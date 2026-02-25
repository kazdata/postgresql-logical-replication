# Lessons Learned and Best Practices
PostgreSQL Logical Replication (Publication + Replication Slot)

This document summarizes key lessons learned during the development and
testing of PostgreSQL logical replication using Informatica CDC.

It also provides best practices for long-term production stability.

---

## 1. Key Lessons Learned

### Replication Slots Retain WAL Until Consumed

Replication slots are powerful but risky if not managed correctly.

If Informatica or the application consumer stops, WAL logs will accumulate,
which can quickly lead to storage alerts and operational incidents.

Slot lag monitoring is mandatory.

---

### Replica Identity FULL Is Often Required for CDC Tools

Informatica requires before-image values for UPDATE and DELETE operations.

For tables without primary keys, Replica Identity FULL is required:

```sql
ALTER TABLE public.table_name REPLICA IDENTITY FULL;
````

With...FULL identity increases WAL generation and overhead.

---

### Dropping Slots Should Not Be Normal Operations

In development, dropping replication slots is acceptable for cleanup.

In production, dropping slots should be treated as a last resort because:

* Replication stops immediately
* WAL retention behavior changes
* Reinitialization may be required

The primary fix is restoring Informatica consumption.

---

### Multi-Table Publications Are Easier to Manage

A single publication can include many tables, and tables can be added or removed
without recreating replication objects:

```sql
ALTER PUBLICATION db002_publication ADD TABLE public.new_table;
ALTER PUBLICATION db002_publication REMOVE TABLE public.old_table;
```

This is the recommended operational approach.

---

## 2. Best Practices for Production

### Always Monitor Slot Lag

Use slot lag in GB as the primary health metric:

```sql
SELECT slot_name,
       round((pg_current_wal_lsn() - restart_lsn)/1024/1024/1024, 2)
       AS slot_lag_gb
FROM pg_replication_slots;
```

Set clear thresholds:

* Warning: >= 5 GB
* Major: >= 15 GB
* Critical: >= 25 GB

---

### Define Informatica Operational Ownership Upfront

Production replication only works when the consumer team owns:

* Continuous log consumption
* Restart procedures
* Monitoring and alert response

DBA teams should not be expected to resolve lag by dropping slots.

---

### Limit Publication Scope

Only include tables that are truly required.

Over-replication increases WAL volume and storage risk.

Always validate publication membership:

```sql
SELECT * FROM pg_publication_tables;
```

---

### Prefer Primary Keys When Possible

Tables with primary keys can use Replica Identity DEFAULT, which is more efficient.

FULL identity should be used only when necessary.

---

### Test Restart and Recovery Before Go-Live

Before production rollout, confirm:

* Informatica consumer restart works
* Lag stabilizes after restart
* No uncontrolled WAL growth occurs
* Incident playbook is understood by both teams

---

## 3. Recommended Long-Term Improvements

* Automate replication lag alerts in LogicMonitor
* Implement consumer heartbeat checks
* Maintain a formal replication request intake process
* Review publication tables quarterly
* Build runbooks for on-call response

---

## Final Note

Logical replication is stable and scalable when supported by:

* Clear ownership
* Proactive monitoring
* Controlled publication scope
* Strong operational processes

This repository documents the complete approach from setup to production support.

```
