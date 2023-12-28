use service_center;

-- Зміна типу стовпця та додавання генератора AUTO_INCREMENT для таблиці owner
ALTER TABLE owner
MODIFY COLUMN owner_id INTEGER AUTO_INCREMENT;

-- Зміна типу стовпця та додавання генератора AUTO_INCREMENT для таблиці number_plate
ALTER TABLE number_plate
MODIFY COLUMN plate_id INTEGER AUTO_INCREMENT;

-- Зміна типу стовпця та додавання генератора AUTO_INCREMENT для таблиці vehicle_type
ALTER TABLE vehicle_type
MODIFY COLUMN type_id INTEGER AUTO_INCREMENT;

-- Зміна типу стовпця та додавання генератора AUTO_INCREMENT для таблиці fuel_type
ALTER TABLE fuel_type
MODIFY COLUMN fuel_id INTEGER AUTO_INCREMENT;

-- Змінюємо тип стовпця та додаємо властивість AUTO_INCREMENT для таблиці vehicle
ALTER TABLE vehicle
MODIFY COLUMN vehicle_id INTEGER AUTO_INCREMENT;

-- Зміна типу стовпця та додавання генератора AUTO_INCREMENT для таблиці service_center
ALTER TABLE service_center
MODIFY COLUMN service_id INTEGER AUTO_INCREMENT;

-- Зміна типу стовпця та додавання генератора AUTO_INCREMENT для таблиці operator
ALTER TABLE operator
MODIFY COLUMN operator_id INTEGER AUTO_INCREMENT;

-- Зміна типу стовпця та додавання генератора AUTO_INCREMENT для таблиці inspector
ALTER TABLE inspector
MODIFY COLUMN inspector_id INTEGER AUTO_INCREMENT;

-- Зміна типу стовпця та додавання генератора AUTO_INCREMENT для таблиці vehicle_registration
ALTER TABLE vehicle_registration
MODIFY COLUMN registration_id INTEGER AUTO_INCREMENT;

-- Зміна типу стовпця та додавання генератора AUTO_INCREMENT для таблиці tax_information
ALTER TABLE tax_information
MODIFY COLUMN tax_id INTEGER AUTO_INCREMENT;

-- Зміна типу стовпця та додавання генератора AUTO_INCREMENT для таблиці fine
ALTER TABLE fine
MODIFY COLUMN fine_id INTEGER AUTO_INCREMENT;
