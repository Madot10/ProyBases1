'use strict';
const { PedidoProvModel } = require('../models/PedidoProvModel');

const pedido = new PedidoProvModel;

class PedidoProvCont {
	
	//Obtener pedidos aprobados
	getPedidos(req, res) {
		const id_prov = req.params.id_prov;

		pedido.getPedidos(id_prov)
				.then(function (pedidos) {
						res.status(200).json({ Info_Pedidos: pedidos });
				})
				.catch((e) => console.error(e.stack));
	}

	//Obtener pedidos pendientes
	getPedidosPendientes(req, res) {
		const id_prov = req.params.id_prov;

		pedido.getPedidosPendientes(id_prov)
				.then(function (pedidos) {
						res.status(200).json({ Info_Pedidos_Pendientes: pedidos });
				})
				.catch((e) => console.error(e.stack));
	}

	//Obtener fe pedidos pendientes
	getPedidosPendientesfe(req, res) {
		const id_prov = req.params.id_prov;

		pedido.getPedidosPendientesfe(id_prov)
				.then(function (pedidos) {
						res.status(200).json({ Info_Pedidos_Pendientes: pedidos });
				})
				.catch((e) => console.error(e.stack));
	}

	//Obtener fp pedidos pendientes
	getPedidosPendientesfp(req, res) {
		const id_prov = req.params.id_prov;

		pedido.getPedidosPendientesfp(id_prov)
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
			.then(function(){res.status(200).json({message: 'Pedido aprobado con éxito y pagos generados'})})
			.catch(e => console.error(e.stack))
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
