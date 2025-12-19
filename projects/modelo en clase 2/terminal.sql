
-- CREAR TABLESPACE

CREATE TABLESPACE tpersonal
DATAFILE 'D:\datos\datapersonal.dbf'
size 250M;

CREATE TABLESPACE ttour
DATAFILE 'D:\datos\datatour.dbf'
size 250M;

CREATE TABLESPACE ttransporte
DATAFILE 'D:\datos\datatransporte.dbf'
size 250M;

-- CREAR TEMPORARY TABLESPACE

CREATE TEMPORARY TABLESPACE temppersonal
TEMPFILE 'D:\datos\tempdatapersonal.dbf'
size 10M;

CREATE TEMPORARY TABLESPACE temptour
TEMPFILE 'D:\datos\tempdatatour.dbf'
size 10M;

CREATE TEMPORARY TABLESPACE temptransporte
TEMPFILE 'D:\datos\tempdatatransporte.dbf'
size 10M;

-- CREATE USER

alter session set "_oracle_script"=true;

CREATE USER personal IDENTIFIED BY Lara13
DEFAULT TABLESPACE tpersonal
TEMPORARY TABLESPACE temppersonal;

CREATE USER tour IDENTIFIED BY Lara13
DEFAULT TABLESPACE ttour
TEMPORARY TABLESPACE temptour;

CREATE USER transporte IDENTIFIED BY Lara13
DEFAULT TABLESPACE ttransporte
TEMPORARY TABLESPACE temptransporte;

-- grant y revoke -> dsl

-- PERMISOS

GRANT create any table,delete any table,alter any table TO tour;

GRANT connect,resource to tour;

GRANT create any table,delete any table,alter any table,connect,resource TO personal;

GRANT create any table,delete any table,alter any table,connect,resource TO transporte;


ALTER USER personal quota unlimited on tpersonal;

ALTER USER tour quota unlimited on ttour;

ALTER USER transporte quota unlimited on ttransporte;

CREATE table personal.persona (
  id_persona NUMBER NOT NULL,
  primer_nombre VARCHAR(45) NOT NULL,
  segundo_nombre VARCHAR(45) DEFAULT NULL,
  primer_apellido VARCHAR(45) NOT NULL,
  segundo_apellido VARCHAR(45) DEFAULT (NULL),
  fecha_nacimiento DATE NOT NULL,
  numero_documento NUMBER(19) NOT NULL,
  correo_persona VARCHAR(45) NOT NULL,
  idtipo_documento NUMBER  NOT NULL,
  id_sexo NUMBER NOT NULL
);

CREATE table personal.usuario (
  id_usuario NUMBER NOT NULL,
  nombre_usuario VARCHAR(45) NOT NULL,
  password_usuario VARCHAR(45) NOT NULL,
  estado_usuario VARCHAR(45) NOT NULL,
  id_persona NUMBER  NOT NULL,
  id_rol NUMBER NOT NULL
 );

CREATE TABLE personal.rol (
  id_rol NUMBER NOT NULL,
  nombre_rol VARCHAR(45) NOT NULL,
  estado_rol VARCHAR(45) NOT NULL
);

CREATE TABLE personal.sexo (
  id_sexo NUMBER NOT NULL,
  nombre_sexo VARCHAR(45) NOT NULL
);

CREATE TABLE personal.tipodocumento (
  idtipo_documento NUMBER  NOT NULL,
  nombretipo_documento VARCHAR(45) NOT NULL
);


CREATE table personal.celular (
  id_celular NUMBER  NOT NULL,
  numero_celular NUMBER(19)  NOT NULL,
  id_persona NUMBER  NOT NULL
);

create TABLE personal.idioma_persona (
  id_idioma NUMBER  NOT NULL,
  id_persona NUMBER  NOT NULL,
  nivelidioma_persona VARCHAR(45) NOT NULL
);
   
