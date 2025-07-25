// Polyfill global para crypto.randomUUID
const { randomUUID } = require('crypto');

// Aplicar polyfill inmediatamente en el scope global
if (!global.crypto) {
    global.crypto = { randomUUID };
}

if (!globalThis.crypto) {
    globalThis.crypto = { randomUUID };
}

module.exports = {};
