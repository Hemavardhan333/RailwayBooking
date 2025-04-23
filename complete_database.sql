-- Start of schema.sql
-- schema.sql
CREATE DATABASE IF NOT EXISTS tenp1;
USE temp1;

-- Station table
CREATE TABLE Station (
    station_id INT PRIMARY KEY AUTO_INCREMENT,
    station_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(10) NOT NULL
);

-- Route table
CREATE TABLE Route (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    route_name VARCHAR(100) NOT NULL,
    origin_station_id INT NOT NULL,
    destination_station_id INT NOT NULL,
    distance_km INT NOT NULL,
    FOREIGN KEY (origin_station_id) REFERENCES Station(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES Station(station_id)
);

-- Train table
CREATE TABLE Train (
    train_id INT PRIMARY KEY AUTO_INCREMENT,
    train_name VARCHAR(100) NOT NULL,
    train_number VARCHAR(10) UNIQUE NOT NULL,
    route_id INT NOT NULL,
    total_seats INT NOT NULL,
    FOREIGN KEY (route_id) REFERENCES Route(route_id)
);

-- Schedule table
CREATE TABLE Schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    train_id INT NOT NULL,
    station_id INT NOT NULL,
    arrival_time TIME,
    departure_time TIME,
    day_number INT NOT NULL, -- 1=Monday, 2=Tuesday, etc.
    sequence_number INT NOT NULL,
    FOREIGN KEY (train_id) REFERENCES Train(train_id),
    FOREIGN KEY (station_id) REFERENCES Station(station_id)
);

-- Class table
CREATE TABLE Class (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(50) NOT NULL,
    base_fare_per_km DECIMAL(10,2) NOT NULL
);

-- Seat table
CREATE TABLE Seat (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    train_id INT NOT NULL,
    class_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    availability_status ENUM('available', 'booked', 'waitlisted') DEFAULT 'available',
    FOREIGN KEY (train_id) REFERENCES Train(train_id),
    FOREIGN KEY (class_id) REFERENCES Class(class_id)
);

-- Passenger table
CREATE TABLE Passenger (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    mobile_number VARCHAR(15) NOT NULL,
    email VARCHAR(100)
);

-- Ticket table
CREATE TABLE Ticket (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    pnr_number VARCHAR(10) UNIQUE NOT NULL,
    passenger_id INT NOT NULL,
    train_id INT NOT NULL,
    source_station_id INT NOT NULL,
    destination_station_id INT NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    journey_date DATE NOT NULL,
    seat_id INT,
    ticket_status ENUM('confirmed', 'waitlisted', 'cancelled') NOT NULL,
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (train_id) REFERENCES Train(train_id),
    FOREIGN KEY (source_station_id) REFERENCES Station(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES Station(station_id),
    FOREIGN KEY (seat_id) REFERENCES Seat(seat_id)
);

-- Payment table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Credit Card', 'Debit Card', 'Net Banking', 'UPI', 'Wallet') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id)
);

-- Start of data.sql
-- data.sql
USE railway_reservation;

-- Insert Stations
INSERT INTO Station (station_name, city, state, pincode) VALUES
('Mumbai Central', 'Mumbai', 'Maharashtra', '400001'),
('Delhi Junction', 'Delhi', 'Delhi', '110006'),
('Chennai Central', 'Chennai', 'Tamil Nadu', '600003'),
('Howrah Junction', 'Kolkata', 'West Bengal', '700001');

-- Insert Routes
INSERT INTO Route (route_name, origin_station_id, destination_station_id, distance_km) VALUES
('Mumbai-Delhi', 1, 2, 1400),
('Delhi-Chennai', 2, 3, 2200),
('Chennai-Kolkata', 3, 4, 1650);

-- Insert Trains
INSERT INTO Train (train_name, train_number, route_id, total_seats) VALUES
('Rajdhani Express', '12951', 1, 500),
('Shatabdi Express', '12002', 2, 350),
('Duronto Express', '12213', 3, 450);

