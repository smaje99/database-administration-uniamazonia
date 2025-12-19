-- Active: 1657206181542@@127.0.0.1@5432@parqueadero
create database parqueadero;

create table if not exists tipo (
    codigo integer not null,
    tipo varchar(20) not null,
    valor decimal not null,

    constraint pk_tipo primary key (codigo)
);

create table if not exists vehiculo (
    codigo integer not null,
    estado boolean not null default true,
    placa char(6) not null,
    tipo_cod integer not null,

    constraint pk_vehiculo primary key (codigo),
    constraint fk_vehiculo_tipo
        foreign key (tipo_cod)
        references tipo (codigo)
);

create table if not exists moto (
    tiempo smallint not null
) inherits (vehiculo);

create table if not exists camion (
    ejes smallint
) inherits (vehiculo);

create table if not exists tiquete (
    codigo integer not null,
    horas smallint not null,
    fecha date not null default current_date,
    valor decimal,
    vehiculo_cod integer not null,

    constraint pk_tiquete primary key (codigo)
);

alter table tiquete
add constraint fk_tiquete_vehiculo
foreign key (vehiculo_cod)
references vehiculo (codigo);

insert into
    tipo (codigo, tipo, valor)
values
    (1, 'moto', 2000),
    (2, 'camion', 10000),
    (3, 'auto', 6000);

insert into
    moto (codigo, placa, tipo_cod, tiempo)
values (1, 'LXL33F', 1, 4);

select
    tipo.valor
from
    tipo
inner join
    vehiculo
    on vehiculo.tipo_cod = tipo.codigo
where
    vehiculo.codigo = 1;

create or replace function calcular_valor_tiquete()
    returns trigger
    language plpgsql
    as
$$
declare
    valor decimal;
begin

    new.valor = new.vehiculo_id;

    return new;
end
$$;

create or replace trigger t_calcular_valor_tiquete
    before insert
    on tiquete
    for each row
    execute procedure calcular_valor_tiquete();

insert into
    tiquete (codigo, horas, vehiculo_cod)
values (1, 5, 1);


create table if not exists allergy (
    id uuid not null default uuid_generate_v4(),
    name text not null,
    is_active bool not null default true,

    constraint pk_allergy primary key (id)
);

create extension "uuid-ossp";

insert into allergy (name) values ('Mocca');