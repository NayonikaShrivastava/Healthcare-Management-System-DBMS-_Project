
-- Add Patient Procedure
CREATE OR REPLACE PROCEDURE add_patient (
    IN patient_aadharID VARCHAR,
    IN patient_name VARCHAR,
    IN patient_age INTEGER,
    IN patient_address VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Patient(AadharID, Name, Age, Address)
    VALUES (patient_aadharID, patient_name, patient_age, patient_address);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Unable to add new patient: %', SQLERRM;
END;
$$;


-- Add Doctor Procedure
CREATE OR REPLACE PROCEDURE add_doctor (
    IN doctor_aadharID VARCHAR,
    IN doctor_name VARCHAR,
    IN doctor_speciality VARCHAR,
    IN doctor_experience INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Doctor(AadharID, Name, Specialty, YearsOfExperience)
    VALUES (doctor_aadharID, doctor_name, doctor_speciality, doctor_experience);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Unable to add new doctor: %', SQLERRM;
END;
$$;


-- Add Pharmaceutical Company Procedure
CREATE OR REPLACE PROCEDURE add_pharmaCompany (
    IN pc_name VARCHAR,
    IN pc_phone VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO PharmaceuticalCompany(Name, Phone)
    VALUES (pc_name, pc_phone);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Unable to add new pharma firm: %', SQLERRM;
END;
$$;


-- Add Drug Procedure
CREATE OR REPLACE PROCEDURE add_drug (
    IN Trade_Name VARCHAR,
    IN Formula VARCHAR,
    IN PC_Name VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Drug(TradeName, Formula, PC_Name)
    VALUES (Trade_Name, Formula, PC_Name);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Unable to add new drug: %', SQLERRM;
END;
$$;


-- Add Pharmacy Procedure
CREATE OR REPLACE PROCEDURE add_pharmacy (
    IN Pharmacy_Name VARCHAR,
    IN Pharmacy_Address VARCHAR,
    IN Pharmacy_Phone VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Pharmacy(Name, Address, Phone)
    VALUES (Pharmacy_Name, Pharmacy_Address, Pharmacy_Phone);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Unable to add new pharmacy: %', SQLERRM;
END;
$$;


-- Add Contract Procedure
CREATE OR REPLACE PROCEDURE add_contract (
    IN Pharmacy_Address VARCHAR,
    IN PC_Name VARCHAR,
    IN Content VARCHAR,
    IN StartDate DATE,
    IN EndDate DATE,
    IN Supervisor VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Contract(Address, PC_Name, Content, StartDate, EndDate, Supervisor)
    VALUES (Pharmacy_Address, PC_Name, Content, StartDate, EndDate, Supervisor);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Unable to add new contract: %', SQLERRM;
END;
$$;


-- Add Pharmacy Inventory Procedure
CREATE OR REPLACE PROCEDURE add_PharmacyInventory (
    IN Trade_Name VARCHAR,
    IN PC_Name VARCHAR,
    IN Address_Pharmacy VARCHAR,
    IN Price INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Sells(Trade_Name, PC_Name, Address_Pharmacy, Price)
    VALUES (Trade_Name, PC_Name, Address_Pharmacy, Price);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Unable to add new pharmacy inventory item: %', SQLERRM;
END;
$$;


-- Add Consultation Procedure
CREATE OR REPLACE PROCEDURE add_consultation (
    IN AadharID_P VARCHAR,
    IN AadharID_D VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Consults(AadharID_P, AadharID_D)
    VALUES (AadharID_P, AadharID_D);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Unable to add new consultation: %', SQLERRM;
END;
$$;



CREATE OR REPLACE PROCEDURE add_full_prescription_with_check (
    IN p_doctorID VARCHAR,
    IN p_patientID VARCHAR,
    IN p_date DATE,
    IN p_drugs Drug[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    existing_date DATE;
    drug_exists   INTEGER;
    i             INTEGER;
BEGIN
    -- Check if a prescription already exists for this doctor-patient pair
    BEGIN
        SELECT Date INTO existing_date
        FROM Prescription
        WHERE AadharID_D = p_doctorID AND AadharID_P = p_patientID;

        -- If new date is more recent, replace it
        IF p_date > existing_date THEN
            DELETE FROM Prescription
            WHERE AadharID_D = p_doctorID AND AadharID_P = p_patientID;

            INSERT INTO Prescription (Date, AadharID_D, AadharID_P)
            VALUES (p_date, p_doctorID, p_patientID);

            FOR i IN 1 .. array_length(p_drugs, 1) LOOP
                SELECT COUNT(*) INTO drug_exists
                FROM Drug
                WHERE TradeName = p_drugs[i].trade_name
                  AND PC_Name = p_drugs[i].pc_name;

                IF drug_exists = 0 THEN
                    RAISE EXCEPTION 'Drug does not exist: % by %',
                        p_drugs[i].trade_name, p_drugs[i].pc_name;
                END IF;

                INSERT INTO Contains (Date, AadharID_D, AadharID_P, Trade_Name, PC_Name, Quantity)
                VALUES (p_date, p_doctorID, p_patientID,
                        p_drugs[i].trade_name, p_drugs[i].pc_name, p_drugs[i].quantity);
            END LOOP;
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- No previous prescription exists: insert a new one
            INSERT INTO Prescription (Date, AadharID_D, AadharID_P)
            VALUES (p_date, p_doctorID, p_patientID);

            FOR i IN 1 .. array_length(p_drugs, 1) LOOP
                SELECT COUNT(*) INTO drug_exists
                FROM Drug
                WHERE TradeName = p_drugs[i].trade_name
                  AND PC_Name = p_drugs[i].pc_name;

                IF drug_exists = 0 THEN
                    RAISE EXCEPTION 'Drug does not exist: % by %',
                        p_drugs[i].trade_name, p_drugs[i].pc_name;
                END IF;

                INSERT INTO Contains (Date, AadharID_D, AadharID_P, Trade_Name, PC_Name, Quantity)
                VALUES (p_date, p_doctorID, p_patientID,
                        p_drugs[i].trade_name, p_drugs[i].pc_name, p_drugs[i].quantity);
            END LOOP;
    END;


EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in prescription procedure: %', SQLERRM;
        ROLLBACK;
END;
$$;


CREATE OR REPLACE PROCEDURE add_prescription_one_only (
    p_doctorid        VARCHAR,
    p_patientid       VARCHAR,
    p_trade_name      VARCHAR,
    p_pcname          VARCHAR,
    p_date            DATE,
    p_qty             INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    existing_date DATE;
BEGIN
    -- Check for existing prescription
    SELECT date INTO existing_date
    FROM Prescription
    WHERE AadharID_D = p_doctorid AND AadharID_P = p_patientid;

    IF FOUND THEN
        -- Replace if new date is more recent
        IF p_date > existing_date THEN
            DELETE FROM Prescription
            WHERE AadharID_D = p_doctorid AND AadharID_P = p_patientid;

            INSERT INTO Prescription (Date, AadharID_D, AadharID_P)
            VALUES (p_date, p_doctorid, p_patientid);

            INSERT INTO Contains (Date, AadharID_D, AadharID_P, Trade_Name, PC_Name, Quantity)
            VALUES (p_date, p_doctorid, p_patientid, p_trade_name, p_pcname, p_qty);
        END IF;
    ELSE
        -- Create new prescription
        INSERT INTO Prescription (Date, AadharID_D, AadharID_P)
        VALUES (p_date, p_doctorid, p_patientid);

        INSERT INTO Contains (Date, AadharID_D, AadharID_P, Trade_Name, PC_Name, Quantity)
        VALUES (p_date, p_doctorid, p_patientid, p_trade_name, p_pcname, p_qty);
    END IF;

EXCEPTION
    WHEN others THEN
        RAISE NOTICE 'Error in add_prescription_one_only: %', SQLERRM;
        RAISE;
END;
$$;