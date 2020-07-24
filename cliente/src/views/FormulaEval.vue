<template>
    <card-main>
        <template v-slot:title>
            FÓRMULAS DE EVALUACIÓN
        </template>
        <template v-slot:content>
            <!-- Aviso -->
            <b-toast id="toast-aviso" :variant="aviso.tipo" :title="aviso.titulo" solid>
                {{ aviso.mensaje }}
            </b-toast>

            <!--MODal crear form -->
            <modal-crear-formula
                :mode="mode"
                :variables="vars"
                :esc_aviso="esc_aviso"
                :escala="escala"
                v-on:state="respuestaCreate"
            ></modal-crear-formula>

            <!-- HEADER BANNER -->
            <div>
                <b-row>
                    <b-col
                        ><b-button
                            :variant="mode == 'ini' ? 'primary' : 'outline-primary'"
                            block
                            @click="cambiarTab('ini')"
                            >EVALUACIÓN INICIAL</b-button
                        ></b-col
                    >
                    <b-col
                        ><b-button
                            :variant="mode == 'rev' ? 'primary' : 'outline-primary'"
                            block
                            @click="cambiarTab('rev')"
                            >EVALUACIÓN ANUAL</b-button
                        ></b-col
                    >
                </b-row>
            </div>

            <br />

            <!-- CONTENIDO -->
            <div class="sombra mt-2 p-3">
                <div>
                    <b-row>
                        <b-col>
                            <h4>
                                Fórmula {{ mode == "ini" ? "inicial" : "de renovación" }} vigente
                            </h4></b-col
                        >
                        <b-col>
                            <b-button
                                variant="primary"
                                block
                                @click="openModalNuevo()"
                                v-show="!is_empty"
                                >CREAR NUEVA</b-button
                            >
                        </b-col>
                    </b-row>
                </div>
                <br />
                <b-alert show variant="warning" class="text-center" v-show="is_empty"
                    >¡No posee fórmula activa!
                    <b-button
                        block
                        class="mt-2"
                        variant="outline-secondary"
                        @click="openModalNuevo(false)"
                        >CREAR NUEVA FÓRMULA</b-button
                    >
                </b-alert>
                <div v-show="!is_empty">
                    <b-form-group
                        label="RANGO DE CLASIFICACIÓN"
                        label-cols="4"
                        label-class="font-weight-bold"
                    >
                        <!-- Escala mínima-->
                        <b-form-group
                            label-cols-sm="5"
                            label="Escala mínima:"
                            label-align-sm="left"
                            class="p-0 m-0"
                        >
                            <b-form-input plaintext v-model="formula.esc_min"></b-form-input>
                        </b-form-group>

                        <!-- Escala máxima -->
                        <b-form-group
                            label-cols-sm="5"
                            label="Escala máxima:"
                            label-align-sm="left"
                            class="p-0 m-0"
                        >
                            <b-form-input plaintext v-model="formula.esc_max"></b-form-input>
                        </b-form-group>

                        <!-- Puntaje de aprobación -->
                        <b-form-group
                            label-cols-sm="5"
                            label="Puntaje de aprobación (%):"
                            label-align-sm="left"
                            class="p-0 m-0"
                        >
                            <b-form-input plaintext v-model="formula.punt_exito"></b-form-input>
                        </b-form-group>
                    </b-form-group>
                    <hr />
                    <!-- CRITERIOS -->
                    <b-form-group label="CRITERIOS" label-cols="3" label-class="font-weight-bold">
                        <br />
                        <div v-for="(c, i) in formula.criterios" :key="i">
                            <!-- Nombre -->
                            <h5>
                                {{ c.nombre }}
                            </h5>
                            <p>
                                {{ c.descripcion }}
                            </p>
                            <b-form-group
                                label-cols-sm="4"
                                label="Peso (%):"
                                label-align-sm="left"
                                class="p-0 m-0"
                            >
                                <b-form-input plaintext v-model="c.peso"></b-form-input>
                            </b-form-group>
                            <hr />
                        </div>
                    </b-form-group>
                </div>
            </div>
        </template>
    </card-main>
</template>

<script>
import CardMain from "../components/CardMain.vue";
import ModalCrearFormula from "../components/ModalCrearFormula.vue";

