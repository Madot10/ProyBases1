"use strict";
const { database } = require("../config/db.config");

//Se ingresan las condiciones de forma de pago y de envío
function createInsertCondFeFp(id_pedido, id_prov, id_prod, pedido) {
    return new Promise((resolve, reject) => {
        database
            .query(
                `INSERT INTO vam_cond_pedido(id_pedido,id_cond,id_contrato,id_cont_prov,id_cont_prod) VALUES ($1,(SELECT condc.id FROM vam_fe_fp_c AS condc WHERE condc.id_prod_cont = $4 AND condc.id_prov_cont = $3 AND condc.id_form_envio = $5),$2,$3,$4),($1,(SELECT condc.id FROM vam_fe_fp_c AS condc WHERE condc.id_prod_cont = $4 AND condc.id_prov_cont = $3 AND condc.id_form_pago = $6),$2,$3,$4)`,
                [
                    id_pedido,
                    pedido.id_contrato,
                    id_prov,
                    id_prod,
                    pedido.id_fe_cond,
                    pedido.id_fp_cond,
                ]
            )
            .then(function () {
                resolve(true);
            })
            .catch((e) => console.error(e.stack));
    });
}

function createInsertDetPedido(id_pedido, id_prov, id_prod, pedido) {
    return new Promise((resolve, reject) => {
        for (var i = 0; pedido.cas[i] != null; i++) {
            console.log("Detalle de pedido ingresado:", i + 1);
            database
                .query(
                    `INSERT INTO vam_det_pedido(id_pedido,cantidad,id_ing_presentacion,cas_ingrediente,id_prov_ing) VALUES ($1,$2,$3,$4,$5)`,
                    [id_pedido, pedido.cantidad[i], pedido.id_pres[i], pedido.cas[i], id_prov]
                )
                .catch((e) => console.error(e.stack));
        }
        createInsertCondFeFp(id_pedido, id_prov, id_prod, pedido);
    });
}

class PedidoProdModel {
    //28
    createPedido(id_prod, id_prov, pedido) {
        console.log("Paso por aqui 2");
        return new Promise((resolve, reject) => {
            console.log("Paso por aqui 3");
            database
                .query(

                    `INSERT INTO vam_pedidos(f_emision,estado,id_prov,id_prod,subtotal_usd,total_usd) VALUES (current_date,'p',$1,$2,$3,$4) RETURNING id`,
                    [id_prov, id_prod,pedido.subtotal_usd,pedido.total_usd]

                )
                .then(function (response) {
                    const id_pedido = response.rows[0].id;
                    createInsertDetPedido(id_pedido, id_prov, id_prod, pedido).then(() => {
                        resolve();
                    });
                })
                .catch((e) => {
                    reject(e);
                    console.error(e.stack);
                });
        });
    }

    //24
    getProvsParaPedido(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT prov.id, mpc.id_contrato AS cont_id, prov.nombre AS nom_prov, prov.email, prov.telefono, prov.pag_web, pais.nombre AS nom_pais, ing.cas, pres.id AS presid, ing.nombre AS nom_ing, ing.tipo, pres.volumen, pres.precio
                    FROM vam_mp_c AS mpc
                        INNER JOIN vam_proveedores AS prov ON mpc.id_cont_prov = prov.id
                        LEFT JOIN vam_paises AS pais ON pais.id = prov.id_pais
                        LEFT JOIN vam_ingrediente_esencias AS ing ON mpc.cas = ing.cas
                        LEFT JOIN vam_ing_presentaciones AS pres ON ing.cas = pres.cas_ingrediente
                    WHERE mpc.id_cont_prov = prov.id AND mpc.id_cont_prod = $1 AND mpc.id_cont_prov IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = $1 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))`,
                    [id_prod]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //24.1
    getProvsParaPedidofe(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT fe.id_prov, fe.id AS id_fe, pais.nombre, fe.tipo, fe.cargo
                FROM vam_fe_fp_c AS condc
                    INNER JOIN vam_forma_envios AS fe ON condc.id_form_envio = fe.id
                    INNER JOIN vam_paises AS pais ON pais.id = condc.id_form_envio_pais
                WHERE condc.id_form_envio IS NOT NULL AND condc.id_prod_cont = $1 AND condc.id_prov_cont IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = $1 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))`,
                    [id_prod]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //24.2
    getProvsParaPedidofp(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT fp.id_proveedor, fp.id AS id_fp, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago
                FROM vam_fe_fp_c AS condc
                    LEFT JOIN vam_forma_pagos AS fp ON condc.id_form_pago = fp.id
                WHERE condc.id_form_pago IS NOT NULL AND condc.id_prod_cont = $1 AND condc.id_prov_cont IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = $1 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))`,
                    [id_prod]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //23
    getPedidos(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT p.id, p.estado, p.f_emision, p.f_confirmacion, p.nro_factura, p.id_prov, prov.nombre AS prov_nom, p.subtotal_usd, p.total_usd, ing.cas, ing.nombre AS ing_nom, det.id AS id_det, det.cantidad, pres.volumen, pres.precio
                    FROM vam_pedidos AS p
                        INNER JOIN vam_det_pedido AS det ON det.id_pedido = p.id
                        INNER JOIN vam_ing_presentaciones AS pres ON pres.id = det.id_ing_presentacion
                        INNER JOIN vam_ingrediente_esencias AS ing ON ing.cas = pres.cas_ingrediente
                        INNER JOIN vam_proveedores prov on ing.id_proveedor = prov.id
                    WHERE p.estado = 'a' AND det.id_pedido = p.id AND p.id_prod = $1`,
                    [id_prod]
                )
                .then(function (response) {
                    const prods = response.rows;
                    resolve(prods);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //23.1
    getPedidosfe(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT condpe.id_pedido, fe.id, fe.tipo, fe.cargo, pais.nombre AS nombre_pais
                    FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon
                        INNER JOIN vam_forma_envios AS fe ON condcon.id_form_envio = fe.id
                        INNER JOIN vam_paises AS pais ON pais.id = condcon.id_form_envio_pais
                    WHERE condcon.id_form_envio IS NOT NULL AND condpe.id_cont_prod = $1 AND condpe.id_cond = condcon.id AND  condpe.id_pedido IN (SELECT ped.id FROM vam_pedidos AS ped WHERE ped.id_prod = $1 AND ped.estado = 'a')`,
                    [id_prod]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //23.2
    getPedidosfp(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT condpe.id_pedido, fp.id, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago
                    FROM vam_cond_pedido AS condpe, vam_fe_fp_c AS condcon
                        LEFT JOIN vam_forma_pagos AS fp ON condcon.id_form_pago = fp.id
                    WHERE condcon.id_form_pago IS NOT NULL AND condpe.id_cont_prod = $1 AND condpe.id_cond = condcon.id AND  condpe.id_pedido IN (SELECT ped.id FROM vam_pedidos AS ped WHERE ped.id_prod = $1 AND ped.estado = 'a')`,
                    [id_prod]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //26
    updateCancelarPedido(id_prod, id_ped, motivo_cancel) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    "UPDATE vam_pedidos SET estado='anpd', motivo_cancel=$1 WHERE id = $2 AND id_prod = $3",
                    [motivo_cancel, id_ped, id_prod]
                )
                .then(function () {
                    resolve(true);
                })
                .catch((e) => console.error(e.stack));
        });
    }
}

module.exports = { PedidoProdModel };
