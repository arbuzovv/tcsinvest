#' @title cancelOrder
#'
#' @description cancelOrder
#'
#' @param token token from tinkoff
#' @param orderId id of order from getOrders
#' @param sandbox paper (TRUE) or live (FALSE) trading
#' @details  As described by the official Tinkoff Investments documentation
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @seealso \code{\link{getOrders}}
#' @examples
#' token = 'your_token_from_tcs_account'
#' cancelOrder(token,'')
#' @import httr
#'
#' @export

cancelOrder = function(token = '',orderId='',sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization" = paste("Bearer",token))
  url = paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),'orders/cancel?orderId=',orderId)
  raw_data = POST(url, headers)
  return(content(raw_data, as = "parsed"))
}
