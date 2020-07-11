--SELECT CONDICIONES DE UN CONTRATO
SELECT * FROM vam_contratos AS c, vam_fe_fp_c AS cond  WHERE  cond.id_contrato = c.id;

-- SELECT PARA TENER FE Y FP DADO UN CONTRATO
SELECT * FROM vam_contratos AS c, vam_fe_fp_c AS cond LEFT JOIN vam_forma_envios AS fe ON  fe.id = cond.id_form_envio LEFT JOIN vam_forma_pagos AS fp ON  fp.id = cond.id_form_pago WHERE c.id = 1 AND cond.id_contrato = c.id
--c.id AS ContratoID, cond.id_form_envio As FormaEnvioID, cond.id_form_pago AS FormaPagoID, fe.id AS FEID, fp.id AS FPIS

--SELECT PRODUCTOS CONTRATADOS
SELECT  * FROM vam_contratos AS c, vam_mp_c AS mpcont WHERE c.id = mpcont.id_contrato;

--SELCT CONTRATOS CON MENOS DE 1 ano segun fecha emsion
SELECT  c.id, c.fecha_emision, age(fecha_emision) AS Diff FROM vam_contratos AS c WHERE age(c.fecha_emision) <= '11 month';

--SELECT CONTRATOS ACTIVOS (USANDO SUBQUERY)
SELECT  c.id AS id_contrato, c.fecha_emision FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '11 month' OR age(c.fecha_emision) <= '11 month');

--SELECT DATOS FE Y FP DE TODOS CONTRATOS ACTIVOS (SUB QUERY)
SELECT c.id AS ContratoID, cond.id_form_envio As FormaEnvioID, cond.id_form_pago AS FormaPagoID, fe.id AS FEID, fp.id AS FPIS FROM vam_contratos AS c, vam_fe_fp_c AS cond LEFT JOIN vam_forma_envios AS fe ON  fe.id = cond.id_form_envio LEFT JOIN vam_forma_pagos AS fp ON  fp.id = cond.id_form_pago WHERE cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '11 month' OR age(c.fecha_emision) <= '11 month');

--PROVEEDORES SIN CONTRATO CON UN PRODUCTOR DADO
SELECT prov.id AS provId FROM vam_proveedores As prov WHERE  NOT exists(SELECT * FROM vam_contratos As c WHERE c.id_prov = prov.id AND c.id_prod = 1)

--SECLT PRoveedores libres para hacer contrato con un Prod dado = 1
SELECT prov.id AS provId FROM vam_proveedores As prov WHERE  NOT exists(SELECT * FROM vam_contratos As c WHERE c.id_prov = prov.id AND c.id_prod = 1) UNION SELECT prov.id AS provId FROM vam_proveedores As prov, vam_contratos As c WHERE c.id_prov = prov.id AND c.id_prod = 1 AND (c.fecha_cancelacion IS NOT NULL OR (age(c.fecha_emision) >= '12 month' AND age(COALESCE((SELECT MAX(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id AND c.id_prod = 1 GROUP BY r.id_contrato), now() - interval '13 month')) >= '12 month'));

--SELECT (una vez)Pares Proveedores que entregan a Productores segun FE y Sedes DADO un productor 'and sedes.id_productor = 1"
SELECT DISTINCT prov.id AS provid, sedes.id_productor AS prodId FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 1;

-- DAME LOS PROVEEDORES DISPONIBLES Y CON CAPACIDAD DE ENVIO
SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 1) AND NOT exists(SELECT * FROM vam_contratos As c WHERE c.id_prov = prov.id AND c.id_prod = 1) UNION SELECT prov.id AS provId FROM vam_proveedores As prov, vam_contratos As c WHERE c.id_prov = prov.id AND c.id_prod = 1 AND (c.fecha_cancelacion IS NOT NULL OR (age(c.fecha_emision) >= '12 month' AND age(COALESCE((SELECT MAX(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id AND c.id_prod = 1 GROUP BY r.id_contrato), now() - interval '13 month')) >= '12 month'));

--LISTA HISTORICO DADO UN PROV = 1
SELECT prov.id AS provId, ifra.fecha_inicio, ifra.fecha_fin FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE prov.id = 1 AND ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL;

-- DAME LOS PROVEEDORES DISPONIBLES, CON CAPACIDAD DE ENVIO Y IFRA ACTIVO
SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = 1) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND NOT exists(SELECT * FROM vam_contratos As c WHERE c.id_prov = prov.id AND c.id_prod = 1) UNION SELECT prov.id AS provId FROM vam_proveedores As prov, vam_contratos As c WHERE c.id_prov = prov.id AND c.id_prod = 1 AND (c.fecha_cancelacion IS NOT NULL OR (age(c.fecha_emision) >= '12 month' AND age(COALESCE((SELECT MAX(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id AND c.id_prod = 1 GROUP BY r.id_contrato), now() - interval '13 month')) >= '12 month'));

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
SELECT mpcont.id_contrato, mpcont.cas, cont.id, cont.id_prov FROM vam_contratos AS cont, vam_mp_c AS mpcont WHERE mpcont.id_contrato = cont.id AND cont.exclusividad = TRUE AND mpcont.id_contrato IN (SELECT c.id AS id_contrato FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '11 month' OR age(c.fecha_emision) <= '11 month'))

-- Ingredientes disponibles para contratar No exclusivos dado un PROV=3
SELECT 3 AS provId, ing.nombre, ing.tipo, ing.cas FROM vam_ingrediente_esencias AS ing WHERE ing.id_proveedor = 3 AND ing.cas NOT IN (SELECT mpcont.cas FROM vam_contratos AS cont, vam_mp_c AS mpcont WHERE mpcont.id_contrato = cont.id AND cont.exclusividad = TRUE AND mpcont.id_contrato IN (SELECT c.id AS id_contrato FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '11 month' OR age(c.fecha_emision) <= '11 month')))

--Ing contratados en contratos activos => Ing activos
SELECT  mpcont.cas FROM vam_contratos AS c, vam_mp_c AS mpcont WHERE c.id = mpcont.id_contrato AND c.id IN(SELECT  c.id AS id_contrato FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '11 month' OR age(c.fecha_emision) <= '11 month'))

-- Ing disponibles para contratar en contrato exclusivo dado un Prov=5
SELECT 5 AS provId, ing.nombre, ing.tipo, ing.cas FROM vam_ingrediente_esencias AS ing WHERE ing.id_proveedor = 5 AND ing.cas NOT IN (SELECT  mpcont.cas FROM vam_contratos AS c, vam_mp_c AS mpcont WHERE c.id = mpcont.id_contrato AND c.id IN(SELECT  c.id AS id_contrato FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '11 month' OR age(c.fecha_emision) <= '11 month')))

--SELECT CONTRATOS ACTIVOS (USANDO SUBQUERY) A PUNTO DE VENCER (RANGO entre 11 y 12meses) de un prod = 1
SELECT  c.id AS id_contrato, c.fecha_emision, c.id_prod,age(c.fecha_emision) FROM vam_contratos AS c WHERE c.id_prod = 1 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) BETWEEN '11 month' AND '12 month' OR age(c.fecha_emision) BETWEEN '11 month' AND '12 month');
