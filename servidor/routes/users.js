var express = require("express");
var router = express.Router();

//RUTA EJEMPLO
/* GET users listing. */
router.get("/", async (req, res) => {
    res.send("respond with a resource");
});

module.exports = router;
