-- ============================================================
-- Query Performance Analysis
-- ALX Airbnb Database Project
-- ============================================================
-- This file contains complex queries for performance analysis
-- and optimization demonstration.

-- ============================================================
-- INITIAL COMPLEX QUERY
-- ============================================================
-- This query retrieves all bookings with complete details including:
-- - User (guest) information
-- - Property details
-- - Payment information

-- Initial unoptimized query
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_amount AS booking_amount,
    b.status AS booking_status,
    b.created_at AS booking_date,
    
    -- User (guest) details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role AS user_role,
    
    -- Property details
    p.property_id,
    p.title AS property_title,
    p.description AS property_description,
    p.price_per_night,
    p.city,
    p.state,
    p.country,
    
    -- Payment details
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.status AS payment_status,
    pay.provider AS payment_provider,
    pay.created_at AS payment_date

FROM 
    bookings b
INNER JOIN 
    users u ON b.guest_id = u.user_id
INNER JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id;


-- ============================================================
-- EXPLAIN ANALYZE OUTPUT (for analysis)
-- ============================================================
-- Run this to analyze query performance:
-- EXPLAIN ANALYZE
-- SELECT ... (the query above)

-- Expected output analysis points:
-- 1. Check for sequential scans vs index scans
-- 2. Look at join methods (nested loop, hash join, merge join)
-- 3. Examine row estimates vs actual rows
-- 4. Identify the most expensive operations


-- ============================================================
-- OPTIMIZED QUERY VERSION 1
-- ============================================================
-- Optimization: Select only necessary columns to reduce data transfer

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_amount,
    b.status AS booking_status,
    
    u.first_name || ' ' || u.last_name AS guest_name,
    u.email AS guest_email,
    
    p.title AS property_title,
    p.city || ', ' || p.country AS property_location,
    p.price_per_night,
    
    pay.amount AS payment_amount,
    pay.status AS payment_status

FROM 
    bookings b
INNER JOIN 
    users u ON b.guest_id = u.user_id
INNER JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id;


-- ============================================================
-- OPTIMIZED QUERY VERSION 2
-- ============================================================
-- Optimization: Add WHERE clause to limit results and utilize indexes

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_amount,
    b.status AS booking_status,
    
    u.first_name || ' ' || u.last_name AS guest_name,
    u.email AS guest_email,
    
    p.title AS property_title,
    p.city || ', ' || p.country AS property_location,
    p.price_per_night,
    
    pay.amount AS payment_amount,
    pay.status AS payment_status

FROM 
    bookings b
INNER JOIN 
    users u ON b.guest_id = u.user_id
INNER JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id
WHERE 
    b.start_date >= CURRENT_DATE - INTERVAL '1 year'
ORDER BY 
    b.created_at DESC
LIMIT 100;


-- ============================================================
-- OPTIMIZED QUERY VERSION 3
-- ============================================================
-- Optimization: Use specific date range and indexed columns

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_amount,
    b.status AS booking_status,
    
    u.first_name,
    u.last_name,
    u.email,
    
    p.title,
    p.city,
    p.country,
    
    pay.amount,
    pay.status AS payment_status

FROM 
    bookings b
INNER JOIN 
    users u ON b.guest_id = u.user_id
INNER JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id
WHERE 
    b.status IN ('confirmed', 'completed')
    AND b.start_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY 
    b.start_date DESC;
