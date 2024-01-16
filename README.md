# Analyzing EURO Cup 2020

## Dataset
The dataset for the coursework has 6 excel files namely: Match events, Match information, Match line-ups, Match player statistics, Match team statistics, and Pre-match information. Our focus will be on Match player statistics as we need to analyze the Players and Match line-ups to retrieve the role of the players. Match player statistics has 276181 rows and 12 columns. It has information on the player’s performance in every match. The coding language used is R and the libraries used are tidyverse, ggplot2, dplyr, caret, tidyr, fmsb, and randomForest.

## Libraries

- Tidyverse
- Ggplot2
- Dplyr
- Tidyr
- randomForest
- Caret
- FMSB

## Data Wrangling
Data wrangling, also known as data cleaning, pre-processing, or preparation, is the task of preparing and structuring data for analysis. It involves transforming and mapping data from one format or structure to another, which can include cleaning, reshaping, and enriching the data. The goal of data wrangling is to make the data usable and suitable for different forms of analysis, including modelling and visualization. Tasks that are often included are handling missing data, removing duplicate observations, and converting data types. It could also encompass combining multiple datasets, selecting specific subsets of data, or aggregating data by certain variables, visualizing data to gain insights, and storing it in a format that is easy to access and utilize.

The players are categorized into four parts based on their role in the team which are Defenders, Forwards, Midfielders, and Goalkeepers. The Role of the player given in Match line-up dataset and the statistics are given in Match player statistics dataset so we need to clean and merge our data first, for which we use select, group by, filter, and merge functions in the dplyr package to retrieve the needed information and store it in a variable. Further, we filter out the players based on their roles in the team and store them in different variables. We use duplicated function in dplyr library to deal with duplicated data and for the missing Values and NA, we use the na.rm = TRUE argument. Now we have all the information we need. To analyze the statistics of every player, we need a metric. 

One of the main challenges in evaluating player performance is how to combine a range of metrics into a single composite index. One approach is to use statistical techniques, such as weighting the performance measures based on their correlation with team-level match results. However, this method has some limitations and estimation issues. An alternative approach, commonly used in the past, is the "mixed-methods" approach which incorporates expert judgment in the process of combining performance measurements. This approach results in more reliable player ratings, but it can lack transparency and be difficult for decision-makers to understand and use.

So, in order to solve this issue, we used a statistic called Z-Score that gives each attribute equal weight. The Z-score is a popular tool for standardizing performance measurements. The z-score in statistics indicates how many standard deviations a number deviates from the mean. We use the following formula to calculate a z-score:

Z = (X – n) / σ

where:
- X is a single raw data value
- n is the sample mean
- σ is the sample standard deviation

Mean is the average of the given set of values in the dataset.

Standard deviation is the dispersion of a dataset relative to its mean.

