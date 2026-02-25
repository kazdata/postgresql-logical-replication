# Production Readiness Checklist for Logical Replication

This checklist helps ensure logical replication can run safely in production without repeated manual slot drops.

---

## Database Configuration

- Confirm WAL settings:

  ```sql
  SHOW wal_level;

- Expected: logical
  - Ensure capacity is set:
  - max_replication_slots
  - max_wal_senders
  - WAL storage monitoring enabled

---

## Content:
- slot lag alert thresholds
- Informatica consumption expectations
- storage risk handling
