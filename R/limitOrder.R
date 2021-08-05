#' @title Place limit order
#'
#' @description this function will place your order in to account.
#'
#' @param token token from Tinkoff account
#' @param figi internal tinkoff code for instrument
#' @param direction "Buy" or "Sell"
#' @param lots number of lots to buy
#' @param price price of limit order
#' @param sandbox paper (TRUE) or live (FALSE) trading
#' @details  As described by the official Tinkoff Investments documentation. If you want live trading, use sandbox=FALSE with live token
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{marketOrder}}
#' @examples
#' token = 'your_token_from_tcs_account'
#' # remember that this command will place limit order in your account !
#' limitOrder(token,figi='BBG005HLTYH9',direction='Buy',lots=1,price=100,sandbox = TRUE)
#' @export

limitOrder = function(token = '',figi='',direction=NULL,lots=NULL,price=NULL,sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization" = paste("Bearer",token),"Content-Type" = "application/json")
  data = paste0('{\"lots\":',lots,',\"operation\":\"',direction,'\",\"price\":',price,'}')
  url = paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),'orders/limit-order?figi=',figi)
  raw_data = POST(url, headers,body = data)
  return(content(raw_data, as = "parsed"))
}
