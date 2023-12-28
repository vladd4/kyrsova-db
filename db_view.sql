USE service_center;

-- Вивести всіх інспекторів сервісного центру МВС
CREATE VIEW all_inspectors AS
SELECT 
	inspector_id, 
	name, 
	surname, 
	status, 
	service_code, 
	city AS service_city, 
	address AS service_address, 
	contact_phone AS service_contact_phone 
FROM inspector
JOIN 
	service_center ON inspector.service_center_code = service_center.service_id;

-- Вивести всі транспорті засоби
CREATE VIEW all_vehicles AS
SELECT 
	vehicle_id,
    brand,
    model,
    year,
    color,
    weight,
    vin,
    fuel,
    vehicle_type.type,
    engine,
    octane_rating,
    maximum_payload
 FROM vehicle
JOIN fuel_type ON vehicle.fuel_type = fuel_type.fuel_id
JOIN vehicle_type ON vehicle.type = vehicle_type.type_id;

-- Вивести всіх операторів сервісного центру МВС
CREATE VIEW all_operators AS
SELECT 
	operator_id, 
	name, 
	surname, 
	status, 
	service_code, 
	city AS service_city, 
	address AS service_address, 
	contact_phone AS service_contact_phone 
FROM operator
JOIN 
	service_center ON operator.service_center_code = service_center.service_id;

-- Вивести всі особисті дані про власників та їх сплачені транзакції    
CREATE VIEW all_owners AS
SELECT 
	owner.owner_id,
    amount AS tax_amount,
    transaction_date,
    tax_type,
    name AS owner_name,
    surname AS owner_surname,
    phone_number,
    city,
    address,
    passport_number
FROM tax_information
JOIN owner ON tax_information.owner_id = owner.owner_id;   


-- Вивести всі дані про автомобіль, його власника та дійсну реєстрацію
CREATE VIEW all_registration_info AS
SELECT  
	registration_id,
    registration_date,
    expiration_date,
    brand,
    model,
    year,
    color,
    weight,
    vin,
    fuel,
    type,
    engine,
    octane_rating,
    owner.name AS owner_name,
    owner.surname AS owner_surname,
    owner.phone_number,
    owner.city,
    owner.address,
    owner.passport_number,
	all_inspectors.inspector_id, 
	all_inspectors.name AS inspector_name, 
	all_inspectors.surname AS inspector_surname, 
	all_inspectors.service_code AS inspector_service_code
FROM 
	vehicle_registration
JOIN all_vehicles ON vehicle_registration.vehicle_id = all_vehicles.vehicle_id
JOIN all_inspectors ON vehicle_registration.inspector_id = all_inspectors.inspector_id
JOIN owner ON vehicle_registration.owner_id = owner.owner_id;


SELECT * FROM all_owners;
SELECT * FROM all_operators ORDER BY operator_id ASC;
SELECT * FROM all_inspectors ORDER BY inspector_id ASC;
SELECT * FROM all_vehicles ORDER BY vehicle_id ASC;
SELECT * FROM all_registration_info ORDER BY registration_id ASC;


