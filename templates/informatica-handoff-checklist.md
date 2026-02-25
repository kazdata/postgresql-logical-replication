# Informatica / Application Handoff Checklist
Logical Replication (PostgreSQL)

This checklist defines the responsibilities and validation steps for the
Informatica/Application team when consuming PostgreSQL logical replication.

The goal is to prevent WAL backlog, storage alerts, and replication outages.

---

## 1. Replication Objects Provided by DBA Team

The DBA team has created the following:

- Publication: db002_publication
- Replication Slot: db002_replication_slot
- Tables Included: table1 through table6 (as agreed)

The Informatica process is expected to consume changes continuously.

---

## 2. Informatica Team Responsibilities

The Informatica/Application team owns:

- Continuous CDC log consumption
- Monitoring job health and lag
- Restart and recovery procedures
- Alert response when replication falls behind

Replication slots retain WAL logs until Informatica consumes them.

If Informatica stops, WAL will accumulate and storage incidents can occur.

---

## 3. Pre-Go-Live Validation

Before enabling production replication, confirm:

- Informatica CDC job starts successfully
- Logs are being consumed in real time
- No growing backlog is observed
- Restart procedures are tested

---

## 4. Required Monitoring on Informatica Side

Informatica team must monitor:

- CDC job running status
- Throughput and latency
- Polling/heartbeat frequency
- Failure retries and reconnect behavior

If the consumer is down, WAL will grow rapidly.

---

## 5. Common Failure Scenarios

| Scenario | Result |
|---------|--------|
| Informatica job stopped | WAL backlog builds up |
| Network interruption | Slot becomes inactive |
| Subscriber lagging | Slot lag increases |
| High volume updates | WAL spikes quickly |

---

## 6. Alert Expectations

The following conditions require action:

- Slot lag >= 5 GB (Warning)
- Slot lag >= 15 GB (Major)
- Slot lag >= 25 GB (Critical)

If alerts trigger, Informatica team should respond immediately.

DBA slot drop is last resort.

---

## 7. Recovery Actions (Informatica First Response)

If lag is increasing:

1. Confirm Informatica CDC process is running
2. Restart the replication consumer job
3. Validate connectivity to PostgreSQL
4. Confirm lag stops growing

DBA team should not be asked to drop slots unless replication is abandoned.

---

## 8. DBA Escalation Criteria

Escalate to DBA team only if:

- Lag continues after Informatica restart
- Slot remains inactive for extended period
- Storage risk becomes critical
- Publication/table changes are required

---

## 9. Production Support Agreement

For production deployment, both teams must agree on:

- Ownership of monitoring and alerts
- On-call escalation path
- Restart and recovery responsibilities
- Slot drop approval process

---

## Final Note

Logical replication works reliably in production when:

- Informatica consumes WAL continuously
- Monitoring is proactive
- Slot drops are avoided except emergencies

This checklist ensures clear operational ownership and stability.
