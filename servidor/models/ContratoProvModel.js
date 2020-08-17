"use strict";
const { database } = require("../config/db.config");

class ContratoProvModel {
    //3.1
    getContratos(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT prod.nombre AS prodnombre, c.id, c.fecha_emision, c.exclusividad, c.clausula, c.fecha_cancelacion, c.motivo_cancel, c.quien_cancela, cond.id_form_envio, p.nombre, fe.tipo AS fe_tipo, fe.cargo, cond.id_form_pago, fp.tipo AS fp_tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago
                  FROM vam_contratos AS c, vam_fe_fp_c AS cond
                  LEFT JOIN  vam_productores AS prod ON prod.id = cond.id_prod_cont
                    LEFT JOIN vam_forma_envios AS fe ON  fe.id = cond.id_form_envio
                    LEFT JOIN vam_paises AS p ON p.id = fe.id_pais
                    LEFT JOIN vam_forma_pagos AS fp ON  fp.id = cond.id_form_pago
                  WHERE c.id_prov = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')`,
                    [id_prov]
                )
                .then(function(response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //3.2
    getIngCont(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT c.id, ing.cas, ing.nombre, ing.tipo, ing.descripcion, ing.taxonomia, ing_pres.volumen, ing_pres.precio FROM vam_contratos AS c, vam_mp_c AS cond LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = cond.cas LEFT JOIN vam_ing_presentaciones AS ing_pres ON ing_pres.cas_ingrediente = cond.cas WHERE c.id_prov = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')`,
                    [id_prov]
                )
                .then(function(response) {
                    const provs = response.rows;

                    resolve(provs);
                })
                .catch((e) => {
                    console.error(e.stack);
                    reject(e);
                });
        });
    }
}

module.exports = { ContratoProvModel };
