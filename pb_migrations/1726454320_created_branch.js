/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "3ydmn3jad9ex3dk",
    "created": "2024-09-16 02:38:40.766Z",
    "updated": "2024-09-16 02:38:40.766Z",
    "name": "branch",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "ofne7sqe",
        "name": "location",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      }
    ],
    "indexes": [],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("3ydmn3jad9ex3dk");

  return dao.deleteCollection(collection);
})
