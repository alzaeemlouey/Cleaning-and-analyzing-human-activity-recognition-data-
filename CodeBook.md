# CodeBook – UCI HAR Tidy Dataset

## Overview

This codebook describes the variables, data sources, and all transformations applied to produce `tidy_data.txt` from the raw **UCI Human Activity Recognition Using Smartphones** dataset.

---

## Source Data

| Item | Detail |
|------|--------|
| **Origin** | UCI Machine Learning Repository |
| **URL** | http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones |
| **Device** | Samsung Galaxy S II (worn on the waist) |
| **Sensors** | 3-axial accelerometer + 3-axial gyroscope at 50 Hz |
| **Subjects** | 30 volunteers aged 19–48 years |
| **Activities** | 6 (see below) |
| **Original split** | 70 % training (7,352 observations), 30 % test (2,947 observations) |

---

## Raw Data Files Used

| File | Description |
|------|-------------|
| `features.txt` | List of 561 feature names |
| `activity_labels.txt` | Mapping of activity IDs (1–6) to names |
| `train/X_train.txt` | Training measurements (7,352 × 561) |
| `train/y_train.txt` | Training activity labels (7,352 × 1) |
| `train/subject_train.txt` | Training subject IDs (7,352 × 1) |
| `test/X_test.txt` | Test measurements (2,947 × 561) |
| `test/y_test.txt` | Test activity labels (2,947 × 1) |
| `test/subject_test.txt` | Test subject IDs (2,947 × 1) |

---

## Transformations Applied

### Step 1 – Merge Training and Test Sets
- Loaded `X_train`, `y_train`, `subject_train` and bound them column-wise.
- Loaded `X_test`, `y_test`, `subject_test` and bound them column-wise.
- Row-bound both sets → **10,299 rows × 563 columns**.
- Duplicate feature names (84 `bandsEnergy` columns) were made unique by appending a suffix index; they were dropped in Step 2 regardless.

### Step 2 – Extract Mean and Standard Deviation Features
- Retained only columns whose original name contains exactly `mean()` or `std()`.
- This yielded **66 measurement columns** (excluded `meanFreq()` and angle-means, which are derived quantities, not direct mean/std of a signal).

### Step 3 – Descriptive Activity Names
- Merged the `activity_labels` lookup table on `activity_id`.
- Replaced the numeric code with the text label (e.g. `1` → `WALKING`).

### Step 4 – Descriptive Variable Names
Systematic renaming rules applied:

| Original pattern | Replaced with |
|-----------------|---------------|
| Leading `t` | `TimeDomain_` |
| Leading `f` | `FrequencyDomain_` |
| `Acc` | `Accelerometer` |
| `Gyro` | `Gyroscope` |
| `Mag` | `Magnitude` |
| `BodyBody` | `Body` (corrected duplication) |
| `-mean()-` | `_Mean_` |
| `-mean()` | `_Mean` |
| `-std()-` | `_StdDev_` |
| `-std()` | `_StdDev` |

### Step 5 – Tidy Summary Dataset
- Grouped by `subject_id` and `activity`.
- Computed the **arithmetic mean** of every measurement column within each group.
- Prefixed all averaged columns with `Avg_` to make clear these are group means.
- Result: **180 rows** (30 subjects × 6 activities) × **68 columns**.
- Written to `tidy_data.txt` (space-separated, header row included).

---

## Variables in `tidy_data.txt`

### Identifier Columns

| Column | Type | Values | Description |
|--------|------|--------|-------------|
| `subject_id` | Integer | 1 – 30 | Anonymised participant identifier |
| `activity` | Character | See below | Physical activity performed |

**Activity values:**

| Label | Description |
|-------|-------------|
| `WALKING` | Subject walking on flat ground |
| `WALKING_UPSTAIRS` | Subject walking up a staircase |
| `WALKING_DOWNSTAIRS` | Subject walking down a staircase |
| `SITTING` | Subject seated |
| `STANDING` | Subject standing still |
| `LAYING` | Subject lying down |

---

### Measurement Columns (66 variables, all prefixed `Avg_`)

All values are **normalised to the range [−1, 1]** and represent the **mean over all observations** for a given subject–activity combination.

#### Time Domain – Body Accelerometer

