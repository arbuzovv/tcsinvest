

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



cancelOrder = function(token = '',orderId='',sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization" = paste("Bearer",token))
  url = paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),'orders/cancel?orderId=',orderId)
  raw_data = POST(url, headers,body = data)
  return(content(raw_data, as = "parsed"))
}
