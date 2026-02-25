-- ============================================================
-- Script: 09-alert-threshold-recommendations.sql
-- Purpose: Recommended alert thresholds for logical replication
--          slot lag and WAL backlog monitoring
--
-- Use Case:
-- Prevent storage incidents caused by stalled replication slots
-- (LogicMonitor / PagerDuty alerts)
--
-- NOTE:
-- Thresholds should be tuned based on workload and WAL volume.
-- ============================================================


-- ------------------------------------------------------------
-- Step 1: Monitor Slot Lag in GB (Primary Metric)
-- ------------------------------------------------------------

SELECT slot_name,
       now() AS time_now,
       round((pg_current_wal_lsn() - restart_lsn)/1024/1024/1024, 2)
       AS slot_lag_gb
FROM pg_replication_slots;


-- ------------------------------------------------------------
-- Step 2: Recommended Alert Threshold Levels
-- ------------------------------------------------------------

-- Slot Lag Alerting (General Guidance)

-- WARNING LEVEL:
-- slot_lag_gb >= 5 GB
-- Action: Notify DBA + Informatica team to check consumer health

-- HIGH / MAJOR LEVEL:
-- slot_lag_gb >= 15 GB
-- Action: Immediate Informatica restart + escalation

-- CRITICAL LEVEL:
-- slot_lag_gb >= 25 GB (or rapid growth)
-- Action: PagerDuty on-call, storage risk imminent


-- ------------------------------------------------------------
-- Step 3: Detect Inactive Slots (High Risk Condition)
-- ------------------------------------------------------------

SELECT slot_name,
       active
FROM pg_replication_slots
WHERE active = false;


-- Recommended Alert:
-- If slot remains inactive > 10 minutes → raise warning
-- If slot remains inactive > 30 minutes → escalate


-- ------------------------------------------------------------
-- Step 4: Publication Scope Validation (Avoid Over-Replication)
-- ------------------------------------------------------------

SELECT *
FROM pg_publication_tables
WHERE publication = 'db002_publication';


-- Best Practice:
-- Only replicate tables required for the business use case.
-- Extra tables increase WAL generation and storage usage.


-- ------------------------------------------------------------
-- Step 5: Operational Recommendations for Monitoring Tools
-- ------------------------------------------------------------

-- LogicMonitor / PagerDuty should track:

-- 1. Slot lag growth (GB)
-- 2. WAL disk usage percentage
-- 3. Replication slot active/inactive status
-- 4. Informatica CDC job heartbeat
-- 5. Sudden WAL spikes after bulk loads


-- ------------------------------------------------------------
-- Step 6: Suggested Incident Response Workflow
-- ------------------------------------------------------------

-- If WARNING triggered (>= 5 GB):
-- - Check Informatica is running
-- - Validate slot is active

-- If MAJOR triggered (>= 15 GB):
-- - Restart Informatica consumer process
-- - Confirm lag stops growing

-- If CRITICAL triggered (>= 25 GB):
-- - Escalate to on-call DBA + storage team
-- - Prepare emergency slot cleanup only if replication is abandoned


-- ------------------------------------------------------------
-- Step 7: Slot Cleanup is Last Resort
-- ------------------------------------------------------------

-- DO NOT drop slots as first response in production.
-- Only drop if replication is permanently stopped.

-- SELECT pg_drop_replication_slot('db002_replication_slot');


-- ============================================================
-- End of Script
-- ============================================================
