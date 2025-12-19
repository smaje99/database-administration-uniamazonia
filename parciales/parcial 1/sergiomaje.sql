drop database if exists vias;

create database vias;

use vias;

-- creación de tablas
create table if not exists departamento (
    id_departamento integer unsigned not null,
    nombre varchar(50) not null
);

create table if not exists municipio (
    id_municipio integer unsigned not null,
    nombre varchar(50) not null,
    departamento integer unsigned not null
);

create table if not exists zona (
    id_zona integer unsigned not null,
    nombre varchar(50) not null,
    municipio integer unsigned not null
);

create table if not exists obra (
    id_obra integer unsigned not null,
    nombre varchar(50) not null,
    coordenadas varchar(100) not null,
    km_inicio float not null,
    km_fin float not null,
    fecha_inicio date not null,
    fecha_fin date not null,
    costo_total double not null default 0,
    zona integer unsigned not null,
    material integer unsigned not null
);

create table if not exists adicion (
    id_adicion integer unsigned not null,
    valor double not null default 0,
    motivo varchar(255) not null,
    obra integer unsigned not null
);

create table if not exists material (
    id_material integer unsigned not null,
    nombre varchar(50) not null
);

create table if not exists fase (
    id_fase integer unsigned not null,
    nombre varchar(50) not null
);

create table if not exists fase_material (
    id_fase_material integer unsigned not null,
    material integer unsigned not null,
    fase integer unsigned not null
);

create table if not exists registro (
    id_registro integer unsigned not null,
    kms_intervenido float not null default 0,
    fecha timestamp not null default now(),
    obra integer unsigned not null,
    fase integer unsigned not null
);

-- llaves primarias
alter table departamento
add constraint pk_departamento
primary key (id_departamento);

alter table municipio
add constraint pk_municipio
primary key (id_municipio);

alter table zona
add constraint pk_zona
primary key (id_zona);

alter table obra
add constraint pk_obra
primary key (id_obra);

alter table adicion
add constraint pk_adicion
primary key (id_adicion);

alter table material
add constraint pk_material
primary key (id_material);

alter table fase
add constraint pk_fase
primary key (id_fase);

alter table fase_material
add constraint pk_fase_material
primary key (id_fase_material);

alter table registro
add constraint pk_registro
primary key (id_registro);

-- llaves foraneas
alter table municipio
add constraint fk_departamento_municipio
foreign key (departamento)
references departamento(id_departamento);

alter table zona
add constraint fk_municipio_zona
foreign key (municipio)
references municipio(id_municipio);

alter table obra
add constraint fk_zona_obra
foreign key (zona)
references zona(id_zona);

alter table obra
add constraint fk_material_obra
foreign key (material)
references material(id_material);

alter table adicion
add constraint fk_obra_adicion
foreign key (obra)
references obra(id_obra);

alter table fase_material
add constraint fk_material_fase_material
foreign key (material)
references material(id_material);

alter table fase_material
add constraint fk_fase_fase_fase
foreign key (fase)
references fase(id_fase);

alter table registro
add constraint fk_obra_registro
foreign key (obra)
references obra(id_obra);

alter table registro
add constraint fk_fase_registro
foreign key (fase)
references fase_material(id_fase_material);

-- Realizar una alteración de tabla agregando un nuevo atributo
alter table registro
add desarrollo integer unsigned not null
comment 'El dearrollo se mide en porcentaje'
after kms_intervenido;

alter table obra
add activo bool not null default 1
after nombre;

-- Inserción de registros a la base de datos
insert into
    vias.departamento (id_departamento, nombre)
values
    (1, 'Caquetá'),
    (2, 'Huila'),
    (3, 'Cundinamarca');

insert into
    vias.municipio (id_municipio, nombre, departamento)
values
    (1, 'Florencia', 1),
    (2, 'Neiva', 2),
    (3, 'Facatativa', 3);

insert into
    vias.zona (id_zona, nombre, municipio)
