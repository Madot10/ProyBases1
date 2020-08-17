"use strict";
const { database } = require("../config/db.config");

//Se generan el o los pagos
function generarPagos(id_ped, fp) {
    return new Promise((resolve, reject) => {
        var i = true;
        var primer_pago = 0.0;
        var pagos = 0.0;
        var cuota = 0;

        do {
            //Primer pago
            if (i === true) {
                if (fp[0].tipo === "cred") {
                    primer_pago =
                        fp[0].subtotal_usd * (fp[0].porc_inicial / 100);
                    fp[0].nro_cuotas--;
                    console.log(primer_pago);
                    var resto =
                        fp[0].subtotal_usd -
                        primer_pago +
                        ((fp[0].subtotal_usd - primer_pago) *
                            fp[0].interes_mensual) /
                            100;
                    pagos = resto / fp[0].nro_cuotas;
                    console.log(pagos);
                } else {
                    primer_pago = fp[0].subtotal_usd;
                }
                i = false;
                console.log("realizó primer pago");
                database
                    .query(
                        `INSERT INTO vam_pagos(id_pedido, fecha, monto) VALUES ($1,current_date,$2)`,
                        [id_ped, primer_pago]
                    )
                    .then(function() {
                        resolve(true);
                    })
                    .catch((e) => console.error(e.stack));
            } else {
                fp[0].nro_cuotas--;
                cuota++;
                var dias = fp[0].nro_dia_entre_pago * cuota;
                database
                    .query(
                        `INSERT INTO vam_pagos(id_pedido, fecha, monto) VALUES ($1,now()+ interval '1 day' * $2,$3)`,
                        [id_ped, dias, pagos]
                    )
                    .then(function() {
                        resolve(true);
                    })
                    .catch((e) => console.error(e.stack));
            }
        } while (fp[0].tipo !== "cont" && fp[0].nro_cuotas !== 0);
    });
}

//25.2
function createPagosPedido(id_prov, id_ped) {
    return new Promise((resolve, reject) => {
        database
            .query(
                `SELECT fp.id, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago, ped.subtotal_usd
                FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon
                    LEFT JOIN vam_forma_pagos AS fp ON condcon.id_form_pago = fp.id
                    INNER JOIN vam_pedidos AS ped ON ped.id = $1
                WHERE condpe.id_pedido = $1 AND condcon.id_form_pago IS NOT NULL AND condpe.id_cont_prov = $2 AND condpe.id_cond = condcon.id`,
                [id_ped, id_prov]
            )
            .then(function(response) {
                var fp = response.rows;
                console.log(fp);
                generarPagos(id_ped, fp).then(() => {
                    resolve();
                });
            })
            .catch((e) => {
                reject(e);
                console.error(e.stack);
            });
    });
}

