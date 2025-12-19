const $ = element => document.querySelector(element);

const register = document.forms.register;

register.addEventListener('submit', async (event) => {
    event.preventDefault();

    const persona = {
        cc_persona: parseInt(register.cc_persona.value),
        nombre_persona: register.nombre_persona.value,
        apellido_persona: register.apellido_persona.value,
        foto_persona: register.foto_persona.files[0]
    }

    const personaResponse = await registerPersona(persona);

    const photoResponse = await sendPhoto({
        cc_persona: personaResponse.cc_persona,
        foto_persona: persona.foto_persona
    })

    console.log(photoResponse)

    alert('persona creada')

    register.reset();
})

async function registerPersona({ cc_persona, nombre_persona, apellido_persona }) {
    const response = await fetch('/persona', {
        method: 'POST',
        body: JSON.stringify({ cc_persona, nombre_persona, apellido_persona }),
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        }
    })
    const persona = await response.json();

    return persona;
}

async function sendPhoto({ cc_persona, foto_persona }) {
    const data = new FormData();
    data.append('photo', foto_persona)

    const response = await fetch(`/upload_photo/${cc_persona}`, {
        method: 'PATCH',
        body: { photo: foto_persona }
    })

    const persona = await response.json()

    return persona;
}