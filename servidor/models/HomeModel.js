'use strict';
const { database } = require('../config/db.config');

class HomeModel{

  getAllProd(){
		return new Promise((resolve, reject) => {
      
      database.query('SELECT id,nombre FROM VAM_PRODUCTORES')
			  .then(function(response){
				  const prods = response.rows
				  resolve(prods)
			  })
			  .catch(e => console.error(e.stack))
		})
  }
  
  getAllProv(){
		return new Promise((resolve, reject) => {
      
      database.query('SELECT id,nombre FROM VAM_PROVEEDORES')
			  .then(function(response){
				  const provs = response.rows
				  resolve(provs)
			  })
			  .catch(e => console.error(e.stack))
		})
  }
  
}

module.exports = { HomeModel };
