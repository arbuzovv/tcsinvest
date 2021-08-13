
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tcsinvest <a href='https://tcsinvest.ru'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/arbuzovv/tcsinvest/actions/workflows/r.yml/badge.svg)](https://github.com/arbuzovv/tcsinvest/actions/workflows/r.yml)
<!-- badges: end -->

**tcsinvest** - это неофициальная библиотека R для работы с API Тинькофф
Инвестиции. Библиотека использует в своей основе `data.table` как один
из наиболее производительных способов работы с большими объемами данных
в R. Взаимодействией с Rest API реализовано с использованием библиотеки
`httr`, а стриминг данных через `websocket`.

-   `getStocks()` adds new variables that are functions of existing
    variables
-   `getETFs()` picks variables based on their names.
-   `filter()` picks cases based on their values.
-   `summarise()` reduces multiple values down to a single summary.
-   `arrange()` changes the ordering of the rows.

## Установка библиотеки tcsinvest

Для использования библиотеки в R, ее нужно сперва установить. Можно это
сделать 2 способами:

-   Использовать версию загруженную в репозиторий CRAN

-   Использовать версию с Github

В репозиторий CRAN обычно загружены наиболее стабильные версии
библиотек, их легко установить, но достаточно часто они не учитывают
последние изменения в коде, исправления возникающих ошибок и изменения в
самом API. Хотя для большинства пользователей достаточно и рекомендуется
использование библиотеки загруженной на CRAN. Для установки с CRAN
достаточно найти библиотеку в списке общих пакетов или установить с
использованием команды:

``` r
install.packages("tcsinvest")
```

В случае загрузки библиотеки с github необходима установленная
библиотека `devtools` (в случае если ее нет - нужно установить).

``` r
devtools::install_github("arbuzovv/tcsinvest",build_vignettes = TRUE)
```

Иногда при таком методе возникает ошибка *“Error in
utils::download.file(url, path….”* которая лечится следующей строчкой
кода:

``` r
options(download.file.method = "libcurl")
```

Если в процессе установки возникает ошибка *“Error in strptime(xx, f, tz
= tz) : (converted from warning) unable to identify current timezone”*,
то ее можно устранить указанием временной зоны

``` r
Sys.timezone()
Sys.setenv(TZ='GMT')
Sys.timezone()
```

## Где взять токен аутентификации?

В разделе инвестиций личного кабинета Tinkoff. Далее:

-   Перейдите в настройки

-   Проверьте, что функция “Подтверждение сделок кодом” отключена

-   Выпустите токен для торговли на бирже и режима “песочницы” (sandbox)

-   Скопируйте токен и сохраните, токен отображается только один раз,
    просмотреть его позже не получится, тем не менее вы можете выпускать
    неограниченное количество токенов

## Работа с потоковой информацией

Tinkoff API позволяет работать с потоковой информацией (через
WebSocket). Особенностью работы с потокой информацией является ее
асинхронность - информация с сервера приходит когда появились какие-то
изменения. Очень важным моментом является факт того, что мы не знаем
момента времени, когда придет следующее событие от сервера. Для
взаимодействия с потоковой информацией необходимо писать обработчик
событий. В API на данный момент поддерживаются 3 типа потоковых данных:

-   `candle` - подписка на свечи

-   `orderbook` - подписка на книгу заявок (стакан)

-   `instrument_info` - подписка на информацию об инструменте

На потоковые данные можно как подписываться, так и отписываться от них.

Для работы с потоковыми данными необходимо создать объект *“клиент”*,
который в последующем будет использован для создания подключения.

``` r
client = streamClient(token)
```

После создания клиента можно посмотреть статус этого клиента. Статус
`Pre-connecting` означает, что подключение готово к использованию и
можно подписываться на данные.

``` r
streamStatus(client)
```

Создадим подписку на данные о книге заявок:

``` r
streamSubscribe(client,subscribe = TRUE,type='orderbook',figi='BBG004730N88',depth=1)
```

Отменить подписку на данные о книге заявок:

``` r
streamSubscribe(client,subscribe = FALSE,type='orderbook',figi='BBG004730N88',depth=1)
```

Создадим подписку на цену:

``` r
streamSubscribe(client,subscribe = TRUE,type='candle',figi='BBG004730N88',interval='1min')
```

Отменить подписку на цену:

``` r
streamSubscribe(client,subscribe = FALSE,type='candle',figi='BBG004730N88',interval='1min')
```

Для того, чтобы разорвать соединение используйте функцию `streamClose`:

``` r
streamClose(client)
```

При подписке на данные, включается обработчик событий, который по
умолчанию является функцией `print` выводящей в консоль информацию о
вновь поступившей рыночной информации. Для создания более сложной логики
необходимо задать свой собственный обработчик событий. Для этой задачи
обычно пишется пользовательская функция с необходимой логикой. В
качестве примера попробуем написать обработчик событий, который по
инфомации из книги заявок (`orderbook`) будет вычислять разницу между
лучшей ценой спроса и предложения (бид-аск спред).

``` r
bid_ask_spread = function(x)
{
  spread = min(x$asks[,1])-max(x$bids[,1])
  print(spread)
}
```

Теперь, когда у нас имеется пользовательская функция, можно приступить к
обработке с ее помощью событий. Для этого в качестве агрумента `FUN`
передадим название нашей новой функции `bid_ask_spread`:

``` r
streamStatus(client)
streamSubscribe(client,subscribe = TRUE,type='orderbook',FUN = 'bid_ask_spread',figi='BBG004730N88',depth=5)
```

Для отмены подписки на данный поток, используйте команду с указанием той
функции, с помощью которой подписывались на поток:

``` r
streamSubscribe(client,subscribe = FALSE,type='orderbook',FUN = 'bid_ask_spread',figi='BBG004730N88',depth=5)
streamClose(client)
```

## Пример простейшего торгового робота

``` r
# задаем баланс в песочнице на который будем торговать
token = 'your_sandbox_token_from_tcs_account'
live = FALSE
sandboxBalance(token,balance = 100000,currency = 'RUB')
getBalance(token,live)

# информация об инструменте
capital = 100000
ticker_info = getTickerInfo(token,live,ticker = 'SBER' )
lots = ticker_info$lot
figi_code = ticker_info$figi

# бесконечный цикл торговли
while(2==2)
{
# инфомация о сигнале и необходимой позиции (теоретической)
history = getHistoricalData(token,live,figi_code,from = Sys.Date()-1,interval = '1min')
last_ret = tail(history$c/history$o-1,1)
size = floor(capital/getQuotes(token,live,figi_code)$lastPrice/lots)
theor_position = ifelse(last_ret>0,size,0)
  
# фактическое состояние портфеля
my_portfolio = getPortfolio(token,live)
if(length(my_portfolio)>0)
  current_position = my_portfolio[figi==figi_code]$lots
current_position = ifelse(length(current_position)==0,0,current_position)  

# приводим теоретическое состояние к фактическому
if(theor_position!=current_position)
{
  direction = ifelse(theor_position-current_position>0,'Buy','Sell')
  marketOrder(token,live,figi_code,direction=direction,lots=abs(theor_position-current_position))
}

# печать совершенных сделок и ожидание следующей минуты  
print(getTrades(token,live))
Sys.sleep(60)
}
```
