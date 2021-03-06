<template>
    <b-modal id="eval-preg-modal" centered size="xl" title="Evaluar">
        <!-- CONTENIDO MODAL -->
        <b-container>
            <!-- PREGUNTA -->
            <div v-for="(c, i) in criterios" :key="i" v-show="!isEvaluating && !isFinal">
                <!--pagina -->

                <div v-show="page == i">
                    <h3>{{ c.nombre }}</h3>
                    <p>{{ c.descripcion }}</p>
                    <!--CONTENIDO-->

                    <!--Ubicación Geográfica-->
                    <div v-if="c.nombre == 'Ubicación'">
                        <b-form-group
                            label="Ubicación Geográfica"
                            label-cols="3"
                            label-class="font-weight-bold"
                        >
                            <!-- pais -->
                            <b-form-group label-cols-sm="5" label="Pais:" label-align-sm="right">
                                <b-form-input plaintext v-model="prov.pais"></b-form-input>
                            </b-form-group>
                        </b-form-group>
                    </div>

                    <!-- Forma de envío-->
                    <div v-if="c.nombre == 'Formas de envíos'">
                        <b-table
                            small
                            striped
                            hover
                            :items="prov.formas_envios"
                            :fields="fields_fe"
                        >
                            <!-- Cells -->
                            <template v-slot:cell(tipo)="row">
                                {{
                                    row.value == "m"
                                        ? "Marítimo"
                                        : row.value == "a"
                                        ? "Áereo"
                                        : "Terrestre"
                                }}
                            </template>
                        </b-table>
                    </div>

                    <!-- Forma de pago-->
                    <div v-if="c.nombre == 'Formas de pago'">
                        <b-table small striped hover :items="prov.formas_pagos" :fields="fields_fp">
                            <!-- Cells -->
                            <template v-slot:cell(tipo)="row">
                                {{ row.value == "cred" ? "Crédito" : "Contado" }}
                            </template>
                            <template v-slot:cell(porc_inicial)="row">
                                {{ row.item.tipo == "cred" ? row.value : "-" }}
                            </template>
                            <template v-slot:cell(nro_cuotas)="row">
                                {{ row.item.tipo == "cred" ? row.value : "-" }}
                            </template>
                            <template v-slot:cell(interes_mensual)="row">
                                {{ row.item.tipo == "cred" ? row.value : "-" }}
                            </template>
                        </b-table>
                    </div>

                    <!--VALORACION -->
                    <b-input-group>
                        <b-form-input
                            id="range-2"
                            v-model="valoracion[i]"
                            value="0"
                            type="range"
                            :min="formula.valor_min"
                            :max="formula.valor_max"
                            step="1"
                        ></b-form-input>
                        <b-input-group-append>
                            <b-input-group-text
                                class="justify-content-center"
                                style="min-width: 3em;"
                            >
                                {{ valoracion[i] }}
                            </b-input-group-text>
                        </b-input-group-append>
                    </b-input-group>
                    <br />
                </div>
            </div>

            <!-- EVALUANDO -->
            <div class="d-flex justify-content-center mb-3" v-if="isEvaluating">
                <b-spinner
                    label="Loading..."
                    style="width: 3rem; height: 3rem;"
                    type="grow"
                    variant="primary"
                ></b-spinner>
            </div>

            <!-- FINAL-->
            <div v-show="isFinal" class="text-center">
                <h3>{{ isAprobado ? "Aprobado" : "Reprobado" }}</h3>
                <p>
                    El proveedor obtuvo <b>{{ puntaje }} / {{ formula.valor_max }}pts</b>
                </p>
                <p v-show="isAprobado">¿Desea continuar con el proceso de crear contrato?</p>
            </div>
        </b-container>

        <!--FOOTER-->
        <template v-slot:modal-footer="{ ok, cancel }">
            <b-button variant="outline-danger" @click="cancel">
                {{ isAprobado && isFinal ? "NO" : isAprobado ? "CANCELAR" : "CERRAR" }}
            </b-button>
            <b-button variant="primary" @click="nextPreg" v-show="flag_next">
                SIGUIENTE
            </b-button>
            <b-button
                variant="primary"
                @click="evaluar"
                v-show="!flag_next && !isEvaluating && !isFinal && !isAprobado"
            >
                EVALUAR
            </b-button>
            <b-button
                variant="primary"
                @click="continuarContrato(ok)"
                v-show="isAprobado && isFinal"
            >
                SI
            </b-button>
        </template>
    </b-modal>
</template>

