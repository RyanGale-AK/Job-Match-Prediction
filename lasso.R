library("boot")
library("glmnet")
library("caret")
library("matrixStats")


setwd("~/Documents/Git/Job-Match-Prediction")
job_data_v2 = read.csv("dtm_jobs_v2.csv", header =TRUE)

set.seed(1)

#Randomly shuffle the data
shuffledData<-job_data_v2[sample(nrow(job_data_v2)),]

#Create 10 equally size folds
folds <- cut(seq(1,nrow(shuffledData)),breaks=5,labels=FALSE)

A = shuffledData[,12:1827]
X= as.matrix(A)
Y = as.vector(shuffledData$Cat1)

grid = 10^seq(10,-2,length = 100)

cv.error = rep(0,5)

#Perform 5 fold cross validation
for(i in 1:5){
  #Segement your data by fold using the which() function 
  testIndexes <- which(folds==i,arr.ind=TRUE)
  Xtest <- X[testIndexes, ]
  Ytest <- Y[testIndexes]
  Xtrain <- X[-testIndexes, ]
  Ytrain <- Y[-testIndexes]
  
  #lasso.mod = glmnet(X,Y,alpha = 1, lambda =grid, family = "multinomial")
  cv.out=cv.glmnet(Xtrain,Ytrain,alpha=1,lambda=grid, family = "multinomial")
  bestlam=cv.out$lambda.min
  
  lasso.mod=glmnet(Xtrain,Ytrain,alpha=1,lambda=bestlam, family = "multinomial")
  #coef(lasso.mod)
  pred.lasso = inv.logit(predict.cv.glmnet(cv.out,s = bestlam, newx = Xtest, type = "link"))
  pred = c(0,nrow(pred.lasso))
  for(j in 1:nrow(pred.lasso)){
    m= max(pred.lasso[j,,])
    if(pred.lasso[j,1,] == m){pred[j]="Admin"}
    else if(pred.lasso[j,2,] == m){pred[j]="Business"}
    else if(pred.lasso[j,3,] == m){pred[j]="Sales"}
    else{pred[j]="Tech"}
  }
  table= table(pred,Ytest)
  print(table)
  error = 1 - (sum(diag(table))/length(Ytest))
  cv.error[i] = error
}

cv.error
mean_error = mean(cv.error)
lasso.coef = coef(lasso.mod,s=bestlam)
admin = lasso.coef$Admin
admin[which(admin!=0)]
