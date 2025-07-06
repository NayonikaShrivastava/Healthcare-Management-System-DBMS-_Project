-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS get_drugs_by_company;

-- Create the procedure to get drugs produced by a pharmaceutical company
CREATE OR REPLACE PROCEDURE get_drugs_by_company(
    company_name VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    company_exists BOOLEAN;
    drug_count INTEGER;
    drug_rec RECORD;
BEGIN
    -- Check if the pharmaceutical company exists
    SELECT EXISTS(
        SELECT 1 FROM PharmaceuticalCompany 
        WHERE Name = company_name
    ) INTO company_exists;
    
    IF NOT company_exists THEN
        RAISE NOTICE 'Pharmaceutical company "%" does not exist', company_name;
        RETURN;
    END IF;
    
    -- Get all drugs produced by the company
    RAISE NOTICE 'Drugs produced by %:', company_name;
    
    -- Display the results
    RAISE NOTICE '----------------------------------------------';
    RAISE NOTICE 'TRADE NAME | FORMULA';
    RAISE NOTICE '----------------------------------------------';
    
    FOR drug_rec IN 
        SELECT TradeName, Formula 
        FROM Drug 
        WHERE PC_Name = company_name
        ORDER BY TradeName
    LOOP
        RAISE NOTICE '% | %', drug_rec.TradeName, drug_rec.Formula;
    END LOOP;
    
    -- Count the number of drugs and display
    SELECT count(*) INTO drug_count FROM Drug WHERE PC_Name = company_name;
    RAISE NOTICE '----------------------------------------------';
    RAISE NOTICE 'Total drugs produced by %: %', company_name, drug_count;
END;
$$;