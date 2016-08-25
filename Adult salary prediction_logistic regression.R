#title: "Salary prediction from UCI adult dataset"
#output: html_notebook
#Author: Zhuangfang Yi

setwd("C:/Data Science Fundation with R/R-Course-HTML-Notes/R-Course-HTML-Notes/R-for-Data-Science-and-Machine-Learning/Training Exercises/Machine Learning Projects/CSV files for ML Projects")
list.files("C:/Data Science Fundation with R/R-Course-HTML-Notes/R-Course-HTML-Notes/R-for-Data-Science-and-Machine-Learning/Training Exercises/Machine Learning Projects/CSV files for ML Projects")
A.df <- read.csv("adult_sal.csv", sep = ",")
head(A.df)

summary(A.df)

library(ggplot2)
library(ggthemes)
ggplot(A.df, aes(sex)) + geom_bar(aes(fill= income), alpha=0.5)

ggplot(A.df, aes(factor(type_employer))) + geom_bar(aes(fill=income)) + facet_grid(.~ sex) + theme(text = element_text(size=12),axis.text.x = element_text(angle=90, vjust=0.2)) 

ggplot(A.df, aes(factor(type_employer))) + geom_bar(aes(fill=sex), alpha = 0.6) + facet_grid(.~ income) + theme(text = element_text(size=12),axis.text.x = element_text(angle=90, vjust=0.2)) 

table(A.df$type_employer)

A.df$type_employer <- as.character(A.df$type_employer)
str(A.df)
unemp <- function(job) {
  job <- as.character(job)
  if (job =='Never-worked'| job=='Without-pay') {
    return("unemployed")
  } else {
    return(job)
  }
}
A.df$type_employer <- sapply(A.df$type_employer, unemp)
table(A.df$type_employer)

table(A.df$marital)
ggplot(A.df, aes(marital)) +geom_bar(fill="purple", color = "white",alpha = 0.8) +theme_economist() +theme(text = element_text(size=12),axis.text.x = element_text(angle=90, vjust=0.2))

marital.s <- function(marriage) {
  marriage <- as.character(marriage)
  if (marriage == "Divorced"|marriage =="Separated" | marriage =="Widowed" ) {
    return("Not-Married")
  } else if (marriage == "Married-AF-spouse" | marriage == "Married-civ-spouse" | marriage == "Married-spouse-absent") {
    return("Married")
  } else {
    return(marriage)
  }
}
A.df$marital <- sapply(A.df$marital, marital.s)
table(A.df$marital)
ggplot(A.df, aes(marital)) +geom_bar(fill = "purple", color = "white", alpha=0.8)+theme_economist()

library(RColorBrewer)
ggplot(A.df, aes(marital)) + geom_bar(aes(fill=income))+ scale_fill_manual(values=c("#74c476","#31a354"))+ theme_economist()

table(A.df$country)

levels(A.df$country)

Asia <- c("Cambodia", "China", "Hong", "Iran", "Japan","India", "Laos","Philippines","Taiwan", "Thailand","Vietnam")

North.American <- c( "Canada", "United-States","Puerto-Rico")

Europe <- c('England' ,'France', 'Germany' ,'Greece','Holand-Netherlands','Hungary','Ireland','Italy','Poland','Portugal','Scotland','Yugoslavia')

Latin.and.South.America <- c('Columbia','Cuba','Dominican-Republic','Ecuador','El-Salvador','Guatemala','Haiti','Honduras','Mexico','Nicaragua','Outlying-US(Guam-USVI-etc)','Peru','Jamaica','Trinadad&Tobago')

Other <- c('South')

Couninet <- function(country){
  if(country %in% Asia) {
    return("Asia")
  } else if(country %in% Europe) {
    return("Europe")
  } else if(country %in% North.American){
    return("North America")
  } else if (country %in% Latin.and.South.America){
    return("Latin.and.South.America")
  }else{
    return("Other")
  }
}

A.df$country <- sapply(A.df$country, Couninet)

table(A.df$country)

str(A.df)

A.df$type_employer <- sapply(A.df$type_employer, factor)
A.df$country <- sapply(A.df$country, factor)
A.df$marital <- sapply(A.df$marital, factor)
str(A.df)

library(Amelia)
A.df[A.df == "?"] <- NA
missmap(A.df, y.at=c(1),y.labels = c(''), legend = T, col = c("yellow", "blue"))

A.df <- na.omit(A.df)
missmap(A.df, y.at=c(1),y.labels = c(''), legend = F, col = c("yellow", "black"))

library(dplyr)
ggplot(A.df) + geom_density(mapping= aes(x=age, fill = as.factor(income)), alpha=0.5) + theme_bw()

ggplot(A.df) + geom_density(mapping= aes(x=hr_per_week, fill = as.factor(income)), alpha=0.5) + theme_bw()
ggplot(A.df,aes(country)) + geom_bar(aes(fill=income))+theme_bw() +
  theme(axis.text.x = element_text(angle =45, hjust = 1))+ geom_smooth(method = "loess", se = FALSE) 

library(caTools)

# Set a random seed
set.seed(101) 
# Split up the sample, basically randomly assigns a booleans to a new column "sample"
sample <- sample.split(A.df$income, SplitRatio = 0.70) # SplitRatio = percent of sample==TRUE
# Training Data
train = subset(A.df, sample == TRUE)
# Testing Data
test = subset(A.df, sample == FALSE)

model.Train <- glm(income ~., family = binomial(logit), data = A.df)
summary(model.Train)

step.model <- step(model.Train)

summary(step.model)

test$income.predicted <- predict(model.Train, newdata = test, type="response")
table(test$income, test$income.predicted >0.5)

print("The accuracy of the model")
(6392+1414)/(528+881+1414+6392)

print("Recall")
6392/(6392+528)

print("Precision")
6392/(6392+881)


  
  