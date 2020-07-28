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
                <h6>{{ p.headline }}</h6>
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
                    //0
                    headline: "",
                    pregunta: "Cuéntanos, ¿Para quién es el perfume?",
                    respuesta: [null],
                    multi: false,
                    opciones: [
                        { text: "Un hombre", value: "m" },
                        { text: "Una mujer", value: "f" },
                        { text: "Unisex", value: "u" },
                    ],
                },
                {
                    //1
                    headline: "Sabemos que la edad es sinónimo de experiencia",
                    pregunta: "¿Crees identificar cuál es tu rango de experiencia?",
                    respuesta: [null],
                    multi: false,
                    opciones: [],
                },
                {
                    //2
                    headline: "",
                    pregunta: "¿Con cuál clase de esencia te podemos ayudar?",
                    respuesta: [null],
                    multi: false,
                    opciones: [],
                },
                {
                    //3
                    headline: "Creemos que el carácter marca a todo el que nos conozca",
                    pregunta: "¿De qué forma marcas a quien te conoce?",
                    respuesta: [null],
                    multi: true,
                    opciones: [],
                },
                {
                    headline: "",
                    pregunta: "¿Qué clasificación te gustaría que fuera el perfume?",
                    respuesta: [null],
                    multi: true,
                    opciones: [],
                },
                {
                    headline: "",
                    pregunta: "¿Cuál es el aroma que te gustaría que perdurara más?",
                    respuesta: [null],
                    multi: true,
                    opciones: [],
                },
                {
                    headline: "",
                    pregunta: "¿Cuál es la ocasión ideal para el perfume que buscas?",
                    respuesta: [null],
                    multi: false,
                    opciones: [],
                },
                {
                    headline: "",
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
                case 1:
                    this.objToSend.edad = this.preguntas[this.pagina].respuesta[0].value;
                    break;

                case 2:
                    //this.objToSend.filtros.intensidad = this.preguntas[this.pagina].respuesta[2].value;
                    let resp = this.getRealValueIntensidad(
                        this.preguntas[this.pagina].respuesta[0].value
                    );

                    resp.forEach((op) => {
                        this.objToSend.filtros.intensidad.push(`'${op.value}'`);
                    });
                    break;

                case 3:
                    for (let i = 1; i < this.preguntas[this.pagina].respuesta.length; i++) {
                        this.objToSend.filtros.caracter.push(
                            Number(this.preguntas[this.pagina].respuesta[i])
                        );
                    }
                    break;

                case 4:
                    for (let i = 1; i < this.preguntas[this.pagina].respuesta.length; i++) {
                        this.objToSend.filtros.flia_olf.push(
                            Number(this.preguntas[this.pagina].respuesta[i])
                        );
                    }
                    break;

                case 5:
                    for (let i = 1; i < this.preguntas[this.pagina].respuesta.length; i++) {
                        this.objToSend.filtros.aroma.push(
                            Number(this.preguntas[this.pagina].respuesta[i])
                        );
                    }
                    break;

                case 6:
                    let resp_x = this.getRealValueIntensidad(
                        this.preguntas[this.pagina].respuesta[0].value,
                        true
                    );

                    resp_x.forEach((op) => {
                        this.objToSend.filtros.preferencia.push(`'${op.value}'`);
                    });
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

            console.log(this.pagina);

            switch (this.pagina) {
                case 0:
                    //Dame perf segun el genero select y next opciones (edad)
                    urlApi += "perfumes";
                    //this.gestionarRespuesta(res);

                    break;

                case 2:
                    //Dame perf segun intensidad y next opciones (caracter)
                    urlApi += "caracter";
                    //this.gestionarRespuesta(caract_res);
                    break;

                case 3:
                    //Dame perfume segun caracteres y next opciones flia olf
                    urlApi += "fliaolf";

                    //this.gestionarRespuesta(flia_res);
                    break;

                case 4:
                    //Dame perf segun flia y next opciones  aroma
                    urlApi += "aroma";

                    //this.gestionarRespuesta(aroma_res);
                    break;

                case 5:
                    //Dame perf segun aroma y netx opcion pref
                    urlApi += "preferencia";

                    //this.gestionarRespuesta(pref_res);
                    break;

                case 6:
                    //Dame perf segun preferencia y netx opcion personalidad
                    urlApi += "personalidad";

                    //this.gestionarRespuesta(per_res);
                    break;

                default:
                    this.gestionarRespuesta();
                    return;
                    break;
            }
            console.warn("OBJ TO SEND", this.objToSend);

            fetch(urlApi, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(this.objToSend),
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
        getObjIntensidad(int, is_pref = false) {
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
        getRealValueIntensidad(int, is_pref = false) {
            if (!is_pref) {
                switch (int) {
                    case "lf":
                    case "lf":
                        return [
                            {
                                value: "edc",
                                //edc
                            },
                            {
                                value: "eds",
                                //eds
                            },
                        ];
                        break;

                    case "int":
                        return [
                            {
                                value: "edt",
                                //edt
                            },
                        ];
                        break;

                    case "hea":
                        return [
                            {
                                value: "edp",
                                //edp
                            },
                            {
                                value: "edp",
                                //edp
                            },
                        ];
                        break;

                    default:
                        break;
                }
            } else {
                switch (int) {
                    case "d":
                        return [
                            {
                                value: "eds",
                                //eds
                            },
                        ];
                        break;

                    case "y":
                        return [
                            {
                                value: "edp",
                                //edp
                            },
                            {
                                value: "p",
                                //p
                            },
                        ];
                        break;

                    case "oe":
                        return [
                            {
                                value: "edc",
                                //edc
                            },
                            {
                                value: "edt",
                                //edt
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
                case 7: //Dame perf segun personalidad
                    this.perfumes.forEach((perf) => {
                        for (let j = 0; j < filtro.length; j++) {
                            if (perf.id == filtro[j].id_perf) {
                                //Perfume va
                                aux_perf.push(perf);
                                if (this.pagina != 7)
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
