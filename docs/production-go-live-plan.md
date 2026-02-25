# Production Go-Live Plan
PostgreSQL Logical Replication (Publication + Replication Slot)

This document defines the step-by-step go-live approach for enabling
PostgreSQL logical replication in the Production environment.

Goal: Deploy replication safely with clear monitoring, ownership, and rollback.

---

## 1. Objective

Enable logical replication for approved PostgreSQL tables in Production using:

- One publication (multi-table)
- One logical replication slot
- Informatica/Application CDC consumer

Replication must run continuously without WAL backlog incidents.

---

## 2. Scope

Included:

- Publication: db002_publication
- Slot: db002_replication_slot
- Approved replication tables (final list)

Out of scope:

- Ad-hoc table additions without request intake approval
- Slot drops as standard operations

---

## 3. Pre-Go-Live Requirements

### Database Readiness

Confirm:

- wal_level is logical

```sql
SHOW wal_level;
````

* max_replication_slots is sufficient
* WAL storage monitoring is enabled

---

### Table Readiness

For each replicated table:

* Primary key exists (preferred)
* If no PK, Replica Identity FULL documented

```sql
ALTER TABLE public.table_name REPLICA IDENTITY FULL;
```

---

### Informatica/Application Readiness

Confirm Informatica team has:

* Continuous CDC job configured
* Restart procedures tested
* Monitoring alerts enabled
* Ownership agreement documented

---

## 4. Staging Validation (Required Before Prod)

Replication must be tested in staging with production-like volume:

* Slot lag remains stable
* WAL does not grow uncontrollably
* Informatica consumption is consistent
* Restart test succeeds

---

## 5. Production Implementation Steps

### Step 1: Create Publication

```sql
CREATE PUBLICATION db002_publication
FOR TABLE public.table1, public.table2, public.table3;
```

Verify:

```sql
SELECT * FROM pg_publication_tables
WHERE publication = 'db002_publication';
```

---

### Step 2: Create Replication Slot

```sql
SELECT pg_create_logical_replication_slot(
  'db002_replication_slot',
  'pgoutput'
);
```

Verify:

```sql
SELECT * FROM pg_replication_slots
WHERE slot_name = 'db002_replication_slot';
```

---

### Step 3: Grant Permissions

```sql
GRANT SELECT ON ALL TABLES IN SCHEMA public TO test_dev_info_ro;
GRANT USAGE ON PUBLICATION db002_publication TO test_dev_info_ro;
```

---

### Step 4: Informatica Consumer Activation

Informatica team starts CDC process and confirms:

* Consumer connected
* Logs consumed continuously

DBA validates slot activity:

```sql
SELECT slot_name, active
FROM pg_replication_slots;
```

---

## 6. Go-Live Monitoring Window

For the first 24–48 hours, monitor closely:

### Slot Lag in GB

```sql
SELECT slot_name,
       round((pg_current_wal_lsn() - restart_lsn)/1024/1024/1024, 2)
       AS slot_lag_gb
FROM pg_replication_slots;
```

Alert thresholds:

* Warning: >= 5 GB
* Major: >= 15 GB
* Critical: >= 25 GB

---

## 7. Rollback / Emergency Plan

Rollback is only required if replication must be abandoned.

### Preferred Fix

* Informatica restart
* Network recovery
* Subscriber validation

Slot drop is last resort.

### Emergency Slot Drop (DBA Lead Approval)

```sql
SELECT pg_drop_replication_slot('db002_replication_slot');
```

### Publication Removal (Decommission Only)

```sql
DROP PUBLICATION db002_publication;
```

---

## 8. Post-Go-Live Success Criteria

Replication is considered stable when:

* Slot remains active
* Lag stays within threshold
* WAL storage growth is controlled
* Informatica job runs continuously
* No repeated storage incidents occur

---

## 9. Ownership and Support Model

* Informatica team owns consumer health and log consumption
* DBA team owns publication/slot configuration
* Slot drops require joint approval

---

## Final Note

Production logical replication is successful when monitoring, ownership,
and recovery processes are established upfront.

This go-live plan ensures a controlled rollout with minimal operational risk.

```
