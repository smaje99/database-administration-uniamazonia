select
    persona.id_persona,
    persona.nombre_persona,
    sexo.nombre_sexo,
    identificacion.nombre_dentificacion,
    persona.numero_identificacion
from
    salsamentaria.persona as persona
inner join
    salsamentaria.sexo as sexo
    on persona.id_sexo = sexo.id_sexo
inner join
    salsamentaria.tipo_identificacion as identificacion
    on persona.id_identificacion = identificacion.id_identificacion
where
    sexo.id_sexo in (1, 2)
    and identificacion.estado_identificacion = 'a'
order by
    persona.id_persona asc;


-- nombre de la persona y el estado del proveedor
select
    persona.nombre_persona,
    proveedor.estado_proveedor
from
    salsamentaria.proveedor as proveedor
inner join
    salsamentaria.persona as persona
    on proveedor.id_persona = persona.id_persona
order by
    proveedor.id_proveedor asc;


--
update salsamentaria.cliente
set idtipo_cliente = null
where id_cliente in (2, 6);

update salsamentaria.tipo_cliente
set tipo_cliente = 'ocasional'
where tipo_cliente = 'ocacional';


-- todos los clientes con sus respectivos tipo de cliente si lo tienen
select
    cliente.razon_social,
    tipo.tipo_cliente
from
    salsamentaria.cliente as cliente
left join
    salsamentaria.tipo_cliente as tipo
    on cliente.idtipo_cliente = tipo.idtipo_cliente
order by
    cliente.id_cliente asc;


-- nombre y apellido de los proveedores y sus respectivos productos
-- donde el producto y el proveedor esten activos
select
    persona.nombre_persona,
    persona.apellido_persona,
    producto.descripcion_producto
from
    salsamentaria.proveedor as proveedor
inner join
    salsamentaria.persona as persona
    on proveedor.id_persona = persona.id_persona
inner join
    salsamentaria.compra as compra
    on compra.id_proveedor = proveedor.id_proveedor
inner join
    salsamentaria.detalle_compra as detalle_compra
    on detalle_compra.id_compra = compra.id_compra
inner join
    salsamentaria.producto as producto
    on detalle_compra.id_producto = producto.id_producto
where
    proveedor.estado_proveedor = 'a'
    and producto.estado_producto = 'a'
order by
    persona.id_persona asc;


select
    persona.nombre_persona,
    persona.apellido_persona,
    proveedor.razon_social
from
    salsamentaria.proveedor as proveedor
natural join
    salsamentaria.persona as persona
where
    proveedor.estado_proveedor = 'a';

-- cuantas categorias de producto son proveidas por cada sexo
select
    categoria_producto.nombre_categoria,
    sexo.nombre_sexo,
    count(producto.id_categoria) as categorias_por_sexo
from
    salsamentaria.sexo as sexo
inner join
    salsamentaria.persona as persona
    on persona.id_sexo = sexo.id_sexo
inner join
    salsamentaria.proveedor as proveedor
    on proveedor.id_persona = persona.id_persona
inner join
    salsamentaria.compra as compra
    on compra.id_proveedor = proveedor.id_proveedor
inner join
    salsamentaria.detalle_compra as detalle_compra
    on detalle_compra.id_compra = compra.id_compra
inner join
    salsamentaria.producto as producto
    on detalle_compra.id_producto = producto.id_producto
inner join
    salsamentaria.categoria_producto as categoria_producto
    on producto.id_categoria = categoria_producto.id_categoria
group by
    categoria_producto.nombre_categoria,
    sexo.nombre_sexo
order by
    categoria_producto.id_categoria asc;


-- cuantas ventas se han hecho por cada forma de pago
-- forma de pago y cantidad
select
    forma_pago.forma_pago,
    count(venta.idforma_pago) as cantidad
from
    salsamentaria.venta as venta
inner join
    salsamentaria.forma_pago as forma_pago
    on venta.idforma_pago = forma_pago.idforma_pago
group by
    forma_pago.forma_pago
order by
    cantidad desc,
    forma_pago.forma_pago asc;

-- cuál es la venta maxima, la venta minima y el promedio de las ventas
select
    max(venta.valortotal_venta) as máximo,
    min(venta.valortotal_venta) as mínimo,
    truncate(avg(venta.valortotal_venta), 2) as promedio_auto,
    round(sum(venta.valortotal_venta) / count(venta.valortotal_venta), 2) as promedio_manual
