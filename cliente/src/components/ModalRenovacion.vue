<template>
    <b-modal id="ask-renov-modal" centered title="Tipo de renovación">
        <!-- CONTENIDO MODAL -->
        <p class="text-center">
            ¿Desea renovar el contrato con iguales condiciones?
        </p>

        <template v-slot:modal-footer="{ ok, cancel }">
            <b-button variant="outline-danger" @click="selectRenov(cancel, false)">
                NO
            </b-button>
            <b-button variant="primary" @click="selectRenov(ok, true)">
                SI
            </b-button>
        </template>
    </b-modal>
</template>

<script>
export default {
    methods: {
        selectRenov(optFun, opt) {
            this.$emit("renovSelect", opt);
            optFun();
        },
    },
};
</script>

<style></style>
