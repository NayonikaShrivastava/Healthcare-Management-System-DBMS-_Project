-- Ensure the composite type for the prescription procedure exists
-- You might need to run this CREATE TYPE command once before the procedures that use it.
-- Check if the type already exists before creating it.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'drug' AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = current_schema())) THEN
        CREATE TYPE Drug AS (
            trade_name VARCHAR,
            pc_name VARCHAR,
            quantity INTEGER
        );
    END IF;
END$$;


-- 1. Add Pharmaceutical Companies
CALL add_pharmaCompany('PharmaCorp', '123-456-7890');
CALL add_pharmaCompany('MediSolutions', '987-654-3210');

-- 2. Add Drugs produced by these companies
CALL add_drug('PainAway', 'C16H13ClN2O', 'PharmaCorp');
CALL add_drug('HealFast', 'C9H8O4', 'PharmaCorp');
CALL add_drug('VitaBoost', 'C63H88CoN14O14P', 'MediSolutions');

-- 3. Add Pharmacies
CALL add_pharmacy('Central Pharmacy', '123 Main St, Anytown', '555-111-2222');
CALL add_pharmacy('Community Drugs', '456 Oak Ave, Anytown', '555-333-4444');

-- 4. Add Contracts between Pharmacies and Companies
CALL add_contract('123 Main St, Anytown', 'PharmaCorp', 'Standard supply agreement', '2024-01-01', '2025-12-31', 'John Smith');
CALL add_contract('456 Oak Ave, Anytown', 'MediSolutions', 'Exclusive vitamin distribution', '2024-03-15', '2026-03-14', 'Alice Brown');
CALL add_contract('123 Main St, Anytown', 'MediSolutions', 'General pharmaceuticals contract', '2023-06-01', '2024-05-31', 'Robert Jones'); -- Example contract

-- 5. Add Drugs to Pharmacy Inventory (Sells table)
CALL add_PharmacyInventory('PainAway', 'PharmaCorp', '123 Main St, Anytown', 15);
CALL add_PharmacyInventory('HealFast', 'PharmaCorp', '123 Main St, Anytown', 10);
CALL add_PharmacyInventory('VitaBoost', 'MediSolutions', '123 Main St, Anytown', 25);
CALL add_PharmacyInventory('VitaBoost', 'MediSolutions', '456 Oak Ave, Anytown', 26);

-- 6. Add Patients
CALL add_patient('111122223333', 'Alice Wonderland', 30, '10 Rabbit Hole Ln');
CALL add_patient('444455556666', 'Bob The Builder', 45, '20 Construction Rd');
CALL add_patient('777788889999', 'Charlie Chaplin', 55, '30 Silent Film Ave');

-- 7. Add Doctors
CALL add_doctor('DOC123456789', 'Dr. Eve Adams', 'Cardiology', 15);
CALL add_doctor('DOC987654321', 'Dr. Frank Stein', 'Neurology', 22);

-- 8. Add Consultations between Patients and Doctors
CALL add_consultation('111122223333', 'DOC123456789'); -- Alice consults Dr. Adams
CALL add_consultation('444455556666', 'DOC987654321'); -- Bob consults Dr. Stein
CALL add_consultation('111122223333', 'DOC987654321'); -- Alice also consults Dr. Stein

-- 9. Add Prescriptions (using the complex procedure)
 CALL add_prescription_one_only('DOC123456789', '111122223333', 'PainAway', 'PharmaCorp', '2023-01-01', 10);
 CALL add_prescription_one_only('DOC123456789', '777788889999', 'HealFast', 'PharmaCorp', '2023-01-01', 10);
