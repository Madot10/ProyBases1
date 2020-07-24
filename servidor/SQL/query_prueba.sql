--SELECT CONDICIONES DE UN CONTRATO
SELECT * FROM vam_contratos AS c, vam_fe_fp_c AS cond  WHERE  cond.id_contrato = c.id;

-- SELECT PARA TENER FE Y FP DADO UN CONTRATO
SELECT * FROM vam_contratos AS c, vam_fe_fp_c AS cond LEFT JOIN vam_forma_envios AS fe ON  fe.id = cond.id_form_envio LEFT JOIN vam_forma_pagos AS fp ON  fp.id = cond.id_form_pago WHERE c.id = 1 AND cond.id_contrato = c.id
--c.id AS ContratoID, cond.id_form_envio As FormaEnvioID, cond.id_form_pago AS FormaPagoID, fe.id AS FEID, fp.id AS FPIS

--Select de contrato con info bonita
SELECT c.id, c.fecha_emision, c.exclusividad, c.clausula, c.fecha_cancelacion, c.motivo_cancel, c.quien_cancela, cond.id_form_envio, fe.id_pais, fe.tipo, fe.cargo, cond.id_form_pago, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago	
FROM vam_contratos AS c, vam_fe_fp_c AS cond 
  LEFT JOIN vam_forma_envios AS fe ON  fe.id = cond.id_form_envio 
  LEFT JOIN vam_forma_pagos AS fp ON  fp.id = cond.id_form_pago 
WHERE c.id_prov = $1 AND cond.id_contrato = c.id


--SELECT PRODUCTOS CONTRATADOS
SELECT  * FROM vam_contratos AS c, vam_mp_c AS mpcont WHERE c.id = mpcont.id_contrato;

--SELCT CONTRATOS CON MENOS DE 1 ano segun fecha emsion
SELECT  c.id, c.fecha_emision, age(fecha_emision) AS Diff FROM vam_contratos AS c WHERE age(c.fecha_emision) <= '12 month';

--SELECT CONTRATOS ACTIVOS (USANDO SUBQUERY)
SELECT  c.id AS id_contrato, c.fecha_emision FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '11 month' OR age(c.fecha_emision) <= '12 month');

3.1/4.1 --SELECT DATOS FE Y FP DE TODOS CONTRATOS ACTIVOS (SUB QUERY)
SELECT c.id AS ContratoID, cond.id_form_envio As FormaEnvioID, cond.id_form_pago AS FormaPagoID, fe.id AS FEID, fp.id AS FPIS FROM vam_contratos AS c, vam_fe_fp_c AS cond LEFT JOIN vam_forma_envios AS fe ON  fe.id = cond.id_form_envio LEFT JOIN vam_forma_pagos AS fp ON  fp.id = cond.id_form_pago WHERE cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month');


3.2/4.2 --SELECT DATOS ING E ING_PRES DE TODOS LOS CONTRATOS ACTIVOS DE UN PROV
SELECT c.id, ing.cas, ing.nombre, ing.tipo, ing.descripcion, ing.taxonomia, ing_pres.volumen, ing_pres.precio
FROM vam_contratos AS c, vam_mp_c AS cond
  LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = cond.cas
  LEFT JOIN vam_ing_presentaciones AS ing_pres ON ing_pres.cas_ingrediente = cond.cas
WHERE c.id_prov = 3 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month');

--PROVEEDORES SIN CONTRATO CON UN PRODUCTOR DADO
SELECT prov.id AS provId FROM vam_proveedores As prov WHERE  NOT exists(SELECT * FROM vam_contratos As c WHERE c.id_prov = prov.id AND c.id_prod = 1)

