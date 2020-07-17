<template>
    <b-container>
        <b-row class="main" align-v="center">
            <b-col cols="2"></b-col>
            <b-col>
                <b-card class="text-center">
                    <h1 class="text-primary font-weight-normal">
                        <b-icon icon="box-seam"></b-icon>
                        Sistema VAM
                    </h1>
                    <div v-if="mode_list">
                        <h4>
                            <b-icon
                                icon="chevron-left"
                                class="pointer"
                                @click="back_select"
                            ></b-icon>
                            {{ type_user == "prov" ? "Proveedores" : "Productores" }}
                        </h4>
                    </div>

                    <br />
                    <!--BOTONES DE TIPO-->
                    <div v-if="!mode_list">
                        <b-button
                            variant="outline-primary"
                            size="lg"
                            class="px-5 m-2"
                            @click="select_type_user('prov')"
                        >
                            <b-icon icon="truck" style="width: 3em; height: 3em;"></b-icon>
                            <br />
                            Proveedor
                        </b-button>
                        <b-button
                            variant="outline-primary"
                            size="lg"
                            class="px-5 m-2"
                            @click="select_type_user('prod')"
                        >
                            <b-icon icon="basket2" style="width: 3em; height: 3em;"></b-icon>
                            <br />
                            Productor
                        </b-button>
                    </div>

                    <!--LISTA DE USUARIOS SEGUN TIPO-->
                    <div v-else>
                        <div class="loader" v-show="isLoading">
                            <b-spinner label="Spinning"></b-spinner>
                        </div>
                        <b-list-group v-show="!isLoading">
                            <b-list-group-item
                                href="#"
                                v-for="u in list_users"
                                :key="u.id"
                                @click="click_user(u.id)"
                                >{{ u.nombre }}</b-list-group-item
                            >
                        </b-list-group>
                    </div>
                </b-card>
            </b-col>
            <b-col cols="2"></b-col>
        </b-row>
    </b-container>
</template>

<script>
export default {
    data() {
        return {
            mode_list: false,
            type_user: null,
            list_users: [],
            isLoading: false,
        };
    },
    methods: {
        select_type_user(type) {
            this.type_user = type;
            this.mode_list = true;
            this.isLoading = true;
            this.load_list_user();
        },
        back_select() {
            this.type_user = null;
            this.mode_list = false;
        },
        load_list_user() {
            let urlApi = "http://localhost:3000";

            if (this.type_user == "prov") {
                urlApi += "/provs";
            } else {
                urlApi += "/prods";
            }

            fetch(urlApi)
                .then(function(response) {
                    return response.json();
                })
                .then((res) => {
                    console.log("ADMIN ", res);
                    this.list_users = res.Proveedores || res.Productores;
                    this.isLoading = false;
                });
        },
        click_user(id) {
            if (this.type_user == "prov") {
                this.$router.push({ name: "HomeProv", params: { id } });
            } else {
                this.$router.push({ name: "HomeProd", params: { id } });
            }
        },
    },
};
</script>

<style>
body {
    background-color: var(--main-color-vam);
}

.main {
    height: 100vh;
}

.pointer {
    cursor: pointer;
}
</style>
