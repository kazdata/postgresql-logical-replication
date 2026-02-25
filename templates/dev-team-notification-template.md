# Developer Notification Template
PostgreSQL Logical Replication Setup

Use this template to notify the development team after replication objects
(publication + slot) have been created successfully.

---

## Subject
PostgreSQL Logical Replication Setup Completed – Publication and Slot Details

---

## Message Template

Hi Team,

Logical replication has been configured successfully in the PostgreSQL database.

Below are the replication details for your reference:

---

### Database Environment
- Database: CEV-Nonprod (or Prod)
- Replication Type: Logical Replication (CDC)

---

### Publication Information
- Publication Name: db002_publication
- Tables Included:

  - public.table1  
  - public.table2  
  - public.table3  
  - public.table4  
  - public.table5  
  - public.table6  

---

### Replication Slot Information
- Replication Slot Name: db002_replication_slot
- Output Plugin: pgoutput

---

### Access / Permissions
The following replication consumer user has been granted the required access:

- User: test_dev_info_ro
- Privileges: SELECT on all published tables

---

### Replica Identity Note (Important)

For UPDATE and DELETE operations, replica identity has been set as needed:

```sql

ALTER TABLE public.table_name REPLICA IDENTITY FULL;

---

## Monitoring Reminder

- Please ensure the replication consumer process (Informatica/application) remains active.

- If logs are not consumed, WAL backlog can grow and trigger storage alerts.

- DBA team will monitor replication slot lag as part of operational support.

- Let us know once application-side testing is complete or if additional tables need to be added to the publication.

Thanks,
DB Engineering Team
