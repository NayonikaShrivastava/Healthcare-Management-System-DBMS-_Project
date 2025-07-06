DROP PROCEDURE IF EXISTS get_prescription_details(VARCHAR, DATE);

CREATE OR REPLACE PROCEDURE get_prescription_details(
    p_patient_aadhar VARCHAR, 
    p_date DATE
) 
LANGUAGE plpgsql
AS $procedure$
DECLARE
    -- Declare variables to store prescription info
    v_patient_name VARCHAR;
    v_doctor_name VARCHAR;
    v_doctor_specialty VARCHAR;
    v_prescription_found BOOLEAN := FALSE;
    
    -- Record for medication info
    med RECORD;
    v_med_count INTEGER := 0;
    v_total_cost NUMERIC := 0;
BEGIN
    -- First check if the prescription exists
    BEGIN
        SELECT 
            pat.Name, doc.Name, doc.Specialty
        INTO 
            v_patient_name, v_doctor_name, v_doctor_specialty
        FROM 
            Prescription p
            JOIN Patient pat ON p.AadharID_P = pat.AadharID
            JOIN Doctor doc ON p.AadharID_D = doc.AadharID
        WHERE 
            p.AadharID_P = p_patient_aadhar
            AND p.Date = p_date;
            
        v_prescription_found := TRUE;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE NOTICE 'No prescription found for patient with Aadhar ID: % on date: %', 
                p_patient_aadhar, to_char(p_date, 'YYYY-MM-DD');
            v_prescription_found := FALSE;
    END;

    -- If prescription exists, print details
    IF v_prescription_found THEN
        -- Print prescription header
        RAISE NOTICE '==== PRESCRIPTION DETAILS ====';
        RAISE NOTICE 'Date: %', to_char(p_date, 'YYYY-MM-DD');
        RAISE NOTICE 'Patient: % (ID: %)', v_patient_name, p_patient_aadhar;
        RAISE NOTICE 'Doctor: % (%)', v_doctor_name, v_doctor_specialty;
        RAISE NOTICE '';
        RAISE NOTICE '==== MEDICATIONS ====';
        
        -- Loop through medications
        FOR med IN
            SELECT 
                d.TradeName,
                d.Formula,
                d.PC_Name,
                c.Quantity,
                s.Price,
                (c.Quantity * s.Price) AS TotalCost,
                ph.Name AS PharmacyName,
                ph.Address AS PharmacyAddress,
                ph.Phone AS PharmacyPhone
            FROM 
                Contains c
                JOIN Drug d ON c.Trade_Name = d.TradeName AND c.PC_Name = d.PC_Name
                JOIN Sells s ON d.TradeName = s.Trade_Name AND d.PC_Name = s.PC_Name
                JOIN Pharmacy ph ON s.Address_Pharmacy = ph.Address
            WHERE 
                c.AadharID_P = p_patient_aadhar
                AND c.Date = p_date
            ORDER BY 
                d.TradeName
        LOOP
            v_med_count := v_med_count + 1;
            RAISE NOTICE '';
            RAISE NOTICE 'Medication #%:', v_med_count;
            RAISE NOTICE '  Name: %', med.TradeName;
            RAISE NOTICE '  Formula: %', med.Formula;
            RAISE NOTICE '  Manufacturer: %', med.PC_Name;
            RAISE NOTICE '  Quantity: %', med.Quantity;
            RAISE NOTICE '  Unit Price: $%', med.Price;
            RAISE NOTICE '  Total Cost: $%', med.TotalCost;
            RAISE NOTICE '  Available at: %', med.PharmacyName;
            RAISE NOTICE '  Pharmacy Address: %', med.PharmacyAddress;
            RAISE NOTICE '  Pharmacy Contact: %', med.PharmacyPhone;
            
            v_total_cost := v_total_cost + med.TotalCost;
        END LOOP;
        
        IF v_med_count = 0 THEN
            RAISE NOTICE 'No medications found in this prescription.';
        ELSE
            RAISE NOTICE '';
            RAISE NOTICE '==== SUMMARY ====';
            RAISE NOTICE 'Total medications: %', v_med_count;
            RAISE NOTICE 'Total prescription cost: $%', v_total_cost;
        END IF;
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error occurred: %', SQLERRM;
END;
$procedure$;
