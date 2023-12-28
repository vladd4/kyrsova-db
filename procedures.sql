USE service_center;

-- Вивести певну кількість найновіших реєстрацій
DELIMITER //
CREATE PROCEDURE getNewestRegistrations(IN registration_count INT)
BEGIN
	SELECT * FROM vehicle_registration
	ORDER BY registration_date DESC
	LIMIT registration_count;
END;
//
DELIMITER ;

-- Вивести всі дані про зареєстровані транспортні засоби за іменем та прізвищем власника
DELIMITER //
CREATE PROCEDURE getAllRegisteredVehicles(
    IN owner_name VARCHAR(255),
    IN owner_surname VARCHAR(255)
)
BEGIN
    DECLARE resultCount INT;

    SELECT COUNT(*) INTO resultCount
    FROM 
        vehicle_registration, 
        vehicle, 
        owner, 
        fuel_type, 
        number_plate, 
        vehicle_type
    WHERE
        vehicle_registration.vehicle_id = vehicle.vehicle_id
        AND vehicle_registration.owner_id = owner.owner_id
        AND vehicle.fuel_type = fuel_type.fuel_id
        AND vehicle.type = vehicle_type.type_id
        AND vehicle.plate_id = number_plate.plate_id
        AND owner.name = owner_name AND owner.surname = owner_surname;

    IF resultCount > 0 THEN
        SELECT 
            registration_date,
            expiration_date,
            brand,
            model,
            year,
            color,
            vin,
            weight,
            engine,
            vehicle_type.type AS vehicle_type,
            fuel_type.fuel,
            number_plate.plate AS number_plate,
            name,
            surname,
            phone_number,
            city,
            address,
            passport_number
        FROM 
            vehicle_registration, 
            vehicle, 
            owner, 
            fuel_type, 
            number_plate, 
            vehicle_type
        WHERE
            vehicle_registration.vehicle_id = vehicle.vehicle_id
            AND vehicle_registration.owner_id = owner.owner_id
            AND vehicle.fuel_type = fuel_type.fuel_id
            AND vehicle.type = vehicle_type.type_id
            AND vehicle.plate_id = number_plate.plate_id
            AND owner.name = owner_name AND owner.surname = owner_surname;
    ELSE
        SELECT 'Не знайдено жодного зареєстрованого транспортного засобу' AS message;
    END IF;
END;
//
DELIMITER ;

-- Змінити статус штрафу для певного автомобіля
DELIMITER //
CREATE PROCEDURE changeFineStatus(IN fineID INT, IN vehicleID INT, IN fine_status INT)
BEGIN
    DECLARE customError VARCHAR(255) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 customError = MESSAGE_TEXT;
    END;

    UPDATE fine
    SET fine.status = fine_status
    WHERE 
        fine.fine_id = fineID
        AND fine.vehicle_id = vehicleID;

    IF customError IS NOT NULL THEN
        SELECT CONCAT('Error: ', customError) AS message;
    ELSE
        SELECT 'Fine status updated successfully.' AS message;
    END IF;
END;
//
DELIMITER ;

-- Перевірити чи транспортний засіб має штрафи і якщо має, вивести інформацію про них
DELIMITER //
CREATE PROCEDURE checkFines(IN vehicleID int)
BEGIN
	DECLARE resultCount INT;
    
	SELECT COUNT(*) INTO resultCount
	FROM fine
	JOIN vehicle ON vehicle.vehicle_id = fine.vehicle_id
	JOIN number_plate ON number_plate.plate_id = vehicle.plate_id
	JOIN fuel_type ON fuel_type.fuel_id = vehicle.fuel_type
	JOIN vehicle_type ON vehicle_type.type_id = vehicle.type
    WHERE fine.vehicle_id = vehicleID;
    
     IF resultCount > 0 THEN
        SELECT 
			fine_id,
			date, 
			amount, 
			description, 
			fine.status, 
			vehicle.vehicle_id, 
			brand, 
			model, 
			year, 
			color, 
			weight, 
			vin, 
			fuel, 
			vehicle_type.type, 
			engine 
		FROM fine
		JOIN vehicle ON vehicle.vehicle_id = fine.vehicle_id
		JOIN number_plate ON number_plate.plate_id = vehicle.plate_id
		JOIN fuel_type ON fuel_type.fuel_id = vehicle.fuel_type
		JOIN vehicle_type ON vehicle_type.type_id = vehicle.type
        WHERE fine.vehicle_id = vehicleID;
    ELSE
        SELECT 'Не знайдено жодного штрафа для цього транспортного засобу' AS message;
    END IF;
