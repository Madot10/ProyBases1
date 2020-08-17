"use strict";
const { database } = require("../config/db.config");

class HomeModel {
    getAllProd() {
        return new Promise((resolve, reject) => {
            database
                .query("SELECT id,nombre FROM VAM_PRODUCTORES")
                .then(function(response) {
                    const prods = response.rows;
                    resolve(prods);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getAllProv() {
        return new Promise((resolve, reject) => {
            database
                .query("SELECT id,nombre FROM VAM_PROVEEDORES")
                .then(function(response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getProvs() {
        return new Promise((resolve, reject) => {
            database
                .query(
                    "SELECT prov.id AS id_prov, prov.nombre AS nombre_prov, prov.email, prov.telefono, prov.pag_web, pais.nombre AS nombre_pais, ing.cas, ing.nombre AS nombre_ing, ing.tipo AS tipo_ing, ing_pres.volumen, ing_pres.precio FROM vam_proveedores AS prov LEFT JOIN vam_ingrediente_esencias AS ing ON ing.id_proveedor = prov.id LEFT JOIN vam_ing_presentaciones AS ing_pres ON ing_pres.cas_ingrediente = ing.cas LEFT JOIN vam_paises AS pais ON pais.id = prov.id_pais WHERE (SELECT fecha_fin FROM vam_historico_ifra WHERE id_proveedor = prov.id) IS NULL"
                )
                .then(function(response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getProvsfe() {
        return new Promise((resolve, reject) => {
            database
                .query(
                    "SELECT prov.id AS id_prov, fe.id AS id_fe, fe.tipo AS tipo_fe, fe.cargo, pais.nombre AS destino FROM vam_proveedores AS prov, vam_forma_envios AS fe LEFT JOIN vam_paises AS pais ON pais.id = fe.id_pais WHERE fe.id_prov = prov.id AND (SELECT fecha_fin FROM vam_historico_ifra WHERE id_proveedor = prov.id) IS NULL"
                )
                .then(function(response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    getProvsfp() {
        return new Promise((resolve, reject) => {
            database
                .query(
                    "SELECT prov.id AS id_prov, fp.id AS id_fp, fp.tipo AS tipo_fp, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual FROM vam_proveedores AS prov LEFT JOIN vam_forma_pagos AS fp ON fp.id_proveedor = prov.id  WHERE (SELECT fecha_fin FROM vam_historico_ifra WHERE id_proveedor = prov.id) IS NULL"
                )
                .then(function(response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }
}

module.exports = { HomeModel };
