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
                    formas_envios: [
                        { idfe: 2, tipo: "m", cargo: "10", pais: "Venezuela" },
                        { idfe: 2, tipo: "a", cargo: "5", pais: "Corea" },
                    ],
                    formas_pagos: [
                        {
                            idfp: 3,
                            tipo: "cont",
                            porc_inicial: null,
                            nro_cuotas: null,
                            int_mensual: null,
                        },
                        {
                            idfp: 3,
                            tipo: "cred",
                            porc_inicial: "15",
                            nro_cuotas: "2",
                            interes_mensual: "6",
                        },
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

            this.$router.push({
                name: "PedidosDetalle",
                params: {
                    id_prov: this.proveedor.id,
                    datosProv: this.proveedor,
                },
            });
        },
        generateProv(provs, fes, fps) {
            let aux_prov = [];

            provs.forEach((p) => {
                if (aux_prov[p.id] == null) {
                    aux_prov[p.id] = {
                        nombre: p.nombre,
                        email: p.email,
                        telefono: p.telefono,
                        pag_web: p.pag_web,
                        pais: null,
                        ingredientes: [],
                        formas_envios: [],
                        formas_pagos: [],
                    };
                }

                aux_prov[p.id].ingredientes.push({
                    cas: Number(p.cas),
                    nombre: p.nombre,
                    tipo: p.tipo,
                    volumen: Number(p.volumen),
                    precio: Number(p.precio),
                });
            });

            fes.forEach((fe) => {
                aux_prov[fe.id_prov].formas_envios.push({
                    idfe: fe.id_fe,
                    tipo: fe.tipo,
                    cargo: Number(fe.cargo),
                    pais: fe.nombre,
                });
            });

            fps.forEach((fp) => {
                aux_prov[fp.id_proveedor].formas_pagos.push({
                    idfp: fp.id_fp,
                    tipo: fp.tipo,
                    porc_inicial: fp.porc_inicial,
                    nro_cuotas: fp.nro_cuotas,
                    int_mensual: fp.interes_mensual,
                });
            });

            this.proveedores = aux_prov;
        },
        getProveedores() {
            let datosProvs = {
                Lista_de_proveedores: [
                    {
                        id: 3,
                        nombre: "Acetato de Benzilo",
                        email: "contact@tennantsfinechemicals.co.uk",
                        telefono: "1538399100",
                        pag_web: "www.tennantsfinechemicals.co.uk",
                        cas: "140114",
                        tipo: "q",
                        volumen: "100",
                        precio: "3.00",
                    },
                    {
                        id: 3,
                        nombre: "Acetato de Benzilo",
                        email: "contact@tennantsfinechemicals.co.uk",
                        telefono: "1538399100",
                        pag_web: "www.tennantsfinechemicals.co.uk",
                        cas: "140114",
                        tipo: "q",
                        volumen: "10000",
                        precio: "2500.00",
                    },
                    {
                        id: 3,
                        nombre: "Aldehído Cinámico Amilo",
                        email: "contact@tennantsfinechemicals.co.uk",
                        telefono: "1538399100",
                        pag_web: "www.tennantsfinechemicals.co.uk",
                        cas: "78605966",
                        tipo: "q",
                        volumen: "100",
                        precio: "55.00",
                    },
                ],
            };
            let datosFe = {
                Lista_de_fe_proveedores: [
                    { id_prov: 3, id_fe: 8, nombre: "Sudáfrica", tipo: "a", cargo: "13" },
                ],
            };
            let datosFP = {
                Lista_de_fp_proveedores: [
                    {
                        id_proveedor: 3,
                        id_fp: 5,
                        tipo: "cont",
                        porc_inicial: null,
                        nro_cuotas: null,
                        interes_mensual: null,
                        nro_dia_entre_pago: null,
                    },
                ],
            };

            this.generateProv(
                datosProvs.Lista_de_proveedores,
                datosFe.Lista_de_fe_proveedores,
                datosFP.Lista_de_fp_proveedores
            );
        },
    },

    created() {
        this.getProveedores();
        this.isLoading = false;
    },
};
</script>

<style></style>
