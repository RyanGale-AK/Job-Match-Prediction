###Tree method code 
library(tree)
library(randomForest)

setwd("~/Documents/Git/Job-Match-Prediction")
job_data = read.csv("dtm_jobs.csv", header =TRUE)

set.seed(1)

#Randomly shuffle the data
shuffledData<-job_data[sample(nrow(job_data)),]

#Create 10 equally size folds
#folds <- cut(seq(1,nrow(shuffledData)),breaks=5,labels=FALSE)

X = shuffledData[,11:1814]
#X = job_data[,11:1814]

Y = as.vector(shuffledData$Category)
Y = as.factor(Y)

data = data.frame(Y,X)

# tree.job = tree(Y~X, data = data)
# summary(tree.job)
# plot(tree.job)
# 
# cv.tree.job = cv.tree(tree.job)
# prune.job = prune.tree(tree.job,best=5)

#train = sample(nrow(data), (nrow(data))*.75)

cv.error = rep(0,5)
folds <- cut(seq(1,nrow(shuffledData)),breaks=5,labels=FALSE)

for(i in 1:5){
  #Segement your data by fold using the which() function 
  testIndexes <- which(folds==i,arr.ind=TRUE)
  train <- which(folds!=i,arr.ind=TRUE)
  job.test = Y[testIndexes]
  bag.job = randomForest(x=X, y=Y, subset = train, importance = TRUE, ntree=50)
  bag.job
  yhat.bag = predict(bag.job, newdata = X[testIndexes,])
  table= table(yhat.bag,job.test)
  print(table)
  error = 1 - (sum(diag(table))/length(job.test))
  cv.error[i] = error
}


mean(cv.error)
varUsed(bag.job,count=TRUE)
