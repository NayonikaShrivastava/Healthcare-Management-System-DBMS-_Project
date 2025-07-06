DROP PROCEDURE IF EXISTS print_contact_details(VARCHAR, VARCHAR);

CREATE OR REPLACE PROCEDURE print_contact_details(
    p_address VARCHAR,
    p_pc_name VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    pharm_name TEXT;
    pharm_phone TEXT;
    pc_phone TEXT;
    supervisor_name TEXT;
    row_count INT;
BEGIN
    SELECT COUNT(*) INTO row_count
    FROM Contract
    WHERE Address = p_address AND PC_Name = p_pc_name;

    IF row_count = 0 THEN
        RAISE NOTICE 'No contract exists between pharmacy and pharmaceutical company at the provided address.';
        RETURN;
    END IF;

    SELECT P.Name, P.Phone
    INTO pharm_name, pharm_phone
    FROM Pharmacy P
    WHERE P.Address = p_address;

    SELECT PC.Phone
    INTO pc_phone
    FROM PharmaceuticalCompany PC
    WHERE PC.Name = p_pc_name;

    SELECT Supervisor
    INTO supervisor_name
    FROM Contract
    WHERE Address = p_address AND PC_Name = p_pc_name;

    RAISE NOTICE 'Pharmacy Name: %, Phone: %', pharm_name, pharm_phone;
    RAISE NOTICE 'Pharmaceutical Company: %, Phone: %', p_pc_name, pc_phone;
    RAISE NOTICE 'Supervisor: %', supervisor_name;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error fetching contact details: % - SQLSTATE: %', SQLERRM, SQLSTATE;
        RAISE;
END;
$$;
