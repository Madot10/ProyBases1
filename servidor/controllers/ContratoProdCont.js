'use strict';
const { ContratoProdModel } = require('../models/ContratoProdModel');

const contrato = new ContratoProdModel();

class ContratoProdCont {

	//Lista de contratos activos con sus formas de pago y envío de un productor
	getContratos(req,res){
		const id_prod = req.params.id_prod;

		contrato.getContratos(id_prod)
			.then(function(contratos){ res.status(200).json({Info_Contratos: contratos})})
			.catch(e => console.error(e.stack))
	}

	//Lista de ingredientes en contratos activos de un productor
	getIngCont(req,res){
		const id_prod = req.params.id_prod;

		contrato.getIngCont(id_prod)
			.then(function(ingred){ res.status(200).json({Ingredientes_Contratos: ingred})})
			.catch(e => console.error(e.stack))
	}

	//Lista de contratos por vencer con sus formas de pago y envío de un productor
	getContVencer(req,res){
		const id_prod = req.params.id_prod;

		contrato.getContVencer(id_prod)
			.then(function(contratos){ res.status(200).json({Info_Contratos: contratos})})
			.catch(e => console.error(e.stack))
	}

	//Lista de ingredientes en contratos por vencer de un productor
	getIngContVencer(req,res){
		const id_prod = req.params.id_prod;

		contrato.getIngContVencer(id_prod)
			.then(function(ingred){ res.status(200).json({Ingredientes_Contratos: ingred})})
			.catch(e => console.error(e.stack))
	}

	//Cancelar contrato
	updateCancelarCont(req, res){
    const { motivo_cancel, quien_cancela } = req.body;
		const id_cont = req.params.id_cont;
		const id_prod = req.params.id_prod;

		contrato.updateCancelarCont(id_prod,id_cont,motivo_cancel,quien_cancela)
			.then(function(){res.status(200).json({message: 'Contrato cancelado con éxito'})})
			.catch(e => console.error(e.stack))
	}

	//Lista de proveedores sin contrato con el productor
	getContNuevo(req,res){
		const id_prod = req.params.id_prod;

		contrato.getContNuevo(id_prod)
			.then(function(provs){ res.status(200).json({Lista_de_proveedores: provs})})
			.catch(e => console.error(e.stack))
	}

	//Formas de Envio de la lista de proveedores sin contrato con el productor
	getContNuevoFe(req,res){
		const id_prod = req.params.id_prod;

		contrato.getContNuevoFe(id_prod)
			.then(function(fes){ res.status(200).json({Lista_de_formas_de_envio: fes})})
			.catch(e => console.error(e.stack))
	}

	//Formas de pago de la lista de proveedores sin contrato con el productor
	getContNuevoFp(req,res){
		const id_prod = req.params.id_prod;

		contrato.getContNuevoFp(id_prod)
			.then(function(fps){ res.status(200).json({Lista_de_formas_de_pago: fps})})
			.catch(e => console.error(e.stack))
	}

	//Ingredientes de la lista de proveedores sin contrato con el productor
	getContNuevoIng(req,res){
		const id_prod = req.params.id_prod;

		contrato.getContNuevoIng(id_prod)
			.then(function(ingreds){ res.status(200).json({Lista_de_ingredientes: ingreds})})
			.catch(e => console.error(e.stack))
	}

	//Ingredientes de un proveedor disponibles para contratar (sin pedir exclusividad)
	getContNuevoListIng(req,res){
		const id_prov = req.params.id_prov;

		contrato.getContNuevoListIng(id_prov)
			.then(function(ingreds){ res.status(200).json({Lista_de_proveedores: ingreds})})
			.catch(e => console.error(e.stack))
	}
	
	//Ingredientes de un proveedor disponibles para contratar (pidiendo exclusividad)
	getContNuevoListIngExc(req,res){
		const id_prov = req.params.id_prov;

		contrato.getContNuevoListIngExc(id_prov)
			.then(function(ingreds){ res.status(200).json({Lista_de_proveedores: ingreds})})
			.catch(e => console.error(e.stack))
	}

	//Creación del contrato
	createContrato(req, res){
		const { cont } = req.body;
		const id_prov = req.params.id_prov;
		const id_prod = req.params.id_prod;

		//ejemplo de id_prov=4, id_prod=2
		/*
		var cont = {
			clausula: "prueba de clausula",
			exclusividad: false,
			cas: [110383,8007010],
			id_fp: [7],
			id_fe: [8,9],
			id_pais: [12,179]
		}
		*/

		contrato.createContrato(id_prod,id_prov,cont)
			.then(res.status(200).json({message: 'Contrato creado con éxito'})
			)
			.catch(e => console.error(e.stack))
		
	}

}

module.exports = { ContratoProdCont };
