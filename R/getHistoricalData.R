#' @title Download Historical Bar Data
#'
#' @description Makes a request to the server, and returns an data.table object with information about prices of instrument if successful.
#'
#' @param token token from Tinkoff account
#' @param live live trading - TRUE or sandbox (paper) trading - FALSE (default)
#' @param figi internal tinkoff code for instrument
#' @param from from what date download history
#' @param to to what date download history
#' @param interval timeframe of bars
#' @param verbose display status of retrieval (default FALSE)
#' @details  As described by the official Tinkoff Investments documentation
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{getOrderBook}}
#' @examples
#' token = 'your_sandbox_token_from_tcs_account'
#' getHistoricalData(token,figi = 'BBG005HLTYH9')
#' @export

getHistoricalData = function(token = '', live = FALSE, figi = '', from = Sys.Date()-2, to = Sys.Date(), interval = 'hour', verbose = FALSE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(live == FALSE,'sandbox/',''),
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
    if(verbose) return(content(raw_data, as = "parsed"))
}
