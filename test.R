library(lubridate)
library(ODataQuery)
library(tidyverse)
library(jsonlite)
source("funktioner.R", encoding="UTF-8")
source("ft_medlemmer.R", encoding = "UTF-8")
source("person_data.R", encoding = "UTF-8")
source("partier_pr_samling.R")
samling <- samlings_data() %>% 
  filter(periodeid == 32)


mf <- ft_medlemmer3(samling$samling_id)

mf <- mf %>% mutate(startdato = as_date(startdato),
               slutdato = as_date(slutdato)) %>%
  mutate(mf_startdato = if_else(is.na(startdato), as_date(samling$periode_startdato), startdato),
         mf_slutdato = if_else(is.na(slutdato), as_date(samling$periode_slutdato), slutdato)
  ) %>%
  mutate(mf_periode = interval(start = mf_startdato, end = mf_slutdato)) %>%
  select(-c(startdato, slutdato, opdateringsdato, tilaktørid)) %>% 
  distinct(person_id, mf_periode, .keep_all = T) 

partier <- partier_per_samling(samling$periodeid)

gruppe_medlemsskab <- partier %>% 
  mutate(medlem = map(id, partier_medlemsskab ))

gruppe_medlemsskab  %>% 
  select(-c(typeid, gruppenavnkort, fornavn, efternavn, biografi, periodeid,
            opdateringsdato)) %>% 
  rename(samling_startdato = startdato,
         samling_slutdato  = slutdato,
         parti_id = id,
         parti_navn = navn) %>% 
  unnest(medlem) %>% 
  select(-c(id, tilaktørid, opdateringsdato)) %>% 
  rename(person_id = fraaktørid) %>% 
  mutate(slutdato = if_else(is.na(slutdato), samling_slutdato, slutdato)) %>%
  mutate(gruppe_startdato = as_date(startdato),
         gruppe_slutdato = as_date(slutdato),
         gruppe_interval = interval(start = gruppe_startdato, end = gruppe_slutdato)) %>% 
  select(-c(startdato, slutdato))
  
