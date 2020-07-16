<template>
    <b-modal id="prop-con-modal" centered size="xl" title="Propuesta de contrato">
        <!-- CONTENIDO MODAL -->
        <b-container fluid>
            <b-row>
                <b-col>
                    <h4>CLÁUSULAS</h4>
                    <b-form-textarea
                        v-model="clausula_text"
                        placeholder="(Opcional)"
                        rows="2"
                        max-rows="6"
                    ></b-form-textarea>
                    <br />

                    <!-- FORMAS DE ENVIOS -->
                    <b-table-simple small>
                        <b-thead>
                            <b-tr variant="secondary">
                                <b-th>FORMA DE ENVÍO</b-th>
                            </b-tr>
                            <b-tr v-show="flag_repited_fe">
                                <b-th class="text-danger">
                                    *Formas de envio duplicadas
                                </b-th>
                            </b-tr>
                            <b-tr v-show="flag_null_fe">
                                <b-th class="text-danger">
                                    *Debe llenar todos los renglones
                                </b-th>
                            </b-tr>
                            <b-tr v-show="fe_selected.length < 1">
                                <b-th class="text-danger">
                                    *Debe llenar al menos un renglón
                                </b-th>
                            </b-tr>
                        </b-thead>

                        <b-tbody>
                            <b-tr v-for="(fd, i) in fe_selected" :key="i">
                                <b-th>
                                    <b-input-group>
                                        <b-form-select v-model="fe_selected[i]" :options="fe_disp">
                                            <b-form-select-option :value="null" disabled
                                                >Selecciona una opción</b-form-select-option
                                            >
                                        </b-form-select>
                                        <b-input-group-append>
                                            <b-button
                                                variant="outline-danger"
                                                @click="eliminarItem_fe(i)"
                                                >X</b-button
                                            >
                                        </b-input-group-append>
                                    </b-input-group>
                                </b-th>
                            </b-tr>
                            <b-tr>
                                <b-th>
                                    <b-button
                                        block
                                        variant="outline-primary"
                                        @click="agregarItem_fe()"
                                        >AGREGAR</b-button
                                    >
                                    <hr />
                                </b-th>
                            </b-tr>
                        </b-tbody>
                    </b-table-simple>

                    <!-- FORMAS DE PAGOS -->
                    <b-table-simple small>
                        <b-thead>
                            <b-tr variant="secondary">
                                <b-th>FORMA DE PAGO</b-th>
                            </b-tr>
                            <b-tr v-show="flag_repited_fp">
                                <b-th class="text-danger">
                                    *Formas de pago duplicadas
                                </b-th>
                            </b-tr>
                            <b-tr v-show="flag_null_fp">
                                <b-th class="text-danger">
                                    *Debe llenar todos los renglones
                                </b-th>
                            </b-tr>
                            <b-tr v-show="fp_selected.length < 1">
                                <b-th class="text-danger">
                                    *Debe llenar al menos un renglón
                                </b-th>
                            </b-tr>
                        </b-thead>

                        <b-tbody>
                            <b-tr v-for="(fd, i) in fp_selected" :key="i">
                                <b-th>
                                    <b-input-group>
                                        <b-form-select v-model="fp_selected[i]" :options="fp_disp">
                                            <b-form-select-option :value="null" disabled
                                                >Selecciona una opción</b-form-select-option
                                            >
                                        </b-form-select>
                                        <b-input-group-append>
                                            <b-button
                                                variant="outline-danger"
                                                @click="eliminarItem_fp(i)"
                                                >X</b-button
                                            >
                                        </b-input-group-append>
                                    </b-input-group>
                                </b-th>
                            </b-tr>
                            <b-tr>
                                <b-th>
                                    <b-button
                                        block
                                        variant="outline-primary"
                                        @click="agregarItem_fp()"
                                        >AGREGAR</b-button
                                    >
                                    <hr />
                                </b-th>
                            </b-tr>
                        </b-tbody>
                    </b-table-simple>
                </b-col>
            </b-row>
        </b-container>

        <!-- FOOTER MODAL -->
        <template v-slot:modal-footer="{ ok, cancel }">
            <b-button @click="cancel()" variant="outline-danger">
                Cerrar
            </b-button>
            <b-button @click="enviarContrato(ok)" variant="primary">
                Contratar
            </b-button>
        </template>
    </b-modal>