CREATE TABLE personal.idioma (
  id_idioma NUMBER  NOT NULL,
  nombre_idioma VARCHAR(45) NOT NULL
);


CREATE TABLE personal.capitan (
  id_capitan NUMBER  NOT NULL,
  horasviaje_capitan NUMBER  NOT NULL,
  estado_capitan VARCHAR(45) NOT NULL,
  id_persona NUMBER  NOT NULL
 );

CREATE TABLE personal.oficial (
  id_oficial NUMBER  NOT NULL,
  experiencia_oficial NUMBER  NOT NULL,
  estado_oficial VARCHAR(45) NOT NULL,
  id_persona NUMBER  NOT NULL
);

CREATE TABLE personal.pasajero (
  id_pasajero NUMBER  NOT NULL,
  estado_pasajero VARCHAR(45) NOT NULL,
  id_persona NUMBER  NOT NULL
 );

-- TOUR

CREATE table tour.viaje (
  id_viaje NUMBER  NOT NULL,
  origen_viaje VARCHAR(45) NOT NULL,
  destino_viaje VARCHAR(45) NOT NULL,
  fechasalida_viaje TIMESTAMP NOT NULL,
  fechallegada_viaje TIMESTAMP NOT NULL,
  precio_estandar NUMBER(19) DEFAULT NULL,
  estado_viaje VARCHAR(45) NOT NULL,
  id_barco NUMBER  NOT NULL
);

CREATE table tour.bitacora (
  id_bitacora NUMBER  NOT NULL,
  id_viaje NUMBER  NOT NULL,
  id_capitan NUMBER  NOT NULL,
  novedadesviaje_capitan VARCHAR(45) DEFAULT NULL
 );
 
CREATE TABLE tour.viaje_oficial (
  id_viaje NUMBER  NOT NULL,
  id_oficial NUMBER  NOT NULL,
  novedadesviaje_oficial VARCHAR(45) DEFAULT NULL
);
 
CREATE TABLE tour.ticket (
  id_ticket NUMBER  NOT NULL,
  precio_ticket NUMBER,
  puesto_ticket NUMBER  NOT NULL,
  fecha_compra TIMESTAMP NOT NULL,
  motivo_viaje VARCHAR(45) DEFAULT NULL,
  estado_ticket VARCHAR(45) NOT NULL,
  id_pasajero NUMBER  NOT NULL,
  id_viaje NUMBER  NOT NULL,
  id_clasepuesto NUMBER  NOT NULL,
  id_equipaje NUMBER  NOT NULL
);

CREATE table tour.clasepuesto (
  id_clasepuesto NUMBER  NOT NULL,
  nombreclase_puesto VARCHAR(45) NOT NULL,
  porcentaje_clase NUMBER(19) DEFAULT NULL
);

CREATE TABLE tour.equipaje (
  id_equipaje NUMBER  NOT NULL,
  peso_equipaje NUMBER  NOT NULL,
  id_categoria NUMBER  NOT NULL
);

CREATE TABLE tour.categoria (
  id_categoria NUMBER  NOT NULL,
  nombre_categoria VARCHAR(45) NOT NULL
);

-- TRANSPORTE

CREATE table transporte.barco (
  id_barco NUMBER  NOT NULL,
  nombre_barco VARCHAR(45) NOT NULL,
  numpuesto_barco NUMBER  NOT NULL,
  numero_habitacion NUMBER DEFAULT NULL,
  idempresa_maritima NUMBER  NOT NULL,
  idtipo_barco NUMBER NOT NULL
);

CREATE TABLE transporte.tipo_barco (
  idtipo_barco NUMBER NOT NULL,
  nombretipo_barco VARCHAR(45) NOT NULL
);

CREATE table transporte.empresa_maritima (
  idempresa_maritima NUMBER  NOT NULL,
  seccional_terminal VARCHAR(45) NOT NULL,
  numlocal_terminalempresa NUMBER DEFAULT NULL,
  numangar_terminalempresa NUMBER DEFAULT NULL,
  idterminal_maritima NUMBER  NOT NULL,
  id_empresa NUMBER NOT NULL
 );

