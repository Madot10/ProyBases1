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
                            class="multi-opt"
                            v-for="(op, k) in p.opciones"
                            :key="k"
                            :value="op.value"
                            button-variant="info"
                            >{{ op.text }}</b-form-checkbox
                        >
                    </b-form-checkbox-group>
                </div>
                <p class="text-danger" v-show="flag_null">
                    * Debe seleccionar una opción para poder continuar
                </p>
                <br />

                <!--Acciones ant o nex preg -->
                <div class="op-dist">
                    <b-button
                        variant="outline-info"
                        size="sm"
                        v-show="p.multi && !mode_loading"
                        @click="opcionSiguienteMulti"
                        >Siguiente <b-icon icon="caret-right"></b-icon
                    ></b-button>
                </div>
            </div>

            <!-- DESEA CONTINUAR? -->
            <div class="desea-continuar" v-show="ask_continuar && !mode_loading">
                <h3 v-show="pagina != 7 && !mode_empty">¿Desea continuar personalizando?</h3>
                <h3 v-show="pagina == 7 || mode_empty">
                    ¿Preparado para ver sus perfumes ideales?
                </h3>
                <p v-show="mode_empty">
                    Actualmente no poseemos más perfumes que se adapten a las opciones
                </p>
                <br />
                <div class="todo">
                    <b-button variant="outline-info" @click="opcionContinuarSelected(false)"
                        >Ver perfumes</b-button
                    >
                    <b-button
                        variant="info"
                        @click="opcionContinuarSelected(true)"
                        v-show="pagina != 7"
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
    data() {
        return {
            show: true,
            pagina: 0,
            mode_recon: false,
            mode_loading: false,
            mode_empty: false,
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
                    pregunta:
                        "Sabemos que la edad es sinónimo de experiencia ¿Crees identificarte cuál es tu rango de experiencia?",
                    respuesta: [null],
                    multi: false,
                    opciones: [],
                },
                {
                    pregunta: "¿Con cuál clase de esencia te podemos ayudar?",
                    respuesta: [null],
                    multi: false,
                    opciones: [],
                },
                {
                    pregunta:
                        "Creemos que el carácter marca a todo el que nos conozca ¿De qué forma marcas a quien te conoce?",
                    respuesta: [null],
                    multi: true,
                    opciones: [],
                },
                {
                    pregunta: "¿Qué clasificación te gustaría que fuera el perfume?",
                    respuesta: [null],
                    multi: true,
                    opciones: [],
                },
                {
                    pregunta: "¿Cuál es el aroma que te gustaría que perdurara más?",
                    respuesta: [null],
                    multi: true,
                    opciones: [],
                },
                {
                    pregunta: "¿Cuál es la ocasión ideal para el perfume que buscas?",
                    respuesta: [null],
                    multi: false,
                    opciones: [],
                },
                {
                    pregunta: "¿Qué quisieras que el perfume resaltara de ti?",
                    respuesta: [null],
                    multi: true,
                    opciones: [],
                },
            ],
            perfumes: [],
            flag_null: false,
            objToSend: {
                genero: null,
                edad: null,
                filtros: {
                    intensidad: [],
                    caracter: [],
                    flia_olf: [],
                    aroma: [],
                    preferencia: [],
                },
            },
        };
    },
    methods: {
        construirObj() {
            switch (this.pagina) {
                case 0:
                    this.objToSend.genero = this.preguntas[this.pagina].respuesta[0].value;
                    break;

                default:
                    break;
            }
        },
        opcionSelected(obj) {
            this.preguntas[this.pagina].respuesta[0] = obj;
            this.mode_loading = true;

            this.getOpcionesFromServer();
            //this.ask_continuar = true;
        },
        checkNonEmpty() {
            this.flag_null = false;

            if (this.preguntas[this.pagina].respuesta.length < 2) {
                this.flag_null = true;
                return false;
            }

            return true;
        },
        opcionSiguienteMulti() {
            if (this.checkNonEmpty()) {
                this.mode_loading = true;

                this.getOpcionesFromServer();
            }
        },
        opcionContinuarSelected(opt) {
            if (opt) {
                this.ask_continuar = false;
                this.pagina++;
                //this.mode_loading = true;
            } else {
                //Mostrar resultados
                this.show = false;
                this.$emit("readyPerf", this.perfumes);
            }
        },
        perfumesVacio() {
            //this.perfumes tienen el filtro anterior
            this.mode_loading = false;
            this.mode_empty = true;
        },
        gestionarRespuesta(res) {
            switch (this.pagina) {
                case 0:
                    //Genero

                    this.perfumes = res.Perfumes;

                    this.filtrarPerfumes();
                    break;
                case 1:
                    //Edad
                    this.filtrarPerfumes();
                    break;

                case 2:
                    //Caracteres
                    if (res.Caracteres.length > 0) {
                        this.filtrarPerfumes(res.Caracteres);
                    } else {
                        this.perfumesVacio();
                    }

                    break;

                case 3:
                    //Flia
                    if (res.Familias_Olfativas.length > 0) {
                        this.filtrarPerfumes(res.Familias_Olfativas);
                    } else {
                        this.perfumesVacio();
                    }
                    break;

                case 4:
                    if (res.Aromas.length > 0) {
                        this.filtrarPerfumes(res.Aromas);
                    } else {
                        this.perfumesVacio();
                    }
                    break;

                case 5:
                    if (res.Preferencias.length > 0) {
                        this.filtrarPerfumes(res.Preferencias);
                    } else {
                        this.perfumesVacio();
                    }
                    break;

                case 6:
                    if (res.Personalidades.length > 0) {
                        this.filtrarPerfumes(res.Personalidades);
                    } else {
                        this.perfumesVacio();
                    }
                    break;
                default:
                    break;
            }

            this.mode_loading = false;
            this.ask_continuar = true;
        },
        getOpcionesFromServer() {
            this.construirObj();

            let urlBaseApi = "http://localhost:3000/rec/";
            let urlApi = urlBaseApi;

            switch (this.pagina) {
                case 0:
                    //Genero
                    urlApi += "perfumes";
                    let res = {
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

                    //this.gestionarRespuesta(res);

                    break;

                case 2:
                    //Construir objecto a enviar
                    //Get opciones de caracter
                    let caract_res = {
                        Caracteres: [
                            {
                                id_perf: 2,
                                id_car: 44,
                                palabra: "Floral",
                            },
                            {
                                id_perf: 2,
                                id_car: 45,
                                palabra: "Natural",
                            },
                            {
                                id_perf: 2,
                                id_car: 46,
                                palabra: "Luminosa",
                            },
                            {
                                id_perf: 3,
                                id_car: 44,
                                palabra: "Floral",
                            },
                            {
                                id_perf: 3,
                                id_car: 45,
                                palabra: "Natural",
                            },
                            {
                                id_perf: 3,
                                id_car: 46,
                                palabra: "Luminosa",
                            },
                            {
                                id_perf: 12,
                                id_car: 44,
                                palabra: "Floral",
                            },
                        ],
                    };
                    this.gestionarRespuesta(caract_res);
                    break;

                case 3:
                    let flia_res = {
                        Familias_Olfativas: [
                            {
                                id_perf: 2,
                                id_flia: 3,
                                nombre: "Flores",
                            },
                            {
                                id_perf: 2,
                                id_flia: 4,
                                nombre: "Frutas",
                            },
                            {
                                id_perf: 3,
                                id_flia: 3,
                                nombre: "Flores",
                            },
                            {
                                id_perf: 3,
                                id_flia: 4,
                                nombre: "Frutas",
                            },
                            {
                                id_perf: 12,
                                id_flia: 3,
                                nombre: "Flores",
                            },
                        ],
                    };

                    this.gestionarRespuesta(flia_res);
                    break;

                case 4:
                    let aroma_res = {
                        Aromas: [
                            {
                                id_perf: 2,
                                id_aroma: 1,
                                palabra: "Madera",
                            },
                            {
                                id_perf: 2,
                                id_aroma: 3,
                                palabra: "Floral",
                            },
                            {
                                id_perf: 2,
                                id_aroma: 4,
                                palabra: "Almizcle",
                            },
                            {
                                id_perf: 2,
                                id_aroma: 5,
                                palabra: "Ambar",
                            },
                            {
                                id_perf: 2,
                                id_aroma: 6,
                                palabra: "Vainilla",
                            },
                            {
                                id_perf: 2,
                                id_aroma: 7,
                                palabra: "Frutas Maduras",
                            },
                            {
                                id_perf: 2,
                                id_aroma: 8,
                                palabra: "Musgo",
                            },
                            {
                                id_perf: 2,
                                id_aroma: 9,
                                palabra: "Musks ámbar",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 1,
                                palabra: "Madera",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 3,
                                palabra: "Floral",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 4,
                                palabra: "Almizcle",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 5,
                                palabra: "Ambar",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 6,
                                palabra: "Vainilla",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 7,
                                palabra: "Frutas Maduras",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 8,
                                palabra: "Musgo",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 9,
                                palabra: "Musks ámbar",
                            },
                            {
                                id_perf: 12,
                                id_aroma: 1,
                                palabra: "Madera",
                            },
                            {
                                id_perf: 12,
                                id_aroma: 3,
                                palabra: "Floral",
                            },
                            {
                                id_perf: 12,
                                id_aroma: 4,
                                palabra: "Almizcle",
                            },
                            {
                                id_perf: 12,
                                id_aroma: 5,
                                palabra: "Ambar",
                            },
                            {
                                id_perf: 12,
                                id_aroma: 6,
                                palabra: "Vainilla",
                            },
                            {
                                id_perf: 12,
                                id_aroma: 9,
                                palabra: "Musks ámbar",
                            },
                        ],
                    };

                    this.gestionarRespuesta(aroma_res);
                    break;

                case 5:
                    let pref_res = {
                        Preferencias: [
                            {
                                id_perf: 2,
                                id_intens: 2,
                                tipo: "edp",
                            },
                            {
                                id_perf: 3,
                                id_intens: 3,
                                tipo: "edp",
                            },
                            {
                                id_perf: 12,
                                id_intens: 12,
                                tipo: "edp",
                            },
                        ],
                    };

                    this.gestionarRespuesta(pref_res);
                    break;

                case 6:
                    let per_res = {
                        Personalidades: [
                            {
                                id_perf: 2,
                                id_aroma: 27,
                                palabra: "Juventud",
                            },
                            {
                                id_perf: 2,
                                id_aroma: 28,
                                palabra: "Frutas",
                            },
                            {
                                id_perf: 2,
                                id_aroma: 29,
                                palabra: "Especias",
                            },
                            {
                                id_perf: 2,
                                id_aroma: 30,
                                palabra: "Alegría",
                            },
                            {
                                id_perf: 2,
                                id_aroma: 31,
                                palabra: "Ganas de vivir",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 27,
                                palabra: "Juventud",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 28,
                                palabra: "Frutas",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 29,
                                palabra: "Especias",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 30,
                                palabra: "Alegría",
                            },
                            {
                                id_perf: 3,
                                id_aroma: 31,
                                palabra: "Ganas de vivir",
                            },
                            {
                                id_perf: 12,
                                id_aroma: 28,
                                palabra: "Frutas",
                            },
                            {
                                id_perf: 12,
                                id_aroma: 29,
                                palabra: "Especias",
                            },
                        ],
                    };

                    this.gestionarRespuesta(per_res);
                    break;

                default:
                    this.gestionarRespuesta();

                    break;
            }
            let aux_obj = Object.assign({}, this.objToSend);
            console.warn("OBJ TO SEND", aux_obj);

            fetch(urlApi, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: aux_obj,
            })
                .then((response) => {
                    return response.json();
                })
                .then((res) => {
                    console.warn("RESPUESTA", res);
                    this.gestionarRespuesta(res);
                });
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
        getObjIntensidad(int, is_pref) {
            if (!is_pref) {
                switch (int) {
                    case "edc":
                    case "eds":
                        return [
                            {
                                text: "Ligero",
                                value: "lf",
                            },
                            {
                                text: "Fresco",
                                value: "lf",
                            },
                        ];
                        break;

                    case "edt":
                        return [
                            {
                                text: "Intermedio",
                                value: "int",
                            },
                        ];
                        break;

                    case "edp":
                    case "p":
                        return [
                            {
                                text: "Intenso",
                                value: "hea",
                            },
                        ];
                        break;

                    default:
                        break;
                }
            } else {
                switch (int) {
                    case "eds":
                        return [
                            {
                                text: "Diario",
                                value: "d",
                            },
                        ];
                        break;

                    case "edp":
                    case "p":
                        return [
                            {
                                text: "Trabajo",
                                value: "t",
                            },
                        ];
                        break;

                    case "edc":
                    case "edt":
                        return [
                            {
                                text: "Ocaciones especiales",
                                value: "oe",
                            },
                        ];
                        break;

                    default:
                        break;
                }
            }
        },

        filtrarPerfumes(filtro) {
            let aux_perf = [];
            switch (this.pagina) {
                case 0:
                    //Dame perf segun el genero select y next opciones (edad)

                    this.perfumes.forEach((perf) => {
                        if (perf.genero == this.preguntas[this.pagina].respuesta[0].value) {
                            //Perfume va
                            this.addOpcionesPosible(perf, this.pagina + 1);
                            aux_perf.push(perf);
                        }
                    });

                    break;

                case 1:
                    //Dame Perf segun edad y next opciones (intensidad)
                    this.perfumes.forEach((perf) => {
                        if (perf.rango_edad == this.preguntas[this.pagina].respuesta[0].value) {
                            //Perfume va
                            this.addOpcionesPosible(perf, this.pagina + 1);
                            aux_perf.push(perf);
                        }
                    });
                    break;
                case 2: //Dame perf segun intensidad y next opciones (caracter)
                case 3: //Dame perfume segun caracteres y next opciones flia olf
                case 4: //Dame perf segun flia y next opciones  aroma
                case 5: //Dame perf segun aroma y netx opcion pref
                case 6: //Dame perf segun preferencia y netx opcion personalidad
                    this.perfumes.forEach((perf) => {
                        for (let j = 0; j < filtro.length; j++) {
                            if (perf.id == filtro[j].id_perf) {
                                //Perfume va
                                aux_perf.push(perf);
                                this.addOpcionesPosible(filtro[j], this.pagina + 1);
                            }
                        }
                    });
                    break;

                    break;
                default:
                    break;
            }

            this.perfumes = aux_perf;

            this.mode_loading = false;
            // this.ask_continuar = false;
            //this.pagina++;
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
                case 2:
                    //Add Opciones de intensidades disponibles
                    let inten = this.getObjIntensidad(perf.tipo_int, false);
                    if (this.canAdd(ipreg, inten[0].value)) {
                        inten.forEach((op) => {
                            this.preguntas[ipreg].opciones.push(op);
                        });
                    }
                    break;

                case 3: //Add Opciones de caracter
                case 4: //Add opciones de flia
                case 5: //add opciones aroma
                case 7: //Add opciones personalidad
                    if (
                        this.canAdd(
                            ipreg,
                            perf.id_car || perf.id_flia || perf.id_aroma || perf.id_intens
                        )
                    ) {
                        this.preguntas[ipreg].opciones.push({
                            text: perf.palabra || perf.nombre || perf.tipo,
                            value: perf.id_car || perf.id_flia || perf.id_aroma || perf.id_intens,
                        });
                    }
                    break;

                case 6: //Add opciones pref uso
                    let prefuso = this.getObjIntensidad(perf.tipo, true);
                    if (this.canAdd(ipreg, prefuso[0].value)) {
                        prefuso.forEach((op) => {
                            this.preguntas[ipreg].opciones.push(op);
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
    text-align: right;
}

.multi-opt {
    margin-top: 5px;
}
</style>
