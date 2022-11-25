MATCH (:User)-[owns:OWNS]->(:Crate)
DELETE owns;

LOAD CSV WITH HEADERS FROM "file:///crate_owners.csv" AS line FIELDTERMINATOR ","
MATCH (crate:Crate { id: toInteger(line.crate_id) })
MATCH (owner:User { id: toInteger(line.owner_id) })
CREATE (owner)-[ownership:OWNS {
    created_at: apoc.date.parse(line.created_at, "ms", "yyyy-MM-dd HH:mm:ss"),
    created_by: toInteger(line.created_by),
    owner_kind: toInteger(line.owner_kind)
}]->(crate);