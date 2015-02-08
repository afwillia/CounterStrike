### This is the first part of several scripts to clean and graph CSS data
### This is all about cleaning up the CSS console data
#######################################################################
###                           To Do:
###   A:  For actual data, remove the timestamp subsetting from lines 24,25
###     My real data will all have timestamp data
###
###   B:  Figure out what to do with timestamp information.
###       Currently I'm filtering it out.
###   C: Find a more robust way of filtering out non killing data
###   D: Account for round information, map changes, etc
##################################################################

#import console data. ideally change file to log location
console.data <- readLines(con = "file.log")

#find rows with killing information. maybe add second grep for "with"
kill.data <- grep("killed", console.data, value=TRUE)
kill.data <- grep("with", kill.data, value=TRUE)

#make separate df for timestamped kills. this is temporary
#later filter out timestamp info, then combine with rest of data
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

#make list of trimmed data. now it looks just like timestamp-free data
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

#this would be the spot where I try to add time information

#Finally, create a df for all player's kills and deaths
all.kills <- table(df$killer)
all.deaths <- table(df$killed)

player.deaths <- as.data.frame(all.deaths)
names(player.deaths) <- c("player", "deaths")

player.kills <- as.data.frame(all.kills)
names(player.kills) <- c("player", "kills")

player.df <- merge(player.deaths, player.kills, by = "player", all.x=TRUE)
player.df[is.na(player.df$kills), "kills"] <- 0
player.df[is.na(player.df$deaths), "deaths"] <- 0

print("Before importing next script make variable player = player you want to track")
