rm(list=ls())


library(data.table)
library(stringr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer) 


#============ functions ==============
# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

get_word_stats<-function(mydata,target){
  mydata$x<-1
  library(data.table)
  stat<-mydata[,.(freq=sum(x)),by=target]
  stat<-setorder(stat,-freq)
  return(stat)
}



#========= start =========
load('movieScriptsAnalysis.Rda')

setnames(dt,'utter','script')

mydashboardtitle = 'Movie Scripts Analysis'


dt2<-merge(dt2,mt[,list(movieID,movieTitle)],by='movieID',all.x = TRUE)

#tristats$rank<-seq(nrow(tristats))

max_words = 500 #all movies

single_movie_max_words = 100

min_freq = 2
my_scale = c(6,.1)


pal <- brewer.pal(6,"Dark2")
pal <- pal[-(1)]



