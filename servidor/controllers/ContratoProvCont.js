'use strict';
const { ContratoProvModel } = require('../models/ContratoProvModel');

const contrato = new ContratoProvModel();

class ContratoProvCont {

  //Lista de contratos activos con sus formas de pago y envío de un proveedor
  getContratos(req,res){
    const id_prov = req.params.id_prov;

    contrato.getContratos(id_prov)
      .then(function(contratos){ res.status(200).json({Info_Contratos: contratos})})
      .catch(e => console.error(e.stack))
  }

  //Lista de ingredientes en contratos activos de un proveedor
	getIngCont(req,res){
		const id_prov = req.params.id_prov;

		contrato.getIngContSiendoProv(id_prov)
			.then(function(ingred){ res.status(200).json({Ingredientes_Contratos: ingred})})
			.catch(e => console.error(e.stack))
	}

}

module.exports = { ContratoProvCont };
