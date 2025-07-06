-- Drop the procedure if it exists to ensure a clean creation
DROP PROCEDURE IF EXISTS delete_patient(VARCHAR);

CREATE OR REPLACE PROCEDURE delete_patient (
    p_patientID VARCHAR -- Use the specific data type for AadharID in your Patient table
)
LANGUAGE plpgsql -- Specify the language [1]
AS $$ -- Start procedure body block [1][5]
BEGIN

    DELETE FROM Patient -- Use the exact table name from your PostgreSQL schema
    WHERE AadharID = p_patientID; -- Use the exact column name

    -- Check if a row was actually deleted using the special variable FOUND
    IF FOUND THEN
        RAISE NOTICE 'Successfully deleted patient with AadharID: %', p_patientID;
    ELSE
        RAISE NOTICE 'Patient with AadharID: % not found. No rows deleted.', p_patientID;
    END IF;

    -- No explicit COMMIT needed here [1][6][9]

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details [1][9]
        RAISE NOTICE 'Error deleting patient %: % - SQLSTATE: %', p_patientID, SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$; 


DROP PROCEDURE IF EXISTS delete_doctor(VARCHAR);

CREATE OR REPLACE PROCEDURE delete_doctor (
    d_patientID VARCHAR -- Use the specific data type for AadharID in your Patient table
)
LANGUAGE plpgsql -- Specify the language [1]
AS $$ -- Start procedure body block [1][5]
BEGIN

    DELETE FROM Doctor -- Use the exact table name from your PostgreSQL schema
    WHERE AadharID = d_patientID; -- Use the exact column name

    -- Check if a row was actually deleted using the special variable FOUND
    IF FOUND THEN
        RAISE NOTICE 'Successfully deleted doctor with AadharID: %', d_patientID;
    ELSE
        RAISE NOTICE 'Doctor with AadharID: % not found. No rows deleted.', d_patientID;
    END IF;

    -- No explicit COMMIT needed here [1][6][9]

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details [1][9]
        RAISE NOTICE 'Error deleting Doctor %: % - SQLSTATE: %', d_patientID, SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$; 


DROP PROCEDURE IF EXISTS delete_pc(VARCHAR);

CREATE OR REPLACE PROCEDURE delete_pc (
    pc_name VARCHAR -- Use the specific data type for AadharID in your Patient table
)
LANGUAGE plpgsql -- Specify the language [1]
AS $$ -- Start procedure body block [1][5]
BEGIN

    DELETE FROM PharmaceuticalCompany -- Use the exact table name from your PostgreSQL schema
    WHERE name = pc_name; -- Use the exact column name

    -- Check if a row was actually deleted using the special variable FOUND
    IF FOUND THEN
        RAISE NOTICE 'Successfully deleted pharma firm with name: %', pc_name;
    ELSE
        RAISE NOTICE 'Pharma form with name: % not found. No rows deleted.', pc_name;
    END IF;

    -- No explicit COMMIT needed here [1][6][9]

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details [1][9]
        RAISE NOTICE 'Error deleting Doctor %: % - SQLSTATE: %', pc_name, SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$; 


DROP PROCEDURE IF EXISTS delete_drug(VARCHAR);

CREATE OR REPLACE PROCEDURE delete_drug (
    drug_name VARCHAR,
    p_c_name VARCHAR -- Use the specific data type for AadharID in your Patient table
)
LANGUAGE plpgsql -- Specify the language [1]
AS $$ -- Start procedure body block [1][5]
BEGIN

    DELETE FROM Drug -- Use the exact table name from your PostgreSQL schema
    WHERE TradeName = drug_name and PC_Name=p_c_name; -- Use the exact column name

    -- Check if a row was actually deleted using the special variable FOUND
    IF FOUND THEN
        RAISE NOTICE 'Successfully deleted drug with name: %', drug_name;
    ELSE
        RAISE NOTICE 'Drug with name: % not found. No rows deleted.', drug_name;
    END IF;

    -- No explicit COMMIT needed here [1][6][9]

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details [1][9]
        RAISE NOTICE 'Error deleting Doctor %: % - SQLSTATE: %', drug_name, SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$; 


DROP PROCEDURE IF EXISTS delete_pharmacy(VARCHAR);

CREATE OR REPLACE PROCEDURE delete_pharmacy(
    pharmacy_address VARCHAR -- Use the specific data type for AadharID in your Patient table
)
LANGUAGE plpgsql -- Specify the language [1]
AS $$ -- Start procedure body block [1][5]
BEGIN

    DELETE FROM Pharmacy -- Use the exact table name from your PostgreSQL schema
    WHERE Address=pharmacy_address; -- Use the exact column name

    -- Check if a row was actually deleted using the special variable FOUND
    IF FOUND THEN
        RAISE NOTICE 'Successfully deleted pharmacy with address: %', pharmacy_address;
    ELSE
        RAISE NOTICE 'Pharmacy with address: % not found. No rows deleted.', pharmacy_address;
    END IF;

    -- No explicit COMMIT needed here [1][6][9]

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details [1][9]
        RAISE NOTICE 'Error deleting pharmacy %: % - SQLSTATE: %', pharmacy_address, SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$; 


DROP PROCEDURE IF EXISTS delete_contract(VARCHAR);

