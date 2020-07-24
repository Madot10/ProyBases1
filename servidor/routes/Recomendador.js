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
//Filtro Genero
router.get('/perfumes/caracter', rec.getPerfFiltroCaracter);
//Filtro Genero
router.get('/perfumes/fliaolf', rec.getPerfFiltroCaracter);
//Filtro Genero
router.get('/perfumes/aroma', rec.getPerfFiltroCaracter);
//Filtro Genero
router.get('/perfumes/preferencia', rec.getPerfFiltroCaracter);
//Filtro Genero
router.get('/perfumes/personalidad', rec.getPerfFiltroCaracter);


module.exports = router;