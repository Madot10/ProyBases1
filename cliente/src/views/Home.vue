<template>
    <div class="home">
        <!-- Aviso -->
        <b-toast id="toast-aviso" :variant="aviso.tipo" :title="aviso.titulo" solid>
            {{ aviso.mensaje }}
        </b-toast>

        <!-- MODAL -->
        <modal-m-p
            :datos="mp_p[mp_selected_i]"
            :mode="mode"
            @crear="crearNuevoMP"
            @actualizar="actualizarMP"
        ></modal-m-p>

        <h2>MATERIA PRIMA PROHIBIDA</h2>
        <b-button variant="outline-primary" block @click="openModal(null, 'a')">Agregar +</b-button>
        <br />
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
                    @click="openModal(row.index, 'v')"
                ></b-icon>
                <span class="ml-2"></span>
                <b-icon
                    class="cur-fake m-1"
                    font-scale="1.5"
                    icon="pencil-square"
                    variant="dark"
                    v-b-tooltip.hover
                    title="Editar"
                    @click="openModal(row.index, 'e')"
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
import ModalMP from "../components/ModalMP.vue";

export default {
    components: {
        ModalMP,
    },
    data() {
        return {
            aviso: { mensaje: "", titulo: "", tipo: "success" },
            isLoading: true,
            mp_selected_i: null,
            mode: "",
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
    methods: {
        openModal(index, mode) {
            this.mp_selected_i = index;
            this.mode = mode;
            this.$bvModal.show("detalle-modal");
        },
        crearNuevoMP(obj) {
            //console.log("evento nuevo", obj);
            this.axios
                .post("http://localhost:3000/mp_prob", obj)
                .then((res) => {
                    this.mp_p.push(obj);

                    this.aviso.mensaje = "¡Guardado correctamente!";
                    this.aviso.titulo = "Éxito";
                    this.aviso.tipo = "success";
                    this.$bvToast.show("toast-aviso");
                })
                .catch((err) => {
                    this.aviso.mensaje = "¡Ha ocurrido un error!";
                    this.aviso.titulo = "Error";
                    this.aviso.tipo = "danger";
                    this.$bvToast.show("toast-aviso");

                    console.log("ERROR ", err);
                });
        },
        actualizarMP(obj) {
            this.axios
                .put(`http://localhost:3000/mp_prob/${this.mp_p[this.mp_selected_i].cas}`, obj)
                .then((res) => {
                    this.mp_p[this.mp_selected_i].cas = obj.cas;
                    this.mp_p[this.mp_selected_i].nombre = obj.nombre;

                    this.aviso.mensaje = "¡Guardado correctamente!";
                    this.aviso.titulo = "Éxito";
                    this.aviso.tipo = "success";
                    this.$bvToast.show("toast-aviso");
                })
                .catch((err) => {
                    this.aviso.mensaje = "¡Ha ocurrido un error!";
                    this.aviso.titulo = "Error";
                    this.aviso.tipo = "danger";
                    this.$bvToast.show("toast-aviso");

                    console.log("ERROR ", err);
                });
        },
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
    min-height: 92vh;
    border-radius: 10px;
    margin: 25px;
    padding: 25px;
}
.cur-fake {
    cursor: pointer;
}
</style>
