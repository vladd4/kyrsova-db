DROP DATABASE IF EXISTS service_center;
CREATE DATABASE service_center;

USE service_center;

CREATE TABLE owner (
  owner_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  surname VARCHAR(255) NOT NULL,
  phone_number VARCHAR(15),
  city VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  passport_number VARCHAR(15) NOT NULL
);

CREATE TABLE number_plate (
  plate_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  plate VARCHAR(8) NOT NULL,
  status ENUM('available', 'unavailable') NOT NULL DEFAULT 'available'
);

CREATE TABLE vehicle_type (
  type_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  type VARCHAR(55) NOT NULL,
  maximum_payload DECIMAL(10,2) NOT NULL
);

CREATE TABLE fuel_type (
  fuel_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  fuel VARCHAR(55) NOT NULL,
  octane_rating INTEGER
);

CREATE TABLE vehicle (
  vehicle_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  brand VARCHAR(255) NOT NULL,
  model VARCHAR(255) NOT NULL,
  year INTEGER NOT NULL,
  color VARCHAR(55) NOT NULL,
  weight DECIMAL(10,2),
  plate_id INTEGER UNIQUE NOT NULL,
  vin VARCHAR(17) UNIQUE NOT NULL,
  fuel_type INTEGER NOT NULL,
  type INTEGER NOT NULL,
  engine DECIMAL(2,1) NOT NULL CHECK (engine > 0),
  FOREIGN KEY (plate_id) REFERENCES number_plate(plate_id),
  FOREIGN KEY (fuel_type) REFERENCES fuel_type(fuel_id),
  FOREIGN KEY (type) REFERENCES vehicle_type(type_id)
);

CREATE TABLE service_center (
  service_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  service_code CHAR(4) NOT NULL,
  city VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  contact_phone VARCHAR(15) NOT NULL,
  CONSTRAINT chk_service_code CHECK (LENGTH(service_code) = 4 AND REGEXP_LIKE(service_code, '^[0-9]{4}$'))
);

CREATE TABLE operator (
  operator_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  surname VARCHAR(255) NOT NULL,
  status ENUM('available', 'unavailable') NOT NULL DEFAULT 'available',
  service_center_code INTEGER NOT NULL,
  FOREIGN KEY (service_center_code) REFERENCES service_center(service_id)
);                                                     

CREATE TABLE inspector (
  inspector_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  surname VARCHAR(255) NOT NULL,
  status ENUM('available', 'unavailable') NOT NULL DEFAULT 'available',
  service_center_code INTEGER NOT NULL,
  FOREIGN KEY (service_center_code) REFERENCES service_center(service_id)
);  

CREATE TABLE vehicle_registration (
  registration_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expiration_date TIMESTAMP NOT NULL,
  vehicle_id INTEGER NOT NULL,
  owner_id INTEGER NOT NULL,
  operator_id INTEGER NOT NULL,
  inspector_id INTEGER NOT NULL,
  FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id),
  FOREIGN KEY (owner_id) REFERENCES owner(owner_id),
  FOREIGN KEY (operator_id) REFERENCES operator(operator_id),
  FOREIGN KEY (inspector_id) REFERENCES inspector(inspector_id)
);
 

CREATE TABLE tax_information (
  tax_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  tax_type ENUM('registration', 'reregistration') NOT NULL DEFAULT 'registration',
  owner_id INTEGER NOT NULL,
  FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
);


CREATE TABLE fine (
  fine_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  description VARCHAR(255),
  status ENUM('paid', 'pending') NOT NULL DEFAULT 'pending',
  vehicle_id INTEGER NOT NULL,
  FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
);
