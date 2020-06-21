'use strict';
const { database } = require('../config/db.config');

class FormaPago{
  
  createFormaPago(tipo, porc_inicial, nro_cuotas, interes_mensual, nro_dia_entre_pago, id_proveedor){
    return new Promise((resolve, reject) => {

          database.query('INSERT INTO FORMA_PAGO (tipo, porc_inicial, nro_cuotas, interes_mensual, nro_dia_entre_pago, id_proveedor) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id', [tipo, porc_inicial, nro_cuotas, interes_mensual, nro_dia_entre_pago, id_proveedor])
						.then(function(response){
							const id = response.rows[0].id
							resolve(id)
						})
            .catch(e => console.error(e.stack))
    })
  }

  getFormaPago(id){
		return new Promise((resolve, reject) => {

			database.query('SELECT * FROM FORMA_PAGO WHERE id = $1', [id])
		    .then(response => {
		    	const prod = response.rows[0]
		    	resolve(prod)
		    })
        .catch(e => console.error(e.stack))
		})
  }

  getAll(id_prov){
		return new Promise((resolve, reject) => {
      
      database.query('SELECT * FROM FORMA_PAGO WHERE id_proveedor = $1 ORDER BY id DESC',  [id_prov])
			  .then(function(response){
				  const prods = response.rows
				  resolve(prods)
			  })
			  .catch(e => console.error(e.stack))
		})
	}

	updateFormaPago(id_pago, tipo, porc_inicial, nro_cuotas, interes_mensual, nro_dia_entre_pago){
		return new Promise((resolve, reject) => {

			database.query('UPDATE FORMA_PAGO SET tipo = $1, porc_inicial = $2, nro_cuotas = $3, interes_mensual = $4, nro_dia_entre_pago = $5 WHERE id = $6', [tipo, porc_inicial, nro_cuotas, interes_mensual, nro_dia_entre_pago, id_pago])
				.then(function(){resolve(true)})
        .catch(e => console.error(e.stack))
		})
	}
	
	deleteFormaPago(id_pago){
		return new Promise((resolve, reject) => {

			database.query('DELETE FROM FORMA_PAGO WHERE id = $1', [id_pago])
				.then(function(){resolve(true)})
        .catch(e => console.error(e.stack))
		})
  }
  
}

module.exports = { FormaPago };
