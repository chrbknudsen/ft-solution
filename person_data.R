person_data <- function(personid){
  samlinger <- ODataQuery$new("https://oda.ft.dk/api")
  samlinger <- samlinger$path("Aktør")
  samlinger <- samlinger$filter(id.eq = personid)
  samlinger$get()
  samlinger$url
  samlinger$retrieve()$value %>%
    as_tibble()
}


person_data(19576) %>% pull(navn)
