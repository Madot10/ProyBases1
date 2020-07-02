'use strict';
const { database } = require('../config/db.config');

class ContratoModel{

  getContratosSiendoProv(id_prov){
		return new Promise((resolve, reject) => {
      
			database.query('SELECT a.*, b.* FROM vam_contratos a, vam_ingrediente_esencias b, VAM_MP_C c INNER JOIN vam_contratos ON c.id_contrato=$1', [id_prov])
			  .then(function(response){
				  const prods = response.rows
				  resolve(prods)
			  })
        .catch(e => console.error(e.stack))
		})
  }
  
}

module.exports = { ContratoModel };
