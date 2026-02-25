-- ============================================================
-- File: example-multi-table-publication.sql
-- Purpose: Create logical replication publication with
--          multiple tables
-- Environment: PostgreSQL Dev
-- ============================================================

-- Step 1: Verify wal_level
SHOW wal_level;

-- wal_level must be 'logical'


-- Step 2: Create Publication with Multiple Tables

CREATE PUBLICATION app_publication
FOR TABLE
    public.users,
    public.orders,
    public.order_items,
    public.payments,
    public.audit_log;


-- Step 3: Verify Publication

SELECT
    pubname,
    puballtables
FROM pg_publication;


-- Step 4: View Tables in Publication

SELECT
    p.pubname,
    t.schemaname,
    t.tablename
FROM pg_publication p
JOIN pg_publication_tables t
ON p.pubname = t.pubname
ORDER BY t.tablename;


-- Step 5: Add Additional Table Later

ALTER PUBLICATION app_publication
ADD TABLE public.new_table;


-- Step 6: Remove Table from Publication

ALTER PUBLICATION app_publication
DROP TABLE public.audit_log;


-- Notes:
-- - No need to recreate publication when adding tables
-- - Subscriber must refresh subscription after structural changes
-- - Ensure REPLICA IDENTITY is configured for tables without PK

