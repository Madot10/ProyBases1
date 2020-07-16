<template>
    <card-main>
        <template #title>Nuevo Contrato</template>
        <template #content>
            <!-- MODAL PROPUESTA -->
            <modal-propuesta-contrato @condReady="contratoReady"></modal-propuesta-contrato>

            <!-- CONTENIDO VISTA -->
            <h3>Contrato</h3>
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
    data() {
        return {
            mat_prim_selected: [null],
            flag_repited: false,
            flag_null: false,
            mat_prima_disp: [],
            mat_prima: [
                { cas: 244, nombre: "AAAAAsdad sad " },
                { cas: 45454564, nombre: "BBB sdsad dsds " },
                { cas: 254545444, nombre: "AVVVAAAA sd sd sd a" },
                { cas: 99999, nombre: "CCCC sd s" },
                { cas: 2445478794, nombre: "SADS DFSADsad " },
            ],
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
            console.log("READY COND: ", obj_data);
        },
    },
    computed: {},
    created() {
        //console.warn(this.$route.params); {id: "5", id_prov: "2"}
        //console.warn(this.$route.query); {e: "n"}
        this.mat_prima_disp = this.mat_prima.map((mp) => {
            return {
                value: mp.cas,
                text: mp.nombre,
            };
        });
    },
};
</script>

<style></style>
