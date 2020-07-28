<template>
    <b-modal id="con-modal" centered size="xl" title="Contrato">
        <!-- CONTENIDO MODAL -->
        <b-container fluid>
            <b-row>
                <b-col>
                    <b-form-group
                        label="Datos básicos"
                        label-cols="3"
                        label-class="font-weight-bold"
                    >
                        <!-- F_emision -->
                        <b-form-group
                            label-cols-sm="5"
                            label="Fecha de emisión:"
                            label-align-sm="right"
                        >
                            <b-form-input
                                plaintext
                                :value="getDateFormated(contrato.fecha_emision)"
                            ></b-form-input>
                        </b-form-group>
                        <div v-if="contrato.fecha_can">
                            <!-- F_can -->
                            <b-form-group
                                label-cols-sm="5"
                                label="Fecha de cancelación:"
                                label-align-sm="right"
                            >
                                <b-form-input
                                    plaintext
                                    :value="getDateFormated(contrato.fecha_can)"
                                ></b-form-input>
                            </b-form-group>

                            <!-- Motiva CAn -->
                            <b-form-group
                                label-cols-sm="5"
                                label="Motivo de cancelación:"
                                label-align-sm="right"
                            >
                                <b-form-textarea
                                    id="textarea"
                                    rows="3"
                                    max-rows="6"
                                    readonly
                                    v-model="contrato.motivo_cancel"
                                ></b-form-textarea>
                            </b-form-group>
                        </div>

                        <!-- Exclusividad -->
                        <b-form-group
                            label-cols-sm="5"
                            label="Exclusividad:"
                            label-align-sm="right"
                        >
                            <b-form-input
                                plaintext
                                :value="contrato.exclusividad ? 'Si' : 'No'"
                            ></b-form-input>
                        </b-form-group>

                        <!-- Clausula -->
                        <b-form-group label-cols-sm="5" label="Clausula:" label-align-sm="right">
                            <b-form-textarea
                                id="textarea"
                                rows="3"
                                max-rows="6"
                                readonly
                                v-model="contrato.clausula"
                            ></b-form-textarea>
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
                        :items="contrato.formas_envios"
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

                    <!-- Forma de pago-->
                    <b-form-group
                        label="Formas de pagos"
                        label-cols="4"
                        label-class="font-weight-bold"
                    >
                    </b-form-group>
                    <b-table small striped hover :items="contrato.formas_pagos" :fields="fields_fp">
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

                    <!-- Ingredientes contratados-->
                    <b-form-group
                        label="Ingredientes contratados"
                        label-cols="4"
                        label-class="font-weight-bold"
                    >
                    </b-form-group>
                    <b-table
                        small
                        striped
                        hover
                        :items="contrato.ingredientes"
                        :fields="fields_con"
                    >
                        <!-- Cells -->
                        <template v-slot:cell(tipo)="row">
                            {{ row.value == "q" ? "Sintético" : "Natural" }}
                        </template>
                    </b-table>
                </b-col>
            </b-row>
        </b-container>

        <!-- FOOTER MODAL -->
        <template v-slot:modal-footer="{ ok }">
            <b-button @click="ok()">
                Cerrar
            </b-button>
        </template>
    </b-modal>
</template>

<script>
export default {
    props: ["contrato"],
    data() {
        return {
            fields_con: [
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
            ],
            fields_fe: [
                {
                    key: "tipo",
                    label: "Tipo",
                    sortable: false,
                },
                {
                    key: "cargo",
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
                    key: "interes_mensual",
                    label: "Interés mensual (%)",
                    sortable: false,
                },
            ],
        };
    },
    methods: {
        getDateFormated(date) {
            let d = new Date(date);
            if (date) {
                return `${d.getDate()}/${
                    d.getMonth() > 8 ? d.getMonth() + 1 : `0${d.getMonth() + 1}`
                }/${d.getFullYear()}`;
            } else {
                return "";
            }
        },
    },
};
</script>

<style></style>
