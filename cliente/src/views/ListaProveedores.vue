<template>
    <card-main>
        <template #title>Proveedores</template>
        <template #content>
            <!-- Modal Detalle -->
            <modal-prov-detalle :proveedor="proveedores[index_selected_prov]" :only_view="true">
            </modal-prov-detalle>

            <b-container>
                <b-row>
                    <b-col>
                        <b-card-group columns>
                            <b-card v-for="(prov, i) in proveedores" :key="i">
                                <b-card-title>{{ prov.nombre }}</b-card-title>
                                <b-card-sub-title class="mb-4">{{ prov.pais }}</b-card-sub-title>

                                <b-button block variant="primary" @click="abrirDetalle(i)"
                                    >VER MÁS</b-button
                                >
                            </b-card>
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
            index_selected_prov: 0,
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
            this.$bvModal.show("prov-det-modal");
        },
    },
};
</script>

<style></style>
