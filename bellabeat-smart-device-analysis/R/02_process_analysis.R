# =====================================================
# PROCESS PHASE
# Descriptive Statistics & Behavioral Analysis
# =====================================================

# -----------------------------
# 1. Libraries & Data Loading
# -----------------------------

library(tidyverse)

data <- read_csv("final_dataset_prepared.csv")


# -----------------------------
# 2. Global Descriptive Statistics
# -----------------------------

summary_stats <- data %>%
  summarise(
    mean_steps = mean(TotalSteps, na.rm = TRUE),
    median_steps = median(TotalSteps, na.rm = TRUE),
    sd_steps = sd(TotalSteps, na.rm = TRUE),
    
    mean_active = mean(total_active_minutes, na.rm = TRUE),
    mean_sedentary_ratio = mean(sedentary_ratio, na.rm = TRUE),
    
    mean_sleep = mean(TotalMinutesAsleep, na.rm = TRUE),
    mean_time_in_bed = mean(TotalTimeInBed, na.rm = TRUE),
    
    mean_calories = mean(Calories, na.rm = TRUE)
  )

print(summary_stats)


# -----------------------------
# 3. Distribution Analysis
# -----------------------------

# Steps distribution
ggplot(data, aes(x = TotalSteps)) +
  geom_histogram(bins = 30)

# Sleep duration distribution
ggplot(data, aes(x = TotalMinutesAsleep)) +
  geom_histogram(bins = 30)

# Sedentary ratio distribution
ggplot(data, aes(x = sedentary_ratio)) +
  geom_histogram(bins = 30)


# -----------------------------
# 4. Weekday vs Weekend Comparison
# -----------------------------

weekday_analysis <- data %>%
  group_by(is_weekend) %>%
  summarise(
    mean_steps = mean(TotalSteps, na.rm = TRUE),
    mean_sleep = mean(TotalMinutesAsleep, na.rm = TRUE),
    mean_sedentary = mean(sedentary_ratio, na.rm = TRUE)
  )

print(weekday_analysis)


# -----------------------------
# 5. Correlation Analysis
# -----------------------------

cor_steps_calories <- cor(data$TotalSteps, data$Calories, use = "complete.obs")
cor_steps_sleep <- cor(data$TotalSteps, data$TotalMinutesAsleep, use = "complete.obs")
cor_sedentary_sleep <- cor(data$sedentary_ratio, data$TotalMinutesAsleep, use = "complete.obs")
cor_active_calories <- cor(data$total_active_minutes, data$Calories, use = "complete.obs")

cor_steps_calories
cor_steps_sleep
cor_sedentary_sleep
cor_active_calories


# -----------------------------
# 6. Segmentation by Activity Level
# -----------------------------

segment_analysis <- data %>%
  group_by(activity_level) %>%
  summarise(
    mean_sleep = mean(TotalMinutesAsleep, na.rm = TRUE),
    mean_calories = mean(Calories, na.rm = TRUE),
    mean_sedentary = mean(sedentary_ratio, na.rm = TRUE),
    count = n()
  )

print(segment_analysis)

# -----------------------------
# 7. Statistical Validation
# -----------------------------

# 7.1 ANOVA — Sleep by Activity Level
anova_sleep <- aov(TotalMinutesAsleep ~ activity_level, data = data)
anova_results <- summary(anova_sleep)

# 7.2 T-tests — Weekday vs Weekend
t_test_steps <- t.test(TotalSteps ~ is_weekend, data = data)
t_test_sleep <- t.test(TotalMinutesAsleep ~ is_weekend, data = data)

# 7.3 Correlation Significance — Steps vs Sleep
cor_test_steps_sleep <- cor.test(
  data$TotalSteps,
  data$TotalMinutesAsleep,
  use = "complete.obs"
)

# 7.4 Segmentation by Quartiles (More Robust)
data <- data %>%
  mutate(
    steps_quartile = ntile(TotalSteps, 4)
  )

