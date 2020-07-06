<template>
    <card-main>
        <template v-slot:title>
            {{ mode_renovar ? "Contratos a vencer" : "Contratos" }}
        </template>
        <template v-slot:content>
            <!-- MODAL DETALLE CONTRATO -->
            <modal-contrato-detalle
                :contrato="contratos[index_selected_contrato]"
            ></modal-contrato-detalle>

            <!-- MODAL RENOV CONTRATO -->
            <modal-renovacion @renovSelect="renovacionSelected"></modal-renovacion>

            <!-- MODAL EXCLUSIVIDAD -->
            <modal-exclusividad @optionSelect="exclusividadSelect"></modal-exclusividad>

            <!-- MODAL CANCELAR -->
            <modal-cancelar @optionCancelar="cancelarConfirm"></modal-cancelar>

            <!-- TABLA small -->
            <b-table
                striped
                hover
                :per-page="perPage"
                :current-page="currentPage"
                :items="contratos"
                :fields="fields"
                id="con-table"
            >
                <!-- Campo exclusividad -->
                <template v-slot:cell(exclusividad)="data">
                    {{ data.value ? "Si" : "No" }}
                </template>

                <!-- BOTON Acciones -->
                <template v-slot:cell(acciones)="row">
                    <b-icon
                        class="cur-fake m-1"
                        font-scale="1.2"
                        icon="search"
                        variant="dark"
                        v-b-tooltip.hover
                        title="Detalle"
                        @click="verDetalleContrato(row.index)"
                    ></b-icon>
                </template>
                <template v-slot:cell(acciones2)="row">
                    <!-- {{ row.index }} -->
                    <b-button
                        v-show="mode_renovar"
                        variant="outline-primary"
                        @click="openRenovModal"
                        >RENOVAR</b-button
                    >
                    <span v-show="mode_renovar"> - </span>
                    <b-button variant="outline-danger" @click="openCancelar">CANCELAR</b-button>
                </template>
            </b-table>

            <b-pagination
                v-model="currentPage"
                :total-rows="rows"
                :per-page="perPage"
                align="center"
                aria-controls="con-table"
            >
                <template v-slot:first-text><b-icon icon="chevron-double-left"></b-icon></template>
                <template v-slot:prev-text><b-icon icon="chevron-left"></b-icon></template>
                <template v-slot:next-text><b-icon icon="chevron-right"></b-icon></template>
                <template v-slot:last-text><b-icon icon="chevron-double-right"></b-icon></template>
            </b-pagination>
        </template>
    </card-main>
</template>

<script>
import CardMain from "../components/CardMain.vue";
import ModalContratoDetalle from "../components/ModalContratoDetalle.vue";
import ModalRenovacion from "../components/ModalRenovacion.vue";
import ModalExclusividad from "../components/ModalExclusividad.vue";
import ModalCancelar from "../components/ModalCancelar.vue";

export default {
    components: {
        CardMain,
        ModalContratoDetalle,
        ModalRenovacion,
        ModalExclusividad,
        ModalCancelar,
    },
    data() {
        return {
            currentPage: 1,
            perPage: 20,
            mode_renovar: false,
            fields: [
                {
                    key: "fecha_inicio",
                    label: "Fecha de inicio",
                    sortable: true,
                },
                {
                    key: "fecha_can",
                    label: "Fecha de cancelación",
                    sortable: true,
                },
                {
                    key: "exclusividad",
                    label: "Exclusividad",
                    sortable: true,
                },
                {
                    key: "ACCIONES",
                    label: "",
                    sortable: false,
                },
                {
                    key: "ACCIONES2",
                    label: "",
                    sortable: false,
                },
            ],
            contratos: [
                {
                    id_prov: 3,
                    fecha_inicio: "24/07/2020",
                    exclusividad: true,
                    fecha_can: "27/07/2020",
                    ingredientes: [
                        { cas: "1234", nombre: "Cacao", tipo: "natural", volumen: "10" },
                        { cas: "1234", nombre: "Cacao", tipo: "natural", volumen: "15" },
                    ],
                    formas_envios: [{ tipo: "Maritimo", recargo: "10", pais: "Venezuela" }],
                    formas_pagos: [
                        { tipo: "Contado", porc_inicial: "15", nro_cuotas: "2", int_mensual: "6" },
                    ],
                },
                {
                    id_prov: 6,
                    fecha_inicio: "24/07/2020",
                    exclusividad: false,
                    fecha_can: "",
                },
                {
                    id_prov: 7,
                    fecha_inicio: "10/07/2020",
                    exclusividad: false,
                    fecha_can: "27/07/2020",
                },
            ],
            index_selected_contrato: 0,
        };
    },
    methods: {
        getUserType(url) {
            if (url.includes("prov")) {
                return "prov";
            } else {
                return "prod";
            }
        },
        verDetalleContrato(index) {
            this.index_selected_contrato = index;
            this.$bvModal.show("con-modal");
        },
        checkModeContratos() {
            let url = this.$route.path;
            if (url.includes("vencer")) {
                //console.warn(url);
                //Modo mostrar BOTONES RENOVACION
                this.mode_renovar = true;
            } else {
                //nop
                this.mode_renovar = false;
            }
        },
        openRenovModal() {
            this.$bvModal.show("ask-renov-modal");
        },
        renovacionSelected(typeRenov) {
            //console.log("Type Renov", typeRenov);
            if (typeRenov) {
                //Igual cond
            } else {
                //Hacer nuevo
                this.$bvModal.show("exclusividad-modal");
            }
        },
        exclusividadSelect(opt) {
            console.log("Exclusividad seleccionada ", opt);
            this.$router.push({
                name: "DetalleContrato",
                params: { id_prov: this.contratos[this.index_selected_contrato].id_prov },
                query: { e: opt ? "y" : "n" },
            });
        },
        openCancelar() {
            this.$bvModal.show("cancelar-modal");
        },
        cancelarConfirm(text) {
            console.error("Cancelar con motivo: ", text);
        },
    },
    watch: {
        $route(to, from) {
            this.checkModeContratos();
        },
    },
    computed: {
        rows() {
            return this.contratos.length;
        },
    },

    created() {
        this.checkModeContratos();
    },
};
</script>

<style>
.cur-fake {
    cursor: pointer;
}
</style>
