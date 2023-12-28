USE service_center;

-- Вивести всіх вільних інспекторів, які працюють в м. Ковель
SELECT 
	inspector_id, 
	name, 
	surname, 
	status, 
	service_code, 
	city AS service_city, 
	address AS service_address, 
	contact_phone AS service_contact_phone FROM inspector
JOIN 
	service_center ON inspector.service_center_code = service_center.service_id
WHERE status = 1 AND city = 'Kovel';


-- Вивести всіх інспекторів, які працюють в м. Ковель
SELECT 
	inspector_id, 
	name, 
	surname, 
	status, 
	service_code, 
	city AS service_city, 
	address AS service_address, 
	contact_phone AS service_contact_phone FROM inspector
JOIN 
	service_center ON inspector.service_center_code = service_center.service_id
WHERE city = 'Kovel';

-- Вивести всі транспорті засоби
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
JOIN vehicle_type ON vehicle.type = vehicle_type.type_id
ORDER BY vehicle_id ASC;

-- Вивести всі транспорті засоби, фактична маса яких перевищує максимальну допустиму масу типу транспортного засобу
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
JOIN vehicle_type ON vehicle.type = vehicle_type.type_id
WHERE weight > maximum_payload;

-- Вивести всі дизельні та електричні транспорті засоби, у яких рік випуску більший або дорівнює 2010.
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
JOIN vehicle_type ON vehicle.type = vehicle_type.type_id
WHERE year >= 2010 AND fuel IN ('Diesel', 'Electricity');

-- Вивести всі дані про автомобіль, його власника та дійсну реєстрацію
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
    name AS owner_name,
    surname AS owner_surname,
    phone_number,
    city,
    address,
    passport_number
FROM 
	vehicle_registration
JOIN all_vehicles ON vehicle_registration.vehicle_id = all_vehicles.vehicle_id
JOIN all_inspectors ON vehicle_registration.inspector_id = all_inspectors.inspector_id
JOIN all_owners ON vehicle_registration.owner_id = all_owners.owner_id
ORDER BY registration_id ASC;

-- Вивести всі особисті дані про власників та їх сплачені транзакції
SELECT 
	tax_id,
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

-- Вивести всі дані про штраф та автомобіль, який має штрафи
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
JOIN vehicle_type ON vehicle_type.type_id = vehicle.type;

-- Вивести всі особисті дані про власників та їх сплачені транзакції, ім'я яких починається на літеру С
SELECT 
	tax_id,
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
JOIN owner ON tax_information.owner_id = owner.owner_id
WHERE name LIKE 'C%';

-- Об'єднати та вивести імена всіх інспекторів та операторів, які працюють в м.Ковель
SELECT inspector.name FROM inspector
JOIN service_center ON inspector.service_center_code = service_center.service_id
WHERE city = 'Kovel' 
UNION
SELECT operator.name FROM operator
JOIN service_center ON operator.service_center_code = service_center.service_id
WHERE city = 'Kovel';

-- Вивести кількість штрафів для кожного автомобіля
SELECT
    vehicle.vehicle_id,
    number_plate.plate,
    COUNT(fine.fine_id) AS fine_count
FROM vehicle
LEFT JOIN fine ON fine.vehicle_id = vehicle.vehicle_id
JOIN number_plate ON number_plate.plate_id = vehicle.plate_id
GROUP BY vehicle.vehicle_id, number_plate.plate;

-- Порахувати суму усіх штрафів і вивести кількість штрафів для кожного автомобіля 
SELECT
    vehicle.vehicle_id,
    number_plate.plate,
    COUNT(fine.fine_id) AS fine_count,
    SUM(fine.amount) AS fine_amount
FROM vehicle
LEFT JOIN fine ON fine.vehicle_id = vehicle.vehicle_id
JOIN number_plate ON number_plate.plate_id = vehicle.plate_id
GROUP BY vehicle.vehicle_id, number_plate.plate;

