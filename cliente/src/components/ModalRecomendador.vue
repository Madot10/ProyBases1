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
            <!-- BIENVENIDA -->
            <div class="bienvenida" v-show="!mode_recon">
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
                v-show="i == pagina && mode_recon && !ask_continuar"
            >
                <h4>{{ p.pregunta }}</h4>
                <br />
                <div class="opciones" v-if="!p.multi">
                    <b-button
                        variant="info"
                        v-for="(op, j) in p.opciones"
                        :key="j"
                        @click="opcionSelected"
                    >
                        {{ op.text }}
                    </b-button>
                </div>
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
                    <br />
                    <div class="text-right">
                        <b-button variant="outline-info" size="sm"
                            >Siguiente <b-icon icon="caret-right"></b-icon
                        ></b-button>
                    </div>
                </div>
            </div>

            <!-- DESEA CONTINUAR? -->
            <div class="desea-continuar" v-show="ask_continuar">
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
            ask_continuar: false,
            preguntas: [
                {
                    pregunta: "Cuéntanos, ¿Para quién es el perfume?",
                    respuesta: [],
                    multi: false,
                    opciones: [
                        { text: "Un hombre", value: 1 },
                        { text: "Una mujer", value: 2 },
                        { text: "Unisex", value: 3 },
                    ],
                },
                {
                    pregunta: "¿Para quién es el perfume?",
                    respuesta: [],
                    multi: true,
                    opciones: [
                        { text: "Niño", value: 1 },
                        { text: "Joven", value: 2 },
                        { text: "Adulto", value: 3 },
                        { text: "Anciano", value: 4 },
                    ],
                },
            ],
            respuestas: [],
        };
    },
    methods: {
        opcionSelected() {
            this.ask_continuar = true;
        },
        opcionContinuarSelected(opt) {
            if (opt) {
                this.ask_continuar = false;
                this.pagina++;
            } else {
                //Mostrar resultados
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
</style>