values
    (1, 'Troncal del Hacha', 1),
    (2, 'Malecon del Magdalena', 2),
    (3, 'Zona 1', 3);

insert into
    vias.fase (id_fase, nombre)
values
    (1, 'Localización y replanteo'),
    (2, 'Cercamiento'),
    (3, 'Demolición obras existentes'),
    (4, 'Adicionamiento de la superficie'),
    (5, 'Rellenos'),
    (6, 'Excavaciones manuales'),
    (7, 'Acero de refuerzo'),
    (8, 'Concreto hidráulico'),
    (9, 'Concreto ciclópeo'),
    (10, 'Riostras'),
    (11, 'Cunetas'),
    (12, 'Sello de juntas'),
    (13, 'Cajas de recolección'),
    (14, 'Alcantarillas'),
    (15, 'Obra terminada');

insert into
    vias.material (id_material, nombre)
values
    (1, 'Material 1'),
    (2, 'Material 2'),
    (3, 'Material 3');

insert into
    vias.fase_material (id_fase_material, material, fase)
values
    (1, 1, 1),  -- material 1
    (2, 1, 2),
    (3, 1, 3),
    (4, 1, 4),
    (5, 1, 5),
    (6, 1, 6),
    (7, 1, 7),
    (8, 1, 8),
    (9, 1, 9),
    (10, 1, 10),
    (11, 1, 11),
    (12, 1, 12),
    (13, 1, 13),
    (14, 1, 14),
    (15, 1, 15),
    (16, 2, 1),  -- material 2
    (17, 2, 2),
    (18, 2, 3),
    (19, 2, 4),
    (20, 2, 5),
    (21, 2, 6),
    (22, 2, 7),
    (23, 2, 8),
    (24, 2, 9),
    (25, 2, 10),
    (26, 2, 11),
    (27, 2, 12),
    (28, 2, 15),
    (29, 3, 1),  -- material 3
    (30, 3, 2),
    (31, 3, 3),
    (32, 3, 4),
    (33, 3, 5),
    (34, 3, 6),
    (35, 3, 7),
    (38, 3, 10),
    (39, 3, 11),
    (40, 3, 12),
    (41, 3, 13),
    (42, 3, 14),
    (43, 3, 15);

insert into
    vias.obra (
        id_obra,
        nombre,
        coordenadas,
        km_inicio,
        km_fin,
        fecha_inicio,
        fecha_fin,
        costo_total,
        zona,
        material
    )
values
    (1, 'obra 1', '1.09,2.03', 23, 26, '2022-01-15', '2022-01-25', 15647814, 1, 3),
    (2, 'obra 2', '1.09,2.03', 30, 37, '2022-02-03', '2022-03-08', 48647814, 1, 3),
    (3, 'obra 3', '1.09,2.03', 67, 70, '2022-04-08', '2022-04-20', 36647814, 3, 2),
    (4, 'obra 4', '1.09,2.03', 56, 87, '2022-12-15', '2022-12-25', 80647814, 2, 2),
    (5, 'obra 5', '1.09,2.03', 34, 45, '2022-01-15', '2022-01-30', 67647814, 2, 1);

insert into
    vias.adicion (id_adicion, valor, motivo, obra)
values
    (1, 13003098, 'motivo 1', 1),
    (2, 45004056, 'motivo 2', 5),
    (3, 786053, 'motivo 3', 5);

insert into
    vias.registro (id_registro, kms_intervenido, desarrollo, fecha, obra, fase)
values
    (1, 2, 20, '2022-02-01', 5, 2),
    (2, 1, 15, '2022-02-17', 5, 3),
    (3, 3, 78, '2022-03-03', 5, 4);

-- Realizar una alteración de tabla actualizando un registro
update
    vias.zona
set
    nombre = 'Omnicentro'
where
    id_zona = 3 and nombre = 'Zona 1';

update
    vias.obra