-- Вивести інформацію про зареєстровані машини власника за ім'ям та прізвищем, якщо такі є
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
AND 
	vehicle_registration.owner_id = owner.owner_id
AND 
	vehicle.fuel_type = fuel_type.fuel_id
AND 
	vehicle.type = vehicle_type.type_id
AND 
	vehicle.plate_id = number_plate.plate_id
AND 
	owner.name = 'Vlad' AND owner.surname = 'Donets';
    
-- Вивести інформацію про зареєстрований транспортний засіб за він кодом авто, використовуючи представлення
SELECT * FROM all_registration_info WHERE all_registration_info.vin = 'WAULT68E94A862556';

-- Вивести ім'я, адресу та місто власників авто, які мають несплачені штрафи
SELECT name, city, address
FROM owner
JOIN vehicle_registration ON owner.owner_id = vehicle_registration.owner_id
JOIN fine  ON vehicle_registration.vehicle_id = fine.vehicle_id
WHERE fine.status = 'pending';

-- Вивести всі дані про власника, транспортний засіб якого реєстрував оператор з певним іменем
SELECT *
FROM owner
JOIN vehicle_registration ON owner.owner_id = vehicle_registration.owner_id
JOIN operator ON vehicle_registration.operator_id = operator.operator_id
WHERE operator.name LIKE 'R%';

-- Вивести всі дані про зареєстрований транспортний засіб та дату закічення реєстрації, яка спливає через місяць
SELECT vehicle.*, vehicle_registration.expiration_date
FROM vehicle
JOIN vehicle_registration ON vehicle.vehicle_id = vehicle_registration.vehicle_id
WHERE 
	vehicle_registration.expiration_date BETWEEN CURDATE() 
AND 
	CURDATE() + INTERVAL 1 MONTH;

-- Вивести всю інформацію про сервісний центр МВС та кількість вільних операторів
SELECT service_center.*, COUNT(operator.operator_id) AS available_operators
FROM service_center
LEFT JOIN operator ON service_center.service_id = operator.service_center_code 
AND 
	operator.status = 'available'
GROUP BY service_center.service_id;

-- Вивести всю інформацію про власників та кількість їх зареєстрованих авто, якщо їх більше ніж 1
SELECT owner.*, COUNT(vehicle_registration.vehicle_id) AS vehicle_count
FROM owner
JOIN vehicle_registration ON owner.owner_id = vehicle_registration.owner_id
GROUP BY owner.owner_id
HAVING vehicle_count > 1;

-- Вивести кожен тип автомобіля та середню вагу типу, на основі ваги транспортних засобів такого типу
SELECT vehicle_type.type, AVG(vehicle.weight) AS average_weight
FROM vehicle_type
JOIN vehicle ON vehicle_type.type_id = vehicle.type
GROUP BY vehicle_type.type_id;

-- Вивести імена інспекторів та кількість транспортних засобів, які вони інспектували
SELECT inspector.name, inspector.surname, COUNT(vehicle_registration.vehicle_id) AS vehicles_inspected
FROM inspector
JOIN vehicle_registration ON inspector.inspector_id = vehicle_registration.inspector_id
GROUP BY inspector.inspector_id
ORDER BY vehicles_inspected DESC;


-- Вивести інформацію про власника, його штрафи та його загальну сплачену суму штрафів
SELECT o.owner_id, o.name AS owner_name, v.vehicle_id, v.brand, v.model, f.fine_id, f.amount AS fine_amount,
       (SELECT SUM(f2.amount) FROM fine f2 WHERE f2.vehicle_id = v.vehicle_id AND f2.status = 'paid') AS total_paid_fines
FROM owner o
JOIN vehicle_registration vr ON o.owner_id = vr.owner_id
JOIN vehicle v ON vr.vehicle_id = v.vehicle_id
LEFT JOIN fine f ON v.vehicle_id = f.vehicle_id
ORDER BY o.owner_id, v.vehicle_id, f.fine_id;

