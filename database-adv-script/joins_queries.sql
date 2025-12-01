-- ============================================================
-- Advanced SQL Queries: JOIN Operations
-- ALX Airbnb Database Project
-- ============================================================

-- ============================================================
-- 1. INNER JOIN: Retrieve all bookings with their respective users
-- ============================================================
-- This query retrieves all bookings along with the details of the users 
-- who made those bookings. Only bookings that have a matching user are returned.

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_amount,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role
FROM 
    bookings b
INNER JOIN 
    users u ON b.guest_id = u.user_id;


-- ============================================================
-- 2. LEFT JOIN: Retrieve all properties and their reviews
-- ============================================================
-- This query retrieves all properties including those that have no reviews.
-- Properties without reviews will have NULL values in the review columns.

SELECT 
    p.property_id,
    p.title AS property_title,
    p.description,
    p.price_per_night,
    p.city,
    p.country,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date
FROM 
    properties p
LEFT JOIN 
    reviews r ON p.property_id = r.property_id
ORDER BY 
    p.property_id, r.created_at DESC;


-- ============================================================
-- 3. FULL OUTER JOIN: Retrieve all users and all bookings
-- ============================================================
-- This query retrieves all users and all bookings, even if:
-- - A user has no bookings (user columns populated, booking columns NULL)
-- - A booking is not linked to a user (booking columns populated, user columns NULL)
-- Note: In a properly constrained database, orphan bookings shouldn't exist,
-- but this demonstrates the FULL OUTER JOIN concept.

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_amount,
    b.status AS booking_status
FROM 
    users u
FULL OUTER JOIN 
    bookings b ON u.user_id = b.guest_id;
