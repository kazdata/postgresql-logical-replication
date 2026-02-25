-- ============================================================
-- File: example-slot-lag-check.sql
-- Purpose: Monitor logical replication slot lag and WAL retention
-- Environment: PostgreSQL 10+
-- ============================================================

-- 1. Basic Slot Overview

SELECT
    slot_name,
    slot_type,
    active,
    plugin,
    restart_lsn,
    confirmed_flush_lsn
FROM pg_replication_slots
ORDER BY slot_name;


-- 2. WAL Retained by Each Slot (Human Readable)

SELECT
    slot_name,
    active,
    pg_size_pretty(pg_current_wal_lsn() - restart_lsn) AS retained_wal,
    round(
        (pg_current_wal_lsn() - restart_lsn)
        / 1024 / 1024 / 1024,
        2
    ) AS retained_wal_gb
FROM pg_replication_slots
ORDER BY retained_wal_gb DESC;


-- 3. Identify Inactive Logical Slots (High Risk)

SELECT
    slot_name,
    slot_type,
    active
FROM pg_replication_slots
WHERE slot_type = 'logical'
AND active = false;


-- 4. Detect Slots Exceeding Threshold (Example: 2 GB)

SELECT
    slot_name,
    round(
        (pg_current_wal_lsn() - restart_lsn)
        / 1024 / 1024 / 1024,
        2
    ) AS retained_wal_gb
FROM pg_replication_slots
WHERE (pg_current_wal_lsn() - restart_lsn)
      > (2 * 1024 * 1024 * 1024);


-- 5. Replication Sender Status (Primary Only)

SELECT
    client_addr,
    state,
    sync_state,
    write_lag,
    flush_lag,
    replay_lag
FROM pg_stat_replication;


-- 6. Operational Notes
--
-- - WAL backlog growth indicates consumer is not keeping up.
-- - Logical slots retain WAL indefinitely until consumed.
-- - Dropping a slot may cause data loss for CDC tools.
-- - Always validate business impact before slot removal.

