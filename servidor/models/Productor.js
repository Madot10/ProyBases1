'use strict';
const { database } = require('../config/db.config');

class Productor{
  
  create(nombre, contrasena, info_contacto, pagina_web){
    return new Promise((resolve, reject) => {

          database.query('INSERT INTO productores (nombre, contrasena, info_contacto, pagina_web) VALUES ($1, $2, $3, $4) RETURNING id', [nombre, contrasena, info_contacto, pagina_web])
						.then(function(response){
							const id = response.rows[0].id
							resolve(id)
						})
            .catch(e => console.error(e.stack))
    })
  }

  getById(id){
		return new Promise((resolve, reject) => {

			database.query('SELECT * FROM productores WHERE id = $1', [id])
		    .then(response => {
		    	const prod = response.rows[0]
		    	resolve(prod)
		    })
        .catch(e => console.error(e.stack))
		})
  }

  getAll(){
		return new Promise((resolve, reject) => {
      
      database.query('SELECT * FROM productores ORDER BY id DESC')
			  .then(function(response){
				  const prods = response.rows
				  resolve(prods)
			  })
			  .catch(e => console.error(e.stack))
		})
	}

	update(id, nombre, contrasena, info_contacto, pagina_web){
		return new Promise((resolve, reject) => {

			database.query('UPDATE productores SET nombre = $1, contrasena = $2, info_contacto = $3, pagina_web = $4 WHERE id = $5', [nombre, contrasena, info_contacto, pagina_web, id])
				.then(function(){resolve(true)})
        .catch(e => console.error(e.stack))
		})
	}
	
	delete(id){
		return new Promise((resolve, reject) => {

			database.query('DELETE FROM productores WHERE id = $1', [id])
				.then(function(){resolve(true)})
        .catch(e => console.error(e.stack))
		})
  }
  
}

module.exports = { Productor };
