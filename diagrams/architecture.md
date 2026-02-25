# Architecture Diagram (Logical Replication)

This diagram represents the environment architecture
and operational flow.
It highlights core components.

```mermaid
flowchart LR
  A[App Tables] -->|WAL changes| B[PostgreSQL Primary]
  B --> C[Publication]
  C --> D[Logical Replication Slot]
  D --> E[CDC Consumer\nInformatica]
  E --> F[Target System]
  B --> G[Monitoring\nSlot Lag / WAL Growth]
````
