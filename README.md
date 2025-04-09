# 📉 Tech Layoffs SQL Data Analysis Project

This project analyzes global tech layoffs using SQL. The dataset includes major tech company layoffs, providing insights into trends over time, affected industries, funding stages, and company status. The project includes data cleaning, transformation, and analysis to generate meaningful business insights.

---

## 📊 Project Overview

- **Title**: Tech Layoffs SQL Project
- **Focus Areas**: Data Cleaning, Trend Analysis, Business Intelligence
- **Dataset**: Layoffs in tech companies from 2020 onwards
- **Tools Used**: SQL (MySQL / PostgreSQL), Excel, CSV

![click to SQL Code](https://github.com/Softechanalytics/layoffs/blob/main/sql_SOLUTION_BARRA.sql)

![click to Dataset](https://github.com/Softechanalytics/layoffs/blob/main/layoffs.csv)

---

## 📁 Repository Structure

├── layoffs.csv / layoffs.xlsx # Raw dataset

├── Data cleaning.sql # Data cleaning queries 

├── sql_SOLUTION_BARRA.sql # Final analysis queries 

├── README.md # Project documentation

yaml
Copy
Edit

---

## 🧾 Dataset Description

| Column           | Description                           |
|------------------|---------------------------------------|
| company          | Name of the company                   |
| location         | HQ or country of operation            |
| industry         | Sector the company operates in        |
| total_laid_off   | Number of employees laid off          |
| percentage_laid_off | Percentage of workforce laid off   |
| date             | Layoff announcement date              |
| stage            | Startup funding stage (e.g., Series A)|
| country          | Country of the company                |
| funds_raised_millions | Total funds raised in USD        |

---

## 🧹 Data Cleaning Steps

Performed in `Data cleaning.sql`:
- Removed duplicates
- Standardized company names and null values
- Reformatted date columns
- Removed outliers and invalid entries
- Cleaned and transformed percentage values

---

## 📌 Business Questions Answered

Included in `sql_SOLUTION_BARRA.sql`:
1. What are the top 10 companies with the most layoffs?
2. Which year recorded the highest number of layoffs?
3. Which industries are most affected?
4. Are layoffs correlated with funding stages?
5. What are the average layoffs by country?
6. How many companies had 100% workforce laid off?
7. What trends are visible over time (monthly/yearly)?
8. Who are the top countries affected by layoffs?

---

## 📈 Sample SQL Query

```sql
-- Top 5 companies with the most layoffs
SELECT 
    company,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_cleaned
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 5;
📊 Key Insights
The technology industry saw the highest layoffs during 2022 and early 2023.

Series C and later-stage startups were hit hardest.

100% layoffs occurred in several companies, indicating closures.

Countries like the USA, India, and Canada were the most affected.

🚀 How to Use
Clone the repository:

bash
Copy
Edit
git clone https://github.com/yourusername/tech-layoffs-sql-analysis.git
Load the dataset (layoffs.csv or .xlsx) into your SQL environment.

Run:

Data cleaning.sql to prepare the dataset

sql_SOLUTION_BARRA.sql to extract insights

Modify queries or expand with your own analysis!

👤 Author
Anyakwu Chukwuemeka Isaac
🔗 LinkedIn | ✉️ Email

📜 License
This project is for educational and portfolio purposes only.
© 2025 Great Learning – All rights reserved.
