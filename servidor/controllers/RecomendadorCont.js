"use strict";
const { RecomendadorModel } = require("../models/RecomendadorModel");

const rec = new RecomendadorModel();

class RecomendadorCont {
    //Información para filtros

    getCaracter(req, res) {
        const { genero, edad, filtros } = req.body;
        //filtros
        /*
        var filtros = {
			intensidad: [`'edp'`,`'p'`]
        }
        */

        const intensidad = filtros.intensidad.join(` OR intp.tipo = `);

        rec.getCaracter(genero, edad, intensidad)
            .then(function (carac) {
                res.status(200).json({ Caracteres: carac });
            })
            .catch((e) => console.error(e.stack));
    }

    getFliaOlf(req, res) {
        const { genero, edad, filtros } = req.body;

        //filtros
        /*
        var filtros = {
            intensidad: [`'edp'`],
            caracter: [55,57,44]
        }
        */

        const intensidad = filtros.intensidad.join(` OR intp.tipo = `);
        const caracter = filtros.caracter.join(` OR palabra.id = `);

        rec.getFliaOlf(genero, edad, intensidad, caracter)
            .then(function (flia) {
                res.status(200).json({ Familias_Olfativas: flia });
            })
            .catch((e) => console.error(e.stack));
    }

    getAroma(req, res) {
        const { genero, edad, filtros } = req.body;

        //filtros
        /*
        var filtros = {
            intensidad: [`'edp'`],
            caracter: [55,57,44],
            flia_olf: [3,9]
        }
        */
        const intensidad = filtros.intensidad.join(` OR intp.tipo = `);
        const caracter = filtros.caracter.join(` OR palabra.id = `);
        const flia_olf = filtros.flia_olf.join(` OR flia.id = `);

        rec.getAroma(genero, edad, intensidad, caracter, flia_olf)
            .then(function (aroma) {
                res.status(200).json({ Aromas: aroma });
            })
            .catch((e) => console.error(e.stack));
    }

    getPreferencia(req, res) {
        const { genero, edad, filtros } = req.body;

        //filtros
        /*
        var filtros = {
            intensidad: [`'edp'`],
            caracter: [55,57,44],
            flia_olf: [3,9],
            aroma: [5,6,18]
        }
        */
        const intensidad = filtros.intensidad.join(` OR intp.tipo = `);
        const caracter = filtros.caracter.join(` OR palabra.id = `);
        const flia_olf = filtros.flia_olf.join(` OR flia.id = `);
        const aroma = filtros.aroma.join(` OR palabra.id = `);

        rec.getPreferencia(genero, edad, intensidad, caracter, flia_olf, aroma)
            .then(function (pref) {
                res.status(200).json({ Preferencias: pref });
            })
            .catch((e) => console.error(e.stack));
    }

    getPersonalidad(req, res) {
        const { genero, edad, filtros } = req.body;

        //filtros
        /*
        var filtros = {
            intensidad: [`'edp'`],
            caracter: [55,57,44],
            flia_olf: [3,9],
            aroma: [5,6,18],
            preferencia: [`'edp'`],
        }
        */
        const intensidad = filtros.intensidad.join(` OR intp.tipo = `);
        const caracter = filtros.caracter.join(` OR palabra.id = `);
        const flia_olf = filtros.flia_olf.join(` OR flia.id = `);
        const aroma = filtros.aroma.join(` OR palabra.id = `);
        const preferencia = filtros.preferencia.join(` OR intp.tipo = `);

        rec.getPersonalidad(genero, edad, intensidad, caracter, flia_olf, aroma, preferencia)
            .then(function (pers) {
                res.status(200).json({ Personalidades: pers });
            })
            .catch((e) => console.error(e.stack));
    }

    //Filtros de Perfumes

    getPerfumes(req, res) {
        const { genero } = req.body;

        rec.getPerfumes(genero)
            .then(function (perfs) {
                res.status(200).json({ Perfumes: perfs });
            })
            .catch((e) => console.error(e.stack));
    }

    getEsenciasPerfumes(req, res) {
        const id_perf = req.params.id_perf;

        rec.getEsenciasPerfumes(id_perf)
            .then(function (perfs) {
                res.status(200).json({ Perfumes: perfs });
            })
            .catch((e) => console.error(e.stack));
    }
}

module.exports = { RecomendadorCont };
