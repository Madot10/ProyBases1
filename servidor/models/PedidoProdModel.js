'use strict';
const { database } = require('../config/db.config');


function createInsertDetPedido(id_pedido,id_prov,pedido) {
    
  return new Promise((resolve, reject) => {
      for(var i=0; pedido.cas[i] != null; i++){
          console.log('Detalle de pedido ingresado:', i+1)
          database
          .query(
              `INSERT INTO vam_det_pedido(id_pedido,cantidad,id_ing_presentacion,cas_ingrediente,id_prov_ing) VALUES ($1,$2,$3,$4,$5)`,
              [id_pedido,pedido.cantidad[i],pedido.id_pres[i],pedido.cas[i],id_prov]
          )
          .then(function () {
              resolve(true);
          })
          .catch((e) => console.error(e.stack));

      }
  });
}


class PedidoProdModel{

    createPedido(id_prod, id_prov, pedido) {
    
      return new Promise((resolve, reject) => {
         
         database
         .query(
             `INSERT INTO vam_pedidos(f_emision,estado,id_prov,id_prod,total_usd) VALUES (current_date,'p',$1,$2,$3) RETURNING id`,
             [id_prov,id_prod,pedido.total_usd]
         )
         .then(function (response) {
              const id_pedido = response.rows[0].id
              createInsertDetPedido(id_pedido,id_prov,pedido)
          })
          .catch((e) => console.error(e.stack));
      });
  }

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
