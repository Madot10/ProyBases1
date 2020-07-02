const express = require('express');
const router = express.Router();

router.use('/', require('./Home'));
//router.use('/prod', require('./Productor'));
router.use('/prov', require('./Proveedor'));

module.exports = router;
