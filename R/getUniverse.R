#' @title Download universe data (stocks,bonds,etfs,currencies)
#'
#' @description Makes 4 request to the server, and returns an data.table object with information about available instruments in Tinkoff
#'
#' @param token token from Tinkoff account
#' @param live live trading - TRUE or sandbox (paper) trading - FALSE (default)
#' @details  this function for not from official list of functions.
#' @note Not for the faint of heart. All profits and losses related are yours and yours alone. If you don't like it, write it yourself.
#' @author Vyacheslav Arbuzov
#' @seealso \code{\link{getCurrencies}} \code{\link{getBonds}} \code{\link{getETFs}} \code{\link{getStocks}}
#' @import data.table
#' @examples
#' token = 'your_sandbox_token_from_tcs_account'
#' getUniverse(token)
#' @export

getUniverse = function(token = '', live = FALSE)
{
  universe = rbind(getETFs(token,live),getBonds(token,live),getStocks(token,live),getCurrencies(token,live),fill=TRUE)
  return(universe)
}
