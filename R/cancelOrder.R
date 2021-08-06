#' @title cancelOrder
#'
#' @description cancelOrder
#'
#' @param token token from tinkoff
#' @param live live trading - TRUE or sandbox (paper) trading - FALSE
#' @param orderId id of order from getOrders
#' @details  As described by the official Tinkoff Investments documentation
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @seealso \code{\link{getOrders}}
#' @examples
#' paper_token = 'your_sandbox_token_from_tcs_account'
#' cancelOrder(paper_token,'your_order_id')
#'
#' live_token = 'your_live_token_from_tcs_account'
#' # remember that this command will close your order in live account !
#' cancelOrder(live_token,TRUE,'your_order_id')
#'
#' @import httr
#'
#' @export

cancelOrder = function(token = '', live = FALSE, orderId = '')
{
  headers = add_headers("accept" = "application/json","Authorization" = paste("Bearer",token))
  url = paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(live == FALSE,'sandbox/',''),'orders/cancel?orderId=',orderId)
  raw_data = POST(url, headers)
  return(content(raw_data, as = "parsed"))
}
