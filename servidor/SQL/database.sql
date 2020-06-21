CREATE DATABASE sistema_vam;

--Cambiarse a la BS: \c database_name
--Listar BD: \l o \list
--Listar tablas de una BD: \dt

CREATE TABLE MP_PROHIBIDA(
   cas INT PRIMARY KEY,
   nombre VARCHAR NOT NULL
);

CREATE TABLE CONTINENTE(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR NOT NULL UNIQUE
);

--Falta colocarle el PK compuesta con continente
CREATE TABLE PAIS(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR NOT NULL UNIQUE,
   id_continente INT,
   FOREIGN KEY(id_continente) REFERENCES CONTINENTE(id) ON DELETE SET NULL
);

CREATE TABLE PRODUCTOR(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR NOT NULL,
   email VARCHAR NOT NULL UNIQUE,
   telefono BIGINT NOT NULL UNIQUE,
   pag_web VARCHAR NOT NULL UNIQUE,
   local_nro INT NOT NULL UNIQUE,
   calle VARCHAR NOT NULL,
   cod_postal INT NOT NULL,
   id_pais INT,
   FOREIGN KEY(id_pais) REFERENCES PAIS(id) ON DELETE SET NULL
);

CREATE TABLE PROVEEDOR(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR NOT NULL,
   email VARCHAR NOT NULL UNIQUE,
   telefono BIGINT NOT NULL UNIQUE,
   pag_web VARCHAR NOT NULL UNIQUE,
   local_nro INT NOT NULL UNIQUE,
   calle VARCHAR NOT NULL,
   cod_postal INT NOT NULL,
   id_pais INT,
   FOREIGN KEY(id_pais) REFERENCES PAIS(id) ON DELETE SET NULL
);

--Falta colocarle el PK compuesta con PROVEEDOR
CREATE TABLE FORMA_ENVIO(
   id SERIAL PRIMARY KEY,
   tipo VARCHAR NOT NULL CHECK(tipo = 'm' OR tipo = 'a' OR tipo = 'a'),
   cargo REAL NOT NULL,
   id_pais INT,
   id_cont_pais INT,
   FOREIGN KEY(id_pais) REFERENCES PAIS(id) ON DELETE SET NULL,
   FOREIGN KEY(id_cont_pais) REFERENCES CONTINENTE(id) ON DELETE SET NULL
);

--De aquí para arriba se tiene que modificar la PK compuesta con país

--Falta colocarle el PK compuesta con PROVEEDOR
CREATE TABLE FORMA_PAGO(
   id SERIAL PRIMARY KEY,
   tipo VARCHAR NOT NULL CHECK(tipo = 'cont' OR tipo = 'cred'),
   porc_inicial REAL,
   nro_cuotas REAL,
   interes_mensual REAL,
   nro_dia_entre_pago INT,
   id_proveedor INT,
   FOREIGN KEY(id_proveedor) REFERENCES PROVEEDOR(id) ON DELETE SET NULL
);




--Ejemplo parainsertar productos en MP_PROHIBIDA
INSERT INTO MP_PROHIBIDA VALUES(100, 'Algo prohibido xD');

--Datos de prueba 

INSERT INTO CONTINENTE VALUES(1, 'Europa');

INSERT INTO PAIS VALUES(1, 'Francia', 1);

INSERT INTO PROVEEDOR VALUES(1, 'Juanito', 'hola@gmail.com', 2123987654, 'www.juanito.com', 123, 'los proceres', 1071, 1);