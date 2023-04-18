###
### Name: group_BirdNET_output
### 
### Author: Sunny Tseng
### Date: 2022-10-18
### Output: a tidy dataframe with BirdNET output from single season
###


###
### Library
###
library(tidyverse)
library(purrr)
library(here)
library(janitor)


###
### Main function here
###

# list the files

data_folder <- "BirdNET_WAV_output"
file_list <- list.files(data_folder, pattern = ".csv$", recursive = TRUE)

# combine all the txt files
data_full <- tibble()
for(file in file_list){
  data <- read_csv(file = here(data_folder, file), 
                   col_type = list(`Start (s)` = col_double(),
                                   `End (s)` = col_double(),
                                   `Scientific name` = col_character(),
                                   `Common name` = col_character(),
                                   `Confidence` = col_double())) %>%
    mutate(recording = file)
  data_full <- bind_rows(data_full, data)
}

# wrangle the big dataset
data_full_format <- data_full %>%
  clean_names() %>%
  mutate(site = str_extract(recording, pattern = ".+(?=_2023)"),
         date = str_extract(recording, pattern = "(?<=_)\\d+(?=_)"), 
         time_hms = str_extract(recording, pattern = "(?<=_)\\d+(?=_output)")) %>%
  mutate(month = str_sub(date, start = 5, end = 6),
         day = str_sub(date, start = 7, end = 8))

data_full_format



