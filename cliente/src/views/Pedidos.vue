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

                <!-- Campo fecha inicio 
                <template v-slot:cell(fecha_emision)="data">
                    {{ getDateFormated(data.value) }}
                </template>-->

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
                    key: "prov_nombre",
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
            pedidos: [
                {
                    id: 1,
                    fecha_emision: "12/07/2020",
                    total_usd: 569.2,
                    subtotal_usd: 100.5,
                    estado: "a",
                    fecha_confirmacion: "17/07/2020",
                    nro_factura: 694765,
                    motivo_cancel: null,
                    forma_envio: { tipo: "Maritimo", recargo: "10", pais: "Venezuela" },
                    forma_pago: {
                        tipo: "Contado",
                        porc_inicial: "15",
                        nro_cuotas: "2",
                        int_mensual: "6",
                    },

                    detalle: [
                        { cas: 9999, nombre: "Aceite", volumen: "50", precio: 12, cantidad: 5 },
                        { cas: 9999, nombre: "Aceite", volumen: "50", precio: 2, cantidad: 1 },
                        { cas: 9999, nombre: "Aceite", volumen: "50", precio: 11, cantidad: 7 },
                    ],
                },
                {
                    id: 2,
                    fecha_emision: "12/01/2019",
                    total_usd: 100.2,
                    subtotal_usd: 55.5,
                    estado: "a",
                    fecha_confirmacion: "17/01/2020",
                    nro_factura: 9999,
                    motivo_cancel: null,
                    forma_envio: { tipo: "Maritimo", recargo: "10", pais: "Venezuela" },
                    forma_pago: {
                        tipo: "Contado",
                        porc_inicial: "15",
                        nro_cuotas: "2",
                        int_mensual: "6",
                    },

                    detalle: [
                        { cas: 9999, nombre: "Aceite", volumen: "50", precio: 12, cantidad: 5 },
                        { cas: 9999, nombre: "Aceite", volumen: "50", precio: 12, cantidad: 5 },
                        { cas: 9999, nombre: "Aceite", volumen: "50", precio: 12, cantidad: 5 },
                    ],
                },
            ],
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
        },
        openAprobModal(index) {
            this.index_selected_pedido = index;
            this.pedido = this.pedidos[index];
            this.only_view = false;

            this.$bvModal.show("pe-modal");
        },
        aprobarSelected() {
            console.log("Aprobuebeseeee");
        },
        openCancelar(index) {
            this.index_selected_pedido = index;
            this.pedido = this.pedidos[index];

            this.$bvModal.show("cancelar-modal");
        },
        cancelarConfirm(text) {
            console.log("Cancelando ", this.pedido);
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
