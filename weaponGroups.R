# figure out how console outputs guns

#categorize guns to make colorizing more compact
gun.classes <- c("pistol", "shotgun", "smg", "rifle", "sniper", "machine gun", "knife", "grenade")
factor(gun.classes, labels = gun.classes)


# number of weapon groups
0:6

# 0 = knife = knife
# 1 = pistol = deagle, glock, usp, p228, elite, fiveseven
# 2 = shotgun = m3, xm1014
# 3 = smg = mac10, tmp, mp5navy, ump45, p90
# 4 = rifle = galil, ak47, sg500, famas, m4a1, aug, sg552
# 5 = sniper = scout, awp, g3sg1
# 6 = machine gun = m249
# 7 = knife = knife
# 8 = grenade = hegrenade


      Glock (glock)
       USP (usp)
       228 Compact (p228)
       Desert Eagle (deagle)
       Dualies (elite)
       Five-Seven (fiveseven)
       
       Pump Shotgun (m3)
       Auto Shotgun (xm1014)
       
       Mac-10 (mac10)
       TMP (tmp)
       MP5 (mp5navy)
       UMP (ump45)
       P90 (p90)
       
       Defender (galil)
       AK-47/CV-47 (ak47)
       Krieg Commando (sg550)
       Clarion (famas)
       Maverick M4A1 Colt (m4a1)
       Bullpup (aug)
       Scout (scout)
       Krieg 552 (sg552)
       AWP (awp)
       D3/AU1 (g3sg1)
       
       M249 (m249)