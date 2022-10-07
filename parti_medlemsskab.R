partier_medlemsskab <- function(partiid){
  res <- data.frame()
  partier <- ODataQuery$new("https://oda.ft.dk/api")
  partier <- partier$path("AktørAktør")
  partier <- partier$filter(tilaktørid.eq = partiid)
  url <- partier$url  %>% str_remove_all(., "\\)") %>%
    str_remove_all(., "\\(") %>%
    str_replace_all(., "%F8", "%C3%B8")
  
  while(!is.null(url)){
    tmp <- fromJSON(url)
    res <- rbind(res, tmp$value)
    url <- tmp$odata.nextLink
  }
  as_tibble(res)
}

