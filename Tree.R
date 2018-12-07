library(tree)
library(randomForest)

setwd("~/Documents/Git/Job-Match-Prediction")

job_data_v2 = read.csv("dtm_jobs_v2.csv", header =TRUE)
set.seed(1)

#Randomly shuffle the data
shuffledData<-job_data_v2[sample(nrow(job_data_v2)),]

#Create 10 equally size folds

X = shuffledData[,12:1827]

Y = as.vector(shuffledData$Cat2)
Y = as.factor(Y)

data = data.frame(Y,X)

cv.error = rep(0,5)
folds <- cut(seq(1,nrow(shuffledData)),breaks=5,labels=FALSE)

for(i in 1:5){
  #Segement your data by fold using the which() function 
  testIndexes <- which(folds==i,arr.ind=TRUE)
  train <- which(folds!=i,arr.ind=TRUE)
  job.test = Y[testIndexes]
  rf.job = randomForest(y=Y[train],x=X[train,], importance = TRUE, ntree=50)
  rf.job
  yhat.rf = predict(rf.job, newdata = X[testIndexes,])
  table= table(yhat.rf,job.test)
  print(table)
  error = 1 - (sum(diag(table))/length(job.test))
  cv.error[i] = error
}


mean(cv.error)
varUsed(rf.job,count=TRUE)
import = importance(rf.job, type =1)
