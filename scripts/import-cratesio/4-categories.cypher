CREATE RANGE INDEX index_category_id IF NOT EXISTS
FOR (category:Category)
ON (category.id);

CREATE TEXT INDEX index_category_name IF NOT EXISTS
FOR (category:Category)
ON (category.name);

CREATE TEXT INDEX index_category_slug IF NOT EXISTS
FOR (category:Category)
ON (category.slug);

CREATE TEXT INDEX index_category_leaf IF NOT EXISTS
FOR (category:Category)
ON (category.leaf);

MATCH (category:Category)
DETACH DELETE category;

CREATE (
    :Category {
        name: "Root",
        created_at: datetime(),
        description: "Root category. Does not contain any category by itself.",
        id: 0,
        path: "root",
        slug: "root"
    }
);

LOAD CSV WITH HEADERS FROM "file:///categories.csv" AS line
CREATE (
    :Category {
        name: line.category,
        created_at: apoc.date.parse(line.created_at, "ms", "yyyy-MM-dd HH:mm:ss"),
        description: line.description,
        id: toInteger(line.id),
        path: line.path,
        slug: line.slug
    }
);

MATCH (c:Category)
WITH c, split(c.path, ".") AS path
SET c.leaf = path[-1];

MATCH (c:Category)
WITH c, split(c.path, ".") AS path
MATCH (d:Category {leaf: path[-2]})
CREATE (d)-[:CONTAINS]->(c);
