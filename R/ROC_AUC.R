library(pROC) # install with install.packages("pROC")
library(randomForest) # install with install.packages("randomForest")

#######################################
## Example: Modified - Thanks to StatQuest
## Generate exam learning time and result datasets.
##
#######################################
set.seed(420) # this will make my results match yours

num.samples <- 100

## generate 100 values from a normal distribution with
## mean 50 and standard deviation 12, then sort them
 <- sort(rnorm(n=num.samples, mean=50, sd=12))

## Now we will decide if a sample is pass or not. 
## NOTE: This method for classifying a sample as pass or not
## was made up just for this example.
## rank(elearn) returns 1 for the least time spent, 2 for the second least time, ...
##              ... and it returns 100 for the highest time spent
## So what we do is generate a random number between 0 and 1. Then we see if
## that number is less than rank/100. So, for the least sample, rank = 1.
## This sample will be classified "pass" if we get a random number less than
## 1/100. For the second least sample, rank = 2, we get another random
## number between 0 and 1 and classify this sample "pass" if that random
## number is < 2/100. We repeat that process for all 100 samples
pass <- ifelse(test=(runif(n=num.samples) < (rank(elearn)/num.samples)), 
  yes=1, no=0)
pass ## print out the contents of "pass" to show us which samples were
      ## classified "pass" with 1, and which samples were classified
      ## "not pass" with 0.

## plot the data
plot(x=elearn, y=pass)

## fit a logistic regression to the data...
glm.fit=glm(pass ~ elearn, family=binomial)
lines(elearn, glm.fit$fitted.values)


#######################################
##
## draw ROC and AUC using pROC
##
#######################################

## NOTE: By default, the graphs come out looking terrible
## The problem is that ROC graphs should be square, since the x and y axes
## both go from 0 to 1. However, the window in which I draw them isn't square
## so extra whitespace is added to pad the sides.
roc(pass, glm.fit$fitted.values, plot=TRUE)

## Now let's configure R so that it prints the graph as a square.
##
par(pty = "s") ## pty sets the aspect ratio of the plot region. Two options:
##                "s" - creates a square plotting region
##                "m" - (the default) creates a maximal plotting region
roc(pass, glm.fit$fitted.values, plot=TRUE)

## NOTE: By default, roc() uses specificity on the x-axis and the values range
## from 1 to 0.  To use 1-specificity (i.e. the 
## False Positive Rate) on the x-axis, set "legacy.axes" to TRUE.
roc(pass, glm.fit$fitted.values, plot=TRUE, legacy.axes=TRUE)

## If you want to rename the x and y axes...
roc(pass, glm.fit$fitted.values, plot=TRUE, legacy.axes=TRUE, percent=TRUE, xlab="False Positive Percentage", ylab="True Postive Percentage")

## We can also change the color of the ROC line, and make it wider...
roc(pass, glm.fit$fitted.values, plot=TRUE, legacy.axes=TRUE, percent=TRUE, xlab="False Positive Percentage", ylab="True Postive Percentage", col="#377eb8", lwd=4)

## If we want to find out the optimal threshold we can store the 
## data used to make the ROC graph in a variable...
roc.info <- roc(pass, glm.fit$fitted.values, legacy.axes=TRUE)
str(roc.info)

## and then extract just the information that we want from that variable.
roc.df <- data.frame(
  tpp=roc.info$sensitivities*100, ## tpp = true positive percentage
  fpp=(1 - roc.info$specificities)*100, ## fpp = false positive precentage
  thresholds=roc.info$thresholds)

head(roc.df) ## head() will show us the values for the upper right-hand corner
             ## of the ROC graph, when the threshold is so low 
             ## (negative infinity) that every single sample is called "pass".
             ## Thus TPP = 100% and FPP = 100%

tail(roc.df) ## tail() will show us the values for the lower left-hand corner
             ## of the ROC graph, when the threshold is so high (infinity) 
             ## that every single sample is called "not pass". 
             ## Thus, TPP = 0% and FPP = 0%

## now let's look at the thresholds between TPP 60% and 80%...
roc.df[roc.df$tpp > 60 & roc.df$tpp < 80,]

## We can calculate the area under the curve...
roc(pass, glm.fit$fitted.values, plot=TRUE, legacy.axes=TRUE, percent=TRUE, xlab="False Positive Percentage", ylab="True Postive Percentage", col="#377eb8", lwd=4, print.auc=TRUE)

## ...and the partial area under the curve.
roc(pass, glm.fit$fitted.values, plot=TRUE, legacy.axes=TRUE, percent=TRUE, xlab="False Positive Percentage", ylab="True Postive Percentage", col="#377eb8", lwd=4, print.auc=TRUE, print.auc.x=45, partial.auc=c(100, 90), auc.polygon = TRUE, auc.polygon.col = "#377eb822")


#######################################
##
## Now let's fit the data with a random forest...
##
#######################################
rf.model <- randomForest(factor(pass) ~ elearn)

## ROC for random forest
roc(pass, rf.model$votes[,1], plot=TRUE, legacy.axes=TRUE, percent=TRUE, xlab="False Positive Percentage", ylab="True Postive Percentage", col="#4daf4a", lwd=4, print.auc=TRUE)


#######################################
##
## Now layer logistic regression and random forest ROC graphs..
##
#######################################
roc(pass, glm.fit$fitted.values, plot=TRUE, legacy.axes=TRUE, percent=TRUE, xlab="False Positive Percentage", ylab="True Postive Percentage", col="#377eb8", lwd=4, print.auc=TRUE)

plot.roc(pass, rf.model$votes[,1], percent=TRUE, col="#4daf4a", lwd=4, print.auc=TRUE, add=TRUE, print.auc.y=40)
legend("bottomright", legend=c("Logisitic Regression", "Random Forest"), col=c("#377eb8", "#4daf4a"), lwd=4)


#######################################
##
## Now that we're done with our ROC fun, let's reset the par() variables.
## There are two ways to do it...
##
#######################################
par(pty = "m")
