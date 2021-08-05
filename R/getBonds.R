#' @title Download Bond data
#'
#' @description Makes a request to the server, and returns an data.table object with information about available bonds if successful.
#'
#' @param token token from Tinkoff account
#' @param sandbox paper (TRUE) or live (FALSE) trading
#' @details  As described by the official Tinkoff Investments documentation
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{getETFs}} \code{\link{getCurrencies}} \code{\link{getStocks}}
#' @examples
#' token = 'your_token_from_tcs_account'
#' getBonds(token)
#' @export

getBonds = function(token = '',sandbox = TRUE)
{
  headers = add_headers("accept" = "application/json","Authorization"=paste("Bearer",token))
  raw_data = GET(paste0('https://api-invest.tinkoff.ru/openapi/',ifelse(sandbox == TRUE,'sandbox/',''),'market/bonds'), headers)
  if(raw_data$status_code==200)
  {
    data_tmp <- content(raw_data, as = "parsed")
    data_result = rbindlist(data_tmp$payload$instruments,fill=TRUE)
    return(data_result)
  }
  if(raw_data$status_code!=200)
    return(structure('error in connection to tinkoff server', class = "try-error"))
}
