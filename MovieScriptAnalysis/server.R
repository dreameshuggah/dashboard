library(shiny)


shinyServer(function(input, output) {
  
  # ==================== TRIGRAM ==============================================  
  output$tristats_tbl<-renderDataTable({
    tristats
  }, options = list(aLengthMenu = c(5,10,20,30, 50), iDisplayLength = 12,orderClasses = TRUE))
  
  
  output$TriwordCloud<-renderPlot({
    
    wordcloud(tristats$word,tristats$freq,
              scale=my_scale,
              min.freq=10,
              max.words=500,
              random.order=FALSE,#TRUE, 
              #random.color=FALSE, 
              rot.per=.15,
              colors=pal#,ordered.colors=FALSE,use.r.layout=FALSE,
              #fixed.asp=TRUE
    )
  })
  
  
  get_topTrigram<-reactive({
    
    #cm<-tristats[input$tri_range[1]:input$tri_range[2],]$word
    cm_dt<- unique(subset(dt3[,list(id,word)],word %in% input$selected_trigram ))
    cm_dt<-dcast(cm_dt, id ~ word,value.var='word',fill=NULL)#wide table
    cm_dt<-merge(cm_dt,dt[,list(id,
                                #characterID,
                                lineID,
                                movieID,
                                script)])
    
    cm_dt<-merge(cm_dt,mt[,list(movieID,movieTitle)],by='movieID',all.x = TRUE)
    cm_dt<-cm_dt[,c('movieID','id'):=NULL]
    setnames(cm_dt,input$selected_trigram,'trigram')
  })
  
  output$topTrigram_tbl<-renderDataTable({
    get_topTrigram()
  }, options = list(aLengthMenu = c(5,10,20,30, 50), iDisplayLength = 10,orderClasses = TRUE))
  
#============  END TRIGRAM ================  

  
  
#============ BIGRAM =========================  
  
  get_movie1_bigram<-reactive({
    b_t1<-subset(dt2[,list(word,movieTitle)],movieTitle == input$selected_movie1)[,list(word)]
    b_t1<-get_word_stats(b_t1,'word')
    b_t1<-subset(b_t1,freq>=2)
    
  })
  
  output$movie1_bigram_tbl<-renderDataTable({
    get_movie1_bigram()
  }, options = list(aLengthMenu = c(5,10,20,30, 50), iDisplayLength = 5,orderClasses = TRUE))
  
  output$movie1_wordcloud<-renderPlot({
    b_t1<-get_movie1_bigram()
    
    wordcloud(b_t1$word,b_t1$freq,
              scale=my_scale,
              min.freq= min_freq,
              max.words=single_movie_max_words,
              random.order=FALSE,#TRUE, 
              #random.color=FALSE, 
              rot.per=.15,
              colors=pal#,ordered.colors=FALSE,use.r.layout=FALSE,
              #fixed.asp=TRUE
    ) 
  })
  
  
  get_movie2_bigram<-reactive({
    b_t2<-subset(dt2[,list(word,movieTitle)],movieTitle == input$selected_movie2)[,list(word)]
    b_t2<-get_word_stats(b_t2,'word')
    b_t2<-subset(b_t2,freq>=2)
  })
  
  output$movie2_bigram_tbl<-renderDataTable({
    get_movie2_bigram()
  }, options = list(aLengthMenu = c(5,10,20,30, 50), iDisplayLength = 5,orderClasses = TRUE))
  
  output$movie2_wordcloud<-renderPlot({
    b_t2<-get_movie2_bigram()
    
    wordcloud(b_t2$word,b_t2$freq,
              scale=my_scale,
              min.freq= min_freq,
              max.words=single_movie_max_words,
              random.order=FALSE,#TRUE, 
              #random.color=FALSE, 
              rot.per=.15,
              colors=pal#,ordered.colors=FALSE,use.r.layout=FALSE,
              #fixed.asp=TRUE
    )
  })
    
  
  
#============ DATA ====================
  
  output$mt_tbl<-renderDataTable({
    mt
  }, options = list(aLengthMenu = c(5,10,20,30, 50), iDisplayLength = 10,orderClasses = TRUE))
  
  
  
  output$mv_line_tbl<-renderDataTable({
    dt[,list(id,movieID,lineID,characterID,characterName,script,unigrams,bigrams,trigrams)]
  }, options = list(aLengthMenu = c(5,10,20,30, 50), iDisplayLength = 10,orderClasses = TRUE))
  
  
  
  
  

    
  #================================END=============================================================
 
})#shinyserver function