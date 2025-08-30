WITH last_30_days AS (
  SELECT 
    SUM(spend) as total_spend,
    SUM(conversions) as total_conversions,
    SUM(conversions) * 100 as revenue
  FROM adds_spenses 
  WHERE campaign_date >= '2025-03-01' AND campaign_date <= '2025-03-30'
),
prior_30_days AS (
  SELECT 
    SUM(spend) as total_spend,
    SUM(conversions) as total_conversions,
    SUM(conversions) * 100 as revenue
  FROM adds_spenses 
  WHERE campaign_date >= '2025-02-01' AND campaign_date <= '2025-02-28'
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
    'Last 30 Days' as period,
    l.total_spend,
    l.total_conversions,
    l.revenue,
    CASE WHEN l.total_conversions > 0 THEN l.total_spend / l.total_conversions ELSE 0 END as cac,
    CASE WHEN l.total_spend > 0 THEN l.revenue / l.total_spend ELSE 0 END as roas,
    NULL::numeric as spend_delta_pct,
    NULL::numeric as conversions_delta_pct,
    NULL::numeric as revenue_delta_pct,
    NULL::numeric as cac_delta_pct,
    NULL::numeric as roas_delta_pct
  FROM last_30_days l
  
  UNION ALL
  
  SELECT 
    'Prior 30 Days' as period,
    p.total_spend,
    p.total_conversions,
    p.revenue,
    CASE WHEN p.total_conversions > 0 THEN p.total_spend / p.total_conversions ELSE 0 END as cac,
    CASE WHEN p.total_spend > 0 THEN p.revenue / p.total_spend ELSE 0 END as roas,
    NULL::numeric as spend_delta_pct,
    NULL::numeric as conversions_delta_pct,
    NULL::numeric as revenue_delta_pct,
    NULL::numeric as cac_delta_pct,
    NULL::numeric as roas_delta_pct
  FROM prior_30_days p
  
  UNION ALL
  
  SELECT 
    'Delta % Change' as period,
    NULL::numeric as total_spend,
    NULL::numeric as total_conversions,
    NULL::numeric as revenue,
    NULL::numeric as cac,
    NULL::numeric as roas,
    ROUND(((l.total_spend - p.total_spend) / p.total_spend * 100)::numeric, 2) as spend_delta_pct,
    ROUND(((l.total_conversions - p.total_conversions) / p.total_conversions * 100)::numeric, 2) as conversions_delta_pct,
    ROUND(((l.revenue - p.revenue) / p.revenue * 100)::numeric, 2) as revenue_delta_pct,
    ROUND(((CASE WHEN l.total_conversions > 0 THEN l.total_spend / l.total_conversions ELSE 0 END - 
           CASE WHEN p.total_conversions > 0 THEN p.total_spend / p.total_conversions ELSE 0 END) / 
           CASE WHEN p.total_conversions > 0 THEN p.total_spend / p.total_conversions ELSE 1 END * 100)::numeric, 2) as cac_delta_pct,
    ROUND(((CASE WHEN l.total_spend > 0 THEN l.revenue / l.total_spend ELSE 0 END - 
           CASE WHEN p.total_spend > 0 THEN p.revenue / p.total_spend ELSE 0 END) / 
           CASE WHEN p.total_spend > 0 THEN p.revenue / p.total_spend ELSE 1 END * 100)::numeric, 2) as roas_delta_pct
  FROM last_30_days l, prior_30_days p
) results
ORDER BY 
  CASE period 
    WHEN 'Last 30 Days' THEN 1
    WHEN 'Prior 30 Days' THEN 2
    WHEN 'Delta % Change' THEN 3
  END;