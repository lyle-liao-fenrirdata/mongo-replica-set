## Create a Replica Set MongoDB architectures taking advantage of docker-compose.

- Use example.bash step 1 to 3 to establish MongoDB Replica Set settings. (This part will be done by docker-compose, no need to execute.)
- Use example.base step 4 for nextjs application settings. (as follow)

```bash
## 進入容器
docker-compose -f docker-compose-replica-set.yml exec mongo-rs1 bash

## 進入 mongosh
mongosh mongodb://mongo-rs1:27017

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

db.test.insertOne({ "test_id" : 1, "test_name" : "init" });
## 必須輸入一筆資料，db才會真的被創建
## {
##   acknowledged: true,
##   insertedId: ObjectId("6530934c331d4f7e11f74ef1")
## }

## 兩次退出 離開 mongosh 與 容器
exit
```

- Be sure that the volumes in docker-compose are pointing to the location(path) you want. Especially "/data/db" one.
