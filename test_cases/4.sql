-- Test Case 1: Get drugs from an existing pharmaceutical company with drugs (PharmaCorp)
CALL get_drugs_by_company('PharmaCorp');

-- Test Case 3: Test with a non-existent pharmaceutical company
--Prints an error message
CALL get_drugs_by_company('NonExistentPharma')