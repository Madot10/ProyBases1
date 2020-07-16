'use strict';
const { database } = require('../config/db.config');


class PedidoProvModel{

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
