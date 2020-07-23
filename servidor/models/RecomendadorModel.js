"use strict";
const { database } = require("../config/db.config");

class RecomendadorModel {
/*
    getAllProd() {
        return new Promise((resolve, reject) => {
            database
                .query("SELECT id,nombre FROM VAM_PRODUCTORES")
                .then(function (response) {
                    const prods = response.rows;
                    resolve(prods);
                })
                .catch((e) => console.error(e.stack));
        });
    }
*/
}

module.exports = { RecomendadorModel };
