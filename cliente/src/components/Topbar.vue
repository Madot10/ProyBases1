<template>
    <b-navbar variant="info" type="dark">
        <b-navbar-brand class="mb-0">{{ titulo }}</b-navbar-brand>
        <!-- <b-navbar-nav class="ml-auto">
            <b-nav-form
                ><b-button variant="outline-light" @click="cambiarTitulo" href="#"
                    ><b-icon icon="geo-alt"></b-icon
                ></b-button> </b-nav-form
        ></b-navbar-nav> -->
    </b-navbar>
</template>

<script>
export default {
    data() {
        return {
            esp: "El Perfumista",
            fr: "Le Parfumeur",
            mode: null,
            titulo: "",
        };
    },
    methods: {
        cambiarTitulo() {
            if (this.mode == "e") {
                this.mode = "f";
                this.titulo = this.fr;
            } else {
                this.mode = "e";
                this.titulo = this.esp;
            }
        },
    },
    created() {
        this.mode = "e";
        this.titulo = this.esp;
    },
};
</script>

<style></style>
