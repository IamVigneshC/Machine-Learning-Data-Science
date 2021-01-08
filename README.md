# Machine-Learning-Data-Science

Machine learning algorithms build a model based on sample data, known as "training data", in order to make predictions or decisions without being explicitly programmed

- Train the ML methods
- Test the ML methods

We predict using different ML methods and document and results.

__Confusion matrix__ helps to compare different ML methods and decide which performs best. We represent the training and testing data and document the actuals vs predicted in a matrix form depending on the number of parameters involved

Cross Validation is used to decide which machine learning method would be best for our dataset.

__Sensitivity and Specificity__

- Sensitivity measures the proportion of positives that are correctly identified (i.e. the proportion of those who have some condition (affected) who are correctly identified as having the condition)
- Specificity measures the proportion of negatives that are correctly identified (i.e. the proportion of those who do not have the condition (unaffected) who are correctly identified as not having the condition)

__Bias and Variance__

- The inability of a ML method to capture the true relationship is called Bias
- The difference in fits between data sets is called Variance (training vs testing data)

__ROC and AUC__

ROC (Receiver Operator Characteristic) graphs and AUC (the area under the curve), are useful for consolidating the information from a ton of confusion matrices into a single, easy to interpret graph.

- ROC curve makes it easy to identify the best threshold for making a decision
- AUC helps in deciding which categorization methos is better
