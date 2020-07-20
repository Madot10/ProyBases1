import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);

const routes = [
    {
        //Recomendador?
        path: "/",
        name: "Home",
        redirect: { name: "admin" },
    },
    {
        path: "/admin",
        name: "admin",
        component: () => import("../views/admin.vue"),
    },
    /*RUTAS PROVEEDOR */
    {
        path: "/prov/:id",
        component: () => import("../views/MainView.vue"),
        children: [
            {
                name: "HomeProv",
                path: "",
                component: () => import("../views/Home.vue"),
            },
            {
                name: "ContratosProv",
                path: "contratos",
                component: () => import("../views/Contratos.vue"),
            },
            {
                name: "PedidosProv",
                path: "pedidos",
                component: () => import("../views/Pedidos.vue"),
            },
            {
                name: "PedidosPendientes",
                path: "pedidos/pendientes",
                component: () => import("../views/Pedidos.vue"),
            },
        ],
    },

    /*RUTAS PRODUCTOR */
    {
        path: "/prod/:id",
        component: () => import("../views/MainView.vue"),
        children: [
            {
                name: "HomeProd",
                path: "",
                component: () => import("../views/Home.vue"),
            },
            {
                name: "ListaProveedores",
                path: "proveedores",
                component: () => import("../views/ListaProveedores.vue"),
            },
            {
                name: "ContratosProd",
                path: "contratos",
                component: () => import("../views/Contratos.vue"),
            },
            {
                name: "ContratosVencer",
                path: "contratos/vencer",
                component: () => import("../views/Contratos.vue"),
            },
            {
                name: "ContratoNuevo",
                path: "contratos/nuevo",
                component: () => import("../views/NuevoContrato.vue"),
            },
            {
                name: "DetalleContrato",
                path: "contratos/nuevo/:id_prov",
                component: () => import("../views/DetalleContrato.vue"),
                props: true,
            },
            {
                name: "PedidosProd",
                path: "pedidos",
                component: () => import("../views/Pedidos.vue"),
            },
            {
                name: "PedidosNuevo",
                path: "pedidos/nuevo",
                component: () => import("../views/NuevoPedido.vue"),
            },
            {
                name: "PedidosDetalle",
                path: "pedidos/nuevo/:id_prov",
                component: () => import("../views/DetallePedido.vue"),
                props: true,
            },
        ],
    },

    /* 404 => REDIRECT  */
    {
        path: "*",
        redirect: { name: "admin" },
    },
];

const router = new VueRouter({
    mode: "history",
    base: process.env.BASE_URL,
    routes,
});

export default router;
