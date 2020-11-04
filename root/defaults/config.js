const CONFIG = {
  baseURI: '/',
  dbCleanInterval: 1000 * 60 * 60,
  dbPath: '/config/flood-db/',
  disableUsersAndAuth: false,
  configUser: {
    client: 'rTorrent',
    type: 'socket',
    version: 1,
    socket: '/run/php/.rtorrent.sock',
  },
  floodServerPort: 3000,
  maxHistoryStates: 30,
  pollInterval: 1000 * 5,
  secret: 'flood',
  scgi: {
    host: 'localhost',
    port: 5000,
    socket: true,
    socketPath: '/run/php/.rtorrent.sock'
  },
  ssl: false,
  sslKey: '/config/nginx/key.pem',
  sslCert: '/config/nginx/cert.pem',
};

module.exports = CONFIG;
