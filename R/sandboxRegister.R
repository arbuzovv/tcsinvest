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
