<template>
    <div>
        <!--Header-->
        <top-bar></top-bar>

        <!--Contenido -->
        <div class="over">
            <modal-recomendador :show="true"></modal-recomendador>
        </div>
    </div>
</template>

<script>
import TopBar from "../components/Topbar.vue";
import ModalRecomendador from "../components/ModalRecomendador.vue";

export default {
    components: {
        TopBar,
        ModalRecomendador,
    },
    data() {
        return {};
    },
};
</script>

<style>
.over {
    box-shadow: inset 0 0 0 1000px rgb(97 59 177 / 30%);
    min-height: 100vh;

    background-image: url("~@/assets/fondo-perfumista-2k.jpg");
    background-repeat: no-repeat;
    background-attachment: fixed;
    background-size: cover;
}
</style>
