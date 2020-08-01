<template>
    <b-modal id="escala-form-modal" size="lg" centered title="Fórmula">
        <!-- CONTENIDO MODAL -->

        <!-- ESCALA Y EXITO -->
        <b-form-group label="RANGO DE CLASIFICACIÓN" label-cols="4" label-class="font-weight-bold">
            <p class="text-danger" v-show="flag_esc">
                *Debe ingresar escalas superiores a 0 e inferiores a 999
            </p>
            <p class="text-danger" v-show="flag_minmax">
                *Escala mínima no puede ser mayor que la máxima
            </p>
            <!-- Escala mínima-->
            <b-form-group
                label-cols-sm="5"
                label="Escala mínima:"
                label-align-sm="left"
                class="p-0 m-0"
            >
                <b-form-input
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
                    v-model="esc.valor_max"
                    size="sm"
                    type="number"
                    min="0"
                    max="999"
                ></b-form-input>
            </b-form-group>
        </b-form-group>

        <!--FOOTER-->
        <template v-slot:modal-footer="{ ok, cancel }">
            <b-button variant="outline-danger" @click="cancel">
                CANCELAR
            </b-button>
            <b-button variant="primary" @click="validar(ok)">
                CREAR
            </b-button>
        </template>
    </b-modal>
</template>

<script>
export default {
    data() {
        return {
            esc: { valor_min: 0, valor_max: 0 },
            flag_esc: false,
            flag_minmax: false,
        };
    },

    methods: {
        crearEscala(fnok) {
            let idUser = this.$route.params.id;
            let urlBaseApi = `http://localhost:3000/prod/${idUser}`;

            //Escala vecemos

            fetch(urlBaseApi + "/escala/vencer", {
                method: "PUT",
            })
                .then((response) => {
                    return response.json();
                })
                .then((res) => {
                    //console.log("Servidor responde esc: ", res);

                    //CREAMOS ESCALA
                    fetch(urlBaseApi + "/escala/crear", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },

                        body: JSON.stringify({
                            valor_min: this.esc.valor_min,
                            valor_max: this.esc.valor_max,
                        }),
                    })
                        .then((response) => {
                            return response.json();
                        })
                        .then((res) => {
                            console.log("Servidor responde esc: ", res);

                            fnok();
                            this.$router.go();
                        });
                });
        },
        checkMinMax() {
            this.flag_minmax = false;
            if (
                this.esc.valor_min > this.esc.valor_max ||
                this.esc.valor_min == this.esc.valor_max
            ) {
                this.flag_minmax = true;
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
        validar(fnok) {
            this.checkEsc();
            this.checkMinMax();

            if (!(this.flag_esc || this.flag_minmax)) {
                console.log("Todo okk");
                this.crearEscala(fnok);
            }
        },
    },
};
</script>

<style></style>
