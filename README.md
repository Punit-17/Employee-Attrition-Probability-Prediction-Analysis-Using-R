# Employee-Attrition-Probability-Prediction-Analysis-Using-R

## Overview

This project predicts employee attrition within a organization and understand why our best and most experienced employees are leaving prematurely. The dataset provided contains various features related to employees, including satisfaction levels, last evaluations, number of projects, average monthly hours, and more. The project can be divided into two main phases:

1. **Regression Tree Model**: I initially built a regression tree model to predict employee attrition and achieved a Root Mean Squared Error **(RMSE) value of 0.56.**

2. **Classification Tree Model**: To improve performance, I then developed a classification tree model. This model achieved a significantly higher Area Under the Curve **(AUC) score of 0.83.**

## Data

- **`hr_train.csv`**: This dataset was used to train the predictive models. It includes features such as employee satisfaction levels, last evaluations, number of projects, and the target variable 'left' (indicating whether an employee left the company).

- **`hr_test.csv`**: This dataset contains the same features as `hr_train.csv`, except it lacks the 'left' variable. The model developed in this project was used to predict attrition for this dataset.

## Models

### Regression Tree

- Model Type: Regression Tree
- RMSE Value: 0.56
- Performance: The regression tree model provided insights into the factors contributing to attrition but had limited predictive accuracy.

### Classification Tree

- Model Type: Classification Tree
- AUC Score: 0.83
- Performance: The classification tree model significantly improved predictive accuracy, making it more suitable for predicting employee attrition.

## Usage

1. **Data Preparation**: Ensure that you have both `hr_train.csv` and `hr_test.csv` datasets available.

2. **Code**: You can find the code used to develop the regression and classification tree models in this project's repository.

3. **Predictions**: Predictions for the `hr_test.csv` dataset using the classification tree model have been stored in a CSV file named `**Punit_Alkunte_P4_P2.csv**`.

## Conclusion

My analysis reveals that a classification tree model with an AUC score of 0.83 provides valuable insights into employee attrition and can be used to predict which valuable employees are at risk of leaving the organization. Further actions can be taken based on these predictions to retain and engage employees effectively.

For more details and code implementation, please refer to this project's GitHub repository.


# Thankyou
