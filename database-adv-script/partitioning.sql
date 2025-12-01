-- ============================================================
-- Table Partitioning for Large Tables
-- ALX Airbnb Database Project
-- ============================================================
-- This script implements partitioning on the Booking table
-- based on the start_date column to optimize query performance
-- for large datasets.

-- ============================================================
-- STEP 1: Create the partitioned table structure
-- ============================================================
-- In PostgreSQL, we need to create a new partitioned table
-- and migrate data from the original table.

-- Create the partitioned bookings table
CREATE TABLE bookings_partitioned (
    booking_id UUID DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    guest_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
    status booking_status DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    CHECK (end_date > start_date),
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);


-- ============================================================
-- STEP 2: Create partitions by year
-- ============================================================
-- Create partitions for different date ranges

-- Partition for 2023
CREATE TABLE bookings_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for 2024
CREATE TABLE bookings_2024 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Partition for 2025
CREATE TABLE bookings_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Partition for 2026 (future bookings)
CREATE TABLE bookings_2026 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

-- Default partition for any dates outside defined ranges
CREATE TABLE bookings_default PARTITION OF bookings_partitioned
    DEFAULT;


-- ============================================================
-- STEP 3: Create indexes on partitions
-- ============================================================
-- Indexes are automatically created on partitions when created on parent
-- But we can also create partition-specific indexes

-- Index on property_id (inherited by all partitions)
CREATE INDEX idx_bookings_part_property_id ON bookings_partitioned(property_id);

-- Index on guest_id (inherited by all partitions)
CREATE INDEX idx_bookings_part_guest_id ON bookings_partitioned(guest_id);

-- Index on status (inherited by all partitions)
CREATE INDEX idx_bookings_part_status ON bookings_partitioned(status);

-- Composite index for date range queries
CREATE INDEX idx_bookings_part_dates ON bookings_partitioned(start_date, end_date);


-- ============================================================
-- STEP 4: Migrate data from original table (if exists)
-- ============================================================
-- Uncomment and run this section to migrate existing data

-- INSERT INTO bookings_partitioned 
-- SELECT * FROM bookings;


-- ============================================================
-- STEP 5: Add foreign key constraints
-- ============================================================
-- Foreign keys need to be added after partition creation

ALTER TABLE bookings_partitioned
    ADD CONSTRAINT fk_bookings_part_property 
    FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE;

ALTER TABLE bookings_partitioned
    ADD CONSTRAINT fk_bookings_part_guest 
    FOREIGN KEY (guest_id) REFERENCES users(user_id) ON DELETE CASCADE;


-- ============================================================
-- STEP 6: Sample queries to test partition pruning
-- ============================================================

-- Query 1: Fetch bookings for a specific date range (uses partition pruning)
-- This query will only scan the relevant partition(s)
EXPLAIN ANALYZE
SELECT 
    booking_id,
    property_id,
    guest_id,
    start_date,
    end_date,
    total_amount,
    status
FROM 
    bookings_partitioned
WHERE 
    start_date BETWEEN '2024-06-01' AND '2024-08-31';


-- Query 2: Fetch bookings for a specific year
EXPLAIN ANALYZE
SELECT 
    COUNT(*) as booking_count,
    SUM(total_amount) as total_revenue
FROM 
    bookings_partitioned
WHERE 
    start_date >= '2024-01-01' AND start_date < '2025-01-01';


-- Query 3: Fetch recent bookings (last 30 days)
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_amount,
    u.first_name,
    u.last_name
FROM 
    bookings_partitioned b
JOIN 
    users u ON b.guest_id = u.user_id
WHERE 
    b.start_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY 
    b.start_date DESC;


-- ============================================================
-- STEP 7: Maintenance - Adding new partitions
-- ============================================================
-- Script to add new yearly partitions (run annually)

-- Example: Add partition for 2027
-- CREATE TABLE bookings_2027 PARTITION OF bookings_partitioned
--     FOR VALUES FROM ('2027-01-01') TO ('2028-01-01');


-- ============================================================
-- STEP 8: View partition information
-- ============================================================

-- Query to see all partitions of a table
SELECT 
    parent.relname AS parent_table,
    child.relname AS partition_name,
    pg_get_expr(child.relpartbound, child.oid) AS partition_range
FROM 
    pg_inherits
JOIN 
    pg_class parent ON pg_inherits.inhparent = parent.oid
JOIN 
    pg_class child ON pg_inherits.inhrelid = child.oid
WHERE 
    parent.relname = 'bookings_partitioned';
