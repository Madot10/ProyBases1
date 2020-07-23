"use strict";
const { RecomendadorModel } = require("../models/RecomendadorModel");

const rec = new RecomendadorModel();

class RecomendadorCont {
    
    getAllProd(req, res) {
        /*
        home.getAllProd()
            .then(function (prods) {
                res.status(200).json({ Productores: prods });
            })
            .catch((e) => console.error(e.stack));
    */
    }
}

module.exports = { RecomendadorCont };
