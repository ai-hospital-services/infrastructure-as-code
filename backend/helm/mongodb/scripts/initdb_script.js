var initDBName = process.env["MONGO_INITDB_DATABASE"];
var appInitDBUsername = process.env["APP_INITDB_USERNAME"];
var appInitDBPassword = process.env["APP_INITDB_PASSWORD"];

db.createUser({
  user: appInitDBUsername,
  pwd: appInitDBPassword,
  roles: [{ role: "readWrite", db: initDBName }],
});

db.auth({
  user: appInitDBUsername,
  pwd: appInitDBPassword,
});

db = db.getSiblingDB(initDBName);
db.createCollection("draft");
