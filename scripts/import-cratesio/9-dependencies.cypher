CREATE RANGE INDEX index_dependency_id IF NOT EXISTS
FOR ()-[dependency:DEPENDS_ON]->()
ON (dependency.id);

CREATE TEXT INDEX index_dependency_requirement IF NOT EXISTS
FOR ()-[dependency:DEPENDS_ON]->()
ON (dependency.requirement);

CREATE TEXT INDEX index_dependency_explicit_name IF NOT EXISTS
FOR ()-[dependency:DEPENDS_ON]->()
ON (dependency.explicit_name);

LOAD CSV WITH HEADERS FROM "file:///dependencies.csv" AS line FIELDTERMINATOR ","
CALL {
    WITH line
    MATCH 
        (version:Version { id: toInteger(line.version_id) }),
        (requirement:Crate { id: toInteger(line.crate_id) })
    MERGE (version)-[dependency:DEPENDS_ON]->(requirement)
    SET
        dependency.id = line.id,
        dependency.is_optional = CASE line.optional
            WHEN "t"
                THEN true
            ELSE
                false
            END,
        dependency.is_default = CASE line.default_features
            WHEN "t"
                THEN true
            ELSE
                false
            END,
        dependency.explicit_name = line.explicit_name,
        dependency.features = line.features,
        dependency.requirement = line.req,
        dependency.target = line.target
} IN TRANSACTIONS OF 10000 ROWS;
