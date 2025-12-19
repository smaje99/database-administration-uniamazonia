drop database if exists personas;

create database personas;

-- punto 16
create table if not exists personas.persona (
    cc_persona integer unsigned not null,
    nombre_persona text not null,
    apellido_persona text not null,
    foto_persona char(24)
);

alter table personas.persona
add constraint pk_persona
primary key (cc_persona);


-- punto 17
create table if not exists personas.libro (
    id integer unsigned not null,
    titulo text not null,
    autor integer unsigned not null,
    copias integer unsigned not null
);

alter table personas.libro
add constraint pk_libro
primary key (id);

alter table personas.libro
add constraint fk_libro_persona
foreign key (autor) references personas.persona (cc_persona);

insert into
    personas.persona (
        cc_persona,
        nombre_persona,
        apellido_persona
    )
values
    (123456, 'John', 'Doe'),
    (123457, 'Fred', 'Young'),
    (123458, 'Jeff', 'Bever'),
    (123459, 'Walter', 'Smith');

insert into
    personas.libro
values
    (1, 'Amor encolerado', 123456, 10),
    (2, 'Cómo pasar Administración de Bases de Datos', 123458, 1),
    (3, 'Sobreviviendo al semestre', 123459, 5),
    (4, 'Queriendo dormir', 123457, 3),
    (5, 'Música de fondo', 123459, 100),
    (6, 'Tomar anotaciones importantes', 123458, 10);