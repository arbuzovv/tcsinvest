#' @title Working with sandbox. Delete positions
#'
#' @description Delete sandbox positions (all positions: stocks, etfs,bonds and money)
#'
#' @param token token from Tinkoff account (only sandbox token)
#' @details  If you need to create few money position, use this function for each position
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{sandboxPositions}}
#' @examples
#' token = 'your_token_from_tcs_account'
#' sandboxDeletePositions(token)
#' @export

sandboxDeletePositions = function(token = '')
{
  headers = add_headers("accept" = "application/json","Authorization" = paste("Bearer",token))
  url = paste0('https://api-invest.tinkoff.ru/openapi/sandbox/sandbox/clear')
  raw_data = POST(url, headers)
  if(raw_data$status_code==200)
  {
    data_tmp = content(raw_data, as = "parsed")
    data_result = cbind(data_tmp$status)
    return(data_result)
  }
  if(raw_data$status_code!=200)
    return(content(raw_data, as = "text"))
}
