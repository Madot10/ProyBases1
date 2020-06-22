<template>
    <b-container fluid class="view-container">
        <div class="page-header">
            <b-row>
                <b-col><h2>DATOS PROVEEDOR</h2></b-col>
                <b-col class="my-2"><b-button block variant="primary">MODIFICAR</b-button></b-col>
            </b-row>
        </div>
        <div class="content-card px-4 py-3">
            <b-form-group
                label-cols-lg="2"
                label="DATOS BÁSICOS"
                label-size="lg"
                label-class="font-weight-bold pt-0"
                class="mb-0"
            >
                <br />
                <b-form-group label="Nombre de empresa:" label-for="nested-street">
                    <b-form-input id="nested-street"></b-form-input>
                </b-form-group>
            </b-form-group>
        </div>
    </b-container>
</template>

<script>
export default {};
</script>

<style>
.view-container {
    height: 100%;
}

.content-card {
    min-height: 90%;
    background-color: white;
    border-radius: 10px;
}
</style>
