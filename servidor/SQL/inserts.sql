
--Datos de prueba 

INSERT INTO VAM_PAISES(nombre,continente) VALUES('Francia','e');
INSERT INTO VAM_PAISES(nombre,continente) VALUES('Estados Unidos','am');
INSERT INTO VAM_PAISES(nombre,continente) VALUES('Canadá','am');

INSERT INTO VAM_PROVEEDORES(nombre,email,telefono,pag_web,id_pais) VALUES('PROVEEDOR 1', 'hola1@gmail.com', 215327654, 'www.juanito.com', 4);
INSERT INTO VAM_PROVEEDORES(nombre,email,telefono,pag_web,id_pais) VALUES('PROVEEDOR 2', 'hola2@gmail.com', 2123982454, 'www.juanito1.com', 2);


--Modificar problema con serial
UPDATE VAM_PROVEEDORES
  SET id=1
  WHERE id=3;
DELETE FROM VAM_INGREDIENTE_ESENCIAS
    WHERE id_proveedor=3;


INSERT INTO VAM_PRODUCTORES(nombre,email,telefono,pag_web) VALUES('PRODUCTOR 1', 'hola@gmail.com', 2123555654, 'www.juanito3.com');
INSERT INTO VAM_PRODUCTORES(nombre,email,telefono,pag_web) VALUES('PRODUCTOR 2', 'hola3@gmail.com', 2123354, 'www.juanito4.com');

--Inserts de los paises de los productores
INSERT INTO VAM_PA_PR VALUES(2,3);
INSERT INTO VAM_PA_PR VALUES(2,4);
INSERT INTO VAM_PA_PR VALUES(1,2);
INSERT INTO VAM_PA_PR VALUES(1,4);

INSERT INTO VAM_INGREDIENTE_ESENCIAS(cas,id_proveedor,nombre,tipo,descripcion,taxonomia) VALUES(1234,2,'naranjita','n','soy naranjita','naranjus medium');
INSERT INTO VAM_INGREDIENTE_ESENCIAS(cas,id_proveedor,nombre,tipo,descripcion,taxonomia) VALUES(132354,1,'manzanita','n','soy manzanita','manzanis tilum');

INSERT INTO VAM_CONTRATOS(id_prov,id_prod,fecha_emision,exclusividad) VALUES(1,1,'06-01-2019',TRUE);
INSERT INTO VAM_CONTRATOS(id_prov,id_prod,fecha_emision,exclusividad) VALUES(2,2,'10-19-2020',DEFAULT);
INSERT INTO VAM_CONTRATOS(id_prov,id_prod,fecha_emision,exclusividad,clausula) VALUES(1,1,'12-10-2019',DEFAULT,'Contrato formado por ambas partes de las empresas, en la que se acuerda vender sin exclusividad');


--PAra modificar fecha de emision de un contrato
UPDATE VAM_CONTRATOS
  SET fecha_emision = '06-01-2019'
  WHERE id=1;


INSERT INTO VAM_HISTORICO_IFRA(fecha_inicio,id_proveedor) VALUES('12-30-2012',1);
INSERT INTO VAM_HISTORICO_IFRA(fecha_inicio,id_proveedor) VALUES('07-27-2019',2);
INSERT INTO VAM_HISTORICO_IFRA(fecha_inicio,id_productor) VALUES('11-11-2014',1);
INSERT INTO VAM_HISTORICO_IFRA(fecha_inicio,id_productor) VALUES('01-30-2012',2);

INSERT INTO VAM_FORMA_PAGOS(id_proveedor,tipo) VALUES (1,'cont');
INSERT INTO VAM_FORMA_PAGOS(id_proveedor,tipo) VALUES (2,'cont');
INSERT INTO VAM_FORMA_PAGOS(id_proveedor,tipo,porc_inicial,nro_cuotas,interes_mensual,nro_dia_entre_pago) VALUES (1,'cred',50,2,10,15);
INSERT INTO VAM_FORMA_PAGOS(id_proveedor,tipo,porc_inicial,nro_cuotas,interes_mensual,nro_dia_entre_pago) VALUES (2,'cred',80,3,40,30);

INSERT INTO vam_forma_envios(id_prov, id_pais, tipo, cargo)  VALUES(1,2,'m',20);
INSERT INTO vam_forma_envios(id_prov, id_pais, tipo, cargo)  VALUES(1,3,'a',50);
INSERT INTO vam_forma_envios(id_prov, id_pais, tipo, cargo)  VALUES(2,2,'m',30);
INSERT INTO vam_forma_envios(id_prov, id_pais, tipo, cargo)  VALUES(2,4,'t',30);

INSERT INTO VAM_MP_C VALUES(1,1,1,1234,2);
INSERT INTO VAM_MP_C VALUES(3,1,1,1234,2);
INSERT INTO VAM_MP_C VALUES(2,2,2,132354,1);

INSERT INTO vam_fe_fp_c(id_contrato, id_prov_cont, id_prod_cont, id_form_pago, id_prov_fp) VALUES (1,1,1,2,1);
INSERT INTO vam_fe_fp_c(id_contrato, id_prov_cont, id_prod_cont, id_form_pago, id_prov_fp) VALUES (2,2,2,3,2);
INSERT INTO vam_fe_fp_c(id_contrato, id_prov_cont, id_prod_cont, id_form_pago, id_prov_fp) VALUES (3,1,1,4,1);
INSERT INTO vam_fe_fp_c(id_contrato, id_prov_cont, id_prod_cont, id_form_envio, id_prov_fe, id_form_envio_pais) VALUES (1,1,1,1,1,2);
INSERT INTO vam_fe_fp_c(id_contrato, id_prov_cont, id_prod_cont, id_form_envio, id_prov_fe, id_form_envio_pais) VALUES (2,2,2,3,2,2);
INSERT INTO vam_fe_fp_c(id_contrato, id_prov_cont, id_prod_cont, id_form_envio, id_prov_fe, id_form_envio_pais) VALUES (3,1,1,2,1,3);



--Borrar tablas
DROP TABLE VAM_PROVEEDORES;
DROP TABLE VAM_PRODUCTORES;
DROP TABLE VAM_FORMA_ENVIOS;
DROP TABLE VAM_FORMA_PAGOS;
DROP TABLE VAM_PAISES;
DROP TABLE VAM_CONTRATOS;
drop table vam_cond_pedido;
drop table  vam_fe_fp_c;