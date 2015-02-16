<<<<<<< HEAD
#this splits data up into rounds. or at least adds round number to data
#make sure player varible is set for graph below

=======
>>>>>>> 6582ee3a1e3ad4b2ac4e93540733a4bee589e524
#import console data. ideally change file to log location
data.file <- "D:/Program Files/Steam/SteamApps/common/Counter-Strike Source/cstrike/file.log"
console.data <- readLines(con = data.file)

#find rows with killing information. maybe add second grep for "with"
kill.data <- grep("killed", console.data, value=TRUE)
kill.data <- grep("with", kill.data, value=TRUE)

round.data <- grep("Most kills:", console.data, value = TRUE)

round.time <- lapply(round.data, substr, 14, 21)
round.time <- strptime(as.character(round.time), "%H:%M:%S")

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

<<<<<<< HEAD
#bind round column to df. set default round to 1
round.df <- cbind(clean.df, "round" = rep(1, length(clean.df[,1])))

#loop for adding round number based on time
#if not on last round, set round time between current round and next round
#if on last round, set time to anything greater.
=======
round.df <- cbind(clean.df, "round" = rep(NA, length(clean.df[,1])))

#loop for adding round number based on time
>>>>>>> 6582ee3a1e3ad4b2ac4e93540733a4bee589e524
for (i in seq_along(round.time)) {
  if (i != length(round.time)){
  round.df[round.df$time > round.time[i] & round.df$time <= round.time[(i+1)], "round"] <- i
}
<<<<<<< HEAD
  else { round.df[round.df$time > round.time[i], "round"] <- i
}
}

###################

#make df of each player's kills by round
x <- tapply(round.df$killer, round.df$round, table)
y <- lapply(x, as.data.frame)

merge.all <- function(x, y)
  merge(x, y, all=TRUE, by="Var1")

#warning is just for duplicated col names
out <- Reduce(merge.all, y)
names(out) <- c("player", paste("round", 1:18, sep = "."))

#subset out player column and calcluate sums and means
#means aren't accurate because they don't adjust for players that joined late or left early
c <- 2:19
a <- rowSums(out[,c])
b <- rowMeans(out[,c])
names(b) <- out[,1]


###################
pdf(paste0(Sys.Date(), player, "RoundKills.pdf"), 11.5, 8)

#plot kills per round
s <- subset(round.df, subset = killer == player)
plot(table(s$round), main = paste(player, "Kills by Round", sep = " "), 
     ylab = "Kills")
#add line for average kills/round
#too tricky now- need to determine how many rounds individuals played
#abline(h = nrow(s)/(max(s$round) - s$round[1]), col = "blue")

dev.off()

=======
  else { round.df[round.df$time > round.time[i], "round"] <- i + 1
}
}
>>>>>>> 6582ee3a1e3ad4b2ac4e93540733a4bee589e524
