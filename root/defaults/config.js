const CONFIG = {
  baseURI: '/',
  dbCleanInterval: 1000 * 60 * 60,
  dbPath: '/config/flood-db/',
  floodServerHost: '127.0.0.1',
  floodServerPort: 3000,
  floodServerProxy: 'http://127.0.0.1',
  maxHistoryStates: 30,
  pollInterval: 1000 * 5,
  secret: 'flood',
  scgi: {
    host: 'localhost',
    port: 5000,
    socket: true,
    socketPath: '/run/php/.rtorrent.sock'
  },
  ssl: true,
  sslKey: '/config/nginx/key.pem',
  sslCert: '/config/nginx/cert.pem',
  torrentClientPollInterval: 1000 * 2
};

module.exports = CONFIG;
