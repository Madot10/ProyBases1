<template>
    <b-modal id="perf-det-modal" centered size="xl" :title="perfume.nombre">
        <!-- CONTENIDO MODAL -->
        <b-container fluid>
            {{ perfume }}
        </b-container>
    </b-modal>
</template>

<script>
export default {
    props: ["perfume"],
};
</script>

<style></style>
