'use strict';
const { PedidoProvModel } = require('../models/PedidoProvModel');

const pedido = new PedidoProvModel;

class PedidoProvCont {
	
	//Obtener pedidos pendientes
	getPedidosPendientes(req, res) {
		const id_prov = req.params.id_prov;

		pedido.getPedidosPendientes(id_prov)
				.then(function (pedidos) {
						res.status(200).json({ Info_Pedidos_Pendientes: pedidos });
				})
				.catch((e) => console.error(e.stack));
	}

	//Aprobar pedido
	updateAprobarPedido(req, res){
    const { nro_factura } = req.body;
		const id_prov = req.params.id_prov;
		const id_ped = req.params.id_ped;

		pedido.updateAprobarPedido(id_prov,id_ped,nro_factura)
			.then(function(){res.status(200).json({message: 'Contrato aprobado éxito'})})
			.catch(e => console.error(e.stack))
	}

	//Renovación del contrato
	createPagosPedido(req, res) {
		const id_prov = req.params.id_prov;
		const id_ped = req.params.id_ped;

		pedido.createPagosPedido(id_prov, id_ped)
				.then(res.status(200).json({ message: "Pagos generados con éxito" }))
				.catch((e) => {
						console.error(e.stack);
						res.status(500);
				});
}

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
