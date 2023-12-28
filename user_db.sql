USE service_center;

CREATE ROLE IF NOT EXISTS service_admin;
CREATE ROLE IF NOT EXISTS service_operator;
CREATE ROLE IF NOT EXISTS service_inspector;

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER ON service_center.* TO service_admin;

GRANT SELECT ON service_center.* TO service_operator;

GRANT SELECT ON fuel_type TO service_inspector;
GRANT SELECT ON inspector TO service_inspector;
GRANT SELECT ON vehicle TO service_inspector;
GRANT SELECT ON vehicle_registration TO service_inspector;
GRANT SELECT ON vehicle_type TO service_inspector;

CREATE USER IF NOT EXISTS 'service_admin'@'localhost' IDENTIFIED BY 'service_admin';
GRANT service_admin TO 'service_admin'@'localhost';

CREATE USER IF NOT EXISTS 'service_operator'@'localhost' IDENTIFIED BY 'service_operator';
GRANT service_operator TO 'service_operator'@'localhost';

CREATE USER IF NOT EXISTS 'service_inspector'@'localhost' IDENTIFIED BY 'service_inspector';
GRANT service_inspector TO 'service_inspector'@'localhost';