END;
//
DELIMITER ;

-- Змінити статус інспектора сервісного центру мвс
DELIMITER //
CREATE PROCEDURE changeInspectorStatus(IN inspectorID INT, IN new_status INT)
BEGIN
    DECLARE customError VARCHAR(255) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 customError = MESSAGE_TEXT;
    END;

    UPDATE inspector
    SET inspector.status = new_status
    WHERE 
        inspector.inspector_id = inspectorID;

    IF customError IS NOT NULL THEN
        SELECT CONCAT('Error: ', customError) AS message;
    ELSE
        SELECT 'Inspector status updated successfully.' AS message;
    END IF;
END;
//
DELIMITER ;

-- Змінити статус оператора сервісного центру мвс
DELIMITER //
CREATE PROCEDURE changeOperatorStatus(IN operatorID INT, IN new_status INT)
BEGIN
    DECLARE customError VARCHAR(255) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 customError = MESSAGE_TEXT;
    END;

    UPDATE operator
    SET operator.status = new_status
    WHERE 
        operator.operator_id = operatorID;

    IF customError IS NOT NULL THEN
        SELECT CONCAT('Error: ', customError) AS message;
    ELSE
        SELECT 'Operator status updated successfully.' AS message;
    END IF;
END;
//
DELIMITER ;

-- Вивести всі дані про зареєстровані транспортні засоби за він кодом тз
DELIMITER //
CREATE PROCEDURE getAllRegisteredVehiclesByVin(
    IN vin VARCHAR(255)
)
BEGIN
    DECLARE resultCount INT;

    SELECT COUNT(*) INTO resultCount
    FROM 
        vehicle_registration, 
        vehicle, 
        owner, 
        fuel_type, 
        number_plate, 
        vehicle_type
    WHERE
        vehicle_registration.vehicle_id = vehicle.vehicle_id
        AND vehicle_registration.owner_id = owner.owner_id
        AND vehicle.fuel_type = fuel_type.fuel_id
        AND vehicle.type = vehicle_type.type_id
        AND vehicle.plate_id = number_plate.plate_id
        AND vehicle.vin = vin;

    IF resultCount > 0 THEN
        SELECT 
            registration_date,
            expiration_date,
            brand,
            model,
            year,
            color,
            vin,
            weight,
            engine,
            vehicle_type.type AS vehicle_type,
            fuel_type.fuel,
            number_plate.plate AS number_plate,
            name,
            surname,
            phone_number,
            city,
            address,
            passport_number
        FROM 
        vehicle_registration, 
        vehicle, 
        owner, 
        fuel_type, 
        number_plate, 
        vehicle_type
		WHERE
			vehicle_registration.vehicle_id = vehicle.vehicle_id
		AND vehicle_registration.owner_id = owner.owner_id
		AND vehicle.fuel_type = fuel_type.fuel_id
		AND vehicle.type = vehicle_type.type_id
		AND vehicle.plate_id = number_plate.plate_id
		AND vehicle.vin = vin;
    ELSE
        SELECT 'Не знайдено жодного зареєстрованого транспортного засобу за цим він кодом' AS message;
    END IF;
END;
//
DELIMITER ;

