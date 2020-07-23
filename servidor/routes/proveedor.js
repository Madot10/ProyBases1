const express = require("express");
const router = express.Router();
const { ContratoProvCont } = require("../controllers/ContratoProvCont");
const { PedidoProvCont } = require("../controllers/PedidoProvCont");

//Se crea clase Controller y se llaman a los métodos de esa clase
const contrato = new ContratoProvCont();
const pedido = new PedidoProvCont();

//Contratos
//Lista de contratos activos con sus formas de pago y envío de un proveedor
router.get("/:id_prov/contratos", contrato.getContratos);

//Lista de ingredientes en contratos activos de un proveedor
router.get("/:id_prov/contratos/ing", contrato.getIngCont);

//Pedidos
//Lista de pedidos aprobados
router.get("/:id_prov/pedidos", pedido.getPedidos)

//Pedidos pendientes por confirmar por el proveedor
router.get("/:id_prov/pedidos/pendientes", pedido.getPedidosPendientes)

//Fe de pedidos pendientes por confirmar
router.get("/:id_prov/pedidos/pendientes/fe", pedido.getPedidosPendientesfe)

//Fp de pedidos pendientes por confirmar
router.get("/:id_prov/pedidos/pendientes/fp", pedido.getPedidosPendientesfp)

//Para aprobar pedido, se requieren de un post y de un put
//Aprobar pedido
router.post("/:id_prov/pedido/aprobar/:id_ped", pedido.updateAprobarPedido);

//Cancelar pedido siendo proveedor
router.put("/:id_prov/pedido/cancelar/:id_ped", pedido.updateCancelarPedido);

module.exports = router;
