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
                        <b-list-group>
                            <b-list-group-item href="#">Awesome link</b-list-group-item>
                            <b-list-group-item href="#">Awesome link</b-list-group-item>
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
        };
    },
    methods: {
        select_type_user(type) {
            this.type_user = type;
            this.mode_list = true;
        },
        back_select() {
            this.type_user = null;
            this.mode_list = false;
        },
        test_click() {
            console.warn("YEI! Hiciste click");
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
