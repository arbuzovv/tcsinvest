#' @title Create stream client
#'
#' @description this function creates client for streaming
#'
#' @param token token from Tinkoff account
#' @details  As described by the official Tinkoff Investments documentation. If you want live trading, use sandbox=FALSE with live token
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{streamStatus}} \code{\link{streamClose}} \code{\link{streamSubscribe}}
#' @import websocket
#' @export

streamClient = function(token = '')
{
  ws <- WebSocket$new("wss://api-invest.tinkoff.ru/openapi/md/v1/md-openapi/ws",
                      headers = list("Authorization" = paste("Bearer",token)),
                      autoConnect = FALSE)
  ws$onOpen(function(event) {
    cat("Connection opened\n")
  })
  ws$onClose(function(event) {
    cat("Client disconnected with code ", event$code,
        " and reason ", event$reason, "\n", sep = "")
  })
  ws$onError(function(event) {
    cat("Client failed to connect: ", event$message, "\n")
  })
  return(ws)
}
