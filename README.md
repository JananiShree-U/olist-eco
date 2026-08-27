# 🛒 Olist E-Commerce Analytics

> **End-to-End SQL & Power BI Business Intelligence Project**

An end-to-end e-commerce analytics project built on the **Brazilian Olist marketplace dataset**, evaluating sales performance, customer behavior, seller performance, product trends, delivery operations, and customer satisfaction.

The project combines **SQL-based data validation and business analysis** with **interactive Power BI dashboards** to transform raw transactional data into actionable business insights.

---

## 📌 Project Overview

E-commerce businesses generate large volumes of transactional, customer, seller, product, payment, delivery, and review data — but raw data alone doesn't create business value.

This project follows a structured analytics workflow:

**Raw Data → Data Quality Assessment → Data Validation → SQL Analysis → KPI Development → Power BI Dashboards → Business Insights**

The objective is to understand:

- How the marketplace is performing financially
- Which products and categories drive sales
- How customers behave and purchase
- Which sellers perform best
- How delivery performance affects customer satisfaction
- Where potential business improvement opportunities exist

---

## 🎯 Business Objectives

### 💰 Sales Performance
- How are revenue and order volumes changing over time?
- What are the key sales trends?
- What is the average order value?
- Which product categories contribute most to sales?

### 👥 Customer Analysis
- How many customers are purchasing from the marketplace?
- What does customer purchasing behavior look like?
- Which locations generate the highest order volume?
- What factors are associated with customer satisfaction?

### 🏪 Seller Performance
- Which sellers generate the highest revenue?
- Which sellers process the highest number of orders?
- How does seller performance vary across categories?
- Are high-volume sellers also maintaining strong customer ratings?

### 🚚 Delivery & Customer Experience
- How long do customers typically wait for their orders?
- How does delivery performance vary?
- Is delayed delivery associated with lower review scores?
- What areas may require operational improvement?

---

## 🗂️ Dataset

The project uses the **Olist Brazilian E-Commerce Public Dataset**, containing approximately 100K orders placed between **2016 and 2018**.

### Core Tables

| Table | Description |
|---|---|
| `customers` | Customer information and location |
| `orders` | Order status and timestamps |
| `order_items` | Products purchased within each order |
| `products` | Product-level information |
| `sellers` | Seller information and location |
| `order_payments` | Payment details |
| `order_reviews` | Customer review scores and comments |
| `product_category_name_translation` | Portuguese-to-English category mapping |

The relational structure enables analysis of the complete order lifecycle: **customer → order → product → seller → payment → delivery → review**.

---

## 🛠️ Tools & Technologies

**Data Analysis:** SQL · Relational Data Modeling · Data Validation · Data Quality Analysis · Aggregations & Joins · CTEs · Window Functions · Date & Time Analysis

**Visualization & BI:** Microsoft Power BI · DAX · Interactive Dashboard Design · KPI Development · Data Modeling

**Supporting Tools:** GitHub · Excel

---

## 🧹 Data Quality & Validation

Before performing business analysis, the dataset was systematically validated to ensure analytical reliability. The SQL validation workflow includes:

1. Table structure verification
2. Duplicate record detection
3. Row count validation
4. Missing value analysis
5. Data validation
6. Relationship validation
7. Price & freight validation
8. Product category & review validation
9. Order status analysis

This ensures downstream KPIs and visualizations are based on validated, consistent data.

---

## 📊 KPI Framework

The Power BI dashboards track **10 key business KPIs** covering sales, customers, sellers, orders, and customer experience.

| KPI | Business Purpose |
|---|---|
| Total Revenue | Measures overall marketplace sales |
| Total Orders | Measures transaction volume |
| Average Order Value | Measures average revenue generated per order |
| Total Customers | Measures customer base |
| Total Sellers | Measures marketplace seller base |
| Average Review Score | Measures customer satisfaction |
| Total Products | Measures product diversity |
| Freight Revenue / Cost | Evaluates shipping contribution |
| Delivery Performance | Measures order fulfillment efficiency |
| Category Performance | Identifies high-performing product segments |

