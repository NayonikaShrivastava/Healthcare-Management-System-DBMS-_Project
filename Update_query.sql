-- Drop the procedure if it exists, matching the final parameter signature
DROP PROCEDURE IF EXISTS update_patient(VARCHAR, VARCHAR, INTEGER, VARCHAR);

-- Create the PostgreSQL version of the procedure
CREATE OR REPLACE PROCEDURE update_patient (
    p_patientID VARCHAR,    -- Use the specific data type for AadharID
    p_name VARCHAR,         -- Use the specific data type for Name
    p_age INTEGER,          -- Use the specific data type for Age
    p_address VARCHAR       -- Use the specific data type for Address
    -- p_physician parameter removed as it's not in the provided Patient table schema
)
LANGUAGE plpgsql
AS $$
BEGIN
    
    UPDATE Patient          -- Use the PostgreSQL table name
    SET Name = p_name,      -- Use the PostgreSQL column name
        Age = p_age,        -- Use the PostgreSQL column name
        Address = p_address -- Use the PostgreSQL column name
        -- primary_physician = p_physician -- Removed SET clause for non-existent column
    WHERE AadharID = p_patientID; -- Use the PostgreSQL column name

    -- Check if the UPDATE statement affected any rows
    IF FOUND THEN
        RAISE NOTICE 'Successful';
    ELSE
        RAISE NOTICE 'Unsuccessful';
    END IF;

    -- No explicit COMMIT needed here

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details
        RAISE NOTICE 'Error: % - SQLSTATE: %',SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$;



-- Drop the procedure if it exists, matching the final parameter signature
DROP PROCEDURE IF EXISTS update_doctor(VARCHAR, VARCHAR,VARCHAR, INTEGER);

-- Create the PostgreSQL version of the procedure
CREATE OR REPLACE PROCEDURE update_doctor (
    d_patientID VARCHAR,    -- Use the specific data type for AadharID
    d_name VARCHAR,         -- Use the specific data type for Name
    d_speciality VARCHAR,          -- Use the specific data type for Age
    d_experience INTEGER       -- Use the specific data type for Address
    -- p_physician parameter removed as it's not in the provided Patient table schema
)
LANGUAGE plpgsql
AS $$
BEGIN
    
    UPDATE Doctor          -- Use the PostgreSQL table name
    SET Name = d_name,      -- Use the PostgreSQL column name
        Specialty = d_speciality,        -- Use the PostgreSQL column name
        YearsOfExperience = d_experience -- Use the PostgreSQL column name
        -- primary_physician = p_physician -- Removed SET clause for non-existent column
    WHERE AadharID = d_patientID; -- Use the PostgreSQL column name

    -- Check if the UPDATE statement affected any rows
    IF FOUND THEN
        RAISE NOTICE 'Successful';
    ELSE
        RAISE NOTICE 'Unsuccessful';
    END IF;

    -- No explicit COMMIT needed here

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details
        RAISE NOTICE 'Error: % - SQLSTATE: %',SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$;


DROP PROCEDURE IF EXISTS update_pc(VARCHAR, VARCHAR);

-- Create the PostgreSQL version of the procedure
CREATE OR REPLACE PROCEDURE update_pc (
    pc_name VARCHAR,    -- Use the specific data type for AadharID
    pc_phone VARCHAR
    -- p_physician parameter removed as it's not in the provided Patient table schema
)
LANGUAGE plpgsql
AS $$
BEGIN
    
    UPDATE PharmaceuticalCompany          -- Use the PostgreSQL table name
    SET Phone = pc_phone
    WHERE Name = pc_name; -- Use the PostgreSQL column name

    -- Check if the UPDATE statement affected any rows
    IF FOUND THEN
        RAISE NOTICE 'Successful';
    ELSE
        RAISE NOTICE 'Unsuccessful';
    END IF;

    -- No explicit COMMIT needed here

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details
        RAISE NOTICE 'Error: % - SQLSTATE: %',SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$;


DROP PROCEDURE IF EXISTS update_drug(VARCHAR, VARCHAR,VARCHAR);

-- Create the PostgreSQL version of the procedure
CREATE OR REPLACE PROCEDURE update_drug (
    drug_name VARCHAR,    -- Use the specific data type for AadharID
    drug_formula VARCHAR,
    drug_pc_name VARCHAR
    -- p_physician parameter removed as it's not in the provided Patient table schema
)
LANGUAGE plpgsql
AS $$
BEGIN
    
    UPDATE Drug          -- Use the PostgreSQL table name
    SET Formula=drug_formula
    WHERE TradeName = drug_name and PC_Name=drug_pc_name; -- Use the PostgreSQL column name

    -- Check if the UPDATE statement affected any rows
    IF FOUND THEN
        RAISE NOTICE 'Successful';
    ELSE
        RAISE NOTICE 'Unsuccessful';
    END IF;

    -- No explicit COMMIT needed here

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details
        RAISE NOTICE 'Error: % - SQLSTATE: %',SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$;



