# E-Commerce Customer Segmentation: RFM Analysis

**Advanced customer analytics project analyzing 1M+ transactions to identify high-value customers and at-risk segments using Recency-Frequency-Monetary (RFM) analysis.**

##  Project Overview

This project demonstrates **end-to-end data analytics** combining SQL for data extraction, Python for analysis, and visualization for insights. The analysis segments 5,878 unique customers into 7 actionable segments based on purchasing behavior.

### Key Results
- **Total Transactions:** 1,067,371
- **Unique Customers:** 5,878
- **Analysis Period:** Dec 2010 — Dec 2011
- **Customer Segments:** 7 (Champions, Loyal, New, Potential, At Risk, Need Attention, Lost)
- **Revenue:** $9.24M total

##  Features

### Tech Stack
- **Database:** PostgreSQL (1M+ row dataset)
- **Data Analysis:** Python (Pandas, NumPy)
- **Visualization:** Matplotlib, Seaborn
- **Notebook:** Jupyter

### Analysis Components

**1. SQL Data Extraction (8 Advanced Queries)**
- Revenue by country (top 15)
- Top 10 customers by lifetime value
- Top 10 products by revenue
- Monthly sales trend analysis
- Average order value by country
- Customer count by region
- Product return rates
- Guest vs registered order comparison

**2. RFM Segmentation**
- **Recency:** Days since last purchase (22-760 days range)
- **Frequency:** Number of orders (1-398 orders range)
- **Monetary:** Total customer spend ($2.95-$688K range)

**3. Customer Segments (7 Categories)**
- **Champions (1,294):** VIP customers, bought recently & frequently, high spenders
- **Loyal Customers (1,143):** Regular buyers, consistent revenue
- **New Customers (441):** Recent customers, low history
- **Potential Loyalists (357):** Good potential, need nurturing
- **At Risk (612):** Used to buy frequently, haven't recently
- **Need Attention (757):** Mixed behavior, require engagement
- **Lost Customers (1,274):** Haven't purchased in long time

**4. Visualizations (6 Professional Charts)**
- Revenue by country (top 15)
- Monthly sales trend (2010-2011)
- Top 10 products by revenue
- Top 10 customers by spend
- Customer segments distribution
- RFM scatter plot with bubble sizing

### Business Insights

**Geographic Analysis**
- **UK dominance:** 95% of revenue ($8.87M)
- **Top 3 markets:** UK, Netherlands, EIRE
- **Opportunity:** International expansion severely underutilized

**Temporal Patterns**
- **Peak month:** November 2010 ($1.17M)
- **Seasonality:** Clear Q4 spike both years
- **Trend:** Revenue declining through 2011

**Customer Segmentation**
- **Champions avg spend:** $9,354 (36x more than Lost Customers)
- **Attrition insight:** 1,274 lost customers (21.6% of base) — critical retention issue
- **At-risk segment:** 612 customers with high historical value now disengaged

### Recommendations

**Immediate (Month 1)**
1. **Win-back campaign:** Target 1,274 Lost Customers with seasonal discount
2. **VIP program:** Tier 1,294 Champions for exclusive benefits
3. **At-risk intervention:** Personal outreach to 612 at-risk customers

**Medium-term (Months 2-3)**
1. **Loyalty program:** Reward repeat purchases (Loyal Customers segment)
2. **Nurture sequence:** Develop new customers into loyal base
3. **Geographic expansion:** Launch in Germany, France, Spain

**Long-term (Months 4-12)**
1. **Predictive model:** Identify future at-risk customers before they churn
2. **Personalization:** Dynamic pricing/offers based on RFM tier
3. **Retention optimization:** Target goal of reducing Lost segment by 50%

##  Technical Deep Dive

### Data Pipeline

```
Excel CSV / Raw Dataset
↓
Python + Pandas (Data Cleaning & Transformation)
↓
PostgreSQL Database (Load Cleaned Data)
↓
SQL Analysis Queries (Business Insights Extraction)
↓
Matplotlib/Seaborn (Visualize)
↓
RFM Metric Calculation (Recency, Frequency, Monetary)
↓
Customer Segmentation Logic
↓
Business Recommendations
```

### RFM Scoring Methodology

