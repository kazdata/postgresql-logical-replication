# PostgreSQL Logical Replication SOP

This repository contains a step-by-step Standard Operating Procedure (SOP) for setting up PostgreSQL logical replication using:

- One publication for multiple tables
- One logical replication slot
- Required permissions for application or Informatica users
- Monitoring and troubleshooting for WAL backlog
- Cleanup and production considerations

This guide was created based on a real replication implementation and testing activity in a non-production environment, with focus on production readiness.

---

## Project Goal

To provide a repeatable and documented approach for enabling logical replication for selected PostgreSQL tables, supporting use cases such as:

- Informatica CDC pipelines
- Application-level replication consumers
- Data movement between environments
- Controlled replication testing

---

## Key Objects Used

Example naming convention:

- Publication: `db002_publication`
- Replication Slot: `db002_replication_slot`

---

## What This SOP Covers

- PostgreSQL configuration prerequisites (`wal_level=logical`)
- Creating a publication for multiple tables
- Creating a single replication slot
- Granting required privileges
- Setting replica identity when needed (`REPLICA IDENTITY FULL`)
- Monitoring replication lag and WAL growth
- Safe cleanup steps after testing
- Production best practices to avoid storage alerts

---

## Repository Structure

postgresql-logical-replication/

<img width="568" height="649" alt="image" src="https://github.com/user-attachments/assets/bdb352fa-c5b2-4de8-9aa6-b6ebef55ae60" />


---

## Project Navigation

- [Project Overview](PROJECT_OVERVIEW.md)
- [Main SOP](docs/SOP-Logical-Replication.md)
- [Production Readiness Checklist](docs/production-readiness.md)
- [Monitoring + WAL Troubleshooting](docs/monitoring-wal-troubleshooting.md)
- [On-Call Incident Playbook](docs/on-call-incident-playbook.md)
- [Go-Live Plan](docs/production-go-live-plan.md)
- [Lessons Learned](docs/lessons-learned-and-best-practices.md)

---

## Architecture Diagram

See detailed architecture here:

[View Architecture Diagram](./diagrams/architecture.md)


