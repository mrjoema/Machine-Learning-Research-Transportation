from sklearn import svm
svc = svm.SVC(kernel='linear')
svc.fit(iris.data, iris.target)
SVC(...)