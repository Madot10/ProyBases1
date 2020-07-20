'use strict';
const { database } = require('../config/db.config');

class EvalProdModel{

  //REVISAAAAAAR

  //30.1
  guardarResultadoEval(id_prod, id_prov, resultado, tipoeval) {
    return new Promise((resolve, reject) => {
       
      database
        .query(
            `INSERT INTO vam_result_eval(fecha,id_prod,id_prov,resultado,tipoeval) VALUES (current_date,$1,$2,$3,$4)`,
            [id_prod,id_prov,resultado,tipoeval]
        )
        .then(function () {
          resolve(true);
        })
        .catch((e) => console.error(e.stack));
    });
  }

}

module.exports = { EvalProdModel };
