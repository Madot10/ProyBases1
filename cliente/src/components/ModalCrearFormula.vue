<template>
    <b-modal id="c-form-modal" size="lg" centered title="Fórmula">
        <!-- CONTENIDO MODAL -->

        <!-- PREG ESCALA -->
        <div>
            <b-alert :show="esc_aviso && aviso_aux" class="text-center"
                >¿Desea seguir utilizando la escala activa?

                <b-row class="mt-2">
                    <b-col>
                        <b-button block variant="secondary" @click="wantCreateEscala(false)"
                            >Mantener</b-button
                        >
                    </b-col>
                    <b-col>
                        <b-button block variant="success" @click="wantCreateEscala(true)"
                            >Nueva</b-button
                        >
                    </b-col>
                </b-row>
            </b-alert>
        </div>
        <p class="text-danger" v-show="flag_esc_dec">
            *Debe decidir que hacer con la escala
        </p>

        <!-- ESCALA Y EXITO -->
        <b-form-group label="RANGO DE CLASIFICACIÓN" label-cols="4" label-class="font-weight-bold">
            <p class="text-danger" v-show="flag_esc">
                *Debe ingresar escalas superiores a 0 e inferiores a 999
            </p>
            <!-- Escala mínima-->
            <b-form-group
                label-cols-sm="5"
                label="Escala mínima:"
                label-align-sm="left"
                class="p-0 m-0"
            >
                <b-form-input
                    :plaintext="!new_esc"
                    v-model="esc.valor_min"
                    size="sm"
                    type="number"
                    min="0"
                    max="999"
                ></b-form-input>
            </b-form-group>

            <!-- Escala máxima -->
            <b-form-group
                label-cols-sm="5"
                label="Escala máxima:"
                label-align-sm="left"
                class="p-0 m-0"
            >
                <b-form-input
                    :plaintext="!new_esc"
                    v-model="esc.valor_max"
                    size="sm"
                    type="number"
                    min="0"
                    max="999"
                ></b-form-input>
            </b-form-group>
            <p class="text-danger" v-show="flag_exito">
                *Debe ingresar un puntaje mayor a 0 e inferior a 100
            </p>
            <!-- Puntaje de aprobación -->
            <b-form-group
                label-cols-sm="5"
                label="Puntaje de aprobación (%):"
                label-align-sm="left"
                class="p-0 m-0"
            >
                <b-form-input
                    v-model="punt_exito"
                    size="sm"
                    type="number"
                    min="0"
                    max="100"
                ></b-form-input>
            </b-form-group>
        </b-form-group>

        <hr />

        <!-- VARIABLES -->
        <b-table-simple>
            <b-thead>
                <b-tr>
                    <b-th>CRITERIOS</b-th>
                    <b-th>PESO (%)</b-th>
                </b-tr>
                <b-tr v-show="flag_repited">
                    <b-th class="text-danger">
                        *Criterios duplicados
                    </b-th>
                </b-tr>
                <b-tr v-show="flag_null">
                    <b-th class="text-danger">
                        *Debe llenar todos los renglones
                    </b-th>
                </b-tr>
                <b-tr v-show="criterios_selected.length < 1">
                    <b-th class="text-danger">
                        *Debe llenar al menos un renglón
                    </b-th>
                </b-tr>
                <b-tr v-show="flag_zero_neg">
                    <b-th class="text-danger">
                        *Debe ingresar pesos superiores a 0 e inferiores a 100
                    </b-th>
                </b-tr>
            </b-thead>

            <b-tbody>
                <b-tr v-for="(c, i) in criterios_selected" :key="i">
                    <b-th>
                        <b-input-group>
                            <b-input-group-append>
                                <b-button variant="outline-danger" @click="eliminarItem(i)"
                                    >X</b-button
                                >
                            </b-input-group-append>
                            <b-form-select
                                v-model="criterios_selected[i].id"
                                :options="criterios_disp"
                            >
                                <b-form-select-option :value="null" disabled
                                    >Selecciona una opción</b-form-select-option
                                >
                            </b-form-select>
                        </b-input-group>
                    </b-th>
                    <b-th>
                        <b-form-input
                            class="peso-select"
                            type="number"
                            v-model="criterios_selected[i].peso"
                            min="1"
                            max="100"
                        ></b-form-input>
                    </b-th>
                </b-tr>
                <b-tr>
                    <b-th colspan="2">
                        <b-button block variant="outline-primary" @click="agregarItem"
                            >AGREGAR</b-button
                        >
                        <hr />
                    </b-th>
                </b-tr>
            </b-tbody>
        </b-table-simple>
        <div>
            <!-- TOTAL -->
            <div class="rg-align">
                <b>Total:</b> <span>{{ totalPer }}%</span>
            </div>
        </div>
        <p class="text-danger rg-align" v-show="flag_100">
            *Total debe ser igual al 100%
        </p>

        <!--FOOTER-->
        <template v-slot:modal-footer="{ ok, cancel }">
            <b-button variant="outline-danger" @click="cancel">
                CANCELAR
            </b-button>
            <b-button variant="primary" @click="crearFormula(ok)">
                CREAR
            </b-button>
        </template>
    </b-modal>
