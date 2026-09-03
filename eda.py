"""
Walmart Store Performance Analysis — Python EDA (basics)
Simple, beginner-friendly script using pandas + matplotlib.
Run: python3 python/eda.py
"""

import pandas as pd
import matplotlib.pyplot as plt
import os

# ---------- 1. Load data ----------
sales = pd.read_csv("data/walmart_sales.csv")
stores = pd.read_csv("data/store_info.csv")
print("Sales rows:", sales.shape, "| Stores:", stores.shape)

# ---------- 2. Basic cleaning / validation ----------
sales["date"] = pd.to_datetime(sales["date"])
print("\nMissing values:\n", sales.isnull().sum())

before = len(sales)
sales = sales.drop_duplicates()
print(f"Removed {before - len(sales)} duplicate rows")

print("Any negative sales?", (sales["weekly_sales"] < 0).any())

# ---------- 3. Merge with store info ----------
df = sales.merge(stores, on="store_id", how="left")

# ---------- 4. Store performance ranking ----------
store_perf = (
    df.groupby("store_id")["weekly_sales"]
    .agg(total_sales="sum", avg_sales="mean")
    .sort_values("total_sales", ascending=False)
)
print("\nTop 10 stores by total sales:\n", store_perf.head(10))
print("\nBottom 5 stores by total sales:\n", store_perf.tail(5))

# ---------- 5. Seasonal demand pattern ----------
df["month"] = df["date"].dt.month
seasonal = df.groupby("month")["weekly_sales"].mean()
print("\nAverage sales by month (seasonality):\n", seasonal)

# ---------- 6. Holiday impact ----------
holiday_lift = df.groupby("is_holiday")["weekly_sales"].mean()
print("\nAvg sales — Holiday(1) vs Non-Holiday(0):\n", holiday_lift)

# ---------- 7. Regional comparison ----------
region_perf = df.groupby("region")["weekly_sales"].sum().sort_values(ascending=False)
print("\nTotal sales by region:\n", region_perf)

# ---------- 8. Simple charts ----------
os.makedirs("python/charts", exist_ok=True)

store_perf.head(10)["total_sales"].plot(
    kind="bar", title="Top 10 Stores by Total Sales", color="navy"
)
plt.ylabel("Total Sales ($)")
plt.tight_layout()
plt.savefig("python/charts/top_stores.png")
plt.close()

seasonal.plot(kind="line", marker="o", title="Average Sales by Month (Seasonality)")
plt.xlabel("Month")
plt.ylabel("Avg Weekly Sales ($)")
plt.tight_layout()
plt.savefig("python/charts/seasonal_pattern.png")
plt.close()

region_perf.plot(kind="bar", title="Total Sales by Region", color="darkgreen")
plt.ylabel("Total Sales ($)")
plt.tight_layout()
plt.savefig("python/charts/region_sales.png")
plt.close()

print("\nCharts saved to python/charts/")
