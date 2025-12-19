select
    initcap(
        persona.primer_nombre
        ||' '
        ||persona.segundo_nombre
        ||' '
        ||persona.primer_apellido
        ||' '
        ||persona.segundo_apellido
    ) as nombre,
    persona.numero_documento,
    tipodocumento.nombretipo_documento,
    sexo.nombre_sexo
from
    personal.persona persona
inner join
    personal.tipodocumento tipodocumento
    on persona.idtipo_documento = tipodocumento.idtipo_documento
inner join
    personal.sexo sexo
    on persona.id_sexo = sexo.id_sexo
order by
    nombre asc;


-- ticket de cada cliente con su respectivo barco
select
    initcap(
        persona.primer_nombre
        ||' '
        ||persona.segundo_nombre
        ||' '
        ||persona.primer_apellido
        ||' '
        ||persona.segundo_apellido
    ) as cliente,
    ticket.id_ticket as ticket,
    ticket.puesto_ticket as puesto,
    clasepuesto.nombreclase_puesto as clase,
    barco.nombre_barco
from
    personal.persona persona
inner join
    personal.pasajero pasajero
    on pasajero.id_persona = persona.id_persona
inner join
    tour.ticket ticket
    on ticket.id_pasajero = pasajero.id_pasajero
inner join
    tour.clasepuesto clasepuesto
    on ticket.id_clasepuesto = clasepuesto.id_clasepuesto
inner join
    tour.viaje viaje
    on ticket.id_viaje = viaje.id_viaje
inner join
    transporte.barco barco
    on viaje.id_barco = barco.id_barco
order by
    cliente asc,
    ticket asc;


select distinct
    barco.nombre_barco as barco
from
    tour.ticket ticket
inner join
    tour.viaje viaje
    on ticket.id_viaje = viaje.id_viaje
inner join
    transporte.barco barco
    on viaje.id_barco = barco.id_barco
order by
    barco asc;

-- crear tabla de auditoria para la tabla clase puesto
create table tour.aud_clasepuesto(
    id_clasepuesto number not null,
    nombreclase_puesto varchar(45) not null,
    porcentaje_clase number(19) null,
    usuario varchar(45) not null,
    fecha timestamp default sysdate,
    proceso char(6) not null check(proceso in ('insert', 'update', 'delete'))
);

create or replace trigger tour.trClasePuesto_Aud
    before
        insert or update or delete
        on tour.clasepuesto
    for each row
declare
    l_transaction char(6);
begin
    l_transaction := case
        when INSERTING then 'insert'
        when UPDATING then 'update'
        when DELETING then 'delete'
    end;

    insert into
        tour.aud_clasepuesto
    values
        (
            :new.id_clasepuesto,
            :new.nombreclase_puesto,
            :new.porcentaje_clase,
            user,
            sysdate,
            l_transaction
        );
end;

insert into
    tour.clasepuesto
values
    (6, 'VIP', 10000);


alter table
    tour.ticket
modify
    precio_ticket
    number
    null;


-- Ejercicio del precio
create or replace trigger tour.trPriceTicket
    before insert
    on tour.ticket
    for each row
declare
    price_chair number;
    price_ship number;
begin
    select
        clasepuesto.porcentaje_clase into price_chair
    from
        tour.clasepuesto clasepuesto
    where
        :new.id_clasepuesto = clasepuesto.id_clasepuesto;

    select
        viaje.precio_estandar into price_ship
    from
        tour.viaje viaje
    where
        :new.id_viaje = viaje.id_viaje;

    :new.precio_ticket := price_ship + price_chair;

    insert into
        aud_ticket
    values
        (
            :new.id_ticket,
            :new.precio_ticket,
            :new.puesto_ticket,
            :new.fecha_compra,
            :new.motivo_viaje,
            :new.estado_ticket,
            :new.id_pasajero,
            :new.id_viaje,
            :new.id_clasepuesto,
            :new.id_equipaje,
            user,
            sysdate,
            'insert'
        );
end;

insert into
    tour.ticket (
        id_ticket,
        puesto_ticket,
        fecha_compra,
        estado_ticket,
        id_pasajero,
        id_viaje,
        id_clasepuesto,
        id_equipaje
    )
values
    (7, 5, sysdate, 'activo', 1, 1, 1, 1);

select * from tour.ticket order by id_ticket asc;


-- store procedure insert ticket
create or replace procedure tour.spTicket_Insert (
    id in number,
    puesto in number,
    motivo in varchar,
    estado in varchar,
    pasajero in number,
    viaje in number,
    clasepuesto in number,
    equipaje in number
) as
begin
    insert into
        tour.ticket (
            id_ticket,
            puesto_ticket,
            fecha_compra,
            motivo_viaje,
            estado_ticket,
            id_pasajero,
            id_viaje,
            id_clasepuesto,
            id_equipaje
        )
    values
        (
            id,
            puesto,
            sysdate,
            motivo,
            estado,
            pasajero,
            viaje,
            clasepuesto,
            equipaje
        );
    commit;
end;

call spTicket_Insert(9, 3, 'turismo', 'activo', 3, 2, 6, 1);

create table tour.aud_ticket(
    id_ticket number not null,
    precio_ticket number not null,
    puesto_ticket number not null,
    fecha_compra timestamp not null,
    motivo_viaje varchar(45) not null,
    estado_ticket varchar(45) not null,
    id_pasajero number not null,
    id_viaje number not null,
    id_clasepuesto number not null,
    id_equipaje number not null,
    usuario varchar(45) not null,
    fecha timestamp default sysdate,
    proceso char(6) not null check(proceso in ('insert', 'update', 'delete'))
);

call spTicket_Insert(10, 10, 'negocios', 'activo', 4, 5, 6, 3);


-- hacer una secuencia automática y manual mediante un trigger
create sequence personal.celular_secuencia
    start with 16
    increment by 1
    nomaxvalue
    minvalue 0
    nocycle;

insert into
    personal.celular
values (personal.celular_secuencia.nextval, 3125280239, 1);

create or replace trigger personal.TrSexoSecuencia
    before insert
    on personal.sexo
    for each row
declare
    table_index number;
begin
    select
        max(sexo.id_sexo) into table_index
    from
        personal.sexo sexo;

    :new.id_sexo := table_index + 1;
end;

insert into
    personal.sexo (nombre_sexo)
values ('qwer');


-- si el valor del tiket es mayor a la media se le resta un 10%
-- hacerlo en un bloque anonimo
declare
    cursor tickets_greater_than_avg is
        select
            ticket.id_ticket,
            ticket.precio_ticket
        from
            tour.ticket ticket
        where
            ticket.precio_ticket > (
                select
                    avg(ticket.precio_ticket)
                from
                    tour.ticket ticket
            )
        order by
            ticket.id_ticket asc;
    ticket_row tickets_greater_than_avg%rowtype;
begin
    open tickets_greater_than_avg;

    loop
        fetch tickets_greater_than_avg into ticket_row;
        exit when tickets_greater_than_avg%notfound;

        update
            tour.ticket
        set
            precio_ticket = ticket_row.precio_ticket * 0.9
        where
            id_ticket = ticket_row.id_ticket;
    end loop;

    close tickets_greater_than_avg;
end;