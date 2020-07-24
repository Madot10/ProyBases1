const express = require("express");
const router = express.Router();
const { ContratoProdCont } = require("../controllers/ContratoProdCont");
const { HomeCont } = require("../controllers/HomeCont");
const { PedidoProdCont } = require("../controllers/PedidoProdCont");
const { EvalProdCont } = require("../controllers/EvalProdCont");

//Se crea clase Controller y se llaman a los métodos de esa clase
const contrato = new ContratoProdCont();
const home = new HomeCont();
const pedido = new PedidoProdCont();
const eval = new EvalProdCont();

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
//Creación del pedido
router.post("/:id_prod/pedido/nuevo/:id_prov", pedido.createPedido);

//Lista de proveedores aptos para generar pedidos
router.get("/:id_prod/pedido/nuevo", pedido.getProvsParaPedido);

//Lista de fe de proveedores aptos para generar pedidos
router.get("/:id_prod/pedido/nuevo/fe", pedido.getProvsParaPedidofe);

//Lista de fp de proveedores aptos para generar pedidos
router.get("/:id_prod/pedido/nuevo/fp", pedido.getProvsParaPedidofp);

//Lista de pedidos aprobados
router.get("/:id_prod/pedidos", pedido.getPedidos);

//Fe de pedidos aprobados
router.get("/:id_prod/pedidos/fe", pedido.getPedidosfe);

//Fp de pedidos aprobados
router.get("/:id_prod/pedidos/fp", pedido.getPedidosfp);

//Cancelar pedido siendo productor
router.put("/:id_prod/pedido/cancelar/:id_ped", pedido.updateCancelarPedido);

//Evaluación de Proveedores
//Guardar puntaje obtenido según tipo de evaluación
router.post("/:id_prod/eval/result/:id_prov", eval.guardarResultadoEval);

//Crear Variable
router.post("/variable/crear", eval.createVariable);

//Listar escalas
router.get("/:id_prod/escalas", eval.getEscalas);

//Crear Escala
router.post("/:id_prod/escala/crear", eval.createEscala);

//Vencer Escala
router.put("/:id_prod/escala/vencer", eval.updateEscala);

//Crear evaluación de criterios y vencer otras
router.post("/:id_prod/evaluacion_criterios", eval.createEvalCriterios);

//Variables de evaluación inicial
router.get("/evaluacion/inicial/variables", eval.getVarInicial);

//Información de evaluación de criterios (inicial)
router.get("/:id_prod/evaluacion_criterios/inicial", eval.getEvalCritInicial);

//Información de evaluación de criterios (renov)
router.get("/:id_prod/evaluacion_criterios/renovacion", eval.getEvalCritRenov);

//Información de evaluación de criterios (renovación)
//Cantidad de pedidos desde la creación del contrato hasta hoy
router.get(
    "/:id_prod/evaluacion_criterios/renovacion/all/:id_prov/:id_contrato",
    eval.getEvalCritRenovPedidos
);

//Cantidad de pedidos APROBADOS desde la creación del contrato hasta hoy
router.get(
    "/:id_prod/evaluacion_criterios/renovacion/:id_prov/:id_contrato",
    eval.getEvalCritRenovPedidosAprobados
);
module.exports = router;