<script>
export default {
    props: ["prov"],
    data() {
        return {
            valoracion: [],
            criterios: [],
            formula: { valor_min: null, valor_max: null, punt_exito: null },
            page: 0,
            flag_next: true,
            fields_fe: [
                {
                    key: "tipo",
                    label: "Tipo",
                    sortable: false,
                },
                {
                    key: "cargo",
                    label: "Cargo (%)",
                    sortable: false,
                },
                {
                    key: "pais",
                    label: "Destino",
                    sortable: false,
                },
            ],
            fields_fp: [
                {
                    key: "tipo",
                    label: "Tipo",
                    sortable: false,
                },
                {
                    key: "porc_inicial",
                    label: "Porcentaje inicial (%)",
                    sortable: false,
                },
                {
                    key: "nro_cuotas",
                    label: "Num de cuotas",
                    sortable: false,
                },
                {
                    key: "interes_mensual",
                    label: "Interés mensual (%)",
                    sortable: false,
                },
            ],
            isEvaluating: false,
            isFinal: false,
            puntaje: 0,
            isAprobado: null,
            is_empty: false,
        };
    },
    methods: {
        nextPreg() {
            this.page++;
            if (this.page >= this.criterios.length - 1) {
                this.flag_next = false;
            }
        },
        continuarContrato(fnOk) {
            this.$emit("vaContrato");
            fnOk();
        },
        evaluar() {
            console.log("Evaluando...");

            this.isEvaluating = true;

            let sum = 0;
            let sumFixeado = 0;

            for (let i = 0; i < this.criterios.length; i++) {
                sumFixeado +=
                    (this.criterios[i].peso / 100) *
                    (this.valoracion[i] - Number(this.formula.valor_min));
                sum += (this.criterios[i].peso / 100) * this.valoracion[i];
            }
            this.puntaje = Math.ceil(sum);
            let p_punt =
                (Math.ceil(sumFixeado) * 100) /
                (this.formula.valor_max - Number(this.formula.valor_min));

            console.warn(
                "Resultados",
                sumFixeado,
                p_punt,
                this.puntaje,
                this.formula.punt_exito,
                p_punt >= this.formula.punt_exito
            );

            if (p_punt >= this.formula.punt_exito) {
                this.isAprobado = true;
            } else {
                this.isAprobado = false;
            }

            this.isEvaluating = false;
            this.isFinal = true;

            //Guardar puntaje
            let idUser = this.$route.params.id;
            let urlApi = `http://localhost:3000/prod/${idUser}/eval/result/${this.prov.id}`;

            let obj_eval = {
                resultado: p_punt,
                tipoeval: "i",
            };

            fetch(urlApi, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(obj_eval),
            })
                .then((response) => {
                    return response.json();
                })
                .then((res) => {
                    console.log("Guardando resultados ", res);
                });
        },
        generateForm(crit, esc) {
            let aux_crit = [];
            let aux_form = {};

            crit.forEach((c) => {
                if (c.nombre_crit != "Exito") {
                    aux_crit.push({
                        id: null,
                        nombre: c.nombre_crit,
                        descripcion: c.descripcion,
                        peso: Number(c.peso),
                    });
                } else {
                    aux_form = {
                        punt_exito: Number(c.peso),
                        valor_min: esc[0].valor_min,
                        valor_max: esc[0].valor_max,
                    };
                }
            });

            this.formula = aux_form;
            this.criterios = aux_crit;
            this.isEvaluating = false;

            this.valoracion = this.criterios.map(() => {
                return 0;
            });
        },
        getFormula() {
            let idUser = this.$route.params.id;

            let urlBaseApi = `http://localhost:3000/prod/${idUser}`;
            let urlApi = urlBaseApi;
            urlApi += "/evaluacion_criterios/inicial";

            let datosCri;

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
                            let aux = datosCri.Info_de_Evaluacion_inicial;
                            if (aux.length > 0 && esc.Info_de_Evaluacion.length > 0) {
                                this.generateForm(
                                    datosCri.Info_de_Evaluacion_inicial,
                                    esc.Info_de_Evaluacion
                                );
                            } else {
                                //Redirigir
                                this.$router.push({
                                    name: "FormulaEval",
                                });
                                this.is_empty = true;
                            }
                        });
                });
        },
    },
    mounted() {
        this.$root.$on("bv::modal::show", (bvEvent, modalId) => {
            if (modalId == "eval-preg-modal") {
                this.page = 0;
                this.flag_next = true;
                this.isEvaluating = true;
                this.isFinal = false;
                this.puntaje = 0;
                this.isAprobado = null;

                this.getFormula();
            }
        });
    },
};
</script>

<style></style>
