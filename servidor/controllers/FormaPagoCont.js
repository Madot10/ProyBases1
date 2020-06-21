'use strict';
const { FormaPago } = require('../models/FormaPago');

const pago = new FormaPago();

class FormaPagoCont {

	createFormaPago(req, res){
		const { tipo, porc_inicial, nro_cuotas, interes_mensual, nro_dia_entre_pago } = req.body;
    const id_proveedor = req.params.id_prov;
    
		pago.createFormaPago(tipo, porc_inicial, nro_cuotas, interes_mensual, nro_dia_entre_pago, id_proveedor)
			.then(res.status(200).json({
					message: 'Forma de Pago creada con éxito',
					body: {
							Forma_Pago: {
                tipo, 
                porc_inicial, 
                nro_cuotas, 
                interes_mensual, 
                nro_dia_entre_pago,
                id_proveedor
						}
					}
				})
			)
			.catch(e => console.error(e.stack))
	}

	getFormaPago(req, res){
		const id = req.params.id_pago;

		pago.getFormaPago(id)
			.then(function(formaPago){
				if(formaPago){
					res.status(200).json({Forma_Pago: formaPago})
				}
				else {
					res.status(500).json({message: 'Forma de Pago no encontrada'})
				}
			})
			.catch(e => console.error(e.stack))
	}

  getAll(req,res){
    const id_prov = req.params.id_prov;

		pago.getAll(id_prov)
			.then(function(prods){ res.status(200).json({Formas_Pago: prods})})
			.catch(e => console.error(e.stack))
	}

	updateFormaPago(req, res){
    const {tipo, porc_inicial, nro_cuotas, interes_mensual, nro_dia_entre_pago} = req.body;
		const id_pago = req.params.id_pago;

		pago.updateFormaPago(id_pago, tipo, porc_inicial, nro_cuotas, interes_mensual, nro_dia_entre_pago)
			.then(function(pago){res.status(200).json({message: 'Forma de Pago actualizada con éxito'})})
			.catch(e => console.error(e.stack))
	}

	deleteFormaPago(req, res){
		const id_pago = req.params.id_pago;

		pago.deleteFormaPago(id_pago)
			.then(function(pago){res.status(200).json({message: 'Forma de Pago eliminada con éxito'})})
			.catch(e => console.error(e.stack))
	}

}

module.exports = { FormaPagoCont };
