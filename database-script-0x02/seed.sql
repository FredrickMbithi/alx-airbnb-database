-- Seed data for ALX Airbnb Database
-- Run after the schema: psql -d <db_name> -f database-script-0x02/seed.sql

BEGIN;

-- Insert users
INSERT INTO users (email, password_hash, first_name, last_name, role)
VALUES
  ('john@example.com','hashed_pw_john','John','Doe','host'),
  ('jane@example.com','hashed_pw_jane','Jane','Smith','guest'),
  ('admin@airbnb.com','hashed_pw_admin','Admin','User','admin');

-- Insert amenities
INSERT INTO amenities (name) VALUES
  ('Wifi'), ('Kitchen'), ('Air conditioning'), ('Washer'), ('Free parking');

-- Insert a property owned by John (host)
INSERT INTO properties (host_id, title, description, price_per_night, currency, street, city, state, country, postal_code, max_guests, latitude, longitude)
VALUES (
  (SELECT user_id FROM users WHERE email='john@example.com'),
  'Cozy Studio in Nairobi',
  'Perfect for solo travelers',
  45.00,
  'KES',
  '1 Studio St',
  'Nairobi',
  'Nairobi County',
  'Kenya',
  '00100',
  2,
  -1.2921,
  36.8219
);

-- Link amenities to the property
INSERT INTO property_amenities (property_id, amenity_id)
SELECT p.property_id, a.amenity_id
FROM properties p
JOIN amenities a ON a.name IN ('Wifi','Kitchen')
WHERE p.title = 'Cozy Studio in Nairobi';

-- Add property images
INSERT INTO property_images (property_id, url, caption, ordinal)
SELECT property_id, 'https://example.com/images/studio1.jpg', 'Front view', 1 FROM properties WHERE title='Cozy Studio in Nairobi';

-- Insert a confirmed booking in the future
INSERT INTO bookings (property_id, guest_id, start_date, end_date, total_amount, status)
VALUES (
  (SELECT property_id FROM properties WHERE title='Cozy Studio in Nairobi'),
  (SELECT user_id FROM users WHERE email='jane@example.com'),
  '2025-11-15',
  '2025-11-20',
  45.00 * 5,
  'confirmed'
);

-- Payment for the confirmed booking
INSERT INTO payments (booking_id, amount, currency, status, provider, provider_payment_id)
VALUES (
  (SELECT booking_id FROM bookings WHERE guest_id=(SELECT user_id FROM users WHERE email='jane@example.com') ORDER BY created_at DESC LIMIT 1),
  225.00,
  'KES',
  'succeeded',
  'stripe',
  'pay_001'
);

-- Insert a cancelled booking (edge case: no succeeded payment)
INSERT INTO bookings (property_id, guest_id, start_date, end_date, total_amount, status)
VALUES (
  (SELECT property_id FROM properties WHERE title='Cozy Studio in Nairobi'),
  (SELECT user_id FROM users WHERE email='jane@example.com'),
  '2024-06-01',
  '2024-06-05',
  180.00,
  'cancelled'
);

-- Insert a past completed booking and a refunded payment
INSERT INTO bookings (property_id, guest_id, start_date, end_date, total_amount, status)
VALUES (
  (SELECT property_id FROM properties WHERE title='Cozy Studio in Nairobi'),
  (SELECT user_id FROM users WHERE email='jane@example.com'),
  '2023-01-10',
  '2023-01-15',
  225.00,
  'completed'
);

INSERT INTO payments (booking_id, amount, currency, status, provider, provider_payment_id)
VALUES (
  (SELECT booking_id FROM bookings WHERE status='completed' AND guest_id=(SELECT user_id FROM users WHERE email='jane@example.com') ORDER BY created_at DESC LIMIT 1),
  225.00,
  'KES',
  'refunded',
  'stripe',
  'pay_002'
);

-- Add a review for the property
INSERT INTO reviews (property_id, user_id, rating, comment)
VALUES (
  (SELECT property_id FROM properties WHERE title='Cozy Studio in Nairobi'),
  (SELECT user_id FROM users WHERE email='jane@example.com'),
  5,
  'Great stay — clean, central and affordable.'
);

COMMIT;

-- End of seed script