-- Insert Schedules
INSERT INTO Schedule (train_id, station_id, arrival_time, departure_time, day_number, sequence_number) VALUES
-- Rajdhani Express
(1, 1, NULL, '17:00:00', 1, 1),
(1, 2, '08:30:00', NULL, 2, 2),
-- Shatabdi Express
(2, 2, NULL, '06:00:00', 3, 1),
(2, 3, '20:45:00', NULL, 3, 2),
-- Duronto Express
(3, 3, NULL, '15:30:00', 4, 1),
(3, 4, '09:15:00', NULL, 5, 2);

-- Insert Classes
INSERT INTO Class (class_name, base_fare_per_km) VALUES
('First AC', 3.50),
('Second AC', 2.50),
('Third AC', 1.75),
('Sleeper', 1.00);

-- Insert Seats
INSERT INTO Seat (train_id, class_id, seat_number, availability_status) VALUES
-- Rajdhani Express
(1, 1, 'A1', 'available'),
(1, 2, 'B1', 'available'),
(1, 3, 'C1', 'available'),
(1, 4, 'S1', 'available'),
-- Shatabdi Express
(2, 1, 'A1', 'available'),
(2, 2, 'B1', 'available'),
(2, 3, 'C1', 'available'),
(2, 4, 'S1', 'available'),
-- Duronto Express
(3, 1, 'A1', 'available'),
(3, 2, 'B1', 'available'),
(3, 3, 'C1', 'available'),
(3, 4, 'S1', 'available');

-- Insert Passengers
INSERT INTO Passenger (first_name, last_name, age, gender, mobile_number, email) VALUES
('Rahul', 'Sharma', 28, 'Male', '9876543210', 'rahul.sharma@example.com'),
('Priya', 'Patel', 25, 'Female', '8765432109', 'priya.patel@example.com'),
('Amit', 'Singh', 35, 'Male', '7654321098', 'amit.singh@example.com'),
('Neha', 'Gupta', 30, 'Female', '6543210987', 'neha.gupta@example.com');

-- Insert Tickets
INSERT INTO Ticket (pnr_number, passenger_id, train_id, source_station_id, destination_station_id, journey_date, seat_id, ticket_status) VALUES
('PNR12345', 1, 1, 1, 2, '2023-12-15', 1, 'confirmed'),
('PNR67890', 2, 2, 2, 3, '2023-12-20', 5, 'confirmed'),
('PNR24680', 3, 3, 3, 4, '2023-12-25', 9, 'confirmed');

-- Insert Payments
INSERT INTO Payment (ticket_id, amount, payment_method, payment_status) VALUES
(1, 4900.00, 'Credit Card', 'completed'),
(2, 5500.00, 'Debit Card', 'completed'),
(3, 5775.00, 'Net Banking', 'completed');

-- Start of procedures.sql
USE railway_reservation;

DELIMITER //

DROP PROCEDURE IF EXISTS BookTicket //

