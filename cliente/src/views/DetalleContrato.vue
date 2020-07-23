<template>
    <card-main>
        <template #title>Nuevo Contrato</template>
        <template #content>
            <!-- MODAL PROPUESTA -->
            <modal-propuesta-contrato
                @condReady="contratoReady"
                :data="datosProv"
            ></modal-propuesta-contrato>

            <!-- CONTENIDO VISTA -->
            <h3>Contrato <span v-show="$route.query.e != 'n'">exclusivo</span></h3>
            <br />
            <b-table-simple>
                <b-thead>
                    <b-tr variant="secondary">
                        <b-th>MATERIA PRIMA</b-th>
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
                                <b-form-select
                                    v-model="mat_prim_selected[i]"
                                    :options="mat_prima_disp"
                                >
                                    <b-form-select-option :value="null" disabled
                                        >Selecciona una opción</b-form-select-option
                                    >
                                </b-form-select>
                                <b-input-group-append>
                                    <b-button variant="outline-danger" @click="eliminarItem(i)"
                                        >X</b-button
                                    >
                                </b-input-group-append>
                            </b-input-group>
                        </b-th>
                    </b-tr>
                    <b-tr>
                        <b-th>
                            <b-button block variant="outline-primary" @click="agregarItem"
                                >AGREGAR</b-button
                            >
                            <hr />
                        </b-th>
                    </b-tr>
                </b-tbody>
            </b-table-simple>

            <br />

            <b-button block variant="primary" @click="nextCondiciones()"
                >SIGUIENTE
                <b-icon icon="chevron-right"></b-icon>
            </b-button>
        </template>
    </card-main>
</template>

<script>
import CardMain from "../components/CardMain.vue";
import ModalPropuestaContrato from "../components/ModalPropuestaContrato.vue";

export default {
    components: {
        CardMain,
        ModalPropuestaContrato,
    },
    props: ["datosProv"],
    data() {
        return {
            mat_prim_selected: [null],
            flag_repited: false,
            flag_null: false,
            mat_prima_disp: [],
        };
    },
    methods: {
        agregarItem() {
            this.mat_prim_selected.push(null);
        },
        eliminarItem(index) {
            this.mat_prim_selected.splice(index, 1);
        },
        checkRepNull() {
            this.flag_repited = false;
            this.flag_null = false;

            for (let ind = 0; ind < this.mat_prim_selected.length; ind++) {
                for (let i = 0; i < ind; i++) {
                    if (this.mat_prim_selected[i] == this.mat_prim_selected[ind] && i != ind) {
                        this.flag_repited = true;
                        break;
                    }
                }

                if (this.mat_prim_selected[ind] == null) {
                    this.flag_null = true;
                    break;
                }
            }
        },
        nextCondiciones() {
            this.checkRepNull();
            if (!(this.flag_repited || this.flag_null) && this.mat_prim_selected.length > 0) {
                //ABRIR MODAL
                console.log("Se puede continuar");
                this.$bvModal.show("prop-con-modal");
            }
        },
        contratoReady(obj_data) {
            console.log("READY COND: ", obj_data, this.$route);

            let arr_pais = [];
            obj_data.form_env.forEach((fe) => {
                let i = this.datosProv.formas_envios.indexOf(fe.id_form_env);
                if (i > -1) {
                    arr_pais.push(this.datosProv.formas_envios[i].id_pais);
                }
            });

            let contrato_final = {
                clausula: obj_data.clausula ? obj_data.clausula : null,
                exclusividad: this.$route.query.e == "n" ? false : true,
                cas: this.mat_prim_selected,
                id_fe: obj_data.form_env,
                id_fp: obj_data.form_pago,
                id_pais: arr_pais,
            };

            console.warn("FINAL ", contrato_final);

            fetch(
                `http://localhost:3000/prod/${this.$route.params.id}/contratos/nuevo/${this.$route.params.id_prov}`,
                {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify(contrato_final),
                }
            );

            this.$router.push({
                name: "HomeProd",
            });
        },
    },
    computed: {},
    created() {
        console.log("PROP: ", this.datosProv);

        this.mat_prima_disp = this.datosProv.ingredientes.map((mp) => {
            return {
                value: mp.cas,
                text: `${mp.nombre} (${mp.tipo == "q" ? "Sintético" : "Natural"})`,
            };
        });
    },
};
</script>

<style></style>
