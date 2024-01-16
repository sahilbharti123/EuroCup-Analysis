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
•	X is a single raw data value
•	n is the sample mean
•	σ is the sample standard deviation

Mean is the average of the given set of values in the dataset.
Standard deviation is the dispersion of a dataset relative to its mean.


