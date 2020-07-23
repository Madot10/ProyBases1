<template>
    <card-main>
        <template v-slot:title>
            FÓRMULAS DE EVALUACIÓN
        </template>
        <template v-slot:content>
            <modal-crear-formula
                :mode="mode"
                :variables="vars"
                :esc_aviso="esc_aviso"
                :escala="escala"
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
                            <b-button variant="primary" block @click="openModalNuevo()"
                                >CREAR NUEVA</b-button
                            >
                        </b-col>
                    </b-row>
                </div>
                <br />
                <b-alert show variant="warning" class="text-center" v-show="false"
                    >¡No posee fórmula activa!
                    <b-button
                        block
                        class="mt-2"
                        variant="outline-secondary"
                        @click="openModalNuevo(false)"
                        >CREAR NUEVA FÓRMULA</b-button
                    >
                </b-alert>
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
            mode: "ini",
            vars: [],
            esc_aviso: true,
            escala: { valor_min: 0, valor_max: 5 },
            formula_ini: {
                esc_min: 0,
                esc_max: 5,
                punt_exito: 80,
                criterios: [
                    {
                        nombre: "Ubicación geográfica del proveedor",
                        peso: 35,
                        descripcion: "HJADFJAS s dhd sdshdsd shdsdhb bshd",
                    },
                    {
                        nombre:
                            "Costos y alternativas de envíos de los pedidos según ubicación geográfica de los clientes",
                        peso: 35,
                        descripcion: "HJADFJAS s dhd sdshdsd shdsdhb bshd",
                    },
                    {
                        nombre: "Alternativas y condiciones de pago",
                        peso: 30,
                        descripcion: "HJADFJAS s dhd sdshdsd shdsdhb bshd",
                    },
                ],
            },
            formula_rev: {
                esc_min: 0,
                esc_max: 10,
                punt_exito: 70,
                criterios: [
                    {
                        nombre:
                            "Cumplimiento de los pedidos en el tiempo solicitado por la compañía",
                        peso: 100,
                        descripcion: "HJADFJAS s dhd sdshdsd shdsdhb bshd",
                    },
                ],
            },
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
        },
        openModalNuevo(esc = true) {
            console.log(this.mode, this.mode == "ini");
            if (this.mode == "ini") {
                this.vars = [
                    {
                        id: 1,
                        nombre_crit: "Ubicación",
                        descripcion: "Ubicación geográfica del proveedor",
                    },
                    {
                        id: 2,
                        nombre_crit: "Formas de envíos",
                        descripcion:
                            "Costos y alternativas de envíos de los pedidos según ubicación geográfica de los clientes",
                    },
                    {
                        id: 3,
                        nombre_crit: "Formas de pago",
                        descripcion: "Alternativas y condiciones de pago que ofrece el proveedor",
                    },
                    {
                        id: 5,
                        nombre_crit: "Éxito",
                        descripcion: "Puntaje objetivo de éxito",
                    },
                ];
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
            }

            this.esc_aviso = esc;
            this.$bvModal.show("c-form-modal");
        },
    },
    created() {
        this.formula = this.formula_ini;
    },
};
</script>

<style>
.sombra {
    box-shadow: 0px 0 6px 2px hsla(0, 0%, 0%, 0.2);
    border-radius: 10px;
}
</style>
