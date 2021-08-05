#' @title Working with sandbox. Set Positions
#'
#' @description Set positions for sandbox account
#'
#' @param token token from Tinkoff account
#' @param balance balance of figi instrument in sandbox account
#' @param figi internal tinkoff code for instrument
#' @details  If you need to create few money position, use this function for each position
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{sandboxDeletePositions}}
#' @examples
#' token = 'your_token_from_tcs_account'
#' sandboxPositions(token,balance = 100,figi = 'BBG000BMFNP4')
#' @export

sandboxPositions = function(token = '',balance = NULL,figi = '')
{
  headers = add_headers("accept" = "application/json","Authorization" = paste("Bearer",token),"Content-Type" = "application/json")
  data = paste0('{\"figi\":\"',figi,'\",\"balance\":',balance,'}')
  url = paste0('https://api-invest.tinkoff.ru/openapi/sandbox/sandbox/positions/balance')
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
