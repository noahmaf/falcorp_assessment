/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("4dss6144o2dse9z")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "1vl7lnzz",
    "name": "manager",
    "type": "relation",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "_pb_users_auth_",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("4dss6144o2dse9z")

  // remove
  collection.schema.removeField("1vl7lnzz")

  return dao.saveCollection(collection)
})
