# Walmart Store Performance Analysis

Exploratory data analysis (EDA) on multi-store sales data to identify revenue drivers,
seasonal demand patterns, and store-level performance — built with Python, SQL, and
Power BI (DAX).

## Overview
This project simulates daily sales data for 45 Walmart-style stores (2019–2025,
115,000+ records) and demonstrates:
- Python-based data cleaning, validation, and exploratory data analysis (EDA)
- SQL window functions (RANK, ROW_NUMBER) and aggregation for store comparisons
- Seasonal demand pattern discovery (holiday lift, monthly trends)
- Regional and store-level performance benchmarking

## Repo structure
```
walmart-store-performance/
├── data/
│   ├── walmart_sales.csv   # 115,000+ daily sales records across 45 stores
│   └── store_info.csv      # store metadata (type, region, size)
├── sql/
│   └── analysis_queries.sql  # ranking, seasonality, regional, window-function queries
├── python/
│   ├── eda.py               # cleaning, validation, EDA, charts
│   └── charts/               # output PNGs from eda.py
├── powerbi/
│   └── dax_measures.md       # Power BI build steps + DAX measures
└── README.md
```

## Dataset columns (walmart_sales.csv)
| Column | Description |
|---|---|
| store_id | Store identifier (links to store_info.csv) |
| date | Sales date |
| weekly_sales | Daily/weekly sales figure |
| markdown | Promotional markdown amount (0 if none) |
| is_holiday | 1 if date falls in a holiday window, else 0 |
| temperature_f | Local temperature |
| fuel_price | Regional fuel price |
| cpi | Consumer Price Index |
| unemployment_rate | Regional unemployment rate |

## How to reproduce
1. **Python**: `pip install pandas matplotlib` then `python3 python/eda.py` from the
   repo root — cleans and validates the data, ranks stores by sales, calculates
   seasonal averages and holiday lift, compares regions, and saves 3 charts.
2. **SQL**: Load both CSVs using the schema in `sql/analysis_queries.sql`, then run
   the queries for store ranking (window functions), seasonality, regional comparison,
   and markdown effectiveness.
3. **Power BI**: Follow `powerbi/dax_measures.md` to load the data, relate the tables,
   add DAX measures, and build the dashboard pages.

## Key findings (from the synthetic data)
- Clear seasonal spike in **November–December** (holiday season), consistent with
  expected retail demand patterns.
- Holiday dates show a meaningfully higher average sales figure than non-holiday dates.
- Store performance varies widely — top stores generate roughly 10x the sales of the
  lowest-performing stores, driven mainly by store size and region.

## Key skills demonstrated
Python (pandas, matplotlib) for cleaning and EDA, SQL (window functions — RANK,
ROW_NUMBER, running totals — aggregation, filtering), seasonal trend analysis,
DAX, Power BI dashboarding, store/region benchmarking, findings documentation.

## Note on data
The dataset is **synthetically generated** to resemble realistic retail seasonal
sales patterns for portfolio purposes — no real Walmart data is used.