-- Додати нового власника до бази даних
DELIMITER //
CREATE PROCEDURE createOwner(
	IN owner_name VARCHAR(255), IN owner_surname VARCHAR(255), 
    IN phone VARCHAR(15), IN owner_city VARCHAR(255), 
    IN owner_address VARCHAR(255), IN passport VARCHAR(15) 
)
BEGIN
	INSERT INTO owner (name, surname, phone_number, city, address, passport_number) 
    VALUES (owner_name, owner_surname, phone, owner_city, owner_address, passport);
END;
//
DELIMITER ;

-- Додати новий штраф для транспортного засобу
DELIMITER //
CREATE PROCEDURE createFine(
	IN fine_date TIMESTAMP, IN fine_amount DECIMAL(10,2), 
    IN descrip VARCHAR(255), IN fine_status ENUM('paid', 'pending'), 
    IN vehicleID INT 
)
BEGIN
	DECLARE vehicle_exists INT;
	SELECT COUNT(*) INTO vehicle_exists FROM vehicle WHERE vehicle_id = vehicleID;
    
	 IF vehicle_exists > 0 THEN
        INSERT INTO fine (date, amount, description, status, vehicle_id) 
        VALUES (fine_date, fine_amount, descrip, fine_status, vehicleID);
        SELECT 'Штраф успішно додано!' AS message;
    ELSE
       SELECT 'Не знайдено жодного зареєстрованого транспортного засобу за цим id' AS message;
    END IF;
END;
//
DELIMITER ;

-- Додати новий транспортний засіб
DELIMITER //
CREATE PROCEDURE createVehicle(
	IN v_brand VARCHAR(255), IN v_model VARCHAR(255), 
    IN v_year INT, IN v_color VARCHAR(55), 
    IN v_weight DECIMAL(10,2), IN plateID INT,
    IN v_vin VARCHAR(17), IN fuelID INT,
    IN typeID INT, IN v_engine DECIMAL(2,1)
)
BEGIN
	DECLARE fuel_exists INT;
    DECLARE type_exists INT;
    DECLARE plate_status ENUM('available', 'unavailable');

    SELECT COUNT(*) INTO fuel_exists FROM fuel_type WHERE fuel_id = fuelID;
    SELECT COUNT(*) INTO type_exists FROM vehicle_type WHERE type_id = typeID;
    SELECT status INTO plate_status FROM number_plate WHERE plate_id = plateID;
    
	 IF fuel_exists > 0 AND type_exists > 0 AND plate_status = 'available' THEN
        INSERT INTO vehicle (brand, model, year, color, weight, plate_id, vin, fuel_type, type, engine) 
        VALUES (v_brand, v_model, v_year, v_color, v_weight, plateID, v_vin, fuelID, typeID, v_engine);
        SELECT 'Транспортний засіб успішно додано!' AS message;
    ELSE
       SELECT 'Неможливо додати транспортний засіб. Перевірте існування типу палива, типу авто або статус номерного знака.' AS message;
    END IF;
END;
//
DELIMITER ;

