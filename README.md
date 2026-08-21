# data_warehouse_project

# 📊 SQL Data Warehouse & Advanced Analytics - Complete Learning Project

> **A complete end-to-end SQL learning project covering Data Warehousing, Exploratory Data Analysis (EDA), Advanced Analytics, and Reporting using production-style SQL architecture and workflows.**

---

# 🙏 Acknowledgment

Special thanks to Baraa Masoud for creating the incredible **30-Hour SQL Master Class: Zero to Hero**.

This project was heavily inspired by the practical and industry-oriented approach taught throughout the course.

### What makes the course exceptional?

- ✅ Real-world SQL engineering concepts
- ✅ Production-grade implementation patterns
- ✅ Enterprise-level data warehouse architecture
- ✅ End-to-end analytics workflows
- ✅ Clear explanations for beginners and intermediate learners
- ✅ Complete hands-on projects instead of isolated tutorials

📺 YouTube Channel: http://bit.ly/3GiCVUE

---

# 🎯 Project Overview

This repository combines **three major SQL learning modules** into one structured project:

1. **SQL Data Warehouse Engineering**
2. **Exploratory Data Analysis (EDA)**
3. **Advanced Analytics & Reporting**

The project demonstrates how raw business data flows through a complete analytics pipeline using the **Medallion Architecture** pattern.

---

# 📦 Project Modules

---

## 🏗️ Project 1 — SQL Data Warehouse Engineering (Main Focus ⭐)

![Data Architecture](/docs/dw_architecture.png)

This module implements a complete **Modern Data Warehouse** using the **Medallion Architecture** approach.

### Architecture Layers

### 🥉 Bronze Layer
Raw ingestion layer for source-system data.

Responsibilities:
- CRM & ERP raw ingestion
- Historical preservation
- Source fidelity
- Staging tables

### 🥈 Silver Layer
Data cleansing and transformation layer.

Responsibilities:
- Data standardization
- Null handling
- Deduplication
- Business rule validation
- Type conversion

### 🥇 Gold Layer
Analytics-ready dimensional model.

Responsibilities:
- Star schema implementation
- Fact and dimension modeling
- Reporting optimization
- Business-ready datasets

### Core Concepts Covered

- Medallion Architecture
- ETL Pipeline Development
- Data Quality Validation
- Incremental Processing
- Dimensional Modeling
- Star Schema Design
- Stored Procedures
- Data Warehouse Testing

📄 Detailed Guide: `md/01_DATA_WAREHOUSE_README.md`

Important Documentation:
- `docs/dw_architecture.png`
- `docs/data_model.png`
- `docs/integration_model.png`
- `docs/data_flow.png`

---

## 🔍 Project 2 — Exploratory Data Analysis (EDA)

This module focuses on structured SQL-based exploration techniques.

### Topics Covered

- Database exploration
- Schema analysis
- Dimension exploration
- Time-series analysis
- KPI calculations
- Magnitude analysis
- Ranking analysis

### EDA Workflow

1. Database Exploration
2. Dimensions Exploration
3. Date Range Analysis
4. Measures Exploration
5. Magnitude Analysis
6. Ranking Analysis

📄 Detailed Guide: `md/02_EDA_README.md`

Key Scripts:
- `scripts/02_eda/01_database_exploration.sql`
- `scripts/02_eda/02_dimensions_exploration.sql`
- `scripts/02_eda/03_date_range_exploration.sql`
- `scripts/02_eda/04_measures_exploration.sql`
- `scripts/02_eda/05_magnitude_analysis.sql`
- `scripts/02_eda/06_ranking_analysis.sql`

---

## 📈 Project 3 — Advanced Analytics & Reporting

This module demonstrates advanced business analytics using SQL.

### Analytics Topics

- Change-over-time analysis
- Cumulative analysis
- Performance benchmarking
- Part-to-whole analysis
- Customer segmentation
- Product segmentation

### Reporting Layer

Production-style analytical reports:

- Customer Performance Report
- Product Performance Report

📄 Detailed Guide: `md/03_ADVANCED_ANALYTICS_README.md`

Key Scripts:
- `scripts/03_advaced_analytics/07_change_over_time_analysis.sql`
- `scripts/03_advaced_analytics/08_cumulative_analysis.sql`
- `scripts/03_advaced_analytics/09_performance_analysis.sql`
- `scripts/03_advaced_analytics/10_part_to_whole_analysis.sql`
- `scripts/03_advaced_analytics/11_data_segmentation.sql`

Reports:
- `scripts/04_reports/12_customer_report.sql`
- `scripts/04_reports/13_product_report.sql`

---

# 📂 Repository Structure

