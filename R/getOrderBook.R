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
getOrderBook = function(token = '',figi='',depth=NULL,sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),'market/orderbook?figi=',figi,'&depth=',depth), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    data_bids = rbindlist(data_tmp$payload$bids,fill=TRUE)
    data_asks = rbindlist(data_tmp$payload$asks,fill=TRUE)
    data_asks$quantity = -data_asks$quantity
    data_result = rbind(data_asks,data_bids)
    data_result = data_result[order(price,decreasing = TRUE)]
    return(data_result)
  }
  if(etfs$status_code!=200)
    return(structure('error in connection to tinkoff server', class = "try-error"))
}
