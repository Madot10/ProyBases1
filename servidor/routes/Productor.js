const express = require('express');
const router = express.Router();
const { ContratoProdCont }= require('../controllers/ContratoProdCont')

//Se crea clase Controller y se llaman a los métodos de esa clase
var contrato = new ContratoProdCont;

//Lista de contratos activos con sus formas de pago y envío de un productor
router.get('/:id_prod/contratos', contrato.getContratos);

//Lista de ingredientes en contratos activos de un productor
router.get('/:id_prod/contratos/ing', contrato.getIngCont);

//Lista de contratos por vencer con sus formas de pago y envío de un productor
router.get('/:id_prod/contratos/vencer', contrato.getContVencer);

//Lista de ingredientes en contratos por vencer de un productor
router.get('/:id_prod/contratos/ing/vencer', contrato.getIngContVencer);

//Cancelar un contrato
router.put('/:id_prod/contratos/:id_cont', contrato.updateCancelarCont);

//Lista de proveedores sin contrato con el productor
router.get('/:id_prod/contratos/nuevo', contrato.getContNuevo);

//Formas de Envio de la lista de proveedores sin contrato con el productor
router.get('/:id_prod/contratos/nuevo/fe', contrato.getContNuevoFe);

//Formas de pago de la lista de proveedores sin contrato con el productor
router.get('/:id_prod/contratos/nuevo/fp', contrato.getContNuevoFp);

//Ingredientes de la lista de proveedores sin contrato con el productor
router.get('/:id_prod/contratos/nuevo/ing', contrato.getContNuevoIng);

//Ingredientes de un proveedor disponibles para contratar (sin pedir exclusividad)
router.get('/:id_prod/contratos/nuevo/ing/:id_prov', contrato.getContNuevoListIng);

//Ingredientes de un proveedor disponibles para contratar (pidiendo exclusividad)
router.get('/:id_prod/contratos/nuevo/ing/exc/:id_prov', contrato.getContNuevoListIngExc);

//Creación del contrato
router.post('/:id_prod/contratos/nuevo/:id_prov', contrato.createContrato);

module.exports = router;