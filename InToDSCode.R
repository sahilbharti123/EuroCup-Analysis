
#Loading the datasets from excel


match_events<-read.csv("C:/Users/SAHIL BHARTI/Desktop/Msc DS Coursework/InToDS/UEFA Euro 2020/cervus-uefa-euro-2020/Match events.csv")
View(match_events)

match_information<-read.csv("C:/Users/SAHIL BHARTI/Desktop/Msc DS Coursework/InToDS/UEFA Euro 2020/cervus-uefa-euro-2020/Match information.csv")
View(match_information)

match_lineup<-read.csv("C:/Users/SAHIL BHARTI/Desktop/Msc DS Coursework/InToDS/UEFA Euro 2020/cervus-uefa-euro-2020/Match line-ups.csv")
View(match_lineup)

match_player_stat<-read.csv("C:/Users/SAHIL BHARTI/Desktop/Msc DS Coursework/InToDS/UEFA Euro 2020/cervus-uefa-euro-2020/Match player statistics.csv")
View(match_player_stat)

match_team_stat<-read.csv("C:/Users/SAHIL BHARTI/Desktop/Msc DS Coursework/InToDS/UEFA Euro 2020/cervus-uefa-euro-2020/Match team statistics.csv")
View(match_team_stat)

pre_match_info<-read.csv("C:/Users/SAHIL BHARTI/Desktop/Msc DS Coursework/InToDS/UEFA Euro 2020/cervus-uefa-euro-2020/Pre-match information.csv")
View(pre_match_info)


TotalGoals<-match_player_stat[match_player_stat$StatsName=="Goals",]
view(TotalGoals)

#Installing the essential packages 

install.packages("tidyverse")
install.packages("fmsb")
install.packages("caret")
install.packages("randomForestSRC")
install.packages("randomForest")

#Calling the libraries

library(tidyverse)
library(ggplot2)
library(dplyr)
library(fmsb)
library(caret)
library(tidyr)
library(randomForest)

#Sorting the player stats by StatsID


Player_stat<- match_player_stat %>% group_by(StatsID)
view(Player_stat)


Player<- select(Player_stat, HomeTeamName, PlayerID, PlayerName, PlayerSurname, IsGoalkeeper, StatsID, StatsName, Value)
view(Player)

Player<-Player[,c("HomeTeamName","PlayerName","PlayerSurname","IsGoalkeeper","StatsID","StatsName","Value","PlayerID")]
colnames(Player)[8]<-"PlayerID"

#Retrieving the Role(Position) of Player from match_lineup

Player_pos<- select(match_lineup, ID, Role)
Player_pos<-Player_pos[!duplicated(Player_pos),]
colnames(Player_pos)[1]<-"PlayerID"
Player_pos<-filter(Player_pos, Role=="midfielders" | Role=="defenders" | Role=="forwards" | Role=="goalkeepers")
view(Player_pos)

#Merging the two datasets


Player_full_stat  <- merge(Player, Player_pos, by = "PlayerID")
view(Player_full_stat)

#Dividing the players into four categories i.e Forwards, Defenders, Midfielders and Goalkeeper

Midfielders<- filter(Player_full_stat, Role == "midfielders")
view(Midfielders)

Forwards<- filter(Player_full_stat, Role == "forwards")
view(Forwards)

Defenders<- filter(Player_full_stat, Role == "defenders")
view(Defenders)

Goalkeepers<- filter(Player_full_stat, Role == "goalkeepers")
view(Goalkeepers)




match_player_stat$Value<-as.numeric(match_player_stat$Value)


#########################################################

#Midfielders

Midfielders$Value<-as.numeric(Midfielders$Value)

#Assists