--SECLT PRoveedores libres para hacer contrato con un Prod dado = 1
SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id NOT IN (SELECT c.id_prov FROM vam_contratos As c WHERE c.id_prov = prov.id AND c.id_prod = 1) UNION SELECT prov.id AS provId FROM vam_proveedores As prov, vam_contratos As c WHERE c.id_prov = prov.id AND c.id_prod = 1 AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos As c WHERE c.id_prov = prov.id AND c.id_prod = 1) AND (c.fecha_cancelacion IS NOT NULL OR (age(c.fecha_emision) >= '12 month' AND age(COALESCE((SELECT MAX(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id AND c.id_prod = 1 GROUP BY r.id_contrato), now() - interval '13 month')) >= '12 month'));

--Proveedores disponibles (No tienen contratos activos con dicho prod)
SELECT prov.id, prov.nombre FROM vam_proveedores AS prov WHERE prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'));

--SELECT (una vez)Pares Proveedores que entregan a Productores segun FE y Sedes DADO un productor 'and sedes.id_productor = 2"
SELECT DISTINCT prov.id AS provid, sedes.id_productor AS prodId FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 2;

-- DAME LOS PROVEEDORES DISPONIBLES Y CON CAPACIDAD DE ENVIO
SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 2) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))

--LISTA HISTORICO DADO UN PROV = 1
SELECT prov.id AS provId, ifra.fecha_inicio, ifra.fecha_fin FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE prov.id = 1 AND ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL;

6 -- DAME LOS PROVEEDORES DISPONIBLES, CON CAPACIDAD DE ENVIO Y IFRA ACTIVO
SELECT prov.id AS provId, pais.nombre AS paisnombre, prov.nombre, prov.email, prov.telefono, prov.pag_web FROM vam_proveedores As prov, vam_paises AS pais WHERE prov.id_pais = pais.id AND prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 2) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'));

  6.1 --DAME DATO PROV Y FE con PAIS NOMBRE
  SELECT prov.id AS provId, fe.id, fe.tipo, fe.cargo, p.nombre, p.id AS paisId FROM vam_proveedores AS prov INNER JOIN vam_forma_envios AS fe ON fe.id_prov = prov.id INNER JOIN vam_paises AS p ON p.id = fe.id_pais WHERE prov.id IN (SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 1) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))

  6.2 --DAME DATO PROV Y FP
  SELECT prov.id AS provId, fp.id, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago FROM vam_proveedores AS prov INNER JOIN vam_forma_pagos AS fp ON fp.id_proveedor = prov.id WHERE prov.id IN(SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 1) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))

  6.3 -- DAME LOS ING Y PRESENTACIONES
  SELECT prov.id AS provId, ing.cas, ing.nombre, ing.tipo, present.precio, present.volumen FROM vam_proveedores AS prov INNER JOIN vam_ingrediente_esencias AS ing ON ing.id_proveedor = prov.id INNER JOIN vam_ing_presentaciones AS present ON present.cas_ingrediente = ing.cas WHERE prov.id IN (SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 1) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))

--DAME DATO PROV Y FE con PAIS NOMBRE
-- FALTA PARA FILTRAR PROVEEDORES DISPONIBLES: WHERE prov.id IN (<SELECT DE ARRIBA>)
SELECT prov.id, prov.nombre, fe.id, fe.tipo, p.nombre FROM vam_proveedores AS prov INNER JOIN vam_forma_envios AS fe ON fe.id_prov = prov.id INNER JOIN vam_paises AS p ON p.id = fe.id_pais

--DAME DATO PROV Y FP
-- FALTA PARA FILTRAR PROVEEDORES DISPONIBLES: WHERE prov.id IN (<SELECT DE ARRIBA>)
SELECT prov.id, prov.nombre, fp.id, fp.tipo FROM vam_proveedores AS prov INNER JOIN vam_forma_pagos AS fp ON fp.id_proveedor = prov.id

-- DAME LOS ING Y PRESENTACIONES
-- FALTA PARA FILTRAR PROVEEDORES DISPONIBLES: WHERE prov.id IN (<SELECT DE ARRIBA>)
SELECT prov.id, prov.nombre, ing.nombre, ing.tipo, present.precio, present.volumen FROM vam_proveedores AS prov INNER JOIN vam_ingrediente_esencias AS ing ON ing.id_proveedor = prov.id INNER JOIN vam_ing_presentaciones AS present ON present.cas_ingrediente = ing.cas

