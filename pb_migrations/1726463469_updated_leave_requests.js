/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("4dss6144o2dse9z")

  // remove
  collection.schema.removeField("aymbpitn")

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("4dss6144o2dse9z")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "aymbpitn",
    "name": "days",
    "type": "number",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "noDecimal": false
    }
  }))

  return dao.saveCollection(collection)
})
