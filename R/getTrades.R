#' @title Download trades of current account
#'
#' @description Makes a request to the server, and returns an data.table object with information about account trades if successful.
#'
#' @param token token from Tinkoff account
#' @param live live trading - TRUE or sandbox (paper) trading - FALSE (default)
#' @param from from what date download trades
#' @param to to what date download trades
#' @param symbol_info download full information about instruments of trades (4 additional requests)
#' @param verbose display status of retrieval (default FALSE)
#' @details  parsing this data from getOperaions function
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{getOrders}}
#' @examples
#' token = 'your_sandbox_token_from_tcs_account'
#' getTrades(token)
#' @export

getTrades = function(token = '', live = FALSE, from = Sys.Date()-5, to = Sys.Date(), symbol_info = FALSE, verbose = FALSE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(live == FALSE,'sandbox/',''),
                        'operations?from=',from,'T21%3A00%3A00%2B03%3A00',
                        '&to=',to,'T21%3A00%3A00%2B03%3A00'), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    num_operations = length(data_tmp$payload$operations)
    data_result = NA
    if(num_operations==0) return(data_result)
    for(i in 1:num_operations)
      if(data_tmp$payload$operations[[i]]$operationType %in% c('Sell','Buy') & data_tmp$payload$operations[[i]]$status == "Done")
      {
        trade = rbindlist(list(data_tmp$payload$operations[[i]][c(1:10)]))
        trds=rbindlist(data_tmp$payload$operations[[i]]$trades)
        com = rbindlist(list(data_tmp$payload$operations[[i]]$commission))
        if(length(trds)>0) names(trds) = paste0('executed.',names(trds))
        if(length(com)>0) names(com) = paste0('commission.',names(com))
        if('status' %in% names(trade)) trade = cbind(trade,com,trds)
        if(!'status' %in% names(trade))
        {
          trade = cbind(trade,com,trds,data_tmp$payload$operations[[i]]$status)
          names(trade)[ncol(trade)] = 'status'
        }
        if(length(data_result)>1)
          data_result = rbind(data_result,trade)
        if(length(data_result)<=1)
          data_result = trade
      }
    # exists data ?
    if(length(data_result)>1)
    {
    setcolorder(data_result, c(5,4,1:3,6:length(names(data_result))))
    if(symbol_info) data_result = merge(data_result,getUniverse(token,live)[,-'currency'],by='figi',all.x = TRUE)
    }
    return(data_result)
  }
  if(raw_data$status_code!=200)
    if(verbose) return(content(raw_data, as = "parsed"))
}
