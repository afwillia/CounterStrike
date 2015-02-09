# needs clean.df from consoleMunge.R

library(ggplot2)

#bar plot of players that killed player, filled with weapon
#need to figure out how to trim axis label to make more compact
p <- ggplot(subset(clean.df, subset = killed == "Bilbo T. Baggins"), aes(x = killer))
p + geom_bar(aes(fill = weapon)) + theme(axis.text.x = element_text(angle = 45, hjust = 1))

#barplot kills by player filled with weapon. 
#bar labels too crowded
# group weapons into class, sniper, rifle, pistol, etc
q <- ggplot(clean.df, aes(x = killer))
q + geom_bar(aes(fill = weapon))


