from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy import (
    create_engine, Column, Integer, String,
    Float, Boolean, DateTime
)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from datetime import datetime, timedelta
from typing import Optional, List
from pydantic import BaseModel
from jose import jwt, JWTError

# ── Configuration ─────────────────────────────────────────
DATABASE_URL  = "sqlite:///./agivision_cloud.db"
SECRET_KEY    = "agivision-secret-key-change-in-production"
ALGORITHM     = "HS256"
TOKEN_MINUTES = 60 * 24   # 24 hours

# Shared API key — Flutter app uses this to authenticate
# Must match AppConstants.apiKey in Flutter
API_KEY = "agivision-app-key-2025"

# ── Database ──────────────────────────────────────────────
engine       = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False}
)
SessionLocal = sessionmaker(
    autocommit=False, autoflush=False, bind=engine
)
Base         = declarative_base()

# ── SQLAlchemy Models ─────────────────────────────────────
class DiagnosisModel(Base):
    __tablename__ = "diagnoses"

    id          = Column(Integer, primary_key=True,
                         index=True, autoincrement=True)
    local_id    = Column(Integer, nullable=True, index=True)
    device_id   = Column(String,  nullable=True)
    crop        = Column(String,  nullable=False)
    disease     = Column(String,  nullable=False)
    confidence  = Column(Float,   nullable=False)
    is_healthy  = Column(Boolean, default=False)
    location    = Column(String,  nullable=True)
    latitude    = Column(Float,   nullable=True)
    longitude   = Column(Float,   nullable=True)
    synced_at   = Column(DateTime, default=datetime.utcnow)

# ── Pydantic Schemas ──────────────────────────────────────
class LoginRequest(BaseModel):
    api_key: str

class TokenResponse(BaseModel):
    access_token: str
    token_type:   str = "bearer"

class DiagnosisCreate(BaseModel):
    local_id:   Optional[int]   = None
    device_id:  Optional[str]   = None
    crop:       str
    disease:    str
    confidence: float
    is_healthy: bool             = False
    location:   Optional[str]   = None
    latitude:   Optional[float] = None
    longitude:  Optional[float] = None

class DiagnosisResponse(BaseModel):
    id:          int
    local_id:    Optional[int]
    crop:        str
    disease:     str
    confidence:  float
    is_healthy:  bool
    location:    Optional[str]
    latitude:    Optional[float]
    longitude:   Optional[float]
    synced_at:   datetime

    class Config:
        from_attributes = True

class BatchRequest(BaseModel):
    records: List[DiagnosisCreate]

class BatchResult(BaseModel):
    synced:  int
    failed:  int
    records: List[dict]
    errors:  List[dict]

class StatsResponse(BaseModel):
    total_diagnoses:    int
    disease_count:      int
    healthy_count:      int
    average_confidence: float
    disease_breakdown:  dict

# ── Auth helpers ──────────────────────────────────────────
security = HTTPBearer()

def create_access_token(data: dict) -> str:
    payload = data.copy()
    payload["exp"] = (
        datetime.utcnow() +
        timedelta(minutes=TOKEN_MINUTES)
    )
    return jwt.encode(payload, SECRET_KEY,
                      algorithm=ALGORITHM)

def verify_token(
    credentials: HTTPAuthorizationCredentials =
        Depends(security)
) -> dict:
    try:
        payload = jwt.decode(
            credentials.credentials,
            SECRET_KEY,
            algorithms=[ALGORITHM]
        )
        return payload
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )

# ── DB dependency ─────────────────────────────────────────
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ── FastAPI app ───────────────────────────────────────────
app = FastAPI(
    title="AGIVISION Cloud API",
    description=(
        "Backend sync server for the AGIVISION "
        "offline-first crop disease diagnosis app."
    ),
    version="1.0.0"
)

# Allow all origins for development
# Restrict to your Flutter app domain in production
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Create all tables on startup
@app.on_event("startup")
def on_startup():
    Base.metadata.create_all(bind=engine)
    print("╔══════════════════════════════════════╗")
    print("║   AGIVISION Cloud API  v1.0.0        ║")
    print("╠══════════════════════════════════════╣")
    print(f"║  Database : {DATABASE_URL:<24}║")
    print(f"║  API Key  : {API_KEY:<24}║")
    print("║  Docs     : http://localhost:8000/docs║")
    print("╚══════════════════════════════════════╝")

# ══════════════════════════════════════════════════════════
# ENDPOINTS
# ══════════════════════════════════════════════════════════

# ── Health check (no auth required) ──────────────────────
@app.get("/health", tags=["System"])
def health_check():
    return {
        "status":    "online",
        "service":   "AGIVISION Cloud API",
        "timestamp": datetime.utcnow().isoformat()
    }

