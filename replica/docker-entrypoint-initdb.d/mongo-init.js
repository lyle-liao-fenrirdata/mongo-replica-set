print(
  "Replica Set Initate Start #################################################################"
);

config = {
  _id: "RS",
  members: [
    { _id: 0, host: "mongo-rs1:27041", priority: 1 },
    { _id: 1, host: "mongo-rs2:27042", priority: 0 },
    { _id: 2, host: "mongo-rs3:27043", priority: 0 },
  ],
};
rs.initiate(config);
rs.status();

var nextjsDB = db.getSiblingDB("nextjs");

nextjsDB.createUser({
  user: "nextjs",
  pwd: "nextjs",
  roles: [
    { role: "dbAdmin", db: "nextjs" },
    { role: "readWrite", db: "nextjs" },
  ],
});
nextjsDB.createCollection("test");
nextjsDB.test.insertOne({ testf_id: 1, test_name: "init" });

print(
  "################################################################# Replica Set Initate End"
);
