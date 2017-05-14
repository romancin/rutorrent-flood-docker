const CONFIG = {
  baseURI: '<CONTEXT_PATH>',
  dbCleanInterval: 1000 * 60 * 60,
  dbPath: '/config/flood-db/',
  floodServerPort: 3000,
  maxHistoryStates: 30,
  pollInterval: 1000 * 5,
  secret: '<FLOOD_SECRET>',
  scgi: {
    host: 'localhost',
    port: 5000,
    socket: true,
    socketPath: '/run/php/.rtorrent.sock'
  }
};

module.exports = CONFIG;