from
    salsamentaria.venta as venta;


-- traer las ventas y el total de productos de cada venta,
-- pero que la fecha de entrega 15 al 25 de un mes
select
    venta.id_venta,
    date_format(venta.fecha_venta, '%d/%m/%Y') as fecha,
    count(producto.id_producto) as total_productos
from
    salsamentaria.producto as producto
inner join
    salsamentaria.detalle_venta as detalle_venta
    on detalle_venta.id_producto = producto.id_producto
inner join
    salsamentaria.venta as venta
    on detalle_venta.id_venta = venta.id_venta
where
    venta.fecha_venta between '2022-01-15' and '2022-04-25'
group by
    venta.id_venta,
    venta.fecha_venta
order by
    venta.id_venta asc;


-- cuál es el máximo producto vendido con el nombre
-- funciona pero no es optima
select
    producto_vendido.descripcion_producto as producto,
    max(producto_vendido.total_vendido) as total_vendido
from
    (
        select
            producto.descripcion_producto,
            sum(detalle_venta.cantidaddetalle_venta) as total_vendido
        from
            salsamentaria.producto as producto
        inner join
            salsamentaria.detalle_venta as detalle_venta
            on detalle_venta.id_producto = producto.id_producto
        group by
            producto.descripcion_producto
        order by
            total_vendido desc,
            producto.descripcion_producto asc
    ) as producto_vendido
group by
    producto_vendido.descripcion_producto
having
    total_vendido >= (
        select
            sum(detalle_venta.cantidaddetalle_venta) as total_vendido
        from
            salsamentaria.producto as producto
        inner join
            salsamentaria.detalle_venta as detalle_venta
            on detalle_venta.id_producto = producto.id_producto
        group by
            producto.descripcion_producto
        order by
            total_vendido desc,
            producto.descripcion_producto asc
        limit
            1
    )
order by
    producto;

-- esta solución no es recomendada
select
    producto.descripcion_producto,
    sum(detalle_venta.cantidaddetalle_venta) as total_vendido
from
    salsamentaria.producto as producto
inner join
    salsamentaria.detalle_venta as detalle_venta
    on detalle_venta.id_producto = producto.id_producto
group by
    producto.descripcion_producto
order by
    total_vendido desc,
    producto.descripcion_producto asc
limit
    1;

-- cuál es el máximo producto vendido con el nombre
-- funciona pero no es optima
select
    producto.descripcion_producto as producto,
    sum(detalle_venta.cantidaddetalle_venta) as total_vendido
from
    salsamentaria.producto as producto
inner join
    salsamentaria.detalle_venta as detalle_venta
    on detalle_venta.id_producto = producto.id_producto
group by
    producto.descripcion_producto
having
    total_vendido = (
        select
            sum(detalle_venta.cantidaddetalle_venta) as cantidad
        from
            salsamentaria.detalle_venta as detalle_venta
        group by
            detalle_venta.id_producto
        order by
            cantidad desc
        limit
            1
    )
order by
    producto.descripcion_producto asc;


-- cantidad de productos vendidos con nombre que inicien con aceite
select
    producto.descripcion_producto as producto,
    sum(detalle_venta.cantidaddetalle_venta) as total_vendido
from
    salsamentaria.producto as producto
inner join
    salsamentaria.detalle_venta as detalle_venta
    on detalle_venta.id_producto = producto.id_producto
where
    producto.descripcion_producto like 'aceite%'
group by
    producto.descripcion_producto
order by
    producto.descripcion_producto asc;


-- cantidad de productos vendidos con nombre que terminen en cocina
select
    producto.descripcion_producto as producto,
    sum(detalle_venta.cantidaddetalle_venta) as total_vendido
from
    salsamentaria.producto as producto
inner join
    salsamentaria.detalle_venta as detalle_venta
    on detalle_venta.id_producto = producto.id_producto
where
    producto.descripcion_producto like '%cocina'
group by
    producto.descripcion_producto
order by
    producto.descripcion_producto asc;


-- cantidad de productos vendidos con nombre que contenga la palabra 'sal'
select
    producto.descripcion_producto as producto,
    sum(detalle_venta.cantidaddetalle_venta) as total_vendido