--INGREDIENTES EN CONTRATOS EXCLUSIVOS
SELECT mpcont.id_contrato, mpcont.cas, cont.id, cont.id_prov FROM vam_contratos AS cont, vam_mp_c AS mpcont WHERE mpcont.id_contrato = cont.id AND cont.exclusividad = TRUE

--INGREDIENTES EN CONTRATOS EXCLUSIVOS ACTIVOS
SELECT mpcont.id_contrato, mpcont.cas, cont.id, cont.id_prov FROM vam_contratos AS cont, vam_mp_c AS mpcont WHERE mpcont.id_contrato = cont.id AND cont.exclusividad = TRUE AND mpcont.id_contrato IN (SELECT c.id AS id_contrato FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))

7 -- Ingredientes disponibles para contratar No exclusivos dado un PROV=3
SELECT 3 AS provId, ing.nombre, ing.tipo, ing.cas FROM vam_ingrediente_esencias AS ing WHERE ing.id_proveedor = 3 AND ing.cas NOT IN (SELECT mpcont.cas FROM vam_contratos AS cont, vam_mp_c AS mpcont WHERE mpcont.id_contrato = cont.id AND cont.exclusividad = TRUE AND mpcont.id_contrato IN (SELECT c.id AS id_contrato FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))

--Ing contratados en contratos activos => Ing activos
SELECT  mpcont.cas FROM vam_contratos AS c, vam_mp_c AS mpcont WHERE c.id = mpcont.id_contrato AND c.id IN(SELECT  c.id AS id_contrato FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))

8 -- Ing disponibles para contratar en contrato exclusivo dado un Prov=5
SELECT 5 AS provId, ing.nombre, ing.tipo, ing.cas FROM vam_ingrediente_esencias AS ing WHERE ing.id_proveedor = 5 AND ing.cas NOT IN (SELECT  mpcont.cas FROM vam_contratos AS c, vam_mp_c AS mpcont WHERE c.id = mpcont.id_contrato AND c.id IN(SELECT  c.id AS id_contrato FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))


11 --Select datos del proveedor, ingredientes y presentaciones de acuerdo al IFRA activo
SELECT prov.id AS id_prov, prov.nombre AS nombre_prov, prov.email, prov.telefono, prov.pag_web, pais.nombre AS nombre_pais, ing.cas, ing.nombre AS nombre_ing, ing.tipo AS tipo_ing, ing_pres.volumen, ing_pres.precio,
FROM vam_proveedores AS prov
  LEFT JOIN vam_ingrediente_esencias AS ing ON ing.id_proveedor = prov.id
  LEFT JOIN vam_ing_presentaciones AS ing_pres ON ing_pres.cas_ingrediente = ing.cas
  LEFT JOIN vam_paises AS pais ON pais.id = prov.id_pais
WHERE (SELECT fecha_fin FROM vam_historico_ifra WHERE id_proveedor = prov.id) IS NULL;

11.1 --Select formas de pago y de envío de un proveedor de acuerdo al IFRA activo
SELECT prov.id AS id_prov, fp.id AS id_fp, fp.tipo AS tipo_fp, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fe.id AS id_fe, fe.tipo AS tipo_fe, fe.cargo, pais.nombre AS destino
FROM vam_proveedores AS prov
  LEFT JOIN vam_forma_pagos AS fp ON fp.id_proveedor = prov.id
  LEFT JOIN vam_forma_envios AS fe ON fe.id_prov = prov.id
  LEFT JOIN vam_paises AS pais ON pais.id = fe.id_pais
WHERE (SELECT fecha_fin FROM vam_historico_ifra WHERE id_proveedor = prov.id) IS NULL;


12 --SELECT CONTRATOS ACTIVOS (USANDO SUBQUERY) A PUNTO DE VENCER (RANGO entre 11 y 12meses) DE UN PROD
SELECT  c.id AS id_contrato, c.fecha_emision, c.id_prod,age(c.fecha_emision) FROM vam_contratos AS c WHERE c.id_prod = 1 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) BETWEEN '11 month' AND '12 month' OR age(c.fecha_emision) BETWEEN '11 month' AND '12 month');


UPDATE vam_contratos SET fecha_emision='01-08-2019' WHERE id = 1;


