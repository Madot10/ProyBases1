'use strict';
const { PedidoProdModel } = require('../models/PedidoProdModel');

const pedido = new PedidoProdModel;

class PedidoProdCont {

	//Creación del pedido
	createPedido(req, res){
		//const { pedido } = req.body;
		const id_prov = req.params.id_prov;
		const id_prod = req.params.id_prod;

    //ejemplo de id_prov=1, id_prod=1
    
		var ped = {
			total_usd: 2999.99,
			cas: [8007805,8016635],
			id_pres: [1,4],
			cantidad: [1050,2000]
		}
		
		pedido.createPedido(id_prod,id_prov,ped)
			.then(res.status(200).json({message: 'Pedido creado con éxito'})
			)
			.catch(e => console.error(e.stack))
		
	}
	
	//Cancelar pedido siendo productor
	updateCancelarPedido(req, res){
    const { motivo_cancel } = req.body;
		const id_prod = req.params.id_prod;
		const id_ped = req.params.id_ped;

		pedido.updateCancelarPedido(id_prod,id_ped,motivo_cancel)
			.then(function(){res.status(200).json({message: 'Contrato cancelado con éxito'})})
			.catch(e => console.error(e.stack))
	}



}

module.exports = { PedidoProdCont };
