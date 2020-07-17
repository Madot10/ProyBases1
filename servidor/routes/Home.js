const express = require('express');
const router = express.Router();
const { HomeCont }= require('../controllers/HomeCont')

//Se crea clase Controller y se llaman a los métodos de esa clase
var home = new HomeCont;

//Alistar Productores
router.get('/prods', home.getAllProd);
//Alistar Proveedores
router.get('/provs', home.getAllProv);

module.exports = router;