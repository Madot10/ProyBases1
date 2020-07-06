const express = require('express');
const router = express.Router();
const { ProdProhibCont }= require('../controllers/ProdProhibCont')

var prod = new ProdProhibCont;

//Métodos get, post y put
router.get('/', prod.getAll);
router.post('/', prod.createProdProhib);
router.put('/:id', prod.updateProdProhib);

module.exports = router;
