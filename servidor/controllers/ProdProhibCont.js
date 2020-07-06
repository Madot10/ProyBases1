'use strict';
const { ProdProhib } = require('../models/ProdProhib');

const prod = new ProdProhib();

class ProdProhibCont {

  getAll(req,res){

		prod.getAll()
			.then(function(prods){ res.status(200).json({Productos_Prohibidos: prods})})
      .catch(e => console.error(e.stack))
      
  }
  
  createProdProhib(req, res){
		const { cas, nombre } = req.body;
    
    prod.createProdProhib(cas,nombre)
      .then(res.status(200).json({
          message: 'Producto creado con éxito',
            Producto_Prohibido: {
                cas,
                nombre
            }
          }
        )
      )
      .catch(e => console.error(e.stack))
  }
    
  updateProdProhib(req, res){
    const { nombre } = req.body;
		const id = req.params.id;

		prod.updateProdProhib(nombre,id)
			.then(function(prod){res.status(200).json({message: 'Producto actualizado con éxito'})})
			.catch(e => console.error(e.stack))
	}

}

module.exports = { ProdProhibCont };
