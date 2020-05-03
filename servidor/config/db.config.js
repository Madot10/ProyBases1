const { Pool } = require('pg')

const db = {
  user: 'postgres',
  host: 'localhost',
  database: 'perfumeria',
  password: '12345',
  port: 5432
}
const database = new Pool(db);

module.exports = { database };