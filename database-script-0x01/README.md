# Schema README

This folder contains the Postgres schema for the ALX Airbnb database.

Files:

- `schema.sql` — DDL for tables, types, indexes, and a helpful view.

Design choices summary:

- UUID PKs (generated using `uuid_generate_v4()`) to mimic production-friendly, globally unique IDs.
- Enums for constrained values: `user_role`, `booking_status`, `payment_status`.
- Separate tables for repeating groups: `property_images`, `amenities`, `property_amenities` (junction table).
- `bookings.total_amount` stores the price at booking time (historical price snapshot).
- `payments` can record multiple attempts for the same booking.

How to apply (local Postgres):

1. Create or select your database. Example PowerShell commands:

```powershell
createdb alx_airbnb_db
psql -d alx_airbnb_db -f database-script-0x01/schema.sql
```

2. Confirm the extensions and types were created. The script is idempotent (it uses IF NOT EXISTS where appropriate).

Notes & next steps:

- If you plan to use a different UUID generator (e.g., `pgcrypto`), adapt the extension and defaults accordingly.
- Consider adding partial indexes or full-text search indexes later for text-heavy queries (title, description).
- Run tests/seed script: see `database-script-0x02/README.md`.
