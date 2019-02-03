rm(list=ls())
library(data.table)
library(stringr)


mt<-fread('movie_titles_metadata.csv')
mc<-fread('movie_conversations.csv')


dt<-fread('mv_line_final.csv')
str(dt)

dt$lineID_num<-as.integer(unlist(lapply(strsplit(dt$lineID, "L"), "[", 2)))


#setorder
dt<-setorder(dt,movieID,lineID_num)

#==== seq id =======
dt$id<-seq(nrow(dt))


dt$unigrams <- gsub("\\[|\\]","",dt$unigrams)
dt$bigrams <- gsub("\\[|\\]","",dt$bigrams)
dt$trigrams <- gsub("\\[|\\]","",dt$trigrams)



# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)





#============== CLEAN BIGRAMS ==========
dt2<-data.table(str_split_fixed(dt$bigrams, ",",Inf))
dt2$id<-seq(nrow(dt2))
dt2<-subset(dt2,V1!='')
dt2 <- melt(dt2, id=c("id"),na.rm = TRUE,value.name = "word")
dt2<-dt2[,variable:=NULL]
dt2<-subset(dt2,word!='')
dt2$word<-as.factor(trim(dt2$word))
dt2<-merge(dt2,dt[,list(id,movieID)],by='id',all.x = TRUE)
#dt2<-merge(dt2,mt,by='movieID',all.x = TRUE)
dt2<-setorder(dt2,id)




#============== CLEAN TRIGRAMS ==========
dt3<-data.table(str_split_fixed(dt$trigrams, ",",Inf))
dt3$id<-seq(nrow(dt3))
dt3<-subset(dt3,V1!='')
dt3 <- melt(dt3, id=c("id"),na.rm = TRUE,value.name = "word")
dt3<-dt3[,variable:=NULL]
dt3<-subset(dt3,word!='')
dt3$word<-as.factor(trim(dt3$word))
dt3<-merge(dt3,dt[,list(id,movieID)],by='id',all.x = TRUE)
#dt3<-merge(dt3,mt,by='movieID',all.x = TRUE)
dt3<-setorder(dt3,id)







#==========================================
get_word_stats<-function(mydata,target){
  mydata$x<-1
  library(data.table)
  stat<-mydata[,.(freq=sum(x)),by=target]
  stat<-setorder(stat,-freq)
  return(stat)
}


tristats<-get_word_stats(dt3,'word')
tristats<-subset(tristats,freq>=10)

#for dashboard
save(dt,dt2,dt3,mt,mc,tristats,file='movieScriptsAnalysis.Rda')





