# Informatica Operational Ownership
PostgreSQL Logical Replication (Production Support Model)

This document defines the operational responsibilities of the
Informatica/Application team when consuming PostgreSQL logical replication.

The goal is to ensure replication runs safely in production without repeated
manual DBA intervention.

---

## 1. Background

PostgreSQL logical replication uses:

- Publications (table scope)
- Replication slots (WAL retention)

Replication slots retain WAL logs until the consumer (Informatica) reads them.

If Informatica stops consuming logs, WAL backlog grows and storage alerts occur.

---

## 2. Ownership Model

| Area | Primary Owner | DBA Support Role |
|------|--------------|------------------|
| CDC consumer process health | Informatica Team | Consult only |
| Log consumption continuity | Informatica Team | Monitor lag |
| Restart and recovery actions | Informatica Team | Assist if needed |
| Slot configuration and setup | DBA Team | Primary |
| Publication table changes | DBA Team | Primary |
| Storage incident escalation | Shared | Joint response |

---

## 3. Informatica Daily Operational Responsibilities

Informatica team must ensure:

- CDC job is running continuously
- Replication lag is not increasing
- Failures are detected and addressed quickly
- Retry/reconnect logic is functioning
- Subscriber systems are healthy

Replication should not depend on manual DBA cleanup.

---

## 4. Required Monitoring (Informatica Side)

Informatica team must monitor:

- Job running status
- Throughput and latency
- Last successful replication timestamp
- Connectivity to PostgreSQL
- Failure retry events

Any consumer downtime will directly cause WAL backlog.

---

## 5. Alert Response Expectations

When alerts occur:

### Warning Level (>= 5 GB lag)

- Informatica team investigates immediately
- Confirm consumer is connected and running

### Major Level (>= 15 GB lag)

- Restart CDC process
- Escalate to application support

### Critical Level (>= 25 GB lag)

- PagerDuty escalation
- Immediate action required to prevent storage exhaustion

---

## 6. Standard Recovery Actions (Informatica First)

If replication lag increases, Informatica team should:

1. Confirm CDC job is active
2. Restart Informatica consumer process
3. Validate network connectivity
4. Confirm subscriber availability
5. Re-check lag stabilization

DBA slot drop should not be the first response.

---

## 7. DBA Escalation Criteria

Escalate to DBA team only if:

- Slot remains inactive after Informatica restart
- Lag continues growing despite recovery attempts
- Publication/table changes are required
- Production storage risk is critical

---

## 8. Slot Drop Policy (Production)

Dropping replication slots is a last resort.

Slot drops require:

- DBA Lead approval
- Informatica confirmation replication will not resume
- Acceptance that reinitialization may be required

Slot drop is not a normal operational fix.

---

## 9. Production Support Agreement

Before go-live, both teams must agree on:

- On-call ownership boundaries
- Restart procedures
- Monitoring responsibilities
- Escalation path
- Emergency approval process

Clear ownership ensures stable replication operations long-term.

---

## Final Note

Logical replication works reliably in production when the consumer
(Informatica) remains healthy and continuously consumes WAL logs.

This document establishes the operational model needed to prevent
repeat storage incidents and manual slot cleanup.
