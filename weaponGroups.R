# figure out how console outputs guns

#categorize guns to make colorizing more compact
gun.classes <- c("knife", "pistol", "SMG", "rifle", "grenade", "shotgun", "sniper", "machine gun")
factor(gun.classes, labels = gun.classes)


# number of weapon groups
0:6

# 0 = knife = knife
# 1 = pistol = deagle, 