CREATE TABLE transporte.empresa (
  id_empresa NUMBER NOT NULL,
  nombre_empresa VARCHAR(45) NOT NULL,
  nit_empresa VARCHAR(45) DEFAULT NULL,
  direccion_empresa VARCHAR(45) DEFAULT NULL,
  estado_empresa VARCHAR(45) NOT NULL
);

CREATE TABLE transporte.terminal_maritima (
  idterminal_maritima NUMBER  NOT NULL,
  nombre_terminal VARCHAR(45) NOT NULL,
  estado_terminal VARCHAR(45) NOT NULL,
  id_ubicacion NUMBER  NOT NULL
);

CREATE TABLE transporte.ubicacion (
  id_ubicacion NUMBER  NOT NULL,
  nombre_ubicacion VARCHAR(45) NOT NULL
);

grant references on personal.persona to tour;
grant references on personal.usuario to tour;
grant references on personal.rol to tour;
grant references on personal.sexo to tour;
grant references on personal.tipodocumento to tour;
grant references on personal.celular to tour;
grant references on personal.idioma_persona to tour;
grant references on personal.idioma to tour;
grant references on personal.capitan to tour;
grant references on personal.oficial to tour;
grant references on personal.pasajero to tour;

grant references on personal.persona to transporte;
grant references on personal.usuario to transporte;
grant references on personal.rol to transporte;
grant references on personal.sexo to transporte;
grant references on personal.tipodocumento to transporte;
grant references on personal.celular to transporte;
grant references on personal.idioma_persona to transporte;
grant references on personal.idioma to transporte;
grant references on personal.capitan to transporte;
grant references on personal.oficial to transporte;
grant references on personal.pasajero to transporte;

grant references,select on tour.viaje to personal;
grant references,select on tour.bitacora to personal;
grant references,select on tour.viaje_oficial to personal;
grant references,select on tour.ticket to personal;
grant references,select on tour.clasepuesto to personal;
grant references,select on tour.equipaje to personal;
grant references,select on tour.categoria to personal;

grant references,select on transporte.barco to personal;
grant references,select on transporte.tipo_barco to personal;
grant references,select on transporte.empresa_maritima to personal;
grant references,select on transporte.empresa to personal;
grant references,select on transporte.terminal_maritima to personal;
grant references,select on transporte.ubicacion to personal;


grant references,select on tour.viaje to transporte;
grant references,select on tour.bitacora to transporte;
grant references,select on tour.viaje_oficial to transporte;
grant references,select on tour.ticket to transporte;
grant references,select on tour.clasepuesto to transporte;
grant references,select on tour.equipaje to transporte;
grant references,select on tour.categoria to transporte;

grant references,select on transporte.barco to tour;
grant references,select on transporte.tipo_barco to tour;
grant references,select on transporte.empresa_maritima to tour;
grant references,select on transporte.empresa to tour;
grant references,select on transporte.terminal_maritima to tour;
grant references,select on transporte.ubicacion to tour;

-- llaves primaria

ALTER TABLE personal.persona ADD CONSTRAINT pk_id_persona PRIMARY KEY (id_persona);

ALTER TABLE personal.usuario ADD constraint pk_id_usuario PRIMARY KEY (id_usuario);

ALTER TABLE personal.rol ADD constraint pk_id_rol PRIMARY KEY (id_rol);

ALTER TABLE personal.sexo ADD constraint pk_id_sexo PRIMARY KEY (id_sexo);
    
ALTER TABLE personal.tipodocumento ADD CONSTRAINT pk_idtipo_documento PRIMARY KEY (idtipo_documento);
    
ALTER TABLE personal.celular ADD constraint pk_id_celular PRIMARY KEY (id_celular);
   
