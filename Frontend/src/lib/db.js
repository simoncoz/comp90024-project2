import PouchDB from 'pouchdb';

const db = new PouchDB('http://admin:group49xxx@172.26.131.226:5984/aurin_lang');

const connection = {};
connection.info = (fn) => {
  db.info().then((info) => {
    fn(info);
  });
};

export default {
  connection,
};
