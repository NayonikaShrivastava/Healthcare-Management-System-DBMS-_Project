DROP PROCEDURE IF EXISTS patients_list(VARCHAR);

CREATE OR REPLACE PROCEDURE patients_list(dID VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    docname TEXT;
    patient_record RECORD;
    row_count INT;
BEGIN
    -- Get doctor name
    SELECT Name INTO docname FROM Doctor WHERE AadharID = dID;

    -- Count number of patients
    SELECT COUNT(*) INTO row_count
    FROM Consults
    WHERE AadharID_D = dID;

    RAISE NOTICE 'Patients treated by %:', docname;

    IF row_count = 0 THEN
        RAISE NOTICE 'None';
    ELSE
        FOR patient_record IN
            SELECT P.Name, P.Age
            FROM Patient P
            JOIN Consults C ON P.AadharID = C.AadharID_P
            WHERE C.AadharID_D = dID
        LOOP
            RAISE NOTICE 'Name: %, Age: %', patient_record.Name, patient_record.Age;
        END LOOP;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'Doctor with AadharID % not found.', dID;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: % - SQLSTATE: %', SQLERRM, SQLSTATE;
        RAISE;
END;
$$;
