# REQUIRES console.Munge.R  (uses clean.df)
#Set player variable in console

##### This creates 4 graphs of individual "player" information
##  Player kills, Players that killed players, guns player used,
## and guns that killed player.

#import clean.df from script
source("consoleMunge.R")


#open pdf device for saving plots
pdf(paste0(Sys.Date(), player, ".pdf"), 11.5, 8)

#subset number of kills for me
kill.subset <- subset(clean.df, subset = killer == player)
kill.numbers <- sort(table(kill.subset$killed), decreasing = TRUE)

#specify plot pars for 4 plots per page and resize margins
par(mfrow = c(2, 2))
par(mar = c(3, 3, 2, 2))
par(cex.axis = 0.7)

#barplot people player killed
#subset > 0 to remove empty columns
barplot(kill.numbers[kill.numbers > 0], border = NA, 
        names.arg = substr(names(kill.numbers[kill.numbers > 0]), 1, 8),
        main = paste(player, "kills", sep = " "), las = 2)

#subset killed
killed.subset <- subset(clean.df, subset = killed == player)
killed.numbers <- sort(table(killed.subset$killer), decreasing = TRUE)

#barplot of people who killed player
barplot(killed.numbers[killed.numbers > 0], border = NA, 
        names.arg = substr(names(killed.numbers[killed.numbers > 0]), 1, 8),
        main = paste(player, "killed by", sep = " "), las = 2)

#########################################################################
### Weapons summary

kill.player.weaps <- sort(table(kill.subset$weapon), decreasing = TRUE)

barplot(kill.player.weaps[kill.player.weaps > 0], border = NA,
        main = paste(player, "weapons used", sep = " "))

# table and barplot of weapons that killed player
killed.player.weaps <- sort(table(killed.subset$weapon), decreasing = TRUE)

barplot(killed.player.weaps[killed.player.weaps > 0],
        border = NA,
        main = paste(player, "killed with", sep = " "))

dev.off()

