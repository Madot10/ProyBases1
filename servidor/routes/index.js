var express = require("express");
var router = express.Router();

//RUTA EJEMPLO
/* GET home page. */
router.get("/", async (req, res) => {
    res.json({ title: "Home", mensaje: "Hola" });
});

module.exports = router;
