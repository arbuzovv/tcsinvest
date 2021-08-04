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
  if(etfs$status_code!=200)
    return(structure('error in connection to tinkoff server', class = "try-error"))
}
