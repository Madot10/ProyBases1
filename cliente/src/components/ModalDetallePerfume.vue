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
                    <div v-if="perfume.descrip_componentes">
                        <h5>Componentes</h5>
                        <p>
                            {{
                                perfume.descrip_componentes[0].toUpperCase() +
                                    perfume.descrip_componentes.slice(1)
                            }}
                        </p>
                    </div>

                    <!-- ESENCIAS -->
                    <div>
                        <h5>Esencias</h5>
                        <ul v-if="perfume.tipo_estructura == 'm'">
                            <li v-for="(esencia, j) in esen" :key="j">
                                {{ esencia }}
                            </li>
                        </ul>
                        <ul v-else>
                            <li>
                                <b>Notas de salida</b>
                                <ul>
                                    <li v-for="(esencia, j) in e_s" :key="j">
                                        {{ esencia }}
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <b>Notas de corazón</b>
                                <ul>
                                    <li v-for="(esencia, j) in e_c" :key="j">
                                        {{ esencia }}
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <b>Notas de fondo</b>
                                <ul>
                                    <li v-for="(esencia, j) in e_f" :key="j">
                                        {{ esencia }}
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>

                    <!-- Ver en tienda -->
                    <b-button
                        block
                        variant="outline-info"
                        href="https://fr.loccitane.com/tous-les-parfums-femme,74,1,86798,0.htm"
                        >ENCUÉNTRALO <b-icon icon="cart4"></b-icon
                    ></b-button>
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
            e_c: [],
            e_f: [],
            e_s: [],
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
                    console.log(es);
                    es.Perfumes.forEach((e) => {
                        let name = e.nombre[0].toUpperCase() + e.nombre.slice(1);
                        if (this.perfume.tipo_estructura == "m") {
                            if (!aux_esc.includes(name)) {
                                aux_esc.push(name);
                            }
                        } else {
                            switch (e.tipo_nota) {
                                case "c":
                                    if (!this.e_c.includes(name)) {
                                        this.e_c.push(name);
                                    }
                                    break;

                                case "s":
                                    if (!this.e_s.includes(name)) {
                                        this.e_s.push(name);
                                    }
                                    break;

                                case "f":
                                    if (!this.e_f.includes(name)) {
                                        this.e_f.push(name);
                                    }
                                    break;
                            }
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
