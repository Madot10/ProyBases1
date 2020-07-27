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
			id_contrato: 4,
			id_fe_cond: 8,
			id_fp_cond: 9,
			subtotal_usd: 2799.99,
			total_usd: 2999.99,
			cas: [142927],
			id_pres: [14],
			cantidad: [700]
		}
		
		pedido.createPedido(id_prod,id_prov,ped)
			.then(res.status(200).json({message: 'Pedido creado con éxito'})
			)
			.catch(e => console.error(e.stack))
		
	}

	//Lista de proveedores aptos para generar pedidos
	getProvsParaPedido(req, res){
		const id_prod = req.params.id_prod;

		pedido.getProvsParaPedido(id_prod)
		.then(function (provs) {
			res.status(200).json({ Lista_de_proveedores: provs });
		})
		.catch((e) => console.error(e.stack));
		
	}

	//Lista de fe de proveedores aptos para generar pedidos
	getProvsParaPedidofe(req, res){
		const id_prod = req.params.id_prod;

		pedido.getProvsParaPedidofe(id_prod)
		.then(function (provs) {
			res.status(200).json({ Lista_de_fe_proveedores: provs });
		})
		.catch((e) => console.error(e.stack));
		
	}

	//Lista de fp de proveedores aptos para generar pedidos
	getProvsParaPedidofp(req, res){
		const id_prod = req.params.id_prod;

		pedido.getProvsParaPedidofp(id_prod)
		.then(function (provs) {
			res.status(200).json({ Lista_de_fp_proveedores: provs });
		})
		.catch((e) => console.error(e.stack));
		
	}
	
	//Obtener pedidos aprobados
	getPedidos(req, res) {
		const id_prod = req.params.id_prod;

		pedido.getPedidos(id_prod)
				.then(function (pedidos) {
						res.status(200).json({ Info_Pedidos: pedidos });
				})
				.catch((e) => console.error(e.stack));
	}

	
	//Obtener fe pedidos aprobados
	getPedidosfe(req, res) {
		const id_prod = req.params.id_prod;

		pedido.getPedidosfe(id_prod)
				.then(function (pedidos) {
						res.status(200).json({ Info_Pedidos_Pendientes: pedidos });
				})
				.catch((e) => console.error(e.stack));
	}

	//Obtener fp pedidos aprobados
	getPedidosfp(req, res) {
		const id_prod = req.params.id_prod;

		pedido.getPedidosfp(id_prod)
				.then(function (pedidos) {
						res.status(200).json({ Info_Pedidos_Pendientes: pedidos });
				})
				.catch((e) => console.error(e.stack));
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
