const { Pool } = require('pg')

const db = {
  user: 'postgres',
  host: 'localhost',
  database: 'sistema_vam',
  password: '12345',
  port: 5432,
  multipleStatements: true
}
const database = new Pool(db);

module.exports = { database };