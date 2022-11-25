MATCH (:Crate)-[relation:IS_TAGGED_WITH]->(:Keyword)
DELETE relation;

LOAD CSV WITH HEADERS FROM "file:///crates_keywords.csv" AS line FIELDTERMINATOR ","
MATCH 
    (crate:Crate {id: toInteger(line.crate_id)}),
    (keyword:Keyword {id: toInteger(line.keyword_id)})
CREATE (crate)-[:IS_TAGGED_WITH]->(keyword);
