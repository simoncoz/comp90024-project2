import PouchDB from 'pouchdb-browser'

const db = new PouchDB(‘tweetsdb’);
const remoteDatabase = new PouchDB(`http://127.0.0.1:5984/tweetsdb`);
PouchDB.sync(db, remoteDatabase, {
   live: true,
   heartbeat: false,
   timeout: false,
   retry: true
});