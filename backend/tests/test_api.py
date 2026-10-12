from fastapi.testclient import TestClient

try:
    from backend.app.main import app
except ModuleNotFoundError:
    from app.main import app

client = TestClient(app)


def test_health() -> None:
    response = client.get('/health')
    assert response.status_code == 200
    assert response.json()['status'] == 'ok'


def test_description_validates_input() -> None:
    response = client.post('/api/v1/ai/generate-description', json={'item_title': 'x'})
    assert response.status_code == 422


def test_description_requires_server_configuration() -> None:
    response = client.post('/api/v1/ai/generate-description', json={
        'item_title': 'Engineering Mathematics',
        'category': 'Books',
        'condition': 'Good',
        'price': 250,
    })
    assert response.status_code == 503
