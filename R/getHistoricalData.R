#' @title Download Historical Bar Data
#'
#' @description Makes a request to the server, and returns an data.table object with information about prices of instrument if successful.
#'
#' @param token token from Tinkoff account
#' @param figi internal tinkoff code for instrument
#' @param from from what date download history
#' @param to to what date download history
#' @param interval timeframe of bars
#' @param sandbox paper (TRUE) or live (FALSE) trading
#' @details  As described by the official Tinkoff Investments documentation
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{getOrderBook}}
#' @examples
#' token = 'your_token_from_tcs_account'
#' getHistoricalData(token,figi = 'BBG005HLTYH9')
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
  if(raw_data$status_code!=200)
    return(structure('error in connection to tinkoff server', class = "try-error"))
}
