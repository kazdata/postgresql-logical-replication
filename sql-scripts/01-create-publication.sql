-- ============================================================
-- Script: 01-create-publication.sql
-- Purpose: Create a publication for multiple tables
-- Example Publication: db002_publication
-- ============================================================

CREATE PUBLICATION db002_publication
FOR TABLE
    public.table1,
    public.table2,
    public.table3,
    public.table4,
    public.table5,
    public.table6;

Commit;

-- Verify tables included in publication
SELECT *
FROM pg_publication_tables
WHERE publication = 'db002_publication';

