<template>
    <div class="home">
        <h2>MATERIA PRIMA PROHIBIDA</h2>

        <!--- TABLA DE DATOS -->
        <b-table
            striped
            hover
            :items="mp_p"
            :per-page="perPage"
            id="mp-table"
            :current-page="currentPage"
            :fields="fields"
            :busy.sync="isLoading"
        >
            <!-- LOADING -->
            <template v-slot:table-busy>
                <div class="text-center text-primary my-2">
                    <b-spinner class="align-middle mr-2"></b-spinner>
                    <strong>Cargando...</strong>
                </div>
            </template>

            <!-- BOTON Acciones -->
            <template v-slot:cell(acciones)="row">
                <b-icon
                    class="cur-fake m-1"
                    font-scale="1.5"
                    icon="search"
                    variant="dark"
                    v-b-tooltip.hover
                    title="Ver detalle"
                ></b-icon>
                <span class="ml-2"></span>
                <b-icon
                    class="cur-fake m-1"
                    font-scale="1.5"
                    icon="pencil-square"
                    variant="dark"
                    v-b-tooltip.hover
                    title="Editar"
                ></b-icon>
            </template>
        </b-table>

        <b-pagination
            v-model="currentPage"
            :total-rows="rows"
            :per-page="perPage"
            align="center"
            aria-controls="mp-table"
        >
            <template v-slot:first-text><b-icon icon="chevron-double-left"></b-icon></template>
            <template v-slot:prev-text><b-icon icon="chevron-left"></b-icon></template>
            <template v-slot:next-text><b-icon icon="chevron-right"></b-icon></template>
            <template v-slot:last-text><b-icon icon="chevron-double-right"></b-icon></template>
        </b-pagination>
    </div>
</template>

<script>
export default {
    data() {
        return {
            isLoading: true,
            currentPage: 1,
            perPage: 10,
            mp_p: [],
            fields: [
                { key: "cas", label: "CAS", sortable: true },
                { key: "nombre", label: "NOMBRE", sortable: true },
                {
                    key: "ACCIONES",
                    sortable: false,
                },
            ],
        };
    },
    computed: {
        rows() {
            return this.mp_p.length;
        },
    },
    created() {
        //GET ALL
        this.axios
            .get("http://localhost:3000/mp_prob")
            .then((res) => {
                console.log("Descargado! ", res.data.Productos_Prohibidos);
                this.mp_p = res.data.Productos_Prohibidos;
                this.isLoading = false;
            })
            .catch((err) => {
                console.error("Ha ocurrido un error! ", err);
            });
    },
};
</script>

<style>
body {
    background-color: gray;
}
.home {
    background-color: white;
    height: 92vh;
    border-radius: 10px;
    margin: 25px;
    padding: 25px;
}
.cur-fake {
    cursor: pointer;
}
</style>