| Column | Axis | Statistic |
|--------|------|-----------|
| `Avg_TimeDomain_BodyAccelerometer_Mean_X` | X | Mean |
| `Avg_TimeDomain_BodyAccelerometer_Mean_Y` | Y | Mean |
| `Avg_TimeDomain_BodyAccelerometer_Mean_Z` | Z | Mean |
| `Avg_TimeDomain_BodyAccelerometer_StdDev_X` | X | Std Dev |
| `Avg_TimeDomain_BodyAccelerometer_StdDev_Y` | Y | Std Dev |
| `Avg_TimeDomain_BodyAccelerometer_StdDev_Z` | Z | Std Dev |

#### Time Domain – Gravity Accelerometer

| Column | Axis | Statistic |
|--------|------|-----------|
| `Avg_TimeDomain_GravityAccelerometer_Mean_X` | X | Mean |
| `Avg_TimeDomain_GravityAccelerometer_Mean_Y` | Y | Mean |
| `Avg_TimeDomain_GravityAccelerometer_Mean_Z` | Z | Mean |
| `Avg_TimeDomain_GravityAccelerometer_StdDev_X` | X | Std Dev |
| `Avg_TimeDomain_GravityAccelerometer_StdDev_Y` | Y | Std Dev |
| `Avg_TimeDomain_GravityAccelerometer_StdDev_Z` | Z | Std Dev |

#### Time Domain – Body Accelerometer Jerk

| Column | Axis | Statistic |
|--------|------|-----------|
| `Avg_TimeDomain_BodyAccelerometerJerk_Mean_X` | X | Mean |
| `Avg_TimeDomain_BodyAccelerometerJerk_Mean_Y` | Y | Mean |
| `Avg_TimeDomain_BodyAccelerometerJerk_Mean_Z` | Z | Mean |
| `Avg_TimeDomain_BodyAccelerometerJerk_StdDev_X` | X | Std Dev |
| `Avg_TimeDomain_BodyAccelerometerJerk_StdDev_Y` | Y | Std Dev |
| `Avg_TimeDomain_BodyAccelerometerJerk_StdDev_Z` | Z | Std Dev |

#### Time Domain – Body Gyroscope

| Column | Axis | Statistic |
|--------|------|-----------|
| `Avg_TimeDomain_BodyGyroscope_Mean_X` | X | Mean |
| `Avg_TimeDomain_BodyGyroscope_Mean_Y` | Y | Mean |
| `Avg_TimeDomain_BodyGyroscope_Mean_Z` | Z | Mean |
| `Avg_TimeDomain_BodyGyroscope_StdDev_X` | X | Std Dev |
| `Avg_TimeDomain_BodyGyroscope_StdDev_Y` | Y | Std Dev |
| `Avg_TimeDomain_BodyGyroscope_StdDev_Z` | Z | Std Dev |

#### Time Domain – Body Gyroscope Jerk

| Column | Axis | Statistic |
|--------|------|-----------|
| `Avg_TimeDomain_BodyGyroscopeJerk_Mean_X` | X | Mean |
| `Avg_TimeDomain_BodyGyroscopeJerk_Mean_Y` | Y | Mean |
| `Avg_TimeDomain_BodyGyroscopeJerk_Mean_Z` | Z | Mean |
| `Avg_TimeDomain_BodyGyroscopeJerk_StdDev_X` | X | Std Dev |
| `Avg_TimeDomain_BodyGyroscopeJerk_StdDev_Y` | Y | Std Dev |
| `Avg_TimeDomain_BodyGyroscopeJerk_StdDev_Z` | Z | Std Dev |

#### Time Domain – Magnitudes

| Column | Statistic |
|--------|-----------|
| `Avg_TimeDomain_BodyAccelerometerMagnitude_Mean` | Mean |
| `Avg_TimeDomain_BodyAccelerometerMagnitude_StdDev` | Std Dev |
| `Avg_TimeDomain_GravityAccelerometerMagnitude_Mean` | Mean |
| `Avg_TimeDomain_GravityAccelerometerMagnitude_StdDev` | Std Dev |
| `Avg_TimeDomain_BodyAccelerometerJerkMagnitude_Mean` | Mean |
| `Avg_TimeDomain_BodyAccelerometerJerkMagnitude_StdDev` | Std Dev |
| `Avg_TimeDomain_BodyGyroscopeMagnitude_Mean` | Mean |
| `Avg_TimeDomain_BodyGyroscopeMagnitude_StdDev` | Std Dev |
| `Avg_TimeDomain_BodyGyroscopeJerkMagnitude_Mean` | Mean |
| `Avg_TimeDomain_BodyGyroscopeJerkMagnitude_StdDev` | Std Dev |

