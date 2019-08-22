## Best picture
library(tidyverse)
library(omdbapi)
library(rvest)

## Wiki Page: Academy awards for best picture
url<-"https://en.wikipedia.org/wiki/Academy_Award_for_Best_Picture"

## Get just tables from page
titles<- read_html(url)%>%
  html_nodes('table')%>%
    html_table(fill=TRUE)

## Elements 3:12 are tables of winners
## convert each to a data frame then "stack" them using bind_rows
  titles_df<-bind_rows(titles[3:12])


## Clean up dataset, and create year variable from first 4 of year
titles_df<-titles_df%>%  
  rename_all(tolower)%>%
  mutate(year=str_sub(year,1,4))%>%
  filter(is.na(film)==FALSE)

#View(titles_df)

## Get a vector(list) of movie titles
titles_list<-titles_df%>%
  filter(year>2000)%>%
  filter(is.na(film)==FALSE)%>%
  select(film)%>%as_vector()

# Search IMDB for each title, add to data frame
mv<-map_df(titles_list,search_by_title)

## Clean up data frame by dropping unmatched titles, non-movies, no poster etc
mv2<-mv%>%
  filter(Title%in%titles_list)%>%
  filter(Type=="movie")%>%
  filter(is.na(Poster)==FALSE)%>%
  filter(Poster!="N/A")%>%
  rename_all(tolower)%>%
  rename(film=title)%>%
  filter(year>2000) ## Only for 2000 and after
  
## Include only those results that are in the original dataset, matching
## by film and year gets the right ones
## Drop any NAs that are left
mv2<-left_join(filter(titles_df,year>2000),mv2,by=c("year","film"))%>%
  filter(is.na(film)==FALSE)

## This creates a "find by id" function that will fail gracefully
possibly_find_by_id<-possibly(find_by_id,otherwise=NULL)

# Send request for these IDs to the omdb database
mv_df<-NULL
for (id in mv2$imdbid){
results<-find_by_id(id)
mv_df<-bind_rows(mv_df,results)
}

mv_df$rate_source<-mv_df$Ratings%>%map(1)%>%as_vector()

# pull rating
mv_df$rating<-mv_df$Ratings%>%map(2)%>%as_vector()

# Get relevant ino
mv_df2<-mv_df%>%
  filter(rate_source=="Rotten Tomatoes")%>%
  mutate(rating=parse_number(rating))%>%
  mutate(BoxOffice=parse_number(BoxOffice))%>%
  mutate(imdbRating=parse_number(imdbRating))


# pull rating source
mv_df$rate_source<-mv_df$Ratings%>%map(1)%>%as_vector()

# pull rating
mv_df$rating<-mv_df$Ratings%>%map(2)%>%as_vector()

# pull relevant info
mv_df<-mv_df%>%
  filter(rate_source=="Rotten Tomatoes")%>%
  mutate(rating=parse_number(rating))%>%
  mutate(BoxOffice=parse_number(BoxOffice))%>%
  mutate(imdbRating=parse_number(imdbRating))
