#' @title Subscribe/Unsubscribe to stream
#'
#' @description this function subscribes and unsubscribe for streaming
#'
#' @param client object from streamClient result, class of object ws
#' @param subscribe subscribe - TRUE (default) or unsubscribe - FALSE
#' @param type type of events for subscription: "candle","orderbook" or "instrument_info"
#' @param figi internal tinkoff code for instrument
#' @param FUN function for handler (default print)
#' @param interval timeframe of bars (availible "1min","2min","3min","5min","10min","15min","30min","hour","2hour","4hour","day","week","month")
#' @param depth depth of orderbook, number of bids and asks (1 <= depth <= 20)
#' @details  As described by the official Tinkoff Investments documentation.
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{streamStatus}} \code{\link{streamClose}}  \code{\link{streamClient}}
#' @import jsonlite
#' @export

streamSubscribe = function(client = NULL,subscribe = TRUE,type='candle',figi='BBG004730N88',FUN='print',interval='1min',depth=10)
{
  FUN <- match.fun(FUN)
  client$onMessage(function(event) {
    do.call(FUN,list(fromJSON(event$data)$payload))
  })
  client_status = client$readyState()
  if(client_status!=1)
  {
    client$connect()
    Sys.sleep(1)
  }
  type_message = ifelse(subscribe == TRUE,'subscribe','unsubscribe')
  if(type == 'orderbook') subscribe_message = paste0('{"event": "orderbook:',type_message,'", "figi": "',figi,'", "depth": ',depth,'}')
  if(type == 'candle') subscribe_message = paste0('{"event": "candle:',type_message,'", "figi": "',figi,'", "interval": "',interval,'"}')
  if(type == 'instrument_info') subscribe_message = paste0('{"event": "instrument_info:',type_message,'", "figi": "',figi,'"}')
  if(!type %in% c('candle','instrument_info','orderbook')) return('set one type from: candle,instrument_info or orderbook')
  client$send(subscribe_message)
}
