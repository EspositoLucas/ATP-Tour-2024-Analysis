# ATP Tour 2024 Data Analysis Project

## Project Overview
This project focuses on analyzing data from the 2024 ATP Tour (men's professional tennis). It involves cleaning raw datasets, performing exploratory data analysis (EDA), and creating insightful visualizations to understand player and tournament statistics for the season.

---

## Repository Structure

### 1. **dashboards/**
- **File:** `dashboard.pbix`
  - A Power BI dashboard showcasing visual insights derived from the ATP Tour 2024 dataset.

### 2. **dataset/**
- **Files:**
  - `atp_2024_results_correct.csv` / `.xlsx`: Cleaned and validated data of ATP 2024 results.
  - `atp_2024_results_errors.csv` / `.xlsx`: Initial raw dataset with errors.

### 3. **notebooks/**
- **Files:**
  - `data_cleaning_test.ipynb`: Jupyter Notebook detailing data cleaning processes and validation steps.
  - `eda.ipynb`: Jupyter Notebook for performing exploratory data analysis (EDA), including visualization and statistical summaries.

### 4. **queries/**
- **Files:**
  - `data_cleaning.sql`: SQL queries to clean and preprocess the raw dataset.
  - `eda.sql`: SQL queries for generating insights and performing EDA.

---

## Installation and Setup

### Prerequisites
- Python 3.8 or higher
- Jupyter Notebook
- Power BI Desktop (for viewing `.pbix` files)
- Required Python libraries:
  - pandas
  - matplotlib
  - seaborn

### Setup
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/atp-tour-2024-analysis.git
   cd atp-tour-2024-analysis
   ```
2. Install required Python packages:
   ```bash
   pip install -r requirements.txt
   ```
3. Open and explore the Jupyter Notebooks:
   ```bash
   jupyter notebook
   ```
4. Use Power BI Desktop to open `dashboards/dashboard.pbix`.

---

## Usage

1. **Data Cleaning**:
   - Run the SQL script `queries/data_cleaning.sql` to clean raw data.
   - Alternatively, use `notebooks/data_cleaning_test.ipynb` for a Python-based cleaning workflow.

2. **Exploratory Data Analysis**:
   - Explore patterns and trends using `notebooks/eda.ipynb`.
   - Use `queries/eda.sql` for database-driven analysis.

3. **Visualizations**:
   - View comprehensive dashboards in Power BI using `dashboard.pbix`.

---

## Results and Insights
The project provides insights into:
- Player performance trends across the 2024 season.
- Tournament-specific statistics and analyses.
- Key metrics such as win rates, ace counts, and match durations.


