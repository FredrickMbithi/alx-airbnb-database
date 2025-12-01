# Advanced SQL Scripts - ALX Airbnb Database

This directory contains advanced SQL scripts demonstrating complex database operations, optimization techniques, and performance analysis for the Airbnb database project.

## 📁 Directory Contents

| File                                    | Description                                           |
| --------------------------------------- | ----------------------------------------------------- |
| `joins_queries.sql`                     | Complex JOIN operations (INNER, LEFT, FULL OUTER)     |
| `subqueries.sql`                        | Correlated and non-correlated subqueries              |
| `aggregations_and_window_functions.sql` | Aggregations with COUNT/GROUP BY and window functions |
| `database_index.sql`                    | Index creation scripts for performance optimization   |
| `index_performance.md`                  | Documentation of index performance analysis           |
| `perfomance.sql`                        | Complex query with performance analysis               |
| `optimization_report.md`                | Query optimization strategies and results             |
| `partitioning.sql`                      | Table partitioning implementation                     |
| `partition_performance.md`              | Partitioning performance report                       |
| `performance_monitoring.md`             | Continuous monitoring and refinement guide            |

---

## 🔗 Task 0: Complex Queries with Joins

**File:** `joins_queries.sql`

Demonstrates mastery of SQL JOIN operations:

1. **INNER JOIN** - Retrieves all bookings with their respective users
2. **LEFT JOIN** - Retrieves all properties and their reviews (including properties without reviews)
3. **FULL OUTER JOIN** - Retrieves all users and bookings (including unmatched records)

### Example: INNER JOIN

```sql
SELECT b.booking_id, u.first_name, u.last_name
FROM bookings b
INNER JOIN users u ON b.guest_id = u.user_id;
```

---

## 🔍 Task 1: Subqueries

**File:** `subqueries.sql`

Demonstrates both correlated and non-correlated subqueries:

1. **Non-correlated Subquery** - Find properties with average rating > 4.0
2. **Correlated Subquery** - Find users with more than 3 bookings

### Example: Correlated Subquery

```sql
SELECT u.user_id, u.first_name, u.last_name
FROM users u
WHERE (SELECT COUNT(*) FROM bookings b WHERE b.guest_id = u.user_id) > 3;
```

---

## 📊 Task 2: Aggregations and Window Functions

**File:** `aggregations_and_window_functions.sql`

Demonstrates SQL aggregation and window functions:

1. **COUNT + GROUP BY** - Total bookings per user
2. **ROW_NUMBER()** - Unique ranking of properties by bookings
3. **RANK()** - Ranking with gaps for ties
4. **DENSE_RANK()** - Ranking without gaps for ties

### Example: Window Function

```sql
SELECT p.title, COUNT(b.booking_id) AS total_bookings,
       RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank
FROM properties p
LEFT JOIN bookings b ON p.property_id = b.property_id
GROUP BY p.property_id, p.title;
```

---

## 📈 Task 3: Index Optimization

**Files:** `database_index.sql`, `index_performance.md`

Identifies high-usage columns and creates appropriate indexes:

### Key Indexes Created:

- `idx_users_role` - User role filtering
- `idx_bookings_status` - Booking status queries
- `idx_bookings_guest_dates` - User booking history
- `idx_properties_city_price` - Location + price searches
- `idx_reviews_rating` - Rating-based filtering

### Performance Improvement: 4-8x faster query execution

---

## ⚡ Task 4: Query Optimization

**Files:** `perfomance.sql`, `optimization_report.md`

Demonstrates query optimization techniques:

1. **Initial Complex Query** - Retrieves bookings with user, property, and payment details
2. **Performance Analysis** - Using EXPLAIN ANALYZE
3. **Refactored Queries** - Optimized versions with strategic improvements

### Optimization Strategies:

- Selective column retrieval
- WHERE clause filtering with indexed columns
- Result limiting with LIMIT
- Efficient JOIN ordering

### Result: 5.8x faster execution time

---

## 🗂️ Task 5: Table Partitioning

**Files:** `partitioning.sql`, `partition_performance.md`

Implements RANGE partitioning on the Booking table by `start_date`:

### Partition Structure:

```
bookings_partitioned
├── bookings_2023 (2023 data)
├── bookings_2024 (2024 data)
├── bookings_2025 (2025 data)
├── bookings_2026 (2026 data)
└── bookings_default (fallback)
```

### Benefits:

- **Partition Pruning** - Only relevant partitions scanned
- **Faster Maintenance** - Per-partition VACUUM
- **Easy Archiving** - Detach old partitions
- **5-6x query improvement** for date-range queries

---

## 🔬 Task 6: Performance Monitoring

**File:** `performance_monitoring.md`

Comprehensive guide for continuous database monitoring:

### Tools Covered:

- `EXPLAIN ANALYZE` - Query execution analysis
- `pg_stat_statements` - Query statistics tracking
- `pg_stat_user_tables` - Table-level statistics
- `pg_stat_user_indexes` - Index usage monitoring

### Identified Bottlenecks & Solutions:

1. Missing indexes on frequently filtered columns
2. Inefficient text search queries
3. Suboptimal query patterns

### Monitoring Schedule:

- Daily: Slow query review
- Weekly: Index usage analysis
- Monthly: Full performance review
- Quarterly: Capacity planning

---

## 🚀 Getting Started

### Prerequisites

- PostgreSQL 12+ (for partitioning features)
- Database created with schema from `../database-script-0x01/schema.sql`
- Sample data loaded from `../database-script-0x02/seed.sql`

### Running the Scripts

```bash
# Connect to your database
psql -d airbnb_db

# Run the scripts in order
\i joins_queries.sql
\i subqueries.sql
\i aggregations_and_window_functions.sql
\i database_index.sql
\i perfomance.sql
\i partitioning.sql
```

### Analyzing Performance

```sql
-- Before running queries, enable timing
\timing on

-- Use EXPLAIN ANALYZE to view execution plans
EXPLAIN ANALYZE SELECT ...;
```

---

## 📚 Additional Resources

- [PostgreSQL EXPLAIN Documentation](https://www.postgresql.org/docs/current/sql-explain.html)
- [PostgreSQL Window Functions](https://www.postgresql.org/docs/current/tutorial-window.html)
- [PostgreSQL Table Partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html)
- [PostgreSQL Index Types](https://www.postgresql.org/docs/current/indexes-types.html)

---

## 👤 Author

ALX Airbnb Database Project
