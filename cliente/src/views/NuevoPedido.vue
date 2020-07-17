<template>
    <card-main>
        <template #title>Nuevo Pedido</template>
        <template #content>
            <!-- Modal Detalle -->
            <modal-prov-detalle
                :proveedor="proveedor"
                :only_view="false"
                mode="p"
                @ok="pedirSelected"
            >
            </modal-prov-detalle>

            <div class="text-center" v-show="isLoading">
                <b-spinner variant="primary" label="Cargando..."></b-spinner>
            </div>

            <b-container>
                <b-row>
                    <b-col>
                        <b-card-group columns>
                            <div v-for="(prov, i) in proveedores" :key="i">
                                <b-card v-if="prov">
                                    <b-card-title>{{ prov.nombre }}</b-card-title>
                                    <b-card-sub-title class="mb-4">{{
                                        prov.pais
                                    }}</b-card-sub-title>

                                    <b-button block variant="primary" @click="abrirDetalle(i)"
                                        >VER MÁS</b-button
                                    >
                                </b-card>
                            </div>
                        </b-card-group>
                    </b-col>
                </b-row>
            </b-container>
        </template>
    </card-main>
</template>

<script>
import CardMain from "../components/CardMain.vue";
import ModalProvDetalle from "../components/ModalProvDetalle.vue";

export default {
    components: {
        CardMain,
        ModalProvDetalle,
    },
    data() {
        return {
            isLoading: true,
            index_selected_prov: 0,
            proveedor: {},
            proveedores: [
                {
                    id: 1,
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
                    id: 2,
                    nombre: "Empresita 2",
                    email: "test@dsfdsfsdfsdf.com",
                    telefono: 2124423258,
                    pag_web: "www.gsdsadsaoogle.com",
                    pais: "Estados Unidos de America",
                },
                { nombre: "Empresita 3", pais: "Israel", email: "sdfdsf@sdgfds.sd" },
            ],
        };
    },
    methods: {
        abrirDetalle(index) {
            this.index_selected_prov = index;
            this.proveedor = this.proveedores[index];

            this.$bvModal.show("prov-det-modal");
        },
        pedirSelected() {
            //Iniciar proceso de pedido
            console.log("Pidiendo");
        },
    },

    created() {
        this.isLoading = false;
    },
};
</script>

<style></style>
