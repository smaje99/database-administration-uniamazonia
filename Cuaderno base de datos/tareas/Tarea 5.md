# Tarea 5

<time datetime="05-12-2022" style="color: gray">Mayo 12 de 2022</time>

## Consulta

### Arquitectura Oracle

![Arquitectura Oracle](../recursos/arquitectura%20oracle.png)

Un servidor Oracle Database es el conjunto formado por estos dos elementos:

- **La instancia de Oracle.** Formada por el conjunto de procesos y las estructuras de datos en memoria que requiere el servidor cuando está en funcionamiento.
- **Archivos de la base de datos**. Los archivos en disco que almacenan de forma permanente la información de la base de datos. La base de datos en sí, la forman los **archivos de datos**, los de **control** y los **Redo Log**.

Un servidor de Oracle puede poseer más de una instancia, pero en general en estos apuntes trabajaremos bajo la hipótesis de tener un sistema de instancia simple. Las instancias múltiples se dan en sistemas distribuidos, en los que es posible disponer de más de una instancia (alojada en diferentes servidores) para la misma base de datos.

La ilustración resume la arquitectura de Oracle. En ese diagrama las elipses representan procesos, los rectángulos son almacenes de datos en memoria RAM y los cilindros, archivos en disco.

#### Estructuras en memoria de la instancia de Oracle

##### Elementos de la memoria

![Memoria de la instancia de Oracle](../recursos/memoria%20instancia%20oracle.png)

Elementos de la memoria de Oracle. Se resaltan los principales componentes internos así como la comunicación entre el proceso cliente y el proceso servidor y su relación con la PGA y la SGA.

Una instancia está compuesta por las estructuras de memoria en las que se graban datos y por los procesos que dan servicio a la base de datos.

La Ilustración muestra el detalle de los componentes de la instancia. Cada proceso servidor (si el modo de trabajo es dedicado) atienden cada uno a un usuario.

s datos en la instancia poseen dos grandes estructuras de almacenamiento:

- **SGA** (*Server Global Area*). Zona de la memoria en la que se guardan los datos globales de la instancia. Esos datos son los que comparten todos los procesos servidores, por lo que la mayoría de sus componentes son memorias de tipo caché. Muchas de sus áreas llevan el nombre de Pool. término inglés que, en este contexto, puede traducirse como *fondo*. En el sentido de un espacio en el que se reservan activos.
- **PGA** (*Program Global Area*). Zona de la memoria en la que se guardan los datos referentes a un proceso servidor concreto. Si el modo de trabajo es dedicado, si hay 5 conexiones habrá 5 procesos servidores y, por lo tanto, 5 PGAs. Al conjunto de todas las PGAs en uso, en un momento dado, se le llama **instancia PGA**. El tamaño de la instancia PGA se puede calibrar dentro de las opciones de configuración.

Pasamos, a continuación, a detallar los elementos de la instancia de Oracle. Inicialmente empezaremos por los elementos de la memoria y después detallaremos los principales procesos.

##### Componentes de la PGA

Como se ha comentado, la PGA contiene datos necesarios e independientes para cada proceso servidor. La información que contiene permite acelerar el proceso de las instrucciones SQL del cliente. PGA se divide en dos zonas:

- **Espacio de pila**. Este espacio siempre (aun en modo compartido de servidor) se guarda fuera de la SGA. Es decir, se mantiene en la PGA siempre.
- **UGA** (***User Global Area***). Es el área global de usuario. En modo de servidor compartido este área puede pasar a la SGA (a la zona común de memoria). Este área se compone de los siguientes elementos:
  - **Área de trabajo SQL**. Para el proceso de las instrucciones SQL. A su vez se dividen en:
    - **Área de ordenación**. Para acelerar la ejecución de las cláusulas **ORDER BY** o **GROUP BY**.
    - **Área hash**. Para uniones de tipo hash entre tablas.
    - **Área de creación de bitmaps**. Para crear índices de tipo bitmap.
    - **Área de fusión de bitmaps**. Para resolver índices de tipo bitmap.
  - **Memoria de sesión**. Con los datos de las variables de sesión y de control de la sesión de usuario.
  - **Área privada SQL**. Contiene información sobre la instrucción SQL en curso. Es un almacenamiento que permite almacenar datos referidos al estado de ejecución de las consultas y otras instrucciones. Lo más significado de este área es el uso del **cursor**.

