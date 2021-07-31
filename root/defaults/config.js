const CONFIG = {
  baseURI: '/',
  dbCleanInterval: 1000 * 60 * 60,
  dbPath: '/config/flood-db/',
  auth: 'default',
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
  ssl: false,
  sslKey: '/config/nginx/key.pem',
  sslCert: '/config/nginx/cert.pem',
};

module.exports = CONFIG;
