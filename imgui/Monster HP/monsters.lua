m = {}

-- Standard enemy colors are white, rare enemies are yellow, bosses are red.
-- Minibosses are a less threatening red. 8)
-- Changing the second value to "false" makes the enemy not appear on the monster
-- reader.

-- Forest
m[1] = { 0xFFFFFFFF, true } -- Hildebear / Hildelt
m[2] = { 0xFFFFFF00, true } -- Hildeblue / Hildetorr
m[3] = { 0xFFFFFFFF, true } -- Mothmant / Mothvert
m[4] = { 0xFFFFFFFF, true } -- Monest / Mothvist
m[5] = { 0xFFFFFFFF, true } -- Rag Rappy / El Rappy
m[6] = { 0xFFFFFF00, true } -- Al Rappy / Pal Rappy
m[7] = { 0xFFFFFFFF, true } -- Savage Wolf / Gulgus
m[8] = { 0xFFFFFFFF, true } -- Barbarous Wolf / Gulgus-gue
m[9] = { 0xFFFFFFFF, true } -- Booma / Bartle
m[10] = { 0xFFFFFFFF, true } -- Gobooma / Barble
m[11] = { 0xFFFFFFFF, true } -- Gigobooma / Tollaw

-- Cave
m[12] = { 0xFFFFFFFF, true } -- Grass Assassin / Crimson Assassin
m[13] = { 0xFFFFFFFF, true } -- Poison Lily / Ob Lily
m[14] = { 0xFFFFFF00, true } -- Nar Lily / Mil Lily
m[15] = { 0xFFFFFFFF, true } -- Nano Dragon
m[16] = { 0xFFFFFFFF, true } -- Evil Shark / Vulmer
m[17] = { 0xFFFFFFFF, true } -- Pal Shark / Govulmer
m[18] = { 0xFFFFFFFF, true } -- Guil Shark / Melqueek
m[19] = { 0xFFFFFFFF, true } -- Pofuilly Slime
m[20] = { 0xFFFFFF00, true } -- Pouilly Slime
m[21] = { 0xFFFFFFFF, true } -- Pan Arms
m[22] = { 0xFFFFFFFF, true } -- Migium
m[23] = { 0xFFFFFFFF, true } -- Hidoom

-- Mine
m[24] = { 0xFFFFFFFF, true } -- Dubchic / Dubchich
m[25] = { 0xFFFFFFFF, true } -- Garanz / Baranz
m[26] = { 0xFFFFFFFF, true } -- Sinow Beat / Sinow Blue
m[27] = { 0xFFFFFFFF, true } -- Sinow Gold / Sinow Red
m[28] = { 0xFFFFFFFF, true } -- Canadine / Canabin
m[29] = { 0xFFFFFFFF, true } -- Canane / Canune
m[49] = { 0xFFFFFFFF, true } -- Dubwitch
m[50] = { 0xFFFFFFFF, true } -- Gillchic / Gillchich

-- Ruins
m[30] = { 0xFFFFFFFF, true } -- Delsaber
m[31] = { 0xFFFFFFFF, true } -- Chaos Sorcerer / Gran Sorcerer
m[32] = { 0xFFFFFFFF, true } -- Bee R / Gee R
m[33] = { 0xFFFFFFFF, true } -- Bee L / Gee L
m[34] = { 0xFFFFFFFF, true } -- Dark Gunner
m[35] = { 0xFFFFFFFF, true } -- Death Gunner
m[36] = { 0xFFFFFFFF, true } -- Dark Bringer
m[37] = { 0xFFFFFFFF, true } -- Indi Belra
m[38] = { 0xFFFFFFFF, true } -- Claw
m[39] = { 0xFFFFFFFF, true } -- Bulk
m[40] = { 0xFFFFFFFF, true } -- Bulclaw
m[41] = { 0xFFFFFFFF, true } -- Dimenian / Arlan
m[42] = { 0xFFFFFFFF, true } -- La Dimenian / Merlan
m[43] = { 0xFFFFFFFF, true } -- So Dimenian / Del-D

-- Episode 1 Bosses
m[44] = { 0xFFFF0000, true } -- Dragon / Sil Dragon
m[45] = { 0xFFFF0000, true } -- De Rol Le / Dal Ral Lie
m[46] = { 0xFFFF0000, true } -- Vol Opt / Vol Opt ver.2
m[47] = { 0xFFFF0000, true } -- Dark Falz

