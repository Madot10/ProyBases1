'use strict';
const { HomeModel } = require('../models/HomeModel');

const home = new HomeModel();

class HomeCont {

	//Menú inicial (antes de entrar al sistema)

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

	//Menú después de entrar al sistema

	getProvs(req,res){

		home.getProvs()
			.then(function(ingreds){ res.status(200).json({Proveedores: ingreds})})
			.catch(e => console.error(e.stack))
	}

	getProvsfefp(req,res){

		home.getProvsfefp()
			.then(function(ingreds){ res.status(200).json({Fe_Fp_de_proveedores: ingreds})})
			.catch(e => console.error(e.stack))
	}

}

module.exports = { HomeCont };