El **cursor** es una estructura dentro del área privada que permite volcar al proceso de usuario los datos de las consultas SQL. Si una consulta devuelve 2000 filas, el cursor se encarga de ir volcando poco a poco esos datos.

Para ello un puntero en el área de datos del usuario permite relacionar los datos que ve el usuario con los datos del área privada.

![Cursor del PGA de Oracle](../recursos/cursor%20PGA%20Oracle.png)

En el caso de utilizar un modo de servidor compartido hay datos que pasan a la SGA. Concretamente, la UGA pasará a la SGA y las PGA de cada conexión almacenarán solo el espacio de pila.

##### Componentes de la SGA

###### Pool Compartido (Shared Pool)

Se trata de una zona de memoria utilizada para acelerar la ejecución de las instrucciones SQL y PL/SQL.

Su espacio se divide en:

- **Caché de biblioteca** *(Library Cache)*. Almacena código ejecutable de SQL y PL/SQL. Siempre que se ejecuta una nueva instrucción (SQL o PL/SQL), se comprueba si la ejecución de la misma esta disponible en este área. Dentro de este caché tenemos:
  - **Área SQL compartida** *(Shared SQL area)*. Contiene el plan de ejecución de la instrucción y el árbol de análisis de la misma. De esta forma se ahorra memoria cuando se repiten las instrucciones. También los elementos PL/SQL son cacheados de esta forma.
  - **Área SQL privada**. Normalmente los datos privados de los usuarios, referidos a información sobre su sesión, necesarios para que una instrucción se ejecute correctamente, se almacenan en la PGA (como se puede comprobar en el apartado anterior). Pero en el modo compartido de servidor, se almacena en la SGA, concretamente en la caché de biblioteca en una zona separada del área de SQL compartida.

- **Caché de Diccionario de Datos** *(Data Dictionary Cache)*. Se la conoce también como **caché de fila** ya que sus datos se almacenan en forma de fila (en el resto de cachés se almacenan en forma de bloques). Contiene información para acelerar el acceso a los metadatos que utilizan las instrucciones (también en la Caché de Biblioteca se guarda información sobre metadatos).
- **Caché de resultados** *(Results cache)*. Tanto para SQL como para  
  PL/SQL, almacena fragmentos de consultas SQL y PL/SQL para aprovecharlos en consultas posteriores. El parámetro de sistema **RESULT_CACHE_MODE** permite establecer si todas las consultas almacenarán fragmentos en caché o sólo las marcadas de forma específica.
- **Área fija**. Es una zona pequeña donde se almacenan los datos necesarios para la carga inicial de la SGA en memoria.

![Shared Pool de Oracle](../recursos/shared%20pool%20oracle.png)

###### Cache de Búferes de Datos (Database Buffer Cache)

Está dividida en bloques (más adelante se explica lo que es un bloque de base de datos) y es la estructura (normalmente) que más ocupa en la SGA. Oracle Database intenta que la modificación de datos en el disco tarde lo menos posible. La estrategia principal es escribir lo menos posible en el disco.

Por ello cuando una instrucción provoca modificar datos, inicialmente esos datos se graban en esta caché. La grabación ocurre tras la confirmación de una transacción. Después, cada cierto tiempo, se grabarán todos de golpe en los ficheros de datos (concretamente cuando ocurra un *checkpoint*).

![Oracle Database Buffer Cache](../recursos/database%20buffer%20cache%20oracle.png)

Los datos, aunque no estén grabados realmente en disco, serán ya permanentes y aparecerán en las consultas que se realicen sobre ellos, además esas consultas serán más rápidas al no acceder al disco. Esto último es la segunda idea, que los datos a los que se accede más a menudo, estén en memoria y no se necesite leerlos del disco.

Los búferes de la caché se asignan con un complejo algoritmo basado en **LRU** *(Last Recently Used)* que da prioridad a los búferes que se han utilizado más recientemente.

Cada búfer puede estar en uno de estos estados:

- **Sin uso** *(Unused)*. Son bloques que no se están utilizando actualmente, por lo que están libres para cualquier proceso que requiere almacenar datos en ellos.
- **Limpios** *(Clean)*. Son búferes que se han utilizado, pero cuyos datos ya están grabados en disco. El siguiente *checkpoint* no necesitaría grabar estos datos, por lo que están disponibles si se requiere su reutilización.
- **Sucios** *(Dirty)*. Contienen datos que no se han grabado en disco. Se deben de grabar en el disco en cuanto ocurra un *checkpoint*, de otro modo podríamos perder información.

