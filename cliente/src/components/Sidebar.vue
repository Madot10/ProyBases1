<template>
    <div class="sb-main">
        <div class="header pt-2">
            <h5 class="text-primary font-weight-normal text-center">
                <b-icon icon="box-seam"></b-icon>
                Sistema VAM
            </h5>
        </div>
        <hr />
        <b-row>
            <b-col>
                <div class="gestion-datos">
                    <ul class="ul-header" v-for="categ in select_navigation" :key="categ.icon">
                        <li class="text-primary">
                            <b-icon :icon="categ.icon"></b-icon> {{ categ.title }}
                        </li>
                        <ul class="ul-item">
                            <li v-for="(view, i) in categ.items" :key="i">
                                <router-link :to="view.link" class="li-link">{{
                                    view.item
                                }}</router-link>
                            </li>
                        </ul>
                    </ul>
                </div>
            </b-col>
        </b-row>
    </div>
</template>

<script>
export default {
    data() {
        return {
            navigation_prod: [
                {
                    title: "Pedidos",
                    icon: "card-list",
                    items: [
                        { item: "Ver todos", link: "/" },
                        { item: "Agregar nuevo", link: "/" },
                    ],
                },
                {
                    title: "Contratos",
                    icon: "file-earmark-check",
                    items: [
                        { item: "Ver todos", link: { name: "ContratosProd" } },
                        { item: "A vencer", link: { name: "ContratosVencer" } },
                        { item: "Agregar nuevo", link: { name: "ContratoNuevo" } },
                    ],
                },
                {
                    title: "Proveedores",
                    icon: "truck",
                    items: [
                        { item: "Ver todos", link: { name: "ListaProveedores" } },
                        { item: "Fórmulas de evaluar", link: "/" },
                    ],
                },
            ],
            navigation_prov: [
                {
                    title: "Pedidos",
                    icon: "card-list",
                    items: [
                        { item: "Ver todos", link: { name: "ContratosProv" } },
                        { item: "Ver pendientes", link: "/" },
                    ],
                },
                {
                    title: "Contratos",
                    icon: "file-earmark-check",
                    items: [{ item: "Ver todos", link: { name: "ContratosProv" } }],
                },
            ],
            select_navigation: [],
        };
    },
    methods: {
        getUserType(url) {
            if (url.includes("prod")) {
                return "prod";
            } else {
                return "prov";
            }
        },
    },
    created() {
        console.log("USER TYPE ", this.getUserType(this.$route.path));
        if (this.getUserType(this.$route.path) == "prov") {
            this.select_navigation = this.navigation_prov;
        } else {
            this.select_navigation = this.navigation_prod;
        }
    },
};
</script>

<style>
.sb-main {
    background-color: white;
    width: 100%;
    height: 100vh;
}

.ul-header,
.ul-item {
    font-size: 1em;
    list-style-type: none;
}

.ul-header {
    padding: 0 0 0 5px;
}

.ul-item {
    font-size: 0.9em;
    list-style-type: none;
}

.ul-item li {
    margin-bottom: 3px;
}

.li-link {
    color: black;
    text-decoration: none;
}

.li-link:hover {
    text-decoration: none;
}

.router-link-exact-active {
    color: var(--main-color-vam);
}
</style>
