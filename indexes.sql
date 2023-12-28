USE service_center;

CREATE INDEX idx_inspector_status_service_center ON inspector(status, service_center_code);
CREATE INDEX idx_service_center_city ON service_center(city);
CREATE INDEX idx_vehicle_fuel_type_type_weight ON vehicle(fuel_type, type, weight);
CREATE INDEX idx_vehicle_weight ON vehicle(weight);
CREATE INDEX idx_vehicle_year_fuel_type ON vehicle(year, fuel_type);
CREATE INDEX idx_vehicle_registration_owner_vehicle ON vehicle_registration(owner_id, vehicle_id);
CREATE INDEX idx_tax_information_owner_id ON tax_information(owner_id);
CREATE INDEX idx_fine_status_vehicle_id ON fine(status, vehicle_id);
CREATE INDEX idx_owner_name ON owner(name);
CREATE INDEX idx_owner_owner_id ON owner(owner_id);
CREATE INDEX idx_service_center_service_id ON service_center(service_id);
CREATE INDEX idx_operator_name ON operator(name);
CREATE INDEX idx_vehicle_vehicle_id_plate_id ON vehicle(vehicle_id, plate_id);
CREATE INDEX idx_vehicle_fuel_type_type ON vehicle(fuel_type, type);
CREATE INDEX idx_inspector_inspector_id ON inspector(inspector_id);
CREATE INDEX idx_vehicle_vehicle_id_weight ON vehicle(vehicle_id, weight);
CREATE INDEX idx_inspector_inspector_id_service_center_code ON inspector(inspector_id, service_center_code);
CREATE INDEX idx_vehicle_vin ON vehicle(vin);



