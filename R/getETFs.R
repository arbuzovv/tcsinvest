#' @title Download ETF data
#'
#' @description Makes a request to the server, and returns an data.table object with information about available ETFs if successful.
#'
#' @param token token from Tinkoff account
#' @param sandbox paper (TRUE) or live (FALSE) trading
#' @details  As described by the official Tinkoff Investments documentation
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{getCurrencies}} \code{\link{getBonds}} \code{\link{getStocks}}
#' @examples
#' token = 'your_token_from_tcs_account'
#' getETFs(token)
#' @export

getETFs = function(token = '',sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  etfs = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),'market/etfs'), headers)
  if(etfs$status_code==200)
  {
    data_tmp <- content(etfs, as = "parsed")
    data_result = rbindlist(data_tmp$payload$instruments,fill=TRUE)
    return(data_result)
  }
  if(etfs$status_code!=200)
    return(structure('error in connection to tinkoff server', class = "try-error"))
}
