###Tree method code 
setwd("~/Documents/Git/Job-Match-Prediction")
job_data = read.csv("dtm_jobs.csv", header =TRUE)

set.seed(1)

#Randomly shuffle the data
shuffledData<-job_data[sample(nrow(job_data)),]

#Create 10 equally size folds
folds <- cut(seq(1,nrow(shuffledData)),breaks=5,labels=FALSE)

A = shuffledData[,11:1814]
X= as.matrix(A)
Y = as.vector(shuffledData$Cat1)

library(tree)
data = data.frame(X,Y)

tree.job = tree(Y~X, data = data)
summary(tree.job)
plot(tree.job)

cv.tree.job = cv.tree(tree.job)
prune.job = prune.tree(tree.job,best=5)

# train = sample(nrow(data), (nrow(data))/2)
# job.test = data[-train,]
# 
# library(randomForest)
# bag.job = randomForest(Y~X, data = data, subset = train, mtry = 50, importance = TRUE)
# bag.job
# yhat.bag = predict(bag.job, newdata = data[-train,])
# mean((yhat.bag - job.test)^2)
# 
# bag.job = randomForest(Y~X, data = data, subset = train, mtry = 50, ntree = 50)
# bag.job
# yhat.bag = predict(bag.job, newdata = data[-train,])
# mean((yhat.bag - job.test)^2)
# rf.job = randomForest(Y~X, data = data, subset = train, mtry = 50, importance = TRUE)

