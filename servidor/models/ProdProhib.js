'use strict';
const { database } = require('../config/db.config');

class ProdProhib {

  getAll(id_prov){
		return new Promise((resolve, reject) => {
      
      database.query('SELECT * FROM VAM_MP_PROHIBIDAS')
			  .then(function(response){
				  const prods = response.rows
				  resolve(prods)
			  })
			  .catch(e => console.error(e.stack))
		})
	}

  createProdProhib(cas,nombre){
    return new Promise((resolve, reject) => {

          database.query('INSERT INTO VAM_MP_PROHIBIDAS VALUES ($1, $2)', [cas, nombre])
						.then(function(response){
							const id = response.rows[0].cas
							resolve(id)
						})
            .catch(e => console.error(e.stack))
    })
  }

  updateProdProhib(nombre,id){
		return new Promise((resolve, reject) => {

			database.query('UPDATE VAM_MP_PROHIBIDAS SET nombre = $1 WHERE cas = $2', [nombre,id])
				.then(function(){resolve(true)})
        .catch(e => console.error(e.stack))
		})
	}

}

module.exports = { ProdProhib };
