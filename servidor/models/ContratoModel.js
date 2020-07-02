'use strict';
const { database } = require('../config/db.config');

class ContratoModel{

  getContratosSiendoProv(id_prov){
		return new Promise((resolve, reject) => {
      
      database.query('SELECT * FROM VAM_CONTRATOS WHERE id_prov=$1', [id_prov])
			  .then(function(response){
				  const prods = response.rows
				  resolve(prods)
			  })
        .catch(e => console.error(e.stack))
        //Como consultar los ingredientes, de acuerdo a la entidad VAM_MP_C
        database.query('SELECT * FROM VAM_INGREDIENTE_ESENCIAS WHERE id_prov=$1', [id_prov])
			  .then(function(response){
				  const prods = response.rows
				  resolve(prods)
			  })
			  .catch(e => console.error(e.stack))
		})
  }
  
}

module.exports = { ContratoModel };
