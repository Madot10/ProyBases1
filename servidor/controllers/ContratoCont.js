'use strict';
const { ContratoModel } = require('../models/ContratoModel');

const contrato = new ContratoModel();

class ContratoCont {
	
	//Lista de contratos activos con sus formas de pago y envío de un proveedor
  getContratosSiendoProv(req,res){
		const id_prov = req.params.id_prov;

		contrato.getContratosSiendoProv(id_prov)
			.then(function(contratos){ res.status(200).json({Info_Contratos: contratos})})
			.catch(e => console.error(e.stack))
	}

	//Lista de contratos activos con sus formas de pago y envío de un productor
	getContratosSiendoProd(req,res){
		const id_prod = req.params.id_prod;

		contrato.getContratosSiendoProd(id_prod)
			.then(function(contratos){ res.status(200).json({Info_Contratos: contratos})})
			.catch(e => console.error(e.stack))
	}

	//Lista de ingredientes en contratos activos de un proveedor
	getIngContSiendoProv(req,res){
		const id_prov = req.params.id_prov;

		contrato.getIngContSiendoProv(id_prov)
			.then(function(ingred){ res.status(200).json({Ingredientes_Contratos: ingred})})
			.catch(e => console.error(e.stack))
	}

	//Lista de ingredientes en contratos activos de un productor
	getIngContSiendoProd(req,res){
		const id_prod = req.params.id_prod;

		contrato.getIngContSiendoProd(id_prod)
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

	//Cancelar contrato siendo proveedor
	updateCancelarContSiendoProv(req, res){
    const { motivo_cancel } = req.body;
		const id_cont = req.params.id_cont;
		const id_prov = req.params.id_prov;

		contrato.updateCancelarContSiendoProv(id_prov,id_cont,motivo_cancel)
			.then(function(){res.status(200).json({message: 'Contrato cancelado con éxito'})})
			.catch(e => console.error(e.stack))
	}

	//Cancelar contrato siendo productor
	updateCancelarContSiendoProd(req, res){
    const { motivo_cancel } = req.body;
		const id_cont = req.params.id_cont;
		const id_prod = req.params.id_prod;

		contrato.updateCancelarContSiendoProd(id_prod,id_cont,motivo_cancel)
			.then(function(){res.status(200).json({message: 'Contrato cancelado con éxito'})})
			.catch(e => console.error(e.stack))
	}

}

module.exports = { ContratoCont };
