Sistema VAM
==============================

_Abril - Julio 2020_

Proyecto desarrollado en equipo para la materia **Sistemas de Base de Datos I**.

Sistema de gestión de transacciones:

-   Evaluación de proveedores: Puntaje con base a criterios con un peso asignado por el productor.
-   Contratos: Emisión de contrato entre Proveedor y Productor.
-   Compras: Transacciones para la compra de ingredientes (esencias) de perfumes.
-   Catálogo de perfumes para ser mostrados en un recomendadorsegún las preferencias del usuario.

> **V**[ictoria Paciello](https://github.com/vicpaciello)
>
> **A**[lan Sosa](https://github.com/Black995)
>
> **M**[iguel De Olim](https://github.com/Madot10)

## Tecnologías utilizadas

-   Backend: Node.js + Express
-   Frontend: Vue.js + Bootstrap-vue
-   Base de datos: PostgreSQL **V12**

![Capturas del proyecto](https://repository-images.githubusercontent.com/252214615/a12a5f00-e332-11ea-974f-0ca5a547fd65)

## Instalar dependencias

**Servidor**

1. `cd servidor`
2. `npm install`

**Cliente**

1. `cd cliente`
2. `npm install`

**Base de datos**

1. Contar con PostgreSQL V12
2. Dirigirse a la carpeta SQL en `/servidor/SQL`
3. Crear la BD con el archivo `db_ordenada.sql`
4. Realizar inserts con el archivo `inserts.sql`

## Iniciar proyecto (local)

**Servidor**

1. `cd servidor`
2. `npm run start`

**Cliente**

1. `cd cliente`
2. `npm run serve`
