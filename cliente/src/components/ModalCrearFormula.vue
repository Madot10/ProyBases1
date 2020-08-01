<template>
    <b-modal id="c-form-modal" size="lg" centered title="Fórmula">
        <!-- CONTENIDO MODAL -->

        <!-- PREG ESCALA -->

        <!-- ESCALA Y EXITO -->
        <b-form-group label="RANGO DE CLASIFICACIÓN" label-cols="4" label-class="font-weight-bold">
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
    props: ["mode", "variables"],
    data() {
        return {
            punt_exito: 0,
            criterios_disp: [],
            criterios_selected: [{ id: null, peso: null }],
            flag_repited: false,
            flag_null: false,
            flag_zero_neg: false,
            flag_exito: false,
            flag_100: false,
        };
    },
    methods: {
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
        checkExito() {
            this.flag_exito = false;
            if (this.punt_exito <= 0 || this.punt_exito > 100) {
                this.flag_exito = true;
            }
        },
        crearFormula(fnOk) {
            //Verificar
            this.checkRepNull();
            this.checkCantidad();
            this.checkExito();

            if (
                !(
                    this.flag_repited ||
                    this.flag_null ||
                    this.flag_zero_neg ||
                    this.flag_exito ||
                    this.flag_100
                )
            ) {
                //console.warn("all ok");
                let idUser = this.$route.params.id;
                let urlBaseApi = `http://localhost:3000/prod/${idUser}`;

                let obj_formula = {
                    formula: {
                        id_var_crit: [],
                        pesos: [],
                    },
                    tipo_formula: this.mode == "ini" ? "i" : "r",
                };

                //Criterios
                this.criterios_selected.forEach((c) => {
                    obj_formula.formula.id_var_crit.push(c.id);
                    obj_formula.formula.pesos.push(Number(c.peso));
                });

                //Exito
                obj_formula.formula.id_var_crit.push(5);
                obj_formula.formula.pesos.push(Number(this.punt_exito));

                console.log("Form to send", obj_formula);
                let sta = true;

                //Criterios
                fetch(urlBaseApi + "/evaluacion_criterios", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify(obj_formula),
                })
                    .then((response) => {
                        return response.json();
                    })
                    .then((res) => {
                        console.log("Servidor responde: ", res);
                        if (res == false) {
                            sta = false;
                        }
                    })
                    .catch((e) => {
                        sta = false;
                    })
                    .finally(() => {
                        this.$emit("state", sta);
                    });

                fnOk();
            }
        },
    },
    computed: {
        totalPer() {
            return this.totalizar();
        },
    },
    watch: {
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
    mounted() {
        this.$root.$on("bv::modal::show", (bvEvent, modalId) => {
            if (modalId == "c-form-modal") {
                this.criterios_selected = [{ id: null, peso: null }];
            }
        });
    },
};
</script>

<style>
.rg-align {
    text-align: right;
}
</style>