# ── Auth ──────────────────────────────────────────────────
@app.post(
    "/api/v1/auth/token",
    response_model=TokenResponse,
    tags=["Auth"],
    summary="Exchange API key for JWT access token"
)
def get_token(request: LoginRequest):
    if request.api_key != API_KEY:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid API key"
        )
    token = create_access_token(
        {"sub": "agivision-flutter-app"}
    )
    return TokenResponse(access_token=token)

# ── Single diagnosis sync ──────────────────────────────
@app.post(
    "/api/v1/diagnoses",
    response_model=DiagnosisResponse,
    status_code=201,
    tags=["Diagnoses"],
    summary="Sync a single diagnosis record"
)
def create_diagnosis(
    diagnosis: DiagnosisCreate,
    db:        Session = Depends(get_db),
    _:         dict    = Depends(verify_token)
):
    record = DiagnosisModel(**diagnosis.model_dump())
    db.add(record)
    db.commit()
    db.refresh(record)
    return record

# ── Batch sync (used by SyncEngine) ──────────────────────
@app.post(
    "/api/v1/diagnoses/batch",
    response_model=BatchResult,
    tags=["Diagnoses"],
    summary="Batch sync multiple offline diagnosis records"
)
def batch_sync(
    batch: BatchRequest,
    db:    Session = Depends(get_db),
    _:     dict    = Depends(verify_token)
):
    created = []
    failed  = []

    for item in batch.records:
        try:
            record = DiagnosisModel(**item.model_dump())
            db.add(record)
            db.flush()   # get ID without committing
            created.append({
                "local_id":  item.local_id,
                "cloud_id":  record.id
            })
        except Exception as e:
            db.rollback()
            failed.append({
                "local_id": item.local_id,
                "error":    str(e)
            })

    db.commit()

    return BatchResult(
        synced=len(created),
        failed=len(failed),
        records=created,
        errors=failed
    )

# ── Get all diagnoses ─────────────────────────────────────
@app.get(
    "/api/v1/diagnoses",
    response_model=List[DiagnosisResponse],
    tags=["Diagnoses"],
    summary="List all synced diagnosis records"
)
def list_diagnoses(
    skip:  int     = 0,
    limit: int     = 100,
    db:    Session = Depends(get_db),
    _:     dict    = Depends(verify_token)
):
    return (
        db.query(DiagnosisModel)
          .order_by(DiagnosisModel.synced_at.desc())
          .offset(skip)
          .limit(limit)
          .all()
    )

# ── Statistics ────────────────────────────────────────────
@app.get(
    "/api/v1/stats",
    response_model=StatsResponse,
    tags=["Statistics"],
    summary="Get overall disease statistics"
)
def get_stats(
    db: Session = Depends(get_db),
    _:  dict    = Depends(verify_token)
):
    all_records = db.query(DiagnosisModel).all()

    if not all_records:
        return StatsResponse(
            total_diagnoses=0,
            disease_count=0,
            healthy_count=0,
            average_confidence=0.0,
            disease_breakdown={}
        )

    disease_count  = sum(
        1 for r in all_records if not r.is_healthy)
    healthy_count  = sum(
        1 for r in all_records if r.is_healthy)
    avg_confidence = (
        sum(r.confidence for r in all_records) /
        len(all_records)
    )

    breakdown: dict = {}
    for r in all_records:
        if not r.is_healthy:
            breakdown[r.disease] = (
                breakdown.get(r.disease, 0) + 1
            )

    return StatsResponse(
        total_diagnoses=len(all_records),
        disease_count=disease_count,
        healthy_count=healthy_count,
        average_confidence=round(avg_confidence, 2),
        disease_breakdown=breakdown
    )

# ── Outbreak map data ──────────────────────────────────
@app.get(
    "/api/v1/stats/outbreak",
    tags=["Statistics"],
    summary="Get GPS-tagged disease records for mapping"
)
def get_outbreak_data(
    db: Session = Depends(get_db),
    _:  dict    = Depends(verify_token)
):
    records = (
        db.query(DiagnosisModel)
          .filter(
              DiagnosisModel.latitude.isnot(None),
              DiagnosisModel.longitude.isnot(None),
              DiagnosisModel.is_healthy == False
          )
          .order_by(DiagnosisModel.synced_at.desc())
          .all()
    )

    return {
        "count": len(records),
        "outbreaks": [
            {
                "disease":    r.disease,
                "crop":       r.crop,
                "confidence": r.confidence,
                "latitude":   r.latitude,
                "longitude":  r.longitude,
                "location":   r.location,
                "date":       r.synced_at.isoformat()
            }
            for r in records
        ]
    }