CREATE PROCEDURE BookTicket(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_age INT,
    IN p_gender ENUM('Male', 'Female', 'Other'),
    IN p_mobile_number VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_train_number VARCHAR(10),
    IN p_source_station_name VARCHAR(100),
    IN p_destination_station_name VARCHAR(100),
    IN p_journey_date DATE,
    IN p_class_name VARCHAR(50),
    IN p_payment_method VARCHAR(50),
    OUT p_pnr_number VARCHAR(10),
    OUT p_message VARCHAR(255)
)
proc_label: BEGIN
    DECLARE v_passenger_id INT;
    DECLARE v_train_id INT;
    DECLARE v_source_station_id INT;
    DECLARE v_destination_station_id INT;
    DECLARE v_class_id INT;
    DECLARE v_seat_id INT;
    DECLARE v_route_id INT;
    DECLARE v_distance_km INT;
    DECLARE v_base_fare_per_km DECIMAL(10,2);
    DECLARE v_amount DECIMAL(10,2);
    DECLARE v_pnr VARCHAR(10);
    DECLARE v_ticket_id INT;
    
    -- Generate PNR (8 characters: 2 letters + 4 numbers + 2 letters)
    SET v_pnr = CONCAT(
        CHAR(65 + FLOOR(RAND() * 26)),
        CHAR(65 + FLOOR(RAND() * 26)),
        LPAD(FLOOR(RAND() * 10000), 4, '0'),
        CHAR(65 + FLOOR(RAND() * 26)),
        CHAR(65 + FLOOR(RAND() * 26))
    );
    
    -- Check if passenger exists (by mobile or email)
    SELECT passenger_id INTO v_passenger_id 
    FROM Passenger 
    WHERE mobile_number = p_mobile_number OR email = p_email
    LIMIT 1;
    
    -- Create or update passenger record
    IF v_passenger_id IS NULL THEN
        -- New passenger
        INSERT INTO Passenger (
            first_name, last_name, age, gender, 
            mobile_number, email
        ) VALUES (
            p_first_name, p_last_name, p_age, p_gender,
            p_mobile_number, p_email
        );
        SET v_passenger_id = LAST_INSERT_ID();
        SET p_message = CONCAT('New passenger created with ID: ', v_passenger_id);
    ELSE
        -- Update existing passenger
        UPDATE Passenger SET
            first_name = p_first_name,
            last_name = p_last_name,
            age = p_age,
            gender = p_gender,
            email = p_email
        WHERE passenger_id = v_passenger_id;
        SET p_message = CONCAT('Using existing passenger ID: ', v_passenger_id);
    END IF;
    
    -- [Rest of your existing booking logic...]
    -- Get train ID
    SELECT train_id INTO v_train_id FROM Train WHERE train_number = p_train_number;
    IF v_train_id IS NULL THEN
        SET p_message = CONCAT('Invalid train number: ', p_train_number);
        LEAVE proc_label;
    END IF;
    
    -- Get station IDs
    SELECT station_id INTO v_source_station_id FROM Station WHERE station_name = p_source_station_name;
    IF v_source_station_id IS NULL THEN
        SET p_message = CONCAT('Invalid source station: ', p_source_station_name);
        LEAVE proc_label;
    END IF;
    
    SELECT station_id INTO v_destination_station_id FROM Station WHERE station_name = p_destination_station_name;
    IF v_destination_station_id IS NULL THEN
        SET p_message = CONCAT('Invalid destination station: ', p_destination_station_name);
        LEAVE proc_label;
    END IF;
    
    -- Get class ID
    SELECT class_id, base_fare_per_km INTO v_class_id, v_base_fare_per_km 
    FROM Class WHERE class_name = p_class_name;
    IF v_class_id IS NULL THEN
        SET p_message = CONCAT('Invalid class: ', p_class_name);
        LEAVE proc_label;
    END IF;
    
    -- Find available seat
    SELECT s.seat_id INTO v_seat_id
    FROM Seat s
    WHERE s.train_id = v_train_id
      AND s.class_id = v_class_id
      AND s.availability_status = 'available'
      AND NOT EXISTS (
          SELECT 1 FROM Ticket t 
          WHERE t.seat_id = s.seat_id 
            AND t.journey_date = p_journey_date
            AND t.ticket_status != 'cancelled'
      )
    LIMIT 1;
    
    -- Start transaction
    START TRANSACTION;
    
    -- Create ticket
    IF v_seat_id IS NOT NULL THEN
        -- Confirmed booking
        INSERT INTO Ticket (
            pnr_number, passenger_id, train_id, 
            source_station_id, destination_station_id, 
            journey_date, seat_id, ticket_status
        ) VALUES (
            v_pnr, v_passenger_id, v_train_id, 
            v_source_station_id, v_destination_station_id, 
            p_journey_date, v_seat_id, 'confirmed'
        );
        
        -- Mark seat as booked
        UPDATE Seat SET availability_status = 'booked' WHERE seat_id = v_seat_id;
        
        SET p_message = CONCAT(p_message, ' | Ticket booked successfully');
    ELSE
        -- Waitlisted booking
        INSERT INTO Ticket (
            pnr_number, passenger_id, train_id, 
            source_station_id, destination_station_id, 
            journey_date, ticket_status
        ) VALUES (
            v_pnr, v_passenger_id, v_train_id, 
            v_source_station_id, v_destination_station_id, 
            p_journey_date, 'waitlisted'
        );
        
        SET p_message = CONCAT(p_message, ' | Ticket waitlisted - no seats available');
    END IF;
    
    -- Get ticket ID
    SET v_ticket_id = LAST_INSERT_ID();
    
    -- Calculate fare
    SELECT distance_km INTO v_distance_km 
    FROM Route r JOIN Train t ON r.route_id = t.route_id 
    WHERE t.train_id = v_train_id;
    
    SET v_amount = ROUND(v_distance_km * v_base_fare_per_km * 1.18, 2);
    
    -- Record payment
    INSERT INTO Payment (
        ticket_id, amount, payment_method, payment_status
    ) VALUES (
        v_ticket_id, v_amount, p_payment_method, 'completed'
    );
    
    -- Commit transaction
    COMMIT;
    
    -- Set output parameters
    SET p_pnr_number = v_pnr;
    
    -- Verify the ticket was actually created
    IF NOT EXISTS (SELECT 1 FROM Ticket WHERE pnr_number = v_pnr) THEN
        SET p_message = CONCAT('Error: Ticket with PNR ', v_pnr, ' was not created');
        ROLLBACK;
    END IF;
