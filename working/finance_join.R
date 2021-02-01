
## Most recent version of tidyquant

#devtools:install_github("business-science/tidyquant")

library(tidyquant)
library(lubridate)
library(tidyverse)

api_key<-readlines("~/hod_datasci_keys/av_key.txt")

av_api_key(api_key)

nyse<-tq_exchange("NYSE")

symbols<-nyse$symbol[1:100]



prices<-symbols%>%
  tq_get(get=c("dividends"))
         from="2001-01-01"))


stock_price$year<-year(stock_price$date)

#Just get P/E Ratio


pe<-key_ratios$data[[7]]%>%
  filter(category=="Price to Earnings")%>%
  select(date,value)%>%
  rename(pe=value)

pe$year<-year(pe$date)  


ps<-key_ratios$data[[7]]%>%
  filter(category=="Price to Sales")

ps$year<-year(ps$date)  



combined<-left_join(stock_price,pe,by="year")
combined<-left_join(stock_price,ps,by="year")

fin<-financial %>%
  filter(data == "GROWTH") %>%
  select(quarter)%>%
  unnest()

fin2<-financial%>%
  filter(type=="BS") %>%
  select(quarter) %>%
  unnest()

fin<-rbind(fin,fin2)

fin$name<-symbol

#quarterly
q_df<-left_join(fin,stock_price,by=c("name","date"))

#Combine with full data frame
full_df<-bind_rows(full_df,q_df)

}

oil<-tq_get(x="DCOILWTICO",get = "economic.data",from="2000-01-01")

g1<-ggplot(filter(q_df,category=="Revenue"),aes(x=value,y=close))
g1<-g1+geom_point()
g1

#daily
daily_df<-right_join(fin,stock_price,by=c("name"))

# linear model

reg1<-lm(close~value,
         data=filter(combined,category="Operating Revenues"))