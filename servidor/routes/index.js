const express = require("express");
const router = express.Router();

router.use("/", require("./Home"));
router.use("/prod", require("./Productor"));
router.use("/prov", require("./Proveedor"));
router.use("/rec", require("./Recomendador"));

module.exports = router;
