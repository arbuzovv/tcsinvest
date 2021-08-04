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
getHistoricalData = function(token = '',figi='',from=Sys.Date()-2,to=Sys.Date(),interval='hour',sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),
                        'market/candles?figi=',figi,
                        '&from=',from,'T21%3A00%3A00%2B03%3A00',
                        '&to=',to,'T21%3A00%3A00%2B03%3A00',
                        '&interval=',interval), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    data_result = rbindlist(data_tmp$payload$candles)
    return(data_result)
  }
  if(etfs$status_code!=200)
    return(structure('error in connection to tinkoff server', class = "try-error"))
}
