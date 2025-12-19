from bson.objectid import ObjectId

from database import init_db, get_session
from mongo import init_mongo_migration
from model import Persona, Libro


def main():
    init_db()
    mongo = init_mongo_migration()

    # migration persona table
    with get_session() as session:
        personas = session.query(Persona).all()

        for persona in personas:
            mongo.persona.insert_one({
                'cc_persona': persona.cc_persona,
                'nombre_persona': persona.nombre_persona,
                'apellido_persona': persona.apellido_persona,
                'foto_persona': ObjectId(persona.foto_persona) if persona.foto_persona else None,
            })

    # migration libro table
    with get_session() as session:
        libros = session.query(Libro).all()

        for libro in libros:
            mongo.libro.insert_one({
                '_id': libro.id,
                'titulo': libro.titulo,
                'autor': libro.autor,
                'copias': libro.copias
            })


if __name__ == '__main__':
    main()
