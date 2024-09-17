/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("3ydmn3jad9ex3dk")

  collection.name = "branches"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("3ydmn3jad9ex3dk")

  collection.name = "branch"

  return dao.saveCollection(collection)
})
