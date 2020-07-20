'use strict';
const { EvalProdModel } = require('../models/EvalProdModel');

const evaluacion = new EvalProdModel();

class EvalProdCont {

  guardarResultadoEval(req, res) {
    const { resultado, tipoeval } = req.body;
    const id_prov = req.params.id_prov;
    const id_prod = req.params.id_prod;
  
    evaluacion.guardarResultadoEval(id_prod, id_prov, resultado, tipoeval)
        .then(res.status(200).json({ message: "Resultado de la evaluación registrada con éxito" }))
        .catch((e) => {
            console.error(e.stack);
            res.status(500);
        });
  }


}

module.exports = { EvalProdCont };