</template>

<script>
export default {
    props: ["mode", "variables", "esc_aviso", "escala"],
    data() {
        return {
            new_esc: false,
            aviso_aux: true,
            esc: { valor_min: null, valor_max: null },

            punt_exito: 0,

            criterios_disp: [],
            criterios_selected: [{ id: null, peso: null }],
            flag_repited: false,
            flag_null: false,
            flag_zero_neg: false,
            flag_esc: false,
            flag_exito: false,
            flag_esc_dec: false,
            flag_100: false,
        };
    },
    methods: {
        wantCreateEscala(dec) {
            if (dec) {
                //crear nueva
                this.new_esc = true;
                this.aviso_aux = false;
            } else {
                //mantener
                this.new_esc = false;
                this.aviso_aux = false;
            }
        },
        agregarItem() {
            this.criterios_selected.push({ id: null, peso: null });
        },
        eliminarItem(index) {
            this.criterios_selected.splice(index, 1);
        },
        totalizar() {
            this.flag_100 = false;
            let total = 0;
            this.criterios_selected.forEach((c) => {
                if (c.peso) {
                    total += Number(c.peso);
                }
            });
            if (total != 100) {
                this.flag_100 = true;
            }
            return total;
        },
        checkRepNull() {
            this.flag_repited = false;
            this.flag_null = false;

            for (let ind = 0; ind < this.criterios_selected.length; ind++) {
                for (let i = 0; i < ind; i++) {
                    if (
                        this.criterios_selected[i].id == this.criterios_selected[ind].id &&
                        i != ind
                    ) {
                        this.flag_repited = true;
                        break;
                    }
                }

                if (this.criterios_selected[ind].id == null) {
                    this.flag_null = true;
                    break;
                }
            }
        },
        checkCantidad() {
            this.flag_zero_neg = false;
            for (let i = 0; i < this.criterios_selected.length; i++) {
                if (
                    Number(this.criterios_selected[i].peso) <= 0 ||
                    Number(this.criterios_selected[i].peso) > 100
                ) {
                    this.flag_zero_neg = true;
                    break;
                }
            }
        },
        checkEsc() {
            this.flag_esc = false;
            if (
                this.esc.valor_min < 0 ||
                this.esc.valor_min > 999 ||
                this.esc.valor_max < 0 ||
                this.esc.valor_max > 999
            ) {
                this.flag_esc = true;
            }
        },
        checkExito() {
            this.flag_exito = false;
            if (this.punt_exito <= 0 || this.punt_exito > 100) {
                this.flag_exito = true;
            }
        },
        checkDec() {
            this.flag_esc_dec = false;
            if (this.aviso_aux) {
                this.flag_esc_dec = true;
            }
        },
        crearFormula(fnOk) {
            //Verificar
            this.checkRepNull();
            this.checkCantidad();
            this.checkEsc();
            this.checkExito();
            this.checkDec();

            if (
                !(
                    this.flag_repited ||
                    this.flag_null ||
                    this.flag_zero_neg ||
                    this.flag_esc ||
                    this.flag_exito ||
                    this.flag_esc_dec ||
                    this.flag_100
                )
            ) {
                console.warn("all ok");
            }
        },
    },
    computed: {
        totalPer() {
            return this.totalizar();
        },
    },
    watch: {
        escala(newV) {
            this.esc = newV;
        },
        variables(newV) {
            this.criterios_disp = newV
                .filter((c) => {
                    if (c.nombre_crit == "Éxito") {
                        return false;
                    }
                    return true;
                })
                .map((c) => {
                    return {
                        text: c.nombre_crit,
                        value: c.id,
                    };
                });
        },
    },
};
</script>

<style>
.rg-align {
    text-align: right;
}
</style>
