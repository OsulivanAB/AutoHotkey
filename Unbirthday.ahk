#Requires AutoHotkey v2.0

Attrittion = 0
Points = 0
Points_Needed = 220
Attrition_Chance = 1.0

while (Points < Points_Needed) {
    Attrition := Attrition + 1
    if (Attrition >= 100) {
        Attrition := 0
        Points := Points + 1
    }
    if (Random() < Attrition_Chance) {
        Attrition := 0
        Points := Points + 1
    }
}