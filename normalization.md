# Normalization Report

This document explains how the ALX Airbnb database design was normalized (1NF → 3NF). It documents violations found in the initial conceptual design and the changes made to reach 3NF.

## Quick contract

- Inputs: conceptual entity list and attributes (users, properties, bookings, payments, etc.)
- Outputs: tables in 3NF, foreign keys to preserve relationships, atomic attributes
- Error modes: partial or transitive dependencies causing redundancy

## 1NF (First Normal Form)

- Ensure each table has atomic columns. No arrays or comma-separated values.
- Primary keys exist for each table (UUIDs).

Violations to avoid:

- Storing multiple image URLs in a single `properties.images` column — fixed by `property_images` table.

## 2NF (Second Normal Form)

- Applies when a table has a composite primary key. All non-key attributes must depend on the full key.

Potential violation:

- If we modeled `property_amenities` incorrectly (e.g., storing amenity details inside the junction table), that would violate 2NF. We keep `amenities` as a separate table and `property_amenities` as a pure junction table (PK: property_id, amenity_id).

## 3NF (Third Normal Form)

- No transitive dependencies: non-key columns must not depend on other non-key columns.

Examples and fixes:

- Bad: Storing `city` and `country` as free text in `properties` while also storing `country` derived from `city` in another table.
  Fix: Keep address attributes on `properties` and, if normalization of locations is required, move repeated location data into a `locations` table and reference it via FK.

- Bad: Storing `host_name` on `properties` when `host` is a user reference.
  Fix: Use `host_id` foreign key referencing `users(user_id)`; derive names via JOINs.

## Final design justification (3NF)

- Each entity has a primary key (UUID) and atomic attributes.
- Many-to-many relationships are modeled with junction tables (`property_amenities`, `favorites`).
- Repeating groups (images, amenities) are extracted into dedicated tables.
- Derived data is not stored; it can be computed via queries (e.g., average_rating computed from `reviews`).

## Edge cases considered

- Historical pricing: store price at booking time (`bookings.total_amount`) rather than relying on `properties.price_per_night` to avoid historical distortion.
- Payments: bookings may have multiple payment attempts; payments link to bookings by FK.

## Conclusion

The implemented schema (see `database-script-0x01/schema.sql`) follows 1NF, 2NF and 3NF principles. The schema avoids redundancy and uses foreign keys and junction tables to represent relationships.
