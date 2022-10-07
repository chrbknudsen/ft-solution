source("funktioner.R", encoding = "UTF-8")
source("partier_pr_samling.R", encoding = "UTF-8")
source("ft_medlemmer.R", encoding = "UTF-8")
library(readr)
library(stringr)
library(purrr)
library(tidyr)

# indlæs samlinger
samlinger <- read_rds("data/samlings_data.rds")

# Hent partier og gem dem
partier <- read_rds("data/partier.rds")


# Hent folketingsmedlemmer (id) og gem dem

mfere <- read_rds("data/mfere.rds")


# Hent parti-tilhør og gem dem

# Hent persondata og gem dem
personer <- read_rds("data/personer.rds")



