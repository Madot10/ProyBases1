<template>
    <!-- The modal -->
    <b-modal
        id="pe-form-modal"
        centered
        size="xl"
        :title="mode == 'fp' ? 'Forma de pago' : 'Forma de envío'"
    >
        <!-- CONTENIDO MODAL -->
        <b-container fluid>
            <b-row>
                <b-col>
                    <p>Seleccione una modalida:</p>
                    <!-- Forma de envío-->
                    <div v-show="mode == 'fe'">
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

                            <!-- BOTON Acciones -->
                            <template v-slot:cell(acciones)="row">
                                <b-button variant="outline-secondary" @click="selectFE(row.index)"
                                    >Seleccionar</b-button
                                >
                            </template>
                        </b-table>
                    </div>

                    <!-- Forma de pago-->
                    <div v-show="mode == 'fp'">
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
                        >
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

                            <!-- BOTON Acciones -->
                            <template v-slot:cell(acciones)="row">
                                <b-button variant="outline-secondary" @click="selectFP(row.index)"
                                    >Seleccionar</b-button
                                >
                            </template>
                        </b-table>
                    </div>
                </b-col>
            </b-row>
        </b-container>

        <!--footer-->
        <template v-slot:modal-footer>
            <div></div>
        </template>
    </b-modal>
</template>

<script>
export default {
    props: ["proveedor", "mode"],
    data() {
        return {
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
                {
                    key: "acciones",
                    label: "",
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
                {
                    key: "acciones",
                    label: "",
                    sortable: false,
                },
            ],
        };
    },
    methods: {
        selectFE(ind) {
            this.$bvModal.hide("pe-form-modal");
            this.$emit("fe", ind);
        },
        selectFP(ind) {
            this.$bvModal.hide("pe-form-modal");
            this.$emit("fp", ind);
        },
    },
};
</script>

<style></style>
