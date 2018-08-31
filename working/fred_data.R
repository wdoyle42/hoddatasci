library(tidyquant)
library(tigris)

#get list of states

data(fips_codes)

# Get state names
my_states<-unique(fips_codes$state)

# Drop US territories
my_states<-my_states[-(52:57)]

#Combine state name with fred symbol
stabbr<-"AL"
tickers<-paste0(my_states,"NGSP")


tickers %>% tq_get(get="economic.data", 
                   from="2001-04-01"   # we start from April 2001 due to break in HVS
) -> df

df$name<-substr(df$symbol,1,2)
