#' @title tcsinvest
#'
#' @description function
#'
#' @param dataframe
#'
#' @return the valuet
#'
#' @examples
#' cancelOrder(token)
#' @export

getBonds = function(token = '',sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),'market/bonds'), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    data_result = rbindlist(data_tmp$payload$instruments,fill=TRUE)
    return(data_result)
  }
  if(etfs$status_code!=200)
    return(structure('error in connection to tinkoff server', class = "try-error"))
}
