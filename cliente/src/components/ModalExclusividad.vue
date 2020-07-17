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
    props: ["proveedor"],
    methods: {
        selectExclusividad(optFun, opt) {
            let aux_prov = this.proveedor;

            let idUser = this.$route.params.id;
            let urlBaseApi = `http://localhost:3000/prod/${idUser}/contratos/nuevo/ing/`;
            let urlFinal = urlBaseApi;

            //GET Nueva lista de ings
            console.log("OPCION ", opt);
            if (opt) {
                //Con exc
                urlFinal += `exc/${aux_prov.id || aux_prov.provid}`;
            } else {
                //Sin exc
                urlFinal += `${aux_prov.id || aux_prov.provid}`;
            }

            fetch(urlFinal)
                .then((response) => {
                    return response.json();
                })
                .then((newIngs) => {
                    console.log("NUEVOS INGS", newIngs);

                    this.$emit("optionSelect", newIngs, opt);
                    optFun();
                });
        },
    },
};
</script>

<style></style>