Midfielders_assists<-select(Midfielders, PlayerName, PlayerSurname, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Assists") %>% 
  group_by(PlayerID,PlayerName, PlayerSurname, StatsName) %>% 
  summarise(Value=sum(Value))
view(Midfielders_assists)

Midfielders_assists$Z_score<-(Midfielders_assists$Value-mean(Midfielders_assists$Value))/sd(Midfielders_assists$Value)
Midfielders_assists<-Midfielders_assists[order(as.integer(Midfielders_assists$Z_score), decreasing = TRUE),]
view(Midfielders_assists)

#Tackles

Midfielders_tackles<-select(Midfielders, PlayerName, PlayerSurname, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Tackles won") %>% 
  group_by(PlayerID,PlayerName, PlayerSurname, StatsName) %>% 
  summarise(Value=sum(Value))

Midfielders_tackles$Z_score<-(Midfielders_tackles$Value-mean(Midfielders_tackles$Value))/sd(Midfielders_tackles$Value)
Midfielders_tackles<-Midfielders_tackles[order(as.integer(Midfielders_tackles$Z_score), decreasing = TRUE),]
view(Midfielders_tackles)

#Dribbling

Midfielders_dribbling<-select(Midfielders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Dribbling") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Midfielders_dribbling$Z_score<-(Midfielders_dribbling$Value-mean(Midfielders_dribbling$Value))/sd(Midfielders_dribbling$Value)
Midfielders_dribbling<-Midfielders_dribbling[order(as.integer(Midfielders_dribbling$Z_score), decreasing = TRUE),]
view(Midfielders_dribbling)

#Passes Completed

Midfielders_passescmpltd<-select(Midfielders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Passes completed") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Midfielders_passescmpltd$Z_score<-(Midfielders_passescmpltd$Value-mean(Midfielders_passescmpltd$Value))/sd(Midfielders_passescmpltd$Value)
Midfielders_passescmpltd<-Midfielders_passescmpltd[order(as.integer(Midfielders_passescmpltd$Z_score), decreasing = TRUE),]
view(Midfielders_passescmpltd)

#Passes Accuracy

Midfielders_passaccuracy<-select(Midfielders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Passes accuracy") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Midfielders_passaccuracy$Z_score<-(Midfielders_passaccuracy$Value-mean(Midfielders_passaccuracy$Value))/sd(Midfielders_passaccuracy$Value)
Midfielders_passaccuracy<-Midfielders_passaccuracy[order(as.integer(Midfielders_passaccuracy$Z_score), decreasing = TRUE),]
view(Midfielders_passaccuracy)

#Solo Run in penalty area

Midfielders_SoloRunPen<-select(Midfielders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Solo run into penalty area") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Midfielders_SoloRunPen$Z_score<-(Midfielders_SoloRunPen$Value-mean(Midfielders_SoloRunPen$Value))/sd(Midfielders_SoloRunPen$Value)
Midfielders_SoloRunPen<-Midfielders_SoloRunPen[order(as.integer(Midfielders_SoloRunPen$Z_score), decreasing = TRUE),]
view(Midfielders_SoloRunPen)

#Solo run in key play area

Midfielders_SoloRunKeyPlay<-select(Midfielders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Solo run into key play area") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Midfielders_SoloRunKeyPlay$Z_score<-(Midfielders_SoloRunKeyPlay$Value-mean(Midfielders_SoloRunKeyPlay$Value))/sd(Midfielders_SoloRunKeyPlay$Value)
Midfielders_SoloRunKeyPlay<-Midfielders_SoloRunKeyPlay[order(as.integer(Midfielders_SoloRunKeyPlay$Z_score), decreasing = TRUE),]
view(Midfielders_SoloRunKeyPlay)

#Solo run in attacking third

Midfielders_SoloRunAttack<-select(Midfielders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Solo run into attacking third") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Midfielders_SoloRunAttack$Z_score<-(Midfielders_SoloRunAttack$Value-mean(Midfielders_SoloRunAttack$Value))/sd(Midfielders_SoloRunAttack$Value)
Midfielders_SoloRunAttack<-Midfielders_SoloRunAttack[order(as.integer(Midfielders_SoloRunAttack$Z_score), decreasing = TRUE),]
view(Midfielders_SoloRunAttack)

#Delivery in goal area

Midfielders_DelInGoal<-select(Midfielders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Delivery into goal area") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Midfielders_DelInGoal$Z_score<-(Midfielders_DelInGoal$Value-mean(Midfielders_DelInGoal$Value))/sd(Midfielders_DelInGoal$Value)
Midfielders_DelInGoal<-Midfielders_DelInGoal[order(as.integer(Midfielders_DelInGoal$Z_score), decreasing = TRUE),]
view(Midfielders_DelInGoal)

#Delivery in key play area

Midfielders_DelInKeyPlay<-select(Midfielders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Delivery into key play area") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Midfielders_DelInKeyPlay$Z_score<-(Midfielders_DelInKeyPlay$Value-mean(Midfielders_DelInKeyPlay$Value))/sd(Midfielders_DelInKeyPlay$Value)
Midfielders_DelInKeyPlay<-Midfielders_DelInKeyPlay[order(as.integer(Midfielders_DelInKeyPlay$Z_score), decreasing = TRUE),]
view(Midfielders_DelInKeyPlay)

#Delivery in attacking third

Midfielders_DelInAttack<-select(Midfielders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Delivery into attacking third") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Midfielders_DelInAttack$Z_score<-(Midfielders_DelInAttack$Value-mean(Midfielders_DelInAttack$Value))/sd(Midfielders_DelInAttack$Value)
Midfielders_DelInAttack<-Midfielders_DelInAttack[order(as.integer(Midfielders_DelInAttack$Z_score), decreasing = TRUE),]
view(Midfielders_DelInAttack)

#Delivery in penalty area

Midfielders_DelInPen<-select(Midfielders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Delivery into penalty area") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Midfielders_DelInPen$Z_score<-(Midfielders_DelInPen$Value-mean(Midfielders_DelInPen$Value))/sd(Midfielders_DelInPen$Value)
Midfielders_DelInPen<-Midfielders_DelInPen[order(as.integer(Midfielders_DelInPen$Z_score), decreasing = TRUE),]
view(Midfielders_DelInPen)

#Total Stats

Final_stats_midfielder = list(Midfielders_assists,Midfielders_tackles,Midfielders_dribbling,Midfielders_passescmpltd,
                              Midfielders_passaccuracy,Midfielders_SoloRunPen,Midfielders_SoloRunKeyPlay,Midfielders_SoloRunAttack,
                              Midfielders_DelInGoal,Midfielders_DelInKeyPlay,Midfielders_DelInAttack,Midfielders_DelInPen)

Final_stats_midfielder<-Final_stats_midfielder %>% reduce(inner_join, by="PlayerID")
view(Final_stats_midfielder)


Final_stats_midfielder$totalzscore<-Final_stats_midfielder$Z_score.x+Final_stats_midfielder$Z_score.x.x+Final_stats_midfielder$Z_score.x.x.x+
  Final_stats_midfielder$Z_score.x.x.x.x+Final_stats_midfielder$Z_score.x.x.x.x.x+Final_stats_midfielder$Z_score.x.x.x.x.x.x+Final_stats_midfielder$Z_score.y+
  Final_stats_midfielder$Z_score.y.y+Final_stats_midfielder$Z_score.y.y.y+Final_stats_midfielder$Z_score.y.y.y.y+Final_stats_midfielder$Z_score.y.y.y.y.y.y+
  Final_stats_midfielder$Z_score.y.y.y.y.y.y
view(Final_stats_midfielder)  

Final_stats_midfielder<-Final_stats_midfielder[order(as.integer(Final_stats_midfielder$totalzscore), decreasing = TRUE),]
view(Final_stats_midfielder)  

#######################################################

#Forwards

Forwards$Value<-as.numeric(Forwards$Value)

#Goals

Forwards_goals<-select(Forwards, PlayerName, PlayerSurname, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Goals") %>% 
  group_by(PlayerID,PlayerName, PlayerSurname, StatsName) %>% 
  summarise(Value=sum(Value))
view(Forwards_goals)

Forwards_goals$Z_score<-(Forwards_goals$Value-mean(Forwards_goals$Value))/sd(Forwards_goals$Value)
Forwards_goals<-Forwards_goals[order(as.integer(Forwards_goals$Z_score), decreasing = TRUE),]
view(Forwards_goals)

#Assists

Forwards_assists<-select(Forwards, PlayerName, PlayerSurname, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Assists") %>% 
  group_by(PlayerID,PlayerName, PlayerSurname, StatsName) %>% 
  summarise(Value=sum(Value))
view(Forwards_assists)

Forwards_assists$Z_score<-(Forwards_assists$Value-mean(Forwards_assists$Value))/sd(Forwards_assists$Value)
Forwards_assists<-Forwards_assists[order(as.integer(Forwards_assists$Z_score), decreasing = TRUE),]
view(Forwards_assists)

#Tackles

Forwards_tackles<-select(Forwards, PlayerName, PlayerSurname, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Tackles won") %>% 
  group_by(PlayerID,PlayerName, PlayerSurname, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_tackles$Z_score<-(Forwards_tackles$Value-mean(Forwards_tackles$Value))/sd(Forwards_tackles$Value)
Forwards_tackles<-Forwards_tackles[order(as.integer(Forwards_tackles$Z_score), decreasing = TRUE),]
view(Forwards_tackles)

#Dribbling

Forwards_dribbling<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Dribbling") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_dribbling$Z_score<-(Forwards_dribbling$Value-mean(Forwards_dribbling$Value))/sd(Forwards_dribbling$Value)
Forwards_dribbling<-Forwards_dribbling[order(as.integer(Forwards_dribbling$Z_score), decreasing = TRUE),]
view(Forwards_dribbling)

#Passes Completed

Forwards_passescmpltd<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Passes completed") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_passescmpltd$Z_score<-(Forwards_passescmpltd$Value-mean(Forwards_passescmpltd$Value))/sd(Forwards_passescmpltd$Value)
Forwards_passescmpltd<-Forwards_passescmpltd[order(as.integer(Forwards_passescmpltd$Z_score), decreasing = TRUE),]
view(Forwards_passescmpltd)

#Passes Accuracy

Forwards_passaccuracy<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Passes accuracy") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_passaccuracy$Z_score<-(Forwards_passaccuracy$Value-mean(Forwards_passaccuracy$Value))/sd(Forwards_passaccuracy$Value)
Forwards_passaccuracy<-Forwards_passaccuracy[order(as.integer(Forwards_passaccuracy$Z_score), decreasing = TRUE),]
view(Forwards_passaccuracy)

#Solo Run in penalty area

Forwards_SoloRunPen<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Solo run into penalty area") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_SoloRunPen$Z_score<-(Forwards_SoloRunPen$Value-mean(Forwards_SoloRunPen$Value))/sd(Forwards_SoloRunPen$Value)
Forwards_SoloRunPen<-Forwards_SoloRunPen[order(as.integer(Forwards_SoloRunPen$Z_score), decreasing = TRUE),]
view(Forwards_SoloRunPen)

#Solo run in key play area

Forwards_SoloRunKeyPlay<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Solo run into key play area") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_SoloRunKeyPlay$Z_score<-(Forwards_SoloRunKeyPlay$Value-mean(Forwards_SoloRunKeyPlay$Value))/sd(Forwards_SoloRunKeyPlay$Value)
Forwards_SoloRunKeyPlay<-Forwards_SoloRunKeyPlay[order(as.integer(Forwards_SoloRunKeyPlay$Z_score), decreasing = TRUE),]
view(Forwards_SoloRunKeyPlay)

#Solo run in attacking third

Forwards_SoloRunAttack<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Solo run into attacking third") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_SoloRunAttack$Z_score<-(Forwards_SoloRunAttack$Value-mean(Forwards_SoloRunAttack$Value))/sd(Forwards_SoloRunAttack$Value)
Forwards_SoloRunAttack<-Forwards_SoloRunAttack[order(as.integer(Forwards_SoloRunAttack$Z_score), decreasing = TRUE),]
view(Forwards_SoloRunAttack)

#Delivery in goal area

Forwards_DelInGoal<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Delivery into goal area") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_DelInGoal$Z_score<-(Forwards_DelInGoal$Value-mean(Forwards_DelInGoal$Value))/sd(Forwards_DelInGoal$Value)
Forwards_DelInGoal<-Forwards_DelInGoal[order(as.integer(Forwards_DelInGoal$Z_score), decreasing = TRUE),]
view(Forwards_DelInGoal)

#Delivery in key play area

Forwards_DelInKeyPlay<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Delivery into key play area") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_DelInKeyPlay$Z_score<-(Forwards_DelInKeyPlay$Value-mean(Forwards_DelInKeyPlay$Value))/sd(Forwards_DelInKeyPlay$Value)
Forwards_DelInKeyPlay<-Forwards_DelInKeyPlay[order(as.integer(Forwards_DelInKeyPlay$Z_score), decreasing = TRUE),]
view(Forwards_DelInKeyPlay)

#Delivery in attacking third

Forwards_DelInAttack<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Delivery into attacking third") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_DelInAttack$Z_score<-(Forwards_DelInAttack$Value-mean(Forwards_DelInAttack$Value))/sd(Forwards_DelInAttack$Value)
Forwards_DelInAttack<-Forwards_DelInAttack[order(as.integer(Forwards_DelInAttack$Z_score), decreasing = TRUE),]
view(Forwards_DelInAttack)

#Delivery in penalty area

Forwards_DelInPen<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Delivery into penalty area") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_DelInPen$Z_score<-(Forwards_DelInPen$Value-mean(Forwards_DelInPen$Value))/sd(Forwards_DelInPen$Value)
Forwards_DelInPen<-Forwards_DelInPen[order(as.integer(Forwards_DelInPen$Z_score), decreasing = TRUE),]
view(Forwards_DelInPen)

#Total attempts

Forwards_attempts<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Total Attempts") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_attempts$Z_score<-(Forwards_attempts$Value-mean(Forwards_attempts$Value))/sd(Forwards_attempts$Value)
Forwards_attempts<-Forwards_attempts[order(as.integer(Forwards_attempts$Z_score), decreasing = TRUE),]
view(Forwards_attempts)

#Attempts on target

Forwards_AttemptsOnTarget<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Attempts on target") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_AttemptsOnTarget$Z_score<-(Forwards_AttemptsOnTarget$Value-mean(Forwards_AttemptsOnTarget$Value))/sd(Forwards_AttemptsOnTarget$Value)
Forwards_AttemptsOnTarget<-Forwards_AttemptsOnTarget[order(as.integer(Forwards_AttemptsOnTarget$Z_score), decreasing = TRUE),]
view(Forwards_AttemptsOnTarget)

#Attempts accuracy

Forwards_AttemptsAccuracy<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Attempts Accuracy") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_AttemptsAccuracy$Z_score<-(Forwards_AttemptsAccuracy$Value-mean(Forwards_AttemptsAccuracy$Value))/sd(Forwards_AttemptsAccuracy$Value)
Forwards_AttemptsAccuracy<-Forwards_AttemptsAccuracy[order(as.integer(Forwards_AttemptsAccuracy$Z_score), decreasing = TRUE),]
view(Forwards_AttemptsAccuracy)

#Corners

Forwards_Corners<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Corners") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_Corners$Z_score<-(Forwards_Corners$Value-mean(Forwards_Corners$Value))/sd(Forwards_Corners$Value)
Forwards_Corners<-Forwards_Corners[order(as.integer(Forwards_Corners$Z_score), decreasing = TRUE),]
view(Forwards_Corners)

#Distance covered

Forwards_DistCovered<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Distance covered in possession (m)") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_DistCovered$Z_score<-(Forwards_DistCovered$Value-mean(Forwards_DistCovered$Value))/sd(Forwards_DistCovered$Value)
Forwards_DistCovered<-Forwards_DistCovered[order(as.integer(Forwards_DistCovered$Z_score), decreasing = TRUE),]
view(Forwards_DistCovered)

#Top Speed

Forwards_TopSpeed<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Top Speed (Km/h)") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_TopSpeed$Z_score<-(Forwards_TopSpeed$Value-mean(Forwards_TopSpeed$Value))/sd(Forwards_TopSpeed$Value)
Forwards_TopSpeed<-Forwards_TopSpeed[order(as.integer(Forwards_TopSpeed$Z_score), decreasing = TRUE),]
view(Forwards_TopSpeed)

#Crosses

Forwards_Crosses<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Crosses completed") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_Crosses$Z_score<-(Forwards_Crosses$Value-mean(Forwards_Crosses$Value))/sd(Forwards_Crosses$Value)
Forwards_Crosses<-Forwards_Crosses[order(as.integer(Forwards_Crosses$Z_score), decreasing = TRUE),]
view(Forwards_Crosses)

#Corners Completed

Forwards_CornersCompleted<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Corners completed") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_CornersCompleted$Z_score<-(Forwards_CornersCompleted$Value-mean(Forwards_CornersCompleted$Value))/sd(Forwards_CornersCompleted$Value)
Forwards_CornersCompleted<-Forwards_CornersCompleted[order(as.integer(Forwards_CornersCompleted$Z_score), decreasing = TRUE),]
view(Forwards_CornersCompleted)

#Sprints

Forwards_Sprint<-select(Forwards, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Sprints") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Forwards_Sprint$Z_score<-(Forwards_Sprint$Value-mean(Forwards_Sprint$Value))/sd(Forwards_Sprint$Value)
Forwards_Sprint<-Forwards_Sprint[order(as.integer(Forwards_Sprint$Z_score), decreasing = TRUE),]
view(Forwards_Sprint)



Final_stats_forward = list(Forwards_goals,Forwards_assists,Forwards_tackles,Forwards_dribbling,Forwards_passescmpltd,
                              Forwards_passaccuracy,Forwards_SoloRunPen,Forwards_SoloRunKeyPlay,Forwards_SoloRunAttack,
                              Forwards_DelInGoal,Forwards_DelInKeyPlay,Forwards_DelInAttack,Forwards_DelInPen,Forwards_attempts,
                              Forwards_AttemptsOnTarget,Forwards_AttemptsAccuracy,Forwards_Corners,Forwards_DistCovered,Forwards_TopSpeed,
                              Forwards_Crosses,Forwards_CornersCompleted,Forwards_Sprint)

Final_stats_forward<-Final_stats_forward %>% reduce(inner_join, by="PlayerID")
view(Final_stats_forward)


Final_stats_forward$totalzscore<-Final_stats_forward$Z_score.x+Final_stats_forward$Z_score.x.x+Final_stats_forward$Z_score.x.x.x+
  Final_stats_forward$Z_score.x.x.x.x+Final_stats_forward$Z_score.x.x.x.x.x+Final_stats_forward$Z_score.x.x.x.x.x.x+Final_stats_forward$Z_score.x.x.x.x.x.x.x+
  Final_stats_forward$Z_score.x.x.x.x.x.x.x.x+Final_stats_forward$Z_score.x.x.x.x.x.x.x.x.x+Final_stats_forward$Z_score.x.x.x.x.x.x.x.x.x.x+
  Final_stats_forward$Z_score.x.x.x.x.x.x.x.x.x.x.x+Final_stats_forward$Z_score.y+Final_stats_forward$Z_score.y.y+Final_stats_forward$Z_score.y.y.y+
  Final_stats_forward$Z_score.y.y.y.y+Final_stats_forward$Z_score.y.y.y.y.y.y+Final_stats_forward$Z_score.y.y.y.y.y.y+
  Final_stats_forward$Z_score.y.y.y.y.y.y.y+Final_stats_forward$Z_score.y.y.y.y.y.y.y.y+Final_stats_forward$Z_score.y.y.y.y.y.y.y.y.y+
  Final_stats_forward$Z_score.y.y.y.y.y.y.y.y.y.y+Final_stats_forward$Z_score.y.y.y.y.y.y.y.y.y.y.y
view(Final_stats_forward)  

Final_stats_forward<-Final_stats_forward[order(as.integer(Final_stats_forward$totalzscore), decreasing = TRUE),]
view(Final_stats_forward) 

#######################################################################

#Defenders

Defenders$Value<-as.numeric(Defenders$Value)

#Clearances

Defenders_clearances<-select(Defenders, PlayerName, PlayerSurname, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Clearances") %>% 
  group_by(PlayerID,PlayerName, PlayerSurname, StatsName) %>% 
  summarise(Value=sum(Value))
view(Defenders_clearances)

Defenders_clearances$Z_score<-(Defenders_clearances$Value-mean(Defenders_clearances$Value))/sd(Defenders_clearances$Value)
Defenders_clearances<-Defenders_clearances[order(as.integer(Defenders_clearances$Z_score), decreasing = TRUE),]
view(Defenders_clearances)

#Tackles

Defenders_tackles<-select(Defenders, PlayerName, PlayerSurname, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Tackles won") %>% 
  group_by(PlayerID,PlayerName, PlayerSurname, StatsName) %>% 
  summarise(Value=sum(Value))

Defenders_tackles$Z_score<-(Defenders_tackles$Value-mean(Defenders_tackles$Value))/sd(Defenders_tackles$Value)
Defenders_tackles<-Defenders_tackles[order(as.integer(Defenders_tackles$Z_score), decreasing = TRUE),]
view(Defenders_tackles)

#Passes Completed

Defenders_passescmpltd<-select(Defenders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Passes completed") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Defenders_passescmpltd$Z_score<-(Defenders_passescmpltd$Value-mean(Defenders_passescmpltd$Value))/sd(Defenders_passescmpltd$Value)
Defenders_passescmpltd<-Defenders_passescmpltd[order(as.integer(Defenders_passescmpltd$Z_score), decreasing = TRUE),]
view(Defenders_passescmpltd)

#Passes Accuracy

Defenders_passaccuracy<-select(Defenders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Passes accuracy") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Defenders_passaccuracy$Z_score<-(Defenders_passaccuracy$Value-mean(Defenders_passaccuracy$Value))/sd(Defenders_passaccuracy$Value)
Defenders_passaccuracy<-Defenders_passaccuracy[order(as.integer(Defenders_passaccuracy$Z_score), decreasing = TRUE),]
view(Defenders_passaccuracy)

#Recovered balls

Defenders_RecoveredBalls<-select(Defenders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Recovered balls") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Defenders_RecoveredBalls$Z_score<-(Defenders_RecoveredBalls$Value-mean(Defenders_RecoveredBalls$Value))/sd(Defenders_RecoveredBalls$Value)
Defenders_RecoveredBalls<-Defenders_RecoveredBalls[order(as.integer(Defenders_RecoveredBalls$Z_score), decreasing = TRUE),]
view(Defenders_RecoveredBalls)

#Clearances successful

Defenders_ClearSuccess<-select(Defenders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Clearances successful") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Defenders_ClearSuccess$Z_score<-(Defenders_ClearSuccess$Value-mean(Defenders_ClearSuccess$Value))/sd(Defenders_ClearSuccess$Value)
Defenders_ClearSuccess<-Defenders_ClearSuccess[order(as.integer(Defenders_ClearSuccess$Z_score), decreasing = TRUE),]
view(Defenders_ClearSuccess)

#Blocks

Defenders_blocks<-select(Defenders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Blocks") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Defenders_blocks$Z_score<-(Defenders_blocks$Value-mean(Defenders_blocks$Value))/sd(Defenders_blocks$Value)
Defenders_blocks<-Defenders_blocks[order(as.integer(Defenders_blocks$Z_score), decreasing = TRUE),]
view(Defenders_blocks)

#Sprints

Defenders_sprint<-select(Defenders, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Sprints") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Defenders_sprint$Z_score<-(Defenders_sprint$Value-mean(Defenders_sprint$Value))/sd(Defenders_sprint$Value)
Defenders_sprint<-Defenders_sprint[order(as.integer(Defenders_sprint$Z_score), decreasing = TRUE),]
view(Defenders_sprint)


#Total Stats

Final_stats_defender = list(Defenders_clearances,Defenders_tackles,Defenders_passescmpltd,
                              Defenders_passaccuracy,Defenders_RecoveredBalls,
                            Defenders_ClearSuccess,Defenders_blocks,Defenders_sprint)

Final_stats_defender<-Final_stats_defender %>% reduce(inner_join, by="PlayerID")
view(Final_stats_defender)


Final_stats_defender$totalzscore<-Final_stats_defender$Z_score.x+Final_stats_defender$Z_score.x.x+Final_stats_defender$Z_score.x.x.x+
  Final_stats_defender$Z_score.x.x.x.x+Final_stats_defender$Z_score.y+
  Final_stats_defender$Z_score.y.y+Final_stats_defender$Z_score.y.y.y+Final_stats_defender$Z_score.y.y.y.y
view(Final_stats_defender)  

Final_stats_defender<-Final_stats_defender[order(as.integer(Final_stats_defender$totalzscore), decreasing = TRUE),]
view(Final_stats_defender) 

#######################################################################

#Goalkeepers

Goalkeepers$Value<-as.numeric(Goalkeepers$Value)

#Clearances

Goalkeepers_clearances<-select(Goalkeepers, PlayerName, PlayerSurname, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Clearances") %>% 
  group_by(PlayerID,PlayerName, PlayerSurname, StatsName) %>% 
  summarise(Value=sum(Value))
view(Goalkeepers_clearances)

Goalkeepers_clearances$Z_score<-(Goalkeepers_clearances$Value-mean(Goalkeepers_clearances$Value))/sd(Goalkeepers_clearances$Value)
Goalkeepers_clearances<-Goalkeepers_clearances[order(as.integer(Goalkeepers_clearances$Z_score), decreasing = TRUE),]
view(Goalkeepers_clearances)

#Saves

Goalkeepers_saves<-select(Goalkeepers, PlayerName, PlayerSurname, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Saves") %>% 
  group_by(PlayerID,PlayerName, PlayerSurname, StatsName) %>% 
  summarise(Value=sum(Value))
view(Goalkeepers_saves)

Goalkeepers_saves$Z_score<-(Goalkeepers_saves$Value-mean(Goalkeepers_saves$Value))/sd(Goalkeepers_saves$Value)
Goalkeepers_saves<-Goalkeepers_saves[order(as.integer(Goalkeepers_saves$Z_score), decreasing = TRUE),]
view(Goalkeepers_saves)

#Clearances successful

Goalkeepers_clearances_success<-select(Goalkeepers, PlayerName, PlayerSurname, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Clearances successful") %>% 
  group_by(PlayerID,PlayerName, PlayerSurname, StatsName) %>% 
  summarise(Value=sum(Value))

Goalkeepers_clearances_success$Z_score<-(Goalkeepers_clearances_success$Value-mean(Goalkeepers_clearances_success$Value))/sd(Goalkeepers_clearances_success$Value)
Goalkeepers_clearances_success<-Goalkeepers_clearances_success[order(as.integer(Goalkeepers_clearances_success$Z_score), decreasing = TRUE),]
view(Goalkeepers_clearances_success)

#High Claims

Goalkeepers_high_claims<-select(Goalkeepers, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="High Claims") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Goalkeepers_high_claims$Z_score<-(Goalkeepers_high_claims$Value-mean(Goalkeepers_high_claims$Value))/sd(Goalkeepers_high_claims$Value)
Goalkeepers_high_claims<-Goalkeepers_high_claims[order(as.integer(Goalkeepers_high_claims$Z_score), decreasing = TRUE),]
view(Goalkeepers_high_claims)

#Punches

Goalkeepers_Punches<-select(Goalkeepers, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Punches") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Goalkeepers_Punches$Z_score<-(Goalkeepers_Punches$Value-mean(Goalkeepers_Punches$Value))/sd(Goalkeepers_Punches$Value)
Goalkeepers_Punches<-Goalkeepers_Punches[order(as.integer(Goalkeepers_Punches$Z_score), decreasing = TRUE),]
view(Goalkeepers_Punches)

#Goalkeeper kicks completed

Goalkeepers_kicks_completed<-select(Goalkeepers, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Goalkeeper kicks completed") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Goalkeepers_kicks_completed$Z_score<-(Goalkeepers_kicks_completed$Value-mean(Goalkeepers_kicks_completed$Value))/sd(Goalkeepers_kicks_completed$Value)
Goalkeepers_kicks_completed<-Goalkeepers_kicks_completed[order(as.integer(Goalkeepers_kicks_completed$Z_score), decreasing = TRUE),]
view(Goalkeepers_kicks_completed)

#Low Claims

Goalkeepers_low_claims<-select(Goalkeepers, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Low Claims") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Goalkeepers_low_claims$Z_score<-(Goalkeepers_low_claims$Value-mean(Goalkeepers_low_claims$Value))/sd(Goalkeepers_low_claims$Value)
Goalkeepers_low_claims<-Goalkeepers_low_claims[order(as.integer(Goalkeepers_low_claims$Z_score), decreasing = TRUE),]
view(Goalkeepers_low_claims)

#Goalkeeper kicks completed percentage

Goalkeepers_kicks_completed_per<-select(Goalkeepers, StatsName, Value, PlayerID) %>% 
  filter(StatsName=="Goalkeeper kicks completed %") %>% 
  group_by(PlayerID, StatsName) %>% 
  summarise(Value=sum(Value))

Goalkeepers_kicks_completed_per$Z_score<-(Goalkeepers_kicks_completed_per$Value-mean(Goalkeepers_kicks_completed_per$Value))/sd(Goalkeepers_kicks_completed_per$Value)
Goalkeepers_kicks_completed_per<-Goalkeepers_kicks_completed_per[order(as.integer(Goalkeepers_kicks_completed_per$Z_score), decreasing = TRUE),]
view(Goalkeepers_kicks_completed_per)


#Total Stats

Final_stats_goalkeeper = list(Goalkeepers_clearances,Goalkeepers_saves,Goalkeepers_clearances_success,
                              Goalkeepers_high_claims,Goalkeepers_Punches,
                              Goalkeepers_kicks_completed,Goalkeepers_low_claims,Goalkeepers_kicks_completed_per)

Final_stats_goalkeeper<-Final_stats_goalkeeper %>% reduce(inner_join, by="PlayerID")
view(Final_stats_goalkeeper)


Final_stats_goalkeeper$totalzscore<-Final_stats_goalkeeper$Z_score.x+Final_stats_goalkeeper$Z_score.x.x+Final_stats_goalkeeper$Z_score.x.x.x+
  Final_stats_goalkeeper$Z_score.x.x.x.x+Final_stats_goalkeeper$Z_score.y+
  Final_stats_goalkeeper$Z_score.y.y+Final_stats_goalkeeper$Z_score.y.y.y+Final_stats_goalkeeper$Z_score.y.y.y.y
view(Final_stats_goalkeeper)  

Final_stats_goalkeeper<-Final_stats_goalkeeper[order(as.integer(Final_stats_goalkeeper$totalzscore), decreasing = TRUE),]
view(Final_stats_goalkeeper) 


#Top 4 forwards

Forwards_top_four<-Final_stats_forward[1:4,c(1,2,3,74)]
view(Forwards_top_four)

#Top 4 midfielders

Midfielders_top_four<-Final_stats_midfielder[1:4,c(1,2,3,42)]
view(Midfielders_top_four)

#Top 4 defenders

Defenders_top_four<-Final_stats_defender[1:4,c(1,2,3,30)]
view(Defenders_top_four)

#Top 2 goalkeepers

Goalkeepers_top_two<-Final_stats_goalkeeper[1:2,c(1,2,3,32)]
view(Goalkeepers_top_two)


#Top 10 forwards

Forwards_top_ten<-Final_stats_forward[1:10,]
view(Forwards_top_ten)

#Top 10 defenders

Defenders_top_ten<-Final_stats_defender[1:10,]
view(Defenders_top_ten)

#Pie chart for distribution of goals for forwards

ggplot(Forwards_top_ten, aes(x="", y=Value.x, fill=PlayerSurname.x)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  theme_void()+
  labs(x=NULL, y=NULL, fill="Players",
       title="  Proportion of goals by top 10 forwards",
       caption="Distribution of Goals                         ")

#Heatmap to visualise the skills of top 10 defenders

colnames(Defenders_top_ten)[5] = "ClearancesV"
colnames(Defenders_top_ten)[10] = "TacklesWV"
colnames(Defenders_top_ten)[13] = "PassCompV"
colnames(Defenders_top_ten)[16] = "PassAccV"
colnames(Defenders_top_ten)[19] = "RecBallV"
colnames(Defenders_top_ten)[22] = "ClearsuccV"
colnames(Defenders_top_ten)[25] = "BlockV"
colnames(Defenders_top_ten)[28] = "SprintV"
View(Defenders_top_ten)

Defenders_Matrix<-Defenders_top_ten[,c(3,5,10,13,16,19,22,25,28)]
view(Defenders_matrix)

Defenders_Matrix <- Defenders_Matrix[order(Defenders_Matrix$ClearancesV),]

Defenders_Matrix<-column_to_rownames(Defenders_Matrix, var = "PlayerSurname.x")
Defenders_Matrix <- Defenders_Matrix[,]
Defenders_Matrix<- as.matrix(Defenders_Matrix)
Defenders_heatmap <- heatmap(Defenders_Matrix, Rowv=NA, Colv=NA, col = rev(heat.colors(256)), scale="column", margins=c(9,10), 
                             xlab="Skills", ylab="Players", main="Heatmap")

#Radar Plot to visualise the skills for top 4 goalkeepers

Goalkeepers_top_four_stats<-Final_stats_goalkeeper[1:4,]
view(Goalkeepers_top_two_stats)

colnames(Goalkeepers_top_four_stats)[5] = "Clearances"
colnames(Goalkeepers_top_four_stats)[10] = "Saves"
colnames(Goalkeepers_top_four_stats)[15] = "ClearSuccess"
colnames(Goalkeepers_top_four_stats)[18] = "HighClaims"
colnames(Goalkeepers_top_four_stats)[21] = "Punches"
colnames(Goalkeepers_top_four_stats)[24] = "GKkicks"
colnames(Goalkeepers_top_four_stats)[27] = "LowClaims"

Goalkeepers_top_four_stats<-Goalkeepers_top_four_stats[,c(3,5,10,15,18,21,24,27)]
Goalkeepers_top_four_stats<-column_to_rownames(Goalkeepers_top_four_stats, var = "PlayerSurname.x")
view(Goalkeepers_top_four_stats)



Goalkeepers_top_four_stats<-as.data.frame(Goalkeepers_top_four_stats)
colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) , rgb(0.3,0.5,0.2,0.9), rgb(0.3,0.5,0.4,0.9), rgb(0.7,0.5,0.7,0.9))
colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) , rgb(0.3,0.5,0.2,0.4,),rgb(0.3,0.5,0.7,0.4), rgb(0.6,0.7,0.2,0.4))


max_min <- data.frame(
  Clearances = c(22, 0), Saves = c(21, 0), ClearSuccess = c(20, 0),
  HighClaims = c(15, 0), Punches = c(7, 0), GKkicks = c(42, 0),
  LowClaims = c(20, 0))
rownames(max_min) <- c("Max", "Min")
view(max_min)

GK_stats_radar <- rbind(max_min, Goalkeepers_top_four_stats)

radarchart(GK_stats_radar, axistype=1, pcol=colors_border, pfcol=colors_in , plwd=4, plty=1,
           cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=0.8,vlcex=0.8)

legend(x = "topright", legend = rownames(GK_stats_radar[-c(1,2),]), bty = "n", col = colors_in, pch=20, text.col = "grey", cex = 0.75, pt.cex = 2)

#Preparing the data for random forest model

view(Player_full_stat)

Player_full_stat_code<-Player_full_stat[,c(1,7,8)]
Player_full_stat_code$Value<-as.numeric(Player_full_stat_code$Value)
Full_stats<-Player_full_stat_code %>% pivot_wider(names_from = StatsName, values_from = Value, values_fn = sum) %>% as.data.frame()

view(Full_stats)

#Dealing with the missing values 

Full_stats[is.na(Full_stats)] <- 0
summary(Full_stats)
table(Full_stats$Goals) 

#Making a new column in dataset which has a binary output, i.e if a player has scored the output is 1 and if he hasn't the output is 0

Full_stats$ynGoals[Full_stats$Goals >  0] <- 1

Full_stats$ynGoals[Full_stats$Goals == 0] <- 0


Full_stats$ynGoals <- factor(Full_stats$ynGoals,levels=c(0,1), labels=c("No","Yes"))
table(Full_stats$ynGoals)

#using Recursive feature elimination method to come up with the best features that affect goal scoring

set.seed(7)


control_features<-rfeControl(functions=rfFuncs,
                    method = "repeatedcv",
                    repeats = 5,
                    number = 10)
#we need to focus of yngoals as it is our target variable

target<-Full_stats$ynGoals
target

Full_stats <-Full_stats %>% select(-contains('Goal'))
Full_stats

#applying random forest model

predictors_rfe1 <- rfe(x = Full_stats, 
                   y = target, 
                   sizes = c(1:13),
                   rfeControl = control_features)


predictors_rfe1

#checking for top predictors as per the model 

predictors(predictors_rfe1)

#plotting the the metrics

ggplot(data = predictors_rfe1, metric = "Accuracy") + theme_bw()
ggplot(data = predictors_rfe1, metric = "Kappa") + theme_bw()


variables <- data.frame(feature = row.names(varImp(predictors_rfe1))[1:8],
                          importance = varImp(predictors_rfe1)[1:8, 1])

#Plotting the KPIs

ggplot(data = variables, 
       aes(x = reorder(feature, -importance), y = importance, fill = feature)) +
  geom_bar(stat="identity") + labs(x = "Predictor", y = "Importance") + 
  geom_text(aes(label = round(importance, 2)), vjust=1.6, color="white", size=4) + 
  theme_bw() + theme(axis.text.x = element_text(angle = 90)) 

#Checking the goal scoring ability of our forwards 

Attackers<-Full_stats %>% filter(PlayerID == "250026037" | PlayerID == "250143693" | PlayerID == "250024795" | PlayerID == "250024860")

Attackers<- Attackers %>% select(c('Attempts on target in penalty area','Attempts Accuracy','Attempts on target','Attempts in open play from centre',
                                  'Attempts in open play','Total Attempts','Lost balls opposite half','Sprints'))

Attackers<- Attackers %>% select(c(`Attempts on target in penalty area`,`Attempts Accuracy`,`Attempts on target`,`Attempts in open play from centre`,
                                  `Attempts in open play`,`Total Attempts`,`Lost balls opposite half`,`Sprints`))

view(Attackers)


set.seed(7)

# We excluded all columns which contain "goals" in Full_stats variable, hence we need to rewrite the code to predict the probability of goal scoring

Player_full_stat_code<-Player_full_stat[,c(1,7,8)]
Player_full_stat_code$Value<-as.numeric(Player_full_stat_code$Value)
Full_stats<-Player_full_stat_code %>% pivot_wider(names_from = StatsName, values_from = Value, values_fn = sum) %>% as.data.frame()

view(Full_stats)

Full_stats[is.na(Full_stats)] <- 0
summary(Full_stats)
table(Full_stats$Goals) 


Full_stats$ynGoals[Full_stats$Goals >  0] <- 1

Full_stats$ynGoals[Full_stats$Goals == 0] <- 0


Full_stats$ynGoals <- factor(Full_stats$ynGoals,levels=c(0,1), labels=c("No","Yes"))
table(Full_stats$ynGoals)

target<-Full_stats$ynGoals
target

#fitting in logistic regression model 

log_reg<-glm(target ~ `Attempts on target in penalty area` + `Attempts Accuracy` +
                   +`Attempts on target`+`Attempts in open play from centre`+`Attempts in open play` + `Total Attempts`+`Lost balls opposite half`
                 +`Sprints`,
                 data=Full_stats, family=binomial())

summary(log_reg)

#checking the coefficients of the model 

coef(log_reg) 

#exponentiating the coefficients

exp(coef(log_reg)) 

#predicting the probability of goal scoring of our attackers 

Attackers$prob <- predict(log_reg, newdata=Attackers,
                         type="response")
View(Attackers)

deviance(log_reg)/df.residual(log_reg)





