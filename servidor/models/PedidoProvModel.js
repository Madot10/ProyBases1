'use strict';
const { database } = require('../config/db.config');

//Se generan el o los pagos
function generarPagos(id_prov, id_ped, fp) {
  return new Promise((resolve, reject) => {
    //fp.id, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago, fp.subtotal_usd
    
    //Primer_pago
    var i = true;
    var primer_pago = 0.0;
    var pagos = 0.0;
    var cuota = 0;

    do{
      //Logica loca para crear las iteracciones de los pagos


      if(i === true){
        if(fp.tipo === 'cred'){
            primer_pago = fp.subtotal_usd *((fp.porc_inicial)/100);
            fp.nro_cuotas--;
            console.log(primer_pago);
            pagos = (fp.subtotal_usd - primer_pago)/(fp.nro_cuotas - 1);
            console.log(pagos);
        }
        else{
            primer_pago = fp.subtotal_usd;
        }
        i = false;

        database
            .query(
                `INSERT INTO vam_pagos(id_pedido, fecha, monto) VALUES ($1,current_date,$2)`,
                [id_ped,fecha_pago,primer_pago]
            )
            .then(function () {
                resolve(true);
            })
            .catch((e) => console.error(e.stack));
      }
      else{
        fp.nro_cuotas--;
        cuota++;

        database
            .query(
                `INSERT INTO vam_pagos(id_pedido, fecha, monto) VALUES ($1,current_date + concat($3' days'),$2)`,
                [id_ped,pagos,fp.nro_dia_entre_pago*cuota]
            )
            .then(function () {
                resolve(true);
            })
            .catch((e) => console.error(e.stack));
      }

    }while(fp.tipo !== 'cont' && fp.nro_cuotas !== 0);
  });
}

class PedidoProvModel{
  //22
  getPedidos(id_prov) {
    return new Promise((resolve, reject) => {
        database
            .query(
                `SELECT p.id, p.estado, p.f_emision, p.f_confirmacion, p.id_prod, p.total_usd, ing.cas, ing.nombre, pres.volumen
                FROM vam_pedidos AS p, vam_det_pedido AS det
                    LEFT JOIN vam_ing_presentaciones AS pres ON pres.id = det.id_ing_presentacion
                    LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = pres.cas_ingrediente
                WHERE p.estado = 'a' AND det.id_prov_ing = $1 AND p.id_prov = $1`,
                [id_prov]
            )
            .then(function (response) {
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
                `SELECT p.id, p.estado, p.f_emision, p.f_confirmacion, p.id_prod, p.total_usd, ing.cas, ing.nombre, pres.volumen
                FROM vam_pedidos AS p, vam_det_pedido AS det
                    LEFT JOIN vam_ing_presentaciones AS pres ON pres.id = det.id_ing_presentacion
                    LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = pres.cas_ingrediente
                WHERE p.estado = 'p' AND det.id_prov_ing = $1 AND p.id_prov = $1`,
                [id_prov]
            )
            .then(function (response) {
                const provs = response.rows;
                resolve(provs);
            })
            .catch((e) => console.error(e.stack));
    });
  }
  //21.1
  getPedidosPendientesfefp(id_prov) {
    return new Promise((resolve, reject) => {
        database
            .query(
                `SCRIPT ESTÁN EN sql_pruebas`,
                [id_prov]
            )
            .then(function (response) {
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
            .then(function () {
                resolve(true);
            })
            .catch((e) => console.error(e.stack));
    });
  }
  //25.2
  createPagosPedido(id_prov, id_ped) {
    return new Promise((resolve, reject) => {
        database
            .query(
                `LO NECESITO PARA PRUEBAS DE PAGO :'C`,
                [id_prov, id_ped]
            )
            .then(function (response) {
                const fp = response.rows;
                console.log(fp);
                generarPagos(id_prov, id_ped, fp).then(() => {
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
            .then(function () {
                resolve(true);
            })
            .catch((e) => console.error(e.stack));
    });
  }

}

module.exports = { PedidoProvModel };
