const express = require('express');
const router = express.Router();
const { ContratoCont }= require('../controllers/ContratoCont')

//Se crea clase Controller y se llaman a los métodos de esa clase
var contrato = new ContratoCont;

//Lista de contratos activos con sus formas de pago y envío de un proveedor
router.get('/:id_prov/contratos', contrato.getContratosSiendoProv);

//Lista de ingredientes en contratos activos de un proveedor
router.get('/:id_prov/contratos/ing', contrato.getIngContSiendoProv);

//Cancelar un contrato
router.put('/:id_prov/contratos/:id_cont', contrato.updateCancelarContSiendoProv);

module.exports = router;