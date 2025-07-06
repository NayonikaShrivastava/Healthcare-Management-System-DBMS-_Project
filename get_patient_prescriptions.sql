CREATE OR REPLACE FUNCTION get_patient_prescriptions(
    patient_id VARCHAR,
    start_date DATE,
    end_date DATE
)
RETURNS TABLE (
    prescription_date DATE,
    drug_trade_name VARCHAR,
    quantity INT
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.date::DATE AS prescription_date,
        dr.tradename::VARCHAR,
        c.quantity::INT
    FROM
        Prescription p, Drug dr, Contains c
    WHERE 
        p.AadharID_P = patient_id   
        AND c.AadharID_D = p.AadharID_D
        AND p.AadharID_P = c.AadharID_P
        AND c.Trade_Name = dr.TradeName
        AND p.Date BETWEEN start_date AND end_date
    ORDER BY
        p.Date DESC, dr.TradeName;
END;
$$;
