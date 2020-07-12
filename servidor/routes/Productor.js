const express = require('express');
const router = express.Router();
const { ContratoCont }= require('../controllers/ContratoCont')

//Se crea clase Controller y se llaman a los métodos de esa clase
var contrato = new ContratoCont;

//Lista de contratos activos con sus formas de pago y envío de un productor
router.get('/:id_prod/contratos', contrato.getContratosSiendoProd);

//Lista de ingredientes en contratos activos de un productor
router.get('/:id_prod/contratos/ing', contrato.getIngContSiendoProd);

//Lista de contratos por vencer con sus formas de pago y envío de un productor
router.get('/:id_prod/contratos/vencer', contrato.getContVencer);

//Lista de ingredientes en contratos por vencer de un productor
router.get('/:id_prod/contratos/ing/vencer', contrato.getIngContVencer);


//Cancelar un contrato
router.put('/:id_prod/contrato/:id_cont', contrato.updateCancelarContSiendoProd);

module.exports = router;