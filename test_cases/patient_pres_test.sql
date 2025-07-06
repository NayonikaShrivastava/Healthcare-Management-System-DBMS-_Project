-- Get prescriptions for patient 1001 between Jan-Apr 2025
SELECT * FROM get_patient_prescriptions(
    '111122223333'::VARCHAR, 
    '2022-01-01'::DATE, 
    '2025-04-23'::DATE
);
