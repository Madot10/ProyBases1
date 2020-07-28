<template>
    <b-modal id="perf-det-modal" centered size="xl" :title="perfume.nombre">
        <!-- CONTENIDO MODAL -->
        <b-container fluid>
            <b-row>
                <!--IMAGEN -->
                <b-col cols="4">
                    <b-img :src="getUrlimage(perfume.id)" fluid-grow rounded></b-img>
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

                    <!-- ESENCIAS -->
                    <div>
                        <h5>Esencias</h5>
                        <ul>
                            <li v-for="(esencia, j) in esen" :key="j">
                                {{ esencia }}
                            </li>
                        </ul>
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
    data() {
        return {
            esen: [],
        };
    },
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
        getUrlimage(idp) {
            return `/perfumes/perfume-${idp}.jpg`;
        },
        getEsencias() {
            let aux_esc = [];
            console.log("LLAMANDO A ", this.perfume.id);
            fetch(`http://localhost:3000/rec/perfumes/esencias/${this.perfume.id}`)
                .then((response) => {
                    return response.json();
                })
                .then((es) => {
                    es.Perfumes.forEach((e) => {
                        let name = e.nombre[0].toUpperCase() + e.nombre.slice(1);
                        if (!aux_esc.includes(name)) {
                            aux_esc.push(name);
                        }
                    });

                    this.esen = aux_esc;
                });
        },
    },
    mounted() {
        this.$root.$on("bv::modal::show", (bvEvent, modalId) => {
            if (modalId == "perf-det-modal") {
                setTimeout(() => {
                    this.getEsencias();
                }, 50);
            }
        });
    },
};
</script>

<style>
.p-indent {
    text-indent: 1em;
}
</style>
