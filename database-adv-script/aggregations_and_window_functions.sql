-- ============================================================
-- Advanced SQL Queries: Aggregations and Window Functions
-- ALX Airbnb Database Project
-- ============================================================

-- ============================================================
-- 1. COUNT and GROUP BY: Total bookings per user
-- ============================================================
-- This query calculates the total number of bookings made by each user
-- using the COUNT aggregate function with GROUP BY clause.

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.guest_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
ORDER BY 
    total_bookings DESC;


-- ============================================================
-- 2. Window Functions: Rank properties by total bookings
-- ============================================================
-- Using ROW_NUMBER to assign a unique sequential number to each property
-- based on booking count (no ties - each gets a unique number)

SELECT 
    p.property_id,
    p.title,
    p.city,
    p.country,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number_rank
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.title, p.city, p.country
ORDER BY 
    total_bookings DESC;


-- Using RANK to rank properties (handles ties by assigning same rank)
-- Properties with the same booking count get the same rank,
-- but the next rank skips numbers (e.g., 1, 2, 2, 4)

SELECT 
    p.property_id,
    p.title,
    p.city,
    p.country,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.title, p.city, p.country
ORDER BY 
    rank;


-- Using DENSE_RANK (no gaps in ranking for ties)
-- Properties with the same booking count get the same rank,
-- and the next rank is consecutive (e.g., 1, 2, 2, 3)

SELECT 
    p.property_id,
    p.title,
    p.city,
    p.country,
    COUNT(b.booking_id) AS total_bookings,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.title, p.city, p.country
ORDER BY 
    dense_rank;


-- Combined view with all ranking methods for comparison
SELECT 
    p.property_id,
    p.title,
    p.city,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_num,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.title, p.city
ORDER BY 
    total_bookings DESC;
