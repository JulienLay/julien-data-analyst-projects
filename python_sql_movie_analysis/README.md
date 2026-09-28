# Python + SQL Movie Analysis

This project is a mini **Data Analysis** project based on the [MovieLens dataset](https://grouplens.org/datasets/movielens/) to demonstrate my skills in Python, SQL, and data analysis.

---

## Project Objectives

- Explore and analyze user, movie, and rating data.
- Calculate key metrics:
  - Average ratings by genre
  - Average ratings by movie age group
  - Correlation between number of votes and average rating
- Visualize results using **Matplotlib** and **Seaborn**.
- Build a **simple prediction model** using Linear Regression to estimate a movie's rating based on its genres and age.

---

## Main Notebook Steps

1. **Data import** using `pandas`.
2. **Data preprocessing:**
   - Convert dates to datetime
   - Calculate release year and movie age
   - Handle missing values
3. **Load the data into SQLite** to demonstrate SQL skills.
4. **Exploratory data analysis:**
   - Average ratings by genre and movie age group
   - Correlation between number of votes and average rating
5. **Visualizations:**
   - Heatmap of ratings by genre
   - Boxplot by movie age group
   - Scatter plot of votes vs. average rating
6. **Simple predictive modeling:**
   - Linear Regression to predict a movie's rating
   - Handle missing values using `SimpleImputer`
   - Train/test split and R² evaluation

---

## Skills Demonstrated

- Python (Pandas, Matplotlib, Seaborn, scikit-learn)
- SQL (via SQLite)
- Data Cleaning / Preprocessing
- Data Visualization and Data Storytelling
- Basic Predictive Modeling

---

## How to Use

1. Clone the project:

```bash
git clone https://github.com/JulienLay/julien-data-analyst-projects/tree/main/python_sql_movie_analysis
