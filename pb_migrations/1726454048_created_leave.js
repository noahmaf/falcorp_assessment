/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "3kww9kzah8wd7ka",
    "created": "2024-09-16 02:34:08.196Z",
    "updated": "2024-09-16 02:34:08.196Z",
    "name": "leave",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "urtzddsf",
        "name": "leave_type",
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
  const collection = dao.findCollectionByNameOrId("3kww9kzah8wd7ka");

  return dao.deleteCollection(collection);
})
