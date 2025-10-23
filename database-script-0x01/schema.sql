-- Schema for ALX Airbnb Database (Postgres)
-- Run as: psql -f schema.sql

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Types
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
        CREATE TYPE user_role AS ENUM ('guest','host','admin');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'booking_status') THEN
        CREATE TYPE booking_status AS ENUM ('pending','confirmed','cancelled','completed');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_status') THEN
        CREATE TYPE payment_status AS ENUM ('pending','succeeded','failed','refunded');
    END IF;
END $$;

-- Users
CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role user_role DEFAULT 'guest',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Properties
CREATE TABLE IF NOT EXISTS properties (
    property_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price_per_night NUMERIC(10,2) NOT NULL CHECK (price_per_night >= 0),
    currency CHAR(3) DEFAULT 'USD',
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(30),
    latitude NUMERIC(9,6),
    longitude NUMERIC(9,6),
    max_guests INTEGER NOT NULL DEFAULT 1 CHECK (max_guests > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_properties_host_id ON properties(host_id);
CREATE INDEX IF NOT EXISTS idx_properties_city ON properties(city);

-- Property images
CREATE TABLE IF NOT EXISTS property_images (
    image_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    url TEXT NOT NULL,
    caption TEXT,
    ordinal INTEGER DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_property_images_property_id ON property_images(property_id);

-- Amenities
CREATE TABLE IF NOT EXISTS amenities (
    amenity_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Junction: property_amenities
CREATE TABLE IF NOT EXISTS property_amenities (
    property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    amenity_id UUID NOT NULL REFERENCES amenities(amenity_id) ON DELETE CASCADE,
    PRIMARY KEY (property_id, amenity_id)
);

-- Bookings
CREATE TABLE IF NOT EXISTS bookings (
    booking_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    guest_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL CHECK (end_date > start_date),
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
    status booking_status DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    CHECK (start_date IS NOT NULL AND end_date IS NOT NULL)
);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_guest_id ON bookings(guest_id);
CREATE INDEX IF NOT EXISTS idx_bookings_dates ON bookings(start_date, end_date);

-- Payments
CREATE TABLE IF NOT EXISTS payments (
    payment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID NOT NULL REFERENCES bookings(booking_id) ON DELETE CASCADE,
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    currency CHAR(3) DEFAULT 'USD',
    status payment_status DEFAULT 'pending',
    provider VARCHAR(100),
    provider_payment_id VARCHAR(255) UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_payments_booking_id ON payments(booking_id);

-- Reviews
CREATE TABLE IF NOT EXISTS reviews (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    rating SMALLINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (property_id, user_id)
);
CREATE INDEX IF NOT EXISTS idx_reviews_property_id ON reviews(property_id);

-- Favorites (users saving properties)
CREATE TABLE IF NOT EXISTS favorites (
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    PRIMARY KEY (user_id, property_id)
);

-- Small helpful views (optional)
CREATE OR REPLACE VIEW property_average_rating AS
SELECT p.property_id, ROUND(AVG(r.rating)::numeric,2) AS avg_rating, COUNT(r.*) AS review_count
FROM properties p
LEFT JOIN reviews r ON r.property_id = p.property_id
GROUP BY p.property_id;

-- End of schema
