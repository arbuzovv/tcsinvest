#' @title Download current quotes for instrument
#'
#' @description Makes a request to the server, and returns an data.table object with information about orderbook for selected instrument if successful.
#'
#' @param token token from Tinkoff account
#' @param figi internal tinkoff code for instrument
#' @param sandbox paper (TRUE) or live (FALSE) trading
#' @details  Information gets from orderbook function
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @examples
#' token = 'your_token_from_tcs_account'
#' getQuotes(token,figi = 'BBG005HLTYH9')
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
  if(raw_data$status_code!=200)
    return(structure('error in connection to tinkoff server', class = "try-error"))
}
