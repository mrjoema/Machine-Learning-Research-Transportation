library(R.matlab)
# <- replaced by =
x<-readMat('USPS_all.mat')
x$gnd
x_g<-x$gnd
x_f<-x$fea
data<-data.frame(x_g,x_f)
xtrain<-data[1:7291,]
xval<-data[7292:nrow(data),]
# Selecting K based on missclassification criteria. xval stands for valization set
k_best<-function(xtrain,xval){
  # can use distance weight function in matlab
  distances<-apply(xval[,-1],1,function(i,xtrain){
    apply(xtrain[,-1],1,function(j){
      sqrt(sum((i-j)^2))
    })
  },xtrain=xtrain) 
  cla<-xtrain[,1]
  # sapply is a built-in function, you can replace it with for loop
  misclassifier<-sapply(seq(2:20),function(k){
    mhat<-sapply(seq(1:ncol(distances)), function(i){
      nbs<-order(distances[,i])[1:k]
      return(round(mean(cla[nbs])))
    })
    return(sum(mhat!=xval[,1])/length(mhat))
  })
  k_opt<-which.min(misclassifier)+1
  return(k_opt)
}
# Best K
k_best(xtrain,xval)
# prediction: Different values of K
predict1<-knn(train[,-1],val[,-1],train[,1],k=2)
predict2<-knn(train[,-1],val[,-1],train[,1],k=3)
predict3<-knn(train[,-1],val[,-1],train[,1],k=4)
# accuracy
mean( predict1== val$digit)
mean( predict2== val$digit)
mean( predict3== val$digit)

#confusion matrix
table(predict=predict1, Actual=val$digit)
table(predict=predict2, Actual=val$digit)
table(predict=predict3, Actual=val$digit)