ALTER TABLE personal.idioma_persona ADD CONSTRAINT pk_id_idioma_id_persona PRIMARY KEY (id_idioma,id_persona);

ALTER TABLE personal.idioma ADD constraint pk_id_idioma PRIMARY KEY (id_idioma);
  
ALTER TABLE personal.capitan ADD constraint pk_id_capitan PRIMARY KEY (id_capitan);
  
ALTER TABLE personal.oficial ADD constraint pk_id_oficial PRIMARY KEY (id_oficial);

ALTER TABLE personal.pasajero ADD constraint pk_id_pasajero PRIMARY KEY (id_pasajero);

-- TOUR
   
ALTER TABLE tour.viaje ADD CONSTRAINT pk_id_viaje PRIMARY KEY (id_viaje);
  
ALTER TABLE tour.bitacora ADD constraint pk_id_bitacora PRIMARY KEY (id_bitacora,id_viaje,id_capitan);
  
ALTER TABLE tour.viaje_oficial ADD constraint pk_id_viaje_id_oficial PRIMARY KEY (id_viaje,id_oficial);
 
ALTER TABLE tour.ticket ADD CONSTRAINT pk_id_ticket PRIMARY KEY (id_ticket);

ALTER TABLE tour.clasepuesto ADD constraint pk_id_clasepuesto PRIMARY KEY (id_clasepuesto);
 
ALTER TABLE tour.equipaje ADD constraint pk_id_equipaje PRIMARY KEY (id_equipaje);

ALTER TABLE tour.categoria ADD constraint pk_id_categoria PRIMARY KEY (id_categoria);

-- TRANSPORTE

ALTER TABLE transporte.barco ADD constraint pk_id_barco PRIMARY KEY (id_barco);

ALTER TABLE transporte.tipo_barco ADD constraint pk_idtipo_barco PRIMARY KEY (idtipo_barco);
  
ALTER TABLE transporte.empresa_maritima ADD constraint pk_idempresa_maritima PRIMARY KEY (idempresa_maritima);
  
ALTER TABLE transporte.empresa ADD constraint pk_id_empresa PRIMARY KEY (id_empresa);

ALTER TABLE transporte.terminal_maritima ADD constraint pk_idterminal_maritima PRIMARY KEY (idterminal_maritima);

ALTER TABLE transporte.ubicacion ADD constraint pk_id_ubicacion PRIMARY KEY (id_ubicacion);
 
-- llaves foraneas

ALTER TABLE personal.persona ADD constraint fk_persona_sexo
    FOREIGN KEY (id_sexo)
    REFERENCES personal.sexo (id_sexo);
   
ALTER TABLE personal.persona ADD constraint fk_tipodocumento_persona
    FOREIGN KEY (idtipo_documento)
    REFERENCES personal.tipodocumento (idtipo_documento);
   
ALTER TABLE personal.celular ADD constraint fk_persona_celular
    FOREIGN KEY (id_persona)
    REFERENCES personal.persona (id_persona);
     
ALTER TABLE personal.capitan ADD constraint fk_persona_capitan
    FOREIGN KEY (id_persona)
    REFERENCES personal.persona (id_persona);
    
ALTER TABLE personal.oficial ADD constraint fk_persona_azafata
    FOREIGN KEY (id_persona)
    REFERENCES personal.persona (id_persona);
   
ALTER TABLE personal.pasajero ADD constraint fk_persona_pasajero
    FOREIGN KEY (id_persona)
    REFERENCES personal.persona (id_persona);
    
ALTER TABLE personal.usuario ADD constraint fk_usuario_persona
    FOREIGN KEY (id_persona)
    REFERENCES personal.persona (id_persona);
   
ALTER TABLE personal.usuario add constraint fk_usuario_rol
    FOREIGN KEY (id_rol)
    REFERENCES personal.rol (id_rol);
   
