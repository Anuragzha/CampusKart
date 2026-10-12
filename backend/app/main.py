import json
import os
from typing import Any

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from groq import AsyncGroq

from .schemas import (
    GenerateDescriptionRequest,
    GenerateDescriptionResponse,
    SmartReplyRequest,
    SmartReplyResponse,
)

# Load environment variables from .env file
load_dotenv()

app = FastAPI(title="CampusKart AI Backend", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=os.getenv("CORS_ORIGINS", "*").split(","),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def get_groq_api_key() -> str | None:
    key = os.getenv("GROQ_API_KEY", "").strip()
    return key if key and key != "your_groq_api_key_here" else None


def groq_client() -> AsyncGroq:
    api_key = get_groq_api_key()
    if not api_key:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="GROQ_API_KEY is not set in backend/.env",
        )
    return AsyncGroq(api_key=api_key)


async def complete_json(system_prompt: str, user_prompt: str) -> dict[str, Any]:
    api_key = get_groq_api_key()
    if not api_key:
        # Fallback response for instant testing without API key
        return {}

    try:
        model_name = os.getenv("GROQ_MODEL", "qwen/qwen3.8-27b")
        response = await groq_client().chat.completions.create(
            model=model_name,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt},
            ],
            temperature=0.3,
            max_tokens=350,
            response_format={"type": "json_object"},
        )
        return json.loads(response.choices[0].message.content or "{}")
    except HTTPException:
        raise
    except Exception as exc:
        # Secure error response — prevents leaking internal server paths or headers
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="AI service request could not be completed. Please verify API quotas.",
        ) from exc


@app.get("/health")
async def health() -> dict[str, Any]:
    has_key = bool(get_groq_api_key())
    return {
        "status": "ok",
        "service": "campuskart-ai",
        "groq_configured": has_key,
        "model": os.getenv("GROQ_MODEL", "llama-3.1-8b-instant"),
    }


@app.post("/api/v1/ai/generate-description", response_model=GenerateDescriptionResponse)
async def generate_description(payload: GenerateDescriptionRequest) -> GenerateDescriptionResponse:
    system_prompt = (
        "You are an expert student marketplace copywriter for a university campus. "
        "Create an enticing, honest, and structured listing description. "
        "Return ONLY JSON with these exact keys: 'enhanced_title', 'generated_description', 'suggested_tags' (list of 3 strings)."
    )
    user_prompt = (
        f"Item: {payload.item_title}; Category: {payload.category}; "
        f"Condition: {payload.condition}; Price: INR {payload.price}; "
        f"Notes: {payload.additional_notes or 'none'}"
    )

    data = await complete_json(system_prompt, user_prompt)
    if data and "enhanced_title" in data:
        return GenerateDescriptionResponse(**data)

    # Smart fallback if GROQ_API_KEY not configured yet
    return GenerateDescriptionResponse(
        enhanced_title=f"{payload.item_title} (Verified Condition)",
        generated_description=(
            f"Genuine {payload.item_title} in {payload.condition} condition. "
            f"Perfect for university students. Asking price ₹{payload.price:,.0f} (open to reasonable campus offers). "
            f"Available for immediate pickup on campus."
        ),
        suggested_tags=[payload.category, payload.condition, "CampusVerified"],
    )


@app.post("/api/v1/ai/smart-replies", response_model=SmartReplyResponse)
async def smart_replies(payload: SmartReplyRequest) -> SmartReplyResponse:
    system_prompt = (
        "You generate exactly three short, polite negotiation replies for a campus marketplace buyer/seller chat. "
        "Keep them brief (under 10 words each). "
        "Return ONLY JSON with a 'suggestions' key containing a list of 3 strings."
    )
    user_prompt = (
        f"Item: {payload.item_title}; Asking price: INR {payload.item_price}; "
        f"Seller speaking: {payload.is_seller}; Last message: '{payload.last_message}'"
    )

    data = await complete_json(system_prompt, user_prompt)
    if data and "suggestions" in data and len(data["suggestions"]) == 3:
        return SmartReplyResponse(**data)

    # Smart fallback suggestions
    if payload.is_seller:
        return SmartReplyResponse(
            suggestions=[
                f"Yes, available for ₹{payload.item_price:,.0f}",
                "Can meet at the library today",
                "Price is firm, sorry!",
            ]
        )
    else:
        return SmartReplyResponse(
            suggestions=[
                f"Can you do ₹{payload.item_price * 0.9:,.0f}?",
                "Is this still available?",
                "Where on campus can we meet?",
            ]
        )
