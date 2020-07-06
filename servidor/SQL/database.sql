CREATE DATABASE sistema_vam;

--Cambiarse a la BS: \c database_name
--Listar BD: \l o \list
--Listar tablas de una BD: \dt
--Limpiar pantalla: \! cls

CREATE TABLE VAM_MP_PROHIBIDAS(
   cas NUMERIC(12) PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL
);




--Ejemplo parainsertar productos en la tabla
INSERT INTO VAM_MP_PROHIBIDAS VALUES(12345, 'Materia prohibida 1');
INSERT INTO VAM_MP_PROHIBIDAS VALUES(67890, 'Materia prohibida 2');
INSERT INTO VAM_MP_PROHIBIDAS VALUES(24680, 'Materia prohibida 3');