-- Додати нову реєстрацію транспортного засобу
DELIMITER //
CREATE PROCEDURE createRegistration(
    IN reg_date TIMESTAMP, IN exp_date TIMESTAMP, 
    IN v_brand VARCHAR(255), IN v_model VARCHAR(255), 
    IN v_year INT, IN v_color VARCHAR(55), 
    IN v_weight DECIMAL(10,2), IN plateID INT,
    IN v_vin VARCHAR(17), IN fuelID INT,
    IN typeID INT, IN v_engine DECIMAL(2,1),
    IN owner_name VARCHAR(255), IN owner_surname VARCHAR(255), 
    IN phone VARCHAR(15), IN owner_city VARCHAR(255), 
    IN owner_address VARCHAR(255), IN passport VARCHAR(15),
    IN operatorID INT, IN inspectorID INT
)
BEGIN
    DECLARE vehicle_exists INT;
    DECLARE new_vehicle_id INT;
    DECLARE ownerID INT;
    DECLARE operator_exists INT;
    DECLARE inspector_exists INT;
    DECLARE existing_owner INT;
    DECLARE existing_registration INT;

    SELECT COUNT(*) INTO existing_owner FROM owner WHERE passport_number = passport;

    IF existing_owner > 0 THEN
        SELECT owner_id INTO ownerID FROM owner WHERE passport_number = passport;
    ELSE
        CALL createOwner(owner_name, owner_surname, phone, owner_city, owner_address, passport);
        SELECT owner_id INTO ownerID FROM owner WHERE passport_number = passport;
    END IF;

    SELECT COUNT(*) INTO vehicle_exists FROM vehicle WHERE vin = v_vin;

    IF vehicle_exists > 0 THEN
        SELECT COUNT(*) INTO operator_exists FROM operator WHERE operator_id = operatorID;
        SELECT COUNT(*) INTO inspector_exists FROM inspector WHERE inspector_id = inspectorID;

        IF operator_exists > 0 AND inspector_exists > 0 THEN
            SELECT COUNT(*) INTO existing_registration 
            FROM vehicle_registration 
            WHERE vehicle_id = (SELECT vehicle_id FROM vehicle WHERE vin = v_vin) 
            AND owner_id = ownerID;

            IF existing_registration > 0 THEN
                SELECT 'Транспортний засіб вже зареєстровано для цього власника.' AS message;
            ELSE
                DELETE FROM vehicle_registration
                WHERE vehicle_id = (SELECT vehicle_id FROM vehicle WHERE vin = v_vin);

                INSERT INTO vehicle_registration (registration_date, expiration_date, vehicle_id, owner_id, operator_id, inspector_id) 
                VALUES (reg_date, exp_date, (SELECT vehicle_id FROM vehicle WHERE vin = v_vin), ownerID, operatorID, inspectorID);
				
                INSERT INTO tax_information (amount, transaction_date, tax_type, owner_id) VALUES 
				(505.0, current_timestamp(), 2, ownerID);
                
                SELECT 'Транспортний засіб успішно перереєстровано!' AS message;
            END IF;
        ELSE
            SELECT 'Неможливо зареєструвати транспортний засіб. Перевірте існування оператора або інспектора.' AS message;
        END IF;
    ELSE
        INSERT INTO vehicle (brand, model, year, color, weight, plate_id, vin, fuel_type, type, engine) 
        VALUES (v_brand, v_model, v_year, v_color, v_weight, plateID, v_vin, fuelID, typeID, v_engine);

        SELECT vehicle_id INTO new_vehicle_id FROM vehicle WHERE vin = v_vin;

        INSERT INTO vehicle_registration (registration_date, expiration_date, vehicle_id, owner_id, operator_id, inspector_id) 
        VALUES (reg_date, exp_date, new_vehicle_id, ownerID, operatorID, inspectorID);

        SELECT 'Транспортний засіб успішно зареєстровано!' AS message;
    END IF;
END;
//
DELIMITER ;

-- Додати декілька номерних знаків в базу даних
DELIMITER //
CREATE PROCEDURE addNumberPlates(IN plateValues VARCHAR(255))
BEGIN
    DECLARE valuePos INT;
    DECLARE commaPos INT;
    DECLARE plateValue VARCHAR(255);
    DECLARE done INT DEFAULT FALSE;
    DECLARE plateCursor CURSOR FOR SELECT value FROM temp_values;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DROP TEMPORARY TABLE IF EXISTS temp_values;
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_values (value VARCHAR(255));

    SET valuePos = 1;
    WHILE valuePos < LENGTH(plateValues) DO
        SET commaPos = LOCATE(',', plateValues, valuePos);
        IF commaPos = 0 THEN
            SET commaPos = LENGTH(plateValues) + 1;
        END IF;

        SET plateValue = SUBSTRING(plateValues, valuePos, commaPos - valuePos);
        INSERT INTO temp_values (value) VALUES (plateValue);

        SET valuePos = commaPos + 1;
    END WHILE;

    OPEN plateCursor;
    read_loop: LOOP
        FETCH plateCursor INTO plateValue;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        INSERT INTO number_plate (plate, status) VALUES (plateValue, 1);
    END LOOP;
    
    CLOSE plateCursor;
    DROP TEMPORARY TABLE IF EXISTS temp_values;