12 --SELECT INGREDIENTES DE CONTRATOS ACTIVOS (USANDO SUBQUERY) A PUNTO DE VENCER (RANGO entre 11 y 12meses) DE UN PROD
SELECT c.id, ing.cas, ing.nombre, ing.tipo, ing.descripcion, ing.taxonomia, ing_pres.volumen, ing_pres.precio FROM vam_contratos AS c, vam_mp_c AS cond
    LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = cond.cas
    LEFT JOIN vam_ing_presentaciones AS ing_pres ON ing_pres.cas_ingrediente = cond.cas
WHERE c.id_prod = 1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) BETWEEN '11 month' AND '12 month' OR age(c.fecha_emision) BETWEEN '11 month' AND '12 month');

--Para quitar el Not Null en la fecha de confirmación del pedido
alter table vam_pedidos alter column f_confirmacion drop not null;


--Pedidos pendientes por confirmar por el proveedor
SELECT p.id, p.estado, p.f_emision, p.f_confirmacion, p.id_prod, p.total_usd, ing.cas, ing.nombre, pres.volumen
FROM vam_pedidos AS p, vam_det_pedido AS det
    LEFT JOIN vam_ing_presentaciones AS pres ON pres.id = det.id_ing_presentacion
    LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = pres.cas_ingrediente
WHERE p.estado = 'p' AND det.id_prov_ing = 2;

--24 Proveedores dentro de contrato con un productor (aptos para solicitar pedidos)
SELECT prov.id, prov.nombre, prov.email, prov.telefono, prov.pag_web, pais.nombre, ing.cas, ing.nombre AS nombre_ing, ing.tipo AS tipo_ing, pres.volumen, pres.precio
FROM vam_proveedores AS prov
    LEFT JOIN vam_paises AS pais ON pais.id = prov.id_pais
    LEFT JOIN vam_ingrediente_esencias AS ing ON ing.id_proveedor = prov.id
    LEFT JOIN vam_ing_presentaciones AS pres ON ing.cas = pres.cas_ingrediente
WHERE prov.id IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'));


--CONTRATOS ACTIVOS de un PROD
SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month');


--PEDIDOS pendientes de un prov = 2 (Prov con contrato activo)
SELECT ped.id FROM vam_pedidos AS ped WHERE ped.id_prov = 2 AND ped.estado = 'p' AND ped.id_prov IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))

--Condiciones de todos los pedidos de un prov
SELECT condpe.id_pedido, condpe.id_contrato, condpe.id_cont_prov, condpe.id_cont_prod, condcon.id_form_pago, condcon.id_form_envio FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon WHERE condpe.id_cont_prov = 2 AND condpe.id_cond = condcon.id;

--Dame FP de pedidos de un prov = 2
SELECT condpe.id_pedido, condpe.id_contrato, condpe.id_cont_prov, condpe.id_cont_prod, condcon.id_form_pago, condcon.id_form_envio, fp.tipo FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon LEFT JOIN vam_forma_pagos AS fp ON condcon.id_form_pago = fp.id WHERE condcon.id_form_pago IS NOT NULL AND condpe.id_cont_prov = 2 AND condpe.id_cond = condcon.id;

21--INgredeintes y presetnacion de pedidos pendientes de un prov = 2 (con contrato activo)
SELECT p.id AS pedid, p.estado, p.f_emision, prod.nombre AS nom_prod, p.subtotal_usd, p.total_usd, ing.cas, ing.nombre AS nom_ing,  det.id AS id_det, det.cantidad, pres.volumen, pres.precio
FROM vam_pedidos AS p
    INNER JOIN vam_productores AS prod ON p.id_prod = prod.id
    INNER JOIN vam_det_pedido AS det ON det.id_pedido = p.id
    INNER JOIN vam_ing_presentaciones AS pres ON pres.id = det.id_ing_presentacion
    INNER JOIN vam_ingrediente_esencias AS ing ON ing.cas = pres.cas_ingrediente
WHERE p.estado = 'p' AND p.id = det.id_pedido AND p.id_prov = 2 AND det.id_prov_ing = p.id_prov AND p.id_prov IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))


