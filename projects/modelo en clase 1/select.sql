select
    prs.id_persona, 
    prs.nombre_persona,
     prs.apellido_persona, 
     prs.email_persona,
     sex.nombre_sexo,
      prs.numero_identificacion,
      indt.nombre_dentificacion
from
    salsamentaria.persona  as  prs

inner join
    salsamentaria.sexo as sex
    on  prs.id_sexo =  sex.id_sexo
inner join 
    salsamentaria.tipo_identificacion as  indt 
    on  prs.id_identificacion =  indt.id_identificacion
where
    indt.estado_identificacion = "a"
order by
     prs.nombre_persona asc;