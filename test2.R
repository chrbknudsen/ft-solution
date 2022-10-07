source("read_data.R", encoding = "UTF-8")


datoer <- as_date(as_date(min(samlinger$periode_startdato)):as_date(max(samlinger$periode_slutdato)))


antal <- function(testdato){
mfere %>% 
  filter(testdato %within% mf_interval) %>% 
  filter(rolleid == 15) %>% 
  distinct(person_id, .keep_all = T) %>% 
  nrow()
}

data_til_max <- mfere %>% 
  filter(as_date("1972-12-29") %within% mf_interval) %>% 
  filter(rolleid == 15) %>% 
  distinct(person_id, .keep_all = T) %>% 
  mutate(personen = map(person_id, person_data))

write_rds(data_til_max, file = "180_data.rda")

data_til_max %>% 
  select(personen) %>% 
  unnest(personen)

testdato <- sample(datoer, 1)
testdato


antal(testdato)


stor_test <- datoer %>% 
  enframe() %>% 
  mutate(antal = map(value, antal))
  
stor_test %>% 
  unnest(antal) %>% 
  count(antal) %>% 
  arrange(desc(antal))

stor_test %>% 
  unnest(antal) %>% 
  filter(antal == 180) %>% 
  sample_n(1)
  

test_interval <- samlinger %>% 
  arrange(periode_startdato) %>% 
  slice(1) %>% 
  pull(periode_interval)

samlinger %>% 
  arrange(periode_startdato) %>% 
  view

as_date("1953-10-06") %within% test_interval

