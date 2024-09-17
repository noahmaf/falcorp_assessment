/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("4dss6144o2dse9z")

  collection.updateRule = "@request.auth.role = 'jm2cea9z4jcdld9'"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("4dss6144o2dse9z")

  collection.updateRule = "@request.auth.role = 'manager'"

  return dao.saveCollection(collection)
})