-- VR Temple	
m[51] = { 0xFFFFFF00, true } -- Love Rappy
m[73] = { 0xFFFF0000, true } -- Barba Ray
m[74] = { 0xFFFFFFFF, true } -- Pig Ray
m[75] = { 0xFFFFFFFF, true } -- Ul Ray
m[79] = { 0xFFFFFFFF, true } -- St. Rappy
m[80] = { 0xFFFFFF00, true } -- Hallo Rappy
m[81] = { 0xFFFFFF00, true } -- Egg Rappy

-- VR Spaceship
m[76] = { 0xFFFF0000, true } -- Gol Dragon

-- Central Control Area
m[52] = { 0xFFFFFFFF, true } -- Merillia
m[53] = { 0xFFFFFFFF, true } -- Meriltas
m[54] = { 0xFFFFFFFF, true } -- Gee
m[55] = { 0xFFFF8080, true } -- Gi Gue
m[56] = { 0xFFFF8080, true } -- Mericarol
m[57] = { 0xFFFF8080, true } -- Merikle
m[58] = { 0xFFFF8080, true } -- Mericus
m[59] = { 0xFFFFFFFF, true } -- Ul Gibbon
m[60] = { 0xFFFFFFFF, true } -- Zol Gibbon
m[61] = { 0xFFFF8080, true } -- Gibbles
m[62] = { 0xFFFFFFFF, true } -- Sinow Berill
m[63] = { 0xFFFFFFFF, true } -- Sinow Spigell
m[77] = { 0xFFFF0000, true } -- Gal Gryphon
m[82] = { 0xFFFFFFFF, true } -- Ill Gill
m[83] = { 0xFFFFFFFF, true } -- Del Lily
m[84] = { 0xFFFF8080, true } -- Epsilon
m[87] = { 0xFFFFFFFF, true } -- Epsigard

-- Seabed
m[64] = { 0xFFFFFFFF, true } -- Dolmolm
m[65] = { 0xFFFFFFFF, true } -- Dolmdarl
m[66] = { 0xFFFFFFFF, true } -- Morfos
m[67] = { 0xFFFFFFFF, true } -- Recobox
m[68] = { 0xFFFFFFFF, true } -- Recon
m[69] = { 0xFFFFFFFF, true } -- Sinow Zoa
m[70] = { 0xFFFFFFFF, true } -- Sinow Zele
m[71] = { 0xFFFFFFFF, true } -- Deldepth
m[72] = { 0xFFFFFFFF, true } -- Delbiter
m[78] = { 0xFFFF0000, true } -- Olga Flow
m[85] = { 0xFFFFFFFF, true } -- Gael	
m[86] = { 0xFFFFFFFF, true } -- Giel

-- Crater
m[88] = { 0xFFFFFFFF, true } -- Astark
m[89] = { 0xFFFFFFFF, true } -- Yowie
m[90] = { 0xFFFFFFFF, true } -- Satellite Lizard
m[94] = { 0xFFFFFFFF, true } -- Zu
m[95] = { 0xFFFFFF00, true } -- Pazuzu
m[96] = { 0xFFFFFFFF, true } -- Boota
m[97] = { 0xFFFFFFFF, true } -- Za Boota
m[98] = { 0xFFFFFFFF, true } -- Ba Boota
m[99] = { 0xFFFFFFFF, true } -- Dorphon
m[100] = { 0xFFFFFFFF, true } -- Dorphon Eclair
m[104] = { 0xFFFFFFFF, true } -- Sand Rappy
m[105] = { 0xFFFFFF00, true } -- Del Rappy

-- Desert
m[91] = { 0xFFFFFFFF, true } -- Merissa A
m[92] = { 0xFFFFFF00, true } -- Merissa AA
m[93] = { 0xFFFFFFFF, true } -- Girtablulu
m[101] = { 0xFFFFFFFF, true } -- Goran
m[102] = { 0xFFFFFFFF, true } -- Goran Detonator
m[103] = { 0xFFFFFFFF, true } -- Pyro Goran
m[106] = { 0xFFFF0000, true } -- Saint-Milion
m[107] = { 0xFFFF0000, true } -- Shambertin
m[108] = { 0xFFFF8000, true } -- Kondrieu

-- Other
m[48] = { 0xFFFFFFFF, true } -- Container

return 
{
    m = m,
}
