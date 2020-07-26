<template>
    <b-modal
        id="recomendador-modal"
        size="lg"
        centered
        v-model="show"
        hide-backdrop
        no-close-on-backdrop
        no-close-on-esc
    >
        <!-- HEADER -->
        <template v-slot:modal-header>
            <span></span>
        </template>

        <!-- CONTENIDO MODAL -->
        <div class="text-center">
            <!--LOADING -->
            <div class="loading texe-center" v-show="mode_loading">
                <b-spinner
                    style="width: 4rem; height: 4rem;"
                    variant="info"
                    type="grow"
                ></b-spinner>
            </div>

            <!-- BIENVENIDA -->
            <div class="bienvenida" v-show="!mode_recon && !mode_loading">
                <h4>¡Bienvenido al recomendador!</h4>
                <p>Una experiencia guiada para encontrar tu perfume ideal para cada ocación</p>
                <br />
                <b-button variant="outline-info" @click="mode_recon = true">¡ACONSÉJAME!</b-button>
            </div>

            <!--PREGUNTAS -->
            <div
                class="pregunta"
                v-for="(p, i) in preguntas"
                :key="i"
                v-show="i == pagina && mode_recon && !ask_continuar && !mode_loading"
            >
                <h4>{{ p.pregunta }}</h4>
                <br />
                <!-- una opcion -->
                <div class="opciones" v-if="!p.multi">
                    <b-button
                        :variant="p.respuesta[0] == op.value ? 'info' : 'outline-info'"
                        v-for="(op, j) in p.opciones"
                        :key="j"
                        @click="opcionSelected(op)"
                    >
                        {{ op.text }}
                    </b-button>
                </div>

                <!-- Multi opcion -->
                <div class="multi" v-else>
                    <b-form-checkbox-group v-model="p.respuesta">
                        <b-form-checkbox
                            v-for="(op, k) in p.opciones"
                            :key="k"
                            :value="op.value"
                            button-variant="info"
                            >{{ op.text }}</b-form-checkbox
                        >
                    </b-form-checkbox-group>
                </div>
                <br />

                <!--Acciones ant o nex preg -->
                <div class="op-dist">
                    <b-button
                        variant="outline-info"
                        size="sm"
                        v-show="p.multi && !mode_loading"
                        @click="pagina++"
                        >Siguiente <b-icon icon="caret-right"></b-icon
                    ></b-button>
                </div>
            </div>

            <!-- DESEA CONTINUAR? -->
            <div class="desea-continuar" v-show="ask_continuar && !mode_loading">
                <h3>¿Desea continuar personalizando?</h3>
                <br />
                <div class="todo">
                    <b-button variant="outline-info" @click="opcionContinuarSelected(false)"
                        >Ver perfumes</b-button
                    >
                    <b-button variant="info" @click="opcionContinuarSelected(true)"
                        >Continuar <b-icon icon="caret-right-fill"></b-icon
                    ></b-button>
                </div>
            </div>
        </div>

        <!-- FOOTER -->
        <template v-slot:modal-footer>
            <span></span>
        </template>
    </b-modal>
</template>

