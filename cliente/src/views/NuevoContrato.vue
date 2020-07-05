<template>
    <card-main>
        <template #title>Nuevo Contrato</template>
        <template #content>
            <!-- MODAL DETALLE PROV -->
            <modal-prov-detalle
                :proveedor="proveedores[index_selected_prov]"
                @evaluar="continuarEvaluarProv"
            ></modal-prov-detalle>

            <!-- MODAL EXCLUSIVIDAD -->
            <modal-exclusividad @optionSelect="exclSelect"></modal-exclusividad>

            <h3>Proveedores</h3>

            <!-- TABLA small -->
            <b-table
                :busy="isLoadingProv"
                small
                striped
                hover
                :items="proveedores"
                :fields="fields"
                id="con-table"
            >
                <!-- CARGA -->
                <template v-slot:table-busy>
                    <div class="text-center text-primary my-2">
                        <b-spinner class="align-middle"></b-spinner>
                        <strong> Cargando...</strong>
                    </div>
                </template>

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
import ModalExclusividad from "../components/ModalExclusividad.vue";

export default {
    components: {
        CardMain,
        ModalProvDetalle,
        ModalExclusividad,
    },
    data() {
        return {
            isLoadingProv: true,
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
        continuarEvaluarProv() {
            console.log("A EVALUAR EL PROV ", this.index_selected_prov);
            this.$bvModal.show("exclusividad-modal");
        },
        exclSelect(opt) {
            console.log("Exclusividad seleccionada ", opt);
        },
    },
    created() {
        this.isLoadingProv = false;
    },
};
</script>

<style></style>
