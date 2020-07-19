"use strict";
const { database } = require("../config/db.config");

//10.3 se ingresan datos en la entidad intersección entre fe_fp_c sobre formas de envío
function createInsertFe(id_cont, id_prod, id_prov, cont) {
    return new Promise((resolve, reject) => {
        for (var i = 0; cont.id_fe[i] != null; i++) {
            console.log("Forma de envío ingresado:", i + 1);
            database
                .query(
                    `INSERT INTO vam_fe_fp_c(id_contrato,id_prov_cont,id_prod_cont,id_form_envio,id_prov_fe,id_form_envio_pais) VALUES ($1,$2,$3,$4,$2,$5)`,
                    [id_cont, id_prov, id_prod, cont.id_fe[i], cont.id_pais[i]]
                )
                .then(function () {
                    resolve(true);
                })
                .catch((e) => console.error(e.stack));
        }
    });
}

//10.2 se ingresan datos en la entidad intersección entre fe_fp_c sobre formas de pago
function createInsertFp(id_cont, id_prod, id_prov, cont) {
    return new Promise((resolve, reject) => {
        for (var i = 0; cont.id_fp[i] != null; i++) {
            console.log("Forma de pago insertado:", i + 1);
            database
                .query(
                    `INSERT INTO vam_fe_fp_c(id_contrato,id_prov_cont,id_prod_cont,id_form_pago,id_prov_fp) VALUES ($1,$2,$3,$4,$2)`,
                    [id_cont, id_prov, id_prod, cont.id_fp[i]]
                )
                .catch((e) => console.error(e.stack));
        }
        createInsertFe(id_cont, id_prod, id_prov, cont);
    });
}

//10.1 se ingresan datos en la entidad intersección entre ingredientes y contrato
function createInsertMp_c(id_cont, id_prod, id_prov, cont) {
    return new Promise((resolve, reject) => {
        for (var i = 0; cont.cas[i] != null; i++) {
            console.log("Ingrediente ingresado:", i + 1);
            database
                .query(
                    `INSERT INTO vam_mp_c(id_contrato,id_cont_prov,id_cont_prod,cas,id_prov_ing) VALUES ($1,$2,$3,$4,$2)`,
                    [id_cont, id_prov, id_prod, cont.cas[i]]
                )
                .catch((e) => console.error(e.stack));
        }
        createInsertFp(id_cont, id_prod, id_prov, cont);
    });
}

