'use strict';
const { HomeModel } = require('../models/HomeModel');

const home = new HomeModel();

class HomeCont {

  getAllProd(req,res){
		home.getAllProd()
			.then(function(prods){ res.status(200).json({Productores: prods})})
			.catch(e => console.error(e.stack))
  }
  
  getAllProv(req,res){
		home.getAllProv()
			.then(function(provs){ res.status(200).json({Proveedores: provs})})
			.catch(e => console.error(e.stack))
	}

}

module.exports = { HomeCont };
