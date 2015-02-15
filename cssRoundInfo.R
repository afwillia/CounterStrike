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

round.df <- cbind(clean.df, "round" = rep(NA, length(clean.df[,1])))

#loop for adding round number based on time
for (i in seq_along(round.time)) {
  if (i != length(round.time)){
  round.df[round.df$time > round.time[i] & round.df$time <= round.time[(i+1)], "round"] <- i
}
  else { round.df[round.df$time > round.time[i], "round"] <- i + 1
}
}
