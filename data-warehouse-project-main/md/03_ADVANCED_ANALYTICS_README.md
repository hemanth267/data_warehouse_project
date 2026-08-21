# 📈 Project 3: Advanced Data Analytics

> **Sophisticated SQL Techniques for Business Intelligence & Reporting**

## 🎯 Project Overview

This project demonstrates **advanced SQL analytics techniques** used in real-world business intelligence. Cover 5 analytical domains plus 2 production-quality reports.

---

## 📊 Five Advanced Analytics Scripts

### Script 07: Change Over Time Analysis

**Purpose:** Detect trends, seasonality, and temporal patterns.

**Business Questions:**
- What is the seasonal pattern in our sales?
- How do monthly sales trend across years?

**SQL Techniques:**
```sql
SELECT
    YEAR(order_date) AS year,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);
```

**Insights:**
```
Yearly Trend:
  2011: $7.1M
  2012: $5.8M (-18%)
  2013: $16.3M (+181%)
```

**Business Value:**
- Plan inventory seasonally
- Forecast demand
- Track growth trajectory

---

### Script 08: Cumulative Analysis

**Purpose:** Track compound growth and running totals.

**Business Questions:**
- What is our cumulative revenue to date?
- Is growth accelerating or slowing?

**SQL Techniques:**
```sql
SELECT
    order_date,
    SUM(revenue) OVER (ORDER BY order_date) AS running_total,
    AVG(revenue) OVER (ORDER BY order_date) AS running_avg
FROM monthly_sales
ORDER BY order_date;
```

**Key Metrics:**
- Running total cumulative revenue
- Running average metrics
- Growth acceleration patterns

**Business Value:**
- Visualize long-term progress
- Forecast target dates
- Measure business momentum

---

### Script 09: Performance Analysis

**Purpose:** Compare current performance against baselines and historical periods.

**Business Questions:**
- How does 2013 compare to 2012?
- Which products improved YoY?

**SQL Techniques:**
```sql
SELECT
    product_name,
    SUM(sales) AS curr_sales,
    AVG(sales) OVER (PARTITION BY product_name) AS avg_sales,
    LAG(sales) OVER (PARTITION BY product_name ORDER BY year) AS prev_year
FROM product_sales;
```

**Analysis Output:**
```
Product              2012 Sales  2013 Sales  YoY Change
Mountain-100 Black   $1.2M       $2.85M      +137%
Road-350 Red         $0.95M      $2.1M       +121%
```

**Business Value:**
- Identify performance improvements
- Spot concerning declines
- Benchmark against peers

---

### Script 10: Part-to-Whole Analysis

**Purpose:** Understand composition and contribution percentages.

**Business Questions:**
- What % of revenue comes from each category?
- How concentrated is our revenue?

**SQL Techniques:**
```sql
SELECT
    category,
    revenue,
    ROUND(100.0 * revenue / SUM(revenue) OVER (), 2) AS pct_contribution
FROM category_revenue
ORDER BY revenue DESC;
```

**Results:**
```
Bikes        $28.3M   96.5%  (Dominates)
Accessories  $0.7M    2.4%   (Minimal)
Clothing     $0.3M    1.1%   (Negligible)
```

**Business Value:**
- Identify concentration risks
- Plan diversification
- Understand portfolio balance

---

### Script 11: Data Segmentation

**Purpose:** Partition customers and products into meaningful business groups.

**Business Questions:**
- How do we segment customers (VIP vs Regular vs New)?
- What are product cost categories?

**SQL Techniques:**
```sql
CASE
    WHEN lifespan >= 12 AND monetary > 5000 THEN 'VIP'
    WHEN lifespan >= 12 AND monetary <= 5000 THEN 'REGULAR'
    ELSE 'NEW'
END AS segment
```

**Segmentation Results:**
```
VIP Customers:        1,655 (lifespan ≥12mo, spend >$5K)
Regular Customers:    2,198 (lifespan ≥12mo, spend ≤$5K)
New Customers:       14,631 (lifespan <12mo)

Product Cost Segments:
  Budget ($<100):         23 products
  Mid-Range ($100-500):  152 products
  Premium ($500-1000):    85 products
```

