# Analyzing EURO Cup 2020

## Dataset
The dataset for the coursework has 6 excel files namely: Match events, Match information, Match line-ups, Match player statistics, Match team statistics, and Pre-match information. Our focus will be on Match player statistics as we need to analyze the Players and Match line-ups to retrieve the role of the players. Match player statistics has 276181 rows and 12 columns. It has information on the player’s performance in every match. The coding language used is R and the libraries used are tidyverse, ggplot2, dplyr, caret, tidyr, fmsb, and randomForest.

## Libraries

•	Tidyverse: Tidyverse is a collection of essential R packages for data science. The variety of packages in the tidyverse makes it easier for us to use and interact with the data. You can use your data for many things, such as subsetting, transformation, visualization, and other things. (What Is Tidyverse | Tidyverse Package in R, 2019)
•	Ggplot2: The Grammar of Graphics serves as the foundation for ggplot, a system for declaratively constructing graphics. (Create Elegant Data Visualisations Using the Grammar of Graphics, 2019)
•	Dplyr: A fast, consistent tool for working with data frame like objects, both in memory and out of memory (Wickham et al., 2020).
•	Tidyr: With tidyr, you may make data where each column represents a variable, each row represents an observation, and each cell holds a single value. Deeply nested lists can be converted into rectangular data frames using the "rectangling" feature in "tidyr," as well as values from string columns using the "pivoting" and "unnesting" capabilities. It also has resources for dealing with values that are missing. (Wickham et al., 2020).
•	randomForest: To construct random forests or a lot of decision trees, the package "randomForest" is utilized. Each decision tree receives data from every observation. The final output is the result that corresponds to each observation the most frequently.
•	Caret: The Caret package, which stands for Classification and Regression Training, is a collection of tools for data-splitting, pre-processing, feature selection, model tuning using resampling, variable importance estimation, and other functions intended to speed up the process of developing predictive models. (Kuhn, 2008) 
•	FMSB: The FMSB package stands for Functions for Medical Statistics Book with some Demographic data. (Nakazawa, 2022) We have used it to create a radar chart. 

2.2 Data Wrangling:
Data wrangling, also known as data cleaning, pre-processing, or preparation, is the task of preparing and structuring data for analysis. It involves transforming and mapping data from one format or structure to another, which can include cleaning, reshaping, and enriching the data. The goal of data wrangling is to make the data usable and suitable for different forms of analysis, including modelling and visualization. Tasks that are often included are handling missing data, removing duplicate observations, and converting data types. It could also encompass combining multiple datasets, selecting specific subsets of data, or aggregating data by certain variables, visualizing data to gain insights, and storing it in a format that is easy to access and utilize. 
The players are categorized into four parts based on their role in the team which are Defenders, Forwards, Midfielders, and Goalkeepers. The Role of the player given in Match line-up dataset and the statistics are given in Match player statistics dataset so we need to clean and merge our data first, for which we use select, group by, filter, and merge functions in the dplyr package to retrieve the needed information and store it in a variable. Further, we filter out the players based on their roles in the team and store them in different variables. We use duplicated function in dplyr library to deal with duplicated data and for the missing Values and NA, we use the na.rm = TRUE argument. Now we have all the information we need. To analyze the statistics of every player, we need a metric. 
One of the main challenges in evaluating player performance is how to combine a range of metrics into a single composite index. One approach is to use statistical techniques, such as weighting the performance measures based on their correlation with team-level match results. However, this method has some limitations and estimation issues. An alternative approach, commonly used in the past, is the "mixed-methods" approach which incorporates expert judgment in the process of combining performance measurements. This approach results in more reliable player ratings, but it can lack transparency and be difficult for decision-makers to understand and use. (billyg1958, 2016)
So, in order to solve this issue, we used a statistic called Z-Score that gives each attribute equal weight. The Z-score is a popular tool for standardizing performance measurements. (billyg1958, 2016). The z-score in statistics indicates how many standard deviations a number deviates from the mean. (Zach, 2020). We use the following formula to calculate a z-score:
Z = (X – n) / σ
where:
•	X is a single raw data value
•	n is the sample mean
•	σ is the sample standard deviation

Mean is the average of the given set of values in the dataset.
Standard deviation is the dispersion of a dataset relative to its mean.

As the requirement of all the roles in football is different, so we need to use different sets of attributes to assess each role. Our job was made easier by Michael Hughes who came up with the Key Performance Indicators (Fig 1) for every role in football in his analysis. 
Defenders: The main role of a defender is to block the opposite team’s attack and prevent them from scoring a goal. (Nigel Koay talks Football, 2022)

Midfielders: The main role of a midfielder is to help with the transitional play. We will be considering both the attacking as well as defensive attributes. Passing is the most important trait for a midfielder. (Ramesh, 2022)

Forwards: A forward is responsible for the team’s offense including goals, chance creation, and build-up play. (What Is an Attacker (Positions and Skills) Soccerblade, 2022)

Goalkeepers: A goalkeeper is undoubtedly the most important player in a team’s defense. ‘His main job is to stop the opposite team to score a goal.’ (Madrid, 2022)

