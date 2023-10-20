# 1. 啟動 mongodb replica set containers
docker-compose -f docker-compose-replica-set.yml up -d

# 2. 設定 Replica Set
docker-compose -f docker-compose-replica-set.yml exec mongo-rs1 bash
## 容器內
## 2.1 進入 mongosh
mongosh mongodb://mongo-rs1:27041
## mongosh內
## 2.2 cfg中priority設定 => 確保 mongo-rs1:27041 為 primary
cfg = { "_id": "RS", "members": [{ "_id": 0, "host": "mongo-rs1:27041", "priority": 1 }, { "_id": 1, "host": "mongo-rs2:27042", "priority": 0 }, { "_id": 2, "host": "mongo-rs3:27043", "priority": 0 } ] };
rs.initiate(cfg);
## 印出 { ok: 1 } 就設定完成

# 3. 檢查組態和確認 Replica Set 的狀態
## mongosh內
rs.status().members.map(m => `${m.name}(${m.stateStr})`).join('\n');
## 印出以下，就設定完成
## mongo-rs1:27041(PRIMARY)
## mongo-rs2:27042(SECONDARY)
## mongo-rs3:27043(SECONDARY)

# 4. 建立資料庫/使用者
## mongosh內
use nextjs
db.createUser({ user: "nextjs", pwd: "nextjs",  roles: [ { role: "dbAdmin", db: "nextjs" }, { role: "readWrite", db: "nextjs" } ] });
db.getUsers();
## 會看到類似下列使用者建立
## users: [
##     {
##       _id: 'nextjs.nextjs',
##       userId: new UUID("744e797f-826e-4b05-8c12-fe52ae565bbf"),
##       user: 'nextjs',
##       db: 'nextjs',
##       roles: [
##         { role: 'readWrite', db: 'nextjs' },
##         { role: 'dbAdmin', db: 'nextjs' }
##       ],
##       mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
##     }
##   ],
##   ok: 1,

db.test.insertOne({ "testf_id" : 1, "test_name" : "init" });
## 必須輸入一筆資料，db才會真的被創建
## {
##   acknowledged: true,
##   insertedId: ObjectId("6530934c331d4f7e11f74ef1")
## }

# 測試連線
## 容器內
mongosh mongodb://mongo-rs1:27041,mongo-rs2:27042,mongo-rs3:27043/?replicaSet=RS

# miscellance
## mongosh內
mongosh mongodb://root:root@mongo-rs1:27041/admin?replicaSet=RS
db.getMongo().setReadPref('primary');
db.User.find();
rs.reconfig(cfg);
