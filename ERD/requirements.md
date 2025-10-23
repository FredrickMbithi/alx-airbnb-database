# ER Diagram & Requirements

This file contains the ER diagram placeholder and explanations for the ALX Airbnb Database module.

## ER Diagram (placeholder)

Add your ER diagram export (PNG/SVG/JPG) here. Recommended filename: `ERD/airbnb-erd.png` or `ERD/airbnb-erd.svg`.

If you cannot include the image in the repository, paste a link to the hosted image here.

### Entities (high-level)

- users
- properties
- property_images
- amenities
- property_amenities (junction table)
- bookings
- payments
- reviews
- favorites

### Key relationships (high level)

- User (host) 1 --- \* Property
- Property 1 --- \* PropertyImage
- Property _ --- _ Amenity (via property_amenities)
- User (guest) 1 --- \* Booking
- Booking \* --- 1 Property
- Booking 1 --- \* Payment (a booking may have multiple payment attempts)
- User 1 --- \* Review (a user may write many reviews)
- Property 1 --- \* Review

Place the exported ER diagram image next to this file and write any diagram notes below the image.

---

Notes:

- Use UUIDs for primary keys to match production-like setups.
- Enforce referential integrity with foreign keys and add indexes on FK columns and commonly queried fields (email, property location, booking dates).

Files added in this repository to complete the module:

- `normalization.md` — normalization analysis and decisions
- `database-script-0x01/schema.sql` — DDL (Postgres)
- `database-script-0x01/README.md` — schema rationale and apply instructions
- `database-script-0x02/seed.sql` — seed data with realistic examples and edge cases
- `database-script-0x02/README.md` — seeding strategy and how to run safely

Put your ER diagram image in this folder and reference it above.
