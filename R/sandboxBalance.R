#' @title Working with sandbox. Set balance
#'
#' @description Set balance for sandbox account
#'
#' @param token token from Tinkoff account
#' @param balance balance of money in sandbox account
#' @param currency currency of sandbox account. "USD","EUR" or "RUB"
#' @details  If you need to create few money position, use this function for each position
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{sandboxPositions}}
#' @examples
#' token = 'your_token_from_tcs_account'
#' sandboxBalance(token,balance = 10000,currency = 'USD')
#' @export

sandboxBalance = function(token = '',balance=NULL,currency='RUB')
{
  headers = add_headers("accept" = "application/json","Authorization" = paste("Bearer",token),"Content-Type" = "application/json")
  data = paste0('{\"currency\":\"',currency,'\",\"balance\":',balance,'}')
  url = paste0('https://api-invest.tinkoff.ru/openapi/sandbox/sandbox/currencies/balance')
  raw_data = POST(url, headers,body = data)
  if(raw_data$status_code==200)
  {
    data_tmp = content(raw_data, as = "parsed")
    data_result = cbind(data_tmp$payload$brokerAccountType,data_tmp$payload$brokerAccountId,data_tmp$status)
    return(data_result)
  }
  if(raw_data$status_code!=200)
    return(content(raw_data, as = "text"))
}
