'use strict';
const { PedidoProvModel } = require('../models/PedidoProvModel');

const pedido = new PedidoProvModel;

class PedidoProvCont {
	
	//Cancelar pedido siendo proveedor
	updateCancelarPedido(req, res){
    const { motivo_cancel } = req.body;
		const id_prov = req.params.id_prov;
		const id_ped = req.params.id_ped;

		pedido.updateCancelarPedido(id_prov,id_ped,motivo_cancel)
			.then(function(){res.status(200).json({message: 'Contrato cancelado con éxito'})})
			.catch(e => console.error(e.stack))
	}

}

module.exports = { PedidoProvCont };
