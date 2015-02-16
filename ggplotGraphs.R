# needs clean.df from consoleMunge.R

#import clean.df from script
source("consoleMunge.R")

library(ggplot2)
#aes( x = substr(var, 1, 8)) trims the x labels!
#theme(axis.title.x = element_blank() makes bad label go away!)

#bar plot of players that killed player, filled with weapon
p <- ggplot(subset(clean.df, subset = killed == "Bilbo T. Baggins"), 
            aes(x = substr(killer, 1, 8)))
p + geom_bar(aes(fill = weapon)) +
  theme(axis.title.x = element_blank(), axis.text.x = element_text(angle = 45, hjust = 1))

#barplot kills by player filled with weapon. 
# group weapons into class, sniper, rifle, pistol, etc
q <- ggplot(clean.df, aes(x = substr(killer, 1, 8)))
q + geom_bar(aes(fill = weapon)) + 
  theme(axis.title.x = element_blank(), axis.text.x = element_text(angle = 45, hjust = 1))


