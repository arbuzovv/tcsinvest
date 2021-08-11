#' @title Download current quotes for instrument
#'
#' @description Makes a request to the server, and returns an data.table object with information about orderbook for selected instrument if successful.
#'
#' @param token token from Tinkoff account
#' @param live live trading - TRUE or sandbox (paper) trading - FALSE (default)
#' @param figi internal tinkoff code for instrument
#' @param verbose display status of retrieval (default FALSE)
#' @details  Information gets from orderbook function.
#' Also gets list of availible status of instrument: break_in_trading, normal_trading, not_available_for_trading, closing_auction, closing_period, discrete_auction, opening_period, trading_at_closing_auction_price
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @examples
#' live = FALSE
#' token = 'your_sandbox_token_from_tcs_account'
#' getQuotes(token,live,figi = 'BBG005HLTYH9')
#' @export

getQuotes = function(token = '', live = FALSE, figi='',  verbose = FALSE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(live == FALSE,'sandbox/',''),'market/orderbook?figi=',figi,'&depth=',1), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    data_result = rbindlist(list(data_tmp$payload[c(1,3:8)]))
    if(length(data_tmp$payload$bids)>0)
    {
      best_bid = rbindlist((data_tmp$payload$bids[1]))
      names(best_bid) = paste0('best_bid_',names(best_bid))
      data_result = cbind(data_result,best_bid)
    }
    if(length(data_tmp$payload$asks)>0)
    {
      best_ask = rbindlist((data_tmp$payload$asks[1]))
      names(best_ask) = paste0('best_ask_',names(best_ask))
      data_result = cbind(data_result,best_ask)
    }
    return(data_result)
  }
  if(raw_data$status_code!=200)
    if(verbose) return(content(raw_data, as = "parsed"))
}
