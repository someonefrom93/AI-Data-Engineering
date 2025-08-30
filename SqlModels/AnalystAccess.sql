-- Create a function that takes date ranges as parameters
CREATE OR REPLACE FUNCTION get_metrics_comparison(
    start_date_1 DATE, 
    end_date_1 DATE,
    start_date_2 DATE, 
    end_date_2 DATE
)
RETURNS TABLE (
    period TEXT,
    total_spend NUMERIC,
    total_conversions NUMERIC,
    revenue NUMERIC,
    cac NUMERIC,
    roas NUMERIC,
    spend_delta_pct NUMERIC,
    conversions_delta_pct NUMERIC,
    revenue_delta_pct NUMERIC,
    cac_delta_pct NUMERIC,
    roas_delta_pct NUMERIC
) AS $$
WITH period1 AS (
  SELECT 
    SUM(spend) as total_spend,
    SUM(conversions) as total_conversions,
    SUM(conversions) * 100 as revenue
  FROM adds_spenses 
  WHERE campaign_date >= start_date_1 AND campaign_date <= end_date_1
),
period2 AS (
  SELECT 
    SUM(spend) as total_spend,
    SUM(conversions) as total_conversions,
    SUM(conversions) * 100 as revenue
  FROM adds_spenses 
  WHERE campaign_date >= start_date_2 AND campaign_date <= end_date_2
)
SELECT 
  period,
  total_spend,
  total_conversions,
  revenue,
  cac,
  roas,
  spend_delta_pct,
  conversions_delta_pct,
  revenue_delta_pct,
  cac_delta_pct,
  roas_delta_pct
FROM (
  SELECT 
    'Period 1' as period,
    p1.total_spend,
    p1.total_conversions,
    p1.revenue,
    CASE WHEN p1.total_conversions > 0 THEN p1.total_spend / p1.total_conversions ELSE 0 END as cac,
    CASE WHEN p1.total_spend > 0 THEN p1.revenue / p1.total_spend ELSE 0 END as roas,
    NULL::numeric as spend_delta_pct,
    NULL::numeric as conversions_delta_pct,
    NULL::numeric as revenue_delta_pct,
    NULL::numeric as cac_delta_pct,
    NULL::numeric as roas_delta_pct
  FROM period1 p1
  
  UNION ALL
  
  SELECT 
    'Period 2' as period,
    p2.total_spend,
    p2.total_conversions,
    p2.revenue,
    CASE WHEN p2.total_conversions > 0 THEN p2.total_spend / p2.total_conversions ELSE 0 END as cac,
    CASE WHEN p2.total_spend > 0 THEN p2.revenue / p2.total_spend ELSE 0 END as roas,
    NULL::numeric as spend_delta_pct,
    NULL::numeric as conversions_delta_pct,
    NULL::numeric as revenue_delta_pct,
    NULL::numeric as cac_delta_pct,
    NULL::numeric as roas_delta_pct
  FROM period2 p2
  
  UNION ALL
  
  SELECT 
    'Delta % Change' as period,
    NULL::numeric as total_spend,
    NULL::numeric as total_conversions,
    NULL::numeric as revenue,
    NULL::numeric as cac,
    NULL::numeric as roas,
    ROUND(((p1.total_spend - p2.total_spend) / NULLIF(p2.total_spend, 0) * 100)::numeric, 2) as spend_delta_pct,
    ROUND(((p1.total_conversions - p2.total_conversions) / NULLIF(p2.total_conversions, 0) * 100)::numeric, 2) as conversions_delta_pct,
    ROUND(((p1.revenue - p2.revenue) / NULLIF(p2.revenue, 0) * 100)::numeric, 2) as revenue_delta_pct,
    ROUND(((CASE WHEN p1.total_conversions > 0 THEN p1.total_spend / p1.total_conversions ELSE 0 END - 
           CASE WHEN p2.total_conversions > 0 THEN p2.total_spend / p2.total_conversions ELSE 0 END) / 
           NULLIF(CASE WHEN p2.total_conversions > 0 THEN p2.total_spend / p2.total_conversions ELSE 0 END, 0) * 100)::numeric, 2) as cac_delta_pct,
    ROUND(((CASE WHEN p1.total_spend > 0 THEN p1.revenue / p1.total_spend ELSE 0 END - 
           CASE WHEN p2.total_spend > 0 THEN p2.revenue / p2.total_spend ELSE 0 END) / 
           NULLIF(CASE WHEN p2.total_spend > 0 THEN p2.revenue / p2.total_spend ELSE 0 END, 0) * 100)::numeric, 2) as roas_delta_pct
  FROM period1 p1, period2 p2
) results
ORDER BY 
  CASE period 
    WHEN 'Period 1' THEN 1
    WHEN 'Period 2' THEN 2
    WHEN 'Delta % Change' THEN 3
  END;
$$ LANGUAGE SQL;

-- Then, you can call the function with specific date ranges
-- Example: Compare March 2025 vs February 2025
SELECT * FROM get_metrics_comparison('2025-03-01', '2025-03-30', '2025-02-01', '2025-02-28');