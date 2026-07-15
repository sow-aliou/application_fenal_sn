from fastapi import FastAPI

app = FastAPI(
    title="FÉÑAL IA Service",
    description="Service d'Intelligence Artificielle pour l'OCR et le masquage (floutage) d'images.",
    version="1.0.0"
)

@app.get("/")
def read_root():
    return {"message": "Bienvenue sur le service IA de FÉÑAL"}
