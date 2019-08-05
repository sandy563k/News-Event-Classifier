#installing wordcloud , textmining and e0171(Naive Bayes model) packages
install.packages("wordcloud")
install.packages("tm")
install.packages("e1071")
library(e1071)
library(tm)
library(gmodels)
library(wordcloud)
library(RColorBrewer)
library(readr)
#data collection
event <- read_csv("~/Music/mycoursedocs/AIR/MLEventData/Final_training.csv")
View(event)
library(readr)
FINAL_FEATURES <- read_csv("~/Music/mycoursedocs/AIR/MLEventData/FINAL_FEATURES.csv")
View(FINAL_FEATURES)
FINAL_FEATURES <- FINAL_FEATURES$FINAL_FEATURES
#data preparation
events_raw <- event
FINAL_FEATURES <- unlist(FINAL_FEATURES)
FINAL_FEATURES <- unique(FINAL_FEATURES)
str(events_raw)
events_raw$EVENT_TYPE <- factor(events_raw$EVENT_TYPE)
str(events_raw$EVENT_TYPE)
table(events_raw$EVENT_TYPE)
str(events_raw$EVENT_TYPE)
table(events_raw$EVENT_TYPE)
#Generating corpus(collection of text documents)
events_corpus <- VCorpus(VectorSource(events_raw$ARTICLE_SUMMARY_LEMMA))
print(events_corpus)
inspect(events_corpus[1:2])
events_corpus_clean <- tm_map(events_corpus,stripWhitespace)
events_dtm <- DocumentTermMatrix(events_corpus_clean)
events_dtm
#splitting the data into train and test data
events_dtm_train <- events_dtm[1:55,]
events_dtm_test <- events_dtm[56:76,]
str(FINAL_FEATURES)
events_dtm_train <- events_dtm[1:55,]
events_dtm_test <- events_dtm[56:76,]
events_train_labels <- events_raw[1:55,]$EVENT_TYPE
events_test_labels <- events_raw[56:76,]$EVENT_TYPE
prop.table(table(events_train_labels))
prop.table(table(events_test_labels))
str(FINAL_FEATURES)
events_dtm_freq_train <- events_dtm_train[,FINAL_FEATURES]
events_dtm_freq_train <- events_dtm_train[,FINAL_FEATURES]
FINAL_FEATURES <- unlist(FINAL_FEATURES)
events_dtm_freq_train <- events_dtm_train[,FINAL_FEATURES]
events_dtm_freq_test <- events_dtm_test[,FINAL_FEATURES]
convert_counts <- function(x) {
x <- ifelse(x > 0, "Yes", "No")
}
events_train <- apply(events_dtm_freq_train,MARGIN=2,convert_counts)
events_test <- apply(events_dtm_freq_test,MARGIN=2,convert_counts)
#performing classification on train data
events_classifier <- naiveBayes(events_train,events_train_labels)
#performing prediction on test data
events_test_pred <- predict(events_classifier,events_test)
events_test_pred
#performance evaluation
CrossTable(events_test_pred,events_test_labels,prop.chisq=FALSE,prop.t=FALSE, dnn = c('predicted','actual'))
events_test_pred
events_test_labels

