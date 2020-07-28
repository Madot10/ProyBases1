<template>
    <b-modal id="eval-renov-modal" centered size="xl" title="Evaluar">
        <!-- CONTENIDO MODAL -->
        <b-container>
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
                <p v-show="isAprobado">¿Desea continuar con el renovación?</p>
            </div>
        </b-container>

        <!--FOOTER-->
        <template v-slot:modal-footer="{ ok, cancel }">
            <b-button variant="outline-danger" @click="cancel">
                {{ isAprobado && isFinal ? "NO" : isAprobado ? "CANCELAR" : "CERRAR" }}
            </b-button>
            <b-button variant="primary" @click="continuarRenov(ok)" v-show="isAprobado && isFinal">
                SI
            </b-button>
        </template>
    </b-modal>
</template>

<script>
export default {
    props: ["contrato"],
    data() {
        return {
            criterios: [],
            formula: { valor_min: null, valor_max: null, punt_exito: null },
            page: 0,
            flag_next: true,
            isEvaluating: true,
            isFinal: false,
            puntaje: 0,
            isAprobado: null,
            pedidos: {
                aprobados: 9,
                realizados: 10,
            },
        };
    },
    methods: {
        continuarRenov(fnOk) {
            this.$emit("vaRenov");
            fnOk();
        },
        evaluar() {
            console.log("Evaluando...");

            this.isEvaluating = true;
            let ratio = 0;

            if (this.pedidos.realizados > 0) {
                ratio = (this.pedidos.aprobados * 100) / this.pedidos.realizados;
                this.puntaje = Math.ceil((ratio * this.formula.valor_max) / 100);
            }

            console.warn(
                "Resultados",
                ratio,
                this.puntaje,
                this.formula.punt_exito,
                ratio >= this.formula.punt_exito
            );

            if (ratio >= this.formula.punt_exito) {
                this.isAprobado = true;
            } else {
                this.isAprobado = false;
            }

            this.isEvaluating = false;
            this.isFinal = true;

            //Guardar puntaje
            let idUser = this.$route.params.id;
            let urlApi = `http://localhost:3000/prod/${idUser}/eval/result/${this.contrato.id_prov}`;

            let obj_eval = {
                resultado: ratio,
                tipoeval: "r",
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
        generateForm(datosF, datosEsc, datosPAll, datosPApro) {
            console.log("hola", 4);
            this.formula.punt_exito = datosF[0].peso;
            this.formula.valor_min = datosEsc[0].valor_min;
            this.formula.valor_max = datosEsc[0].valor_max;

            this.pedidos.aprobados = Number(datosPApro[0].count);
            this.pedidos.realizados = Number(datosPAll[0].count);

            this.evaluar();
        },
        getFormulaRenov() {
            let idUser = this.$route.params.id;
            let provid = this.contrato.id_prov;
            let cont_id = this.contrato.id;

            let urlBaseApi = `http://localhost:3000/prod/${idUser}/`;
            let urlApi = urlBaseApi + "evaluacion_criterios/renovacion";

            let datosCri;
            let dataAll;
            console.log("hola", idUser, provid, cont_id);

            //Criterios
            fetch(urlApi)
                .then((response) => {
                    return response.json();
                })
                .then((res) => {
                    console.log("Criterios ", res);
                    datosCri = res;

                    //Escalas
                    fetch(urlBaseApi + "escalas")
                        .then((response) => {
                            return response.json();
                        })
                        .then((esc) => {
                            console.log("Escalas", esc);
                            let aux = datosCri.Info_de_Evaluacion_renov;

                            if (aux.length > 0) {
                                //Get cuentas

                                fetch(
                                    urlBaseApi +
                                        `evaluacion_criterios/renovacion/all/${provid}/${cont_id}`
                                )
                                    .then((response) => {
                                        return response.json();
                                    })
                                    .then((allp) => {
                                        console.log("Pedidos all", allp);
                                        dataAll = allp;

                                        fetch(
                                            urlBaseApi +
                                                `evaluacion_criterios/renovacion/${provid}/${cont_id}`
                                        )
                                            .then((response) => {
                                                return response.json();
                                            })
                                            .then((aproP) => {
                                                console.log("Pedidos aprob", aproP);

                                                this.generateForm(
                                                    datosCri.Info_de_Evaluacion_renov,
                                                    esc.Info_de_Evaluacion,
                                                    dataAll.Cantidad,
                                                    aproP.Cantidad
                                                );
                                            });
                                    });
                            } else {
                                //Redirigir
                                this.$router.push({
                                    name: "FormulaEval",
                                });
                            }
                        });
                });
        },
    },
    mounted() {
        this.$root.$on("bv::modal::show", (bvEvent, modalId) => {
            if (modalId == "eval-renov-modal") {
                this.isEvaluating = true;
                this.isFinal = false;
                this.puntaje = 0;
                this.isAprobado = null;

                //Getters
                this.criterios = [
                    {
                        id: 4,
                        nombre: "Pedidos Aprobados",
                        peso: 100,
                        descripcion:
                            "Cumplimiento de los pedidos en el tiempo solicitado por la compañía",
                    },
                ];

                //this.formula.valor_min = 0;
                // this.formula.valor_max = 10;
                //this.formula.punt_exito = 80;

                //numeros de pedidos
                let dataAll = { Cantidad: [{ count: "20" }] };
                let dataAprob = { Cantidad: [{ count: "5" }] };

                this.getFormulaRenov();
            }
        });
    },
};
</script>

<style></style>
