'use strict';
const { EvalProdModel } = require('../models/EvalProdModel');

const evaluacion = new EvalProdModel();

class EvalProdCont {

  //Guardar puntaje obtenido según tipo de evaluación
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

  //Crear variable
  createVariable(req, res) {
    const { nombre_crit, descripcion } = req.body;
  
    evaluacion.createVariable(nombre_crit, descripcion)
        .then(res.status(200).json({ message: "Variable creada con éxito" }))
        .catch((e) => {
            console.error(e.stack);
            res.status(500);
        });
  }

  //Información de evaluación de criterios (inicial)
	getEscalas(req, res) {
		const id_prod = req.params.id_prod;

		evaluacion.getEscalas(id_prod)
				.then(function (escalas) {
						res.status(200).json({ Info_de_Evaluacion_inicial: escalas });
				})
				.catch((e) => console.error(e.stack));
	}

  //Crear escala
  createEscala(req, res) {
    const { valor_min, valor_max } = req.body;
    const id_prod = req.params.id_prod;
  
    evaluacion.createEscala(id_prod, valor_min, valor_max)
        .then(res.status(200).json({ message: "Escala creada con éxito" }))
        .catch((e) => {
            console.error(e.stack);
            res.status(500);
        });
  }

  //Vencer escala
  updateEscala(req, res) {
    const id_prod = req.params.id_prod;
  
    evaluacion.updateEscala(id_prod)
        .then(res.status(200).json({ message: "Escala vencida con éxito" }))
        .catch((e) => {
            console.error(e.stack);
            res.status(500);
        });
  }

  //Crear evaluación de criterios y vencer otras
  createEvalCriterios(req, res) {
    const { tipo_formula,formula } = req.body;
    const id_prod = req.params.id_prod;

    //Ejemplo
    /*
		var formula = {
			id_var_crit: [1,2,3,4,5],
			pesos: [10,20,30,40,50]
		}
    */
    evaluacion.createEvalCriterios(id_prod, tipo_formula, formula)
        .then(res.status(200).json({ message: "Evaluación de criterios creada con éxito" }))
        .catch((e) => {
            console.error(e.stack);
            res.status(500);
        });
  }

  //Información de evaluación de criterios (inicial)
	getEvalCritInicial(req, res) {
		const id_prod = req.params.id_prod;

		evaluacion.getEvalCritInicial(id_prod)
				.then(function (evalua) {
						res.status(200).json({ Info_de_Evaluacion_inicial: evalua });
				})
				.catch((e) => console.error(e.stack));
	}

  //Información de evaluación de criterios (inicial)
	getEvalCritRenov(req, res) {
		const id_prod = req.params.id_prod;

		evaluacion.getEvalCritRenov(id_prod)
				.then(function (evalua) {
						res.status(200).json({ Info_de_Evaluacion_renovacion: evalua });
				})
				.catch((e) => console.error(e.stack));
	}

}

module.exports = { EvalProdCont };