CREATE OR REPLACE PROCEDURE delete_contract(
    pc_address VARCHAR,
    pc_contract_name VARCHAR -- Use the specific data type for AadharID in your Patient table
)
LANGUAGE plpgsql -- Specify the language [1]
AS $$ -- Start procedure body block [1][5]
BEGIN

    DELETE FROM Contract -- Use the exact table name from your PostgreSQL schema
    WHERE Address=pc_address and PC_Name=pc_contract_name; -- Use the exact column name

    -- Check if a row was actually deleted using the special variable FOUND
    IF FOUND THEN
        RAISE NOTICE 'Successfully deleted contraact with address: %', pc_address;
    ELSE
        RAISE NOTICE 'Contract with address: % not found. No rows deleted.', pc_address;
    END IF;

    -- No explicit COMMIT needed here [1][6][9]

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details [1][9]
        RAISE NOTICE 'Error deleting contract %: % - SQLSTATE: %', pc_address, SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$; 

------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS delete_sale(VARCHAR);

CREATE OR REPLACE PROCEDURE delete_sale(
    sale_trade_name VARCHAR,
    sale_pc_name VARCHAR,
    sale_address VARCHAR-- Use the specific data type for AadharID in your Patient table
)
LANGUAGE plpgsql -- Specify the language [1]
AS $$ -- Start procedure body block [1][5]
BEGIN

    DELETE FROM Sells -- Use the exact table name from your PostgreSQL schema
    WHERE Trade_Name=sale_trade_name and PC_Name=sale_pc_name and Address_Pharmacy=sale_address; -- Use the exact column name

    -- Check if a row was actually deleted using the special variable FOUND
    IF FOUND THEN
        RAISE NOTICE 'Successfully deleted sale of: %', sale_trade_name;
    ELSE
        RAISE NOTICE 'Sale with name: % not found. No rows deleted.', sale_trade_name;
    END IF;

    -- No explicit COMMIT needed here [1][6][9]

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details [1][9]
        RAISE NOTICE 'Error deleting sale%: % - SQLSTATE: %', sale_trade_name, SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$; 


DROP PROCEDURE IF EXISTS delete_prescription(VARCHAR);

CREATE OR REPLACE PROCEDURE delete_prescription(
    pres_date DATE,
    pres_aadhar_d VARCHAR,
    pres_aadhar_p VARCHAR-- Use the specific data type for AadharID in your Patient table
)
LANGUAGE plpgsql -- Specify the language [1]
AS $$ -- Start procedure body block [1][5]
BEGIN

    DELETE FROM Prescription -- Use the exact table name from your PostgreSQL schema
    WHERE Date=pres_date and AadharID_D=pres_aadhar_d and AadharID_P=pres_aadhar_p; -- Use the exact column name

    -- Check if a row was actually deleted using the special variable FOUND
    IF FOUND THEN
        RAISE NOTICE 'Successfully deleted prescription of: %', pres_aadhar_p;
    ELSE
        RAISE NOTICE 'Prescription with AadharID: % not found. No rows deleted.', pres_aadhar_p;
    END IF;

    -- No explicit COMMIT needed here [1][6][9]

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details [1][9]
        RAISE NOTICE 'Error deleting prescription%: % - SQLSTATE: %', pres_aadhar_p, SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$; 


DROP PROCEDURE IF EXISTS delete_contains(VARCHAR);

CREATE OR REPLACE PROCEDURE delete_contains(
    c_date DATE,
    c_aadhar_d VARCHAR,
    c_aadhar_p VARCHAR,
    c_TradeName VARCHAR,
    c_pc_name VARCHAR-- Use the specific data type for AadharID in your Patient table
)
LANGUAGE plpgsql -- Specify the language [1]
AS $$ -- Start procedure body block [1][5]
BEGIN

    DELETE FROM Contains -- Use the exact table name from your PostgreSQL schema
    WHERE Date=c_date and AadharID_D=c_aadhar_d and AadharID_P=c_aadhar_p and Trade_Name=c_TradeName and PC_Name=c_pc_name; -- Use the exact column name

    -- Check if a row was actually deleted using the special variable FOUND
    IF FOUND THEN
        RAISE NOTICE 'Successfully deleted contents of prescription of: %', c_aadhar_p;
    ELSE
        RAISE NOTICE 'Contents of AadharID prescrption: % not found. No rows deleted.', c_aadhar_p;
    END IF;

    -- No explicit COMMIT needed here [1][6][9]

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details [1][9]
        RAISE NOTICE 'Error deleting contents%: % - SQLSTATE: %', c_aadhar_p, SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$; 


DROP PROCEDURE IF EXISTS delete_consults(VARCHAR);

CREATE OR REPLACE PROCEDURE delete_consults(
    c_aadhar_d VARCHAR,
    c_aadhar_p VARCHAR
-- Use the specific data type for AadharID in your Patient table
)
LANGUAGE plpgsql -- Specify the language [1]
AS $$ -- Start procedure body block [1][5]
BEGIN

    DELETE FROM Consults -- Use the exact table name from your PostgreSQL schema
    WHERE AadharID_D=c_aadhar_d and AadharID_P=c_aadhar_p; -- Use the exact column name

    -- Check if a row was actually deleted using the special variable FOUND
    IF FOUND THEN
        RAISE NOTICE 'Successfully deleted consultation of : %', c_aadhar_p;
    ELSE
        RAISE NOTICE 'Consultation of AadharID prescrption: % not found. No rows deleted.', c_aadhar_p;
    END IF;

    -- No explicit COMMIT needed here [1][6][9]

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details [1][9]
        RAISE NOTICE 'Error deleting consultation%: % - SQLSTATE: %', c_aadhar_p, SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$; 