![Screenshot 2024-01-16 190542](https://github.com/sahilbharti123/EuroCup-Analysis/assets/70895213/50312738-3d03-41e9-9e11-edbb8b6f72a8)

We selected the attributes mentioned and related to the Technical KPIs in Fig 1. The selected attributes from the dataset are shown in the table below.

![Screenshot 2024-01-16 190542](https://github.com/sahilbharti123/EuroCup-Analysis/assets/70895213/3ec8f8c1-df15-4366-8b1e-4ca86d80984b)

From the individual variables for the 4 different roles, the Z-scores were calculated individually for the KPIs and then added together to form a consolidated score. The functions select, filter, group by, summarise were used to do so. The scores were then arranged in decreasing order and top 4 players were selected from defenders, midfielders, forwards, and top 2 goalkeepers were selected. 

The below players with top Z-scores were selected. 

![image](https://github.com/sahilbharti123/EuroCup-Analysis/assets/70895213/2319ec6b-6975-4474-86b9-021657cd2eb9)

## Recursive feature elimination
Now, let us assess the goal-scoring abilities of our forwards. We first need the variables which affect goal scoring the most. For this, we used Recursive feature elimination because it is effective at selecting those features in a dataset which are most relevant in predicting the target variable. The target variable here is “Goals.” We needed to do a bit of data wrangling to fit the dataset in the model. We had all the variables in rows, we used pivot_wider function in tidyr library to convert the variables into column names. Then, we set all the NA values to 0. We created a new column of whether a player scored a goal or not. 

When performing Recursive Feature Elimination (RFE) in R, we need to choose a method to control the model. We decided to utilize the CARET package, which offers a variety of RFE methods including random forest, naive bayes, bagged trees, and linear regression. We used the Random Forest function (rfFuncs) from the package because it offers an efficient way of calculating feature importance. In R, the set.seed() function is used when creating variables with random values to ensure reproducibility. By using set.seed(), the same random values are generated every time the code is run.
In order to implement this model, we utilized RFE to identify the top attributes. To visualize the importance of each feature in predicting the target variable, we used ggplot to create a bar graph of variable importance for the selected features.

![image](https://github.com/sahilbharti123/EuroCup-Analysis/assets/70895213/b4881821-1f52-4fd7-a144-5e9857267d7f)

The bar graph shows that “Attempts on target in penalty area” is the most important feature followed by “Attempts accuracy.” 

## Logistic Regression
In order to predict the probability of goal scoring, we will use Logistic Regression, a statistical model commonly used for classification and prediction. The model calculates the probability of an event, such as "yes" or "no", based on the provided independent variables. In this case, the dependent variable "Goals" will be between 0 and 1, as it is a probability outcome. Logistic Regression is a type of generalised linear model and can be implemented in R using the glm() function, which returns a model object that can be further analyzed using summary(), fitted(), and predict() functions.
We fitted the model in Logistic regression and used predict () function to finally predict the probability of our forwards scoring a goal. 

## Result
We came out with our top-performing players of the tournament which are shown below. As you can see, Lorenzo Insigne was our top forward with a Z-Score of 57.83 followed by Pedri whose Z-Score is 51.31. Raheem Sterling and Memphis Depay were our 3rd and 4th forwards with a Z-Score of 41.25 and 40.51 respectively. Marco Verratti was our top Midfielder with a Z-Score of 35.44 followed by Dani Olmo who had a Z-score of 27.27. The third and fourth midfielders were Mason Mount and Pierre-Emile Hojbjerg with Z-Score of 27.33 and 25.17 respectively. Mykola Matviyenko was the top defender with a Z-Score of 16.73 followed by Tomas Kalas, Harry Maguire, and Aymeric Laporte who had Z-Scores of 14.61, 14.12, and 14.11 respectively. Jordan Pickford and Gianluigi Donnarumma are the top two goalkeepers with a Z-Score of 16.57 and 9.37 respectively.

![image](https://github.com/sahilbharti123/EuroCup-Analysis/assets/70895213/db75e92f-f544-47bc-a19b-86ed7ec081d0)

The Pie Chart shows the proportion of goals scored by top 10 forwards in the tournament. It shows that Ronaldo scored the greatest number of goals followed by Kane and Sterling. A notable feature is that Ronaldo who scored the maximum number of goals in the tournament (5) is not in our top four forwards whereas Pedri, who did not score any goal is in our top 4. 

![image](https://github.com/sahilbharti123/EuroCup-Analysis/assets/70895213/db1ca3d7-3481-43b2-984a-8707cfb1521d)

In the above figure, we notice that our top 4 defenders Laporte, Maguire, Kalas and Matviyenko were consistent in every skill which is the reason they had a good Z-Score. Players like Di Lorenzo whose Sprinting was outstanding and Stones whose Pass accuracy was excellent did not make to the top 4 because they underperformed in other skills like Clearances and Tackles Won. 
If we see our top Goalkeepers, Pickford and Donnaruma (who was also the Player of the tournament) as per UEFA, Pickford had the highest number of Punches, Low Claims, Clearances, and successful clearances whereas Donnaruma had the highest number of High claims and second highest number of Punches. 
 
![image](https://github.com/sahilbharti123/EuroCup-Analysis/assets/70895213/6d44b7c6-3c08-4300-b055-fe5ad62117d1)

For analyzing the goal-scoring ability of our forwards, we used Logistic regression. We already know the Key performance indicators for Goal scoring using the RFE technique. When we applied Logistic regression to our selected indicators, we noticed that as per the model (Table 6), only three variables are statistically significant i.e. (whose p-value or Pr(|z|) is less than 0.05). Now, looking at Table 6, we see the coefficients of regression which are our KPIs, Goal scoring opportunity increases with an increase in “Attempts on target in penalty area”, “Attempts accuracy”, “Attempts on target”, “Attempts in open play from the centre”, “Attempts in open play”, “Lost balls in opposite half” and “Sprints” whereas it decreases with increase in “Total attempts.” We can observe this with the negative or positive sign from each coefficient. 
Next, we need to know how each KPI contributes to the achievement of our goals. We will change it for this by exponentiating the result (as shown in Table 7). This demonstrates that, while controlling for other variables, goal scoring increases by a factor of 2.01 for a single attempt on target and falls by 65% for an increase in total attempts.

![image](https://github.com/sahilbharti123/EuroCup-Analysis/assets/70895213/7a2a7b7a-1f3c-47ef-9e36-f23f43ef17fd)

Using the Predict () function we find the Probabilities of the top 4 forwards scoring a goal as shown in the figure below. 

![image](https://github.com/sahilbharti123/EuroCup-Analysis/assets/70895213/b2d351a7-9c71-4533-b699-3607abf55a1d)

The ratio of deviance to residual degrees of freedom (deviance(fit)/df.residual(fit)) is used in statistical modeling to assess the fit of a model. The value suggests that the model is able to explain a significant proportion of the variation in the data.

## Conclusion
Our Goal was to come up with the top-performing team of the tournament which we were able to do successfully. We selected the top 14 players across various roles in the sport. Seven of the selected fourteen players were from the finalist teams of the tournament Italy and England which shows the dominance of the teams in the tournament. We visualized the skills of the players and noticed that consistency in every skill is more important than being excellent in one and below average in others. We can see that the Probability of goal scoring varies from 99% to 8% which is strange but also highlights the point in the introduction in which we mentioned that every skill has equal weightage in the game, goal scoring cannot be considered the only factor in analyzing a forward. 

## Limitations
In this study, we evaluated players using a limited number of KPIs, which might affect the accuracy of the predictions. Attributes such as strength, power, and speed were not taken into account. To make more precise predictions about goals scored, additional data such as distance and angle to the goal would have been beneficial. We used Logistic Regression to estimate the probability of a goal being scored, a model that can only predict binary outcomes (i.e. yes/no, 0/1, true/false), and not the exact number of goals a player will score. However, Logistic Regression has the limitation of assuming that the relationship between the independent and dependent variable is linear which can be untrue in certain situations. It is also sensitive to outliers and extreme values. We also employed Z-scores as a metric, which doesn't take into account the specifics of the dataset like range or frequency distribution. Z-scores are based on population data, when sample data is used the results may differ. To identify the most pertinent features for our target variable 'Goals' Recursive Feature Elimination (RFE) was used. Although, this model has the drawback of identifying redundant features among many independent variables. Additionally, RFE uses only one model, if the best feature subset changes across different models then the feature selection may change too.