**Business Value:**
- Personalized marketing campaigns
- Resource allocation by value
- Customer retention strategies

---

## 📊 Two Production Reports

### Report 1: Customer Analytics View (Script 12)
**File:** `data_warehouse_scripts/12_customer_report.sql`

**Purpose:** Consolidated customer-level metrics for CRM and marketing.

**Key Metrics:**
- Customer demographics (age, segment, tenure)
- Activity metrics (order count, recency, lifespan)
- Performance (lifetime value, AOV, monthly spend)
- Segmentation (VIP/Regular/New, age groups)

**Use Cases:**
- Customer health scoring
- Churn prediction
- Marketing segmentation
- Sales pipeline management

**Sample Columns:**
```
customer_name | age_group | customer_segment | recency | 
total_orders | total_sales | avg_order_value | avg_monthly_spend
```

---

### Report 2: Product Analytics View (Script 13)
**File:** `data_warehouse_scripts/13_product_report.sql`

**Purpose:** Consolidated product-level metrics for sales and inventory.

**Key Metrics:**
- Product attributes (category, subcategory, cost)
- Performance (order count, revenue, customer reach)
- Segmentation (Low/Mid/High performer)
- Activity (recency, lifecycle metrics)
- Efficiency (AOR, monthly revenue)

**Use Cases:**
- Sales forecasting
- Inventory optimization
- SKU rationalization
- Category strategy

**Sample Columns:**
```
product_name | category | total_revenue | product_segment |
total_orders | total_customers | avg_order_revenue | avg_monthly_revenue
```

---

## 🛠️ Advanced SQL Techniques

### Window Functions
```sql
-- Ranking with ties
RANK() OVER (ORDER BY revenue DESC)
DENSE_RANK() OVER (ORDER BY revenue DESC)

-- Comparative
LAG(revenue) OVER (PARTITION BY product ORDER BY month)
LEAD(revenue) OVER (PARTITION BY product ORDER BY month)

-- Running aggregates
SUM(revenue) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
```

### Complex CTEs & CASE
```sql
WITH customer_metrics AS (
    SELECT
        customer_key,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        SUM(sales_amount) AS monetary
    FROM gold.fact_sales
    GROUP BY customer_key
)
SELECT
    CASE
        WHEN lifespan >= 12 AND monetary > 5000 THEN 'VIP'
        WHEN lifespan >= 12 THEN 'REGULAR'
        ELSE 'NEW'
    END AS segment
FROM customer_metrics;
```

---

## 📋 Execution Flow

```sql
-- Prerequisites: Data warehouse setup (see Project 1)

-- Run all analytics scripts
:r data_warehouse_scripts/07_change_over_time_analysis.sql
:r data_warehouse_scripts/08_cumulative_analysis.sql
:r data_warehouse_scripts/09_performance_analysis.sql
:r data_warehouse_scripts/10_part_to_whole_analysis.sql
:r data_warehouse_scripts/11_data_segmentation.sql

-- Create production reports
:r data_warehouse_scripts/12_customer_report.sql
:r data_warehouse_scripts/13_product_report.sql

-- Query reports for insights
SELECT * FROM gold.report_customers WHERE customer_segment = 'VIP';
SELECT * FROM gold.report_products WHERE product_segment = 'High Performer';
```

---

## 🎓 Learning Outcomes

By completing this advanced project, you'll master:

1. **Window Function Mastery** - Running aggregates, comparative analysis, ranking
2. **Time-Series Analysis** - Trends, seasonality, YoY comparisons
3. **Business Analytics** - RFM segmentation, performance evaluation, KPI definition
4. **Performance Optimization** - Query efficiency, best practices
5. **Report Design** - Metrics development, executive dashboards

---

## 💡 Real-World Applications

**Sales & Marketing:**
- Segment customers for targeted campaigns
- Track ROI and campaign effectiveness
- Identify upsell opportunities

**Product Management:**
- Identify underperformers
- Optimize product mix
- Plan new launches

**Finance & Planning:**
- Revenue forecasting
- Budget allocation
- Profitability analysis

**Operations:**
- Inventory optimization
- Resource planning
- Capacity management

---

## 🎓 Credits

Based on **Baraa Masoud's SQL Master Class** advanced analytics framework.