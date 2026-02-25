-- ============================================================
-- Script: 03-grant-permissions.sql
-- Purpose: Grant required privileges to replication consumer user
-- User Example: test_dev_info_ro
-- ============================================================

-- Grant schema usage
GRANT USAGE ON SCHEMA public TO test_dev_info_ro;

-- Grant SELECT on replicated tables
GRANT SELECT ON TABLE
    public.table1,
    public.table2,
    public.table3,
    public.table4,
    public.table5,
    public.table6
TO test_dev_info_ro;

Commit;

-- Grant access to publication
GRANT USAGE ON PUBLICATION db002_publication TO test_dev_info_ro;

-- Optional: allow future tables added to schema to be readable
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO test_dev_info_ro;

commit;
