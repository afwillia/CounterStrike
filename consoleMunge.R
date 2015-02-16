### This is the first part of several scripts to clean and graph CSS data
### This outputs console data into df with time, killer, killed, and weapon

#######################################################################
###                           To Do:
###   B:  Figure out what to do with timestamp information.
###   C: Find a more robust way of filtering out non killing data
###   D: Account for round information, map changes, etc
##################################################################

#Start CSS and enter con_logfile file.log
#  and               con_timestamp 1
#to set up logging properly

#import console data. ideally change file to log location
data.file <- "D:/Program Files/Steam/SteamApps/common/Counter-Strike Source/cstrike/file.log"
console.data <- readLines(con = data.file)

#find rows with killing information. maybe add second grep for "with"
kill.data <- grep("killed", console.data, value=TRUE)
kill.data <- grep("with", kill.data, value=TRUE)

#timestamp has 13 characters of date we can get rid of, 23 counting time.
#make function to extract last 24 to nchar()-1 characters from string - 
#removing the timestamp info. later if i want to include timestamp, make first cutoff 13
stringSplit <- function(x) {
  substring(x, 14, nchar(x)-1)
}

#make list of trimmed data. now it looks just like timestamp-free data
all.kill.data <- lapply(kill.data, stringSplit)

#split all lines by " killed " and " with ", so we get killer, killed, and weapon
data.list <- lapply(all.kill.data, 
                    function(x) strsplit(x, split = ": | killed | with "))

#make df for console data that is just killer, killed, and weapon
clean.df <- data.frame(matrix(unlist(data.list), 
                        nrow=length(data.list), byrow=T))
names(clean.df) <- c("time", "killer", "killed", "weapon")

#make time POSIXlt class
clean.df$time <- strptime(as.character(clean.df$time), "%H:%M:%S")

#clean up environment
rm(all.kill.data, console.data, data.file, data.list, kill.data)

#message for set player of interest before plotting
print("Before importing next script make variable player = player you want to track")



