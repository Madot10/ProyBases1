<template>
    <card-main>
        <template v-slot:title>
            {{ mode_pen ? "Pedidos pendientes" : "Pedidos" }}
        </template>
        <template v-slot:content>
            <!-- Aviso -->
            <b-toast id="toast-aviso" :variant="aviso.tipo" :title="aviso.titulo" solid>
                {{ aviso.mensaje }}
            </b-toast>

            <!-- MODAL DETALLE PEDIDO -->
            <modal-pedido-detalle
                :pedido="pedido"
                :only_view="only_view"
                @aprobar="aprobarSelected"
            ></modal-pedido-detalle>

            <!-- MODAL CANCELAR -->
            <modal-cancelar @optionCancelar="cancelarConfirm" :mode_con="false"></modal-cancelar>

            <!-- TABLA small -->
            <b-table
                striped
                hover
                :busy="isLoading"
                :per-page="perPage"
                :current-page="currentPage"
                :items="pedidos"
                :fields="fields"
                id="pe-table"
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

                <!--Campo fecha inicio -->
                <template v-slot:cell(fecha_emision)="data">
                    {{ getDateFormated(data.value) }}
                </template>

                <!-- Cell estado -->
                <template v-slot:cell(estado)="row">
                    {{ row.value == "a" ? "Aprobado" : "Pendiente" }}
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
                        @click="verDetallePedido(row.index)"
                    ></b-icon>
                </template>
                <template v-slot:cell(acciones2)="row">
                    <!-- {{ row.index }} -->
                    <b-button
                        v-show="mode_pen"
                        variant="outline-primary"
                        @click="openAprobModal(row.index)"
                        >APROBAR</b-button
                    >
                    <span v-show="mode_pen"> - </span>
                    <b-button
                        v-show="mode_pen"
                        variant="outline-danger"
                        @click="openCancelar(row.index)"
                        >CANCELAR</b-button
                    >
                </template>
            </b-table>

            <b-pagination
                v-model="currentPage"
                :total-rows="rows"
                :per-page="perPage"
                align="center"
                aria-controls="pe-table"
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
import ModalPedidoDetalle from "../components/ModalPedidoDetalle.vue";
import ModalCancelar from "../components/ModalCancelar.vue";

