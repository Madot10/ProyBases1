'use strict';
const { database } = require('../config/db.config');

//Se ingresan los criterios de la nueva fórmula
function createFormula(id_prod, tipo_formula, formula) {
    return new Promise((resolve, reject) => {
        for (var i = 0; formula.pesos[i] != null; i++) {
            database
                .query(
                    `INSERT INTO vam_eval_criterios(fecha_inicio,id_prod,id_var_crit,peso,tipo_formula) VALUES (current_date,$1,$2,$3,$4)`,
                    [id_prod,formula.id_var_crit[i],formula.pesos[i],tipo_formula]
                )
                .then(function () {
                    resolve(true);
                })
                .catch((e) => console.error(e.stack));
        }
    });
}

class EvalProdModel{

  //31
  guardarResultadoEval(id_prod, id_prov, resultado, tipoeval) {
    return new Promise((resolve, reject) => {
       
      database
        .query(
            `INSERT INTO vam_result_eval(fecha,id_prod,id_prov,resultado,tipo_eval) VALUES (current_date,$1,$2,$3,$4)`,
            [id_prod,id_prov,resultado,tipoeval]
        )
        .then(function () {
          resolve(true);
        })
        .catch((e) => console.error(e.stack));
    });
  }
  
  //30.3
  getEscalas(id_prod) {
    return new Promise((resolve, reject) => {
        database
            .query(
                `SELECT fecha_inicio, valor_min, valor_max
                FROM vam_escalas
                WHERE id_prod = $1 AND fecha_fin IS NULL`,
                [id_prod]
              )
              .then(function (response) {
                  const prods = response.rows;
                  resolve(prods);
              })
              .catch((e) => console.error(e.stack));
      });
  }

  createEscala(id_prod, valor_min, valor_max) {
    return new Promise((resolve, reject) => {
       
      database
        .query(
            `INSERT INTO vam_escalas(fecha_inicio,id_prod,valor_min,valor_max) VALUES (current_date,$1,$2,$3)`,
            [id_prod,valor_min,valor_max]
        )
        .then(function () {
          resolve(true);
        })
        .catch((e) => console.error(e.stack));
    });
  }

  createVariable(nombre_crit, descripcion) {
    return new Promise((resolve, reject) => {
       
      database
        .query(
            `INSERT INTO vam_var_criterios(nombre_crit, descripcion) VALUES ($1,$2)`,
            [nombre_crit,descripcion]
        )
        .then(function () {
          resolve(true);
        })
        .catch((e) => console.error(e.stack));
    });
  }

  updateEscala(id_prod) {
    return new Promise((resolve, reject) => {
       
      database
        .query(
            `UPDATE vam_escalas SET fecha_fin = current_date WHERE id_prod = $1 AND fecha_fin IS NULL`,
            [id_prod]
        )
        .then(function () {
          resolve(true);
        })
        .catch((e) => console.error(e.stack));
    });
  }

  //29
  //Se vencen las fórmulas vigentes actualmente para luego crear las otras
  createEvalCriterios(id_prod, tipo_formula, formula) {
    return new Promise((resolve, reject) => {
       
      database
        .query(
            `UPDATE vam_eval_criterios SET fecha_fin = current_date WHERE id_prod = $1 AND tipo_formula = $2 AND fecha_fin IS NULL`,
            [id_prod,tipo_formula]
        )
        .then(() => {
            createFormula(id_prod, tipo_formula, formula)
        })
        .catch((e) => console.error(e.stack));
    });
  }

  //30.1
  getEvalCritInicial(id_prod) {
    return new Promise((resolve, reject) => {
        database
            .query(
                `SELECT eval.fecha_inicio, var.nombre_crit, var.descripcion, eval.peso
                FROM vam_eval_criterios AS eval
                  INNER JOIN vam_var_criterios AS var ON var.id = eval.id_var_crit
                WHERE eval.id_prod = $1 AND eval.tipo_formula = 'i' AND eval.fecha_fin IS NULL`,
                [id_prod]
            )
            .then(function (response) {
                const prods = response.rows;
                resolve(prods);
            })
            .catch((e) => console.error(e.stack));
    });
  }
  
  //30.2
  getEvalCritRenovPedidos(id_prod,id_prov,id_contrato) {
    return new Promise((resolve, reject) => {
        database
            .query(
                `SELECT count(ped)
                FROM vam_contratos AS cont, vam_pedidos AS ped
                WHERE cont.id = $1 AND ped.id_prod = $2 AND ped.id_prov = $3 AND ped.f_emision BETWEEN cont.fecha_emision AND current_date`,
                [id_contrato,id_prod,id_prov]
            )
            .then(function (response) {
                const ped = response.rows;
                resolve(ped);
            })
            .catch((e) => console.error(e.stack));
    });
  }

  //30.2
  getEvalCritRenovPedidosAprobados(id_prod,id_prov,id_contrato) {
    return new Promise((resolve, reject) => {
        database
            .query(
                `SELECT count(ped)
                FROM vam_contratos AS cont, vam_pedidos AS ped
                WHERE ped.estado = 'a' AND cont.id = $1 AND ped.id_prod = $2 AND ped.id_prov = $3 AND ped.f_emision BETWEEN cont.fecha_emision AND current_date`,
                [id_contrato,id_prod,id_prov]
            )
            .then(function (response) {
                const ped = response.rows;
                resolve(ped);
            })
            .catch((e) => console.error(e.stack));
    });
  }

}

module.exports = { EvalProdModel };
