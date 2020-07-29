<template>
    <card-main>
        <template #title>Nuevo Pedido</template>
        <template #content>
            <!-- MODAL FORMAS PEDIDO-->
            <modal-formas-pedido
                :proveedor="datosProv"
                :mode="mode_forma"
                @fe="selectedFE"
                @fp="selectedFP"
            ></modal-formas-pedido>

            <!-- INFO PROVEEDOR -->
            <b-form-group label="DATOS" label-cols="2" label-class="font-weight-bold">
                <!-- Nombre Empresa -->
                <b-form-group
                    label-cols-sm="4"
                    label="Nombre de empresa:"
                    label-align-sm="left"
                    class="p-0 m-0"
                >
                    <b-form-input plaintext v-model="datosProv.nombre"></b-form-input>
                </b-form-group>

                <!-- Correo -->
                <b-form-group
                    label-cols-sm="4"
                    label="Correo electónico:"
                    label-align-sm="left"
                    class="p-0 m-0"
                >
                    <b-form-input plaintext v-model="datosProv.email"></b-form-input>
                </b-form-group>

                <!-- telefono -->
                <b-form-group
                    label-cols-sm="4"
                    label="Teléfono:"
                    label-align-sm="left"
                    class="p-0 m-0"
                >
                    <b-form-input plaintext v-model="datosProv.telefono"></b-form-input>
                </b-form-group>
            </b-form-group>

            <!--PEDIDO-->
            <h3>PEDIDO</h3>
            <br />
            <b-table-simple>
                <b-thead>
                    <b-tr variant="secondary">
                        <b-th>MATERIA PRIMA</b-th>
                        <b-th>CANTIDAD</b-th>
                        <b-th>PREC. UNITARIO</b-th>
                        <b-th>PREC. TOTAL</b-th>
                    </b-tr>
                    <b-tr v-show="flag_repited">
                        <b-th class="text-danger">
                            *Materias primas duplicadas
                        </b-th>
                    </b-tr>
                    <b-tr v-show="flag_null">
                        <b-th class="text-danger">
                            *Debe llenar todos los renglones
                        </b-th>
                    </b-tr>
                    <b-tr v-show="flag_zero_neg">
                        <b-th class="text-danger">
                            *Debe ingresar cantidades superiores a 0
                        </b-th>
                    </b-tr>
                    <b-tr v-show="mat_prim_selected.length < 1">
                        <b-th class="text-danger">
                            *Debe llenar al menos un renglón
                        </b-th>
                    </b-tr>
                </b-thead>

                <b-tbody>
                    <b-tr v-for="(fd, i) in mat_prim_selected" :key="i">
                        <b-th>
                            <b-input-group>
                                <b-input-group-append>
                                    <b-button variant="outline-danger" @click="eliminarItem(i)"
                                        >X</b-button
                                    >
                                </b-input-group-append>
                                <b-form-select
                                    v-model="mat_prim_selected[i]"
                                    :options="mat_prima_disp"
                                >
                                    <b-form-select-option :value="null" disabled
                                        >Selecciona una opción</b-form-select-option
                                    >
                                </b-form-select>
                            </b-input-group>
                        </b-th>
                        <b-th>
                            <b-form-input
                                class="cant-select"
                                type="number"
                                v-model="cant_mat_prim[i]"
                                min="1"
                            ></b-form-input>
                        </b-th>
                        <b-th
                            ><span>{{ mat_prim_selected[i].prec_u }}</span></b-th
                        >
                        <b-th
                            ><span>{{
                                Number(mat_prim_selected[i].prec_u * cant_mat_prim[i]).toFixed(2)
                            }}</span></b-th
                        >
                    </b-tr>
                    <b-tr>
                        <b-th colspan="4">
                            <b-button block variant="outline-primary" @click="agregarItem"
                                >AGREGAR</b-button
                            >
                            <hr />
                        </b-th>
                    </b-tr>
                </b-tbody>
            </b-table-simple>

            <p class="text-danger" v-show="flag_fe">*Seleccionar forma de envío</p>
            <b-button
                block
                :variant="is_fe_selected ? 'outline-primary' : 'primary'"
                @click="openModalForma('fe')"
                >{{
                    fe_selected_ind != null
                        ? `${
                              datosProv.formas_envios[fe_selected_ind].pais
                          } (${datosProv.formas_envios[fe_selected_ind].tipo.toUpperCase()})`
                        : "SELECCIONAR FORMA DE ENVÍO"
                }}</b-button
            >
            <hr />
            <p class="text-danger" v-show="flag_fp">*Seleccionar forma de pago</p>
            <b-button
                block
                :variant="is_fp_selected ? 'outline-primary' : 'primary'"
                @click="openModalForma('fp')"
                >{{
                    fp_selected_ind != null
                        ? datosProv.formas_pagos[fp_selected_ind].tipo == "cred"
                            ? `Crédito (${datosProv.formas_pagos[fp_selected_ind].porc_inicial}%)`
                            : "Contado"
                        : "SELECCIONAR FORMA DE PAGO"
                }}
            </b-button>
            <hr />
            <!-- DETALLE MONTOS -->
            <div>
                <div class="rg-align">
                    <b>SUBTOTAL: </b>
                    <span>{{ subtotalizar }}</span> USD
                </div>
                <div class="rg-align">
                    <b>RECARGOS DE ENVÍO*: </b>
                    <span>{{ rec_fe }}</span> USD
                </div>
                <div class="rg-align">
                    <b>RECARGOS DE PAGO*: </b>
                    <span>{{ rec_fp }}</span> USD
                </div>
                <div class="rg-align mt-2">
                    <b>TOTAL: </b>
                    <span>{{ totalizar }}</span> USD
                </div>
            </div>
            <hr />
            <b-button variant="primary" size="lg" block @click="procesarPedido"
                >PROCESAR PEDIDO</b-button
            >
        </template>
    </card-main>
