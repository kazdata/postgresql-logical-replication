-- ============================================================
-- Script: 08-emergency-slot-recovery.sql
-- Purpose: Emergency troubleshooting and recovery when
--          replication slots cause WAL backlog and storage alerts
--
-- Use Case:
-- - Informatica / application stops consuming logs
-- - WAL files accumulate
-- - Storage alerts triggered (LogicMonitor / PagerDuty)
--
-- IMPORTANT:
-- Dropping slots is LAST RESORT in production.
-- ============================================================


-- ------------------------------------------------------------
-- Step 1: Check Replication Slot Status
-- ------------------------------------------------------------

SELECT slot_name,
       active,
       restart_lsn,
       confirmed_flush_lsn
FROM pg_replication_slots;


-- Interpretation:
-- active = true   -> consumer is connected
-- active = false  -> consumer disconnected, WAL may accumulate


-- ------------------------------------------------------------
-- Step 2: Measure Slot Lag (WAL Backlog) in GB
-- ------------------------------------------------------------

SELECT slot_name,
       now() AS time_now,
       round((pg_current_wal_lsn() - restart_lsn)/1024/1024/1024, 2)
       AS slot_lag_gb
FROM pg_replication_slots;


-- Action:
-- If slot_lag_gb keeps increasing, logs are not being consumed.


-- ------------------------------------------------------------
-- Step 3: Identify Inactive or Stalled Slots
-- ------------------------------------------------------------

SELECT slot_name,
       active
FROM pg_replication_slots
WHERE active = false;


-- If slot is inactive, confirm Informatica/application job status.


-- ------------------------------------------------------------
-- Step 4: Confirm Publication Tables (Scope Check)
-- ------------------------------------------------------------

SELECT *
FROM pg_publication_tables
WHERE publication = 'db002_publication';


-- Ensure only required tables are included.


-- ------------------------------------------------------------
-- Step 5: Recommended Recovery Actions (Before Dropping Slot)
-- ------------------------------------------------------------

-- 1. Application/Informatica team should restart CDC job
-- 2. Network connectivity should be confirmed
-- 3. Subscription health should be validated on subscriber side

-- DBA Action:
-- Monitor slot lag again after Informatica restart.


-- ------------------------------------------------------------
-- Step 6: Emergency Last Resort (Only If Replication Is Abandoned)
-- ------------------------------------------------------------
-- WARNING:
-- Dropping slot will immediately release WAL retention,
-- but replication will stop and may require full reinitialization.

-- Drop replication slot ONLY if replication will not resume:

-- SELECT pg_drop_replication_slot('db002_replication_slot');


-- ------------------------------------------------------------
-- Step 7: Emergency Cleanup of Publication (If Fully Decommissioned)
-- ------------------------------------------------------------

-- DROP PUBLICATION db002_publication;


-- ------------------------------------------------------------
-- Step 8: Post-Recovery Verification
-- ------------------------------------------------------------

-- Confirm slots remaining
SELECT * FROM pg_replication_slots;

-- Confirm publications remaining
SELECT * FROM pg_publication;


-- ============================================================
-- End of Script
-- ============================================================