set
    fecha_inicio = '2021-11-19'
where
    id_obra = 5;


-- Consultas

-- Total de km intervenidos y costo por municipio
-- (se debe tener en cuenta las adiciones al proyecto)
select
    municipio.nombre as municipio,
    sum(obra.km_fin - obra.km_inicio) as km_intervenidos,
    sum(obra.costo_total + if (adicion.valor is null, 0, adicion.valor)) as costo_total
from
    vias.obra as obra
inner join
    vias.zona as zona
    on obra.zona = zona.id_zona
inner join
    vias.municipio as municipio
    on zona.municipio = municipio.id_municipio
left outer join
    vias.adicion as adicion
    on adicion.obra = obra.id_obra
group by
    municipio.id_municipio
order by
    municipio;

-- correción
select
    municipio.nombre as municipio,
    sum(obra.km_fin - obra.km_inicio) as km_intervenidos,
    sum(obra.costo_total) + if (sum(adicion.valor )is null, 0, sum(adicion.valor)) as costo_total
from
    vias.obra as obra
inner join
    vias.zona as zona
    on obra.zona = zona.id_zona
inner join
    vias.municipio as municipio
    on zona.municipio = municipio.id_municipio
left outer join
    vias.adicion as adicion
    on adicion.obra = obra.id_obra
group by
    municipio.id_municipio
order by
    municipio;

-- Departamento(s) que superan la media en km intervenidos.
select
    departamento.nombre as departamento
from
    vias.departamento
inner join
    vias.municipio as municipio
    on municipio.departamento = departamento.id_departamento
inner join
    vias.zona as zona
    on zona.municipio = municipio.id_municipio
inner join
    vias.obra as obra
    on obra.zona = zona.id_zona
group by
    departamento
having
    avg(obra.km_fin - obra.km_inicio) > (
        select
            avg(obra.km_fin - obra.km_inicio)
        from
            vias.obra as obra
        limit 1
    )
order by
    departamento;

-- Material menos utilizado para el mejoramiento de vías.
select
    material.nombre as material
from
    vias.material as material
inner join
    vias.obra as obra
    on obra.material = material.id_material
group by
    material.nombre
having
    count(obra.material) = (
        select
            count(obra.material) as cantidad
        from
            vias.obra as obra
        group by
            obra.material
        order by
            cantidad asc
        limit
            1
    )
order by
    material;

-- Obras en mora y han tenido como mínimo dos adiciones en su costo y que no estén en el
-- departamento de Cundinamarca, además que la fecha de inicio no incluya el mes de
-- diciembre y enero.
select
    obra.nombre as obra
from
    vias.adicion as adicion
inner join
    vias.obra as obra
    on adicion.obra = obra.id_obra
inner join
    vias.zona as zona
    on obra.zona = zona.id_zona
inner join
    vias.municipio as municipio
    on zona.municipio = municipio.id_municipio
inner join
    vias.departamento as departamento
    on municipio.departamento = departamento.id_departamento
where
    departamento.nombre <> 'Cundinamarca'
    and extract(month from obra.fecha_inicio) not in (1, 12)
    and (now() > obra.fecha_fin and obra.activo = true)
group by
    obra.nombre
having
    count(adicion.obra) >= 2
order by
    obra;

-- Correción
select
    obra.nombre as obra
from
    vias.adicion as adicion
inner join
    vias.obra as obra
    on adicion.obra = obra.id_obra
inner join
    vias.zona as zona
    on obra.zona = zona.id_zona
inner join
    vias.municipio as municipio
    on zona.municipio = municipio.id_municipio
inner join
    vias.departamento as departamento
    on municipio.departamento = departamento.id_departamento
where
    departamento.nombre <> 3
    and extract(month from obra.fecha_inicio) not in (1, 12)
    and (now() > obra.fecha_fin and obra.activo = true)  -- corregir
group by
    obra.nombre
having
    count(adicion.obra) >= 2
order by
    obra;