</template>

<script>
import CardMain from "../components/CardMain.vue";
import ModalFormasPedido from "../components/ModalFormasPedido.vue";

export default {
    components: {
        CardMain,
        ModalFormasPedido,
    },
    props: ["datosProv"],
    data() {
        return {
            mat_prim_selected: [{ cas: null, prec_u: null }],
            cant_mat_prim: [1],
            is_fe_selected: false,
            is_fp_selected: false,
            flag_repited: false,
            flag_null: false,
            flag_zero_neg: false,
            flag_fe: false,
            flag_fp: false,
            mat_prima_disp: [],
            mode_forma: null,
            fe_selected_ind: null,
            fp_selected_ind: null,
            subtotal_monto: 0,
        };
    },
    methods: {
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
        agregarItem() {
            this.mat_prim_selected.push({ cas: null, prec_u: null });
            this.cant_mat_prim.push(1);
        },
        eliminarItem(index) {
            this.mat_prim_selected.splice(index, 1);
        },
        openModalForma(fm) {
            this.mode_forma = fm;
            this.$bvModal.show("pe-form-modal");
        },
        subTotal() {
            let total = 0;
            for (let i = 0; i < this.mat_prim_selected.length; i++) {
                if (this.mat_prim_selected[i].cas) {
                    total += this.mat_prim_selected[i].prec_u * this.cant_mat_prim[i];
                }
            }
            //console.log("total ", total);
            this.subtotal_monto = total.toFixed(2);
            return total.toFixed(2);
        },
        selectedFE(ind) {
            console.log("FE ", ind);
            this.fe_selected_ind = ind;
            this.flag_fe = false;
            this.is_fe_selected = true;
        },
        selectedFP(ind) {
            console.log("FP ", ind);
            this.fp_selected_ind = ind;
            this.flag_fp = false;
            this.is_fp_selected = true;
        },
        calc_fe() {
            if (this.fe_selected_ind != null) {
                return (
                    this.subtotal_monto *
                    (this.datosProv.formas_envios[this.fe_selected_ind].cargo / 100)
                ).toFixed(2);
            } else {
                return (0).toFixed(2);
            }
        },
        calc_fp() {
            if (this.fp_selected_ind != null) {
                //Si es credito
                let final = 0;
                if (this.datosProv.formas_pagos[this.fp_selected_ind].tipo == "cred") {
                    //let inicial = this.subTotal * (this.datosProv.formas_pagos[fp_selected_ind].porc_inicial / 100);
                    // let restante = this.subTotal * (1 - (this.datosProv.formas_pagos[fp_selected_ind].porc_inicial / 100));
                    let intereses =
                        (this.subtotal_monto * 1 + this.calc_fe() * 1) *
                        (1 - this.datosProv.formas_pagos[this.fp_selected_ind].porc_inicial / 100) *
                        (this.datosProv.formas_pagos[this.fp_selected_ind].int_mensual / 100);

                    final = intereses;
                }
                return final.toFixed(2);
            } else {
                return (0).toFixed(2);
            }
        },
        totalizacion() {
            //console.log("total", this.subtotal_monto * 1, this.calc_fe() * 1, this.calc_fp() * 1);
            return (this.subtotal_monto * 1 + this.calc_fe() * 1 + this.calc_fp() * 1).toFixed(2);
        },
        checkRepNull() {
            this.flag_repited = false;
            this.flag_null = false;

            for (let ind = 0; ind < this.mat_prim_selected.length; ind++) {
                for (let i = 0; i < ind; i++) {
                    if (
                        this.mat_prim_selected[i].cas == this.mat_prim_selected[ind].cas &&
                        i != ind &&
                        this.mat_prim_selected[i].id_pres == this.mat_prim_selected[ind].id_pres
                    ) {
                        this.flag_repited = true;
                        break;
                    }
                }

                if (this.mat_prim_selected[ind].cas == null) {
                    this.flag_null = true;
                    break;
                }
            }
        },
        checkCantidad() {
            this.flag_zero_neg = false;
            for (let i = 0; i < this.cant_mat_prim.length; i++) {
                if (Number(this.cant_mat_prim[i]) <= 0) {
                    this.flag_zero_neg = true;
                    break;
                }
            }
        },
        checkFormas() {
            this.flag_fe = false;
            this.flag_fp = false;

            if (!this.is_fe_selected) {
                this.flag_fe = true;
            }
            if (!this.is_fp_selected) {
                this.flag_fp = true;
            }
        },
        procesarPedido() {
            this.checkRepNull();
            this.checkCantidad();
            this.checkFormas();
            /*console.log(
                "flag_repited",
                this.flag_repited,
                "flag_null",
                this.flag_null,
                "flag_zero_neg",
                this.flag_zero_neg,
                "flag_fe",
                this.flag_fe,
                "flag_fp",
                this.flag_fp
            );*/
            if (
                !(
                    this.flag_repited ||
                    this.flag_null ||
                    this.flag_zero_neg ||
                    this.flag_fe ||
                    this.flag_fp
                ) &&
                this.mat_prim_selected.length > 0
            ) {
                //ALL OK
                //console.warn("all ok");
                let total = this.totalizacion();
                let aux_cas = [];
                let aux_pres = [];
                let aux_cant = [];

                this.mat_prim_selected.forEach((mp, i) => {
                    aux_cas.push(mp.cas);
                    aux_pres.push(mp.id_pres);
                    aux_cant.push(Number(this.cant_mat_prim[i]));
                });

                let obj_pedido = {
                    id_contrato: this.datosProv.cont_id,
                    id_fe_cond: this.datosProv.formas_envios[this.fe_selected_ind].idfe,
                    id_fp_cond: this.datosProv.formas_pagos[this.fp_selected_ind].idfp,
                    total_usd: Number(total),
                    subtotal_usd: Number(this.subtotal_monto),
                    cas: aux_cas,
                    id_pres: aux_pres,
                    cantidad: aux_cant,
                };

                console.warn("PEDIDO READY: ", obj_pedido);

                fetch(
                    `http://localhost:3000/prod/${this.$route.params.id}/pedido/nuevo/${this.$route.params.id_prov}`,
                    {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify({ ped: obj_pedido }),
                    }
                )
                    .then((response) => {
                        return response.json();
                    })
                    .then((resp) => {
                        console.log("Respuesta de servidor: ", resp);

                        this.$router.push({
                            name: "HomeProd",
                        });
                    });
            }
        },
    },
    computed: {
        subtotalizar() {
            return this.formatoNumero(this.subTotal());
        },
        rec_fe() {
            return this.formatoNumero(this.calc_fe());
        },
        rec_fp() {
            return this.formatoNumero(this.calc_fp());
        },
        totalizar() {
            return this.formatoNumero(this.totalizacion());
        },
    },
    created() {
        console.log("Prov recibido: ", this.datosProv);

        this.mat_prima_disp = this.datosProv.ingredientes.map((ing) => {
            return {
                value: { cas: ing.cas, prec_u: ing.precio, id_pres: ing.id_pres },
                text: `${ing.nombre} (${ing.volumen}ml)`,
            };
        });
    },
};
</script>

<style>
.cant-select {
    width: 70%;
}
.rg-align {
    text-align: right;
}
</style>