ALTER TABLE personal.idioma_persona ADD constraint fk_idioma_has_persona_idioma
    FOREIGN KEY (id_idioma)
    REFERENCES personal.idioma (id_idioma);
   
ALTER TABLE personal.idioma_persona ADD constraint fk_idioma_has_persona_persona
    FOREIGN KEY (id_persona)
    REFERENCES personal.persona (id_persona);
   
-- TOUR
   
ALTER TABLE tour.viaje ADD constraint fk_barco_viaje
    FOREIGN KEY (id_barco)
    REFERENCES transporte.barco(id_barco);
 
ALTER TABLE tour.bitacora ADD constraint fk_capitan_bitacora
    FOREIGN KEY (id_capitan)
    REFERENCES personal.capitan (id_capitan);
 
ALTER TABLE tour.bitacora ADD constraint fk_viaje_bitacora
    FOREIGN KEY (id_viaje)
    REFERENCES tour.viaje (id_viaje);

ALTER TABLE tour.viaje_oficial ADD constraint fk_oficial_viaje
    FOREIGN KEY (id_oficial)
    REFERENCES personal.oficial (id_oficial);
   
ALTER TABLE tour.viaje_oficial ADD constraint fk_viaje_oficial
    FOREIGN KEY (id_viaje)
    REFERENCES tour.viaje (id_viaje);

ALTER TABLE tour.ticket ADD constraint fk_clasepuesto_ticket
    FOREIGN KEY (id_clasepuesto)
    REFERENCES tour.clasepuesto (id_clasepuesto);

ALTER TABLE tour.ticket ADD constraint fk_pasajero_ticket
    FOREIGN KEY (id_pasajero)
    REFERENCES personal.pasajero (id_pasajero);
   
ALTER TABLE tour.ticket ADD constraint fk_vuelo_ticket
    FOREIGN KEY (id_viaje)
    REFERENCES tour.viaje (id_viaje);
   
ALTER TABLE tour.ticket ADD constraint fk_ticket_equipaje
    FOREIGN KEY (id_equipaje)
    REFERENCES tour.equipaje (id_equipaje);
       
ALTER TABLE tour.equipaje ADD constraint fk_categoria_equipaje
    FOREIGN KEY (id_categoria)
    REFERENCES tour.categoria (id_categoria);
   
-- TRANSPORTE
   
ALTER TABLE transporte.barco ADD constraint fk_barco_empresa_maritima
    FOREIGN KEY (idempresa_maritima)
    REFERENCES transporte.empresa_maritima (idempresa_maritima);

ALTER TABLE transporte.barco ADD constraint fk_barco_tipo_barco
    FOREIGN KEY (idtipo_barco)
    REFERENCES transporte.tipo_barco (idtipo_barco);

 ALTER TABLE transporte.terminal_maritima ADD constraint fk_ubicacion
    FOREIGN KEY (id_ubicacion)
    REFERENCES transporte.ubicacion (id_ubicacion);
   
  
  ALTER TABLE transporte.empresa_maritima ADD constraint fk_empresa_maritima_empresa
    FOREIGN KEY (id_empresa)
    REFERENCES transporte.empresa (id_empresa);
   
ALTER TABLE transporte.empresa_maritima ADD constraint fk_empresa_maritima_terminal_maritima
    FOREIGN KEY (idterminal_maritima)
    REFERENCES transporte.terminal_maritima (idterminal_maritima);
   
   
SELECT p.ID_PERSONA ,CONCAT(p.PRIMER_NOMBRE,p.SEGUNDO_NOMBRE) ,c.ID_CAPITAN 
FROM PERSONAL.PERSONA p
INNER JOIN PERSONAL.CAPITAN c 
on(c.ID_PERSONA=p.ID_PERSONA);
    

select username, account_status, default_tablespace, temporary_tablespace
   from dba_users
   where username='ADMINDB';
  
 -- insert personal
  
