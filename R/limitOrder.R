#' @title Place limit order
#'
#' @description this function will place your order in to account.
#'
#' @param token token from Tinkoff account
#' @param live live trading - TRUE or sandbox (paper) trading - FALSE (default)
#' @param figi internal tinkoff code for instrument
#' @param direction "Buy" or "Sell"
#' @param lots number of lots to buy
#' @param price price of limit order
#' @details  As described by the official Tinkoff Investments documentation. If you want live trading, use sandbox=FALSE with live token
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{marketOrder}}
#' @examples
#' paper_token = 'your_sandbox_token_from_tcs_account'
#' limitOrder(paper_token,figi='BBG005HLTYH9',direction='Buy',lots=1,price=100)
#'
#' live_token = 'your_live_token_from_tcs_account'
#' # remember that this command will place limit order in your live account !
#' limitOrder(live_token,live=TRUE,figi='BBG005HLTYH9',direction='Buy',lots=1,price=100)
#' @export

limitOrder = function(token = '', live = FALSE, figi = '', direction = NULL, lots = NULL, price = NULL)
{
  headers = add_headers("accept" = "application/json","Authorization" = paste("Bearer",token),"Content-Type" = "application/json")
  data = paste0('{\"lots\":',lots,',\"operation\":\"',direction,'\",\"price\":',price,'}')
  url = paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(live == FALSE,'sandbox/',''),'orders/limit-order?figi=',figi)
  raw_data = POST(url, headers,body = data)
  return(content(raw_data, as = "parsed"))
}
