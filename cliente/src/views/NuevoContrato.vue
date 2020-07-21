<template>
    <card-main>
        <template #title>Nuevo Contrato</template>
        <template #content>
            <!-- Aviso -->
            <b-toast id="toast-aviso" :variant="aviso.tipo" :title="aviso.titulo" solid>
                {{ aviso.mensaje }}
            </b-toast>

            <!-- MODAL PREG EVAL -->
            <modal-preg-eval :prov="proveedor" @vaContrato="openExclModal"></modal-preg-eval>

            <!-- MODAL DETALLE PROV -->
            <modal-prov-detalle
                :proveedor="proveedor"
                @ok="continuarEvaluarProv"
                :only_view="false"
                mode="e"
            ></modal-prov-detalle>

            <!-- MODAL EXCLUSIVIDAD -->
            <modal-exclusividad
                @optionSelect="exclSelect"
                :proveedor="proveedor"
            ></modal-exclusividad>

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
                show-empty
            >
                <!--- VACIO -->
                <template v-slot:empty>
                    <h6 class="text-center">No hay registros que mostrar</h6>
                </template>

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
import ModalPregEval from "../components/ModalPregEval.vue";

export default {
    components: {
        CardMain,
        ModalProvDetalle,
        ModalExclusividad,
        ModalPregEval,
    },
    data() {
        return {
            aviso: { mensaje: "", titulo: "", tipo: "success" },
            isLoadingProv: true,
            index_selected_prov: 0,
            proveedor: {},
            proveedores: [],
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
            this.proveedor = this.proveedores[this.index_selected_prov];
            this.$bvModal.show("prov-det-modal");
        },
        continuarEvaluarProv() {
            console.log("A EVALUAR EL PROV ", this.index_selected_prov);
            this.$bvModal.show("eval-preg-modal");
        },
        openExclModal() {
            this.$bvModal.show("exclusividad-modal");
        },
        exclSelect(newIngs, opt) {
            //console.log("Exclusividad seleccionada ", opt);
            let aux_prov = this.proveedor;

            if (newIngs.Lista_de_proveedores.length > 0) {
                //Hay ingredientes para contratar
                //console.log("Hay elementos ", newIngs.Lista_de_proveedores.length);

                aux_prov.ingredientes = [];

                newIngs.Lista_de_proveedores.forEach((ing) => {
                    aux_prov.ingredientes.push({
                        cas: ing.cas,
                        nombre: ing.nombre,
                        tipo: ing.tipo,
                    });
                });

                //console.log("A enviar", aux_prov);

                this.$router.push({
                    name: "DetalleContrato",
                    params: {
                        id_prov: this.proveedores[this.index_selected_prov].id,
                        datosProv: aux_prov,
                    },
                    query: { e: opt ? "y" : "n" },
                });
            } else {
                //No hay ingredientes para contratar
                this.aviso.mensaje = "¡No se tiene ingredientes disponibles para esta solicitud!";
                this.aviso.titulo = "Aviso";
                this.aviso.tipo = "danger";
                this.$bvToast.show("toast-aviso");
            }
        },
        generateProveedor(datos, datosFe, datosFp, datosIng) {
            let aux_prov = [];

            datos.forEach((p) => {
                if (aux_prov[p.provid] == null) {
                    //Crear Proveedor
                    aux_prov[p.provid] = {
                        id: p.provid,
                        email: p.email,
                        nombre: p.nombre,
                        pag_web: p.pag_web,
                        telefono: p.telefono,
                        pais: p.paisnombre,
                        ingredientes: [],
                        formas_envios: [],
                        formas_pagos: [],
                    };
                }
            });

            datosFe.forEach((feP) => {
                aux_prov[feP.provid].formas_envios.push({
                    id_form_envio: feP.id,
                    pais: feP.nombre,
                    id_pais: feP.paisid,
                    tipo: feP.tipo,
                    cargo: feP.cargo,
                });
            });

            datosFp.forEach((fpP) => {
                aux_prov[fpP.provid].formas_pagos.push({
                    id_form_pago: fpP.id,
                    porc_inicial: fpP.porc_inicial,
                    tipo: fpP.tipo,
                    nro_cuotas: fpP.nro_cuotas,
                    interes_mensual: fpP.interes_mensual,
                    nro_dia_entre_pago: fpP.nro_dia_entre_pago,
                });
            });

            datosIng.forEach((ingP) => {
                aux_prov[ingP.provid].ingredientes.push({
                    cas: ingP.cas,
                    nombre: ingP.nombre,
                    tipo: ingP.tipo,
                    volumen: ingP.volumen,
                    precio: ingP.precio,
                });
            });

            this.proveedores = aux_prov;
            this.isLoadingProv = false;
        },
    },
    created() {
        let idUser = this.$route.params.id;

        fetch(`http://localhost:3000/prod/${idUser}/contratos/nuevo`)
            .then((response) => {
                return response.json();
            })
            .then((provs) => {
                //Proveedores
                console.log("PROVS", provs);

                fetch(`http://localhost:3000/prod/${idUser}/contratos/nuevo/fe`)
                    .then((response) => {
                        return response.json();
                    })

                    .then((fes) => {
                        //Formas de envios
                        console.log("FES ", fes);

                        fetch(`http://localhost:3000/prod/${idUser}/contratos/nuevo/fp`)
                            .then((response) => {
                                return response.json();
                            })

                            .then((fps) => {
                                //Formas de pagos
                                console.log("FPS ", fps);

                                fetch(`http://localhost:3000/prod/${idUser}/contratos/nuevo/ing`)
                                    .then((response) => {
                                        return response.json();
                                    })

                                    .then((ings) => {
                                        //Ingredientes
                                        console.log("Ings ", ings);

                                        //GENERAR TODOS
                                        this.generateProveedor(
                                            provs.Lista_de_proveedores,
                                            fes.Lista_de_formas_de_envio,
                                            fps.Lista_de_formas_de_pago,
                                            ings.Lista_de_ingredientes
                                        );
                                    });
                            });
                    });
            });
    },
};
</script>

<style></style>