export default {
    components: {
        CardMain,
        ModalCrearFormula,
    },
    data() {
        return {
            aviso: { mensaje: "", titulo: "", tipo: "success" },
            mode: "ini",
            vars: [],
            esc_aviso: null,
            is_empty: false,
            escala: { valor_min: 0, valor_max: 5 },
            formula_ini: {},
            formula_rev: {},
            formula: {},
        };
    },
    methods: {
        cambiarTab(tf) {
            if (tf == "ini") {
                this.mode = "ini";
                this.formula = this.formula_ini;
            } else {
                this.mode = "rev";
                this.formula = this.formula_rev;
            }
            this.getFormula();
        },
        respuestaCreate(res) {
            console.warn("capturado", res);
            if (!res) {
                this.aviso.mensaje = "¡No se ha podido registrar la fórmula!";
                this.aviso.titulo = "Aviso";
                this.aviso.tipo = "danger";
                this.$bvToast.show("toast-aviso");
            }
        },
        openModalNuevo(esc) {
            console.log("Esc", esc);
            if (esc == null) {
                esc = true;
            } else {
                esc = false;
            }

            //console.log(this.mode, this.mode == "ini", esc);
            if (this.mode == "ini") {
                fetch("http://localhost:3000/prod/evaluacion/inicial/variables")
                    .then((response) => {
                        return response.json();
                    })
                    .then((res) => {
                        //console.log("Variables: ", res);
                        this.vars = res.Info_de_Evaluacion_inicial;

                        this.esc_aviso = esc;
                        this.$bvModal.show("c-form-modal");
                    });
            } else {
                this.vars = [
                    {
                        id: 4,
                        nombre_crit: "Pedidos Aprobados",
                        descripcion:
                            "Cumplimiento de los pedidos en el tiempo solicitado por la compañía",
                    },
                    {
                        id: 5,
                        nombre_crit: "Éxito",
                        descripcion: "Puntaje objetivo de éxito",
                    },
                ];

                this.esc_aviso = esc;
                this.$bvModal.show("c-form-modal");
            }
        },
        generateFormula(datosCri, datosEsc) {
            let aux_form = { esc_min: null, esc_max: null, punt_exito: null, criterios: [] };

            datosCri.forEach((c) => {
                if (c.nombre_crit != "Exito") {
                    aux_form.criterios.push({
                        nombre: c.nombre_crit,
                        peso: c.peso,
                        descripcion: c.descripcion,
                    });
                } else {
                    aux_form.punt_exito = c.peso;
                }
            });

            aux_form.esc_min = datosEsc[0].valor_min;
            aux_form.esc_max = datosEsc[0].valor_max;

            if (this.mode == "ini") {
                this.formula_ini = aux_form;
                this.formula = this.formula_ini;
            } else {
                this.formula_rev = aux_form;
                this.formula = this.formula_rev;
            }
        },
        getFormula() {
            let idUser = this.$route.params.id;
            let urlBaseApi = `http://localhost:3000/prod/${idUser}`;

            let urlApi = urlBaseApi;

            if (this.mode == "ini") {
                urlApi += "/evaluacion_criterios/inicial";
            } else {
                urlApi += "/evaluacion_criterios/renovacion";
            }

            let datosCri;
            this.is_empty = false;
            //Criterios
            fetch(urlApi)
                .then((response) => {
                    return response.json();
                })
                .then((res) => {
                    console.log("Criterios ", res);
                    datosCri = res;

                    //Escalas
                    fetch(urlBaseApi + "/escalas")
                        .then((response) => {
                            return response.json();
                        })
                        .then((esc) => {
                            console.log("Escalas", esc);
                            let aux =
                                datosCri.Info_de_Evaluacion_inicial ||
                                datosCri.Info_de_Evaluacion_renov;
                            if (aux.length > 0) {
                                this.generateFormula(
                                    datosCri.Info_de_Evaluacion_inicial ||
                                        datosCri.Info_de_Evaluacion_renov,
                                    esc.Info_de_Evaluacion
                                );
                            } else {
                                this.is_empty = true;
                            }
                        });
                });
        },
    },
    created() {
        this.getFormula();
    },
};
</script>

<style>
.sombra {
    box-shadow: 0px 0 6px 2px hsla(0, 0%, 0%, 0.2);
    border-radius: 10px;
}
</style>
