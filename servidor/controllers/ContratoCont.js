'use strict';
const { ContratoModel } = require('../models/ContratoModel');

const contrato = new ContratoModel();

class ContratoCont {

  getContratosSiendoProv(req,res){
		const id_prov = req.params.id_prov;

		contrato.getContratosSiendoProv(id_prov)
			.then(function(contratos){ res.status(200).json({Info_Contratos: contratos})})
			.catch(e => console.error(e.stack))
	}

}

module.exports = { ContratoCont };
