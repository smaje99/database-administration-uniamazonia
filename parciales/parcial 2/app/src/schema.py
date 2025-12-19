from uuid import UUID

from pydantic import BaseModel


class PersonaCreate(BaseModel):
    cc_persona: int
    nombre_persona: str
    apellido_persona: str


class Persona(PersonaCreate):
    foto_persona: str | UUID | None = None

    class Config:
        orm_mode = True
