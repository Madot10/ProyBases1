
--Datos de prueba 

INSERT INTO VAM_PAISES(nombre,continente) VALUES('Francia','eu');
INSERT INTO VAM_PAISES(nombre,continente) VALUES('Estados Unidos','am');

INSERT INTO VAM_PROVEEDORES(nombre,email,telefono,pag_web,id_pais) VALUES('PROVEEDOR 1', 'hola1@gmail.com', 215327654, 'www.juanito.com', 1);
INSERT INTO VAM_PROVEEDORES(nombre,email,telefono,pag_web,id_pais) VALUES('PROVEEDOR 2', 'hola2@gmail.com', 2123982454, 'www.juanito1.com', 2);

INSERT INTO VAM_PRODUCTORES(nombre,email,telefono,pag_web) VALUES('PRODUCTOR 1', 'hola@gmail.com', 2123555654, 'www.juanito3.com');
INSERT INTO VAM_PRODUCTORES(nombre,email,telefono,pag_web) VALUES('PRODUCTOR 2', 'hola3@gmail.com', 2123354, 'www.juanito4.com');

INSERT INTO VAM_INGREDIENTE_ESENCIAS(cas,id_prov,nombre,descripcion,taxonomia) VALUES(1234,1,'naranjita','soy naranjita','naranjus medium');

INSERT INTO VAM_INGREDIENTE_ESENCIAS(cas,id_prov,nombre,descripcion,taxonomia) VALUES(132354,1,'manzanita','soy manzanita','manzanis tilum');

INSERT INTO VAM_CONTRATOS(id_prov,id_prod,fecha_emision,exclusividad) VALUES(1,1,'10-10-2020',DEFAULT);

INSERT INTO VAM_CONTRATOS(id_prov,id_prod,fecha_emision,exclusividad) VALUES(4,1,'10-19-2020',DEFAULT);


INSERT INTO VAM_MP_C VALUES(1,1,1,1234,1);
INSERT INTO VAM_MP_C VALUES(3,4,1,132354,1);

--Borrar tablas
DROP TABLE VAM_PROVEEDORES;
DROP TABLE VAM_PRODUCTORES;
DROP TABLE VAM_FORMA_ENVIOS;
DROP TABLE VAM_FORMA_PAGOS;
DROP TABLE VAM_PAISES;
DROP TABLE VAM_CONTRATOS;
