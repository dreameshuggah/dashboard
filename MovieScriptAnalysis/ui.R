library(shiny)

shinyUI(
  fluidPage(
    #style = "background-color: #525252;",
    titlePanel(
               #title=div(img(src="logo_login.png",height= "80")),#style = "background-color: #ce1256;"),
               img(height = 60,# width = 300,
                   src = "cat.png"),
               windowTitle=paste('Rizal',mydashboardtitle)
               ),
    navbarPage(
      title=mydashboardtitle,
      theme = "white_green.css",#"black.css",#  #
      inverse = TRUE,
      collapsible = TRUE,
             # =============================== TRIGRAM ========================================
             tabPanel("Trigram",

                      h3("Trigram Discovery: All Movies"),br(),
                      
                      fluidRow(
                        column(6,
                        h4("Trigrams Wordcloud: All Movies"),
                        plotOutput("TriwordCloud", height="800px")
                        ),
                      
                        h4("Table of Trigrams: All Movies"),
                        column(4,offset=0.7,
                        div(style = 'overflow-x: scroll',dataTableOutput(outputId="tristats_tbl"))
                        )
                        ),

                      br(),

                     selectInput("selected_trigram", "Please Select Trigram:",
                                 choices = tristats$word,
                                 selected = tristats[1,]$name,
                                 multiple = FALSE),
                      
                      br(),
                      h4("Movie Scripts: based on selected Trigram"),
                      div(style = 'overflow-x: scroll',dataTableOutput(outputId="topTrigram_tbl")),
                      
                      br(),hr()
                      
                      
                      
                      
                     

                ),#tabpanel
      
      #======================= bigram ===================
      tabPanel("Bigram",
               h3("Bigram comparison by movies"),br(),br(),
               fluidRow(
                 column(2,offset=0.5,
                        selectInput("selected_movie1", "Please Select Movie 1:",
                                    choices = mt$movieTitle,
                                    selected = 'the matrix',
                                    multiple = FALSE)),
                 column(2,offset=5,
                       selectInput("selected_movie2", "Please Select Movie 2:",
                                   choices = mt$movieTitle,
                                   selected = 'the godfather',
                                   multiple = FALSE))
                 
               ),
               
               fluidRow(
                 column(6,
                        plotOutput("movie1_wordcloud",height="650px")),
                 column(6,
                        plotOutput("movie2_wordcloud",height="650px"))
                 ),
               
               fluidRow(
                 column(4,offset=0.5,
                        h4('Movie 1'),
                 div(style = 'overflow-x: scroll',dataTableOutput(outputId="movie1_bigram_tbl"))),
                 column(4,offset=3,
                        h4('Movie 2'),
                 div(style = 'overflow-x: scroll',dataTableOutput(outputId="movie2_bigram_tbl")))
               )
                        
        
      ),#tabpanel end bigram
      
      
      
      tabPanel("Data",
               
               h3('Data'),br(),br(),
               
               h4("Movie Metadata"),
               div(style = 'overflow-x: scroll',dataTableOutput(outputId="mt_tbl")),
               
               br(),br(),hr(),
               h4("Movie Lines"),
               div(style = 'overflow-x: scroll',dataTableOutput(outputId="mv_line_tbl")),
               br(),br(),hr()
               
               
               )#tabpanel
      
      
      
  )#navbarPage#fluidpage       
  )#fluidpage       
)#shinyUI