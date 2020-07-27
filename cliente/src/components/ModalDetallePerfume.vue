<template>
    <b-modal id="perf-det-modal" centered size="xl" :title="perfume.nombre">
        <!-- CONTENIDO MODAL -->
        <b-container fluid>
            <b-row>
                <!--IMAGEN -->
                <b-col cols="4">
                    <b-img></b-img>
                </b-col>

                <!--CONTENIDO -->
                <b-col cols="8">
                    <!-- DATOS BASICOS -->
                    <div>
                        <h5>Detalles</h5>
                        <p>Tipo: {{ getTextEst(perfume.tipo_estructura) }}</p>
                        <p>Género: {{ getTextGenero(perfume.genero) }}</p>
                        <p>Rango de edad: {{ getTextoEda(perfume.rango_edad) }}</p>
                        <p class="p-indent">{{ perfume.descrip_perf }}</p>
                    </div>

                    <!-- Perfumistas -->
                    <div>
                        <h5>Perfumista</h5>
                        <ul>
                            <li v-for="(perfm, i) in perfume.perfumistas" :key="i">
                                {{ perfm.nom_perfumista }} {{ perfm.apellido }} ({{ perfm.pais }})
                            </li>
                        </ul>
                    </div>

                    <!-- Presentaciones -->
                    <div>
                        <h5>Presentaciones</h5>
                        <p>
                            <b-badge
                                v-for="(pres, j) in perfume.presentaciones"
                                :key="j"
                                pill
                                variant="info"
                                class="mr-1"
                            >
                                {{ pres.volumen }}ml</b-badge
                            >
                        </p>
                    </div>

                    <!-- Componentes -->
                    <div>
                        <h5>Componentes</h5>
                        <p>{{ perfume.descrip_componentes }}</p>
                    </div>
                </b-col>
            </b-row>
        </b-container>

        <!-- FOOTER -->
        <template v-slot:modal-footer>
            <span></span>
        </template>
    </b-modal>
</template>

<script>
export default {
    props: ["perfume"],
    methods: {
        getTextGenero(codG) {
            switch (codG) {
                case "f":
                    return "Femenino";
                    break;
                case "m":
                    return "Masculino";
                    break;

                case "u":
                    return "Unisex";
                    break;
                default:
                    break;
            }
        },
        getTextoEda(valueEdad) {
            switch (valueEdad) {
                case "adu":
                    return "Adulto";
                    break;

                case "ate":
                    return "Atemporal";
                    break;

                case "inf":
                    return "Infantil";
                    break;
                case "juv":
                    return "Juvenil";
                    break;
                default:
                    break;
            }
        },
        getTextEst(est) {
            switch (est) {
                case "m":
                    return "Monolítico";
                    break;
                case "f":
                    return "Por fases";
                    break;
                default:
                    break;
            }
        },
    },
};
</script>

<style>
.p-indent {
    text-indent: 1em;
}
</style>
