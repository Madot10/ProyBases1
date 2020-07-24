"use strict";
const { RecomendadorModel } = require("../models/RecomendadorModel");

const rec = new RecomendadorModel();

class RecomendadorCont {
    
    //Información para filtros

    getCaracter(req, res) {
        const { genero, edad, intensidad } = req.body; 
        rec.getCaracter(genero,edad,intensidad)
            .then(function (carac) {
                res.status(200).json({ Caracteres: carac });
            })
            .catch((e) => console.error(e.stack));
    }

    getFliaOlf(req, res) {
        const { genero, edad, intensidad, filtros } = req.body; 
        //filtros
        /*
		var filtros = {
			caracter: [1,2],
		}
		*/
        rec.getFliaOlf(genero,edad,intensidad,filtros)
            .then(function (flia) {
                res.status(200).json({ Familias_Olfativas: flia });
            })
            .catch((e) => console.error(e.stack));
    }

    getAroma(req, res) {
        const { genero, edad, intensidad, filtros } = req.body; 
        //filtros
        /*
		var filtros = {
			caracter: [7],
			flia_olf: [8,9],
		}
		*/
        rec.getAroma(genero,edad,intensidad,filtros)
            .then(function (aroma) {
                res.status(200).json({ Aromas: aroma });
            })
            .catch((e) => console.error(e.stack));
    }

    getPreferencia(req, res) {
        const { genero, edad, intensidad, filtros } = req.body; 
        //filtros
        /*
		var filtros = {
			caracter: [7],
			flia_olf: [8,9],
            aroma: [12,179],
		}
		*/
        rec.getPreferencia(genero,edad,intensidad,filtros)
            .then(function (pref) {
                res.status(200).json({ Preferencias: pref });
            })
            .catch((e) => console.error(e.stack));
    }

    getPersonalidad(req, res) {
        const { genero, edad, intensidad, filtros, preferencia } = req.body; 
        //filtros
        /*
		var filtros = {
			caracter: [7],
			flia_olf: [8,9],
			aroma: [12,179]
		}
		*/
        rec.getPreferencia(genero,edad,intensidad,filtros,preferencia)
            .then(function (pers) {
                res.status(200).json({ Personalidades: pers });
            })
            .catch((e) => console.error(e.stack));
    }

    //Filtros de Perfumes

    getPerfFiltroCaracter(req, res) {
        const { genero, edad, intensidad, filtros } = req.body;
        //filtros
        /*
		var filtros = {
			caracter: [1,2],
		}
		*/ 
        rec.getPerfFiltroCaracter(genero,edad,intensidad,filtros)
            .then(function (perfs) {
                res.status(200).json({ Perfumes: perfs });
            })
            .catch((e) => console.error(e.stack));
    }

    getPerfFiltroFliaOlf(req, res) {
        const { genero, edad, intensidad, filtros } = req.body; 
        //filtros
        /*
		var filtros = {
            caracter: [1,2],
            flia_olf: [8,9]
		}
		*/
        rec.getPerfFiltroFliaOlf(genero,edad,intensidad,filtros)
            .then(function (flia) {
                res.status(200).json({ Familias_Olfativas: flia });
            })
            .catch((e) => console.error(e.stack));
    }

    getPerfFiltroAroma(req, res) {
        const { genero, edad, intensidad, filtros } = req.body; 
        //filtros
        /*
		var filtros = {
			caracter: [7],
            flia_olf: [8,9],
            aroma: [12,179]
		}
		*/
        rec.getPerfFiltroAroma(genero,edad,intensidad,filtros)
            .then(function (aroma) {
                res.status(200).json({ Aromas: aroma });
            })
            .catch((e) => console.error(e.stack));
    }

    getPerfFiltroPreferencia(req, res) {
        const { genero, edad, intensidad, filtros, preferencia } = req.body; 
        //filtros
        /*
		var filtros = {
			caracter: [7],
			flia_olf: [8,9],
            aroma: [12,179],
		}
		*/
        rec.getPerfFiltroPreferencia(genero,edad,intensidad,filtros)
            .then(function (pref) {
                res.status(200).json({ Preferencias: pref });
            })
            .catch((e) => console.error(e.stack));
    }

    getPerfFiltroPersonalidad(req, res) {
        const { genero, edad, intensidad, filtros, preferencia } = req.body; 
        //filtros
        /*
		var filtros = {
			caracter: [7],
			flia_olf: [8,9],
			aroma: [12,179]
		}
		*/
        rec.getPerfFiltroPreferencia(genero,edad,intensidad,filtros,preferencia)
            .then(function (pers) {
                res.status(200).json({ Personalidades: pers });
            })
            .catch((e) => console.error(e.stack));
    }

}

module.exports = { RecomendadorCont };
