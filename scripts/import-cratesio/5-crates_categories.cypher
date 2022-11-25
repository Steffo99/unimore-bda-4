MATCH (:Category)-[relation:CONTAINS]->(:Crate)
DELETE relation;

LOAD CSV WITH HEADERS FROM "file:///crates_categories.csv" AS line FIELDTERMINATOR ","
MATCH 
    (crate:Crate {id: toInteger(line.crate_id)}),
    (category:Category {id: toInteger(line.category_id)})
CREATE (category)-[:CONTAINS]->(crate);