END //

DELIMITER ;

-- Start of queries.sql
-- queries.sql
USE railway_reservation;

-- 1. PNR Status Check
DELIMITER //
CREATE OR REPLACE PROCEDURE CheckPNRStatus(IN pnr VARCHAR(10))
BEGIN
    SELECT 
    t.pnr_number,
        CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
        tr.train_name, tr.train_number,
        s1.station_name AS source,
        s2.station_name AS destination,
        t.journey_date,
        t.ticket_status,
        IFNULL(se.seat_number, 'Waitlisted') AS seat_number,
        c.class_name,
        py.amount,
        py.payment_status
    FROM Ticket t
    JOIN Passenger p ON t.passenger_id = p.passenger_id
    JOIN Train tr ON t.train_id = tr.train_id
    JOIN Station s1 ON t.source_station_id = s1.station_id
    JOIN Station s2 ON t.destination_station_id = s2.station_id
    LEFT JOIN Seat se ON t.seat_id = se.seat_id
    LEFT JOIN Class c ON se.class_id = c.class_id
    LEFT JOIN Payment py ON t.ticket_id = py.ticket_id  
    WHERE t.pnr_number = pnr;
END //
DELIMITER ;
-- 2. Train Schedule Lookup
DELIMITER //
CREATE PROCEDURE getTrainSchedule(IN train_number VARCHAR(10))
BEGIN
    SELECT 
        station_name,
        IFNULL(arrival_time, 'Origin') AS arrival_time,
        IFNULL(departure_time, 'Terminus') AS departure_time,
        day_number
    FROM Schedule sch
    JOIN Station s ON sch.station_id = s.station_id
    JOIN Train t ON sch.train_id = t.train_id
    WHERE t.train_number = train_number
    ORDER BY sch.sequence_number;
END //
DELIMITER ;

-- 3. Seat Availability Query
DELIMITER //
CREATE PROCEDURE CheckSeatAvailability(
    IN train_number VARCHAR(10),
    IN journey_date DATE,
    IN class_name VARCHAR(50)
)
BEGIN
    SELECT 
        s.seat_number,
        s.availability_status
    FROM Seat s
    JOIN Train t ON s.train_id = t.train_id
    JOIN Class c ON s.class_id = c.class_id
    WHERE t.train_number = train_number
    AND c.class_name = class_name
    AND s.availability_status IN ('available', 'waitlisted')
    AND NOT EXISTS (
        SELECT 1 FROM Ticket tk 
        WHERE tk.seat_id = s.seat_id 
        AND tk.journey_date = journey_date
        AND tk.ticket_status != 'cancelled'
    );
END //
DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS CancelTicket //