from
    salsamentaria.producto as producto
inner join
    salsamentaria.detalle_venta as detalle_venta
    on detalle_venta.id_producto = producto.id_producto
where
    producto.descripcion_producto like '%sal%'
group by
    producto.descripcion_producto
order by
    producto.descripcion_producto asc;


-- traer las ventas con el total de abonos y el total coutas de esa venta
-- id_venta, valor_venta, total_abonos, número_coutas
-- ordenas con el número de coutas
select
    venta.id_venta,
    venta.valortotal_venta as valor_venta,
    sum(credito.total_abono) as total_abono,
    count(abono.id_credito) as numero_coutas
from
    salsamentaria.venta as venta
inner join
    salsamentaria.credito as credito
    on credito.id_venta = venta.id_venta
inner join
    salsamentaria.abono as abono
    on abono.id_credito = credito.id_credito
group by
    venta.id_venta,
    valor_venta
    -- abono.id_credito  -- en caso de querer agruparlo por la cantidad de creditos de una venta
order by
    numero_coutas desc;


-- traer todos los clientes que contengan o no credito
-- nombre, credito
-- pepe, 1
-- pepe, 2
-- juan, null
select
    concat(persona.nombre_persona, ' ', persona.apellido_persona) as cliente,
    credito.id_credito as credito
from
    salsamentaria.persona as persona
inner join
    salsamentaria.cliente as cliente
    on cliente.id_persona = persona.id_persona
left outer join
    salsamentaria.venta as venta
    on venta.id_cliente = cliente.id_cliente
left outer join
    salsamentaria.credito as credito
    on credito.id_venta = venta.id_venta
order by
    cliente asc;


insert into
    salsamentaria.cliente(
        id_cliente,
        razon_social,
        estado_cliente,
        id_persona,
        idtipo_cliente
    )
values
	 (8, "cliente 8", "a", 7, 1);


-- traer todas la compras
-- nombre proveedor, id compra, valor total de la compra
-- concatenar nombre y apellido del proveedor
-- crear un atributo nivel:
-- si el valor de la compra está entre
-- 0 - 700 Bajo
-- 701 - 999999 Medio
-- 1000000 > Alto
select
    concat(persona.nombre_persona, ' ', persona.apellido_persona) as proveedor,
    compra.id_compra,
    concat('$ ', format(compra.valortotal_compra, 0)) as valor_total,
    case
        when compra.valortotal_compra between 0 and 700000
            then 'Bajo'
        when compra.valortotal_compra between 700001 and 999999
            then 'Medio'
        else 'Alto'
    end as nivel
from
    salsamentaria.proveedor as proveedor
inner join
    salsamentaria.persona as persona
    on proveedor.id_persona = persona.id_persona
inner join
    salsamentaria.compra as compra
    on compra.id_proveedor = proveedor.id_proveedor
order by
    proveedor asc;


-- traer las ventas
-- id, cliente, forma de pago, total y subtotal
-- una columna descuento:
-- 10% - 15% normal
-- 16% - 40% moderado
-- 41% - 50% alto
-- 51% - 70% exagerado
-- si no aplica: sin descuento
select
    venta.id_venta,
    concat(persona.nombre_persona, ' ', persona.apellido_persona) as cliente,
    forma_pago.forma_pago,
    concat('$ ', format(venta.valortotal_venta, 2)) as valor_total,
    concat('$ ', format(venta.subtotal_venta, 2)) as subtotal,
    case
        when (venta.total_descuento / venta.valortotal_venta) between 0.1 and 0.15
            then 'normal'
        when (venta.total_descuento / venta.valortotal_venta) between 0.16 and 0.40
            then 'moderado'
        when (venta.total_descuento / venta.valortotal_venta) between 0.41 and 0.50
            then 'alto'
        when (venta.total_descuento / venta.valortotal_venta) between 0.51 and 0.70
            then 'exagerado'
        else 'sin descuento'
    end as descuento
from
    salsamentaria.persona as persona
inner join
    salsamentaria.cliente as cliente
    on cliente.id_persona = persona.id_persona
inner join
    salsamentaria.venta as venta
    on venta.id_cliente = cliente.id_cliente
inner join
    salsamentaria.forma_pago as forma_pago
    on venta.idforma_pago = forma_pago.idforma_pago
order by
    venta.id_venta asc;

