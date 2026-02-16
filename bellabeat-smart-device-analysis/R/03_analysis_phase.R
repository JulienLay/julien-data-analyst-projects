# =====================================================
# ANALYSIS PHASE
# Behavioral Insights & Patterns Exploration
# =====================================================

# -----------------------------
# 1. Libraries & Data Loading
# -----------------------------
library(tidyverse)

data <- read_csv("../data/processed/final_dataset_prepared.csv")

# -----------------------------
# 2. Activity Patterns Analysis
# -----------------------------

# Average steps by weekday
avg_steps_weekday <- data %>%
  group_by(weekday) %>%
  summarise(mean_steps = mean(TotalSteps, na.rm = TRUE)) %>%
  arrange(match(weekday, c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")))

write.csv(avg_steps_weekday, "../data/processed/output/avg_steps_weekday.csv", row.names = FALSE)

# Average active minutes by weekday
avg_active_weekday <- data %>%
  group_by(weekday) %>%
  summarise(mean_active_minutes = mean(total_active_minutes, na.rm = TRUE)) %>%
  arrange(match(weekday, c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")))

write.csv(avg_active_weekday, "../data/processed/output/avg_active_weekday.csv", row.names = FALSE)

# -----------------------------
# 3. Sleep Patterns Analysis
# -----------------------------

# Average sleep by weekday
avg_sleep_weekday <- data %>%
  group_by(weekday) %>%
  summarise(mean_sleep_minutes = mean(TotalMinutesAsleep, na.rm = TRUE)) %>%
  arrange(match(weekday, c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")))

write.csv(avg_sleep_weekday, "../data/processed/output/avg_sleep_weekday.csv", row.names = FALSE)

# Sleep vs activity correlation per user
user_corr <- data %>%
  group_by(Id) %>%
  summarise(
    cor_steps_sleep = if(sum(!is.na(TotalSteps) & !is.na(TotalMinutesAsleep)) > 1) {
      cor(TotalSteps, TotalMinutesAsleep, use = "complete.obs")
    } else {
      NA_real_
    }
  )

write.csv(user_corr, "../data/processed/output/user_corr_steps_sleep.csv", row.names = FALSE)

# -----------------------------
# 4. Behavioral Segmentation
# -----------------------------

# Cluster users based on activity & sleep
library(stats)

segmentation_vars <- data %>%
  group_by(Id) %>%
  summarise(
    avg_steps = mean(TotalSteps, na.rm = TRUE),
    avg_sleep = mean(TotalMinutesAsleep, na.rm = TRUE),
    avg_sedentary = mean(sedentary_ratio, na.rm = TRUE)
  )

# Scale variables
segmentation_vars_clean <- segmentation_vars %>%
  filter(!is.na(avg_steps) & !is.na(avg_sleep) & !is.na(avg_sedentary))

seg_scaled <- scale(segmentation_vars_clean[, -1])

# K-means clustering
set.seed(123)
k_clusters <- kmeans(seg_scaled, centers = 3)
segmentation_vars_clean$cluster <- k_clusters$cluster

write.csv(segmentation_vars_clean, "../data/processed/output/user_segmentation.csv", row.names = FALSE)

# -----------------------------
# 5. Optional Visualizations
# -----------------------------

# Average steps by weekday plot
p_steps_weekday <- ggplot(avg_steps_weekday, aes(x = weekday, y = mean_steps)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  ggtitle("Average Steps by Weekday") +
  xlab("Weekday") +
  ylab("Average Steps")
ggsave("../data/processed/output/avg_steps_weekday.png", plot = p_steps_weekday, width = 12, height = 7.5)

# Average sleep by weekday plot
p_sleep_weekday <- ggplot(avg_sleep_weekday, aes(x = weekday, y = mean_sleep_minutes)) +
  geom_bar(stat = "identity", fill = "darkgreen") +
  ggtitle("Average Sleep Minutes by Weekday") +
  xlab("Weekday") +
  ylab("Average Sleep (minutes)")
ggsave("../data/processed/output/avg_sleep_weekday.png", plot = p_sleep_weekday, width = 12, height = 7.5)

# Clusters visualization
p_clusters <- ggplot(segmentation_vars_clean, aes(x = avg_steps, y = avg_sleep, color = factor(cluster))) +
  geom_point(size = 3) +
  ggtitle("User Segmentation: Steps vs Sleep") +
  xlab("Average Steps") +
  ylab("Average Sleep (minutes)") +
  scale_color_discrete(name = "Cluster")
ggsave("../data/processed/output/user_clusters.png", plot = p_clusters, width = 12, height = 7.5)