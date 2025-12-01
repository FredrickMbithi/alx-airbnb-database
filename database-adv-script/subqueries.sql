-- ============================================================
-- Advanced SQL Queries: Subqueries
-- ALX Airbnb Database Project
-- ============================================================

-- ============================================================
-- 1. Non-Correlated Subquery: Properties with average rating > 4.0
-- ============================================================
-- This query finds all properties where the average rating is greater than 4.0.
-- The subquery calculates the average rating per property independently,
-- and the outer query filters properties based on this calculated value.

SELECT 
    p.property_id,
    p.title,
    p.description,
    p.price_per_night,
    p.city,
    p.country
FROM 
    properties p
WHERE 
    p.property_id IN (
        SELECT 
            r.property_id
        FROM 
            reviews r
        GROUP BY 
            r.property_id
        HAVING 
            AVG(r.rating) > 4.0
    );


-- Alternative approach using a subquery in FROM clause (derived table)
SELECT 
    p.property_id,
    p.title,
    p.description,
    p.price_per_night,
    p.city,
    p.country,
    avg_ratings.avg_rating
FROM 
    properties p
INNER JOIN (
    SELECT 
        property_id,
        AVG(rating) AS avg_rating
    FROM 
        reviews
    GROUP BY 
        property_id
    HAVING 
        AVG(rating) > 4.0
) AS avg_ratings ON p.property_id = avg_ratings.property_id;


-- ============================================================
-- 2. Correlated Subquery: Users with more than 3 bookings
-- ============================================================
-- This is a correlated subquery where the inner query references the outer query.
-- For each user in the outer query, the subquery counts their bookings,
-- and only users with more than 3 bookings are returned.

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role
FROM 
    users u
WHERE 
    (
        SELECT 
            COUNT(*)
        FROM 
            bookings b
        WHERE 
            b.guest_id = u.user_id
    ) > 3;


-- Alternative using EXISTS (also a correlated subquery pattern)
-- This finds users who have at least one booking (can be modified for count > 3)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role
FROM 
    users u
WHERE 
    EXISTS (
        SELECT 1
        FROM bookings b
        WHERE b.guest_id = u.user_id
        GROUP BY b.guest_id
        HAVING COUNT(*) > 3
    );
