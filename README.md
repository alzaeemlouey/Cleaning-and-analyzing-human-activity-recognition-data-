# Getting and Cleaning Data – Course Project

## Project Summary

This repository contains the scripts and documentation for cleaning and tidying the **UCI Human Activity Recognition (HAR) Using Smartphones** dataset.  
The goal is to merge, clean, and summarise raw accelerometer / gyroscope data collected from a Samsung Galaxy S II into a single tidy dataset ready for downstream analysis.

---

## Repository Contents

| File | Description |
|------|-------------|
| `run_analysis.R` | Main R script – performs all 5 cleaning steps |
| `tidy_data.txt` | Final tidy dataset output (180 rows × 68 columns) |
| `CodeBook.md` | Describes all variables, source data, and transformations |
| `README.md` | This file – explains the project and how scripts relate |

---

## Raw Data Source

Download the raw data from:  
`https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`

Unzip it so that the folder `UCI HAR Dataset/` sits in your working directory alongside `run_analysis.R`.

Full dataset description:  
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

---

## How to Run

### Using R (recommended)

```r
# 1. Install dependency if needed
install.packages("dplyr")

# 2. Set working directory to the repo root (where run_analysis.R lives)
setwd("/path/to/repo")

# 3. Run the script
source("run_analysis.R")

# 4. Read the output
tidy <- read.table("tidy_data.txt", header = TRUE)
```

> **Requirement**: `UCI HAR Dataset/` must exist in the working directory before running.

---

## What `run_analysis.R` Does – Step by Step

The script follows exactly the 5 steps required by the assignment:

### Step 1 – Merge Training and Test Sets
- Loads `X_train.txt`, `y_train.txt`, `subject_train.txt` from the `train/` folder.
- Loads `X_test.txt`, `y_test.txt`, `subject_test.txt` from the `test/` folder.
- Column-binds subject IDs, activity IDs, and measurements for each split.
- Row-binds training and test into one dataset → **10,299 observations × 563 variables**.

### Step 2 – Extract Mean and Standard Deviation Measurements
- Searches feature names for `mean()` or `std()` (exact match, case-sensitive).
- Retains those **66 columns** plus `subject_id` and `activity_id`.

### Step 3 – Use Descriptive Activity Names
- Merges the `activity_labels.txt` lookup table.
- Replaces numeric codes (1–6) with text labels:  
  `WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING`.

### Step 4 – Label with Descriptive Variable Names
Applies systematic renaming to every measurement column:

| Pattern | Replacement |
|---------|-------------|
| Leading `t` | `TimeDomain_` |
| Leading `f` | `FrequencyDomain_` |
| `Acc` | `Accelerometer` |
| `Gyro` | `Gyroscope` |
| `Mag` | `Magnitude` |
| `BodyBody` | `Body` (fixes source typo) |
| `-mean()` | `_Mean` |
| `-std()` | `_StdDev` |

### Step 5 – Create the Tidy Summary Dataset
- Groups the cleaned dataset by `subject_id` and `activity`.
- Computes the **mean** of every measurement column for each group.
- Prefixes averaged columns with `Avg_`.
- Writes the result to `tidy_data.txt` (space-separated, header included).  
  Output: **180 rows** (30 subjects × 6 activities) × **68 columns**.

---

## Reading the Output

```r
tidy <- read.table("tidy_data.txt", header = TRUE, check.names = FALSE)
dim(tidy)   # 180 68
head(tidy[, 1:4])
```

---

## Tidy Data Principles Met

| Principle | How it is met |
|-----------|--------------|
| Each variable in one column | ✓ One measurement per column |
| Each observation in one row | ✓ One row per subject–activity pair |
| Each observational unit in one table | ✓ Single `tidy_data.txt` file |
| Descriptive column names | ✓ Human-readable names (Step 4) |
| Descriptive value labels | ✓ Activity names instead of integers (Step 3) |

---

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `dplyr` | ≥ 1.0 | `group_by`, `summarise`, `across` |

---

## License

Original dataset © 2012 Jorge L. Reyes-Ortiz et al., Smartlab – Non-Linear Complex Systems Laboratory, DITEN, Università degli Studi di Genova.  
This cleaning script is released under the MIT License.
