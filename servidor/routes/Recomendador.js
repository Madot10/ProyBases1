const express = require('express');
const router = express.Router();
const { RecomendadorCont }= require('../controllers/RecomendadorCont')

//Se crea clase Controller y se llaman a los métodos de esa clase
var rec = new RecomendadorCont;

//Información para los filtros
//Carécteres
router.get('/caracter', rec.getCaracter);
//Familias Olvfativas
router.get('/fliaolf', rec.getFliaOlf);
//Aromas
router.get('/aroma', rec.getAroma);
//Preferencias
router.get('/preferencia', rec.getPreferencia);
//Personalidades
router.get('/personalidad', rec.getPersonalidad);

//Filtros
//Se pasa la información de todos los perfumes de acuerdo al filtro de género
router.get('/perfumes', rec.getPerfumes);
//Se pasa la información de las notas de los perfumes de acuerdo al filtro de género
router.get('/perfumes/notas', rec.getNotasPerfumes);

module.exports = router;