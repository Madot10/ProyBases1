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
            this.generarPerfumes(perfs);
            console.log("Mostrando perf ", perfs);
        },
        openModalDetalle(id) {
            this.perfume = this.perfumes[id];
            this.$bvModal.show("perf-det-modal");
        },
        generarPerfumes(perfs) {
            let perf_aux = [];
            perfs.forEach((per) => {
                if (perf_aux[per.id] == null) {
                    //Agregar perfume
                    perf_aux[per.id] = {
                        id: per.id,
                        nombre: per.nom_perf,
                        genero: per.genero,
                        rango_edad: per.rango_edad,
                        descrip_componentes: per.descrip_componentes,
                        tipo_estructura: per.tipo_estructura,
                        descrip_perf: per.descrip_perf,
                        id_perf_int: per.id_perf_int,
                        tipo_int: per.tipo_int,
                        porc_concentracion: per.porc_concentracion,
                        perfumistas: [],
                        presentaciones: [],
                    };
                }

                //Verificar perfumista
                if (perf_aux[per.id].perfumistas[per.id_perfumista] == null) {
                    //Agregar perfumista
                    perf_aux[per.id].perfumistas[per.id_perfumista] = {
                        id: per.id,
                        id_perfumista: per.id_perfumista,
                        nom_perfumista: per.nom_perfumista,
                        apellido: per.apellido,
                        pais: per.pais_origen,
                    };
                }

                //Verificar presentacion
                if (perf_aux[per.id].presentaciones[per.id_pres] == null) {
                    //Agregar presetnacion
                    perf_aux[per.id].presentaciones[per.id_pres] = {
                        id: per.id,
                        id_pres: per.id_pres,
                        volumen: Number(per.volumen),
                    };
                }
            });

            console.log("pre", perf_aux);

            let final_perf = [];

            perf_aux.forEach((p) => {
                let final_perfm = [];
                let final_pre = [];

                if (p) {
                    final_perf.push(p);

                    p.perfumistas.forEach((perfm) => {
                        if (perfm && p.id == perfm.id) {
                            final_perfm.push(perfm);
                        }
                    });
                    final_perf[final_perf.length - 1].perfumistas = final_perfm;

                    p.presentaciones.forEach((pres) => {
                        if (pres && p.id == pres.id) {
                            final_pre.push(pres);
                        }
                    });
                    final_perf[final_perf.length - 1].presentaciones = final_pre;
                }
            });

            this.perfumes = final_perf;
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
