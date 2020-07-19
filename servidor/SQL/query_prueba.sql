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

--6 -- DAME LOS PROVEEDORES DISPONIBLES, CON CAPACIDAD DE ENVIO Y IFRA ACTIVO
SELECT prov.id AS provId, pais.nombre AS paisnombre, prov.nombre, prov.email, prov.telefono, prov.pag_web FROM vam_proveedores As prov, vam_paises AS pais WHERE prov.id_pais = pais.id AND prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 2) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'));

--6.1 --DAME DATO PROV Y FE con PAIS NOMBRE
SELECT prov.id AS provId, fe.id, fe.tipo, fe.cargo, p.nombre, p.id AS paisId FROM vam_proveedores AS prov INNER JOIN vam_forma_envios AS fe ON fe.id_prov = prov.id INNER JOIN vam_paises AS p ON p.id = fe.id_pais WHERE prov.id IN (SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 1) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))

--6.2 --DAME DATO PROV Y FP
SELECT prov.id AS provId, fp.id, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago FROM vam_proveedores AS prov INNER JOIN vam_forma_pagos AS fp ON fp.id_proveedor = prov.id WHERE prov.id IN(SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 1) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))

--  6.3 -- DAME LOS ING Y PRESENTACIONES
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




--REVISAR DE AQUI PARA ABAJO
--porfanomeodienlosquieromucho

--Formas de Pago de acuerdo al pedido y el id_prov
SELECT fp.id, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago
FROM vam_cond_pedido AS cond
    LEFT JOIN vam_forma_pagos AS fp ON cond.id_cond = fp.id
WHERE cond.id_pedido = 9 AND fp.id_proveedor = 3;

--Forma de pago de pedido pendiente
SELECT p.id, fp.id AS id_fp, fp.tipo AS tipofp, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago
                FROM vam_pedidos AS p, vam_fe_fp_c AS fefp
                    LEFT JOIN vam_forma_pagos AS fp ON fp.id = fefp.id_form_pago
                    LEFT JOIN vam_cond_pedido AS cond ON cond.id_cond = fefp.id_form_pago
                WHERE p.estado = 'p' AND cond.id_pedido = p.id AND p.id_prov = 2 AND fefp.id_prov_fp = 2;

--Forma de de envio de pedido pendiente
SELECT p.id, fe.id AS id_fe, fe.cargo, fe.tipo AS tipofe, fe.id_pais
                FROM vam_pedidos AS p, vam_fe_fp_c AS fefp
                    LEFT JOIN vam_forma_envios AS fe ON fe.id = fefp.id_form_envio
                    LEFT JOIN vam_cond_pedido AS cond ON cond.id_cond = fefp.id_form_envio
                WHERE p.estado = 'p' AND cond.id_pedido = p.id AND p.id_prov = 2 AND fefp.id_prov_fe = 2;

--Arreglar para que salgan las fe y fp que estén en los contratos
--24.1 fe y fp de Proveedores dentro de contrato con un productor (aptos para solicitar pedidos)
SELECT prov.id, fp.id AS fp_id, fp.tipo AS tipo_fp, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago, fe.id AS fe_id, pais.nombre AS nombre_pais, fe.tipo AS tipo_fe, fe.cargo
FROM vam_proveedores AS prov, vam_fe_fp_c AS fefpc
    LEFT JOIN vam_forma_pagos AS fp ON fp.id = fefpc.id_form_pago
    LEFT JOIN vam_forma_envios AS fe ON fe.id = fefpc.id_form_envio
    LEFT JOIN vam_paises AS pais ON pais.id = fe.id_pais
WHERE prov.id IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = 2 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'));


