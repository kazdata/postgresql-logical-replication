# On-Call Incident Playbook
PostgreSQL Logical Replication Slot WAL Backlog

This playbook is used when an alert is triggered due to replication slot lag
or excessive WAL log growth.

Common alert sources:

- LogicMonitor storage alerts
- PagerDuty critical incidents
- Informatica CDC job failures

Goal: Restore log consumption safely without dropping slots unless required.

---

## 1. Incident Trigger Examples

This playbook applies when you see alerts such as:

- Replication slot lag increasing rapidly
- WAL disk usage above threshold
- Storage volume nearing capacity
- Informatica consumer disconnected
- Slot inactive for extended period

---

## 2. Immediate First Response (First 5 Minutes)

### Step 1: Confirm Slot Lag

Run:

```sql
SELECT slot_name,
       now() AS time_now,
       round((pg_current_wal_lsn() - restart_lsn)/1024/1024/1024, 2)
       AS slot_lag_gb
FROM pg_replication_slots;
````

If lag is growing quickly, replication consumer is not keeping up.

---

### Step 2: Check Slot Activity

```sql
SELECT slot_name,
       active
FROM pg_replication_slots;
```

* active = true → consumer connected
* active = false → consumer disconnected (high risk)

---

### Step 3: Identify Publication Scope

```sql
SELECT *
FROM pg_publication_tables
WHERE publication = 'db002_publication';
```

Confirm only required tables are being replicated.

---

## 3. Notify Informatica/Application Team (Immediate)

If slot lag is high, Informatica team must confirm:

* CDC job is running
* Consumer is connected
* No processing failures exist

Replication slots will retain WAL until Informatica consumes logs.

---

## 4. Recovery Actions (Preferred Order)

### Action 1: Restart Informatica CDC Job

This is the most common fix.

After restart, re-check lag:

```sql
SELECT slot_name,
       round((pg_current_wal_lsn() - restart_lsn)/1024/1024/1024, 2)
       AS slot_lag_gb
FROM pg_replication_slots;
```

Lag should stabilize or decrease.

---

### Action 2: Validate Network Connectivity

If Informatica cannot reach PostgreSQL:

* Confirm firewall rules
* Confirm endpoint availability
* Confirm credentials not expired

---

### Action 3: Confirm No Subscriber Outage

If subscriber database is down, logs will not be applied.

Informatica must restore subscriber health.

---

## 5. Escalation Threshold Guidance

| Lag Level | Severity | Required Action          |
| --------- | -------- | ------------------------ |
| >= 5 GB   | Warning  | Notify Informatica team  |
| >= 15 GB  | Major    | Restart CDC + escalate   |
| >= 25 GB  | Critical | PagerDuty + storage risk |

---

## 6. Last Resort Emergency Actions

### Slot Drop (Only If Replication Will NOT Resume)

Dropping a slot immediately releases WAL retention but stops replication.

DBA Lead approval required.

```sql
SELECT pg_drop_replication_slot('db002_replication_slot');
```

Only do this if:

* Informatica confirms replication is abandoned
* Storage is at critical risk
* Reinitialization is acceptable

---

### Publication Drop (Decommission Only)

```sql
DROP PUBLICATION db002_publication;
```

Only if replication is being permanently removed.

---

## 7. Post-Incident Validation

After recovery:

### Confirm Slot Health

```sql
SELECT slot_name, active
FROM pg_replication_slots;
```

### Confirm Lag Stabilized

```sql
SELECT slot_name,
       round((pg_current_wal_lsn() - restart_lsn)/1024/1024/1024, 2)
       AS slot_lag_gb
FROM pg_replication_slots;
```

### Document Incident Outcome

* Root cause (consumer stopped, network issue, etc.)
* Actions taken
* Preventative improvement

---

## 8. Key Operational Rule

Dropping replication slots is NOT normal operations.

The primary fix is restoring Informatica log consumption.

NOTE: This playbook ensures safe and consistent response during production incidents.

```
