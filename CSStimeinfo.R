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


rt <- data.frame(round.time)
rt <- cbind(rt, NA, NA, NA)
names(rt) <- names(clean.df)
new.df <- rbind(clean.df, rt)
new.df <- new.df[order(new.df$time),]

#bind round column to df. set default round to 1
new.df <- cbind(new.df, "round" = rep(1, length(new.df[,1])))
new.df$time <- as.POSIXct(new.df$time)


#loop for adding round number based on time
#if not on last round, set round time between current round and next round
#if on last round, set time to anything greater.
for (i in seq_along(round.time)) {
  if (i != length(round.time)){
    new.df[new.df$time > round.time[i] & new.df$time <= round.time[(i+1)], "round"] <- i + 1
  }
  else { new.df[new.df$time > round.time[i], "round"] <- i + 1
  }
}

new.df$round <- as.factor(new.df$round)



####################################################
## this stuff is all experimental
#trying to determine the length of each round

x <- table(round.df$killer)
kills.df <- as.data.frame(x)
t <- tapply(round.df$killer, round.df$round, table)

#plot kills per round
player = "Bilbo T. Baggins"
s <- subset(round.df, subset = killer == player)
plot(table(s$round))
#add line for average kills/round
abline(h = nrow(s)/(max(s$round) - s$round[1]), col = "blue")

#make time relative to first round
transform(round.df, round.time = time - time[1])

df <- group_by(new.df, round)


#want to make loop to find length of each round, but I need to incorporate
#end of last round or start of current round somehow.
for (i in levels(new.df$round)) {
  d <- subset(new.df, subset = round == i)
}



#make time relative to first round
transform(round.df, round.time = time - time[1])

#df <- group_by(round.df, round)



x <- table(round.df$killer)
kills.df <- as.data.frame(x)
t <- tapply(round.df$killer, round.df$round, table)



#transpose the matrix and clean it up... there's got to be a simpler way
#simpler way is not to transpose, take rowMeans of merged DF, subsetting out names
t.out <- t(out)
t.out <- data.frame(t.out)
t.out <- sapply(t.out, as.character)
t.out <- data.frame(t.out)
names.t <- t.out[1,]
names(t.out) <- names.t
t.out <- t.out[-1,]
t.out <- sapply(t.out, function(x) as.numeric(as.character(x)))

#calculate mean kills per round per player
player.mean <- colMeans(t.out)
round.mean <- mean(player.mean)




out

all <-out[,1]



