# =====================================================
# Bellabeat Smart Device Usage Analysis
# Step 1 - Data Inspection & Initial Cleaning
# =====================================================

# -----------------------------
# 0. Load libraries
# -----------------------------
library(tidyverse)

# -----------------------------
# 1. Data Import
# -----------------------------
daily_1 <- read_csv("Fitabase Data 3.12.16-4.11.16/dailyActivity_merged.csv")
daily_2 <- read_csv("Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv")
sleep   <- read_csv("Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv")

# -----------------------------
# 2. Merge Activity Datasets
# -----------------------------
daily_activity <- bind_rows(daily_1, daily_2)

# -----------------------------
# 3. Date Formatting
# -----------------------------
daily_activity <- daily_activity %>%
  mutate(ActivityDate = as.Date(ActivityDate, format = "%m/%d/%Y"))

sleep <- sleep %>%
  mutate(
    SleepDay = as.POSIXct(SleepDay, format = "%m/%d/%Y %I:%M:%S %p"),
    SleepDate = as.Date(SleepDay)
  )

# -----------------------------
# 4. Initial Inspection
# -----------------------------
activity_rows <- nrow(daily_activity)
sleep_rows    <- nrow(sleep)

activity_users <- n_distinct(daily_activity$Id)
sleep_users    <- n_distinct(sleep$Id)

activity_start <- min(daily_activity$ActivityDate)
activity_end   <- max(daily_activity$ActivityDate)

sleep_start <- min(sleep$SleepDate)
sleep_end   <- max(sleep$SleepDate)

activity_duplicates <- sum(duplicated(daily_activity))
sleep_duplicates    <- sum(duplicated(sleep))

users_without_sleep <- setdiff(unique(daily_activity$Id), unique(sleep$Id))
num_users_without_sleep <- length(users_without_sleep)

cat("Activity rows:", activity_rows, "\n")
cat("Sleep rows:", sleep_rows, "\n")
cat("Activity users:", activity_users, "\n")
cat("Sleep users:", sleep_users, "\n")
cat("Activity period:", activity_start, "to", activity_end, "\n")
cat("Sleep period:", sleep_start, "to", sleep_end, "\n")
cat("Activity duplicates:", activity_duplicates, "\n")
cat("Sleep duplicates:", sleep_duplicates, "\n")
cat("Users without sleep data:", num_users_without_sleep, "\n")

# -----------------------------
# 5. Remove Exact Sleep Duplicates
# -----------------------------
sleep <- sleep %>%
  distinct()

# -----------------------------
# 6. Aggregate Sleep by User & Date (Fix Granularity)
# -----------------------------
sleep_clean <- sleep %>%
  group_by(Id, SleepDate) %>%
  summarise(
    TotalSleepRecords   = sum(TotalSleepRecords),
    TotalMinutesAsleep  = sum(TotalMinutesAsleep),
    TotalTimeInBed      = sum(TotalTimeInBed),
    .groups = "drop"
  )

# -----------------------------
# 7. Restrict to Common Period
# -----------------------------
common_start <- sleep_start
common_end   <- sleep_end

daily_activity_common <- daily_activity %>%
  filter(ActivityDate >= common_start &
           ActivityDate <= common_end)

common_rows  <- nrow(daily_activity_common)
common_users <- n_distinct(daily_activity_common$Id)

cat("Common period rows:", common_rows, "\n")
cat("Common period users:", common_users, "\n")

# -----------------------------
# 8. Feature Engineering
# -----------------------------
daily_activity_common <- daily_activity_common %>%
  mutate(
    total_active_minutes = VeryActiveMinutes +
      FairlyActiveMinutes +
      LightlyActiveMinutes,
    
    sedentary_ratio = SedentaryMinutes /
      (total_active_minutes + SedentaryMinutes),
    
    activity_level = case_when(
      TotalSteps < 5000  ~ "Low",
      TotalSteps < 10000 ~ "Moderate",
      TRUE               ~ "High"
    ),
    
    weekday = weekdays(ActivityDate),
    
    is_weekend = if_else(
      weekday %in% c("Saturday", "Sunday"),
      "Weekend",
      "Weekday"
    )
  )

# -----------------------------
# 9. Merge Activity & Sleep (Corrected)
# -----------------------------
final_dataset <- daily_activity_common %>%
  left_join(
    sleep_clean,
    by = c("Id" = "Id", "ActivityDate" = "SleepDate")
  )

# -----------------------------
# 10. Post-Merge Validation
# -----------------------------
cat("Final rows:", nrow(final_dataset), "\n")
cat("Missing sleep values:",
    sum(is.na(final_dataset$TotalMinutesAsleep)), "\n")
cat("Distinct users:",
    n_distinct(final_dataset$Id), "\n")

# =====================================================
# 11. Feature Engineering - Sleep
# =====================================================

final_dataset <- final_dataset %>%
  mutate(
    # Sleep efficiency : ratio sommeil effectif / temps au lit
    sleep_efficiency = if_else(TotalTimeInBed > 0,
                               TotalMinutesAsleep / TotalTimeInBed,
                               NA_real_),
    
    # Categorisation du sommeil
    sleep_level = case_when(
      TotalMinutesAsleep < 360 ~ "Low",        # <6h
      TotalMinutesAsleep < 480 ~ "Moderate",   # 6-8h
      TotalMinutesAsleep >= 480 ~ "High",      # >8h
      TRUE ~ NA_character_
    )
  )

# Vérification rapide
summary(final_dataset$TotalMinutesAsleep)
summary(final_dataset$sleep_efficiency)
table(final_dataset$sleep_level, useNA = "ifany")

# =====================================================
# 12. Export prepared dataset
# =====================================================

write_csv(final_dataset, "final_dataset_prepared.csv")

cat("PREPARE phase complete. Dataset exported as 'final_dataset_prepared.csv'\n")