```bash
data-warehouse-project/
├── LICENSE
├── README_MAIN.md
│
├── datasets
│   ├── source_crm
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   │
│   └── source_erp
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
│
├── docs
│   ├── data_catalog.md
│   ├── data_flow.png
│   ├── data_model.png
│   ├── dw_architecture.png
│   ├── integration_model.png
│   ├── master.drawio
│   └── naming_conventions.md
│
├── md
│   ├── 01_DATA_WAREHOUSE_README.md
│   ├── 02_EDA_README.md
│   └── 03_ADVANCED_ANALYTICS_README.md
│
└── scripts
    ├── 01_data_warehouse
    │   ├── bronze
    │   │   ├── ddl_bronze.sql
    │   │   └── proc_load_bronze.sql
    │   │
    │   ├── silver
    │   │   ├── ddl_silver.sql
    │   │   └── proc_load_silver.sql
    │   │
    │   ├── gold
    │   │   └── ddl_gold.sql
    │   │
    │   ├── tests
    │   │   ├── quality_checks_gold.sql
    │   │   └── quality_checks_silver.sql
    │   │
    │   ├── init_database.sql
    │   └── raw_practice
    │
    ├── 02_eda
    │   ├── 00_init_database.sql
    │   ├── 01_database_exploration.sql
    │   ├── 02_dimensions_exploration.sql
    │   ├── 03_date_range_exploration.sql
    │   ├── 04_measures_exploration.sql
    │   ├── 05_magnitude_analysis.sql
    │   └── 06_ranking_analysis.sql
    │
    ├── 03_advaced_analytics
    │   ├── 07_change_over_time_analysis.sql
    │   ├── 08_cumulative_analysis.sql
    │   ├── 09_performance_analysis.sql
    │   ├── 10_part_to_whole_analysis.sql
    │   └── 11_data_segmentation.sql
    │
    ├── 04_reports
    │   ├── 12_customer_report.sql
    │   └── 13_product_report.sql
    │
    └── raw_practice
        ├── adv_eda.sql
        ├── cust_report.sql
        ├── eda.sql
        ├── gold_dim_products.sql
        ├── prod_report.sql
        ├── silver_crm_cust_info.sql
        ├── silver_crm_prd_info.sql
        ├── silver_crm_sales_detials.sql
        ├── silver_erp_cust_az12.sql
        ├── silver_erp_loc_a101.sql
        └── silver_erp_px_cat_g1v2.sql
```

---

# 🚀 Quick Start

## Step 1 — Initialize Database

```sql
:r scripts/01_data_warehouse/init_database.sql
```

---

## Step 2 — Create Bronze Layer

```sql
:r scripts/01_data_warehouse/bronze/ddl_bronze.sql
:r scripts/01_data_warehouse/bronze/proc_load_bronze.sql
```

---

## Step 3 — Create Silver Layer

```sql
:r scripts/01_data_warehouse/silver/ddl_silver.sql
:r scripts/01_data_warehouse/silver/proc_load_silver.sql
```

---

## Step 4 — Create Gold Layer

```sql
:r scripts/01_data_warehouse/gold/ddl_gold.sql
```

---

## Step 5 — Run Data Quality Checks

```sql
:r scripts/01_data_warehouse/tests/quality_checks_silver.sql
:r scripts/01_data_warehouse/tests/quality_checks_gold.sql
```

---

# 📊 What You'll Learn

✅ Medallion Architecture  
✅ Data Warehouse Design  
✅ ETL Pipeline Development  
✅ Incremental Processing  
✅ Dimensional Modeling  
✅ Star Schema Design  
✅ Stored Procedures  
✅ Window Functions  
✅ CTEs & Advanced SQL  
✅ Data Quality Frameworks  
✅ Business Analytics  
✅ Reporting & KPI Design  
✅ SQL Optimization Techniques  

---

# 🛠️ Technology Stack

| Component | Technology |
|---|---|
| Database | SQL Server |
| SQL Dialect | T-SQL |
| IDE | SQL Server Management Studio (SSMS) |
| Source Systems | CRM & ERP CSV Files |

---

# 🤝 Contributing

Contributions, improvements, and suggestions are welcome.

If this project helps you:

- ⭐ Star the repository
- 🍴 Fork the project
- 📢 Share with others
- 🧠 Suggest improvements

---

# 📄 License

MIT License — free to use for learning and teaching.

---

# 🎓 Final Note

This repository is designed not just as a SQL tutorial, but as a practical demonstration of how modern analytics engineering projects are structured in real-world environments.

From raw ingestion to analytics-ready reporting, the project walks through the complete lifecycle of building a scalable SQL-based analytics platform.

Happy Learning 🚀