Además, con respecto al acceso, los búferes pueden tener estas dos situaciones:

- **Libres** *(Free* o *Unpinned)*. Ningún proceso le está utilizando.
- **Pinned**. Están siendo utilizados por un proceso, por lo que otra sesión no puede acceder a este búfer.

La lectura de búferes sigue este proceso:

1. Si necesitamos un dato, se le busca en esta caché. Si se encuentra se entrega, siempre y cuando no esté ocupado por otro proceso (*pinned*).

2. Si el dato requerido no se encuentra en el búfer, ocurre un **fallo de caché**. Este fallo implica leer los datos del disco y pasarlos a memoria (los búferes necesarios se marcarán como búferes limpios).

3. En ambos casos, si la instrucción implica modificar los datos de ese búfer, se modifica y pasa a ser un búfer sucio.

4. Cuando ocurre un checkpoint, el proceso **DBWn**, graba búferes sucios a disco (lo mismo si se detecta que quedan pocos búferes limpios o sin uso) y se marcan como búferes limpios.

Otro detalle de esta zona de la SGA es que los búferes se agrupan en fondos de almacenamiento (*Pools*). Estos fondos son:

- **Pool por defecto**. Es el de uso normal. Normalmente es el único, salvo que se especifique el uso de otros.
- **Pool KEEP**. Se utiliza para bloques de uso muy frecuente, pero que dentro del fondo por defecto podrían ser reutilizados continuamente si no disponemos de espacio suficiente.
- **Pool RECYCLE**. Se utiliza para bloques de uso muy poco frecuente. El uso de este pool previene de usar estos bloques en el pool por defecto.
- **Pools nK**. El tamaño de bloque es una cuestión importante en una base de datos (más adelante se especificara lo que es un bloque). Aunque la base de datos tiene un tamaño de bloque por defecto, en algunos tablespaces (elemento en el que se guardan los objetos, se describe más adelante), podríamos variar ese tamaño. Por ello podríamos tener otros cachés orientados a estos elementos de tamaño especial. En la ilustración, como ejemplo, aparecen dos fondos de tamaño 2K y 4K.

###### Buffer de Redo Log

Se trata de un búfer circular. Se van utilizando los bloques y, cuando se han usado todos, se vuelven a reutilizar los primeros en caso necesario y así continuamente.

Su función es almacenar la información acerca de los últimos cambios (DML confirmados y DDL) realizados sobre la base de datos. Esta información se vuelca continuamente, mediante el proceso **LGWR**, a los archivos de datos.

Los Redo Log son necesarios para recuperar los datos que no han podido ser grabados definitivamente en disco (normalmente por ocurrir una situación de excepción antes de un CHECKPOINT).

![Oracle Redo Log](../recursos/Oracle%20Redo%20Log.png)

###### Pool Grande (Large Pool)

Área opcional de la SGA que proporciona espacio para los datos necesarios para realizar operaciones que impliquen muchos datos:

- **Backup y restauración**, para copias de seguridad.
- **Procesos de Entrada/Salida del servidor**.
- **Memoria libre**. Para aliviar el trabajo de la instancia.
- **Consultas en paralelo**.
- **Almacenamiento de la UGA**. Normalmente la UGA se almacena en la PGA, pero en modo de servidor compartido se podría almacenar en este área.
- **Cola de peticiones**. Especialmente importante cuando el servidor recibe numerosas peticiones. No se almacenan bloques de datos en este caso.
- **Cola de respuestas**. Tampoco utiliza bloques, sino estructuras más apropiadas para las colas.

![Oracle Large Pool](../recursos/Oracle%20Large%20Pool.png)

Esta área de memoria no ocupa bloques usando el algoritmo LRU (a diferencia del Pool Compartido y de la Caché de Búferes de Datos), sino que los bloques quedan asignados hasta que queden marcados, por el proceso que los utilizó, como libres para otros procesos.

###### Pool de Java

Sólo se usa para los programas que utilizan Java.

###### Pool de Streams

Lo usa sólo el componente Oracle Streams (utilizado por bases de datos distribuidas) y sirve para almacenar en búferes, datos manejados por dicho componente.

## Referencias

[Jorge Sánchez. Manual de Administración de Bases de Datos. Arquitectura de Oracle Database](https://jorgesanchez.net/manuales/abd/arquitectura-oracle.html)


