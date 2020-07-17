<template>
    <b-modal id="quiere-modal" size="lg" centered title="Contrato">
        <!-- CONTENIDO MODAL -->
        <p class="text-center">
            ¿Desea cancelar el contrato actual?
        </p>

        <template v-slot:modal-footer="{ ok, cancel }">
            <b-button variant="outline-danger" @click="selectOpt(cancel, false)">
                NO
            </b-button>
            <b-button variant="primary" @click="selectOpt(ok, true)">
                SI
            </b-button>
        </template>
    </b-modal>
</template>

<script>
export default {
    methods: {
        selectOpt(optFun, opt) {
            this.$emit("optionSelect", opt);
            optFun();
        },
    },
};
</script>

<style></style>
