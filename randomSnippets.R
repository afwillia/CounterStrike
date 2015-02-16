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


##
x <- table(round.df$killer)
kills.df <- as.data.frame(x)
t <- tapply(round.df$killer, round.df$round, table)

##
rt <- data.frame(round.time)
rt <- cbind(rt, NA, NA, NA)
names(rt) <- names(clean.df)
new.df <- rbind(clean.df, rt)
new.df <- new.df[order(new.df$time),]

#bind round column to df. set default round to 1
new.df <- cbind(new.df, "round" = rep(1, length(new.df[,1])))
new.df$time <- as.POSIXct(new.df$time)
