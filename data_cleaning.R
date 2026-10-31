# Load essential libraries for data manipulation
library(dplyr)
library(readr)
library(tidyr) 

# 1. Import the raw Global Superstore dataset
df <- read_csv("superstore.csv")

# 2. Data Preprocessing & Feature Engineering
clean_df <- df %>%
  # Select key variables required for logistics performance analysis
  select(Order.Date, Ship.Date, Ship.Mode, Region, Category, Sales, Profit, Shipping.Cost) %>%
  # Remove incomplete records to ensure data integrity
  drop_na() %>%
  mutate(
    # Standardize date formats for time-series analysis
    Order_Date_Clean = as.Date(substr(Order.Date, 1, 10)),
    Ship_Date_Clean = as.Date(substr(Ship.Date, 1, 10)),
    
    # Calculate delivery lead time (measured in days)
    Delivery_Days = as.numeric(Ship_Date_Clean - Order_Date_Clean),
    
    # Flag shipments exceeding the 4-day Service Level Agreement (SLA) threshold
    Delivery_Status = ifelse(Delivery_Days > 4, "Late", "On-Time")
  ) %>%
  # Drop original raw date columns to optimize dataset size
  select(-Order.Date, -Ship.Date)

# 3. Export the processed dataset for Power BI visualization
write_csv(clean_df, "clean_scg_logistics.csv")