"use strict";
const { database } = require("../config/db.config");

class RecomendadorModel {

    getCaracter(genero,edad,intensidad) {

        var myquery = `SELECT perf.id AS id_perf, palabra.id AS id_car, palabra.palabra
        FROM vam_perfumes AS perf
            INNER JOIN vam_perf_intensidades AS intp ON perf.id = intp.id_perfume
            INNER JOIN vam_fo_principal AS fliap ON perf.id = fliap.id_perf
            INNER JOIN vam_f_fn AS ffn ON fliap.id_flia_olf = ffn.id_flia_olf
            INNER JOIN vam_palabra_clave AS palabra ON palabra.id = ffn.id_palabra_clave AND palabra.tipo_palabra = 'c'
        WHERE perf.genero = $1 AND perf.rango_edad = $2 AND (intp.tipo = ` + intensidad + `)`

        return new Promise((resolve, reject) => {
            database
                .query(myquery, [genero,edad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getFliaOlf(genero,edad,intensidad,caracter) {

        var myquery = `SELECT DISTINCT perf.id AS id_perf, flia.id AS id_flia, flia.nombre
        FROM vam_perfumes AS perf
            INNER JOIN vam_perf_intensidades AS intp ON perf.id = intp.id_perfume
            INNER JOIN vam_fo_principal AS fliap ON perf.id = fliap.id_perf
            INNER JOIN vam_flia_olfat AS flia ON fliap.id_flia_olf = flia.id
            INNER JOIN vam_f_fn AS ffn ON fliap.id_flia_olf = ffn.id_flia_olf
            INNER JOIN vam_palabra_clave AS palabra ON palabra.id = ffn.id_palabra_clave AND palabra.tipo_palabra = 'c'
        WHERE  perf.genero = $1 AND perf.rango_edad = $2 AND (intp.tipo = ` + intensidad + `) AND (palabra.id = ` + caracter + `)`
        
        return new Promise((resolve, reject) => {
            database
                .query(myquery, [genero,edad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getAroma(genero,edad,intensidad,caracter,flia_olf) {

        var myquery = `SELECT DISTINCT perf.id AS id_perf, palabra.id AS id_aroma, palabra.palabra
        FROM vam_perfumes AS perf
            INNER JOIN vam_fo_principal AS fliap ON perf.id = fliap.id_perf
            INNER JOIN vam_f_fn AS ffn ON fliap.id_flia_olf = ffn.id_flia_olf
            INNER JOIN vam_palabra_clave AS palabra ON palabra.id = ffn.id_palabra_clave AND palabra.tipo_palabra = 'n'
        WHERE perf.id IN
        (SELECT perf.id FROM vam_perfumes AS perf
            INNER JOIN vam_perf_intensidades AS intp ON perf.id = intp.id_perfume
            INNER JOIN vam_fo_principal AS fliap ON perf.id = fliap.id_perf
            INNER JOIN vam_flia_olfat AS flia ON fliap.id_flia_olf = flia.id
            INNER JOIN vam_f_fn AS ffn ON fliap.id_flia_olf = ffn.id_flia_olf
            INNER JOIN vam_palabra_clave AS palabra ON palabra.id = ffn.id_palabra_clave AND palabra.tipo_palabra = 'c'
            WHERE perf.genero = $1 AND perf.rango_edad = $2 AND (intp.tipo = ` + intensidad + `) AND (palabra.id = ` + caracter + `) AND (flia.id = ` + flia_olf + `))`

        return new Promise((resolve, reject) => {
            database
                .query(myquery, [genero,edad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPreferencia(genero,edad,intensidad,caracter,flia_olf,aroma) {

        var myquery = `SELECT DISTINCT perf.id AS id_perf, intp.id AS id_intens, intp.tipo
        FROM vam_perfumes AS perf
            INNER JOIN vam_perf_intensidades AS intp ON perf.id = intp.id
            INNER JOIN vam_fo_principal AS fliap ON perf.id = fliap.id_perf
            INNER JOIN vam_f_fn AS ffn ON fliap.id_flia_olf = ffn.id_flia_olf
            INNER JOIN vam_palabra_clave AS palabra ON palabra.id = ffn.id_palabra_clave AND palabra.tipo_palabra = 'n'
        WHERE (palabra.id = ` + aroma + `)
        AND perf.id IN (SELECT DISTINCT perf.id FROM vam_perfumes AS perf
            INNER JOIN vam_perf_intensidades AS intp ON perf.id = intp.id_perfume
            INNER JOIN vam_fo_principal AS fliap ON perf.id = fliap.id_perf
            INNER JOIN vam_flia_olfat AS flia ON fliap.id_flia_olf = flia.id
            INNER JOIN vam_f_fn AS ffn ON fliap.id_flia_olf = ffn.id_flia_olf
            INNER JOIN vam_palabra_clave AS palabra ON palabra.id = ffn.id_palabra_clave AND palabra.tipo_palabra = 'c'
            WHERE perf.genero = $1 AND perf.rango_edad = $2 AND (intp.tipo = ` + intensidad + `) AND (palabra.id = ` + caracter + `) AND (flia.id = ` + flia_olf + `))`

        return new Promise((resolve, reject) => {
            database
                .query(myquery, [genero,edad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPersonalidad(genero,edad,intensidad,caracter,flia_olf,aroma,preferencia) {
        var myquery = `SELECT DISTINCT perf.id AS id_perf, palabra.id AS id_aroma, palabra.palabra
        FROM vam_perfumes AS perf
            INNER JOIN vam_fo_principal AS fliap ON perf.id = fliap.id_perf
            INNER JOIN vam_f_fn AS ffn ON fliap.id_flia_olf = ffn.id_flia_olf
            INNER JOIN vam_palabra_clave AS palabra ON palabra.id = ffn.id_palabra_clave AND palabra.tipo_palabra = 'p'
        WHERE perf.id IN (SELECT DISTINCT perf.id
            FROM vam_perfumes AS perf
                INNER JOIN vam_perf_intensidades AS intp ON perf.id = intp.id
                INNER JOIN vam_fo_principal AS fliap ON perf.id = fliap.id_perf
                INNER JOIN vam_f_fn AS ffn ON fliap.id_flia_olf = ffn.id_flia_olf
                INNER JOIN vam_palabra_clave AS palabra ON palabra.id = ffn.id_palabra_clave AND palabra.tipo_palabra = 'n'
        WHERE (palabra.id = ` + aroma + `) AND (intp.tipo = ` + preferencia + `)
          AND perf.id IN (SELECT DISTINCT perf.id FROM vam_perfumes AS perf
                INNER JOIN vam_perf_intensidades AS intp ON perf.id = intp.id
                INNER JOIN vam_fo_principal AS fliap ON perf.id = fliap.id_perf
                INNER JOIN vam_flia_olfat AS flia ON fliap.id_flia_olf = flia.id
                INNER JOIN vam_f_fn AS ffn ON fliap.id_flia_olf = ffn.id_flia_olf
                INNER JOIN vam_palabra_clave AS palabra ON palabra.id = ffn.id_palabra_clave AND palabra.tipo_palabra = 'c'
                WHERE perf.genero = $1 AND perf.rango_edad = $2 AND (intp.tipo = ` + intensidad + `) AND (palabra.id = ` + caracter + `) AND (flia.id = ` + flia_olf + `)))`

        return new Promise((resolve, reject) => {
            database
                .query(myquery, [genero,edad])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getPerfumes(genero) {
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
                WHERE perf.genero = $1`, 
                [genero])
                .then(function (response) {
                    const perfs = response.rows;
                    resolve(perfs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

}

module.exports = { RecomendadorModel };
