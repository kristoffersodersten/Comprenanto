const crypto = require('crypto');

// Generera en 32-byte (256-bit) slumpmässig nyckel
const key = crypto.randomBytes(32);
// Konvertera till base64
const base64Key = key.toString('base64');

console.log('ENCRYPTION_KEY för .env filer:');
console.log(base64Key); 