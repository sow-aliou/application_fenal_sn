from fastapi import FastAPI
from app.api import document_router

app = FastAPI(
    title="FÉÑAL IA Service",
    description="Service d'Intelligence Artificielle pour l'OCR et le masquage (floutage) d'images.",
    version="1.0.0"
)

# Inclusion du routeur
app.include_router(document_router.router)

@app.get("/")
def read_root():
    return {"message": "Bienvenue sur le service IA de FÉÑAL"}