DROP PROCEDURE IF EXISTS update_pharmacy(VARCHAR, VARCHAR,VARCHAR);

-- Create the PostgreSQL version of the procedure
CREATE OR REPLACE PROCEDURE update_pharmacy (
    pharma_name VARCHAR,    -- Use the specific data type for AadharID
    pharma_address VARCHAR,
    pharma_number VARCHAR
    -- p_physician parameter removed as it's not in the provided Patient table schema
)
LANGUAGE plpgsql
AS $$
BEGIN
    
    UPDATE Pharmacy          -- Use the PostgreSQL table name
    SET Name=pharma_name,
        Phone=pharma_number
    WHERE Address =pharma_address; -- Use the PostgreSQL column name

    -- Check if the UPDATE statement affected any rows
    IF FOUND THEN
        RAISE NOTICE 'Successful';
    ELSE
        RAISE NOTICE 'Unsuccessful';
    END IF;

    -- No explicit COMMIT needed here

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details
        RAISE NOTICE 'Error: % - SQLSTATE: %',SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$;


DROP PROCEDURE IF EXISTS update_contract(VARCHAR, VARCHAR,VARCHAR,DATE,DATE,VARCHAR);

-- Create the PostgreSQL version of the procedure
CREATE OR REPLACE PROCEDURE update_contract (
    contract_address VARCHAR,    -- Use the specific data type for AadharID
    contract_pc_name VARCHAR,
    contract_content VARCHAR,
    contract_st DATE,
    contract_end DATE,
    contract_supervisor VARCHAR
    -- p_physician parameter removed as it's not in the provided Patient table schema
)
LANGUAGE plpgsql
AS $$
BEGIN
    
    UPDATE Contract          -- Use the PostgreSQL table name
    SET Content=contract_content,
        StartDate=contract_st,
        EndDate=contract_end,
        Supervisor=contract_supervisor
    WHERE Address =contract_address and PC_Name=contract_pc_name; -- Use the PostgreSQL column name

    -- Check if the UPDATE statement affected any rows
    IF FOUND THEN
        RAISE NOTICE 'Successful';
    ELSE
        RAISE NOTICE 'Unsuccessful';
    END IF;

    -- No explicit COMMIT needed here

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details
        RAISE NOTICE 'Error: % - SQLSTATE: %',SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$;


DROP PROCEDURE IF EXISTS update_sells(VARCHAR, VARCHAR,VARCHAR,INTEGER);

-- Create the PostgreSQL version of the procedure
CREATE OR REPLACE PROCEDURE update_sells (
    s_tradename VARCHAR,    -- Use the specific data type for AadharID
    s_pc_name VARCHAR,
    s_addresspharmacy VARCHAR,
    s_price INT
    -- p_physician parameter removed as it's not in the provided Patient table schema
)
LANGUAGE plpgsql
AS $$
BEGIN
    
    UPDATE Sells          -- Use the PostgreSQL table name
    SET Price=s_price
    WHERE Trade_Name=s_tradename and PC_Name=s_pc_name and Address_Pharmacy=s_addresspharmacy; -- Use the PostgreSQL column name

    -- Check if the UPDATE statement affected any rows
    IF FOUND THEN
        RAISE NOTICE 'Successful';
    ELSE
        RAISE NOTICE 'Unsuccessful';
    END IF;

    -- No explicit COMMIT needed here

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details
        RAISE NOTICE 'Error: % - SQLSTATE: %',SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$;


------update_prescription does not exist since all are primary keys, it is a cross reference table



DROP PROCEDURE IF EXISTS update_contains(DATE,VARCHAR, VARCHAR,VARCHAR,VARCHAR,INTEGER);

-- Create the PostgreSQL version of the procedure
CREATE OR REPLACE PROCEDURE update_contains (
    c_date DATE,    -- Use the specific data type for AadharID
    c_aadhar_p VARCHAR,
    c_aadhar_d VARCHAR,
    c_TradeName VARCHAR,
    c_pc_name VARCHAR,
    c_quantity INT
    -- p_physician parameter removed as it's not in the provided Patient table schema
)
LANGUAGE plpgsql
AS $$
BEGIN
    
    UPDATE Contains          -- Use the PostgreSQL table name
    SET Quantity=c_quantity
    WHERE Date=c_date and AadharID_P=c_aadhar_p and AadharID_D=c_aadhar_d and Trade_Name=c_TradeName and PC_Name=c_pc_name; -- Use the PostgreSQL column name

    -- Check if the UPDATE statement affected any rows
    IF FOUND THEN
        RAISE NOTICE 'Successful';
    ELSE
        RAISE NOTICE 'Unsuccessful';
    END IF;

    -- No explicit COMMIT needed here

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error details
        RAISE NOTICE 'Error: % - SQLSTATE: %',SQLERRM, SQLSTATE;
        -- Re-raise the current exception to ensure the transaction rolls back
        RAISE;
END;
$$;



------update_Consults does not exist since all are primary keys, it is a cross reference table