insert all
into personal.tipodocumento  values (1, 'cedula de ciudadania')
into personal.tipodocumento  values (2, 'tarjeta de identidad')
into personal.tipodocumento  values (3, 'cedula de extranjeria')
into personal.tipodocumento  values (4, 'pasaporte')
select * from dual;

insert all 
into personal.idioma values (1, 'ingles')
into personal.idioma values (2, 'español')
into personal.idioma values (3, 'italiano')
into personal.idioma values (4, 'frances')
into personal.idioma values (5, 'ruso')
into personal.idioma values (6, 'japones')
into personal.idioma values (7, 'chino')
into personal.idioma values (8, 'aleman')
select *from dual; 

insert all
into personal.sexo values (1, 'masculino')
into personal.sexo values (2, 'femenino')
into personal.sexo values (3, 'homosexual')
into personal.sexo values (4, 'transexual')
select * from dual;

insert all
into personal.rol values (1, 'administrador','activo')
into personal.rol values (2, 'empleado','inactivo')
into personal.rol values (3, 'invitado','activo')
select * from dual;

insert all 
into personal.persona values (1,'juliana','fernanda','rodriguez','morales',timestamp'2002-05-13 00:00:00.0',1006507063,'jf@gmail.com',1,2)
into personal.persona values (2,'laura',null,'morales','rojas',timestamp'2000-02-22 00:00:00.0',1001507062,'lm@gmail.com',1,2)
into personal.persona values (3,'carlos','vicente','martinez',null,timestamp'1990-08-11 00:00:00.0',26551337,'cm@gmail.com',3,1)
into personal.persona values (4,'juan',null,'charrasqueado',null,timestamp'1980-03-23 00:00:00.0',17894561,'jc@gmail.com',3,1)
into personal.persona values (5,'maria','jesus','isaza','cabrera',timestamp'2006-09-06 00:00:00.0',1006537066,'mi@gmail.com',2,2)
into personal.persona values (6,'sara','valentina','guerrero',null,timestamp'2009-12-17 00:00:00.0',1001527369,'sg@gmail.com',2,2)
into personal.persona values (7,'luis','carlos','ruiz',null,timestamp'2001-01-03 00:00:00.0',34543234,'lr@gmail.com',4,1)
into personal.persona values (8,'jose','alfredo','jimenez',null,timestamp'1970-01-01 00:00:00.0',12456789,'jj@gmail.com',4,1)
into personal.persona values (9,'andrea',null,'rosales',null,timestamp'2000-06-09 00:00:00.0',1004607894,'ar@gmail.com',1,2)
into personal.persona values (10,'angie','vanesa','vargas','diaz',timestamp'2002-05-13 00:00:00.0',1006577066,'av@gmail.com',2,2)
select *from dual;

insert all 	  
into personal.celular values (1, 58441437850, 1)
into personal.celular values (2, 26522627601, 1)
into personal.celular values (3, 45096864127, 2)
into personal.celular values (4, 11141404463, 2)
into personal.celular values (5, 29310549633, 3)
into personal.celular values (6, 38485270201, 3)
into personal.celular values (7, 29636235929, 4)
into personal.celular values (8, 62041678874, 4)
into personal.celular values (9, 68057351636, 5)
into personal.celular values (10, 78112468812, 5)
into personal.celular values (11, 72071598715, 6)
into personal.celular values (12, 80177394774, 6)
into personal.celular values (13, 41596218488, 7)
into personal.celular values (14, 50433356329, 8)
into personal.celular values (15, 98491331882, 9)
into personal.celular values (16, 97404620027, 10)
select *from dual;

insert all 	 
into personal.usuario  values (1,'jf@gmail.com','juilana1234','activo',1,1)
into personal.usuario  values (2,'lm@gmail.com','laura1234','inactivo',2,2)
into personal.usuario  values (3,'cm@gmail.com','carlos1234','activo',3,3)
into personal.usuario  values (4,'jc@gmail.com','juan1234','inactivo',4,1)
select *from dual;

