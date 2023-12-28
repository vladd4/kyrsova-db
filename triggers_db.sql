USE service_center;

-- Оновити статус номерного знака на "вільний", коли авто видаляється з бази
DELIMITER //
CREATE TRIGGER delete_vehicle_trigger
AFTER DELETE ON vehicle
FOR EACH ROW
BEGIN
	UPDATE number_plate
    SET number_plate.status = 'available'
	WHERE number_plate.plate_id = OLD.plate_id;
END;
//
DELIMITER ;

select * from vehicle where vehicle_id = 1019;
select * from number_plate where plate_id = 1030;
DELETE FROM vehicle WHERE vehicle_id = 1019;
select * from vehicle where vehicle_id = 1019;
select * from number_plate where plate_id = 1030;
-- Змінити статус інспекторів та операторів сервісного центру, дані якого були змінені
DELIMITER //
CREATE TRIGGER modify_service_trigger
AFTER UPDATE ON service_center
FOR EACH ROW
BEGIN
	UPDATE inspector
    SET status = 'available'
    WHERE service_center_code = NEW.service_id;
    
    UPDATE operator
    SET status = 'available'
    WHERE service_center_code = NEW.service_id;
END;
//
DELIMITER ;

SELECT * FROM inspector WHERE service_center_code = 2;
SELECT * FROM service_center WHERE service_id = 2;
UPDATE service_center SET address = 'new test address';
SELECT * FROM inspector WHERE service_center_code = 2;
SELECT * FROM service_center WHERE service_id = 2;
-- Встановити статус штрафу 'pending' для нового штрафу
DELIMITER //
CREATE TRIGGER insert_fine_trigger
BEFORE INSERT ON fine
FOR EACH ROW
BEGIN
    SET NEW.status = 'pending';
END;
//
DELIMITER ;

-- Автоматично створити квитанцію про оплату послуг реєстрації після створення нової реєстрації
DELIMITER //
CREATE TRIGGER insert_registration_trigger
AFTER INSERT ON vehicle_registration
FOR EACH ROW
BEGIN
	INSERT INTO tax_information (amount, transaction_date, tax_type, owner_id) VALUES 
		(764.0, current_timestamp(), 1, NEW.owner_id);
END;
//
DELIMITER ;

-- Автоматично задати статус номерного знаку "зайнятий" після створення нової реєстрації
DELIMITER //
CREATE TRIGGER insert_vehicle_trigger
AFTER INSERT ON vehicle_registration
FOR EACH ROW
BEGIN
    UPDATE number_plate
    SET status = 2
    WHERE plate_id = (SELECT plate_id FROM vehicle WHERE vehicle_id = NEW.vehicle_id);
END;
//
DELIMITER ;

