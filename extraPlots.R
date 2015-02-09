####total kill info
all.kills <- table(clean.df$killer)
all.deaths <- table(clean.df$killed)

barplot(sort(all.kills, decreasing = TRUE), border = NA, las = 2,
        main = "All kills")


barplot(killed.numbers[killed.numbers > 0], border = NA, 
        names.arg = sapply(killed.numbers[killed.numbers > 0], substr, 1, 10),
        main = paste(player, "killed by", sep = " "))

with(subset(clean.df, subset = killed == player), 
     barplot(table(killer)))

#table of all weapons used
all.weapons <- sort(table(clean.df$weapon), decreasing = TRUE)

barplot(all.weapons, border = NA,
        main = "All weapons used")
