<template>
    <!-- MODAL DETALLE -->
    <b-modal
        id="detalle-modal"
        size="lg"
        centered
        :title="mode == 'v' ? 'Detalle' : mode == 'e' ? 'Editar' : 'Agregar'"
    >
        <!-- CONTENIDO -->
        <div>
            <b-form-group label-cols-sm="3" label="CAS:" label-align-sm="right">
                <b-form-input
                    v-model="aux_mp.cas"
                    type="number"
                    :state="flag_nonEmpty_cas"
                    :plaintext="isReadOnly || !(mode == 'a')"
                ></b-form-input>
            </b-form-group>

            <b-form-group label-cols-sm="3" label="Nombre:" label-align-sm="right">
                <b-form-input
                    v-model="aux_mp.nombre"
                    :plaintext="isReadOnly"
                    :state="flag_nonEmpty_name"
                    id="input-nombre"
                ></b-form-input>
            </b-form-group>
        </div>

        <template v-slot:modal-footer="{ ok, cancel }">
            <b-button variant="outline-secondary" @click="cancel()">Cerrar</b-button>
            <b-button v-show="!isReadOnly" variant="success" @click="guardarCambios(ok)"
                >Guardar</b-button
            >
        </template>
    </b-modal>
</template>

<script>
export default {
    props: ["datos", "mode"],
    data() {
        return {
            flag_nonEmpty_cas: false,
            flag_nonEmpty_name: false,
            aux_mp: {
                nombre: "",
                cas: null,
            },
        };
    },
    methods: {
        checkNonEmpty() {
            if (this.aux_mp.nombre.length <= 0) {
                this.flag_nonEmpty_name = false;
                return false;
            }
            if (this.aux_mp.cas <= 0) {
                this.flag_nonEmpty_cas = false;
                return false;
            }

            this.flag_nonEmpty_name = true;
            this.flag_nonEmpty_cas = true;
            return true;
        },
        guardarCambios(funOk) {
            if (this.checkNonEmpty()) {
                if (this.mode == "e") {
                } else if (this.mode == "a") {
                    this.$emit("crear", this.aux_mp);
                }
                funOk();
            }
        },
        GetDatos() {
            let x = {};
            Object.assign(x, this.datos);
            this.aux_mp = x;
        },
    },
    computed: {
        isReadOnly() {
            if (this.mode == "e" || this.mode == "a") {
                return false;
            } else {
                return true;
            }
        },
    },
    mounted() {
        this.$root.$on("bv::modal::show", (bvEvent, modalId) => {
            if (modalId == "detalle-modal") {
                this.flag_nonEmpty_name = null;
                this.flag_nonEmpty_cas = null;

                console.log("He sido montado!");
                switch (this.mode) {
                    case "v":
                    case "e":
                        this.GetDatos();
                        break;

                    case "a":
                        this.aux_mp = {
                            nombre: "",
                            cas: null,
                        };
                        break;

                    default:
                        break;
                }
            }
        });
    },
};
</script>

<style></style>
