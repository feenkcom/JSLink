var winston = require('winston');

var logger = winston.createLogger({
  level: 'warn',
  // defaultMeta: { service: 'jslink' },
  transports: [
    new (winston.transports.Console)({ format: winston.format.simple() }) ],
  exceptionHandlers: [
    new (winston.transports.Console)({ format: winston.format.simple() }) ],
  exitOnError: false
});

module.exports = logger;
