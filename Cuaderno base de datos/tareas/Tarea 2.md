# Tarea 2

<time datetime="04-07-2022" style="color: grey;">Abril 7 de 2022</time>

## Consulta #1

> Consultar como visualizar la **información de una tabla** en *MySQL*

```sql
desc '<table>';
```

Este comando muestra la estructura de una tabla.

---

## Consulta #2

> Cómo crear un usuario en *MySQL*

```sql
create user '<user>'@'localhost' identified by '<password>';
```

> **Nota:** Al añadir usuarios en el shell de MySQL en este tutorial, especificaremos el host del usuario como `localhost`, y no la dirección IP del servidor. `localhost` es un nombre de host que significa “este equipo”, y MySQL trata este nombre de host en particular de manera especial: cuando un usuario con ese host inicia sesión en MySQL, intentará conectarse al servidor local utilizando un archivo de socket de Unix. Por lo tanto, `localhost` se utiliza normalmente cuando planea conectarse implementando SSH a su servidor o cuando está ejecutando el cliente `mysql` local para conectarse al servidor MySQL local.

En este momento, el `usuario` no tiene permisos  para hacer nada con la base de datos. De hecho, incluso si el `usuario` intentara iniciar sesión, no podrá acceder a la base de datos.

Por lo tanto, lo primero que se debe hacer es proporcionar al `usuario` acceso a la información que necesitará.

```sql
grant all privileges on * . * to '<user>'@'localhost';
```

Los asteriscos en este comando se refieren a la base de datos y la tabla (respectivamente) a los que pueden acceder. Este comando específico permite al usuario leer, editar, ejecutar y realizar todas las tareas en todas las bases de datos y tablas.

Una vez que haya finalizado los permisos que desea configurar para sus nuevos usuarios, asegúrese siempre de volver a cargar todos los privilegios.

```sql
flush privileges;
```

Sus cambios ahora estarán vigentes.

### Cómo otorgar diferentes permisos de usuario

- **ALL PRIVILEGES.** otorga a un usuario de MySQL acceso completo a una base de datos designada (o si no se selecciona ninguna base de datos, acceso global a todo el sistema)

- **CREATE.** Permite crear nuevas tablas o bases de datos.

- **DROP.** Permite eliminar tablas o bases de datos.

- **DELETE.** Permite eliminar filas de las tablas.

- **INSERT.** Permite insertar filas en las tablas.

- **SELECT.** Les permite usar el comando `select` para leer las bases de datos.

- **UPDATE.** Permite actualizar las filas de las tablas.

- **GRANT OPTION.** Permite otorgar o eliminar privilegios de otros usuarios.

Para proporcionar un permiso a un usuario específico, puede usar este marco:

```sql
grant <permission> on <database>.<table> to '<user>'@'localhost'
```

Cada vez que actualice o cambie un permiso, asegúrese de usar el comando `flush privileges`.

Si necesita revocar un permiso, la estructura es casi la misma que para otorgar un permiso:

```sql
revoke <permission> on <database>.<table> from '<user>'@'localhost';
```

Tenga en cuenta que, cuando revoca permisos, la sintaxis requiere que utilice `from` en lugar de `to`, como se utiliza para otorgar permisos.

Puede revisar los permisos actuales de un usuario ejecutando lo siguiente:

```sql
show grants for '<user>'@'localhost';
```

Al igual que puede eliminar bases de datos con DROP, también puede usar DROP para eliminar un usuario por completo:

```sql
drop user '<user>'@'localhost';
```

Para probar su nuevo usuario, cierre sesión escribiendo lo siguiente:

```sql
quit;
```

y vuelva a iniciar sesión con este comando en la terminal:

```shell
mysql -u [username] -p
```

---

### Lenguaje de Control de Datos (DCL)

Permite crear roles, permisos e integridad referencial, así como el control al acceso a la **base de datos**.

Elementos del *DCL* (*Data Control Language*)

- ***GRANT***. Usado para otorgar privilegios de acceso de usuario a la **base de datos**.

- ***REVOKE***. Utilizado para retirar privilegios de acceso otorgados con el comando ***GRANT***.

---

## Referencias

* [¿Qué es DDL? Significado de DML, DCL y TCL - Platzi](https://platzi.com/blog/que-es-ddl-dml-dcl-y-tcl-integridad-referencial/)

* [Cómo crear un nuevo usuario y otorgar permisos en MySQL | DigitalOcean](https://www.digitalocean.com/community/tutorials/crear-un-nuevo-usuario-y-otorgarle-permisos-en-mysql-es)
