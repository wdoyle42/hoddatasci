
if(!file.exists("dividend_data.Rds")){
nyse<-tq_exchange("NYSE")

symbols<-nyse$symbol[1:20]

symbols%>%
tq_get(get="stock.prices")->stock_prices

symbols%>%
  tq_get(get="dividends")->dividends

full<-left_join(dividends,stock_prices,
                by=c("symbol",
                     "date"))

save(full,file="dividend_data.Rds")

} else{
  load("dividend_data.Rds")
}

