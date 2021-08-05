#' @title Download all operations in account
#'
#' @description Makes a request to the server, and returns a list object with information about all operation related with your account if successful.
#'
#' @param token token from Tinkoff account
#' @param from from what date download history
#' @param to to what date download history
#' @param sandbox paper (TRUE) or live (FALSE) trading
#' @details  As described by the official Tinkoff Investments documentation
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{getOrders}} \code{\link{getTrades}}
#' @examples
#' token = 'your_token_from_tcs_account'
#' getOperations(token)
#' @export

getOperations = function(token = '',from=Sys.Date()-2,to=Sys.Date(),sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),
                        'operations?from=',from,'T21%3A00%3A00%2B03%3A00',
                        '&to=',to,'T21%3A00%3A00%2B03%3A00'), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    if(length(data_tmp$payload$operations)>0)
      data_result = list(rbindlist(data_tmp$payload$operations[1]))
    if(length(data_tmp$payload$operations)>1)
      for(i in 2:length(data_tmp$payload$operations))
        data_result[i] =  list(rbindlist(data_tmp$payload$operations[i]))
      return(data_result)
  }
  if(raw_data$status_code!=200)
    return(structure('error in connection to tinkoff server', class = "try-error"))
}
