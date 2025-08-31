# AI Data Engineering Project

A comprehensive data engineering workflow built with n8n that ingests, processes, and analyzes advertising performance data with Supabase PostgreSQL integration.

## 📊 Overview

This project provides an automated pipeline for collecting and analyzing marketing performance data. It features CSV ingestion from external sources, sophisticated metric calculations (CAC, ROAS), and flexible period comparison analytics.

## 🚀 Features

- **Automated CSV Ingestion**: Fetch and process CSV files from external URLs
- **Supabase Integration**: Seamless PostgreSQL database connectivity
- **Advanced Analytics**: Calculate key marketing metrics (CAC, ROAS, conversions)
- **Flexible Date Analysis**: Compare any two time periods with delta calculations
- **SQL Function Library**: Reusable database functions for comprehensive analytics
- **NQL Execution**: LLM integration with database to query report with human.

## 🏗️ Architecture

```
Data Sources → n8n Workflow → Supabase (PostgreSQL) → Analytics & Reporting
```

## 📁 Key Components

### 1. Data Ingestion Workflow
- HTTP Request node for CSV data retrieval
- Python-based data processing and transformation
- PostgreSQL node for database operations

### 2. Database Schema
```sql
CREATE TABLE adds_spenses (
    id BIGSERIAL PRIMARY KEY,
    date TIMESTAMP WITH TIME ZONE,
    platform VARCHAR,
    account VARCHAR,
    campaign VARCHAR,
    country VARCHAR,
    device VARCHAR,
    spend REAL,
    clicks BIGINT,
    impressions REAL,
    conversions BIGINT,
    campaign_date DATE
);
```

### 3. Core Analytics Function
The `get_metrics_comparison()` function provides:
- Input: Two customizable date ranges
- Output: Comprehensive metrics with absolute values and percentage changes
- Metrics: Spend, Conversions, Revenue, CAC, ROAS with delta calculations

### 4. NLQ that delivers report based on human language request.
Try it out by running container at n8n and importing the workflow at n8n/workflows. Also, it is requiered your own supabase and LLM credencials.
- Deepseek node integrated but you can change this to your LLM preference. You only need get an API KEY.
- Agent prompted to be an BI expert that builds SQL statements for reporting.
```
docker-compose up -d -build
```

## ⚡ Quick Start

### Prerequisites
- n8n instance (local or cloud)
- Supabase account with PostgreSQL database
- Python 3.8+ (for custom function nodes)

### Installation Steps

1. **Database Setup**
```sql
-- Create your table
CREATE TABLE adds_spenses (...);

-- Create analytics function
CREATE OR REPLACE FUNCTION get_metrics_comparison(...)
```

2. **n8n Configuration**
   - Set up PostgreSQL credentials for Supabase
   - Import the workflow JSON
   - Configure HTTP request nodes

3. **Run Data Ingestion**
```javascript
// Example n8n HTTP configuration
{
  "url": "https://your-csv-source.com/data.csv",
  "method": "GET",
  "responseFormat": "string"
}
```

## 💡 Usage Examples

### Basic Analytics Query
```sql
-- Compare monthly performance
SELECT * FROM get_metrics_comparison(
  '2025-06-01', '2025-06-30',
  '2025-05-01', '2025-05-31'
);
```

### Custom Date Range Analysis
```sql
-- Compare specific periods
SELECT * FROM get_metrics_comparison(
  '2025-07-01', '2025-07-15',
  '2025-06-15', '2025-06-30'
);
```

## 📈 Metrics Calculated

- **CAC (Customer Acquisition Cost)**: `spend / conversions`
- **ROAS (Return on Ad Spend)**: `(conversions * 100) / spend`
- **Revenue**: `conversions * 100` ($100 per conversion assumption)
- **Percentage Changes**: Period-over-period delta calculations

## 🔧 Workflow Automation

The n8n workflow supports:
- Scheduled daily data ingestion
- Automated weekly/monthly performance reports
- Alerting on significant metric changes
- Customizable data processing pipelines

## 🛠️ Customization

### Modify Metrics
Edit the analytics function to:
- Adjust revenue assumptions
- Add new metrics (CTR, CPC, etc.)
- Change rounding precision

### Add Data Sources
1. Add new HTTP Request nodes
2. Modify Python processing logic
3. Update database schema as needed

## ⚡ Performance Tips

- Create index on `campaign_date` column
- Consider table partitioning for large datasets
- Regular database maintenance
- Optimize n8n workflow memory usage

## 🐛 Troubleshooting

### Common Issues
1. **No Data Returned**: Verify date ranges contain data
2. **Connection Errors**: Check Supabase credentials
3. **CSV Format Issues**: Update Python processing logic

### Debug Queries
```sql
-- Check data availability
SELECT MIN(campaign_date), MAX(campaign_date) FROM adds_spenses;

-- Verify function exists
SELECT pg_get_function_arguments('get_metrics_comparison');
```