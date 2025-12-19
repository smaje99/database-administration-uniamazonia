create database if not exists salsamentaria;

use salsamentaria;

create table if not exists PERSONA (
    id_persona integer unsigned not null,
    nombres_persona varchar(45) not null,
    apellido_persona varchar(45) not null,
    numero_identificacion varchar(13) not null,
    email_persona varchar(45) not null,
    id_sexo integer unsigned not null,
    id_identificacion integer unsigned not null
);

create table if not exists SEXO (
    id_sexo integer unsigned not null,
    nombre_sexo varchar(45) unique not null
);

create table if not exists TIPO_IDENTIFICACION (
    id_identificacion integer unsigned not null,
    nombre_identificacion varchar(45) unique not null,
    estado_identificacion enum('A', 'I') not null
);

create table if not exists TELEFONO_PERSONA (
    id_telefono integer unsigned not null,
    numero_telefono varchar(13) not null,
    estado_telefono tinyint(1) not null default 1,
    id_persona integer unsigned not null
);

create table if not exists CLIENTE (
    id_cliente integer unsigned not null,
    razon_social varchar(45) not null,
    estado_cliente tinyint(1) not null default 1,
    id_persona integer unsigned not null,
    id_tipo_cliente integer unsigned not null
);

create table if not exists TIPO_CLIENTE (
    id_tipo_cliente integer unsigned not null,
    tipo_cliente varchar(45) unique not null
);

create table if not exists USUARIO (
    id_usuario integer unsigned not null,
    nombre_usuario varchar(45) unique not null,
    contrasena_usuario varchar(45) not null,
    estado_usuario tinyint(1) not null default 1,
    id_persona integer unsigned not null,
    id_rol integer unsigned not null
);

create table if not exists ROL (
    id_rol integer unsigned not null,
    nombre_rol varchar(45),
    estado_rol tinyint(1) not null default 1
);

create table if not exists PROVEEDOR (
    id_proveedor integer unsigned not null,
    razon_social varchar(45) not null,
    estado_proveedor tinyint(1) not null default 1,
    id_persona integer unsigned not null
);

create table if not exists COMPRA (
    id_compra integer unsigned not null,
    valor_total_compra double unsigned not null,
    fecha_compra datetime not null default now(),
    subtotal_compra double unsigned not null,
    total_iva_compra double unsigned not null,
    id_proveedor integer unsigned not null
);

create table if not exists VENTA (
    id_venta integer unsigned not null,
    valor_total_venta double unsigned not null default 0,
    fecha_venta datetime not null default now(),
    total_iva double unsigned not null default 0,
    saldo_venta double unsigned not null default 0,
    total_descuento double unsigned not null default 0,
    id_usuario integer unsigned not null,
    id_forma_pago integer unsigned not null,
    id_cliente integer unsigned not null
);

create table if not exists FORMA_PAGO (
    id_forma_pago integer unsigned not null,
    forma_pago varchar(45) unique not null,
    estado_forma_pago enum('A', 'I') not null
);

create table if not exists CREDITO (
    id_credito integer unsigned not null,
    saldo_credito double not null default 0,
    total_abono double not null default 0,
    estado_credito enum('A', 'I') not null,
    id_venta integer unsigned not null
);

create table if not exists ABONO (
    id_abono integer unsigned not null,
    valor_abono double not null default 0,
    fecha_abono datetime not null default now(),
    id_credito integer unsigned not null
);

create table if not exists MARCA_PRODUCTO (
    id_marca integer unsigned not null,
    nombre_marca varchar(45) unique not null,
    estado_marca enum('A', 'I') not null
);

create table if not exists UNIDAD_MEDIDA_PRODUCTO (
    id_unidad_medida integer unsigned not null,
    nombre_unidad_medida varchar(45) unique not null,
    siglas_unidad_medida varchar(5) not null,
    estado_unidad_medida enum('A', 'I') not null
);

create table if not exists CATEGORIA_PRODUCTO (
    id_categoria integer unsigned not null,
    nombre_categoria varchar(50) unique not null,
    estado_categoria enum('A', 'I') not null default 'A'
);

create table if not exists TIPO_PRODUCTO (
    id_tipo_producto integer unsigned not null,
    tipo_producto varchar(45) not null,
    estado_tipo_producto enum('A', 'I') not null default 'A'
);

create table if not exists PRODUCTO (
    id_producto integer unsigned not null,
    precio_producto double not null default 0,
    descripcion_producto varchar(45) not null,
    cantidad_producto integer unsigned not null default 0,
    estado_producto enum('A', 'I') not null default 'A',
    id_marca integer unsigned not null,
    id_unidad_medida integer unsigned not null,
    id_categoria integer unsigned not null,
    id_tipo_producto integer unsigned not null
);

create table if not exists DETALLE_COMPRA (
    subtotal_detalle_compra double unsigned not null default 0,
    cantidad_detalle_compra integer unsigned not null default 0,
    valor_unitario double unsigned not null default 0,
    lote_detalle_compra varchar(20) not null,
    vencimiento_detalle_compra date not null,
    id_compra integer unsigned not null,
    id_producto integer unsigned not null
);

