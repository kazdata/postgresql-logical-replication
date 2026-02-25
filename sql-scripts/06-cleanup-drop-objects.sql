-- ============================================================
-- Script: 06-cleanup-drop-objects.sql
-- Purpose: Clean up replication objects after testing
-- WARNING: Dropping slots will stop replication immediately
-- ============================================================

-- Step 1: Drop replication slot
SELECT pg_drop_replication_slot('db002_replication_slot');

-- Step 2: Drop publication
DROP PUBLICATION db002_publication;

-- Step 3: Confirm cleanup
SELECT * FROM pg_replication_slots;
SELECT * FROM pg_publication;

Commit;