class ContratoProdModel {
    //4.1
    getContratos(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT c.id, c.id_prov AS provid, prov.nombre AS provnombre, c.fecha_emision, c.exclusividad, c.clausula, c.fecha_cancelacion, c.motivo_cancel, c.quien_cancela, cond.id_form_envio, p.nombre, fe.tipo AS fe_tipo, fe.cargo, cond.id_form_pago, fp.tipo AS fp_tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago
                    FROM vam_contratos AS c, vam_fe_fp_c AS cond
                        LEFT JOIN  vam_proveedores AS prov ON prov.id = cond.id_prov_cont
                      LEFT JOIN vam_forma_envios AS fe ON  fe.id = cond.id_form_envio
                      LEFT JOIN vam_paises AS p ON p.id = fe.id_pais
                      LEFT JOIN vam_forma_pagos AS fp ON  fp.id = cond.id_form_pago
                    WHERE c.id_prod = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')`,
                    [id_prod]
                )
                .then(function (response) {
                    const prods = response.rows;
                    resolve(prods);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //4.2
    getIngCont(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT c.id, ing.cas, ing.nombre, ing.tipo, ing.descripcion, ing.taxonomia, ing_pres.volumen, ing_pres.precio FROM vam_contratos AS c, vam_mp_c AS cond LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = cond.cas LEFT JOIN vam_ing_presentaciones AS ing_pres ON ing_pres.cas_ingrediente = cond.cas WHERE c.id_prod = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')`,
                    [id_prod]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //12
    getContVencer(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT  c.id, c.id_prov AS provid, prov.nombre AS provnombre, c.fecha_emision, age(c.fecha_emision) AS tiempo_restante, c.exclusividad, c.clausula, cond.id_form_envio, fe.id_pais, fe.tipo, fe.cargo, cond.id_form_pago, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago FROM vam_contratos AS c, vam_fe_fp_c AS cond LEFT JOIN  vam_proveedores AS prov ON prov.id = cond.id_prov_cont LEFT JOIN vam_forma_envios AS fe ON fe.id = cond.id_form_envio LEFT JOIN vam_forma_pagos AS fp ON fp.id = cond.id_form_pago WHERE c.id_prod = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age(COALESCE((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato),now() - interval '13 month')) BETWEEN '11 month' AND '12 month' OR age(c.fecha_emision) BETWEEN '11 month' AND '12 month')`,
                    [id_prod]
                )
                .then(function (response) {
                    const prods = response.rows;
                    resolve(prods);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //12
    getIngContVencer(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT c.id, ing.cas, ing.nombre, ing.tipo, ing.descripcion, ing.taxonomia, ing_pres.volumen, ing_pres.precio FROM vam_contratos AS c, vam_mp_c AS cond LEFT JOIN vam_ingrediente_esencias AS ing ON ing.cas = cond.cas LEFT JOIN vam_ing_presentaciones AS ing_pres ON ing_pres.cas_ingrediente = cond.cas WHERE c.id_prod = $1 AND cond.id_contrato = c.id AND c.fecha_cancelacion IS NULL AND (age(COALESCE((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato),now() - interval '13 month')) BETWEEN '11 month' AND '12 month' OR age(c.fecha_emision) BETWEEN '11 month' AND '12 month')`,
                    [id_prod]
                )
                .then(function (response) {
                    const prods = response.rows;
                    resolve(prods);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //5
    updateCancelarCont(id_prod, id_cont, motivo_cancel, quien_cancela) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    "UPDATE vam_contratos SET fecha_cancelacion = current_date, motivo_cancel=$1, quien_cancela=$2 WHERE id = $3 AND id_prod = $4",
                    [motivo_cancel, quien_cancela, id_cont, id_prod]
                )
                .then(function () {
                    resolve(true);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //6
    getContNuevo(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT prov.id AS provId, pais.nombre AS paisnombre, prov.nombre, prov.email, prov.telefono, prov.pag_web FROM vam_proveedores As prov, vam_paises AS pais WHERE prov.id_pais = pais.id AND prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = $1) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = $1 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month'))`,
                    [id_prod]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //6.1
    getContNuevoFe(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT prov.id AS provId, fe.id, fe.tipo, fe.cargo, p.nombre, p.id AS paisId FROM vam_proveedores AS prov INNER JOIN vam_forma_envios AS fe ON fe.id_prov = prov.id INNER JOIN vam_paises AS p ON p.id = fe.id_pais WHERE prov.id IN (SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = $1) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = $1 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))`,
                    [id_prod]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //6.2
    getContNuevoFp(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT prov.id AS provId, fp.id, fp.tipo, fp.porc_inicial, fp.nro_cuotas, fp.interes_mensual, fp.nro_dia_entre_pago FROM vam_proveedores AS prov INNER JOIN vam_forma_pagos AS fp ON fp.id_proveedor = prov.id WHERE prov.id IN(SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = $1) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = $1 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))`,
                    [id_prod]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //6.3
    getContNuevoIng(id_prod) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT prov.id AS provId, ing.cas, ing.nombre, ing.tipo, present.precio, present.volumen FROM vam_proveedores AS prov INNER JOIN vam_ingrediente_esencias AS ing ON ing.id_proveedor = prov.id INNER JOIN vam_ing_presentaciones AS present ON present.cas_ingrediente = ing.cas WHERE prov.id IN (SELECT prov.id AS provId FROM vam_proveedores As prov WHERE prov.id IN (SELECT DISTINCT prov.id AS provid FROM vam_proveedores AS prov, vam_forma_envios as fe INNER JOIN vam_pa_pr AS sedes ON sedes.id_pais = fe.id_pais and sedes.id_productor = $1) AND prov.id IN (SELECT prov.id FROM vam_proveedores AS prov, vam_historico_ifra AS ifra WHERE ifra.id_proveedor = prov.id AND (SELECT ifra.fecha_fin WHERE ifra.id_proveedor = prov.id) IS NULL) AND prov.id NOT IN (SELECT c.id_prov FROM vam_contratos AS c WHERE c.id_prod = $1 AND c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))
                    `,
                    [id_prod]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //7
    getContNuevoListIng(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT ing.id_proveedor AS provId, ing.nombre, ing.tipo, ing.cas
                    FROM vam_ingrediente_esencias AS ing
                    WHERE ing.id_proveedor = $1 AND ing.cas NOT IN (
                        SELECT mpcont.cas
                        FROM vam_contratos AS cont, vam_mp_c AS mpcont
                        WHERE mpcont.id_contrato = cont.id AND cont.exclusividad = TRUE AND mpcont.id_contrato IN (SELECT c.id AS id_contrato FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))`,
                    [id_prov]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //8
    getContNuevoListIngExc(id_prov) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `SELECT ing.id_proveedor AS provId, ing.nombre, ing.tipo, ing.cas
                    FROM vam_ingrediente_esencias AS ing
                    WHERE ing.id_proveedor = $1 AND ing.cas NOT IN (
                        SELECT  mpcont.cas
                        FROM vam_contratos AS c, vam_mp_c AS mpcont
                        WHERE c.id = mpcont.id_contrato AND c.id IN(SELECT  c.id AS id_contrato FROM vam_contratos AS c WHERE c.fecha_cancelacion IS NULL AND (age((SELECT max(fecha) as maxf FROM vam_renovaciones AS r WHERE r.id_contrato = c.id GROUP BY id_contrato)) <= '12 month' OR age(c.fecha_emision) <= '12 month')))`,
                    [id_prov]
                )
                .then(function (response) {
                    const provs = response.rows;
                    resolve(provs);
                })
                .catch((e) => console.error(e.stack));
        });
    }

    //10
    createContrato(id_prod, id_prov, cont) {
        return new Promise((resolve, reject) => {
            console.log("Llega: ", cont);
            database
                .query(
                    `INSERT INTO vam_contratos(id_prov,id_prod,fecha_emision,exclusividad,clausula) VALUES ($1,$2,current_date,$3,$4) RETURNING id`,
                    [id_prov, id_prod, cont.exclusividad, cont.clausula]
                )
                .then(function (response) {
                    const id_cont = response.rows[0].id;
                    createInsertMp_c(id_cont, id_prod, id_prov, cont).then(() => {
                        resolve();
                    });
                })
                .catch((e) => console.error(e.stack));
        });
    }
    //30
    renovarContrato(id_prod, id_prov, id_cont) {
        return new Promise((resolve, reject) => {
            database
                .query(
                    `INSERT INTO vam_renovaciones(id_contrato,id_cont_prov,id_cont_prod,fecha) VALUES ($1,$2,$3,current_date)`,
                    [id_cont, id_prov, id_prod]
                )
                .then(function () {
                    resolve(true);
                })
                .catch((e) => console.error(e.stack));
        });
    }
}

module.exports = { ContratoProdModel };
