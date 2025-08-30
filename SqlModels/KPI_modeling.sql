
-- cac = customer acquisition cost
SELECT *, spend / conversions as cac FROM public.adds_spenses;

-- roas = return on ad spend
-- Assuming each conversion generates $100 in revenue
-- roas = revenue / spend
-- revenue = conversions * 100
-- roas = (conversions * 100) / spend
-- Handle division by zero by returning NULL if spend is 0
SELECT
    date,
    platform,
    account,
    campaign,
    country,
    device,
    spend,
    conversions,
    conversions * 100 AS revenue, -- Assuming $100 per conversion
    CASE 
        WHEN spend > 0 THEN (conversions * 100) / spend 
        ELSE NULL 
    END AS roas,
    campaign_date
FROM public.adds_spenses
WHERE spend > 0
ORDER BY date DESC;