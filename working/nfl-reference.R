
library(XML)
library(tidyverse)
library(haven)


scrapeData = function(urlprefix, urlend, startyr, endyr) {
  master = data.frame()
  for (i in startyr:endyr) {
    cat('Loading Year', i, '\n')
    URL = paste(urlprefix, as.character(i), urlend, sep = "")
    table = readHTMLTable(URL, stringsAsFactors=F)[[1]]
    table$Year = i
    master = rbind(table, master)
  }
  return(master)
}

offense_data<-drafts = scrapeData('https://www.pro-football-reference.com/years/', '/#team_stats::none',
                                  2010, 2010)