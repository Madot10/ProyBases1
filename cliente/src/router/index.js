import Vue from "vue";
import VueRouter from "vue-router";
import Home from "../views/Home.vue";
import Login from "../views/Login.vue";

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
        name: "Administración",
        component: () => import("../views/admin.vue"),
    },
];

const router = new VueRouter({
    mode: "history",
    base: process.env.BASE_URL,
    routes,
});

export default router;
