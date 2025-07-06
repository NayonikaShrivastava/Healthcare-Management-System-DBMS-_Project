CREATE OR REPLACE FUNCTION get_pharmacy_stock(
    pname VARCHAR(100)
) RETURNS TABLE (
    pharma_name VARCHAR(100),
    addr VARCHAR(255),
    drug VARCHAR(100),
    pharma_company VARCHAR(255),
    price INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.name::VARCHAR,
        s.address_pharmacy::VARCHAR,
        s.trade_name::VARCHAR,
        s.PC_Name::VARCHAR,
        s.Price::INT
    FROM
        Pharmacy p, Sells s 
    WHERE
        p.name = pname
        AND p.address = s.address_pharmacy
    ORDER BY
        p.name, p.address;
END;
$$;