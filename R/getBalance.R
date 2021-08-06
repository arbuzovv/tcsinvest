#' @title Download balance of account
#'
#' @description Makes a request to the server, and returns an data.table object with information about available balance if successful.
#'
#' @param token token from Tinkoff account
#' @param live live trading - TRUE or sandbox (paper) trading - FALSE (default)
#' @param verbose display status of retrieval (default FALSE)
#' @details  As described by the official Tinkoff Investments documentation
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{getAccounts}} \code{\link{getPortfolio}}
#' @examples
#' token = 'your_sandbox_token_from_tcs_account'
#' getBalance(token)
#' @export

getBalance = function(token = '', live = FALSE, verbose = FALSE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(live == FALSE,'sandbox/',''),'portfolio/currencies'), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    data_result = rbindlist(data_tmp$payload$currencies,fill=TRUE)
    return(data_result)
  }
  if(raw_data$status_code!=200)
    if(verbose) return(content(raw_data, as = "parsed"))
}