export default {
    components: {
        CardMain,
        ModalCancelar,
        ModalPedidoDetalle,
    },
    data() {
        return {
            aviso: { mensaje: "", titulo: "", tipo: "success" },
            isLoading: true,
            currentPage: 1,
            perPage: 20,
            mode_pen: false,
            fields: [
                { key: "estado", label: "Estado", sortable: true },
                {
                    key: "fecha_emision",
                    label: "Fecha de emisión",
                    sortable: false,
                },
                {
                    key: "prov_nom",
                    label: "Empresa",
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
            pedido: {},
            pedidos: [],
            index_selected_pedido: 0,
            only_view: true,
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
        getUserType(url = this.$route.path) {
            if (url.includes("prov")) {
                return "prov";
            } else {
                return "prod";
            }
        },
        verDetallePedido(index) {
            this.index_selected_pedido = index;
            this.pedido = this.pedidos[index];
            this.only_view = true;

            this.$bvModal.show("pe-modal");
        },
        checkModePedidos() {
            this.isLoading = false;
            //this.isLoading = true;
            let url = this.$route.path;

            if (url.includes("pendientes")) {
                //console.warn(url);
                //Modo mostrar BOTONES PENDIENTE
                this.mode_pen = true;
            } else {
                //nop
                this.mode_pen = false;
            }

            this.getPedidos();
        },
        openAprobModal(index) {
            this.index_selected_pedido = index;
            this.pedido = this.pedidos[index];
            this.only_view = false;

            this.$bvModal.show("pe-modal");
        },
        aprobarSelected(nro_fact) {
            console.log("Aprobuebeseeee", nro_fact);

            let idUser = this.$route.params.id;
            let urlApi = `http://localhost:3000/prov/${idUser}/pedido/aprobar/${this.pedido.id}`;

            let obj_apro = {
                nro_factura: Number(nro_fact),
            };

            fetch(urlApi, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(obj_apro),
            })
                .then((response) => {
                    return response.json();
                })
                .then((res) => {
                    console.log("Servidor dice Aprobado: ", res);

                    //Quitar de la lista
                    this.pedidos.splice(this.index_selected_pedido, 1);
                });
        },
        openCancelar(index) {
            this.index_selected_pedido = index;
            this.pedido = this.pedidos[index];

            this.$bvModal.show("cancelar-modal");
        },
        cancelarConfirm(res) {
            let idUser = this.$route.params.id;
            console.log("Cancelando ", this.pedido, res);

            let urlApi = `http://localhost:3000/prov/${idUser}/pedido/cancelar/${this.pedido.id}`;
            let obj_can = {
                motivo_cancel: res.text,
            };

            fetch(urlApi, {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(obj_can),
            })
                .then((response) => {
                    return response.json();
                })
                .then((resp) => {
                    //Quitar de la lista
                    this.pedidos.splice(this.index_selected_pedido, 1);
                });
        },
        generatePedidos(pes, fes, fps) {
            let aux_pe = [];

            pes.forEach((p) => {
                if (aux_pe[p.id || p.pedid] == null) {
                    aux_pe[p.id || p.pedid] = {
                        id: p.id || p.pedid,
                        prov_nom: p.prov_nom,
                        fecha_emision: p.f_emision,
                        total_usd: Number(p.total_usd),
                        subtotal_usd: Number(p.subtotal_usd),
                        estado: p.estado.trim(),
                        nro_factura: null,
                        forma_envio: {},
                        forma_pago: {},
                        detalle: [],
                    };
                }

                aux_pe[p.id || p.pedid].detalle.push({
                    cas: Number(p.cas),
                    nombre: p.nombre,
                    volumen: Number(p.volumen),
                    precio: Number(p.precio),
                    cantidad: Number(p.cantidad),
                });
            });

            fes.forEach((fe) => {
                aux_pe[fe.id_pedido].forma_envio = {
                    tipo: fe.tipo,
                    cargo: Number(fe.cargo),
                    pais: fe.nombre_pais,
                };
            });

            fps.forEach((fp) => {
                aux_pe[fp.id_pedido].forma_pago = {
                    tipo: fp.tipo,
                    porc_inicial: fp.porc_inicial,
                    nro_cuotas: fp.nro_cuotas,
                    int_mensual: Number(fp.interes_mensual),
                };
            });

            this.pedidos = aux_pe;
        },
        getPedidos() {
            let idUser = this.$route.params.id;
            let urlBaseApi = "http://localhost:3000";

            let ApiContrato = urlBaseApi;
            let ApiFEContrato = urlBaseApi;
            let ApiFPContrato = urlBaseApi;

            if (this.getUserType() == "prov") {
                //Prov
                if (this.mode_pen) {
                    //Pendientes
                    ApiContrato += `/prov/${idUser}/pedidos/pendientes`;
                    ApiFEContrato += `/prov/${idUser}/pedidos/pendientes/fe`;
                    ApiFPContrato += `/prov/${idUser}/pedidos/pendientes/fp`;
                } else {
                    //todos
                    ApiContrato += `/prov/${idUser}/pedidos/`;
                    ApiFEContrato += `/prov/${idUser}/pedidos/fe`;
                    ApiFPContrato += `/prov/${idUser}/pedidos/fp`;
                }
            } else {
                //Prod
                ApiContrato += `/prod/${idUser}/pedidos/`;
                ApiFEContrato += `/prod/${idUser}/pedidos/fe`;
                ApiFPContrato += `/prod/${idUser}/pedidos/fp`;
            }

            let datosPe;
            let datosFe;
            let datosFp;

            fetch(ApiContrato)
                .then((response) => {
                    return response.json();
                })
                .then((pe) => {
                    datosPe = pe;
                    console.log("PEDIDOS ", pe);

                    //FE
                    fetch(ApiFEContrato)
                        .then((response) => {
                            return response.json();
                        })
                        .then((fes) => {
                            datosFe = fes;
                            console.log("FES ", fes);
                            //FP
                            fetch(ApiFPContrato)
                                .then((response) => {
                                    return response.json();
                                })
                                .then((fps) => {
                                    datosFp = fps;
                                    console.log("FPS ", fps);
                                    this.generatePedidos(
                                        datosPe.Info_Pedidos_Pendientes || datosPe.Info_Pedidos,
                                        datosFe.Info_Pedidos_Pendientes,
                                        datosFp.Info_Pedidos_Pendientes
                                    );
                                });
                        });
                });
        },
    },
    watch: {
        $route(to, from) {
            this.checkModePedidos();
        },
    },
    computed: {
        rows() {
            return this.pedidos.length;
        },
    },
    created() {
        this.checkModePedidos();
    },
};
</script>

<style>
.cur-fake {
    cursor: pointer;
}
</style>
