source("funktioner.R", encoding = "UTF-8")
source("partier_pr_samling.R", encoding = "UTF-8")
source("ft_medlemmer.R", encoding = "UTF-8")
library(readr)
library(stringr)
library(purrr)
library(tidyr)

# Hent samlinger og gem dem
samlings_data() %>% 
  write_rds("data/samlings_data.rds")

# Hent partier og gem dem

read_rds("data/samlings_data.rds") %>% 
  mutate(parti = map(periodeid, partier_per_samling)) %>% 
  unnest(parti, names_repair = "universal") %>% 
  rename(periodeid = periodeid...2,
         partiid = id) %>% 
  select(-c(typeid, fornavn, efternavn, biografi, periodeid...13,
            opdateringsdato, startdato, slutdato)) %>% 
  write_rds("data/partier.rds")
  
read_rds("data/partier.rds")

# Hent folketingsmedlemmer (id) og gem dem

read_rds("data/samlings_data.rds") %>% 
  mutate(medlemmer = map(samling_id, ft_medlemmer3)) %>% 
  unnest(medlemmer) %>% 
  mutate(mf_startdato = as_date(startdato) + hours(12),
         mf_slutdato  = as_date(slutdato)+ hours(11) + minutes(59)) %>% 
  mutate(mf_startdato = if_else(is.na(mf_startdato), periode_startdato, mf_startdato),
         mf_slutdato  = if_else(is.na(mf_slutdato), periode_slutdato, mf_slutdato)) %>% 
  mutate(mf_interval = interval(start = mf_startdato, end = mf_slutdato)) %>% 
  select(-c(opdateringsdato, id, fraaktørid, tilaktørid, startdato, slutdato)) %>% 
  write_rds("data/mfere.rds")
  

# Hent parti-tilhør og gem dem

# Hent persondata og gem dem
read_rds("data/mfere.rds") %>% 
  distinct(person_id, rolleid) %>% 
  mutate(person = map(person_id, person_data)) %>% 
  unnest(person) %>% 
  select(-c(id, gruppenavnkort, biografi, periodeid, opdateringsdato, 
            startdato, slutdato, typeid)) %>% 
  write_rds("data/personer.rds")



