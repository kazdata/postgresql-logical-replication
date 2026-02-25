-- ============================================================
-- Script: 02-create-replication-slot.sql
-- Purpose: Create one logical replication slot
-- Slot Name: db002_replication_slot
-- Plugin: pgoutput
-- ============================================================

SELECT pg_create_logical_replication_slot(
    'db002_replication_slot',
    'pgoutput'
);

-- Verify replication slot exists
SELECT *
FROM pg_replication_slots
WHERE slot_name = 'db002_replication_slot';

Commit;