-- Вивести інформацію про сервісний центр МВС разом з кількістю вільних/зайнятих операторів та інспекторів
SELECT sc.service_id, sc.city, sc.address, 
       COUNT(CASE WHEN o.status = 'available' THEN 1 END) AS available_operators,
       COUNT(CASE WHEN o.status = 'unavailable' THEN 1 END) AS unavailable_operators
FROM service_center sc
LEFT JOIN operator o ON sc.service_id = o.service_center_code
GROUP BY sc.service_id, sc.city, sc.address
ORDER BY sc.service_id;

-- Вивести інформацію про власника, який має декілька транспортних засобів та їхню загальну вагу, якщо вона більша за 4300
SELECT o.owner_id, o.name AS owner_name, COUNT(v.vehicle_id) AS vehicle_count, 
       SUM(v.weight) AS total_vehicle_weight
FROM owner o
JOIN vehicle_registration vr ON o.owner_id = vr.owner_id
JOIN vehicle v ON vr.vehicle_id = v.vehicle_id
GROUP BY o.owner_id, o.name
HAVING vehicle_count > 1 AND total_vehicle_weight > 4300
ORDER BY total_vehicle_weight DESC;

-- Вивести інформацію про власника, який володіє траспортним засобом, фактична маса якого більша за середню масу всіх транспортних засобів
SELECT owner_id, name AS owner_name
FROM owner
WHERE owner_id IN (
    SELECT DISTINCT o.owner_id
    FROM owner o
    JOIN vehicle_registration vr ON o.owner_id = vr.owner_id
    JOIN vehicle v ON vr.vehicle_id = v.vehicle_id
    WHERE v.weight > (SELECT AVG(weight) FROM vehicle)
);

-- Вивести інформацію про автомобіль, який має штрафи та його максимальну суму штрафу
SELECT v.vehicle_id, v.brand, v.model, f.fine_id, f.amount AS fine_amount,
       (SELECT MAX(f2.amount) FROM fine f2 WHERE f2.vehicle_id = v.vehicle_id) AS max_fine_amount
FROM vehicle v
LEFT JOIN fine f ON v.vehicle_id = f.vehicle_id
WHERE f.fine_id IS NOT NULL ORDER BY v.vehicle_id ASC;

-- Вивести інформацію про сервісний центр та власників які реєстрували транспортний засіб в сервісному центрі, в якому найбільше вільних операторів
SELECT DISTINCT
    o.owner_id,
    o.name,
    o.surname AS owner_name,
    sc_op.service_id AS top_service_center_id,
    sc_op.service_code AS top_service_center_code,
    sc_op.city AS top_service_center_city
FROM
    owner o
JOIN vehicle_registration vr ON o.owner_id = vr.owner_id
JOIN operator op ON vr.operator_id = op.operator_id
JOIN inspector insp ON vr.inspector_id = insp.inspector_id
JOIN service_center sc_op ON op.service_center_code = sc_op.service_id
JOIN (
    SELECT
        i.service_center_code
    FROM
        inspector i
    WHERE
        i.status = 'available'
    GROUP BY
        i.service_center_code
    ORDER BY
        COUNT(*) DESC
    LIMIT 1
) AS top_sc ON sc_op.service_id = top_sc.service_center_code;

-- Вивести всі перереєстровані транспортні засоби
SELECT
    v.vehicle_id,
    v.brand,
    v.model,
    v.year,
    v.color,
    v.weight,
    v.plate_id,
    v.vin,
    v.fuel_type,
    v.type,
    v.engine,
    o.name AS owner_name,
    o.surname AS owner_surname,
    o.phone_number,
    o.city,
    o.address,
    o.passport_number,
    vr.registration_date,
    vr.expiration_date,
    ti.amount,
    ti.transaction_date,
    ti.tax_type
FROM
    vehicle v
JOIN
    vehicle_registration vr ON v.vehicle_id = vr.vehicle_id
JOIN
    owner o ON vr.owner_id = o.owner_id
JOIN
    tax_information ti ON vr.owner_id = ti.owner_id
WHERE
    ti.tax_type = 2;
