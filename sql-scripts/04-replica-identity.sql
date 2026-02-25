-- ============================================================
-- Script: 04-replica-identity.sql
-- Purpose: Set REPLICA IDENTITY for replicated tables
-- Needed for before-image values in CDC tools like Informatica
-- ============================================================

-- Set FULL identity (required if no primary key exists)

ALTER TABLE public.table1 REPLICA IDENTITY FULL;
ALTER TABLE public.table2 REPLICA IDENTITY FULL;
ALTER TABLE public.table3 REPLICA IDENTITY FULL;
ALTER TABLE public.table4 REPLICA IDENTITY FULL;
ALTER TABLE public.table5 REPLICA IDENTITY FULL;
ALTER TABLE public.table6 REPLICA IDENTITY FULL;

Commit;

-- Verify replica identity settings
SELECT relname AS table_name,
       CASE relreplident
            WHEN 'd' THEN 'DEFAULT'
            WHEN 'f' THEN 'FULL'
            WHEN 'n' THEN 'NOTHING'
            ELSE 'UNKNOWN'
       END AS replica_identity
FROM pg_class
WHERE relname IN ('table1','table2','table3','table4','table5','table6')
AND relnamespace = 'public'::regnamespace;
