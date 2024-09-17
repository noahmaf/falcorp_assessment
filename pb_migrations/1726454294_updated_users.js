/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("_pb_users_auth_")

  // remove
  collection.schema.removeField("km8ryyda")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "ytqsdqhj",
    "name": "department",
    "type": "relation",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "y1gfhb0ow1my5nx",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("_pb_users_auth_")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "km8ryyda",
    "name": "department",
    "type": "select",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "maxSelect": 1,
      "values": [
        "IT",
        "Support",
        "HR",
        "Marketing",
        "Sales"
      ]
    }
  }))

  // remove
  collection.schema.removeField("ytqsdqhj")

  return dao.saveCollection(collection)
})
