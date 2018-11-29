library("boot")
library("glmnet")
setwd("~/Documents/Git/Job-Match-Prediction")
job_data = read.csv("dtm_jobs.csv", header =TRUE)

X= job_data[,10:9577]
X <- data.frame(apply(X, 2, as.factor))

Y = as.vector(job_data$Category)
#Y2 = lapply(Y1, as.factor)

#data = cbind(X2, Y)

#X = model.matrix(Y ~ ., data = data)[,-1]

set.seed(1)
grid = 10^seq(10,-2,length = 100)
lasso.mod = glmnet(X,Y,alpha = 1, lambda = .1, family = "multinomial")

#cv.out=cv.glmnet(X_train,Ytrain1,alpha=1,lambda=grid) #10 fold cross validation bestlam=cv.out$lambda.min
#bestlam
#lasso.mod=glmnet(X_train,Ytrain1,alpha=1,lambda=bestlam)
#coef(lasso.mod)[,1]