CREATE RANGE INDEX index_user_id IF NOT EXISTS
FOR (user:User)
ON (user.id);

CREATE RANGE INDEX index_user_ghid IF NOT EXISTS
FOR (user:User)
ON (user.gh_id);

CREATE TEXT INDEX index_user_name IF NOT EXISTS
FOR (user:User)
ON (user.name);

CREATE TEXT INDEX index_user_fullname IF NOT EXISTS
FOR (user:User)
ON (user.full_name);

LOAD CSV WITH HEADERS FROM "file:///users.csv" AS line FIELDTERMINATOR ","
MERGE (user:User { id: toInteger(line.id) })
SET 
    user.avatar = line.gh_avatar,
    user.gh_id = toInteger(line.gh_id),
    user.name = line.gh_login,
    user.full_name = line.name;
