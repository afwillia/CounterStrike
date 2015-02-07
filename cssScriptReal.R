####this is a script to analyze CSS data
library(stringr)
#import console data
console.data <- readLines(con = "file.log")

#find rows with killing information.
kill.data <- grep("killed", console.data, value=TRUE)

#make separate df for timestamped kills
kill.data.ts <- kill.data[123:144]


#split all lines by " killed " and " with ", so we get killer, killed,
# and weapon
data.list <- sapply(kill.data, 
                    function(x) strsplit(x, split = " killed | with "))

#good data for non timestamped entries
data.list.norm <- data.list[1:122]

#timestamp has 13 characters of date we can get rid of, 23 counting time.
#time is HH:MM:SS:   -- maybe filter out last colon?
#delete all time information for now... come back to it later
substring(kill.data.ts[1], 24, nchar(kill.data.ts[1]))

sapply(kill.data.ts, substring, 24, nchar(kill.data.ts[x]))

#this is a much better way of representing the data and tabling it.
df <- data.frame(matrix(unlist(data.list.norm), 
                        nrow=length(data.list.norm), byrow=T))
names(df) <- c("killer", "killed", "weapon")

#table of kills sorted by most.
sort(table(df$killer), decreasing = TRUE)


#subset number of kills for me
kill.subset <- subset(df, subset = killer == "Bilbo T. Baggins")
kill.numbers <- sort(table(kill.subset$killed), decreasing = TRUE)

#barplot people player killed
barplot(kill.numbers, border = NA, 
        names.arg = names(kill.numbers),las = 2,,ylim =c(0,5))

#subset killed
killed.subset <- subset(df, subset = killed == "Bilbo T. Baggins")
killed.numbers <- sort(table(killed.subset$killer), decreasing = TRUE)

#barplot of people who killed player
barplot(killed.numbers, border = NA, 
        names.arg = names(killed.numbers),las = 2,,ylim =c(0,5))




