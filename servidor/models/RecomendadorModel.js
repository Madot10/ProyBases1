"use strict";
const { database } = require("../config/db.config");

class RecomendadorModel {

    //Para unir en un string todos los valores de un array se utiliza elements.join()

    getCaracter(genero,edad,intensidad) {
        return new Promise((resolve, reject) => {
            database
                .query(
                `SELECT perf.id AS id_perf, pal.id AS id_pal_clave, pal.palabra
                FROM vam_perfumes AS perf
                    INNER JOIN vam_perf_intensidades AS perf_int ON perf.id = perf_int.id_perfume
                    INNER JOIN vam_fo_principal AS princ ON princ.id_perf = perf.id
                    INNER JOIN vam_f_fn AS fn ON fn.id_flia_olf = princ.id_flia_olf
                    INNER JOIN vam_palabra_clave AS pal ON pal.id = fn.id_palabra_clave
                WHERE pal.tipo_palabra = 'c' AND perf.genero = $1 AND perf.rango_edad = $2 AND perf_int.tipo = $3`,
                [genero,edad,intensidad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getFliaOlf(genero,edad,intensidad,filtros) {
        return new Promise((resolve, reject) => {
            database
                .query(
                ``,
                [genero,edad,intensidad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getAroma(genero,edad,intensidad,filtros) {
        return new Promise((resolve, reject) => {
            database
                .query(
                ``,
                [genero,edad,intensidad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPreferencia(genero,edad,intensidad,filtros) {
        return new Promise((resolve, reject) => {
            database
                .query(
                ``,
                [genero,edad,intensidad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPersonalidad(genero,edad,intensidad,filtros,preferencia) {
        return new Promise((resolve, reject) => {
            database
                .query(
                ``,
                [genero,edad,intensidad,preferencia])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPerfFiltroCaracter(genero,edad,intensidad,filtros) {
        return new Promise((resolve, reject) => {
            database
                .query(
                `SELECT perf.id, perf.nombre, perf.genero, perf.rango_edad, perf.descrip_componentes, perf.tipo_estructura, perf.descrip_perf, perfum.id AS id_perfumista, perfum.nombre AS nom_perfumista, perfum.apellido, pais.nombre, perf_int.id AS id_perf_int, perf_int.tipo AS tipo_int, perf_int.porc_concentracion, perf_int.descripcion, pres.id AS id_pres, pres.volumen
                FROM vam_perfumes AS perf
                    INNER JOIN vam_perf_intensidades AS perf_int ON perf.id = perf_int.id_perfume
                    INNER JOIN vam_presentaciones AS pres on perf_int.id = pres.id_perf_intensidad and perf_int.id_perfume = pres.id_perf
                    INNER JOIN vam_p_p AS vpp on perf.id = vpp.id_perfume
                    INNER JOIN vam_pefumistas AS perfum on perfum.id = vpp.id_perfumista
                    INNER JOIN vam_paises AS pais ON pais.id = perfum.id_pais
                    INNER JOIN vam_fo_principal AS princ ON princ.id_perf = perf.id
                    INNER JOIN vam_f_fn AS fn ON fn.id_flia_olf = princ.id_flia_olf
                    INNER JOIN vam_palabra_clave AS pal ON pal.id = fn.id_palabra_clave
                WHERE perf.genero = 'u' AND perf.rango_edad = 'ate' AND perf_int.tipo = 'edp' AND pal.id IN (` + filtros.caracter.join() + `)`, 
                [genero,edad,intensidad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPerfFiltroFliaOlf(genero,edad,intensidad,filtros) {
        return new Promise((resolve, reject) => {
            database
                .query(
                ``,
                [genero,edad,intensidad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPerfFiltroAroma(genero,edad,intensidad,filtros) {
        return new Promise((resolve, reject) => {
            database
                .query(
                ``,
                [genero,edad,intensidad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPerfFiltroPreferencia(genero,edad,intensidad,filtros,preferencia) {
        return new Promise((resolve, reject) => {
            database
                .query(
                ``,
                [genero,edad,intensidad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPerfFiltroPersonalidad(genero,edad,intensidad,filtros,preferencia) {
        return new Promise((resolve, reject) => {
            database
                .query(
                ``,
                [genero,edad,intensidad,preferencia])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

}

module.exports = { RecomendadorModel };