```python
# Scoring: 1-5 scale per metric
R_Score = pd.qcut(recency, 5, labels=[5,4,3,2,1])  # Lower days = higher score
F_Score = pd.qcut(frequency.rank(), 5, labels=[1,2,3,4,5])  # More orders = higher
M_Score = pd.qcut(monetary, 5, labels=[1,2,3,4,5])  # Higher spend = higher

# Segmentation Logic
if R≥4 and F≥4 and M≥4: segment = 'Champions'
elif R≥3 and F≥3 and M≥3: segment = 'Loyal'
elif R≥4 and F≤2: segment = 'New'
# ... (5 more conditions)
```

### Key SQL Queries

**Query 1: Revenue by Country**
```sql
SELECT country,
  ROUND(SUM(quantity * price)::numeric, 2) AS total_revenue,
  COUNT(DISTINCT invoice) AS total_orders
FROM online_retail
WHERE quantity > 0 AND price > 0 AND customer_id IS NOT NULL
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 15;
```
**Query 2: Monthly trend**
```sql
SELECT DATE_TRUNC('month', invoice_date) AS month,
		ROUND(SUM(quantity * price):: numeric, 2) AS total_revenue,
		COUNT(DISTINCT invoice) AS total_orders,
		SUM(quantity) AS total_units_sold,
		COUNT(DISTINCT customer_id) AS unique_customers
    FROM online_retail
    WHERE quantity > 0
		AND price > 0
		AND customer_id IS NOT NULL
    GROUP BY month
    ORDER BY month ASC
```
**Query 3: Top Products**
```sql
SELECT stock_code,
		description,
		SUM(quantity) AS total_units_sold,
		ROUND(SUM(quantity * price):: numeric, 2) AS total_revenue,
		COUNT(DISTINCT invoice) AS times_ordered
    FROM online_retail
    WHERE quantity > 0
		AND price > 0
		AND description IS NOT NULL
    GROUP BY stock_code, description
    ORDER BY total_revenue DESC
    LIMIT 10
```
**Query 4: Top Customers**
```sql
SELECT customer_id,
		country,
		ROUND(SUM(quantity * price):: numeric, 2) AS total_spend,
		ROUND(AVG(quantity * price):: numeric, 2) AS avg_order_value
    FROM online_retail
    WHERE quantity > 0
		AND price > 0
		AND customer_id IS NOT NULL
    GROUP BY customer_id, country
    ORDER BY total_spend DESC
    LIMIT 10
```

**Query 5: RFM Calculation Base**
```sql
SELECT 
  customer_id,
  MAX(invoice_date) AS last_purchase_date,
  COUNT(DISTINCT invoice) AS purchase_frequency,
  SUM(quantity * price) AS total_monetary
FROM online_retail
WHERE quantity > 0 AND price > 0
GROUP BY customer_id;
```

##  File Structure
```
ecommerce-rfm-analysis/
│
├── data/
│   ├── raw/
│   │   └── online_retail.csv
│   └── exports/
│   |    └── rfm_segments.csv
│   └── notebook/
│   |   └── ecommerce_analysis.ipynb
│   └── sql/
│   └── e-commerce-analysis.sql
│
├── charts/
│   ├── revenue_by_country.png
│   ├── monthly_sales_trend.png
│   ├── top_products.png
│   ├── top_customers.png
│   ├── customer_segments.png
│   └── rfm_scatter_plot.png
│
├── reports/
│   └── executive_summary.pdf
|
├── README.md
└── .gitignore
```

##  Skills Demonstrated

**SQL (Advanced)**
- Complex aggregations (SUM, COUNT, AVG with GROUP BY)
- Window functions (RANK, ROW_NUMBER)
- Subqueries and CTEs
- Data validation and quality checks
- Performance optimization for 1M+ rows

**Python (Data Analysis)**
- Pandas: DataFrames, groupby, merge operations
- NumPy: Array operations, quantile calculations
- RFM segmentation logic
- Data cleaning and transformation

**Visualization**
- Matplotlib: Multi-subplot layouts
- Seaborn: Professional styling
- Color palettes for data storytelling
- Chart type selection (scatter, bar, funnel)

**Business Analysis**
- Customer lifetime value calculation
- Segmentation strategy
- Actionable recommendations
- Risk/opportunity identification

