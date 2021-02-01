library(tidyquant)

av_key<-read_lines("~/hod_datasci_keys/av_key.txt")

av_api_key(av_key)

nyse<-tq_exchange("NYSE")

symbols<-nyse$symbol[1:100]

series <- symbols %>%
  tq_get(get = "alphavantager", 
         av_fun = "TIME_SERIES_MONTHLY_ADJUSTED",
         )
         