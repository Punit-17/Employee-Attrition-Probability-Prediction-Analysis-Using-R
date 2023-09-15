library(randomForest)
library(ggplot2)
library(dplyr)
library(tree)
library(cvTools)

setwd("D:\\IITK DATA ANALYTICS\\Final Projects\\Human Resources Project")
getwd()

hr_train = read.csv("hr_train.csv")
hr_test = read.csv("hr_test.csv")

hr_test$left = NA

hr_train$data = 'train'
hr_test$data = 'test'

hr_all = rbind(hr_train,hr_test)

#

glimpse(hr_all)

table(hr_all$sales)
table(hr_all$salary)

# create dummies function code

CreateDummies = function(data,var,freq_cutoff=0){
  t = table(data[,var])
  t = t[t>freq_cutoff]
  t = sort(t)
  
  for (cat in names(t)) {
    name = paste(var,cat,sep = "_")
    name = gsub(" ","",name)
    name = gsub("-","_",name)
    name = gsub("\\?","Q",name)
    name = gsub("<","LT_",name)
    name = gsub("\\+","",name)
    
    data[,name] = as.numeric(data[,var]==cat)
  }
  
  data[,var]=NULL
  return(data)
}


# use function on categorical variables
glimpse(hr_all)

hr_all = CreateDummies(hr_all,"salary",)
hr_all = CreateDummies(hr_all, "sales",)

glimpse(hr_all)

# check for NA Values
lapply(hr_all,function(hr_all) sum(is.na(hr_all)))


# Separate train and test set
hr_train=hr_all %>% filter(data=='train') %>% select(-data)
hr_test=hr_all %>% filter(data=='test') %>% select(-data,-left)


# Split train data for model testing 
set.seed(2)
s=sample(1:nrow(hr_train),0.7*nrow(hr_train))
hr_train1=hr_train[s,]
hr_train2=hr_train[-s,]


# Building a Decision Tree
hr.tree = tree(left~.,data = hr_train1)

# View Tree in text
hr.tree

#Visualize tree
plot(hr.tree)
text(hr.tree)

# Performance on validation set
val.left = predict(hr.tree, data = hr_train2)
val.left

rmse_val_left =((val.left)-(hr_train2$left))^2 %>% mean() %>% sqrt()
rmse_val_left

# Final model and test performance on entire test data
hr.tree.final = tree(left~.,data = hr_train)
test.pred = predict(hr.tree.final, newdata = hr_test)
write.csv(test.pred,"Punit_Alkunte_P4_P2.csv", row.names = F)



##### Classification Tree ######

hrc_train = read.csv("hr_train.csv")
hrc_test = read.csv("hr_test.csv")

hrc_test$left = NA

hrc_train$data = 'train'
hrc_test$data = 'test'

hrc_all = rbind(hrc_train,hrc_test)

glimpse(hrc_all)

hrc_all = CreateDummies(hrc_all,"salary",)
hrc_all = CreateDummies(hrc_all, "sales",)


# check for NA Values
lapply(hrc_all,function(hrc_all) sum(is.na(hrc_all)))

# convert response variable to factor type
hrc_all$left = as.factor(hrc_all$left)

# Separate train and test set
hrc_train=hrc_all %>% filter(data=='train') %>% select(-data)
hrc_test=hrc_all %>% filter(data=='test') %>% select(-data,-left)


# Split train data
set.seed(2)
s=sample(1:nrow(hrc_train),0.8*nrow(hrc_train))
hrc_train1=hrc_train[s,]
hrc_train2=hrc_train[-s,]

# Building tree
names(hrc_train1)
hrc.tree = tree(left~.,data = hrc_train1)

formula(hrc.tree)
library(car)
vif(hrc.tree)

# View Tree in text
hrc.tree

#Visualize tree
plot(hrc.tree)
text(hrc.tree)

# Performance on validation set
val.hrc = predict(hrc.tree,  newdata = hrc_train2, type = 'vector')[,1]
pROC::roc(hrc_train2$left,val.hrc)$auc


# Build model on test data
hrc.tree.final = tree(left~., data = hrc_train)


# performance on test data
test.score = predict(hrc.tree.final, newdata = hrc_test, type = 'vector')[,1]

write.csv(test.score,"Punit_Alkunte_P4_P2.csv", row.names = F)



### RANDOM FOREST ####

param=list(mtry=c(3,4,5),
           ntree=c(100,200,500),
           maxnodes=c(5,10,15,20),
           nodesize=c(1,5,10))
param

3*3*4*3

# Function to select random subsets
subset_paras=function(full_list_para,n=10){
  all_comb=expand.grid(full_list_para)
  s=sample(1:nrow(all_comb),n)
  subset_para=all_comb[s,]
  return(subset_para)
}

num_trials=17
my_params=subset_paras(param,num_trials)

lapply(hrc_train,function(hrc_train) sum(is.na(hrc_train)))
# CV Tuning
library(randomForest)
library(cvTools)
library(dplyr)
glimpse(hrc_train)

myerror=9999999

for(i in 1:num_trials){
  
  print(paste0('starting iteration:',i))
  params=my_params[i,]
  k = cvTuning(randomForest,left~.,
             data = hrc_train,
             tuning =params,
             folds = cvFolds(nrow(hrc_train), K=10, type = "random"),
             seed = 2
  )
  score.this=k$cv[,2]
  
  if(score.this < myerror){
   print(params)
    myerror=score.this
    print(myerror)
    
    best_params=params
  }
  print('DONE')
  
}

