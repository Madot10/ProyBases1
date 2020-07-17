<template>
    <b-modal
        id="cancelar-modal"
        size="lg"
        centered
        :title="mode_con ? 'Cancelar contrato' : 'Cancelar pedido'"
    >
        <!-- CONTENIDO MODAL -->
        <b-container fluid>
            <b-row>
                <b-col>
                    <b-form-group class="mb-0" label="Motivo de cancelación:">
                        <b-form-textarea
                            v-model="text_cancel"
                            placeholder="(opcional)"
                            rows="4"
                            max-rows="10"
                        ></b-form-textarea>
                    </b-form-group>
                </b-col>
            </b-row>
        </b-container>

        <template v-slot:modal-footer="{ ok, cancel }">
            <b-button variant="outline-secondary" @click="cancel()">
                Cerrar
            </b-button>
            <b-button variant="primary" @click="selectCancelar(ok)">
                {{ mode_con ? "Cancelar contrato" : "Cancelar pedido" }}
            </b-button>
        </template>
    </b-modal>
</template>

<script>
export default {
    props: ["mode_con"],
    data() {
        return {
            text_cancel: "",
        };
    },
    methods: {
        selectCancelar(optFun) {
            let text = this.text_cancel;
            this.$emit("optionCancelar", { text });
            optFun();
            this.text_cancel = "";
        },
    },
};
</script>

<style></style>