##Dataset Details

**Online Retail II Dataset**
- **Source:** UCI Machine Learning Repository
- **Time Period:** December 2010 — December 2011
- **Records:** 1,067,371 transactions
- **Customers:** 5,878 unique
- **Countries:** 37 nations
- **Columns:** 8 (Invoice, StockCode, Description, Quantity, InvoiceDate, Price, CustomerID, Country)

**Data Quality:**
-  No duplicates
-  Date formats standardized
-  Postal codes preserved with leading zeros
-  Negative quantities (returns) handled appropriately

##How to Use This Analysis

### Running the Jupyter Notebook

```python
# Prerequisites
pip install pandas numpy matplotlib seaborn psycopg2 sqlalchemy

# Open notebook
jupyter notebook ecommerce_analysis.ipynb

# Execute cells in order:
# 1. Import libraries
# 2. Load data from PostgreSQL
# 3. Run SQL queries
# 4. Calculate RFM metrics
# 5. Segment customers
# 6. Generate visualizations
# 7. Export results
```

### PostgreSQL Setup

```sql
-- Create database
CREATE DATABASE ecommerce_analysis;

-- Create table
CREATE TABLE online_retail (
    invoice VARCHAR(20),
    stock_code VARCHAR(20),
    description VARCHAR(255),
    quantity INTEGER,
    invoice_date TIMESTAMP,
    price NUMERIC(10,2),
    customer_id VARCHAR(20),
    country VARCHAR(50)
);

-- Load data (see ecommerce_analysis.ipynb for import code)
```

### Interpreting Results

**RFM Scatter Plot:**
- **X-axis:** Recency (0-760 days) — lower is better
- **Y-axis:** Frequency (0-400 orders) — higher is better
- **Bubble size:** Monetary value — larger = higher spend
- **Color:** Segment — teal=Champions, red=At Risk, gray=Lost

**Segment Distribution:**
- Champions: 22% of base, 65% of revenue (VIP focus)
- Lost: 22% of base, 2% of revenue (recovery opportunity)
- Loyal: 19% of base, 18% of revenue (retention focus)

##  Business Applications

**Marketing**
- Segment-specific campaigns (different messaging per RFM tier)
- Email frequency (Champions: weekly, Lost: monthly reactivation)
- Offer strategy (Champions: loyalty; New: conversion; At-Risk: incentive)

**Finance**
- Revenue forecasting by segment
- Lifetime value prediction
- Churn risk quantification

**Operations**
- Inventory allocation (stock popular items for Champions)
- Fulfillment priority (expedite for high-value customers)
- Customer service routing (VIP support for Champions)

##  Validation & Quality Checks
- Total records: 1,067,371 (no data loss)
- Unique customers: 5,878 (5.5% of transactions average)
- Revenue total: $9,240,760 (matches source system)
- Date range: 2010-12-01 to 2011-12-09 (continuous)
- RFM segments: 7 categories, 5,878 customers (100% coverage)

##  Results Summary

| Metric | Value |
|--------|-------|
| **Customers Analyzed** | 5,878 |
| **Revenue Analyzed** | $9.24M |
| **Average RFM Score** | 2.5/5 (moderate health) |
| **Champions Concentration** | 22% customers, 65% revenue |
| **At-Risk Count** | 612 customers ($2.5M potential loss) |
| **Win-back Opportunity** | 1,274 lost customers |

##  Related Projects

- [Sales & HR Analytics Dashboard (Excel)](https://github.com/DanFalak7/Sales_HR_Analytics---Excel) — 7 KPI cards, 4 charts
- [HR Analytics Dashboard (Power BI)](https://github.com/DanFalak7/hr-analytics-powerbi) — Advanced DAX, heatmaps

##  Next Steps

1. **Run the notebook** with your own PostgreSQL instance
2. **Modify RFM thresholds** based on your business rules
3. **Export segment lists** for marketing campaigns
4. **Monitor churn** of at-risk segment monthly

##  Questions?

This analysis is ready for:
- Marketing teams (customer segmentation campaigns)
- Finance (revenue forecasting by segment)
- Executive (strategic customer focus)

---

 
**Last Updated:** June 2026    
**Data Size:** 1M+ transactions
