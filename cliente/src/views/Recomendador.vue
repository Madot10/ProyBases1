<template>
    <div>
        <!--Header-->
        <top-bar></top-bar>

        <!--Contenido -->
        <div class="over">
            <!-- MODAL FILTROS -->
            <modal-recomendador @readyPerf="mostrarPerfumes"></modal-recomendador>

            <!-- MODAL DETALLE -->
            <modal-detalle-perfume :perfume="perfume"></modal-detalle-perfume>

            <div id="contenedor">
                <div class="grid">
                    <perfume-item
                        v-for="(p, i) in perfumes"
                        :key="i"
                        :class="i"
                        :style="`grid-area: f${(i % 3) + 1}${Math.round(i / 3) + 3}`"
                        :pid="i"
                        @open="openModalDetalle"
                    >
                    </perfume-item>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import TopBar from "../components/Topbar.vue";
import ModalRecomendador from "../components/ModalRecomendador.vue";
import PerfumeItem from "../components/PerfumeItem.vue";
import ModalDetallePerfume from "../components/ModalDetallePerfume.vue";

export default {
    components: {
        TopBar,
        ModalRecomendador,
        PerfumeItem,
        ModalDetallePerfume,
    },
    data() {
        return {
            perfumes: [],
            perfume: {},
        };
    },
    methods: {
        mostrarPerfumes(perfs) {
            this.perfumes = perfs;
            console.log("Mostrando perf ", perfs);
        },
        openModalDetalle(id) {
            this.perfume = this.perfumes[id];
            this.$bvModal.show("perf-det-modal");
        },
    },
};
</script>

<style>
.over {
    box-shadow: inset 0 0 0 1000px rgb(97 59 177 / 30%);
    min-height: 94vh;

    background-image: url("~@/assets/fondo-perfumista-2k.jpg");
    background-repeat: no-repeat;
    background-attachment: fixed;
    background-size: cover;

    padding-top: 6%;
}

#contenedor {
    width: 60%;

    margin: auto;

    /*background-color: #f0f8ff78;*/
    /*border: 4px solid red;*/
}

#contenedor .grid {
    display: grid;
    grid-gap: 12px 16px;
    grid-template-columns: repeat(10, 100px);
    grid-template-rows: repeat(3, 13vh);

    grid-template-areas:
        "f11 f12 f13 f14 f15 f16 f17 f18 f19 f10"
        "f21 f22 f23 f24 f25 f26 f27 f28 f29 f20"
        "f31 f32 f33 f34 f35 f36 f37 f38 f39 f30";
}
</style>
