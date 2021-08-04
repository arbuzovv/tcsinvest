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
getTrades = function(token = '',from=Sys.Date()-2,to=Sys.Date(),sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),
                        'operations?from=',from,'T21%3A00%3A00%2B03%3A00',
                        '&to=',to,'T21%3A00%3A00%2B03%3A00'), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    num_operations = length(data_tmp$payload$operations)
    data_result = NA
    if(num_operations==0) return(data_result)
    for(i in 1:num_operations)
      if(data_tmp$payload$operations[[i]]$operationType %in% c('Sell','Buy'))
      {
        trade = rbindlist(list(data_tmp$payload$operations[[i]][c(1:10)]))
        trds=rbindlist(data_tmp$payload$operations[[i]]$trades)
        com = rbindlist(list(data_tmp$payload$operations[[i]]$commission))
        if(length(trds)>0) names(trds) = paste0('trds.',names(trds))
        if(length(com)>0) names(com) = paste0('com.',names(com))
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
    return(data_result)
  }
  if(etfs$status_code!=200)
    return(structure('error in connection to tinkoff server', class = "try-error"))
}
