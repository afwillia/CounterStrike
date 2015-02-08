#########  This is a script to analyze CSS data #######
### Process console data by filtering lines with kill information
### Make df with killer, killed, and weapon
### Graph player kills and killed
### Graph weapon stats
######################################################################

##### Part 1: Filter console data
#################################

#import console data
console.data <- readLines(con = "file.log")

#find rows with killing information. maybe add second grep for "with"
kill.data <- grep("killed", console.data, value=TRUE)
kill.data <- grep("with", kill.data, value=TRUE)

#until i decide to include timestamps or not...
#make separate df for timestamped kills
#filter out timestamp info, then combine with rest of data
kill.data.notime <- kill.data[1:122]
kill.data.ts <- kill.data[123:144]

#timestamp has 13 characters of date we can get rid of, 23 counting time.
#time is HH:MM:SS:   -- maybe filter out last colon?
#delete all time information for now... come back to it later

#based off above info, make function to extract last 24 to nchar()
#characters from string - removing the timestamp info.
#later if i want to include timestamp, make first cutoff 13

stringSplit <- function(x) {
  substring(x, 24, nchar(x))
}

kill.data.minus.ts <- lapply(kill.data.ts, stringSplit)

#combine non timestamp and timestamped data into one list
all.kill.data <- c(kill.data.minus.ts, kill.data.notime)
all.kill.data <- unlist(all.kill.data)

#split all lines by " killed " and " with ", so we get killer, killed,
# and weapon
data.list <- lapply(all.kill.data, 
                    function(x) strsplit(x, split = " killed | with "))

#this is a much better way of representing the data and tabling it.
df <- data.frame(matrix(unlist(data.list), 
                        nrow=length(data.list), byrow=T))
names(df) <- c("killer", "killed", "weapon")

###########################################################################

####Part 2: Player and weapon stats
##################################

#### Player kills and killed by
#############################

#table of kills sorted by most.
sort(table(df$killer), decreasing = TRUE)

#make a variable for player ID to use in following functions
player = "Bilbo T. Baggins"

#open pdf device for saving plots
pdf(paste0(Sys.Date(), player, ".pdf"), 11.5, 8)

#subset number of kills for me
kill.subset <- subset(df, subset = killer == player)
kill.numbers <- sort(table(kill.subset$killed), decreasing = TRUE)

#specify plot pars for 4 plots per page and resize margins
par(mfrow = c(2, 2))
par(mar = c(3, 3, 2, 2))
par(cex.axis = 0.7)

#barplot people player killed
#subset > 0 to remove empty columns
barplot(kill.numbers[kill.numbers > 0], border = NA, 
        names.arg = names(kill.numbers[kill.numbers > 0]),
        main = paste(player, "kills", sep = " "))
        

#subset killed
killed.subset <- subset(df, subset = killed == player)
killed.numbers <- sort(table(killed.subset$killer), decreasing = TRUE)

#barplot of people who killed player
barplot(killed.numbers[killed.numbers > 0], border = NA, 
        names.arg = names(killed.numbers[killed.numbers > 0]),
        main = paste(player, "killed by", sep = " "))

#########################################################################
### Weapons summary

#table of all weapons used
all.weapons <- sort(table(df$weapon), decreasing = TRUE)

barplot(all.weapons, border = NA,
        main = "All weapons used")

# table and barplot of weapons that killed player
killed.player.weaps <- sort(table(killed.subset$weapon), decreasing = TRUE)

barplot(killed.player.weaps[killed.player.weaps > 0],
        border = NA,
        main = paste(player, "killed with", sep = " "))

dev.off()


####total kill info
all.kills <- table(df$killer)
all.deaths <- table(df$killed)

barplot(sort(all.kills, decreasing = TRUE), border = NA, las = 2,
        main = "All kills")

#########################################################
# make df of all player kills and deaths
##########

player.deaths <- as.data.frame(all.deaths)
names(player.deaths) <- c("player", "deaths")

player.kills <- as.data.frame(all.kills)
names(player.kills) <- c("player", "kills")

player.df <- merge(player.deaths, player.kills, by = "player", all.x=TRUE)

###########################################

#same plot as above, just ordered alphabetically
with(player.df, barplot((kills / deaths),
                        border = NA, names.arg = player,
                        las = 2, main = "Kills/Deaths"))
abline(h = mean(player.df$kills/player.df$deaths, na.rm = TRUE), col = "red")

with(player.df, barplot(kills, border = NA, names.arg = player, 
                        las = 2, main = "Kills"))
abline(h = mean(player.df$kills, na.rm = TRUE), col = "red")

with(player.df, barplot(deaths, border = NA, names.arg = player,
                        las = 2, main = "Deaths"))
abline(h = mean(player.df$deaths, na.rm = TRUE), col = "red")
