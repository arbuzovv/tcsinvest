#' @title Close stream connection
#'
#' @description this function close connection
#'
#' @param client object from streamClient result, class of object ws
#' @details  As described by the official Tinkoff Investments documentation. If you want live trading, use sandbox=FALSE with live token
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{streamStatus}}  \code{\link{streamClient}} \code{\link{streamSubscribe}}
#' @export

streamClose = function(client = NULL)
{
  client$close()
}
