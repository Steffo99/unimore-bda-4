CREATE RANGE INDEX index_keyword_id IF NOT EXISTS
FOR (keyword:Keyword)
ON (keyword.id);

CREATE TEXT INDEX index_keyword_name IF NOT EXISTS
FOR (keyword:Keyword)
ON (keyword.name);

LOAD CSV WITH HEADERS FROM "file:///keywords.csv" AS line FIELDTERMINATOR ","
MERGE (keyword:Keyword { id: toInteger(line.id) })
SET 
    keyword.created_at = apoc.date.parse(line.created_at, "ms", "yyyy-MM-dd HH:mm:ss"),
    keyword.name = line.keyword;