quartile_analysis <- data %>%
  group_by(steps_quartile) %>%
  summarise(
    mean_sleep = mean(TotalMinutesAsleep, na.rm = TRUE),
    mean_calories = mean(Calories, na.rm = TRUE),
    mean_sedentary = mean(sedentary_ratio, na.rm = TRUE),
    count = n(),
    .groups = "drop"
  )

# Print results
anova_results
t_test_steps
t_test_sleep
cor_test_steps_sleep
quartile_analysis

# -----------------------------
# 8. Multiple Linear Regression
# -----------------------------

# 8.1 Explanatory model of sleep
model_sleep <- lm(
  TotalMinutesAsleep ~ TotalSteps + sedentary_ratio + Calories,
  data = data
)

summary(model_sleep)

# ==============================
# 8.2 Multicollinearity Check (Manual VIF)
# ==============================

# Select numeric explanatory variables
vars <- data %>% select(TotalSteps, total_active_minutes, sedentary_ratio, Calories)

# Function to calculate VIF manually without any package
vif_manual <- function(df){
  vifs <- sapply(names(df), function(var){
    f <- as.formula(paste(var, "~", paste(setdiff(names(df), var), collapse = "+")))
    r2 <- summary(lm(f, data=df))$r.squared
    1 / (1 - r2)
  })
  return(vifs)
}

# Calculate VIF values
vif_values <- vif_manual(vars)
print(vif_values)

# 8.3 Calorie-free alternative model
model_sleep_alt <- lm(
  TotalMinutesAsleep ~ TotalSteps + sedentary_ratio,
  data = data
)

summary(model_sleep_alt)

# -----------------------------
# 9. Export summary & results
# -----------------------------

# Create output folder if it doesn't exist
if(!dir.exists("../data/processed/output")) dir.create("../data/processed/output")

# Save descriptive stats
write.csv(summary_stats, "../data/processed/output/summary_stats.csv", row.names = FALSE)

# Save weekday vs weekend analysis
write.csv(weekday_analysis, "../data/processed/output/weekday_analysis.csv", row.names = FALSE)

# Save segmentation by activity level
write.csv(segment_analysis, "../data/processed/output/segment_analysis.csv", row.names = FALSE)

# Save quartile analysis
write.csv(quartile_analysis, "../data/processed/output/quartile_analysis.csv", row.names = FALSE)

# Save VIF values
write.csv(vif_values, "../data/processed/output/vif_values.csv", row.names = TRUE)

# Save model summaries as text
capture.output(summary(model_sleep), file = "../data/processed/output/model_sleep_summary.txt")
capture.output(summary(model_sleep_alt), file = "../data/processed/output/model_sleep_alt_summary.txt")
capture.output(anova_results, file = "../data/processed/output/anova_sleep_summary.txt")
capture.output(t_test_steps, file = "../data/processed/output/t_test_steps.txt")
capture.output(t_test_sleep, file = "../data/processed/output/t_test_sleep.txt")
capture.output(cor_test_steps_sleep, file = "../data/processed/output/cor_test_steps_sleep.txt")

# -----------------------------
# 10. Optional Visualizations
# -----------------------------

# Steps distribution histogram
p_steps <- ggplot(data, aes(x = TotalSteps)) +
  geom_histogram(bins = 30, fill = "steelblue") +
  ggtitle("Steps Distribution")
ggsave("../data/processed/output/steps_distribution.png", plot = p_steps, width = 12, height = 7.49)

# Sleep distribution histogram
p_sleep <- ggplot(data, aes(x = TotalMinutesAsleep)) +
  geom_histogram(bins = 30, fill = "darkgreen") +
  ggtitle("Sleep Duration Distribution")
ggsave("../data/processed/output/sleep_distribution.png", plot = p_sleep, width = 12, height = 7.49)

# Sedentary ratio distribution histogram
p_sedentary <- ggplot(data, aes(x = sedentary_ratio)) +
  geom_histogram(bins = 30, fill = "orange") +
  ggtitle("Sedentary Ratio Distribution")
ggsave("../data/processed/output/sedentary_ratio_distribution.png", plot = p_sedentary, width = 12, height = 7.49)