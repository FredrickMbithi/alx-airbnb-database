-- ============================================================
-- Database Index Creation Script
-- ALX Airbnb Database Project
-- ============================================================
-- This script creates indexes for high-usage columns identified
-- in User, Booking, and Property tables to improve query performance.

-- ============================================================
-- USER TABLE INDEXES
-- ============================================================
-- Note: idx_users_email already exists in schema.sql

-- Index on role for filtering users by role (host, guest, admin)
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- Index on created_at for sorting/filtering by registration date
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- Composite index for name searches
CREATE INDEX IF NOT EXISTS idx_users_names ON users(first_name, last_name);


-- ============================================================
-- BOOKING TABLE INDEXES
-- ============================================================
-- Note: The following indexes already exist in schema.sql:
-- - idx_bookings_property_id
-- - idx_bookings_guest_id
-- - idx_bookings_dates (start_date, end_date)

-- Index on status for filtering bookings by status
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);

-- Index on created_at for recent bookings queries
CREATE INDEX IF NOT EXISTS idx_bookings_created_at ON bookings(created_at);

-- Composite index for user booking history with date filtering
CREATE INDEX IF NOT EXISTS idx_bookings_guest_dates ON bookings(guest_id, start_date);

-- Composite index for property availability checks
CREATE INDEX IF NOT EXISTS idx_bookings_property_dates_status ON bookings(property_id, start_date, end_date, status);


-- ============================================================
-- PROPERTY TABLE INDEXES
-- ============================================================
-- Note: The following indexes already exist in schema.sql:
-- - idx_properties_host_id
-- - idx_properties_city

-- Index on price for range queries and sorting
CREATE INDEX IF NOT EXISTS idx_properties_price ON properties(price_per_night);

-- Index on country for location-based searches
CREATE INDEX IF NOT EXISTS idx_properties_country ON properties(country);

-- Composite index for location-based searches
CREATE INDEX IF NOT EXISTS idx_properties_location ON properties(country, city);

-- Index on created_at for sorting by newest listings
CREATE INDEX IF NOT EXISTS idx_properties_created_at ON properties(created_at);

-- Composite index for price range queries with location
CREATE INDEX IF NOT EXISTS idx_properties_city_price ON properties(city, price_per_night);


-- ============================================================
-- PAYMENT TABLE INDEXES
-- ============================================================
-- Note: idx_payments_booking_id already exists in schema.sql

-- Index on status for payment status queries
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);

-- Index on created_at for payment history
CREATE INDEX IF NOT EXISTS idx_payments_created_at ON payments(created_at);


-- ============================================================
-- REVIEW TABLE INDEXES
-- ============================================================
-- Note: idx_reviews_property_id already exists in schema.sql

-- Index on user_id for user's review history
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON reviews(user_id);

-- Index on rating for filtering by rating
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);

-- Index on created_at for recent reviews
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON reviews(created_at);


-- ============================================================
-- Commands to analyze index usage (run after data insertion)
-- ============================================================

-- To check if indexes are being used, run EXPLAIN on your queries:
-- EXPLAIN ANALYZE SELECT * FROM bookings WHERE guest_id = 'some-uuid';

-- To see index statistics in PostgreSQL:
-- SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
-- FROM pg_stat_user_indexes
-- WHERE schemaname = 'public'
-- ORDER BY idx_scan DESC;
