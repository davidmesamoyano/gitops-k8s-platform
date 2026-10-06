"""API de ejemplo para el proyecto GitOps: expone métricas Prometheus y un endpoint que consume CPU
para poder demostrar el autoescalado (HPA)."""
import hashlib
import os
import socket
import time
from contextlib import asynccontextmanager

from fastapi import FastAPI, Query
from prometheus_fastapi_instrumentator import Instrumentator

APP_VERSION = os.getenv("APP_VERSION", "dev")

_ready = {"ok": False}


@asynccontextmanager
async def lifespan(_app: FastAPI):
    _ready["ok"] = True
    yield
    _ready["ok"] = False


app = FastAPI(title="gitops-demo", version=APP_VERSION, lifespan=lifespan)
Instrumentator().instrument(app).expose(app, endpoint="/metrics", include_in_schema=False)


@app.get("/")
def root() -> dict:
    return {"app": "gitops-demo", "version": APP_VERSION, "pod": socket.gethostname(), "mensaje": "Desplegado con GitOps por David"}


@app.get("/healthz")
def healthz() -> dict:
    return {"status": "ok"}


@app.get("/readyz")
def readyz() -> dict:
    return {"ready": _ready["ok"]}


@app.get("/work")
def work(ms: int = Query(100, ge=1, le=2000)) -> dict:
    """Quema CPU durante ~ms milisegundos (para las pruebas de carga)."""
    end = time.perf_counter() + ms / 1000
    h, n = b"seed", 0
    while time.perf_counter() < end:
        h = hashlib.sha256(h).digest()
        n += 1
    return {"pod": socket.gethostname(), "hashes": n}