#### Frequency Domain – Body Accelerometer

| Column | Axis | Statistic |
|--------|------|-----------|
| `Avg_FrequencyDomain_BodyAccelerometer_Mean_X` | X | Mean |
| `Avg_FrequencyDomain_BodyAccelerometer_Mean_Y` | Y | Mean |
| `Avg_FrequencyDomain_BodyAccelerometer_Mean_Z` | Z | Mean |
| `Avg_FrequencyDomain_BodyAccelerometer_StdDev_X` | X | Std Dev |
| `Avg_FrequencyDomain_BodyAccelerometer_StdDev_Y` | Y | Std Dev |
| `Avg_FrequencyDomain_BodyAccelerometer_StdDev_Z` | Z | Std Dev |

#### Frequency Domain – Body Accelerometer Jerk

| Column | Axis | Statistic |
|--------|------|-----------|
| `Avg_FrequencyDomain_BodyAccelerometerJerk_Mean_X` | X | Mean |
| `Avg_FrequencyDomain_BodyAccelerometerJerk_Mean_Y` | Y | Mean |
| `Avg_FrequencyDomain_BodyAccelerometerJerk_Mean_Z` | Z | Mean |
| `Avg_FrequencyDomain_BodyAccelerometerJerk_StdDev_X` | X | Std Dev |
| `Avg_FrequencyDomain_BodyAccelerometerJerk_StdDev_Y` | Y | Std Dev |
| `Avg_FrequencyDomain_BodyAccelerometerJerk_StdDev_Z` | Z | Std Dev |

#### Frequency Domain – Body Gyroscope

| Column | Axis | Statistic |
|--------|------|-----------|
| `Avg_FrequencyDomain_BodyGyroscope_Mean_X` | X | Mean |
| `Avg_FrequencyDomain_BodyGyroscope_Mean_Y` | Y | Mean |
| `Avg_FrequencyDomain_BodyGyroscope_Mean_Z` | Z | Mean |
| `Avg_FrequencyDomain_BodyGyroscope_StdDev_X` | X | Std Dev |
| `Avg_FrequencyDomain_BodyGyroscope_StdDev_Y` | Y | Std Dev |
| `Avg_FrequencyDomain_BodyGyroscope_StdDev_Z` | Z | Std Dev |

#### Frequency Domain – Magnitudes

| Column | Statistic |
|--------|-----------|
| `Avg_FrequencyDomain_BodyAccelerometerMagnitude_Mean` | Mean |
| `Avg_FrequencyDomain_BodyAccelerometerMagnitude_StdDev` | Std Dev |
| `Avg_FrequencyDomain_BodyAccelerometerJerkMagnitude_Mean` | Mean |
| `Avg_FrequencyDomain_BodyAccelerometerJerkMagnitude_StdDev` | Std Dev |
| `Avg_FrequencyDomain_BodyGyroscopeMagnitude_Mean` | Mean |
| `Avg_FrequencyDomain_BodyGyroscopeMagnitude_StdDev` | Std Dev |
| `Avg_FrequencyDomain_BodyGyroscopeJerkMagnitude_Mean` | Mean |
| `Avg_FrequencyDomain_BodyGyroscopeJerkMagnitude_StdDev` | Std Dev |

---

## Notes

- **Units**: All measurement values are normalised and bounded within [−1, 1]; they are dimensionless.
- **`BodyBody` correction**: Three frequency-domain features in the original data had the erroneous prefix `fBodyBody`; this was corrected to `fBody` (→ `FrequencyDomain_Body`) during renaming.
- **Excluded features**: `meanFreq()` columns and angle-vector means were intentionally excluded as they are not direct mean/std estimates of a measurement signal.
- **Tidy data principles**: Each row is one observation (one subject × one activity); each column is one variable; the file contains a single observational unit.
