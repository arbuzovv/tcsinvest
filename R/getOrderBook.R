#' @title Download current OrderBook snapshot
#'
#' @description Makes a request to the server, and returns an data.table object with information about orderbook for selected instrument if successful.
#'
#' @param token token from Tinkoff account
#' @param live live trading - TRUE or sandbox (paper) trading - FALSE (default)
#' @param figi internal tinkoff code for instrument
#' @param depth depth of orderbook, number of bids and asks
#' @param verbose display status of retrieval (default FALSE)
#' @details  As described by the official Tinkoff Investments documentation
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{getHistoricalData}}
#' @examples
#' token = 'your_sandbox_token_from_tcs_account'
#' getOrderBook(token,figi = 'BBG005HLTYH9',depth = 5)
#' @export

getOrderBook = function(token = '', live = FALSE, figi = '', depth = NULL, verbose = FALSE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(live == FALSE,'sandbox/',''),'market/orderbook?figi=',figi,'&depth=',depth), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    data_bids = rbindlist(data_tmp$payload$bids,fill=TRUE)
    data_asks = rbindlist(data_tmp$payload$asks,fill=TRUE)
    data_asks$quantity = -data_asks$quantity
    data_result = rbind(data_asks,data_bids)
    data_result = data_result[order(data_result[,1],decreasing = TRUE)]
    return(data_result)
  }
  if(raw_data$status_code!=200)
    if(verbose) return(content(raw_data, as = "parsed"))
}
