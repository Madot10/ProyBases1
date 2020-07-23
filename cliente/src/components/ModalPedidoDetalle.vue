<template>
    <b-modal id="pe-modal" centered size="xl" title="Pedido">
        <!-- CONTENIDO MODAL -->
        <b-container fluid>
            <b-row>
                <b-col>
                    <b-form-group
                        label="Datos básicos"
                        label-cols="3"
                        label-class="font-weight-bold"
                    >
                        <!-- F_emision -->
                        <b-form-group
                            label-cols-sm="5"
                            label="Fecha de emisión:"
                            label-align-sm="right"
                        >
                            <b-form-input
                                plaintext
                                :value="getDateFormated(pedido.fecha_emision)"
                            ></b-form-input>
                        </b-form-group>

                        <!-- Estado -->
                        <b-form-group label-cols-sm="5" label="Estado:" label-align-sm="right">
                            <b-form-input
                                plaintext
                                :value="pedido.estado == 'a' ? 'Aprobado' : 'Pendiente'"
                            ></b-form-input>
                        </b-form-group>
                    </b-form-group>

                    <!-- Forma de envío-->
                    <b-form-group
                        label="Forma de envío"
                        label-cols="3"
                        label-class="font-weight-bold"
                    >
                        <!-- Tipo -->
                        <b-form-group label-cols-sm="5" label="Tipo:" label-align-sm="right">
                            <b-form-input
                                plaintext
                                :value="
                                    pedido.hasOwnProperty('forma_envio')
                                        ? pedido.forma_envio.tipo == 'm'
                                            ? 'Marítimo'
                                            : pedido.forma_envio.tipo == 'a'
                                            ? 'Áereo'
                                            : 'Terrestre'
                                        : ''
                                "
                            ></b-form-input>
                        </b-form-group>

                        <!-- Cargo -->
                        <b-form-group label-cols-sm="5" label="Cargo (%):" label-align-sm="right">
                            <b-form-input
                                plaintext
                                :value="
                                    pedido.hasOwnProperty('forma_envio')
                                        ? pedido.forma_envio.cargo
                                        : ''
                                "
                            ></b-form-input>
                        </b-form-group>

                        <!-- Destino -->
                        <b-form-group label-cols-sm="5" label="Destino:" label-align-sm="right">
                            <b-form-input
                                plaintext
                                :value="
                                    pedido.hasOwnProperty('forma_envio')
                                        ? pedido.forma_envio.pais
                                        : ''
                                "
                            ></b-form-input>
                        </b-form-group>
                    </b-form-group>

                    <!-- Forma de pago-->
                    <b-form-group
                        label="Forma de pago"
                        label-cols="3"
                        label-class="font-weight-bold"
                    >
                        <!-- Tipo -->
                        <b-form-group label-cols-sm="5" label="Tipo:" label-align-sm="right">
                            <b-form-input
                                plaintext
                                :value="
                                    pedido.hasOwnProperty('forma_envio')
                                        ? pedido.forma_pago.tipo == 'cred'
                                            ? 'Crédito'
                                            : 'Contado'
                                        : ''
                                "
                            ></b-form-input>
                        </b-form-group>

                        <!-- Porcentaje inicial (%) -->
                        <b-form-group
                            label-cols-sm="5"
                            label="Porcentaje inicial (%):"
                            label-align-sm="right"
                        >
                            <b-form-input
                                plaintext
                                :value="
                                    pedido.hasOwnProperty('forma_pago')
                                        ? pedido.forma_pago.tipo == 'cred'
                                            ? pedido.forma_pago.porc_inicial
                                            : '-'
                                        : ''
                                "
                            ></b-form-input>
                        </b-form-group>

                        <!-- Num de cuotas -->
                        <b-form-group
                            label-cols-sm="5"
                            label="Num de cuotas:"
                            label-align-sm="right"
                        >
                            <b-form-input
                                plaintext
                                :value="
                                    pedido.hasOwnProperty('forma_pago')
                                        ? pedido.forma_pago.tipo == 'cred'
                                            ? pedido.forma_pago.nro_cuotas
                                            : '-'
                                        : ''
                                "
                            ></b-form-input>
                        </b-form-group>

                        <!--Interés mensual (%) -->
                        <b-form-group
                            label-cols-sm="5"
                            label="Interés mensual (%):"
                            label-align-sm="right"
                        >
                            <b-form-input
                                plaintext
                                :value="
                                    pedido.hasOwnProperty('forma_pago')
                                        ? pedido.forma_pago.tipo == 'cred'
                                            ? pedido.forma_pago.int_mensual
                                            : '-'
                                        : ''
                                "
                            ></b-form-input>
                        </b-form-group>
                    </b-form-group>

                    <!-- Ingredientes contratados-->
                    <b-form-group
                        label="Ingredientes contratados"
                        label-cols="4"
                        label-class="font-weight-bold"
                    >
                    </b-form-group>
                    <b-table small striped hover :items="pedido.detalle" :fields="fields_con">
                    </b-table>
                </b-col>
            </b-row>
        </b-container>

        <!-- FOOTER MODAL -->
        <template v-slot:modal-footer="{ cancel, ok }">
            <div v-if="only_view">
                <b-button @click="cancel()" variant="outline-secondary">
                    CERRAR
                </b-button>
            </div>
            <div v-else>
                <b-button @click="cancel()" variant="outline-danger">
                    CERRAR
                </b-button>
                <span class="mr-2"></span>
                <b-button @click="okAprobar(ok)" variant="primary">
                    APROBAR
                </b-button>
            </div>
        </template>
    </b-modal>
</template>

<script>
export default {
    props: ["pedido", "only_view"],
    data() {
        return {
            fields_con: [
                {
                    key: "cas",
                    sortable: false,
                },
                {
                    key: "nombre",
                    label: "Nombre",
                    sortable: false,
                },
                {
                    key: "volumen",
                    label: "Volumen (ml)",
                    sortable: false,
                },
                {
                    key: "precio",
                    label: "Precio (USD)",
                    sortable: false,
                },
                {
                    key: "cantidad",
                    label: "Cantidad",
                    sortable: false,
                },
            ],
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
        okAprobar(funOk) {
            this.$emit("aprobar");
            funOk();
        },
    },
};
</script>

<style></style>
