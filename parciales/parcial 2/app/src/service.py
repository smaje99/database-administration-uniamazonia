from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from database import get_session
from model import Persona
from schema import PersonaCreate


def add_persona(persona: PersonaCreate) -> Persona:
    obj_in_data = jsonable_encoder(persona)
    db_obj = Persona(**obj_in_data)

    with get_session() as session:
        session.add(db_obj)
        session.commit()
        session.refresh(db_obj)

        return db_obj


def add_photo_to_persona(cc_persona: int, photo) -> Persona:
    with get_session() as session:
        persona = session.get(Persona, cc_persona)

        # add image

        foto_persona = None
        persona.foto_persona = foto_persona

        session.add(persona)
        session.commit()
        session.refresh(persona)

        return persona
