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
limitOrder = function(token = '',figi='',direction=NULL,lots=NULL,price=NULL,sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization" = paste("Bearer",token),"Content-Type" = "application/json")
  data = paste0('{\"lots\":',lots,',\"operation\":\"',direction,'\",\"price\":',price,'}')
  url = paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),'orders/limit-order?figi=',figi)
  raw_data = POST(url, headers,body = data)
  return(content(raw_data, as = "parsed"))
}
