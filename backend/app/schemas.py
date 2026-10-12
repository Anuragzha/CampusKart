from typing import Optional

from pydantic import BaseModel, Field


class GenerateDescriptionRequest(BaseModel):
    item_title: str = Field(min_length=3, max_length=80)
    category: str = Field(min_length=2, max_length=40)
    condition: str = Field(min_length=2, max_length=40)
    price: float = Field(gt=0)
    additional_notes: Optional[str] = Field(default=None, max_length=200)


class GenerateDescriptionResponse(BaseModel):
    enhanced_title: str
    generated_description: str
    suggested_tags: list[str]


class SmartReplyRequest(BaseModel):
    last_message: str = Field(min_length=1, max_length=300)
    item_title: str = Field(min_length=2, max_length=80)
    item_price: float = Field(gt=0)
    is_seller: bool = True


class SmartReplyResponse(BaseModel):
    suggestions: list[str] = Field(min_length=3, max_length=3)
