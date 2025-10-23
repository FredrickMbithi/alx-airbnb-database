# Seed README

This folder contains `seed.sql`, a script that inserts realistic test data into the schema created by `database-script-0x01/schema.sql`.

What the seed includes:

- Users with different roles: host, guest, admin
- A property owned by a host, with images and amenities
- Bookings: confirmed (future), cancelled (edge case), completed (past)
- Payments: succeeded, refunded; demonstrates multiple payment scenarios
- A review by a guest

How to run (PowerShell example):

```powershell
# ensure database exists and schema applied
psql -d alx_airbnb_db -f database-script-0x01/schema.sql
# run seed
psql -d alx_airbnb_db -f database-script-0x02/seed.sql
```

Notes and safety:

- The script uses simple SELECT subqueries to resolve FK values by unique emails or titles. If you re-run the seed multiple times against the same DB you may create duplicate records; prefer running against a fresh database or wrap the run in a test-specific database.
- The seed script uses realistic dates (past and future) to exercise booking status logic.

If you want idempotent seeds, consider adding checks (e.g., INSERT ... ON CONFLICT DO NOTHING with unique constraints) or write idempotent `upsert` logic.
