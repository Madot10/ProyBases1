<template>
    <!-- The modal -->
    <b-modal id="prov-det-modal" centered size="xl" title="Proveedor">
        <!-- CONTENIDO MODAL -->
        <b-container fluid>
            <b-row>
                <b-col>
                    <b-form-group
                        label="Datos básicos"
                        label-cols="3"
                        label-class="font-weight-bold"
                    >
                        <!-- Nombre Empresa -->
                        <b-form-group
                            label-cols-sm="5"
                            label="Nombre de empresa:"
                            label-align-sm="right"
                        >
                            <b-form-input plaintext v-model="proveedor.nombre"></b-form-input>
                        </b-form-group>
                    </b-form-group>

                    <b-form-group
                        label="Datos de contacto"
                        label-cols="3"
                        label-class="font-weight-bold"
                    >
                        <!-- Correo -->
                        <b-form-group
                            label-cols-sm="5"
                            label="Correo electónico:"
                            label-align-sm="right"
                        >
                            <b-form-input plaintext v-model="proveedor.email"></b-form-input>
                        </b-form-group>

                        <!-- telefono -->
                        <b-form-group label-cols-sm="5" label="Teléfono:" label-align-sm="right">
                            <b-form-input plaintext v-model="proveedor.telefono"></b-form-input>
                        </b-form-group>

                        <!-- Pag web -->
                        <b-form-group label-cols-sm="5" label="Página Web:" label-align-sm="right">
                            <b-form-input plaintext v-model="proveedor.pag_web"></b-form-input>
                        </b-form-group>
                    </b-form-group>

                    <b-form-group
                        label="Ubicación Geográfica"
                        label-cols="3"
                        label-class="font-weight-bold"
                    >
                        <!-- pais -->
                        <b-form-group label-cols-sm="5" label="Pais:" label-align-sm="right">
                            <b-form-input plaintext v-model="proveedor.pais"></b-form-input>
                        </b-form-group>
                    </b-form-group>

                    <!-- Forma de envío-->
                    <b-form-group
                        label="Formas de envíos"
                        label-cols="4"
                        label-class="font-weight-bold"
                    >
                    </b-form-group>
                    <b-table
                        small
                        striped
                        hover
                        :items="proveedor.formas_envios"
                        :fields="fields_fe"
                    ></b-table>

                    <!-- Forma de pago-->
                    <b-form-group
                        label="Formas de pagos"
                        label-cols="4"
                        label-class="font-weight-bold"
                    >
                    </b-form-group>
                    <b-table
                        small
                        striped
                        hover
                        :items="proveedor.formas_pagos"
                        :fields="fields_fp"
                    ></b-table>

                    <!-- Ingredientes ofrecidos-->
                    <b-form-group
                        label="Ingredientes"
                        label-cols="4"
                        label-class="font-weight-bold"
                    >
                    </b-form-group>
                    <b-table
                        small
                        striped
                        hover
                        :items="proveedor.ingredientes"
                        :fields="fields_ing"
                    ></b-table>
                </b-col>
            </b-row>
        </b-container>

        <!-- FOOTER MODAL -->
        <template v-slot:modal-footer="{ cancel, ok }">
            <div v-if="only_view">
                <b-button @click="cancel()" variant="outline-secondary">
                    CERRAR
                </b-button>
            </div>
            <div v-else>
                <b-button @click="cancel()" variant="outline-danger">
                    CERRAR
                </b-button>
                <span class="mr-2"></span>
                <b-button @click="okEvaluar(ok)" variant="primary">
                    EVALUAR
                </b-button>
            </div>
        </template>
    </b-modal>
</template>

<script>
export default {
    props: ["proveedor", "only_view"],
    data() {
        return {
            fields_ing: [
                {
                    key: "cas",
                    sortable: false,
                },
                {
                    key: "nombre",
                    label: "Nombre",
                    sortable: false,
                },
                {
                    key: "tipo",
                    label: "Tipo",
                    sortable: false,
                },
                {
                    key: "volumen",
                    label: "Volumen (ml)",
                    sortable: false,
                },
                {
                    key: "precio",
                    label: "Precio (usd)",
                    sortable: false,
                },
            ],
            fields_fe: [
                {
                    key: "tipo",
                    label: "Tipo",
                    sortable: false,
                },
                {
                    key: "recargo",
                    label: "Recargo (%)",
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
                    key: "int_mensual",
                    label: "Interés mensual (%)",
                    sortable: false,
                },
            ],
        };
    },
    methods: {
        okEvaluar(funOk) {
            this.$emit("evaluar");
            funOk();
        },
    },
};
</script>

<style></style>
