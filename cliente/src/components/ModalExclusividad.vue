<template>
    <b-modal id="exclusividad-modal" size="lg" centered title="Exclusividad">
        <!-- CONTENIDO MODAL -->
        <p class="text-center">
            ¿Desea solicitar exclusividad de las materias primas para el contrato?
        </p>

        <template v-slot:modal-footer="{ ok, cancel }">
            <b-button variant="outline-danger" @click="selectExclusividad(cancel, false)">
                NO
            </b-button>
            <b-button variant="primary" @click="selectExclusividad(ok, true)">
                SI
            </b-button>
        </template>
    </b-modal>
</template>

<script>
export default {
    methods: {
        selectExclusividad(optFun, opt) {
            this.$emit("optionSelect", opt);
            optFun();
        },
    },
};
</script>

<style></style>