END;
//
DELIMITER ;

-- Додати новий тип транспортного засобу
DELIMITER //
CREATE PROCEDURE createVehicleType(
    IN v_type VARCHAR(55), IN max_payload DECIMAL(10,2)
)
BEGIN
	DECLARE type_exists INT;
	SELECT COUNT(*) INTO type_exists FROM vehicle_type WHERE type = v_type;
    
	 IF type_exists > 0 THEN
        SELECT 'Такий тип вже існує!' AS message;
    ELSE
		INSERT INTO vehicle_type (type, maximum_payload) 
			VALUES (v_type, max_payload);
        SELECT 'Тип транспортного засобу успішно додано!' AS message;
    END IF;
END;
//
DELIMITER ;

-- Додати новий тип палива
DELIMITER //
CREATE PROCEDURE createFuelType(
    IN v_fuel VARCHAR(55), IN o_rating INT
)
BEGIN
	DECLARE fuel_exists INT;
	SELECT COUNT(*) INTO fuel_exists FROM fuel_type WHERE fuel = v_fuel;
    
	 IF fuel_exists > 0 THEN
        SELECT 'Такий тип палива вже існує!' AS message;
    ELSE
		INSERT INTO fuel_type (fuel, octane_rating) 
			VALUES (v_fuel, o_rating);
        SELECT 'Тип палива успішно додано!' AS message;
    END IF;
END;
//
DELIMITER ;

-- Додати нового інспектора сервісного центру МВС
DELIMITER //
CREATE PROCEDURE createInspector(
    IN i_name VARCHAR(255), IN i_surname VARCHAR(255), 
    IN i_status ENUM('available', 'unavailable'), IN serv_code INT
)
BEGIN
    DECLARE inspector_exists INT;
    DECLARE service_center_exists INT;

    SELECT COUNT(*) INTO service_center_exists FROM service_center WHERE service_id = serv_code;

    IF service_center_exists = 0 THEN
        SELECT 'Неможливо додати інспектора. Сервісний центр із вказаним кодом не існує.' AS message;
    ELSE
        SELECT COUNT(*) INTO inspector_exists FROM inspector WHERE name = i_name AND surname = i_surname;

        IF inspector_exists > 0 THEN
            SELECT 'Такий інспектор вже зареєстрований!' AS message;
        ELSE
            INSERT INTO inspector (name, surname, status, service_center_code) 
            VALUES (i_name, i_surname, i_status, serv_code);

            SELECT 'Інспектора успішно додано!' AS message;
        END IF;
    END IF;
END;
//
DELIMITER ;

-- Додати нового оператора сервісного центру МВС
DELIMITER //
CREATE PROCEDURE createOperator(
    IN i_name VARCHAR(255), IN i_surname VARCHAR(255), 
    IN i_status ENUM('available', 'unavailable'), IN serv_code INT
)
BEGIN
    DECLARE operator_exists INT;
    DECLARE service_center_exists INT;

    SELECT COUNT(*) INTO service_center_exists FROM service_center WHERE service_id = serv_code;

    IF service_center_exists = 0 THEN
        SELECT 'Неможливо додати оператора. Сервісний центр із вказаним кодом не існує.' AS message;
    ELSE
        SELECT COUNT(*) INTO operator_exists FROM operator WHERE name = i_name AND surname = i_surname;

        IF operator_exists > 0 THEN
            SELECT 'Такий оператор вже зареєстрований!' AS message;
        ELSE
            INSERT INTO operator (name, surname, status, service_center_code) 
            VALUES (i_name, i_surname, i_status, serv_code);

            SELECT 'Оператора успішно додано!' AS message;
        END IF;
    END IF;
