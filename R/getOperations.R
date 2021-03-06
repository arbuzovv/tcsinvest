#' @title Download all operations in account
#'
#' @description Makes a request to the server, and returns a list object with information about all operation related with your account if successful.
#'
#' @param token token from Tinkoff account
#' @param live live trading - TRUE or sandbox (paper) trading - FALSE (default)
#' @param from from what date download history
#' @param to to what date download history
#' @param verbose display status of retrieval (default FALSE)
#' @details  As described by the official Tinkoff Investments documentation
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{getOrders}} \code{\link{getTrades}}
#' @examples
#' live = FALSE
#' token = 'your_sandbox_token_from_tcs_account'
#' getOperations(token,live)
#' @export

getOperations = function(token = '', live = FALSE, from = Sys.Date()-5, to = Sys.Date(), verbose = FALSE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(live == FALSE,'sandbox/',''),
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
    if(length(data_tmp$payload$operations)!=0)
      return(data_result)
  }
  if(raw_data$status_code!=200)
    if(verbose) return(content(raw_data, as = "parsed"))
}
