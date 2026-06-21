##############################################################################
# run_analysis.R
# Getting and Cleaning Data – Course Project
#
# Steps performed:
#   1. Merge training and test sets into one dataset
#   2. Extract mean() and std() measurements only
#   3. Apply descriptive activity names
#   4. Label dataset with descriptive variable names
#   5. Create a second tidy dataset: average per subject per activity
#
# Pre-requisite: Place "UCI HAR Dataset/" in your working directory.
##############################################################################

library(dplyr)

# ── Path helper ──────────────────────────────────────────────────────────────
data_path <- function(...) file.path("UCI HAR Dataset", ...)

##############################################################################
# STEP 0 – Load reference tables
##############################################################################
features <- read.table(data_path("features.txt"),
                       col.names = c("index", "feature_name"),
                       stringsAsFactors = FALSE)

activity_labels <- read.table(data_path("activity_labels.txt"),
                              col.names = c("activity_id", "activity"),
                              stringsAsFactors = FALSE)

# Make feature names unique (84 duplicate bandsEnergy names in source data)
feature_names <- make.unique(features$feature_name)

##############################################################################
# STEP 1 – Merge training and test sets
##############################################################################
load_split <- function(split) {
  X    <- read.table(data_path(split, paste0("X_", split, ".txt")),
                     col.names = feature_names)
  y    <- read.table(data_path(split, paste0("y_", split, ".txt")),
                     col.names = "activity_id")
  subj <- read.table(data_path(split, paste0("subject_", split, ".txt")),
                     col.names = "subject_id")
  cbind(subj, y, X)
}

merged <- rbind(load_split("train"), load_split("test"))
message("Step 1 – Merged: ", nrow(merged), " rows x ", ncol(merged), " cols")

##############################################################################
# STEP 2 – Extract mean() and std() features
##############################################################################
# Using original (pre-make.unique) names to find mean()/std() columns
mean_std_idx <- grep("mean\\(\\)|std\\(\\)", features$feature_name)
keep_cols    <- c("subject_id", "activity_id",
                  make.unique(features$feature_name)[mean_std_idx])

extracted <- merged[, keep_cols]
message("Step 2 – Extracted ", length(mean_std_idx), " mean/std features")

##############################################################################
# STEP 3 – Descriptive activity names
##############################################################################
extracted <- merge(extracted, activity_labels, by = "activity_id", all.x = TRUE)
extracted$activity_id <- NULL           # drop the numeric id
message("Step 3 – Activity names applied")

##############################################################################
# STEP 4 – Descriptive variable names
##############################################################################
rename_features <- function(x) {
  x <- sub("^t",        "TimeDomain_",        x)
  x <- sub("^f",        "FrequencyDomain_",   x)
  x <- gsub("BodyBody", "Body",               x)
  x <- gsub("Acc",      "Accelerometer",      x)
  x <- gsub("Gyro",     "Gyroscope",          x)
  x <- gsub("Mag",      "Magnitude",          x)
  x <- gsub("\\.mean\\.\\.", "_Mean_",         x)
  x <- gsub("\\.mean$",     "_Mean",           x)
  x <- gsub("\\.std\\.\\.", "_StdDev_",        x)
  x <- gsub("\\.std$",      "_StdDev",         x)
  x <- gsub("_+$",          "",                x)   # trailing underscores
  x <- gsub("\\.+",         "_",               x)   # remaining dots → _
  x
}

names(extracted) <- rename_features(names(extracted))
message("Step 4 – Variable names made descriptive")
message("  Example: ", names(extracted)[3])

##############################################################################
# STEP 5 – Tidy summary: average per subject per activity
##############################################################################
tidy <- extracted %>%
  group_by(subject_id, activity) %>%
  summarise(across(where(is.numeric), mean, .names = "Avg_{.col}"),
            .groups = "drop") %>%
  arrange(subject_id, activity)

write.table(tidy, file = "tidy_data.txt", row.names = FALSE, quote = FALSE)

message("Step 5 – tidy_data.txt written: ",
        nrow(tidy), " rows x ", ncol(tidy), " cols")
message("\nDone!  Read back with:")
message('  tidy <- read.table("tidy_data.txt", header = TRUE)')
