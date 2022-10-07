partier_per_samling <- function(periodeid){
  res <- data.frame()
  partier <- ODataQuery$new("https://oda.ft.dk/api")
  partier <- partier$path("Aktør")
  partier <- partier$filter(and_query(periodeid.eq = periodeid,
                                     typeid.eq = 4))
  url <- partier$url  
  while(!is.null(url)){
    tmp <- fromJSON(url)
    res <- rbind(res, tmp$value)
    url <- tmp$odata.nextLink
  }
  as_tibble(res)
}


