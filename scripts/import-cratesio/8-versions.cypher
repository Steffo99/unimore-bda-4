CREATE LOOKUP INDEX index_version_checksum IF NOT EXISTS
FOR (version:Version)
ON (version.checksum);

CREATE RANGE INDEX index_version_size IF NOT EXISTS
FOR (version:Version)
ON (version.size);

CREATE RANGE INDEX index_version_created_at IF NOT EXISTS
FOR (version:Version)
ON (version.created_at);

CREATE RANGE INDEX index_version_downloads IF NOT EXISTS
FOR (version:Version)
ON (version.downloads);

CREATE RANGE INDEX index_version_id IF NOT EXISTS
FOR (version:Version)
ON (version.id);

CREATE TEXT INDEX index_version_name IF NOT EXISTS
FOR (version:Version)
ON (version.name);

LOAD CSV WITH HEADERS FROM "file:///versions.csv" AS line FIELDTERMINATOR ","
CALL {
    WITH line
    MERGE (version:Version { id: toInteger(line.id) } )
    SET 
        version.checksum = line.checksum,
        version.size = toInteger(line.crate_size),
        version.created_at = apoc.date.parse(line.created_at, "ms", "yyyy-MM-dd HH:mm:ss"),
        version.downloads = toInteger(line.downloads),
        version.license = line.license,
        version.features = line.features,
        version.links = line.links,
        version.name = line.num,
        version.is_yanked = CASE line.yanked
            WHEN "t"
                THEN true
            ELSE
                false
            END
    WITH line, version
    MATCH (crate:Crate { id: toInteger(line.crate_id) })
    MERGE (crate)-[:HAS_VERSION]->(version)
    WITH line, version
    MATCH (user:User { id: toInteger(line.published_by) })
    MERGE (user)-[:PUBLISHED]->(version)
} IN TRANSACTIONS OF 10000 ROWS;
