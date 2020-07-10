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
