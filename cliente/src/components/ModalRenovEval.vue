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

            let ratio = (this.pedidos.aprobados * 100) / this.pedidos.realizados;
            this.puntaje = Math.ceil((ratio * this.formula.valor_max) / 100);

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
                        nombre:
                            "Cumplimiento de los pedidos en el tiempo solicitado por la compañía",
                        peso: 100,
                        descripcion: "HJADFJAS s dhd sdshdsd shdsdhb bshd",
                    },
                ];

                this.formula.valor_min = 0;
                this.formula.valor_max = 10;
                this.formula.punt_exito = 80;

                this.evaluar();
            }
        });
    },
};
</script>

<style></style>
