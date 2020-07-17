<template>
    <card-main>
        <template #title>Proveedores</template>
        <template #content>
            <!-- Modal Detalle -->
            <modal-prov-detalle :proveedor="proveedor" :only_view="true"> </modal-prov-detalle>
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
            proveedores: [],
        };
    },
    methods: {
        abrirDetalle(index) {
            this.index_selected_prov = index;
            this.proveedor = this.proveedores[index];

            this.$bvModal.show("prov-det-modal");
        },
        generateProveedor(datos, datosFe, datosFp) {
            let aux_prov = [];

            datos.forEach((p) => {
                if (aux_prov[p.id_prov] == null) {
                    //Crear Proveedor
                    aux_prov[p.id_prov] = {
                        id: p.id_prov,
                        email: p.email,
                        nombre: p.nombre_prov,
                        pag_web: p.pag_web,
                        telefono: p.telefono,
                        pais: p.nombre_pais,
                        ingredientes: [],
                        formas_envios: [],
                        formas_pagos: [],
                    };
                }

                //Agregar ing
                aux_prov[p.id_prov].ingredientes.push({
                    cas: p.cas,
                    nombre: p.nombre_ing,
                    tipo: p.tipo_ing,
                    volumen: p.volumen,
                    precio: p.precio,
                });
            });

            datosFe.forEach((feP) => {
                aux_prov[feP.id_prov].formas_envios.push({
                    id_form_envio: feP.id_fe,
                    pais: feP.destino,
                    tipo: feP.tipo_fe,
                    cargo: feP.cargo,
                });
            });

            datosFp.forEach((fpP) => {
                aux_prov[fpP.id_prov].formas_pagos.push({
                    id_form_pago: fpP.id_fp,
                    porc_inicial: fpP.porc_inicial,
                    tipo: fpP.tipo_fp,
                    nro_cuotas: fpP.nro_cuotas,
                    interes_mensual: fpP.interes_mensual,
                    nro_dia_entre_pago: fpP.nro_dia_entre_pago,
                });
            });

            this.proveedores = aux_prov;
            this.isLoading = false;
        },
    },
    created() {
        let idUser = this.$route.params.id;

        fetch(`http://localhost:3000/prod/${idUser}/proveedores`)
            .then((response) => {
                return response.json();
            })
            .then((provs) => {
                //PROVEEDORES
                console.log("PROVS ", provs);

                fetch(`http://localhost:3000/prod/${idUser}/proveedores/fe`)
                    .then((response) => {
                        return response.json();
                    })
                    .then((fes) => {
                        //FE
                        console.log("FES", fes);

                        fetch(`http://localhost:3000/prod/${idUser}/proveedores/fp`)
                            .then((response) => {
                                return response.json();
                            })
                            .then((fps) => {
                                //FE FP
                                console.log("FPS", fps);
                                this.generateProveedor(
                                    provs.Proveedores,
                                    fes.Fe_de_proveedores,
                                    fps.Fp_de_proveedores
                                );
                            });
                    });
            });
    },
};
</script>

<style></style>
