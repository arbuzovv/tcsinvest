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
getQuotes = function(token = '',figi='',sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),'market/orderbook?figi=',figi,'&depth=',2), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    data_result = data.table(data_tmp$payload$tradeStatus,data_tmp$payload$lastPrice,data_tmp$payload$closePrice,data_tmp$payload$limitUp,data_tmp$payload$limitDown,data_tmp$payload$minPriceIncrement)
    names(data_result) = c('tradeStatus','lastPrice','closePrice','limitUp','limitDown','minPriceIncrement')
    return(data_result)
  }
  if(etfs$status_code!=200)
    return(structure('error in connection to tinkoff server', class = "try-error"))
}
