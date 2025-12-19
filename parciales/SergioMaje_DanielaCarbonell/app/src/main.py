from fastapi import Body, FastAPI, File, Path, UploadFile
from fastapi.staticfiles import StaticFiles

from database import init_db
from mongo import init_mongo
from schema import Persona, PersonaCreate
from service import add_persona, add_photo_to_persona


app = FastAPI()



@app.on_event('startup')
def startup():
    init_db()
    init_mongo()


@app.post('/persona', response_model=Persona)
async def create_persona(persona: PersonaCreate = Body()):
    return add_persona(persona)


@app.patch('/upload_photo/{cc_persona}', response_model=Persona)
async def upload_photo(cc_persona: int = Path(), photo: bytes = None):
    # contents = await photo.read()
    # return add_photo_to_persona(cc_persona, contents)
    return {'file_size': len(photo)}


app.mount(
    '/',
    StaticFiles(directory='../public', html=True),
    name='static'
)

