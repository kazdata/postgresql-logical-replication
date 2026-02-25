-- ============================================================
-- Script: 07-alter-publication-add-remove-tables.sql
-- Purpose: Manage tables in an existing publication
-- Publication: db002_publication
--
-- Key Point:
-- You do NOT need to recreate the replication slot or publication
-- when adding or removing tables.
-- ============================================================


-- ------------------------------------------------------------
-- Step 1: Review Current Tables in the Publication
-- ------------------------------------------------------------

SELECT *
FROM pg_publication_tables
WHERE publication = 'db002_publication';


-- ------------------------------------------------------------
-- Step 2: Add New Tables to the Publication
-- ------------------------------------------------------------
-- Example: Adding table7 and table8

ALTER PUBLICATION db002_publication
ADD TABLE
    public.table7,
    public.table8;


-- Confirm tables were added successfully
SELECT *
FROM pg_publication_tables
WHERE publication = 'db002_publication';


-- ------------------------------------------------------------
-- Step 3: Remove Tables from the Publication
-- ------------------------------------------------------------
-- Example: Removing table3 if it is no longer needed

ALTER PUBLICATION db002_publication
REMOVE TABLE public.table3;

Commit;

-- Confirm table was removed successfully
SELECT *
FROM pg_publication_tables
WHERE publication = 'db002_publication';


-- ------------------------------------------------------------
-- Step 4: Notes / Best Practices
-- ------------------------------------------------------------
-- 1. Adding tables is safe and does not interrupt replication.
-- 2. Removing tables stops replication for that table only.
-- 3. No need to drop/recreate replication slot.
-- 4. Always ensure Informatica/application is aware of changes.
-- 5. If tables require UPDATE/DELETE replication,
--    confirm REPLICA IDENTITY is set correctly.

-- Example:
-- ALTER TABLE public.table7 REPLICA IDENTITY FULL;
