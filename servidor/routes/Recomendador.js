const express = require('express');
const router = express.Router();
const { RecomendadorCont }= require('../controllers/RecomendadorCont')

//Se crea clase Controller y se llaman a los métodos de esa clase
var rec = new RecomendadorCont;

//Alistar Productores
router.get('/prods', rec.getAllProd);

module.exports = router;