class PedidoProvModel {
    //22
    getPedidos(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT p.id AS pedid, p.estado, p.f_emision, prod.nombre AS nom_prod, p.subtotal_usd, p.total_usd, ing.cas, ing.nombre AS nom_ing,  det.id AS id_det, det.cantidad, pres.volumen, pres.precio
                    FROM vam_pedidos AS p
                        INNER JOIN vam_productores AS prod ON p.id_prod = prod.id
                        INNER JOIN vam_det_pedido AS det ON det.id_pedido = p.id
                        INNER JOIN vam_ing_presentaciones AS pres ON pres.id = det.id_ing_presentacion
                        INNER JOIN vam_ingrediente_esencias AS ing ON ing.cas = pres.cas_ingrediente
                    WHERE p.estado != 'p' AND det.id_pedido = p.id AND p.id_prov = $1`,
                    [id_prov]
                )
                .then(function(response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPedidosFe(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT condpe.id_pedido, fe.id, fe.tipo, fe.cargo, pais.nombre AS nombre_pais
                    FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon
                    INNER JOIN vam_pedidos AS p ON p.id_prod = condcon.id_prod_cont AND p.id_prov = condcon.id_prov_cont
                        INNER JOIN vam_forma_envios AS fe ON condcon.id_form_envio = fe.id
                        INNER JOIN vam_paises AS pais ON pais.id = condcon.id_form_envio_pais
                    WHERE condcon.id_form_envio IS NOT NULL AND condpe.id_cont_prov = $1 AND condpe.id_cond = condcon.id AND  p.estado != 'p';`,
                    [id_prov]
                )
                .then(function(response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPedidosFp(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT condpe.id_pedido, fp.id, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago
                    FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon
                    INNER JOIN vam_pedidos AS p ON p.id_prod = condcon.id_prod_cont AND p.id_prov = condcon.id_prov_cont
                        LEFT JOIN vam_forma_pagos AS fp ON condcon.id_form_pago = fp.id
                    WHERE condcon.id_form_pago IS NOT NULL AND condpe.id_cont_prov = $1 AND condpe.id_cond = condcon.id AND  p.estado != 'p';`,
                    [id_prov]
                )
                .then(function(response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //21
    getPedidosPendientes(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT p.id AS pedid, p.estado, p.f_emision, prod.nombre AS nom_prod, p.subtotal_usd, p.total_usd, ing.cas, ing.nombre AS nom_ing,  det.id AS id_det, det.cantidad, pres.volumen, pres.precio
                    FROM vam_pedidos AS p
                        INNER JOIN vam_productores AS prod ON p.id_prod = prod.id
                        INNER JOIN vam_det_pedido AS det ON det.id_pedido = p.id
                        INNER JOIN vam_ing_presentaciones AS pres ON pres.id = det.id_ing_presentacion
                        INNER JOIN vam_ingrediente_esencias AS ing ON ing.cas = pres.cas_ingrediente
                    WHERE p.estado = 'p' AND p.id = det.id_pedido AND p.id_prov = $1 AND det.id_prov_ing = p.id_prov AND p.id_prov IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = p.id_prod AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))`,
                    [id_prov]
                )
                .then(function(response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //21.1
    getPedidosPendientesfe(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT condpe.id_pedido, fe.id, fe.tipo, fe.cargo, pais.nombre AS nombre_pais
                FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon
                    INNER JOIN vam_forma_envios AS fe ON condcon.id_form_envio = fe.id
                    INNER JOIN vam_paises AS pais ON pais.id = condcon.id_form_envio_pais
                WHERE condcon.id_form_envio IS NOT NULL AND condpe.id_cont_prov = $1 AND condpe.id_cond = condcon.id AND  condpe.id_pedido IN (SELECT ped.id FROM vam_pedidos AS ped WHERE ped.id_prov = $1 AND ped.estado = 'p')
                  AND condpe.id_cont_prov IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = condpe.id_cont_prod AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))`,
                    [id_prov]
                )
                .then(function(response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //21.2
    getPedidosPendientesfp(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT condpe.id_pedido, fp.id, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago
                FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon
                    LEFT JOIN vam_forma_pagos AS fp ON condcon.id_form_pago = fp.id
                WHERE condcon.id_form_pago IS NOT NULL AND condpe.id_cont_prov = $1 AND condpe.id_cond = condcon.id AND  condpe.id_pedido IN (SELECT ped.id FROM vam_pedidos AS ped WHERE ped.id_prov = $1 AND ped.estado = 'p')
                  AND condpe.id_cont_prov IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = condpe.id_cont_prod AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))`,
                    [id_prov]
                )
                .then(function(response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //25.1
    updateAprobarPedido(id_prov, id_ped, nro_factura) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    "UPDATE vam_pedidos SET estado = 'a', nro_factura = $1, f_confirmacion = current_date WHERE id = $2 AND id_prov = $3",
                    [nro_factura, id_ped, id_prov]
                )
                .then(function() {
                    createPagosPedido(id_prov, id_ped).then(() => {
                        resolve();
                    });
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //26
    updateCancelarPedido(id_prov, id_ped, motivo_cancel) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    "UPDATE vam_pedidos SET estado='anpv', motivo_cancel=$1 WHERE id = $2 AND id_prov = $3",
                    [motivo_cancel, id_ped, id_prov]
                )
                .then(function() {
                    resolve(true);
                })
                .catch((e) => console.error(e.stack));
        });
    }
}

module.exports = { PedidoProvModel };
