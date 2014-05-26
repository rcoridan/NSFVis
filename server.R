library(shiny)
library(RMySQL)
library(ggplot2)

shinyServer(function(input,output){
  
  dataInput<-reactive({
    #Respond to the button - wait until user initalizes string data
    #   before calling plot (ie. input$get == 0)
    if(input$get==0) return(NULL)
    
    isolate({
      #Connect to the MySQL server
      con<-dbConnect(MySQL(),user="xxxxxxx",password="xxxxxxx",dbname="nsfdata",host="xxxxxxxxxx")
      #Build the MySQL query
      qu1<-c("select Year, Sum(Amount) from NSFHistory where Title LIKE '%",
             input$keyword1,"%' group by Year;")
      query1<-capture.output(cat(qu1,sep=""))
      #Run query and get the data
      data1<-dbGetQuery(con,query1)
      #Assign a column for the ggplot2 grouping
      data1$Label=input$keyword1
      data<-data1
      
      #Repeat if there is an entry in the 2nd box
      if (input$keyword2 != ""){
        con<-dbConnect(MySQL(),user="xxxxxxx",password="xxxxxxx",dbname="nsfdata",host="xxxxxxxxxx")
        qu2<-c("select Year, Sum(Amount) from NSFHistory where Title LIKE '%",
               input$keyword2,"%' group by Year;")
        query2<-capture.output(cat(qu2,sep=""))
        data2<-dbGetQuery(con,query2)
        data2$Label=input$keyword2
        data=rbind(data,data2)
      }
      
      #Repeat if there is an entry in the 3rd box
      if (input$keyword3 != ""){
        con<-dbConnect(MySQL(),user="xxxxxxx",password="xxxxxxx",dbname="nsfdata",host="xxxxxxxxxx")
        qu3<-c("select Year, Sum(Amount) from NSFHistory where Title LIKE '%",
               input$keyword3,"%' group by Year;")
        query3<-capture.output(cat(qu3,sep=""))
        data3<-dbGetQuery(con,query3)
        data3$Label=input$keyword3
        data=rbind(data,data3)
      }
      
      #clean up MySQL connections
      all_cons <- dbListConnections(MySQL())
      for (coni in all_cons){
        dbDisconnect(coni)
      }
      colnames(data)<-c('Year','Total','Label')
      data$Label<-factor(data$Label)
      #Expenditures in Million$
      data$Total<-data$Total /1e6
      return(data)
    })
  })
  
  output$distPlot <- renderPlot({
    #Plot nothing until user says so
    if(input$get==0) return(NULL)
    pp<-ggplot(dataInput(),aes(x=Year,y=Total,fill=Label),ylab='Total $ (M)')+geom_bar(stat='identity',position='dodge')+ylab('Total ($mil)')
    #Render the ggplot2 plot
    print(pp)
  })
  
  
})