const express = require('express');
const router = express.Router();

//router.use('/prod', require('./productor'));
router.use('/prov', require('./proveedor'));

module.exports = router;
