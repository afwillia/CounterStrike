#REQUIRES roundInfo.R

source("roundInfo.R")

library(reshape2)
library(ggplot2)
##########################################################
#now create a df for kills by round

#make df of each player's kills by round
kills.rounds.list <- tapply(console.rounds.df$killer, console.rounds.df$round, table)
kills.rounds.df.list <- lapply(kills.rounds.list, as.data.frame)

merge.all <- function(x, y)
  merge(x, y, all=TRUE, by="Var1")

#warning is just for duplicated col names
kill.rounds.df <- Reduce(merge.all, kills.rounds.df.list)
names(kill.rounds.df) <- c("killer", paste("r", 1:length(kills.rounds.df.list), sep = "."))

kills.rounds.melt <- melt(kill.rounds.df)
names(kills.rounds.melt) <- c("killer", "round", "kills")


###################
pdf(paste0(Sys.Date(), player, "RoundKills.pdf"), 11.5, 8)

#plot kills per round
#s <- subset(console.rounds.df, subset = killer == player)
#plot(table(s$round), main = paste(player, "Kills by Round", sep = " "), 
     #ylab = "Kills")
#add line for average kills/round
#too tricky now- need to determine how many rounds individuals played
#abline(h = nrow(s)/(max(s$round) - s$round[1]), col = "blue")

p <- ggplot(subset(kills.rounds.melt, subset = killer == player),
            aes(x = round, y = kills, group = killer))
p + geom_line(aes(col = killer))

dev.off()
