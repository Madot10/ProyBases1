'use strict';
const { database } = require('../config/db.config');

class ContratoModel{

  getContratosSiendoProv(id_prov){
		return new Promise((resolve, reject) => {
      
			database.query('SELECT * FROM vam_contratos AS c, vam_fe_fp_c AS cond LEFT JOIN vam_forma_envios AS fe ON  fe.id = cond.id_form_envio LEFT JOIN vam_forma_pagos AS fp ON  fp.id = cond.id_form_pago WHERE c.id_prov = $1 AND cond.id_contrato = c.id ORDER BY c.id', [id_prov])
			  .then(function(response){
					const prods = response.rows
					console.log(prods)
				  resolve(prods)
			  })
        .catch(e => console.error(e.stack))
		})
  }
  
}

module.exports = { ContratoModel };
