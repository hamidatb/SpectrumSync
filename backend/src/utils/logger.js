// utils/logger.js
class Logger {
    log(message) {
        console.log(`[${new Date().toISOString()}] INFO: ${message}`);
    }

    error(message) {
        console.error(`[${new Date().toISOString()}] ERROR: ${message}`);
    }

    warn(message) {
        console.warn(`[${new Date().toISOString()}] WARN: ${message}`);
    }
}

const logger = new Logger();

module.exports = logger;