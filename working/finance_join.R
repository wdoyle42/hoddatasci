library(tidyquant)

symbol<-"GOOG"

financial<-tq_get(symbol,get="financial",from="2001-01-01")

stock_price<-tq_get(symbol,get="stock.prices")
stock_price$name<-symbol


#Just get income statements (IS) others are Balance Sheets (bs) and cash flows (CF)
fin<-financial %>%
  filter(type == "IS") %>%
  select(quarter)%>%
  unnest()

fin$name<-symbol

#quarterly
q_df<-left_join(fin,stock_price,by=c("name","date"))

g1<-ggplot(filter(q_df,category=="Revenue"),aes(x=value,y=close))
g1<-g1+geom_point()
g1

#daily
daily_df<-right_join(fin,stock_price,by=c("name"))
