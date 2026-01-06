CREATE TABLE hotel_reservation (
    booking_id TEXT,
    no_of_adults TEXT,
    no_of_children TEXT,
    no_of_weekend_nights TEXT,
    no_of_week_nights TEXT,
    type_of_meal_plan TEXT,
    room_type_reserved TEXT,
    lead_time TEXT,
    arrival_date TEXT,   -- format: DD-MM-YYYY
    market_segment_type TEXT,
    avg_price_per_room TEXT,
    booking_status TEXT
);

--Total reservations
SELECT COUNT(*) AS total_rows
FROM hotel_reservation;


--Most popular meal plan
SELECT 
    type_of_meal_plan AS popular_meal_plan,
    COUNT(*) AS count
FROM hotel_reservation
WHERE type_of_meal_plan <> 'Not Selected'
GROUP BY type_of_meal_plan
ORDER BY count DESC
LIMIT 1;

--Average price per room for reservations involving children
SELECT 
    ROUND(AVG(avg_price_per_room::NUMERIC), 2)
    AS average_price_per_room_with_children
FROM hotel_reservation
WHERE no_of_children::INT > 0;

--Total reservations made in the year 2017
SELECT 
    COUNT(*) AS total_reservations_2017
FROM hotel_reservation
WHERE EXTRACT(
    YEAR FROM TO_DATE(arrival_date, 'DD-MM-YYYY')
) = 2017;


--Most commonly booked room type
SELECT 
    room_type_reserved AS most_common_room_type,
    COUNT(*) AS count
FROM hotel_reservation
GROUP BY room_type_reserved
ORDER BY count DESC
LIMIT 1;


--Reservations that include weekend stays
SELECT 
    COUNT(*) AS reservations_on_weekends
FROM hotel_reservation
WHERE no_of_weekend_nights::INT > 0;

--Highest and lowest lead time
SELECT 
    MAX(lead_time::INT) AS highest_lead_time,
    MIN(lead_time::INT) AS lowest_lead_time
FROM hotel_reservation;

--Most common market segment type
SELECT 
    market_segment_type,
    COUNT(*) AS count
FROM hotel_reservation
GROUP BY market_segment_type
ORDER BY count DESC
LIMIT 1;

--Total confirmed bookings
SELECT 
    COUNT(*) AS confirmed_bookings
FROM hotel_reservation
WHERE booking_status = 'Not_Canceled';


--Total number of adults and children
SELECT 
    SUM(no_of_adults::INT) AS total_adults,
    SUM(no_of_children::INT) AS total_children,
    SUM(no_of_adults::INT + no_of_children::INT) AS total_guests
FROM hotel_reservation;

--Average number of weekend nights for reservations involving children
SELECT 
    AVG(no_of_weekend_nights::INT) AS avg_weekend_nights
FROM hotel_reservation
WHERE no_of_children::INT > 0
  AND no_of_weekend_nights::INT > 0;


--Monthly reservation count
SELECT 
    EXTRACT(MONTH FROM TO_DATE(arrival_date, 'DD-MM-YYYY')) AS month,
    COUNT(*) AS total_reservations
FROM hotel_reservation
GROUP BY month
ORDER BY month; 

--Average total nights spent per room type
SELECT 
    room_type_reserved,
    AVG(
        no_of_weekend_nights::INT + no_of_week_nights::INT
    ) AS avg_total_nights
FROM hotel_reservation
GROUP BY room_type_reserved
ORDER BY room_type_reserved;


--Most common room type for reservations involving children
SELECT 
    room_type_reserved,
    COUNT(*) AS count,
    AVG(avg_price_per_room::NUMERIC) AS avg_price_per_room
FROM hotel_reservation
WHERE no_of_children::INT > 0
GROUP BY room_type_reserved
ORDER BY count DESC
LIMIT 1;


--Market segment with the highest average room price
SELECT 
    market_segment_type,
    AVG(avg_price_per_room::NUMERIC) AS avg_price_per_room
FROM hotel_reservation
GROUP BY market_segment_type
ORDER BY avg_price_per_room DESC
LIMIT 1;

