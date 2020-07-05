import Vue from "vue";
import VueRouter from "vue-router";
import Home from "../views/Home.vue";

Vue.use(VueRouter);

const routes = [
    {
        //Recomendador?
        path: "/",
        name: "Home",
    },
    {
        path: "/admin",
        name: "admin",
        component: () => import("../views/Admin.vue"),
    },
    /*RUTAS PROVEEDOR */
    {
        path: "/prov/:id",
        component: () => import("../views/MainView.vue"),
        children: [
            {
                path: "",
                component: () => import("../views/Home.vue"),
            },
            {
                name: "ContratosProv",
                path: "contratos",
                component: () => import("../views/Contratos.vue"),
            },
        ],
    },

    /*RUTAS PRODUCTOR */
    {
        path: "/prod/:id",
        component: () => import("../views/MainView.vue"),
        children: [
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