21.1 --Dame FE de pedidos PENDIENTES de un prov = 2 (Prov con contrato activo)
SELECT condpe.id_pedido, fe.id, fe.tipo, pais.nombre AS nombre_pais
FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon
    INNER JOIN vam_forma_envios AS fe ON condcon.id_form_envio = fe.id
    INNER JOIN vam_paises AS pais ON pais.id = condcon.id_form_envio_pais
WHERE condcon.id_form_envio IS NOT NULL AND condpe.id_cont_prov = 2 AND condpe.id_cond = condcon.id AND  condpe.id_pedido IN (SELECT ped.id FROM vam_pedidos AS ped WHERE ped.id_prov = 2 AND ped.estado = 'p')
  AND condpe.id_cont_prov IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'));

21.2 --Dame FP de pedidos PENDIENTES de un prov = 2 (Prov con contrato activo)
SELECT condpe.id_pedido, fp.id, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago
FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon
    LEFT JOIN vam_forma_pagos AS fp ON condcon.id_form_pago = fp.id
WHERE condcon.id_form_pago IS NOT NULL AND condpe.id_cont_prov = 2 AND condpe.id_cond = condcon.id AND  condpe.id_pedido IN (SELECT ped.id FROM vam_pedidos AS ped WHERE ped.id_prov = 2 AND ped.estado = 'p')
  AND condpe.id_cont_prov IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'));


24--Proveedores activos con sus Ing y presentaciones para realizar pedido segun un prod (contratos activos con dicho prod = 2)
SELECT prov.id, prov.nombre AS nom_prov, prov.email, prov.telefono, prov.pag_web, pais.nombre AS nom_pais, ing.cas, ing.nombre AS nom_ing, ing.tipo, pres.volumen, pres.precio
FROM vam_mp_c AS mpc
    INNER JOIN vam_proveedores AS prov ON mpc.id_cont_prov = prov.id
    LEFT JOIN vam_paises AS pais ON pais.id = prov.id_pais
    LEFT JOIN vam_ingrediente_esencias AS ing ON mpc.cas = ing.cas
    LEFT JOIN vam_ing_presentaciones AS pres ON ing.cas = pres.cas_ingrediente
WHERE mpc.id_cont_prov = prov.id AND mpc.id_cont_prod = 1 AND mpc.id_cont_prov IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 1 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))

24.1--FE DE PROVs con contrato disponible con un prod = 1 (Prov con contrato activo)
SELECT fe.id_prov, fe.id AS id_fe, pais.nombre, fe.tipo, fe.cargo
FROM vam_fe_fp_c AS condc
    INNER JOIN vam_forma_envios AS fe ON condc.id_form_envio = fe.id
    INNER JOIN vam_paises AS pais ON pais.id = condc.id_form_envio_pais
WHERE condc.id_form_envio IS NOT NULL AND condc.id_prod_cont = 2 AND condc.id_prov_cont IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))

24.2--FP DE PROVs con contrato disponible con un prod = 2
SELECT fp.id_proveedor, fp.id AS id_fp, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago
FROM vam_fe_fp_c AS condc
    LEFT JOIN vam_forma_pagos AS fp ON condc.id_form_pago = fp.id
WHERE condc.id_form_pago IS NOT NULL AND condc.id_prod_cont = 2 AND condc.id_prov_cont IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))


--FP de un proveedor de acuerdo a un pedido (necesario para buscar información para realizar los pagos)
SELECT fp.id, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago, ped.subtotal_usd
FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon
    LEFT JOIN vam_forma_pagos AS fp ON condcon.id_form_pago = fp.id
    INNER JOIN vam_pedidos AS ped ON ped.id = 9
WHERE condpe.id_pedido = 9 AND condcon.id_form_pago IS NOT NULL AND condpe.id_cont_prov = 2 AND condpe.id_cond = condcon.id;



30.1--Información de evaluación de criterios (inicial)
SELECT eval.fecha_inicio, var.nombre_crit, var.descripcion, eval.peso
FROM vam_eval_criterios AS eval
    INNER JOIN vam_var_criterios AS var ON var.id = eval.id_var_crit