END;
//
DELIMITER ;

-- Додати новий сервісний центр
DELIMITER //
CREATE PROCEDURE createServiceCenter(
    IN serv_code CHAR(4), IN s_city VARCHAR(255),
    IN s_address VARCHAR(255), IN phone VARCHAR(15)
)
BEGIN
	DECLARE serv_exists INT;
	SELECT COUNT(*) INTO serv_exists FROM service_center WHERE service_code = serv_code;
    
	 IF serv_exists > 0 THEN
        SELECT 'Такий сервісний центр МВС вже існує!' AS message;
    ELSE
		INSERT INTO service_center (service_code, city, address, contact_phone) 
			VALUES (serv_code, s_city, s_address, phone);
        SELECT 'Сервісний центр МВС успішно додано!' AS message;
    END IF;
END;
//
DELIMITER ;

-- Вивести усіх вільних інспекторів та операторів певного сервісного центру МВС
DELIMITER //
CREATE PROCEDURE getAvailableWorkers(IN serv_code INT)
BEGIN
    DECLARE service_center_exists INT;

    SELECT COUNT(*) INTO service_center_exists
    FROM service_center
    WHERE service_id = serv_code;

    IF service_center_exists > 0 THEN
        SELECT 
            operator.operator_id,
            operator.name AS operator_name,
            operator.surname AS operator_surname,
            operator.status AS operator_status,
            inspector.inspector_id,
            inspector.name AS inspector_name,
            inspector.surname AS inspector_surname,
            inspector.status AS inspector_status
        FROM 
            operator
        JOIN 
            inspector ON operator.service_center_code = inspector.service_center_code
        WHERE 
            operator.service_center_code = serv_code
            AND operator.status = 'available'
            AND inspector.status = 'available';
    ELSE
        SELECT 'Такого сервісного центру не існує!' AS error_message;
    END IF;
END;
//
DELIMITER ;

CALL getNewestRegistrations(10);
CALL getAllRegisteredVehicles('Vlad', 'Donets');
CALL getAllRegisteredVehicles('Olena', 'Donets');
CALL getAllRegisteredVehicles('Petro', 'Petrovych');
SELECT * FROM fine WHERE fine_id = 1;
CALL changeFineStatus(1, 1, 2);
CALL checkFines(100);
CALL checkFines(1010);
CALL changeInspectorStatus(1, 2);
CALL changeOperatorStatus(1, 2);
CALL getAllRegisteredVehiclesByVin('VINZAFIRA22OP');
CALL getAllRegisteredVehiclesByVin('WUADU12FG7EN643362');
CALL createOwner('Arsen', 'Kozachuk', '(095) 055 44 33', 'Kovel', 'Peremogy 12/2', '859310-0006');
SELECT * FROM owner ORDER BY owner_id DESC;
CALL createFine(current_timestamp(), 2554.2, 'Creating an emergency situation', 'paid', 1009);
SELECT * FROM fine WHERE vehicle_id = 1009;
CALL createVehicle('test', 'A4', 2019, 'White', 2200, 1030, 'testvin00', 1, 6, 2.0);
CALL createRegistration(current_timestamp(), DATE_ADD(NOW(), INTERVAL 2 YEAR), 
'BMW', '550', 2013, 'White', 2200.5, 1026, 'newbmwvin', 2, 4, 3, 'Zlata', 'Tkachuk', '(095) 2345689', 'Kovel', 'Centralna 56', '1h23570-2118', 2, 12);
CALL addNumberPlates('0177,2005,0405,9005');
SELECT * FROM number_plate;
CALL createVehicleType('new type', 2000);
CALL createFuelType('new fuel', 2);
CALL createInspector('John', 'Veyton', 1, 5);
CALL createOperator('Amily', 'Rodrigez', 1, 5);
CALL createServiceCenter('0002', 'some city2', 'some address2', '111 111 11 11');
CALL getAvailableWorkers(5);