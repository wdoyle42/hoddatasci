library(tidyquant)

symbols<-c("GOOG","IBM")

full_df<-NULL #Initialize empty dataset

for (symbol in symbols){

financial<-tq_get(symbol,get="financial",from="2001-01-01")

stock_price<-tq_get(symbol,get="stock.prices")

stock_price$name<-symbol

#Just get income statements (IS) others are Balance Sheets (bs) and cash flows (CF)
fin<-financial %>%
  filter(type == "IS") %>%
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
full_df<-rbind(full_df,q_df)

}

g1<-ggplot(filter(q_df,category=="Revenue"),aes(x=value,y=close))
g1<-g1+geom_point()
g1

#daily
daily_df<-right_join(fin,stock_price,by=c("name"))

# linear model

reg1<-lm(close~value,
         data=filter(combined,category="Operating Revenues"))