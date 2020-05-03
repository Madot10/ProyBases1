'use strict';
const { Productor } = require('../models/Productor');

const prod = new Productor();

class ProdController {

	create(req, res){
		const { nombre, contrasena, info_contacto, pagina_web } = req.body;

		prod.create(nombre, contrasena, info_contacto, pagina_web)
			.then(res.status(200).json({
					message: 'Productor creado con éxito',
					body: {
							Productor: {
                nombre, 
                contrasena, 
                info_contacto, 
                pagina_web
						}
					}
				})
			)
			.catch(e => console.error(e.stack))
	}

	getById(req, res){
		const id = req.params.id;

		prod.getById(id)
			.then(function(prodById){
				if(prodById){
					res.status(200).json({productor: prodById})
				}
				else {
					res.status(500).json({message: 'Productor no encontrado'})
				}
			})
			.catch(e => console.error(e.stack))
	}

  getAll(req,res){

		prod.getAll()
			.then(function(prods){ res.status(200).json({productores: prods})})
			.catch(e => console.error(e.stack))
	}

	update(req, res){
		const { nombre, contrasena, info_contacto, pagina_web } = req.body;
		const id = req.params.id;

		prod.update(id, nombre, contrasena, info_contacto, pagina_web)
			.then(function(prods){res.status(200).json('Productor actualizado con éxito')})
			.catch(e => console.error(e.stack))
	}

	delete(req, res){
		const id = req.params.id;

		prod.delete(id)
			.then(function(prods){res.status(200).json('Productor eliminado con éxito')})
			.catch(e => console.error(e.stack))
	}

}

module.exports = { ProdController };
