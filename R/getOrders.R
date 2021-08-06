#' @title Download all orders in account
#'
#' @description Makes a request to the server, and returns a data.table object with information about all live orders related with your account if successful.
#'
#' @param token token from Tinkoff account
#' @param live live trading - TRUE or sandbox (paper) trading - FALSE (default)
#' @param only_live_orders select only live order or use history? (default TRUE)
#' @param raw_orders get raw orders from server or use transformation? (default FALSE)
#' @param from depth of trading history (from)
#' @param to depth of trading history (to)
#' @details  As described by the official Tinkoff Investments documentation
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{getTrades}} \code{\link{cancelOrder}}
#' @examples
#' token = 'your_sandbox_token_from_tcs_account'
#' getOrders(token)
#' @export

getOrders = function(token = '', live = FALSE, only_live_orders = TRUE, raw_orders = FALSE ,from=Sys.Date()-5, to=Sys.Date()+1)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(live == FALSE,'sandbox/',''),'orders'), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    live_orders = rbindlist(data_tmp$payload)
    if(raw_orders) return(live_orders)
    universe = getUniverse(token,live)
    if(length(live_orders)>0)
    {
      live_orders = merge(live_orders,universe[,c('figi','ticker','lot')],by='figi',all.x = TRUE)
      live_orders$quantity = live_orders$requestedLots * live_orders$lot
      live_orders$quantityExecuted = live_orders$executedLots * live_orders$lot
      live_orders = live_orders[,-c('requestedLots','executedLots','lot')]
      setcolorder(live_orders, c(2,1,7,3,8,9,5,6,4))
    }
  }
  if(raw_data$status_code!=200)
    return(content(raw_data, as = "parsed"))

  if(only_live_orders == TRUE) return(live_orders)
  if(only_live_orders == FALSE)
  {
    raw_data2 = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(live == FALSE,'sandbox/',''),
                          'operations?from=',from,'T21%3A00%3A00%2B03%3A00',
                          '&to=',to,'T21%3A00%3A00%2B03%3A00'), headers)
    if(raw_data2$status_code==200)
    {
      data_tmp2 <- content(raw_data2, as = "parsed")
      num_operations = length(data_tmp2$payload$operations)
      old_orders = NA
      if(num_operations==0) return(old_orders)
      for(i in 1:num_operations)
        if(data_tmp2$payload$operations[[i]]$operationType %in% c('Sell','Buy'))
        {
          select_cols = if(length(data_tmp2$payload$operations[[i]])==12) c(1:12) else c(1:10,13:14)
          old_order = rbindlist(list(data_tmp2$payload$operations[[i]][select_cols]))
          if(length(old_orders)>1)
            old_orders = rbind(old_orders,old_order)
          if(length(old_orders)<=1)
            old_orders = old_order
        }
      names(old_orders)[ncol(old_orders)] = 'orderId'
      names(old_orders)[1] = 'operation'
      old_orders = old_orders[,-c('currency','instrumentType')]
      old_orders$type = NA
      old_orders = merge(old_orders,universe[,c('figi','ticker')],by='figi',all.x = TRUE)
    }
    if(length(live_orders)>0)  all_orders = rbind(old_orders,live_orders,fill=TRUE)
    if(length(live_orders)==0) all_orders = old_orders
    setcolorder(all_orders, c(10,1,12,3,2,5:8,4,11,9))
    all_orders = all_orders[order(all_orders[,1],decreasing = TRUE)]
    return(all_orders)
  }
}
