<template>
    <b-modal id="pe-modal" centered size="xl" title="Pedido">
        <!-- CONTENIDO MODAL -->
        <b-container fluid>
            <b-row>
                <b-col>
                    <!-- NRO FACTURA -->
                    <b-form-group
                        label="Nro factura"
                        v-show="!only_view"
                        label-cols="3"
                        label-class="font-weight-bold"
                    >
                        <b-form-input
                            v-model="nro_fac"
                            type="number"
                            min="0"
                            max="9999999"
                        ></b-form-input>
                        <span class="text-danger" v-show="flag_null"
                            >*Debe ingresar el nro. de factura</span
                        ><br />
                        <span class="text-danger" v-show="flag_limit"
                            >*Debe ser mayor a 0 y menor que 9.999.999</span
                        >
                    </b-form-group>

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
                    <br />
                    <!-- MONTOS -->
                    <b-form-group label="Detalle" label-cols="3" label-class="font-weight-bold">
                        <!-- Subtotal -->
                        <b-form-group label-cols-sm="5" label="Subtotal:" label-align-sm="right">
                            <b-form-input
                                plaintext
                                :value="formatoNumero(pedido.subtotal_usd) + ' USD'"
                            ></b-form-input>
                        </b-form-group>

                        <!-- Total -->
                        <b-form-group label-cols-sm="5" label="Total:" label-align-sm="right">
                            <b-form-input
                                plaintext
                                :value="formatoNumero(pedido.total_usd) + ' USD'"
                            ></b-form-input>
                        </b-form-group>
                    </b-form-group>
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
            nro_fac: null,
            flag_limit: false,
            flag_null: false,
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
            this.flag_limit = false;
            this.flag_null = false;

            if (this.nro_fac != null) {
                if (this.nro_fac > 0 && this.nro_fac < 9999999) {
                    //All okk
                    this.$emit("aprobar", this.nro_fac);
                    funOk();
                } else {
                    this.flag_limit = true;
                }
            } else {
                this.flag_null = true;
            }
        },
        formatoNumero(num) {
            let separador = ".";
            let sepDecimal = ",";

            num += "";
            let splitStr = num.split(".");
            let splitLeft = splitStr[0];
            let splitRight = splitStr.length > 1 ? sepDecimal + splitStr[1] : "";
            let regx = /(\d+)(\d{3})/;
            while (regx.test(splitLeft)) {
                splitLeft = splitLeft.replace(regx, "$1" + separador + "$2");
            }
            return splitLeft + splitRight;
        },
    },
    mounted() {
        this.$root.$on("bv::modal::show", (bvEvent, modalId) => {
            if (modalId == "pe-modal") {
                this.nro_fac = 0;

                this.flag_limit = false;
                this.flag_null = false;
            }
        });
    },
};
</script>

<style></style>
