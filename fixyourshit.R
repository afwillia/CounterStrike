#this splits data up into rounds. or at least adds round number to data

#import console data. ideally change file to log location
data.file <- "D:/Program Files/Steam/SteamApps/common/Counter-Strike Source/cstrike/file.log"
console.data <- readLines(con = data.file)

#########################################
#round time below. need to optimize. haven't used to full potential
#round data starts with me connecting and finds each end of round comment -
# "Most kills:"
game.start.end <- c(grep("Bilbo T. Baggins connected", console.data, value = TRUE),
                    console.data[length(console.data)])
round.times <- grep("Most kills:", console.data, value = TRUE)

game.start.end <- lapply(game.start.end, substr, 14, 21)
round.ends <- lapply(round.times, substr, 14, 21)

game.start.end <- strptime(as.character(game.start.end), "%H:%M:%S")
round.ends <- strptime(as.character(round.ends), "%H:%M:%S")

round.starts <- c(game.start.end[1], round.end + 4)
round.ends <- c(round.ends, game.start.end[2])

names(round.starts) <- paste0("start.", 1:length(round.starts))
names(round.ends) <- paste0("start.", 1:length(round.ends))

round.length <- difftime(round.ends, round.starts)

##################################################

#find rows with killing information. maybe add second grep for "with"
kill.data <- grep("killed", console.data, value=TRUE)
kill.data <- grep("with", kill.data, value=TRUE)

#custom function to trim timestamp
stringSplit <- function(x) {
  substring(x, 14, nchar(x)-1)
}

#make list of trimmed data. now it looks just like timestamp-free data
trimmed.kill.data <- lapply(kill.data, stringSplit)

#split all lines by " killed " and " with ", so we get killer, killed, and weapon
console.split <- lapply(trimmed.kill.data, 
                    function(x) strsplit(x, split = ": | killed | with "))

#make df for console data that is just killer, killed, and weapon
clean.console.df <- data.frame(matrix(unlist(console.split), 
                              nrow=length(console.split), byrow=T))
names(clean.console.df) <- c("time", "killer", "killed", "weapon")

#make time POSIXlt class
clean.console.df$time <- strptime(as.character(clean.console.df$time), "%H:%M:%S")

#bind round column to df. set default round to 1
console.rounds.df <- cbind(clean.console.df, "round" = rep(1, length(clean.console.df[,1])))

#loop for adding round number based on time
#if not on last round, set round time between current round and next round
#if on last round, set time to anything greater.
for (i in seq_along(round.starts)) {
  if (i != length(round.starts)){
    console.rounds.df[console.rounds.df$time > round.starts[i] & console.rounds.df$time <= round.starts[(i+1)], "round"] <- i
  }
  else { console.rounds.df[console.rounds.df$time > round.starts[i], "round"] <- i
  }
}