</template>

<script>
export default {
    data() {
        return {
            clausula_text: "",
            /*FE */
            flag_repited_fe: false,
            flag_null_fe: false,
            fe: [
                { id: 1, tipo: "m", cargo: 10, pais: "Venezuela" },
                { id: 2, tipo: "a", cargo: 12, pais: "Venezuela" },
                { id: 3, tipo: "m", cargo: 5, pais: "Colombia" },
            ],
            fe_disp: [],
            fe_selected: [],
            /*FP*/
            flag_repited_fp: false,
            flag_null_fp: false,
            fp: [
                { id: 1, tipo: "cont" },
                { id: 2, tipo: "cred", porc_inicial: 30, nro_cuotas: 10, interes_mensual: 2.5 },
                { id: 3, tipo: "cred", porc_inicial: 15, nro_cuotas: 5, interes_mensual: 15 },
                { id: 3, tipo: "cred", porc_inicial: 12, nro_cuotas: 7, interes_mensual: 5 },
            ],
            fp_disp: [],
            fp_selected: [],
        };
    },
    methods: {
        agregarItem_fe() {
            this.fe_selected.push(null);
        },
        eliminarItem_fe(index) {
            this.fe_selected.splice(index, 1);
        },
        checkRepNull_fe() {
            this.flag_repited_fe = false;
            this.flag_null_fe = false;

            for (let ind = 0; ind < this.fe_selected.length; ind++) {
                for (let i = 0; i < ind; i++) {
                    if (this.fe_selected[i] == this.fe_selected[ind] && i != ind) {
                        this.flag_repited_fe = true;
                        break;
                    }
                }

                if (this.fe_selected[ind] == null) {
                    this.flag_null_fe = true;
                    break;
                }
            }
        },
        agregarItem_fp() {
            this.fp_selected.push(null);
        },
        eliminarItem_fp(index) {
            this.fp_selected.splice(index, 1);
        },
        checkRepNull_fp() {
            this.flag_repited_fp = false;
            this.flag_null_fp = false;

            for (let ind = 0; ind < this.fp_selected.length; ind++) {
                for (let i = 0; i < ind; i++) {
                    if (this.fp_selected[i] == this.fp_selected[ind] && i != ind) {
                        this.flag_repited_fp = true;
                        break;
                    }
                }

                if (this.fp_selected[ind] == null) {
                    this.flag_null_fp = true;
                    break;
                }
            }
        },
        checkAllcond() {
            this.checkRepNull_fe();
            this.checkRepNull_fp();
            if (
                !(
                    this.flag_repited_fe ||
                    this.flag_null_fe ||
                    this.flag_repited_fp ||
                    this.flag_null_fp ||
                    this.fe_selected.length < 1 ||
                    this.fp_selected.length < 1
                )
            ) {
                return true;
            }
            return false;
        },
        enviarContrato(funOK) {
            if (this.checkAllcond()) {
                //LISTO
                let obj_data = {
                    clausula: this.clausula_text,
                    form_env: this.fe_selected,
                    form_pago: this.fp_selected,
                };
                this.$emit("condReady", obj_data);
                funOK();
            }
        },
    },

    created() {
        console.warn("Creando componente...");
        //FORMA DE ENVIO
        this.fe_disp = this.fe.map((fe) => {
            return {
                value: fe.id,
                text: `${fe.pais} (${
                    fe.tipo == "m" ? "Marítimo" : fe.tipo == "a" ? "Aéreo" : "Terrestre"
                }) - Recargo: ${fe.cargo}%`,
            };
        });

        //FORMA DE PAGO
        this.fp_disp = this.fp.map((fp) => {
            return {
                value: fp.id,
                text: `${fp.tipo == "cont" ? "Contado" : "Crédito"} ${
                    fp.tipo == "cred"
                        ? `(${fp.porc_inicial}% Inicial - ${fp.nro_cuotas} cuotas - ${fp.interes_mensual}% interes)`
                        : ""
                }`,
            };
        });
    },
};
</script>

<style></style>
