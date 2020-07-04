<template>
    <card-main>
        <template v-slot:title>Nuevo Contrato</template>
        <template v-slot:content>
            <!-- MODAL DETALLE PROV -->
            <modal-prov-detalle :proveedor="proveedores[index_selected_prov]"></modal-prov-detalle>

            <!-- TABLA small -->
            <b-table small striped hover :items="proveedores" :fields="fields" id="con-table">
                <!-- BOTON Acciones -->
                <template v-slot:cell(acciones)="row">
                    <b-button variant="outline-primary" @click="verDetallePreov(row.index)"
                        >SELECCIONAR</b-button
                    >
                </template>
            </b-table>
        </template>
    </card-main>
</template>

<script>
import CardMain from "../components/CardMain";
import ModalProvDetalle from "../components/ModalProvDetalle.vue";

export default {
    components: {
        CardMain,
        ModalProvDetalle,
    },
    data() {
        return {
            index_selected_prov: 0,
            proveedores: [
                {
                    nombre: "Empresita 1",
                    email: "test@gdsf.com",
                    telefono: 4545456898,
                    pag_web: "www.google.com",
                    pais: "Puerto Rico",
                    ingredientes: [
                        { cas: "1234", nombre: "Cacao", tipo: "natural", volumen: "10", precio: 5 },
                        {
                            cas: "1234",
                            nombre: "Cacao",
                            tipo: "natural",
                            volumen: "15",
                            precio: 50,
                        },
                    ],
                    formas_envios: [{ tipo: "Maritimo", recargo: "10", pais: "Venezuela" }],
                    formas_pagos: [
                        { tipo: "Contado", porc_inicial: "15", nro_cuotas: "2", int_mensual: "6" },
                    ],
                },
                {
                    nombre: "Empresita 2",
                    email: "test@dsfdsfsdfsdf.com",
                    telefono: 2124423258,
                    pag_web: "www.gsdsadsaoogle.com",
                    pais: "Estados Unidos de America",
                },
                { nombre: "Empresita 3", email: "sdfdsf@sdgfds.sd" },
            ],
            fields: [
                {
                    key: "nombre",
                    label: "Nombre",
                    sortable: true,
                },
                {
                    key: "email",
                    label: "Email",
                    sortable: true,
                },
                {
                    key: "ACCIONES",
                    label: "",
                    sortable: false,
                },
            ],
        };
    },
    methods: {
        verDetallePreov(index) {
            this.index_selected_prov = index;
            this.$bvModal.show("prov-det-modal");
        },
    },
};
</script>

<style></style>
