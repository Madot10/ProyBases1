const express = require("express");
const router = express.Router();
const { RecomendadorCont } = require("../controllers/RecomendadorCont");

//Se crea clase Controller y se llaman a los métodos de esa clase
var rec = new RecomendadorCont();

//Información para los filtros
//Carécteres
router.post("/caracter", rec.getCaracter);
//Familias Olvfativas
router.post("/fliaolf", rec.getFliaOlf);
//Aromas
router.post("/aroma", rec.getAroma);
//Preferencias
router.post("/preferencia", rec.getPreferencia);
//Personalidades
router.post("/personalidad", rec.getPersonalidad);

//Filtros
//Se pasa la información de todos los perfumes de acuerdo al filtro de GËNERO
router.post("/perfumes", rec.getPerfumes);
//Esencias y familia olfativa de acuerdo al ID de un perfume
router.get("/perfumes/esencias/:id_perf", rec.getEsenciasPerfumes);

module.exports = router;
