# Tarea 4

<time datetime="04-28-2022" style="color:gray">Abril 28 de 2022</time>

## Consulta # 1

### Tipos de Join

<img title="Joins de SQL" src="../recursos/TSQL Join Types.png" alt="Joins de SQL" data-align="center">

![Joins en MySQL](../recursos/joins-in-mysql-1.png "Joins en MySQL")

### Cross join

El *CROSS JOIN* presenta el **plano cartesiano** de los registros de las dos tablas. La tabla resultante tendrá todos los registros de la tabla izquierda combinados con cada uno de los registros de la tabla derecha.

#### Combinación cruzada explícita

```sql
select * from <table1> cross join <table2>;
```

#### Combinación cruzada implícita

```sql
select * from <table1>, <table2>;
```

### Natural join

Es una especialización de la combinación de igualdad, anteriormente mencionada, que se representa por el símbolo ⋈. En este caso se comparan todas las columnas que tengan el mismo nombre en ambas tablas. La tabla resultante contiene sólo una columna por cada par de columnas con el mismo nombre.

```sql
select * from <table1> natural join <table2>;
```

### Self join

```sql
select
    * 
from 
    <tabla1> as t1,
    <tabla1> as t2 
where
    t1.common_field = t2.common_field;
```

```sql
select
    *
from 
    <tabla1> as t1
inner join
    <tabla1> as t2 on
    t1.common_field = t2.common_field
```

---

## Consulta # 2

### Agregación o Agrupación

#### Funciones de Agregación

Las funciones de agregación en *SQL* nos permiten efectuar operaciones sobre un conjunto de resultados, pero devolviendo un único valor agregado para todos ellos. Es decir, nos permiten obtener un valor sobre un conjunto de valores.

Las funciones de agregación básicas que soportan todos los gestores de datos relacionales son las siguientes:

- **COUNT:** devuelve el número total de filas seleccionadas por la consulta.

- **MIN:** devuelve el valor mínimo del campo que se especifique.

- **MAX:** devuelve el valor máximo del campo que se especifique.

- **SUM:** suma los valores del campo que se especifique. *Sólo se puede utilizar en columnas numéricas*.

- **AVG:** devuelve el valor promedio del campo que se especifique. *Sólo se puede utilizar en columnas numéricas*.

> Las funciones anteriores son las básicas en SQL, pero cada gestor de bases de datos relacionales ofrece su propio conjunto, más amplio, con otras funciones de agregación particulares.

Todas estas funciones se aplican a una sola columna, que especificaremos entre paréntesis, excepto la función *COUNT*, que se puede aplicar a una columna o indicar un “\*”. La diferencia entre poner el nombre de una columna o un “\*”, es que en el primer caso no cuenta los valores nulos para dicha columna, y en el segundo si.

#### Agrupando resultados

La cláusula **GROUP BY** unida a un SELECT **permite agrupar filas según las columnas que se indiquen como parámetros**, y se suele utilizar en conjunto con las funciones de agrupación, para **obtener datos resumidos y agrupados** por las columnas que se necesiten.

> **Importante**: Es muy importante tener en cuenta que cuando utilizamos la cláusula *GROUP BY*, los únicos campos que podemos incluir en el *SELECT* sin que estén dentro de una función de agregación, son los que vayan especificados en el *GROUP BY*.

El utilizar la cláusula **GROUP BY no garantiza que los datos se devuelvan ordenados**. Suele ser una práctica recomendable **incluir una cláusula ORDER BY** por las mismas columnas que utilicemos en *GROUP BY*, especificando el orden que nos interese.

Existe una cláusula especial, parecida a la *WHERE* que ya conocemos que nos permite especificar las condiciones de filtro para los diferentes grupos de filas que devuelven estas consultas agregadas. Esta cláusula es **HAVING**.

> *HAVING* es muy similar a la cláusula *WHERE*, pero en vez de afectar a las filas de la tabla, afecta a los grupos obtenidos.

---

## Referencias

- [Sentencia JOIN en SQL - Wikipedia, la enciclopedia libre](https://es.wikipedia.org/wiki/Sentencia_JOIN_en_SQL)

- [Left JOIN - Platzi](https://platzi.com/clases/1272-sql-mysql/11099-left-join/)

- [Tipos de JOIN - Platzi](https://platzi.com/clases/1272-sql-mysql/11100-tipos-de-join/)

- [Tutorial SQL #6: Agrupaciones y funciones de agregación](https://www.campusmvp.es/recursos/post/Fundamentos-de-SQL-Agrupaciones-y-funciones-de-agregacion.aspx)
