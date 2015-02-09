###### This is part two of CSS data analysis scripts
#### PLOTS 3 BARPLOTS: ALL KILLS, ALL DEATHS, AND KDRs, ON ONE PAGE
####   WITH A RED BAR FOR AVERAGES OF EACH
######################################################

####       TO DO:
### A:  The graphs below are sorted alphabetically,
###     figure out how to sort them numerically while keeping the names
###     I can do it with a sorted table, but that throws off my matrix merge

#Create a df for all player's kills and deaths
all.kills <- table(clean.df$killer)
all.deaths <- table(clean.df$killed)

player.deaths <- as.data.frame(all.deaths)
names(player.deaths) <- c("player", "deaths")

player.kills <- as.data.frame(all.kills)
names(player.kills) <- c("player", "kills")

player.df <- merge(player.deaths, player.kills, by = "player", all.x=TRUE)
player.df[is.na(player.df$kills), "kills"] <- 0
player.df[is.na(player.df$deaths), "deaths"] <- 0

# open plotting device

pdf(paste0(Sys.Date(), "KDRsummary.pdf"), 11.5, 11.5)

par(mfrow = c(3,1))
par(mar = c(4, 4, 1, 0.5))
par(cex.axis = 1)

#names.arg = sapply(player, substr, 1, 10) limits axis labels to 10 chars

#plot total kills, add line for average
with(player.df, barplot(kills, border = NA, names.arg = sapply(player, substr, 1, 10),
                        las = 2, ylab = "Kills"))
abline(h = mean(player.df$kills, na.rm = TRUE), col = "red")

#plot total deaths, add line for average
with(player.df, barplot(deaths, border = NA, names.arg = sapply(player, substr, 1, 10),
                        las = 2, ylab = "Deaths"))
abline(h = mean(player.df$deaths, na.rm = TRUE), col = "red")

#plot KDR, add line for average
with(player.df, barplot((kills / deaths),
                        border = NA, names.arg = sapply(player, substr, 1, 10),
                        las = 2, ylab = "Kills/Deaths"))
abline(h = mean(player.df$kills/player.df$deaths, na.rm = TRUE), col = "red")

dev.off()

