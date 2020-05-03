const express = require('express');
const router = express.Router();

router.use('/prod', require('./productores'));
//router.use('/prov', require('./proveedores'));

module.exports = router;
