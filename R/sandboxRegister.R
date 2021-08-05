#' @title Working with sandbox. Register account
#'
#' @description Register sandbox account
#'
#' @param token token from Tinkoff account (only sandbox token)
#' @details  If you need to create few money position, use this function for each position
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{sandboxDeleteAccount}}
#' @examples
#' token = 'your_token_from_tcs_account'
#' sandboxRegister(token)
#' @export

sandboxRegister = function(token = '')
{
  headers = add_headers("accept" = "application/json","Authorization" = paste("Bearer",token),"Content-Type" = "application/json")
  data = '{\"brokerAccountType\":\"Tinkoff\"}'
  url = paste0('https://api-invest.tinkoff.ru/openapi/sandbox/sandbox/register')
  raw_data = POST(url, headers,body = data)
  if(raw_data$status_code==200)
  {
    data_tmp = content(raw_data, as = "parsed")
    data_result = cbind(data_tmp$status)
    return(data_result)
  }
  if(raw_data$status_code!=200)
    return(content(raw_data, as = "text"))
}
