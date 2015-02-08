###### This is part two of CSS data analysis scripts
####This script creates a data frame of player's total kills and deaths
#### then makes plots for KDR, Kills, deaths, etc.
######################################################

####       TO DO:
### A:  The graphs below are sorted alphabetically,
###     figure out how to sort them numerically while keeping the names
###     I can do it with a sorted table, but that throws off my matrix merge


all.kills <- table(df$killer)
all.deaths <- table(df$killed)

player.deaths <- as.data.frame(all.deaths)
names(player.deaths) <- c("player", "deaths")

player.kills <- as.data.frame(all.kills)
names(player.kills) <- c("player", "kills")

player.df <- merge(player.deaths, player.kills, by = "player", all.x=TRUE)
player.df[is.na(player.df$kills), "kills"] <- 0
player.df[is.na(player.df$deaths), "deaths"] <- 0