CREATE PROCEDURE CancelTicket(
    IN p_pnr_number VARCHAR(10),
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_ticket_id INT;
    DECLARE v_ticket_status VARCHAR(20);
    DECLARE v_seat_id INT;
    DECLARE v_refund_amount DECIMAL(10,2);
    DECLARE v_days_before_journey INT;
    DECLARE v_payment_amount DECIMAL(10,2);
    DECLARE v_train_id INT;
    DECLARE v_class_id INT;
    DECLARE v_journey_date DATE;
    DECLARE v_waitlisted_ticket_id INT;
    
    -- Get ticket details
    SELECT 
        t.ticket_id, 
        t.ticket_status, 
        t.seat_id,
        DATEDIFF(t.journey_date, CURDATE()),
        p.amount,
        t.train_id,
        IFNULL(s.class_id, (SELECT class_id FROM Class WHERE class_name = 'First AC')),
        t.journey_date
    INTO 
        v_ticket_id, 
        v_ticket_status,
        v_seat_id,
        v_days_before_journey,
        v_payment_amount,
        v_train_id,
        v_class_id,
        v_journey_date
    FROM Ticket t
    JOIN Payment p ON t.ticket_id = p.ticket_id
    LEFT JOIN Seat s ON t.seat_id = s.seat_id
    WHERE t.pnr_number = p_pnr_number;
    
    -- Check if ticket exists
    IF v_ticket_id IS NULL THEN
        SET p_message = 'Error: Ticket not found';
    ELSEIF v_ticket_status = 'cancelled' THEN
        SET p_message = 'Error: Ticket already cancelled';
    ELSE
        -- Start transaction
        START TRANSACTION;
        
        -- Update ticket status
        UPDATE Ticket 
        SET ticket_status = 'cancelled' 
        WHERE ticket_id = v_ticket_id;
        
        -- Free up the seat if it was confirmed
        IF v_seat_id IS NOT NULL THEN
            UPDATE Seat 
            SET availability_status = 'available' 
            WHERE seat_id = v_seat_id;
            
            -- Find the oldest waitlisted ticket for the same train/class/date
            SELECT ticket_id INTO v_waitlisted_ticket_id
            FROM Ticket
            WHERE train_id = v_train_id
              AND journey_date = v_journey_date
              AND ticket_status = 'waitlisted'
              AND seat_id IS NULL
            ORDER BY booking_date
            LIMIT 1;
            
            -- If found, promote it to confirmed
            IF v_waitlisted_ticket_id IS NOT NULL THEN
                -- Get an available seat of the same class
                SELECT seat_id INTO v_seat_id
                FROM Seat
                WHERE train_id = v_train_id
                  AND class_id = v_class_id
                  AND availability_status = 'available'
                  AND NOT EXISTS (
                      SELECT 1 FROM Ticket
                      WHERE seat_id = Seat.seat_id
                        AND journey_date = v_journey_date
                        AND ticket_status != 'cancelled'
                  )
                LIMIT 1;
                
                -- Update the waitlisted ticket
                IF v_seat_id IS NOT NULL THEN
                    UPDATE Ticket
                    SET 
                        ticket_status = 'confirmed',
                        seat_id = v_seat_id
                    WHERE ticket_id = v_waitlisted_ticket_id;
                    
                    UPDATE Seat
                    SET availability_status = 'booked'
                    WHERE seat_id = v_seat_id;
                    
                    SET p_message = CONCAT('Ticket cancelled. Waitlisted ticket promoted. Refund: ', 
                                         IF(v_days_before_journey > 7, v_payment_amount, v_payment_amount * 0.5));
                END IF;
            END IF;
        END IF;
        
        -- Calculate refund amount
        IF v_days_before_journey > 7 THEN
            SET v_refund_amount = v_payment_amount;
        ELSE
            SET v_refund_amount = v_payment_amount * 0.5;
        END IF;
        
        -- Update payment status to refunded
        UPDATE Payment 
        SET 
            payment_status = 'refunded',
            amount = v_refund_amount
        WHERE ticket_id = v_ticket_id;
        
        -- Commit transaction
        COMMIT;
        
        IF p_message IS NULL THEN
            SET p_message = CONCAT('Ticket cancelled successfully. Refund amount: ', v_refund_amount);
        END IF;
    END IF;
END //

DELIMITER ;

-- 4. Waitlisted Passengers
DELIMITER //
CREATE PROCEDURE GetWaitlistedPassengers(IN train_number VARCHAR(10), IN journey_date DATE)
BEGIN
    SELECT 
        t.pnr_number,
        CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
        c.class_name,
        t.booking_date
    FROM Ticket t
    JOIN Passenger p ON t.passenger_id = p.passenger_id
    JOIN Train tr ON t.train_id = tr.train_id
    LEFT JOIN Seat s ON t.seat_id = s.seat_id
    LEFT JOIN Class c ON s.class_id = c.class_id
    WHERE tr.train_number = train_number
    AND t.journey_date = journey_date
    AND t.ticket_status = 'waitlisted'
    ORDER BY t.booking_date;
END //
DELIMITER ;

-- 5. Total Revenue and Refunds
DELIMITER //
CREATE PROCEDURE GetRevenueReport(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT 
        SUM(CASE WHEN payment_status = 'completed' THEN amount ELSE 0 END) AS total_revenue,
        SUM(CASE WHEN payment_status = 'refunded' THEN amount ELSE 0 END) AS total_refunds,
        COUNT(CASE WHEN payment_status = 'completed' THEN 1 END) AS completed_payments,
        COUNT(CASE WHEN payment_status = 'refunded' THEN 1 END) AS refunded_payments
    FROM Payment
    WHERE payment_date BETWEEN start_date AND end_date;
END //
DELIMITER ;

-- 6. Busiest Route Identification
DELIMITER //
CREATE PROCEDURE GetBusiestRoutes(IN limit_count INT)
BEGIN
    SELECT 
        r.route_name,
        COUNT(t.ticket_id) AS total_tickets,
        SUM(p.amount) AS total_revenue
    FROM Route r
    JOIN Train tr ON r.route_id = tr.route_id
    JOIN Ticket t ON tr.train_id = t.train_id
    JOIN Payment p ON t.ticket_id = p.ticket_id
    WHERE p.payment_status = 'completed'
    GROUP BY r.route_id
    ORDER BY total_tickets DESC
    LIMIT limit_count;
END //
DELIMITER ;

-- 7. Itemized Ticket Bill
DELIMITER //
CREATE PROCEDURE GetTicketBill(IN pnr VARCHAR(10))
BEGIN
    SELECT 
        t.pnr_number,
        CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
        tr.train_name,
        s1.station_name AS source,
        s2.station_name AS destination,
        t.journey_date,
        c.class_name,
        r.distance_km,
        c.base_fare_per_km,
        (r.distance_km * c.base_fare_per_km) AS base_fare,
        ((r.distance_km * c.base_fare_per_km) * 0.18) AS gst,
        ((r.distance_km * c.base_fare_per_km) * 1.18) AS total_amount,
        py.payment_method,
        py.payment_status
    FROM Ticket t
    JOIN Passenger p ON t.passenger_id = p.passenger_id
    JOIN Train tr ON t.train_id = tr.train_id
    JOIN Route r ON tr.route_id = r.route_id
    JOIN Station s1 ON t.source_station_id = s1.station_id
    JOIN Station s2 ON t.destination_station_id = s2.station_id
    JOIN Seat se ON t.seat_id = se.seat_id
    JOIN Class c ON se.class_id = c.class_id
    JOIN Payment py ON t.ticket_id = py.ticket_id
    WHERE t.pnr_number = pnr;
END //
DELIMITER ;

-- Reset variables
SET @pnr = NULL;
SET @message = NULL;

-- Call with valid data (use exact station names from your Station table)
CALL BookTicket(1, '12951', 'Mumbai Central', 'Delhi Junction', '2023-12-25', 'First AC', 'Credit Card', @pnr, @message);

-- View results
SELECT @pnr AS your_pnr, @message AS status;

-- Verify the ticket exists
SELECT * FROM Ticket WHERE pnr_number = @pnr;

-- Check PNR status
CALL CheckPNRStatus(@pnr);