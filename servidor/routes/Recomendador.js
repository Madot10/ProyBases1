const express = require('express');
const router = express.Router();
const { RecomendadorCont }= require('../controllers/RecomendadorCont')

//Se crea clase Controller y se llaman a los métodos de esa clase
var rec = new RecomendadorCont;

//Información para los filtros
//Carécteres
router.get("/caracter", rec.getCaracter);
//Familias Olvfativas
router.get("/fliaolf", rec.getFliaOlf);
//Aromas
router.get("/aroma", rec.getAroma);
//Preferencias
router.get("/preferencia", rec.getPreferencia);
//Personalidades
router.get("/personalidad", rec.getPersonalidad);

//Filtros
//Se pasa la información de todos los perfumes de acuerdo al filtro de GËNERO
router.get("/perfumes", rec.getPerfumes);
//Esencias y familia olfativa de acuerdo al ID de un perfume
router.get("/perfumes/esencias/:id_perf", rec.getEsenciasPerfumes);

module.exports = router;