WHERE eval.id_prod = 4 AND eval.tipo_formula = 'i' AND eval.fecha_fin IS NULL;

30.2--Cantidad de pedidos desde la creación del contrato hasta hoy
SELECT count(ped)
FROM vam_contratos AS cont, vam_pedidos AS ped
WHERE cont.id = 1 AND ped.id_prod = 5 AND ped.id_prov = 4 AND ped.f_emision BETWEEN cont.fecha_emision AND current_date;


30.3--Escala activa de un productor
SELECT fecha_inicio, valor_min, valor_max
FROM vam_escalas
WHERE id_prod = 4 AND fecha_fin IS NULL;


--Queries de recomendador
--Datos principales del perfume
SELECT perf.id, perf.nombre, perf.genero, perf.rango_edad, perf.descrip_componentes, perf.tipo_estructura, perf.descrip_perf, perfum.id AS id_perfumista, perfum.nombre AS nom_perfumista, perfum.apellido, pais.nombre, perf_int.id AS id_perf_int, perf_int.tipo AS tipo_int, perf_int.porc_concentracion, perf_int.descripcion, pres.id AS id_pres, pres.volumen
FROM vam_perfumes AS perf
    INNER JOIN vam_perf_intensidades AS perf_int ON perf.id = perf_int.id_perfume
    INNER JOIN vam_presentaciones AS pres on perf_int.id = pres.id_perf_intensidad and perf_int.id_perfume = pres.id_perf
    INNER JOIN vam_p_p AS vpp on perf.id = vpp.id_perfume
    INNER JOIN vam_pefumistas AS perfum on perfum.id = vpp.id_perfumista
    INNER JOIN vam_paises AS pais ON pais.id = perfum.id_pais
WHERE perf.genero = 'f' AND perf.rango_edad = 'ate' AND perf_int.tipo = 'edp'

--REVISAR
--Caracter de acuerdo a un perfume
SELECT perf.id AS id_perf, pal.id AS id_pal_clave, pal.palabra
FROM vam_perfumes AS perf
    INNER JOIN vam_perf_intensidades AS perf_int ON perf.id = perf_int.id_perfume
    INNER JOIN vam_fo_principal AS princ ON princ.id_perf = perf.id
    INNER JOIN vam_f_fn AS fn ON fn.id_flia_olf = princ.id_flia_olf
    INNER JOIN vam_palabra_clave AS pal ON pal.id = fn.id_palabra_clave
WHERE pal.tipo_palabra = 'c' AND perf.genero = 'u' AND perf.rango_edad = 'ate' AND perf_int.tipo = 'edp'

--Información de perfume de acuerdo a los filtros de género, edad, intensidad y caracter
SELECT perf.id, perf.nombre, perf.genero, perf.rango_edad, perf.descrip_componentes, perf.tipo_estructura, perf.descrip_perf, perfum.id AS id_perfumista, perfum.nombre AS nom_perfumista, perfum.apellido, pais.nombre, perf_int.id AS id_perf_int, perf_int.tipo AS tipo_int, perf_int.porc_concentracion, perf_int.descripcion, pres.id AS id_pres, pres.volumen
FROM vam_perfumes AS perf
    INNER JOIN vam_perf_intensidades AS perf_int ON perf.id = perf_int.id_perfume
    INNER JOIN vam_presentaciones AS pres on perf_int.id = pres.id_perf_intensidad and perf_int.id_perfume = pres.id_perf
    INNER JOIN vam_p_p AS vpp on perf.id = vpp.id_perfume
    INNER JOIN vam_pefumistas AS perfum on perfum.id = vpp.id_perfumista
    INNER JOIN vam_paises AS pais ON pais.id = perfum.id_pais
    INNER JOIN vam_fo_principal AS princ ON princ.id_perf = perf.id
    INNER JOIN vam_f_fn AS fn ON fn.id_flia_olf = princ.id_flia_olf
    INNER JOIN vam_palabra_clave AS pal ON pal.id = fn.id_palabra_clave
WHERE perf.genero = 'u' AND perf.rango_edad = 'ate' AND perf_int.tipo = 'edp' AND pal.id IN (52,55,56,57,58,59)


