library(jsonlite)
library(ODataQuery)
library(tibble)
library(dplyr)
library(lubridate)
# Nyttig metadata:
aktøraktørrolle <- fromJSON("https://oda.ft.dk/api/Akt%C3%B8rAkt%C3%B8rRolle?$inlinecount=allpages")
aktørtyper <- fromJSON("https://oda.ft.dk/api/Akt%C3%B8rtype?$inlinecount=allpages")

# Henter data på folketingssamlinger. Bør gøres robust overfor >100 samlinger
# Meget af den efterfølgende databehandling hører nok også hjemme her
samlings_data <- function(){
  samlinger <- ODataQuery$new("https://oda.ft.dk/api")
  samlinger <- samlinger$path("Aktør")
  samlinger <- samlinger$filter(typeid.eq = 11)
  samlinger$get()
  samlinger$url
  samlinger$retrieve()$value %>%
    as_tibble() %>% 
    filter(navn == "Folketinget") %>% 
    mutate(periode_startdato = as_date(startdato) + hours(12),
           periode_slutdato  = as_date(slutdato) + hours(11) + minutes(59),
           periode_interval = interval(start = periode_startdato,
                                       end = periode_slutdato)) %>% 
    rename(samling_id = id) %>% 
    select(samling_id, periodeid, periode_startdato, periode_slutdato, periode_interval)
}

# vi sætter starten af samlingen til kl 12. det får vi ikke fra ODA. men det er 
# der samlingen starter jf grundloven
# slut af samlingen sætter vi så til kl. 11.59. Det får vi heller ikke fra oda
