CREATE RANGE INDEX index_crate_id IF NOT EXISTS
FOR (crate:Crate)
ON (crate.id);

CREATE RANGE INDEX index_crate_downloads IF NOT EXISTS
FOR (crate:Crate)
ON (crate.downloads);

CREATE RANGE INDEX index_crate_created_at IF NOT EXISTS
FOR (crate:Crate)
ON (crate.created_at);

CREATE RANGE INDEX index_crate_updated_at IF NOT EXISTS
FOR (crate:Crate)
ON (crate.updated_at);

CREATE TEXT INDEX index_crate_name IF NOT EXISTS
FOR (crate:Crate)
ON (crate.name);

LOAD CSV WITH HEADERS FROM "file:///crates.csv" AS line FIELDTERMINATOR ","
CALL {
    WITH line
    MERGE (crate:Crate { id: toInteger(line.id) })
    SET 
        crate.created_at = apoc.date.parse(line.created_at, "ms", "yyyy-MM-dd HH:mm:ss"),
        crate.updated_at = apoc.date.parse(line.updated_at, "ms", "yyyy-MM-dd HH:mm:ss"),
        crate.max_upload_size = toInteger(line.max_upload_size),
        crate.downloads = toInteger(line.downloads),
        crate.description = CASE trim(line.description) 
            WHEN "" 
                THEN null 
            ELSE 
                line.description 
            END,
        crate.documentation = CASE trim(line.documentation) 
            WHEN "" 
                THEN null 
            ELSE 
                line.documentation 
            END,
        crate.homepage = CASE trim(line.homepage) 
            WHEN "" 
                THEN null 
            ELSE 
                line.homepage 
            END,
        crate.name = CASE trim(line.name) 
            WHEN "" 
                THEN null 
            ELSE 
                line.name 
            END,
        crate.readme = CASE trim(line.readme) 
            WHEN "" 
                THEN null 
            ELSE 
                line.readme 
            END,
        crate.repository = CASE trim(line.repository) 
            WHEN "" 
                THEN null 
            ELSE 
                line.repository 
            END
} IN TRANSACTIONS OF 10000 ROWS;