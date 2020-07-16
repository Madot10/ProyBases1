<template>
    <card-main>
        <template v-slot:title>
            {{ mode_renovar ? "Contratos a vencer" : "Contratos" }}
        </template>
        <template v-slot:content>
            <!-- MODAL DETALLE CONTRATO -->
            <modal-contrato-detalle :contrato="contrato"></modal-contrato-detalle>

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
                :busy="isLoading"
                :per-page="perPage"
                :current-page="currentPage"
                :items="contratos"
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

                <!-- Campo exclusividad -->
                <template v-slot:cell(exclusividad)="data">
                    {{ data.value ? "Si" : "No" }}
                </template>

                <!-- Campo fecha inicio -->
                <template v-slot:cell(fecha_emision)="data">
                    {{ getDateFormated(data.value) }}
                </template>

                <!-- Campo fecha inicio -->
                <template v-slot:cell(fecha_can)="data">
                    {{ getDateFormated(data.value) }}
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
            isLoading: true,
            currentPage: 1,
            perPage: 20,
            mode_renovar: false,
            fields: [
                {
                    key: "fecha_emision",
                    label: "Fecha de emisión",
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
            contrato: {},
            contratos: [],
            index_selected_contrato: 0,
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
        verDetalleContrato(index) {
            this.index_selected_contrato = index;
            this.contrato = this.contratos[index];
            this.$bvModal.show("con-modal");
        },
        checkModeContratos() {
            this.isLoading = true;
            let url = this.$route.path;

            if (url.includes("vencer")) {
                //console.warn(url);
                //Modo mostrar BOTONES RENOVACION
                this.mode_renovar = true;
            } else {
                //nop
                this.mode_renovar = false;
            }

            this.getContratos();
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
        generateContratos(datos, datosIng) {
            let aux_cont = [];

            datos.forEach((c) => {
                if (aux_cont[c.id] == null) {
                    //Crear Contrato
                    aux_cont[c.id] = {
                        id: c.id,
                        fecha_emision: c.fecha_emision,
                        clausula: c.clausula,
                        exclusividad: c.exclusividad,
                        fecha_can: c.fecha_cancelacion,
                        motivo_cancel: c.motivo_cancel,
                        quien_cancela: c.quien_cancela,
                        ingredientes: [],
                        formas_envios: [],
                        formas_pagos: [],
                    };
                }

                if (c.id_form_envio != null) {
                    //fe

                    aux_cont[c.id].formas_envios.push({
                        id_form_envio: c.id_form_envio,
                        id_pais: c.id_pais,
                        tipo: c.tipo,
                        cargo: c.cargo,
                    });
                } else if (c.id_form_pago != null) {
                    //fp

                    aux_cont[c.id].formas_pagos.push({
                        id_form_pago: c.id_form_pago,
                        porc_inicial: c.porc_inicial,
                        tipo: c.tipo,
                        nro_cuotas: c.nro_cuotas,
                        interes_mensual: c.interes_mensual,
                        nro_dia_entre_pago: c.nro_dia_entre_pago,
                    });
                }
            });

            datosIng.forEach((ci) => {
                aux_cont[ci.id].ingredientes.push({
                    cas: ci.cas,
                    nombre: ci.nombre,
                    tipo: ci.tipo,
                    descripcion: ci.descripcion,
                    taxonomia: ci.taxonomia,
                    volumen: ci.volumen,
                    precio: ci.precio,
                });
            });

            this.contratos = aux_cont;
        },
        getContratos() {
            let idUser = this.$route.params.id;
            let urlBaseApi = "http://localhost:3000";

            let ApiContrato = urlBaseApi;
            let ApiIngContrato = urlBaseApi;

            let datosUser;
            let datosIng;

            if (this.getUserType() == "prov") {
                //Prov - activos
                ApiContrato += `/prov/${idUser}/contratos`;
                ApiIngContrato += `/prov/${idUser}/contratos/ing`;
            } else {
                //Prod
                if (this.mode_renovar) {
                    //Prox a vencer
                    datosUser = {
                        Info_Contratos: [
                            {
                                id: 2,
                                fecha_emision: "2020-10-22T04:00:00.000Z",
                                exclusividad: false,
                                clausula: null,
                                fecha_cancelacion: null,
                                motivo_cancel: null,
                                quien_cancela: null,
                                id_form_envio: null,
                                id_pais: null,
                                tipo: "cont",
                                cargo: null,
                                id_form_pago: 3,
                                porc_inicial: null,
                                nro_cuotas: null,
                                interes_mensual: null,
                                nro_dia_entre_pago: null,
                            },
                            {
                                id: 2,
                                fecha_emision: "2020-10-30T04:00:00.000Z",
                                exclusividad: false,
                                clausula: null,
                                fecha_cancelacion: null,
                                motivo_cancel: null,
                                quien_cancela: null,
                                id_form_envio: null,
                                id_pais: null,
                                tipo: "cred",
                                cargo: null,
                                id_form_pago: 4,
                                porc_inicial: "35",
                                nro_cuotas: "10",
                                interes_mensual: "7",
                                nro_dia_entre_pago: "15",
                            },
                            {
                                id: 2,
                                fecha_emision: "2020-10-19T04:00:00.000Z",
                                exclusividad: false,
                                clausula: null,
                                fecha_cancelacion: null,
                                motivo_cancel: null,
                                quien_cancela: null,
                                id_form_envio: 4,
                                id_pais: 220,
                                tipo: null,
                                cargo: "12",
                                id_form_pago: null,
                                porc_inicial: null,
                                nro_cuotas: null,
                                interes_mensual: null,
                                nro_dia_entre_pago: null,
                            },
                            {
                                id: 6,
                                fecha_emision: "2018-02-14T04:00:00.000Z",
                                exclusividad: false,
                                clausula: null,
                                fecha_cancelacion: null,
                                motivo_cancel: null,
                                quien_cancela: null,
                                id_form_envio: 9,
                                id_pais: 179,
                                tipo: null,
                                cargo: "18",
                                id_form_pago: null,
                                porc_inicial: null,
                                nro_cuotas: null,
                                interes_mensual: null,
                                nro_dia_entre_pago: null,
                            },
                            {
                                id: 6,
                                fecha_emision: "2018-02-14T04:00:00.000Z",
                                exclusividad: false,
                                clausula: null,
                                fecha_cancelacion: null,
                                motivo_cancel: null,
                                quien_cancela: null,
                                id_form_envio: null,
                                id_pais: null,
                                tipo: "cont",
                                cargo: null,
                                id_form_pago: 7,
                                porc_inicial: null,
                                nro_cuotas: null,
                                interes_mensual: null,
                                nro_dia_entre_pago: null,
                            },
                            {
                                id: 6,
                                fecha_emision: "2018-02-14T04:00:00.000Z",
                                exclusividad: false,
                                clausula: null,
                                fecha_cancelacion: null,
                                motivo_cancel: null,
                                quien_cancela: null,
                                id_form_envio: null,
                                id_pais: null,
                                tipo: "cred",
                                cargo: null,
                                id_form_pago: 8,
                                porc_inicial: "40",
                                nro_cuotas: "5",
                                interes_mensual: "2",
                                nro_dia_entre_pago: "20",
                            },
                        ],
                    };

                    datosIng = {
                        Ingredientes_Contratos: [
                            {
                                id: 2,
                                cas: 586629,
                                nombre: "Terpinolene-40",
                                tipo: "q",
                                descripcion:
                                    "Es un químico con  una fragancia dulce, fresca, cítrica de pino con un viejo matiz de cáscara de limón.",
                                taxonomia:
                                    "Mezcla de 1-metil-4-propan-2-ilideneciclohexeno y terpenos",
                                volumen: "5000",
                                precio: "20.00",
                            },
                            {
                                id: 2,
                                cas: 586629,
                                nombre: "Terpinolene-40",
                                tipo: "q",
                                descripcion:
                                    "Es un químico con  una fragancia dulce, fresca, cítrica de pino con un viejo matiz de cáscara de limón.",
                                taxonomia:
                                    "Mezcla de 1-metil-4-propan-2-ilideneciclohexeno y terpenos",
                                volumen: "170000",
                                precio: "600.00",
                            },
                            {
                                id: 2,
                                cas: 586629,
                                nombre: "Terpinolene-40",
                                tipo: "q",
                                descripcion:
                                    "Es un químico con  una fragancia dulce, fresca, cítrica de pino con un viejo matiz de cáscara de limón.",
                                taxonomia:
                                    "Mezcla de 1-metil-4-propan-2-ilideneciclohexeno y terpenos",
                                volumen: "900000",
                                precio: "3000.00",
                            },
                            {
                                id: 2,
                                cas: 4707475,
                                nombre: "Prionyl",
                                tipo: "q",
                                descripcion:
                                    "Es un químico en el que prevalecen los olores de musgo de roble, leñoso, fenólico y terroso",
                                taxonomia: "2,4-dihidroxi-3,6-dimetilbenzoato de metilo",
                                volumen: "15000",
                                precio: "53.00",
                            },
                            {
                                id: 6,
                                cas: 110383,
                                nombre: "Decanoato de etilo",
                                tipo: "q",
                                descripcion:
                                    "También conocido como caprato de etilo, es un éster de ácido graso formado a partir de ácido cáprico y etanol",
                                taxonomia: "C12 H24O2",
                                volumen: "1",
                                precio: "52.00",
                            },
                            {
                                id: 6,
                                cas: 110383,
                                nombre: "Decanoato de etilo",
                                tipo: "q",
                                descripcion:
                                    "También conocido como caprato de etilo, es un éster de ácido graso formado a partir de ácido cáprico y etanol",
                                taxonomia: "C12 H24O2",
                                volumen: "5",
                                precio: "233.00",
                            },
                            {
                                id: 6,
                                cas: 8015956,
                                nombre: "Cinnamon",
                                tipo: "q",
                                descripcion: "Aceite de esencia de hojas de safrol reducido",
                                taxonomia: "Cinamaldehído",
                                volumen: "1000",
                                precio: "114.00",
                            },
                            {
                                id: 6,
                                cas: 8015956,
                                nombre: "Cinnamon",
                                tipo: "q",
                                descripcion: "Aceite de esencia de hojas de safrol reducido",
                                taxonomia: "Cinamaldehído",
                                volumen: "5000",
                                precio: "564.00",
                            },
                            {
                                id: 6,
                                cas: 8007010,
                                nombre: "Aceite Rosa centifolia",
                                tipo: "n",
                                descripcion:
                                    "también denominada rosa de Provenza o rosa repollo o rosa de mayo es un híbrido de rosa conseguido en el siglo XVII",
                                taxonomia: "Rosa X Centifolia",
                                volumen: "1000",
                                precio: "9.00",
                            },
                            {
                                id: 6,
                                cas: 8007010,
                                nombre: "Aceite Rosa centifolia",
                                tipo: "n",
                                descripcion:
                                    "también denominada rosa de Provenza o rosa repollo o rosa de mayo es un híbrido de rosa conseguido en el siglo XVII",
                                taxonomia: "Rosa X Centifolia",
                                volumen: "5000",
                                precio: "42.00",
                            },
                            {
                                id: 6,
                                cas: 8007010,
                                nombre: "Aceite Rosa centifolia",
                                tipo: "n",
                                descripcion:
                                    "también denominada rosa de Provenza o rosa repollo o rosa de mayo es un híbrido de rosa conseguido en el siglo XVII",
                                taxonomia: "Rosa X Centifolia",
                                volumen: "25000",
                                precio: "160.00",
                            },
                        ],
                    };
                } else {
                    //activos
                    ApiContrato += `/prod/${idUser}/contratos`;
                    ApiIngContrato += `/prod/${idUser}/contratos/ing`;
                }
            }

            //Info de contrato
            fetch(ApiContrato)
                .then((response) => {
                    return response.json();
                })
                .then((cont) => {
                    datosUser = cont;

                    //Info ingredientes contratos
                    fetch(ApiIngContrato)
                        .then((response) => {
                            return response.json();
                        })
                        .then((ings) => {
                            datosIng = ings;

                            console.log("INGS ", ings);

                            this.generateContratos(
                                datosUser.Info_Contratos,
                                datosIng.Ingredientes_Contratos
                            );
                            this.isLoading = false;
                        });
                });
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
