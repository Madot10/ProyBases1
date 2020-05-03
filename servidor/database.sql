CREATE DATABASE perfumeria;

CREATE TABLE proveedores(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR NOT NULL,
   contrasena VARCHAR NOT NULL,
   info_contacto VARCHAR NOT NULL,
   pagina_web VARCHAR NOT NULL,
   ubicacion VARCHAR NOT NULL,
   envio_alterno VARCHAR NOT NULL,
   suscripcion_ifra BOOLEAN DEFAULT TRUE
);

CREATE TABLE productores(
   id SERIAL PRIMARY KEY,
   nombre VARCHAR NOT NULL,
   contrasena VARCHAR NOT NULL,
   info_contacto VARCHAR NOT NULL,
   pagina_web VARCHAR NOT NULL
);
