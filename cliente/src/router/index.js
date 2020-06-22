import Vue from "vue";
import VueRouter from "vue-router";
import Home from "../views/Home.vue";

Vue.use(VueRouter);

const routes = [
    {
        //Recomendador?
        path: "/",
        name: "Home",
        component: Home,
    },
    {
        path: "/admin",
        name: "admin",
        component: () => import("../views/Admin.vue"),
    },
    /*RUTAS PROVEEDOR */
    {
        path: "/prov",
        component: () => import("../views/MainView.vue"),
    },

    /*RUTAS PRODUCTOR */
    {
        path: "/prod",
        component: () => import("../views/MainView.vue"),
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
