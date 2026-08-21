# 🔍 Project 2: Exploratory Data Analysis (EDA)

> **Systematic SQL-Based Data Discovery - 6 Progressive Steps**

## 🎯 Project Overview

This project demonstrates a **comprehensive, systematic approach** to data exploration using SQL. Follow 6 progressive steps, each building on the previous to develop complete data understanding.

The EDA framework answers critical questions: What data do we have? How much? What patterns exist? This knowledge is essential before building analytics or making business decisions.

---

## 📊 The 6-Step EDA Framework

### Step 01: Database Exploration
**Purpose:** Discover schema structure and data organization.

**Questions Answered:**
- What tables and views exist?
- What are the column names and data types?

**SQL Techniques:**
- INFORMATION_SCHEMA queries
- System metadata exploration

---

### Step 02: Dimensions Exploration
**Purpose:** Catalog all categorical attributes and their values.

**Questions Answered:**
- What are the distinct values in each category?
- How many categories exist?

**Examples:**
```sql
SELECT DISTINCT country FROM gold.dim_customers;
SELECT DISTINCT category FROM gold.dim_products;
```

**Business Value:**
- Understand customer and product segmentation
- Identify product portfolio structure

---

### Step 03: Date Range Exploration
**Purpose:** Determine temporal scope and data freshness.

**Questions Answered:**
- What is the oldest/newest date in the dataset?
- How long does the data span?

**Key Metrics:**
```
Order Date Range: 2010-12-29 to 2014-01-28 (37 months)
Customer Age: 40 to 110 years old
```

**Business Value:**
- Understand historical depth
- Identify data gaps

---

### Step 04: Measures Exploration
**Purpose:** Establish baseline KPI values and data magnitude.

**Questions Answered:**
- What is total sales revenue?
- How many orders and customers exist?

**Key Metrics:**
```
Total Revenue: $29.4M
Total Orders: 27,659
Total Customers: 18,484
Average Order Value: $1,062
```

**Business Value:**
- Establish performance baselines
- Identify outliers

---

### Step 05: Magnitude Analysis
**Purpose:** Understand data distribution and relative sizes.

**Questions Answered:**
- How is data distributed across dimensions?
- What are the major segments?

**Distributions:**
```
Customers by Country:
  United States:  7,482 (40%)
  Australia:      3,591 (19%)

Products by Category:
  Components:  127 (43%)
  Bikes:        97 (33%)
```

**Business Value:**
- Identify market concentration
- Find growth opportunities

---

### Step 06: Ranking Analysis
**Purpose:** Identify top and bottom performers.

**Questions Answered:**
- Which products generate highest revenue?
- Who are the top customers?

**Sample Results:**
```
Top 5 Products:
  1. Mountain-200 Black 46     $1,373,454
  2. Mountain-200 Black 42     $1,363,128
  3. Mountain-200 Silver 38    $1,339,394
```

**Business Value:**
- Identify star products
- Find underperformers for review

---

## 🛠️ SQL Techniques Covered

| Technique | Steps |
|-----------|-------|
| SELECT DISTINCT | 02, 03 |
| GROUP BY aggregations | 02, 05, 06 |
| ORDER BY ranking | 06 |
| Date functions | 03 |
| Simple aggregations | 04, 05 |
| Multiple JOINs | 05, 06 |

---

## 📋 Execution Guide

```sql
:r data_warehouse_scripts/01_database_exploration.sql
:r data_warehouse_scripts/02_dimensions_exploration.sql
:r data_warehouse_scripts/03_date_range_exploration.sql
:r data_warehouse_scripts/04_measures_exploration.sql
:r data_warehouse_scripts/05_magnitude_analysis.sql
:r data_warehouse_scripts/06_ranking_analysis.sql
```

---

## 📊 Key Metrics to Extract

After completing EDA, you should know:

**Data Inventory:**
- Number of customers, products, orders
- Date range of data
- Geographic distribution

**Business Metrics:**
- Total revenue, average order value
- Customer concentration
- Product mix

**Customer Insights:**
- Top customers and their value
- Geographic concentration

**Product Insights:**
- Top/bottom products
- Category mix

---

## 🎓 Credits

Based on **Baraa Masoud's SQL Master Class** exploratory analysis framework.

---