insert all 	 
into personal.capitan  values (1,45,'activo',5)
into personal.capitan  values (2,80,'inactivo',6)
into personal.capitan  values (3,90,'activo',7)
into personal.capitan  values (4,70,'inactivo',8)
select *from dual;

insert all 	 
into personal.oficial values (1,35,'activo',9)
into personal.oficial values (2,70,'inactivo',10)
into personal.oficial values (3,60,'activo',1)
into personal.oficial values (4,90,'inactivo',2)
select *from dual;
  
insert all 	 
into personal.pasajero values (1,'activo',3)
into personal.pasajero values (2,'inactivo',4)
into personal.pasajero values (3,'activo',5)
into personal.pasajero values (4,'inactivo',6)
select *from dual;
  

insert all 
into personal.idioma_persona values(5, 1, 'alto')
into personal.idioma_persona values(5, 2, 'alto')
into personal.idioma_persona values(4, 5, 'basico')
into personal.idioma_persona values(4, 6, 'alto')
into personal.idioma_persona values(3, 8, 'basico')
into personal.idioma_persona values(3, 4, 'basico')
into personal.idioma_persona values(2, 3, 'intermedio')
into personal.idioma_persona values(2, 2, 'alto')
into personal.idioma_persona values(1, 1, 'intermedio')
into personal.idioma_persona values(1, 7, 'basico')
select *from dual;

-- insert transporte

insert all 
into transporte.ubicacion values (1, 'colombia')
into transporte.ubicacion values(2, 'españa')
into transporte.ubicacion values(3, 'mexico')
into transporte.ubicacion values(4, 'rusia')
into transporte.ubicacion values(5, 'estados unidos')
into transporte.ubicacion values(6, 'francia')
select *from dual;

insert all 
into transporte.terminal_maritima values (1, 'puerto shanghai','activo',1)
into transporte.terminal_maritima values (2, 'puerto singapur','inactivo',2)
into transporte.terminal_maritima values (3, 'puerto busan','activo',3)
into transporte.terminal_maritima values (4, 'puerto holanda','inactivo',4)
into transporte.terminal_maritima values (5, 'puerto colombia','activo',4)
into transporte.terminal_maritima values (6, 'puerto francia','inactivo',1)
select *from dual;


insert all 
into transporte.empresa values (1, 'silversea','123','italia','activo')
into transporte.empresa values (2, 'crystal cruises','124',null,'inactivo')
into transporte.empresa values (3, 'politours','132',null,'activo')
into transporte.empresa values (4, 'celestyal cruises','456','irlanda','inactivo')
into transporte.empresa values (5, 'holland america',null,null,'activo')
into transporte.empresa values (6, 'panavision','678','estados unidos','inactivo')
select *from dual;

insert all 
into transporte.empresa_maritima values (1, '1',2,160,1,2)
into transporte.empresa_maritima values (2, '2',4,78,2,3)
into transporte.empresa_maritima values (3, '3',6,77,4,5)
into transporte.empresa_maritima values (4, '4',8,130,1,1)
into transporte.empresa_maritima values (5, '5',5,45,2,1)
into transporte.empresa_maritima values (6, '6',67,3,2,4)
select *from dual;

insert all 
into transporte.tipo_barco values (1, 'crucero de lujo')
into transporte.tipo_barco values (2, 'crucero de aventura')
into transporte.tipo_barco values (3, 'crucero expedicionario')
into transporte.tipo_barco values (4, 'crucero fluvial')
into transporte.tipo_barco values (5, 'crucero oceánico')
into transporte.tipo_barco values (6, 'crucero convencional')
select *from dual;

