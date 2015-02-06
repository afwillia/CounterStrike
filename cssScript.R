####this is a script to analyze CSS data
#create sample players and weapons
guns <- c("awp", "deagle", "m249", "ak47", "knife")
players <- c("andy", "bob", "chris", "doug", "eddie", "frank")

#test console line
paste(sample(players, 1), k, sample(players, 1), "with", sample(guns,1), " ")

#simulate console output
data <- replicate(100, paste(sample(players, 1), k, sample(players, 1), 
                             "with", sample(guns,1), "."))

#find rows with killing information.
grep("was killed by", data)

#split strings based on spaces- not ideal for players with spaces in name
strsplit(data[[1]], " ")

#split all lines by "was killed by" and "with", so we get killer, killed,
# and weapon
data.list <- sapply(data, 
                    function(x) strsplit(x, split = "was killed by|with"))

#example subset of data.list
data.list[[1]][length(data.list[[1]])-1]

#this is a sloppy way of recompiling data
all <- unlist(data.list)
table(all)

#this is a much better way of representing the data and tabling it.
df <- data.frame(matrix(unlist(data.list), 
                        nrow=length(data.list), byrow=T))
names(df) <- c("killer", "killed", "weapon")

table(df$weapon)
