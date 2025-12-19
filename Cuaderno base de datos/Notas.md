# Notas

## <time datetime="05-5-2022" style="color: grey">Mayo 5 de 2022</time>

> # WildCards (Comodines)
> 
> - **%** - Coincidencia de cualquier número de caracteres, incluso cero caracteres
> 
> - **\_** - Coincidencia exacta de un carácter
> 
> - **[]** - Series y rangos de caracteres que coinciden. [charlist]
> 
> - **^ ó !** - Series y rangos que no coinciden. [^charlist]. [!charlist]
> 
> - **-** - Rangos consecutivos. [a-d] = [abcd]. [2-8] = [2345678]

## <time datetime="04-28-2022" style="color: gray">Abril 28 de 2022</time>

> # Igualdades de *inner join*
> 
> Siempre hacerla de foránea a primaria
> 
> > FOREIGN KEY = PRIMARY KEY

## <time datetime="04-25-2022" style="color: gray">Abril 25 de 2022</time>

> # Comando *check constraint*
> 
> El *constraint* **check** permite especificar los valores en una columna que deben satisfacer una expresión *booleana*.
> 
> ```sql
> check(<condition>);
> ```
> 
> ```sql
> constraint <name> check(<condition>);
> ```

## <time datetime="04-21-2022" style="color: grey">Abril 21 2022</time>

> # Acuerdo pedagógico
> 
> | Contenido                          | Porcentaje | Fecha    |
> | ---------------------------------- | ---------- | -------- |
> | Parcial 1                          | 25%        | Mayo 5   |
> | Informe parcial del proyecto final | 20%        | Junio 9  |
> | Parcial 2                          | 25%        | Julio 7  |
> | Trabajo final                      | 5% - 25%   | Julio 18 |

> # Comando para ejecutar un archivo   en *MySQL*
> 
> ```shell
> mysql -u root -p < <filename>.sql
> ```
> 
> ó
> 
> ```shell
> source <filename>
> ```

> # zerofill
> 
> ***zerofill*** conserva los ceros a la izquierda de un número.
> 
> **Ejemplo:** 0001

> # Motores de MySQL (Engine)
> 
> - MyISAM
> 
> - InnoDB
>   
>   Respeta la integridad referencial

## <time datetime="04-18-2022" style="color: gray">Abril 18 de 2022</time>

> # Atributos multivaluados
> 
> Para los **atributos multivaluados** se recomiendo crear una tabla cuando contienen muchos atributos, en el caso de contener pocos atributos es preferible crearlos en la tabla original para mejorar el *performance* de una consulta y requerir menos *join* en esta.

> # Atributos en una tabla
> 
> una tabla tiene atributos **propios** y **foráneos**.

> # Constraints
> 
> Se recomiendo no hacer **eliminaciones** y **actualizaciones** en **cascada**.
