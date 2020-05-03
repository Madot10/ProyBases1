const express = require('express');
const router = express.Router();
const { ProdController }= require('../controllers/ProdController')

//Se crea clase Controller y se llaman a los métodos de esa clase
var prodController = new ProdController;

router.post('/', prodController.create);
router.get('/:id', prodController.getById);
router.get('/', prodController.getAll);
router.put('/:id', prodController.update);
router.delete('/:id', prodController.delete);

module.exports = router;