<script>
export default {
    props: ["show"],
    data() {
        return {
            pagina: 0,
            mode_recon: false,
            mode_loading: false,
            ask_continuar: false,
            preguntas: [
                {
                    pregunta: "Cuéntanos, ¿Para quién es el perfume?",
                    respuesta: [null],
                    multi: false,
                    opciones: [
                        { text: "Un hombre", value: "h" },
                        { text: "Una mujer", value: "f" },
                        { text: "Unisex", value: "u" },
                    ],
                },
                {
                    pregunta: "Edad:",
                    respuesta: [null],
                    multi: false,
                    opciones: [],
                },
                {
                    pregunta: "Intensidad:",
                    respuesta: [null],
                    multi: false,
                    opciones: [],
                },
                {
                    pregunta: "Caracter:",
                    respuesta: [null],
                    multi: true,
                    opciones: [],
                },
                {
                    pregunta: "Familia olfativa:",
                    respuesta: [null],
                    multi: true,
                    opciones: [],
                },
                {
                    pregunta: "Aroma:",
                    respuesta: [null],
                    multi: true,
                    opciones: [],
                },
                {
                    pregunta: "Preferencia de uso:",
                    respuesta: [null],
                    multi: false,
                    opciones: [],
                },
                {
                    pregunta: "Personalidad:",
                    respuesta: [null],
                    multi: true,
                    opciones: [],
                },
            ],
            perfumes: [],
        };
    },
    methods: {
        opcionSelected(obj) {
            this.preguntas[this.pagina].respuesta[0] = obj;
            this.mode_loading = true;

            this.getOpcionesFromServer();
            //this.ask_continuar = true;
        },
        opcionContinuarSelected(opt) {
            if (opt) {
                //this.ask_continuar = false;
                //this.pagina++;
                this.mode_loading = true;
                this.filtrarPerfumes();
            } else {
                //Mostrar resultados
            }
        },
        backAction() {
            this.pagina--;
        },
        gestionarRespuesta(res) {
            switch (this.pagina) {
                case 0:
                    //Genero
                    res = {
                        Perfumes: [
                            {
                                id: 2,
                                nombre: "Francia",
                                genero: "f",
                                rango_edad: "adu",
                                descrip_componentes: "alcohol, agua",
                                tipo_estructura: "f",
                                descrip_perf:
                                    "Love Fury de Nine West es una fragancia de la familia olfativa Floral Frutal para Mujeres. Love Fury se lanzó en 2012. La Nariz detrás de esta fragrancia es Firmenich",
                                id_perfumista: 3,
                                nom_perfumista: "Jean-Marc",
                                apellido: "Chaillan",
                                id_perf_int: 2,
                                tipo_int: "edp",
                                porc_concentracion: "15",
                                descripcion: null,
                                id_pres: 2,
                                volumen: "50",
                            },
                            {
                                id: 3,
                                nombre: "Estados Unidos de America",
                                genero: "f",
                                rango_edad: "adu",
                                descrip_componentes: "alcohol, agua",
                                tipo_estructura: "f",
                                descrip_perf:
                                    "Fabulous de Isaac Mizrahi es una fragancia de la familia olfativa Floral Frutal para Mujeres. Fabulous se lanzó en 2012. La Nariz detrás de esta fragrancia es Firmenich",
                                id_perfumista: 4,
                                nom_perfumista: "Isaac",
                                apellido: "Mizrahi",
                                id_perf_int: 3,
                                tipo_int: "edp",
                                porc_concentracion: "15",
                                descripcion: null,
                                id_pres: 3,
                                volumen: "50",
                            },
                            {
                                id: 6,
                                nombre: "Francia",
                                genero: "f",
                                rango_edad: "ate",
                                descrip_componentes: "alcohol, agua",
                                tipo_estructura: "f",
                                descrip_perf:
                                    "Blu Love Affair de Byblos es una fragancia de la familia olfativa Oriental Especiada para Mujeres. Blu Love Affair se lanzó en 2006. La Nariz detrás de esta fragancia es IFF",
                                id_perfumista: 10,
                                nom_perfumista: "Ilias",
                                apellido: "Ermenidis",
                                id_perf_int: 6,
                                tipo_int: "edt",
                                porc_concentracion: "10",
                                descripcion: null,
                                id_pres: 7,
                                volumen: "100",
                            },
                            {
                                id: 6,
                                nombre: "Francia",
                                genero: "f",
                                rango_edad: "ate",
                                descrip_componentes: "alcohol, agua",
                                tipo_estructura: "f",
                                descrip_perf:
                                    "Blu Love Affair de Byblos es una fragancia de la familia olfativa Oriental Especiada para Mujeres. Blu Love Affair se lanzó en 2006. La Nariz detrás de esta fragancia es IFF",
                                id_perfumista: 9,
                                nom_perfumista: "Philipe",
                                apellido: "Roque",
                                id_perf_int: 6,
                                tipo_int: "edt",
                                porc_concentracion: "10",
                                descripcion: null,
                                id_pres: 7,
                                volumen: "100",
                            },
                            {
                                id: 7,
                                nombre: "Francia",
                                genero: "f",
                                rango_edad: "ate",
                                descrip_componentes:
                                    "alcohol agua, Anthoxanthumm metoxicinamato de etilhexilo, ethylexil salicilato, butilo, methoxidibenzoylmethalo, cielanhalo",
                                tipo_estructura: "f",
                                descrip_perf:
                                    "Herbae de L'OCCITANE fue diseñado para traducir esta forma de imperfección que nos hace únicos. Es por eso que Herbae de L'OCCITANE eligió hierbas silvestres para encarnar su fragancia",
                                id_perfumista: 11,
                                nom_perfumista: "Karin",
                                apellido: "Dubreuil",
                                id_perf_int: 7,
                                tipo_int: "edp",
                                porc_concentracion: "15",
                                descripcion: null,
                                id_pres: 8,
                                volumen: "10",
                            },
                            {
                                id: 7,
                                nombre: "Francia",
                                genero: "f",
                                rango_edad: "ate",
                                descrip_componentes:
                                    "alcohol agua, Anthoxanthumm metoxicinamato de etilhexilo, ethylexil salicilato, butilo, methoxidibenzoylmethalo, cielanhalo",
                                tipo_estructura: "f",
                                descrip_perf:
                                    "Herbae de L'OCCITANE fue diseñado para traducir esta forma de imperfección que nos hace únicos. Es por eso que Herbae de L'OCCITANE eligió hierbas silvestres para encarnar su fragancia",
                                id_perfumista: 11,
                                nom_perfumista: "Karin",
                                apellido: "Dubreuil",
                                id_perf_int: 7,
                                tipo_int: "edp",
                                porc_concentracion: "15",
                                descripcion: null,
                                id_pres: 9,
                                volumen: "50",
                            },
                            {
                                id: 7,
                                nombre: "Francia",
                                genero: "f",
                                rango_edad: "ate",
                                descrip_componentes:
                                    "alcohol agua, Anthoxanthumm metoxicinamato de etilhexilo, ethylexil salicilato, butilo, methoxidibenzoylmethalo, cielanhalo",
                                tipo_estructura: "f",
                                descrip_perf:
                                    "Herbae de L'OCCITANE fue diseñado para traducir esta forma de imperfección que nos hace únicos. Es por eso que Herbae de L'OCCITANE eligió hierbas silvestres para encarnar su fragancia",
                                id_perfumista: 11,
                                nom_perfumista: "Karin",
                                apellido: "Dubreuil",
                                id_perf_int: 7,
                                tipo_int: "edp",
                                porc_concentracion: "15",
                                descripcion: null,
                                id_pres: 10,
                                volumen: "90",
                            },
                            {
                                id: 8,
                                nombre: "Francia",
                                genero: "f",
                                rango_edad: "ate",
                                descrip_componentes:
                                    "alcohol, agua, limonene, linalol, aceite de cáscara de mandarina, Helichrysum italicum, aceite de flor de Lavandula angustifolia",
                                tipo_estructura: "f",
                                descrip_perf:
                                    "Una fragancia viva, afrutada y picante que combina Cassis de Bourgogne y Ruibarbo. También disponible en nuestra tienda 86Champs",
                                id_perfumista: 12,
                                nom_perfumista: "Alexis",
                                apellido: "Dadier",
                                id_perf_int: 8,
                                tipo_int: "edp",
                                porc_concentracion: "15",
                                descripcion: null,
                                id_pres: 11,
                                volumen: "90",
                            },
                            {
                                id: 10,
                                nombre: "Francia",
                                genero: "f",
                                rango_edad: "ate",
                                descrip_componentes: "alcohol, agua",
                                tipo_estructura: "m",
                                descrip_perf:
                                    "La rosa es un símbolo intemporal de belleza y feminidad. Como una obra de arte original, Rose de Grasse está meticulosamente elaborada con una atención artesanal a los detalles. En el fondo hay una fusión de rosas, incluida la rosa Centifolia de cien pétalos, cuidadosamente seleccionada en Grasse, la capital francesa de la perfumería desde el siglo XVI, donde la historia de las fragancias es arte",
                                id_perfumista: 13,
                                nom_perfumista: "Olivier",
                                apellido: "Cresp",
                                id_perf_int: 10,
                                tipo_int: "edp",
                                porc_concentracion: "15",
                                descripcion: null,
                                id_pres: 14,
                                volumen: "50",
                            },
                            {
                                id: 10,
                                nombre: "Francia",
                                genero: "f",
                                rango_edad: "ate",
                                descrip_componentes: "alcohol, agua",
                                tipo_estructura: "m",
                                descrip_perf:
                                    "La rosa es un símbolo intemporal de belleza y feminidad. Como una obra de arte original, Rose de Grasse está meticulosamente elaborada con una atención artesanal a los detalles. En el fondo hay una fusión de rosas, incluida la rosa Centifolia de cien pétalos, cuidadosamente seleccionada en Grasse, la capital francesa de la perfumería desde el siglo XVI, donde la historia de las fragancias es arte",
                                id_perfumista: 13,
                                nom_perfumista: "Olivier",
                                apellido: "Cresp",
                                id_perf_int: 10,
                                tipo_int: "edp",
                                porc_concentracion: "15",
                                descripcion: null,
                                id_pres: 15,
                                volumen: "100",
                            },
                            {
                                id: 11,
                                nombre: "Francia",
                                genero: "f",
                                rango_edad: "ate",
                                descrip_componentes: "alcohol, agua",
                                tipo_estructura: "m",
                                descrip_perf:
                                    "Amber Musk combina flores sensuales, ámbar distintivo y almizcle cremoso. Ambrox causa una primera impresión aterciopelada, en contraste con una suculenta explosión de agua de coco y la feminidad de Rose Centifolia Absolute. Al igual que el resplandor de las llamas ámbar, el persistente Benzoin & Musk infunde calidez en la fragancia",
                                id_perfumista: 13,
                                nom_perfumista: "Olivier",
                                apellido: "Cresp",
                                id_perf_int: 11,
                                tipo_int: "edp",
                                porc_concentracion: "15",
                                descripcion: null,
                                id_pres: 16,
                                volumen: "50",
                            },
                            {
                                id: 11,
                                nombre: "Francia",
                                genero: "f",
                                rango_edad: "ate",
                                descrip_componentes: "alcohol, agua",
                                tipo_estructura: "m",
                                descrip_perf:
                                    "Amber Musk combina flores sensuales, ámbar distintivo y almizcle cremoso. Ambrox causa una primera impresión aterciopelada, en contraste con una suculenta explosión de agua de coco y la feminidad de Rose Centifolia Absolute. Al igual que el resplandor de las llamas ámbar, el persistente Benzoin & Musk infunde calidez en la fragancia",
                                id_perfumista: 13,
                                nom_perfumista: "Olivier",
                                apellido: "Cresp",
                                id_perf_int: 11,
                                tipo_int: "edp",
                                porc_concentracion: "15",
                                descripcion: null,
                                id_pres: 17,
                                volumen: "100",
                            },
                            {
                                id: 12,
                                nombre: "México",
                                genero: "f",
                                rango_edad: "adu",
                                descrip_componentes: "alcohol, agua",
                                tipo_estructura: "m",
                                descrip_perf:
                                    "Una suntuosa caricia de lujo. El eau de parfum Donna Karan Cashmere Mist es una fragancia floral pura e intoxicante inspirada en la sensación de la cachemira sobre la piel de una mujer. Combinando las esencias de jazmín marroquí, lirio de los valles y la frescura de la bergamota, contra un cálido fondo de sándalo, ámbar y almizcle, es un aroma sensualmente suave que seduce los sentidos",
                                id_perfumista: 14,
                                nom_perfumista: "Rodrigo",
                                apellido: "Flores-Roux",
                                id_perf_int: 12,
                                tipo_int: "edp",
                                porc_concentracion: "15",
                                descripcion: null,
                                id_pres: 18,
                                volumen: "100",
                            },
                        ],
                    };

                    this.perfumes = res.Perfumes;

                    this.mode_loading = false;
                    this.ask_continuar = true;
                    break;

                default:
                    break;
            }
        },
        getOpcionesFromServer() {
            let urlBaseApi = "http://localhost:3000/rec/";
            let urlApi = urlBaseApi;

            switch (this.pagina) {
                case 0:
                    //Genero
                    urlApi += "perfumes";
                    break;

                default:
                    break;
            }

            this.gestionarRespuesta();

            /*
            fetch(urlApi).then((response) => {
                    return response.json();
                })
                .then(res =>{

                })*/
        },
        getTextEdad(valueEdad) {
            switch (valueEdad) {
                case "adu":
                    return "Adulto";
                    break;

                case "ate":
                    return "Atemporal";
                    break;

                case "inf":
                    return "Infantil";
                    break;
                case "juv":
                    return "Juvenil";
                    break;
                default:
                    break;
            }
        },
        filtrarPerfumes() {
            switch (this.pagina) {
                case 0:
                    //Dame perf segun el genero select
                    let aux_perf = this.perfumes.map((perf) => {
                        if (perf.genero == this.preguntas[this.pagina].respuesta[0].value) {
                            //Perfume va
                            this.addOpcionesPosible(perf, this.pagina + 1);
                            return perf;
                        }
                    });

                    break;

                default:
                    break;
            }

            this.mode_loading = false;
            this.ask_continuar = false;
            this.pagina++;
        },
        canAdd(ipreg, value) {
            for (let i = 0; i < this.preguntas[ipreg].opciones.length; i++) {
                if (this.preguntas[ipreg].opciones[i].value == value) {
                    return false;
                }
            }
            return true;
        },
        addOpcionesPosible(perf, ipreg) {
            //ipreg = pagina+1

            switch (ipreg) {
                case 1:
                    //Add Opciones de edades disponibles

                    if (this.canAdd(ipreg, perf.rango_edad)) {
                        this.preguntas[ipreg].opciones.push({
                            text: this.getTextEdad(perf.rango_edad),
                            value: perf.rango_edad,
                        });
                    }

                    break;

                default:
                    break;
            }
        },
    },
};
</script>

<style>
.opciones {
    display: grid;
    grid-template-columns: auto auto auto;
    grid-template-rows: auto;
    column-gap: 10px;
    row-gap: 15px;
}

.todo {
    display: flex;
    justify-content: space-around;
}

.custom-control-input:checked ~ .custom-control-label::before {
    color: #fff;
    border-color: #613bb1;
    background-color: #613bb1;
}

.op-dist {
    display: flex;
    justify-content: space-between;
}
</style>