create table if not null DETALLE_VENTA (
    cantidad_detalle_venta integer unsigned not null default 0,
    subtotal_detalle_venta double unsigned not null default 0,
    id_venta integer unsigned not null,
    id_producto integer unsigned not null
);

-- Llaves primarias

alter table PERSONA
add constraint pk_persona
primary key (id_persona);

alter table SEXO
add constraint pk_sexo
primary key (id_sexo);

alter table TIPO_IDENTIFICACION
add constraint pk_tipo_identificacion
primary key (id_identificacion);

alter table TELEFONO_PERSONA
add constraint pk_telefono_persona
primary key (id_telefono);

alter table CLIENTE
add constraint pk_cliente
primary key (id_cliente);

alter table TIPO_CLIENTE
add constraint pk_tipo_cliente
primary key (id_tipo_cliente);

alter table USUARIO
add constraint pk_usuario
primary key (id_usuario);

alter table ROL
add constraint pk_rol
primary key (id_rol);

alter table PROVEEDOR
add constraint pk_proveedor
primary key (id_proveedor);

alter table COMPRA
add constraint pk_compra
primary key (id_compra);

alter table VENTA
add constraint pk_venta
primary key (id_venta);

alter table FORMA_PAGO
add constraint pk_forma_pago
primary key (id_forma_pago);

alter table CREDITO
add constraint pk_credito
primary key (id_credito);

alter table ABONO
add constraint pk_abono
primary key (id_abono);

alter table MARCA_PRODUCTO
add constraint pk_marca_producto
primary key (id_marca);

alter table UNIDAD_MEDIDA_PRODUCTO
add constraint pk_unidade_medida_producto
primary key (id_unidad_medida);

alter table CATEGORIA_PRODUCTO
add constraint pk_categoria_producto
primary key (id_categoria);

alter table TIPO_PRODUCTO
add constraint pk_tipo_producto
primary key (id_tipo_producto);

alter table PRODUCTO
add constraint pk_producto
primary key (id_producto);

-- Llaves foraneas

alter table PERSONA
add constraint fk_persona_sexo
foreign key (id_sexo) references SEXO(id_sexo);

alter table PERSONA
add constraint fk_persona_identificacion
foreign key (id_identificacion) references TIPO_IDENTIFICACION(id_identificacion);

alter table TELEFONO_PERSONA
add constraint fk_telefono_persona
foreign key (id_persona) references PERSONA(id_persona);

alter table CLIENTE
add constraint fk_cliente_persona
foreign key (id_persona) references PERSONA(id_persona);

alter table CLIENTE
add constraint fk_cliente_tipo_cliente
foreign key (id_tipo_cliente) references TIPO_CLIENTE(id_tipo_cliente);

alter table USUARIO
add constraint fk_usuario_persona
foreign key (id_persona) references PERSONA(id_persona);

alter table USUARIO
add constraint fk_usuario_rol
foreign key (id_rol) references ROL(id_rol);

alter table PROVEEDOR
add constraint fk_proveedor_persona
foreign key (id_persona) references PERSONA(id_persona);

alter table COMPRA
add constraint fk_compra_proveedor
foreign key (id_proveedor) references PROVEEDOR(id_proveedor);

alter table VENTA
add constraint fk_venta_usuario
foreign key (id_usuario) references PERSONA(id_usuario);

alter table VENTA
add constraint fk_venta_forma_pago
foreign key (id_forma_pago) references FORMA_PAGO(id_forma_pago);

alter table VENTA
add constraint fk_venta_cliente
foreign key (id_cliente) references CLIENTE(id_cliente);

alter table CREDITO
add constraint fk_credito_venta
foreign key (id_venta) references VENTA(id_venta);

alter table ABONO
add constraint fk_aborto_credito
foreign key (id_credito) references CREDITO(id_credito);


alter table PRODUCTO
add constraint fk_producto_marca_produto
foreign key (id_marca) references MARCA_PRODUCTO(id_marca);

alter table PRODUCTO
add constraint fk_producto_unidad_medida_produto
foreign key (id_unidad_medida)
references UNIDAD_MEDIDA_PRODUCTO(id_unidad_medida);

alter table PRODUCTO
add constraint fk_producto_categoria_producto
foreign key (id_categoria)
references CATEGORIA_PRODUCTO(id_categoria);

alter table PRODUCTO
add constraint fk_producto_tipo_producto
foreign key (id_tipo_producto)
references TIPO_PRODUCTO(id_tipo_producto);

alter table DETALLE_COMPRA
add constraint fk_detalle_compra_compra
foreign key (id_compra)
references COMPRA(id_compra);

alter table DETALLE_COMPRA
add constraint fk_detalle_compra_producto
foreign key (id_producto)
references PRODUCTO(id_producto);

alter table DETALLE_VENTA
add constraint fk_detalle_venta_venta
foreign key (id_venta)
references VENTA(id_venta);

alter table DETALLE_VENTA
add constraint fk_detalle_venta_producto
foreign key (id_producto)
references PRODUCTO(id_producto);