#' @title Check stream status
#'
#' @description this function return current status of connection
#'
#' @param client object from streamClient result, class of object ws
#' @details  As described by the official Tinkoff Investments documentation. If you want live trading, use sandbox=FALSE with live token
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{streamClose}}  \code{\link{streamClient}} \code{\link{streamSubscribe}}
#' @export

streamStatus = function(client = NULL)
{
  return(client$readyState())
}
