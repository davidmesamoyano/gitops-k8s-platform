from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_root():
    r = client.get("/")
    assert r.status_code == 200
    assert r.json()["app"] == "gitops-demo"


def test_health():
    assert client.get("/healthz").json() == {"status": "ok"}


def test_work():
    r = client.get("/work?ms=10")
    assert r.status_code == 200 and r.json()["hashes"] > 0


def test_metrics():
    client.get("/")
    r = client.get("/metrics")
    assert r.status_code == 200 and "http_requests_total" in r.text
