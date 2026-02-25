# Logical Replication Request Intake Form
(PostgreSQL → Informatica / Application CDC)

This form must be completed before DB Engineering sets up any new
logical replication publication or replication slot changes.

The goal is to ensure replication is planned, monitored, and production-safe.

---

## 1. Request Details

- Requestor Name:
- Team / Application:
- Environment:
  - Dev
  - QA
  - Prod

- Business Reason for Replication:

---

## 2. Source Database Information

- Database Name: (Add here)
- AWS Platform:
  - RDS PostgreSQL
  - Aurora PostgreSQL
  - Self-Managed PostgreSQL

- Source Host / Cluster:  (Add here)

---

## 3. Tables Requested for Replication

List all required tables below:

| Schema | Table Name | Primary Key Exists? (Y/N) | Notes |
|-------|------------|--------------------------|------|
| public | table1     | Y/N                      |      |
| public | table2     | Y/N                      |      |
| public | table3     | Y/N                      |      |

Important:
- Tables without primary keys may require:
  REPLICA IDENTITY FULL

---

## 4. Replica Identity Requirements

Does the application require before-image values for UPDATE/DELETE?

- Yes (Replica Identity FULL may be required)
- No

---

## 5. Consumer / Informatica Details

- Consumer Tool:
  - Informatica
  - Custom Application
  - Other

- Consumer Owner Contact:
- Expected Consumption Frequency:
  - Near real-time
  - Batch (hourly)
  - Daily

---

## 6. Monitoring and Alert Ownership

Replication slots retain WAL logs until consumed.

Who owns first response if lag increases?

- Informatica/Application Team
- DBA Team
- Shared On-Call

PagerDuty escalation contact:

---

## 7. Expected Duration

- Is this replication temporary testing only?
  - Yes
  - No (Production permanent)

If temporary, expected end date:

---

## 8. DBA Implementation Checklist (Internal)

DBA team will confirm:

- Publication created/updated
- Replication slot created
- Permissions granted
- Replica identity set correctly
- Monitoring thresholds reviewed
- Production readiness approved

---

## 9. Approval

Replication setup in Production requires approval from:

- Application Owner
- DBA Lead
- Platform/Storage Team (if needed)

Approval Date:

---

## Final Note

Replication stability depends on continuous WAL consumption.

Dropping replication slots in production is a last resort.
This intake form ensures proper planning and operational ownership.
