library(jsonlite)

# ft_medlemmer* trækker folketingsmedlemmer ud for et givet folketings id 
# NB det er forskelligt fra periodeide'et.
# ft_medlemmer1, trækker ud, hvor ftid er tilaktørid.
# ft_medlemmer2 trækker ud hvor ftid er fraaktørid
# ft_medlemmer3 trækker ud hvor ftid er både til og fra aktør.
# Den sidste bør laves med et or-kald i stedet for to kald.


ft_medlemmer1 <- function(ftid){
  res <- data.frame()
  samlinger <- ODataQuery$new("https://oda.ft.dk/api")
  samlinger <- samlinger$path("AktørAktør")
  samlinger <- samlinger$filter(tilaktørid.eq = ftid)
  
  url <- samlinger$url %>% str_remove_all(., "\\)") %>%
    str_remove_all(., "\\(") %>%
    str_replace_all(., "%F8", "%C3%B8")
  while(!is.null(url)){
    tmp <- fromJSON(url)
    res <- rbind(res, tmp$value)
    url <- tmp$odata.nextLink
  }
  as_tibble(res)
}



ft_medlemmer2 <- function(ftid){
  res <- data.frame()
  samlinger <- ODataQuery$new("https://oda.ft.dk/api")
  samlinger <- samlinger$path("AktørAktør")
  samlinger <- samlinger$filter(fraaktørid.eq = ftid)
  
  url <- samlinger$url %>% str_remove_all(., "\\)") %>%
    str_remove_all(., "\\(") %>%
    str_replace_all(., "%F8", "%C3%B8")
  while(!is.null(url)){
    tmp <- fromJSON(url)
    res <- rbind(res, tmp$value)
    url <- tmp$odata.nextLink
  }
  as_tibble(res)
}


ft_medlemmer3 <- function(ftid){
  res1 <- data.frame()
  samlinger <- ODataQuery$new("https://oda.ft.dk/api")
  samlinger <- samlinger$path("AktørAktør")
  samlinger <- samlinger$filter(tilaktørid.eq = ftid)
  
  url <- samlinger$url %>% str_remove_all(., "\\)") %>%
    str_remove_all(., "\\(") %>%
    str_replace_all(., "%F8", "%C3%B8")
  while(!is.null(url)){
    tmp <- fromJSON(url)
    res1 <- rbind(res1, tmp$value)
    url <- tmp$odata.nextLink
  }
  res1 <- as_tibble(res1)
  
  res2 <- data.frame()
  samlinger <- ODataQuery$new("https://oda.ft.dk/api")
  samlinger <- samlinger$path("AktørAktør")
  samlinger <- samlinger$filter(fraaktørid.eq = ftid)
  
  url <- samlinger$url %>% str_remove_all(., "\\)") %>%
    str_remove_all(., "\\(") %>%
    str_replace_all(., "%F8", "%C3%B8")
  while(!is.null(url)){
    tmp <- fromJSON(url)
    res2 <- rbind(res2, tmp$value)
    url <- tmp$odata.nextLink
  }
  res2 <- as_tibble(res2) %>% 
    {
      if("tilaktørid" %in% names(.)) mutate(., person_id = tilaktørid) else .
    }
  
  res1 <- as_tibble(res1) %>% 
    {
      if("fraaktørid" %in% names(.)) mutate(., person_id = fraaktørid) else .
    }
  
  rbind(res1,res2)   
  
}
