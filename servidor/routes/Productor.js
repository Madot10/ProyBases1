const express = require("express");
const router = express.Router();
const { ContratoProdCont } = require("../controllers/ContratoProdCont");
const { HomeCont } = require("../controllers/HomeCont");
const { PedidoProdCont } = require("../controllers/PedidoProdCont");

//Se crea clase Controller y se llaman a los métodos de esa clase
const contrato = new ContratoProdCont();
const home = new HomeCont();
const pedido = new PedidoProdCont();

//Home
//Lista de proveedores con IFRA activo
router.get("/:id_prod/proveedores", home.getProvs);

//Lista de formas de envío de proveedores con IFRA activo
router.get("/:id_prod/proveedores/fe", home.getProvsfe);

//Lista de formas de pago de proveedores con IFRA activo
router.get("/:id_prod/proveedores/fp", home.getProvsfp);

//Contrato
//Lista de contratos activos con sus formas de pago y envío de un productor
router.get("/:id_prod/contratos", contrato.getContratos);

//Lista de ingredientes en contratos activos de un productor
router.get("/:id_prod/contratos/ing", contrato.getIngCont);

//Lista de contratos por vencer con sus formas de pago y envío de un productor
router.get("/:id_prod/contratos/vencer", contrato.getContVencer);

//Lista de ingredientes en contratos por vencer de un productor
router.get("/:id_prod/contratos/ing/vencer", contrato.getIngContVencer);

//Cancelar un contrato
router.put("/:id_prod/contratos/:id_cont", contrato.updateCancelarCont);

//Lista de proveedores sin contrato con el productor
router.get("/:id_prod/contratos/nuevo", contrato.getContNuevo);

//Formas de Envio de la lista de proveedores sin contrato con el productor
router.get("/:id_prod/contratos/nuevo/fe", contrato.getContNuevoFe);

//Formas de pago de la lista de proveedores sin contrato con el productor
router.get("/:id_prod/contratos/nuevo/fp", contrato.getContNuevoFp);

//Ingredientes de la lista de proveedores sin contrato con el productor
router.get("/:id_prod/contratos/nuevo/ing", contrato.getContNuevoIng);

//Ingredientes de un proveedor disponibles para contratar (sin pedir exclusividad)
router.get("/:id_prod/contratos/nuevo/ing/:id_prov", contrato.getContNuevoListIng);

//Ingredientes de un proveedor disponibles para contratar (pidiendo exclusividad)
router.get("/:id_prod/contratos/nuevo/ing/exc/:id_prov", contrato.getContNuevoListIngExc);

//Creación del contrato
router.post("/:id_prod/contratos/nuevo/:id_prov", contrato.createContrato);

//Renovación de un contrato
router.post("/:id_prod/contratos/:id_contrato/renovar/:id_prov", contrato.renovarContrato);

//Pedido
//Crear del pedido
router.post("/:id_prod/pedido/nuevo/:id_prov", pedido.createPedido);

//Cancelar pedido siendo productor
router.put("/:id_prod/pedido/cancelar/:id_ped", pedido.updateCancelarPedido);

module.exports = router;
