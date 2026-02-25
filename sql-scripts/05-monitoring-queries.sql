-- ============================================================
-- Script: 05-monitoring-queries.sql
-- Purpose: Monitor replication slot health and WAL backlog
-- Used when storage alerts occur
-- ============================================================

-- 1. List replication slots
SELECT slot_name,
       active,
       restart_lsn,
       confirmed_flush_lsn
FROM pg_replication_slots;

------------------------------------------------------------

-- 2. Measure slot lag in GB (WAL not yet consumed)
SELECT slot_name,
       now() AS time_now,
       round((pg_current_wal_lsn() - restart_lsn)/1024/1024/1024, 2)
       AS slot_lag_gb
FROM pg_replication_slots;

------------------------------------------------------------

-- 3. Identify inactive slots (risk of WAL buildup)
SELECT slot_name,
       active
FROM pg_replication_slots
WHERE active = false;

------------------------------------------------------------

-- 4. Check publications and tables included
SELECT *
FROM pg_publication_tables
WHERE publication = 'db002_publication';

------------------------------------------------------------

-- 5. WAL level confirmation
SHOW wal_level;

------------------------------------------------------------

-- 6. Check current WAL directory size (optional)
-- Useful if storage alerts occur
-- Requires filesystem-level monitoring in AWS RDS
