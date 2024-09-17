/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("4dss6144o2dse9z")

  // remove
  collection.schema.removeField("m4z3qowd")

  // remove
  collection.schema.removeField("g0cef3rw")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "wilynhk6",
    "name": "leave_type",
    "type": "relation",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "3kww9kzah8wd7ka",
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

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "m4z3qowd",
    "name": "leave_type",
    "type": "select",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "maxSelect": 1,
      "values": [
        "Annual",
        "Sick",
        "Family Responsibility"
      ]
    }
  }))

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "g0cef3rw",
    "name": "status",
    "type": "select",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "maxSelect": 1,
      "values": [
        "Approved",
        "Pending",
        "Rejected"
      ]
    }
  }))

  // remove
  collection.schema.removeField("wilynhk6")

  return dao.saveCollection(collection)
})