insert all 
into transporte.barco values (1, 'carabela', 4500,10000,1,2)
into transporte.barco values (2, 'titanic', 3000,6000,2,3)
into transporte.barco values (3, 'galeón', 5500,10500,3,4)
into transporte.barco values (4, 'navío', 2000,4000,5,1)
into transporte.barco values (5, 'goleta', 5000,10000,4,1)
into transporte.barco values (6, 'corbeta', 3200,6400,4,5)
into transporte.barco values (7, 'fragata', 2500,5000,1,1)
select *from dual;

-- insert tour 

insert all 
into tour.categoria values (1, 'bodega')
into tour.categoria values (2, 'expecial')
into tour.categoria values (3, 'de mano')
select *from dual;

insert all 
into tour.equipaje values (1, 12, 1)
into tour.equipaje values (2, 4, 2)
into tour.equipaje values (3, 56, 3)
into tour.equipaje values (4, 20, 3)
into tour.equipaje values (5, 2, 2)
into tour.equipaje values (6, 6, 1)
select *from dual;

insert all 
into tour.viaje values(1, 'colombia', 'mexico',timestamp'2022-11-27 01:30:00', timestamp'2022-12-27 04:00:00',4000000,'activo',1)
into tour.viaje values(2, 'francia', 'estados unidos', timestamp'2022-10-02 04:30:00', timestamp'2022-11-02 06:25:00',6000000,'inactivo', 2)
into tour.viaje values(3, 'españa', 'rusia', timestamp'2022-05-07 00:30:00', timestamp'2022-05-07 04:00:00',5000000, 'activo',3)
into tour.viaje values(4, 'colombia', 'alemania', timestamp'2022-04-07 00:30:00', timestamp'2022-04-07 06:00:00',2000000,'inactivo', 3)
into tour.viaje values(5, 'italia', 'mexico', timestamp'2022-03-08 00:30:00', timestamp'2022-03-09 05:00:00',3000000,'activo', 1)
into tour.viaje values(7, 'estados unidos', 'rusia', timestamp'2022-06-07 00:30:00', timestamp'2022-08-07 07:10:00',3500000,'inactivo', 4)
into tour.viaje values(8, 'italia', 'alemania', timestamp'2022-09-01 00:30:00', timestamp'2022-10-11 04:12:00',3600000,'activo', 5)
select *from dual;


insert all 
into tour.clasepuesto values (1, 'turista',5000)
into tour.clasepuesto values (2, 'ejecutiva',6000)
into tour.clasepuesto values (3, 'primera',8000)
into tour.clasepuesto values (4, 'pobre',1000)
into tour.clasepuesto values (5, 'vagabundo',500)
select *from dual;

insert all 
into tour.ticket values (1, 50000, 14,timestamp'2022-01-27 03:10:00','turismo','activo', 1, 1, 5,1)
into tour.ticket values(2, 40000, 12,timestamp'2022-01-13 01:20:00','negocios','inactivo',2,2, 4,2)
into tour.ticket values(3, 34567, 4,timestamp'2022-02-22 02:50:00' ,'estudios','activo',4,3, 3,4)
into tour.ticket values(4, 45465, 6,timestamp'2022-03-11 05:30:00','placer', 'inactivo',3, 4, 2,3)
into tour.ticket values(5, 566456, 7,timestamp'2022-02-02 06:40:00','salud','activo',2, 5, 1,1)
into tour.ticket values(6, 10000, 9,timestamp'2022-01-23 07:30:00','deporte','inactivo',1, 1, 5,2)
select * from dual;

insert all 
into tour.viaje_oficial values(5, 1, null)
into tour.viaje_oficial values(4, 2, null)
into tour.viaje_oficial values(3, 3, null)
into tour.viaje_oficial values(2, 4, null)
into tour.viaje_oficial values(1, 3, null)
select *from dual;

insert all 
into tour.bitacora values(1,5, 1, null)
into tour.bitacora values(2,4, 2, null)
into tour.bitacora values(3,3, 3, null)
into tour.bitacora values(4,2, 4, null)
into tour.bitacora values(5,1, 3, null)
select *from dual;
