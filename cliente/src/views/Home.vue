<template>
    <card-main>
        <template v-slot:title>Inicio</template>
        <template v-slot:content>
            <b-jumbotron
                header="¡Bienvenido!"
                lead="Sistema VAM para gestión de Registro de Proveedores, Evaluación y Compra."
            >
            </b-jumbotron>
        </template>
    </card-main>
</template>

<script>
import CardMain from "../components/CardMain.vue";

export default {
    components: {
        CardMain,
    },
};
</script>
