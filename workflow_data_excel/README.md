# Mini Data Analyst Test - Raw Sales Analysis

## Description

This project is a mini Data Analyst test carried out in Excel.

The goal is to analyze a raw sales dataset using common data cleaning, enrichment, summarization, and visualization techniques.

It demonstrates a Data Analyst workflow for turning raw data into actionable reporting.

## Project Objectives

- Clean raw data (formats, duplicates, missing values)
- Add calculated columns:
  - Revenue (`Quantity * Unit_Price`)
  - Month/Year extracted from the date
  - Customer segment using a lookup from a reference sheet
- Create pivot tables to analyze:
  - Revenue by customer
  - Revenue by country and month
- Identify the customer generating the highest revenue
- Visualize monthly revenue trends using an Excel chart

## Data Analyst Workflow

1. **Import and Inspection of Raw Data**
   - Check data types (dates, text, numbers)
   - Identify and remove duplicates

2. **Data Cleaning and Preparation**
   - Convert dates to the correct format
   - Remove incorrect or empty values

3. **Data Enrichment**
   - Calculate revenue for each row
   - Extract month and year
   - Add the customer segment from a reference table (XLOOKUP / INDEX-MATCH)

4. **Analysis**
   - Create pivot tables
   - Filter by segment, country, or period
   - Sort data to identify the top customer

5. **Visualization**
   - Create a monthly revenue trend chart
   - Optionally filter by customer or segment for comparison

6. **Reporting / Validation**
   - Check the consistency of calculations
   - Validate pivot table and chart results

## Technologies and Tools

- Excel (Pivot Tables, Formulas, Charts)
- Power Query (optional, for data cleaning and transformation)
- Data Analyst methodology

## Expected Output

A clean and structured Excel file containing:

- Raw and enriched data
- An interactive pivot table
- A clear chart showing monthly revenue trends
- The ability to filter data by customer or segment