---

## 📈 Power BI Dashboards

The project contains **3 interactive Power BI dashboards**, each built for a different business perspective.

### 1️⃣ Executive Overview
**Focus:** Revenue, orders, average order value, customer growth, product/category performance, sales trends, order status, geographic performance.

**Business Question:** *"How is the Olist marketplace performing overall?"*

### 2️⃣ Customer Analytics
**Focus:** Customer distribution, geographic analysis, order behavior, purchasing trends, review scores, delivery experience, customer satisfaction.

**Business Question:** *"Who are the customers, how do they purchase, and what influences their experience?"*

### 3️⃣ Seller Analytics
**Focus:** Seller revenue, order volume, seller location, product categories, performance comparison, review scores, delivery performance.

**Business Question:** *"Which sellers are driving marketplace performance, and where are the operational gaps?"*

---

## 🔍 Key Analytical Areas

**📅 Time-Based Analysis** — Monthly revenue trends · Order volume trends · Year-over-year performance · Seasonal patterns

**🛍️ Product Analysis** — Top-performing categories · Revenue by category · Order volume by category · Product-level performance

**👥 Customer Analysis** — Customer distribution · Geographic purchasing behavior · Order frequency · Customer satisfaction

**🏪 Seller Analysis** — Top sellers by revenue · Top sellers by order volume · Seller geographic distribution · Seller review performance

**🚚 Logistics Analysis** — Estimated vs. actual delivery · Delivery duration · Late deliveries · Freight contribution · Delivery-to-review relationship

---


## 📁 Project Structure

```text
OLIST-E-COMMERCE-ANALYTICS/
│
├── SQL/
│   ├── 01_Table_Creation.sql
│   ├── 02_Data_Quality_Assessment.sql
│   ├── 03_Missing_Value_Analysis.sql
│   ├── 04_Data_Validation.sql
│   ├── 05_Relationship_Validation.sql
│   ├── 06_Price_and_Freight_Validation.sql
│   ├── 07_Product_Category_and_Review_Validation.sql
│   ├── 08_Order_Status_Analysis.sql
│   ├── 09_Sales_Performance.sql
│   ├── 10_Customer_Analysis.sql
│   └── 11_Seller_Analysis.sql
│
├── PowerBI/
│   └── Olist_Ecommerce_Dashboard.pbix
│
├── Dashboard_Screenshots/
│   ├── Executive_Overview.png
│   ├── Customer_Analytics.png
│   └── Seller_Analytics.png
│
└── README.md
```

---

## 🔄 Analytical Workflow

```text
OLIST DATASET
     │
     ▼
Data Quality Check
     │
     ▼
Data Validation & Relationship Checks
     │
     ▼
SQL Analysis
     │
     ▼
KPI Development
     │
     ▼
Power BI Dashboards
     │
     ▼
Business Insights
     │
     ▼
Actionable Recommendations
```

---


## 🧠 Key Skills Demonstrated

SQL Data Analysis · Data Cleaning & Validation · Relational Data Modeling · Complex SQL Joins · CTEs · Window Functions · Aggregations · Business KPI Development · Power BI Dashboard Development · DAX · Data Visualization · Customer Analytics · Sales Analytics · Seller Performance Analysis · E-Commerce Analytics · Business Storytelling · Data-Driven Decision Making

---

## 🔎 What This Project Demonstrates

Rather than focusing only on creating visualizations, this project follows a complete analytics lifecycle:

> **Validate the data → Analyze the business → Build KPIs → Visualize performance → Generate insights → Recommend actions**

This ensures the final dashboards are not just visually informative, but **business-oriented and decision-focused**.

---

## 👩‍💻 Author

**Janani U**
Aspiring Data Analyst | Business Intelligence | AI/ML

Interested in solving real-world business problems through data analysis, SQL, visualization, and machine learning.

---

 If you found this project useful or interesting, feel free to explore the SQL scripts and Power BI dashboards.
