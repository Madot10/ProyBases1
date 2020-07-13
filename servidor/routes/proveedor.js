const express = require('express');
const router = express.Router();
const { ContratoProvCont }= require('../controllers/ContratoProvCont')

//Se crea clase Controller y se llaman a los métodos de esa clase
var contrato = new ContratoProvCont;

//Lista de contratos activos con sus formas de pago y envío de un proveedor
router.get('/:id_prov/contratos', contrato.getContratos);

//Lista de ingredientes en contratos activos de un proveedor
router.get('/:id_prov/contratos/ing', contrato.getIngCont);

module.exports = router;