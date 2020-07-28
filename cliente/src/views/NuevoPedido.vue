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
                        <h3 v-show="proveedores.length == 0">No posee proveedores disponibles</h3>
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
            proveedores: [],
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
                    id: this.$route.params.id,
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
                        id: p.id,
                        cont_id: p.cont_id,
                        nombre: p.nom_prov,
                        email: p.email,

                        telefono: p.telefono,
                        pag_web: p.pag_web,
                        pais: p.nom_pais,
                        ingredientes: [],
                        formas_envios: [],
                        formas_pagos: [],
                    };
                }

                aux_prov[p.id].ingredientes.push({
                    cas: Number(p.cas),
                    nombre: p.nom_ing,
                    tipo: p.tipo,
                    id_pres: p.presid,
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
            let idUser = this.$route.params.id;
            let urlBaseApi = "http://localhost:3000/prod/";

            let ApiProvs = urlBaseApi + `${idUser}/pedido/nuevo`;
            let ApiProvsFE = urlBaseApi + `${idUser}/pedido/nuevo/fe`;
            let ApiProvsFP = urlBaseApi + `${idUser}/pedido/nuevo/fp`;

            let datosProvs;
            let datosFe;
            let datosFP;

            fetch(ApiProvs)
                .then((response) => {
                    return response.json();
                })
                .then((provs) => {
                    console.log("PROVS ", provs);
                    datosProvs = provs;

                    fetch(ApiProvsFE)
                        .then((response) => {
                            return response.json();
                        })
                        .then((fes) => {
                            console.log("fes ", fes);
                            datosFe = fes;

                            fetch(ApiProvsFP)
                                .then((response) => {
                                    return response.json();
                                })
                                .then((fps) => {
                                    console.log("fps ", fps);
                                    datosFP = fps;

                                    this.generateProv(
                                        datosProvs.Lista_de_proveedores,
                                        datosFe.Lista_de_fe_proveedores,
                                        datosFP.Lista_de_fp_proveedores
                                    );
                                });
                        });
                });
        },
    },

    created() {
        this.getProveedores();
        this.isLoading = false;
    },
};
</script>

<style></style>
