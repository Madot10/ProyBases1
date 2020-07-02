const express = require('express');
const router = express.Router();
const { FormaPagoCont }= require('../controllers/FormaPagoCont')
const { ContratoCont }= require('../controllers/ContratoCont')

//Se crea clase Controller y se llaman a los métodos de esa clase
var formaPago = new FormaPagoCont;
var contrato = new ContratoCont;

//Lista de contratos de un proveedor
router.get('/:id_prov/contrato', contrato.getContratosSiendoProv);

//Formas de Pago
router.post('/:id_prov/forma_pago', formaPago.createFormaPago);
router.get('/:id_prov/forma_pago/:id_pago', formaPago.getFormaPago);
//Todos los pagos de un proveedor
router.get('/:id_prov/forma_pago', formaPago.getAll);
router.put('/:id_prov/forma_pago/:id_pago', formaPago.updateFormaPago);
router.delete('/:id_prov/forma_pago/:id_pago', formaPago.deleteFormaPago);

module.exports = router;