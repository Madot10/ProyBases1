'use strict';
const { database } = require('../config/db.config');

//ARREGLAR
//Se generan el o los pagos
function generarPagos(id_prov, id_ped, fp) {
  return new Promise((resolve, reject) => {
    //Monto que irá cambiando por cada cálculo
    var monto = 0;
    //Número de la iteracción
    var i = 1;
    //fecha que irá cambiando para pagos a crédito
    var fecha;
    do{
      //Logica loca para crear las iteracciones de los pagos


      if(i === 1){
        database
            .query(
                `INSERT INTO vam_pagos(id_pedido, fecha, monto) VALUES ($1,current_date,$2)`,
                [id_ped,monto]
            )
            .then(function () {
                resolve(true);
            })
            .catch((e) => console.error(e.stack));
      }
      else{
        database
            .query(
                `INSERT INTO vam_pagos(id_pedido, fecha, monto) VALUES ($1,$2,$3)`,
                [id_ped,fecha,monto]
            )
            .then(function () {
                resolve(true);
            })
            .catch((e) => console.error(e.stack));
      }

    }while(fp.tipo !== 'cont');
  });
}

class PedidoProvModel{

  getPedidosPendientes(id_prov) {
    return new Promise((resolve, reject) => {
        database
            .query(
                `SELECT p.id, p.estado, p.f_emision, p.f_confirmacion, p.id_prod, p.total_usd, ing.cas, ing.nombre, pres.volumen
                FROM vam_pedidos AS p, vam_det_pedido AS det
                    LEFT JOIN vam_ing_presentaciones AS pres ON pres.id = det.id_ing_presentacion
                    LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = pres.cas_ingrediente
                WHERE p.estado = 'p' AND det.id_prov_ing = $1`,
                [id_prov]
            )
            .then(function (response) {
                const provs = response.rows;
                resolve(provs);
            })
            .catch((e) => console.error(e.stack));
    });
  }

  updateAprobarPedido(id_prov, id_ped, nro_factura) {
    return new Promise((resolve, reject) => {
        database
            .query(
                "UPDATE vam_pedidos SET estado = 'a', nro_factura = $1, f_confirmacion = current_date WHERE id = $2 AND id_prov = $3",
                [nro_factura, id_ped, id_prov]
            )
            .then(function () {
                resolve(true);
            })
            .catch((e) => console.error(e.stack));
    });
  }

  createPagosPedido(id_prov, id_ped) {
    return new Promise((resolve, reject) => {
        database
            .query(
                `INSERT INTO vam_contratos(id_prov,id_prod,fecha_emision,exclusividad,clausula) VALUES ($1,$2,current_date,$3,$4) RETURNING id`,
                [id_prov, id_prod, cont.exclusividad, cont.clausula]
            )
            .then(function (response) {
                const fp = response.rows;
                generarPagos(id_prov, id_ped, fp).then(() => {
                    resolve();
                });
            })
            .catch((e) => console.error(e.stack));
    });
  }

  updateCancelarPedido(id_prov, id_ped, motivo_cancel) {
    return new Promise((resolve, reject) => {
        database
            .query(
                "UPDATE vam_pedidos SET estado='anpv', motivo_cancel=$1 WHERE id = $2 AND id_prov = $3",
                [motivo_cancel, id_ped, id_prov]
            )
            .then(function () {
                resolve(true);
            })
            .catch((e) => console.error(e.stack));
    });
  }

}

module.exports = { PedidoProvModel };
