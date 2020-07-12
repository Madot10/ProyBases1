"use strict";
const { database } = require("../config/db.config");

class ContratoModel {
    //3.1
    getContratosSiendoProv(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT c.id, c.fecha_emision, c.exclusividad, c.clausula, c.fecha_cancelacion, c.motivo_cancel, c.quien_cancela, cond.id_form_envio, fe.id_pais, fe.tipo, fe.cargo, cond.id_form_pago, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago	FROM vam_contratos AS c, vam_fe_fp_c AS cond LEFT JOIN vam_forma_envios AS fe ON  fe.id = cond.id_form_envio LEFT JOIN vam_forma_pagos AS fp ON  fp.id = cond.id_form_pago WHERE c.id_prov = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '11 month' OR age(c.fecha_emision) <= '11 month')`,
                    [id_prov]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //4.1
    getContratosSiendoProd(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT c.id, c.fecha_emision, c.exclusividad, c.clausula, c.fecha_cancelacion, c.motivo_cancel, c.quien_cancela, cond.id_form_envio, fe.id_pais, fe.tipo, fe.cargo, cond.id_form_pago, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago	FROM vam_contratos AS c, vam_fe_fp_c AS cond LEFT JOIN vam_forma_envios AS fe ON  fe.id = cond.id_form_envio LEFT JOIN vam_forma_pagos AS fp ON  fp.id = cond.id_form_pago WHERE c.id_prod = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '11 month' OR age(c.fecha_emision) <= '11 month')`,
                    [id_prod]
                )
                .then(function (response) {
                    const prods = response.rows;
                    resolve(prods);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //3.2
    getIngContSiendoProv(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT c.id, ing.cas, ing.nombre, ing.tipo, ing.descripcion, ing.taxonomia, ing_pres.volumen, ing_pres.precio FROM vam_contratos AS c, vam_mp_c AS cond LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = cond.cas LEFT JOIN vam_ing_presentaciones AS ing_pres ON ing_pres.cas_ingrediente = cond.cas WHERE c.id_prov = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '11 month' OR age(c.fecha_emision) <= '11 month')`,
                    [id_prov]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //4.2
    getIngContSiendoProd(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT c.id, ing.cas, ing.nombre, ing.tipo, ing.descripcion, ing.taxonomia, ing_pres.volumen, ing_pres.precio FROM vam_contratos AS c, vam_mp_c AS cond LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = cond.cas LEFT JOIN vam_ing_presentaciones AS ing_pres ON ing_pres.cas_ingrediente = cond.cas WHERE c.id_prod = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '11 month' OR age(c.fecha_emision) <= '11 month')`,
                    [id_prod]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //12
    getContVencer(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT  c.id, c.fecha_emision, age(c.fecha_emision) AS tiempo_restante, c.exclusividad, c.clausula, cond.id_form_envio, fe.id_pais, fe.tipo, fe.cargo, cond.id_form_pago, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago FROM vam_contratos AS c, vam_fe_fp_c AS cond LEFT JOIN vam_forma_envios AS fe ON fe.id = cond.id_form_envio LEFT JOIN vam_forma_pagos AS fp ON fp.id = cond.id_form_pago WHERE c.id_prod = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) BETWEEN '11 month' AND '12 month' OR age(c.fecha_emision) BETWEEN '11 month' AND '12 month')`,
                    [id_prod]
                )
                .then(function (response) {
                    const prods = response.rows;
                    resolve(prods);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //12
    getIngContVencer(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT c.id, ing.cas, ing.nombre, ing.tipo, ing.descripcion, ing.taxonomia, ing_pres.volumen, ing_pres.precio FROM vam_contratos AS c, vam_mp_c AS cond LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = cond.cas LEFT JOIN vam_ing_presentaciones AS ing_pres ON ing_pres.cas_ingrediente = cond.cas WHERE c.id_prod = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) BETWEEN '11 month' AND '12 month' OR age(c.fecha_emision) BETWEEN '11 month' AND '12 month')`,
                    [id_prod]
                )
                .then(function (response) {
                    const prods = response.rows;
                    resolve(prods);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    updateCancelarContSiendoProv(id_prov, id_cont, motivo_cancel) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    "UPDATE vam_contratos SET fecha_cancelacion = current_date, motivo_cancel=$1, quien_cancela='prov' WHERE id = $2 AND id_prov = $3",
                    [motivo_cancel, id_cont, id_prov]
                )
                .then(function () {
                    resolve(true);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    updateCancelarContSiendoProd(id_prod, id_cont, motivo_cancel) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    "UPDATE vam_contratos SET fecha_cancelacion = current_date, motivo_cancel=$1, quien_cancela='prod' WHERE id = $2 AND id_prod = $3",
                    [motivo_cancel, id_cont, id_prod]
                )
                .then(function () {
                    resolve(true);
                })
                .catch((e) => console.error(e.stack));
        });
    }
}

module.exports = { ContratoModel };
