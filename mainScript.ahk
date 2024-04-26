#Requires AutoHotkey v2.0.10
#SingleInstance Force

#Include config.ahk
#Include imageInfo.ahk
#Include routineFunctions.ahk

WinGetClientPos &X, &Y, &W, &H, "Forge of Empires - Google Chrome"
WinActivate "Forge of Empires - Google Chrome"
CoordMode "Pixel", "Client"
SendMode "Event"

TAVERN_FLAG := A_NOW - 3600000
EVENT_LIST_FLAG := true
; Burn Light
; UNIT_SELECTION := {Fast: 0, Heavy: 0, Light: 8, Artillery: 0, Ranged: 0, Rogue: 0}
; Artillery
; UNIT_SELECTION := {Fast: 0, Heavy: 0, Light: 0, Artillery: 8, Ranged: 0, Rogue: 0}
; Heavy Heavy
UNIT_SELECTION := {Fast: 0, Heavy: 4, Light: 0, Artillery: 0, Ranged: 0, Rogue: 4}
; Heavy
; UNIT_SELECTION := {Fast: 0, Heavy: 2, Light: 0, Artillery: 0, Ranged: 0, Rogue: 6}
; Ranged
; UNIT_SELECTION := {Fast: 0, Heavy: 0, Light: 0, Artillery: 0, Ranged: 4, Rogue: 4}

loop 20 {
    delay()
    if ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" pixelVariation " " BTN_ATTACK_PATH) {
        battleground(getRandomCoords(X, Y, BTN_ATTACK_WIDTH, BTN_ATTACK_HEIGHT))
    } else if ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" pixelVariation " " BTN_GE_ATTACK) {
        ge(getRandomCoords(X, Y, BTN_GE_ATTACK_WIDTH, BTN_GE_ATTACK_HEIGHT))
    } else if ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" pixelVariation " " BTN_DEFEND_PATH) {
        ge(getRandomCoords(X, Y, BTN_DEFEND_WIDTH, BTN_DEFEND_HEIGHT))
    } else if ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" pixelVariation " " BTN_ARENA_BUTTON_ALL_PATH) {
        pvp(Y + (BTN_ARENA_BUTTON_ALL_HEIGHT * (1/3)), Y + (BTN_ARENA_BUTTON_ALL_HEIGHT * (2/3)))
    } else if (EVENT_LIST_FLAG && ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" pixelVariation " " TOWN_HALL_PATH)) {
        global EVENT_LIST_FLAG
        Result := MsgBox("Do you want to take a minute to update events?",, "YesNo")
        WinActivate "Forge of Empires - Google Chrome"
        if (Result = "Yes") {
            updateEvents()
        }
        EVENT_LIST_FLAG := false
    } else if (A_NOW - TAVERN_FLAG > 3600000 && ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" pixelVariation " " FRIEND_ICON_PATH)) {
        tavern_check()
    } 
}

Reload
Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
MsgBox("There was an issue reloading. The script will now exit.")
ExitApp

updateEvents(){
    if(!openNewsTab() || !openEventHistory()) {
        MsgBox "Something went wrong, try again later"
        return
    }
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_NEXT_EVENT_PAGE_PATH)
    if validateImageFound(loc) {
        cords := getRandomCoords(loc.x, loc.y, BTN_NEXT_EVENT_PAGE_WIDTH, BTN_NEXT_EVENT_PAGE_HEIGHT)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        shortDelay()
        loop 120 {
            quickClick_human()
        }
    } else {
        MsgBox "Something went wrong, try again later"
        return
    }
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_EXIT_PATH)
    if validateImageFound(loc) {
        cords := getRandomCoords(loc.x, loc.y, BTN_EXIT_WIDTH, BTN_EXIT_HEIGHT)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        shortDelay()
        Click
    }
}

quickClick_human() {
    Click
    Sleep(Random(250, 500))    
}

openEventHistory() {
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_EVENT_HISTORY_PATH)
    if validateImageFound(loc) {
        cords := getRandomCoords(loc.x, loc.y, BTN_EVENT_HISTORY_WIDTH, BTN_EVENT_HISTORY_HEIGHT)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        shortDelay()
        Click
        return true
    } else {
        return false
    }
}

openNewsTab() {
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_NEWS_PATH)
    if validateImageFound(loc) {
        cords := getRandomCoords(loc.x, loc.y, BTN_NEWS_WIDTH, BTN_NEWS_HEIGHT)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        shortDelay()
        Click
        return true
    } else {
        return false
    }
}

tavern_check() {
    global TAVERN_FLAG
    Result := MsgBox("Do you want to take a minute to do tavern?",, "YesNo")
    WinActivate "Forge of Empires - Google Chrome"
    if (Result = "Yes") {
        tavern()
    }
    TAVERN_FLAG := A_NOW
}

tavern() {
    delay()
    openFriends()
    if(!pressStartOfFriends()) {
        MsgBox "Something went wrong, try again later"
        return
    }
    loop 32 {
        Sleep(Random(2000, 3000))
        visitTaverns()
        if(!pressNextFriendPage()) {
            MsgBox "Something went wrong, try again later"
            return
        }
    }
    delay()
    closeFriends()
}

visitTaverns() {
    loop {
        loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_TAVERN_SEAT_PATH)
        if validateImageFound(loc) {
            cords := getRandomCoords(loc.x, loc.y, BTN_TAVERN_SEAT_WIDTH, BTN_TAVERN_SEAT_HEIGHT)
            MouseMove cords.x, cords.y, MOUSE_SPEED
            shortDelay()
            Click
            shortDelay()
        } else {
            break
        }
    }
}

pvp(yStart, yEnd) {
    loc := findImg(0, yStart, A_ScreenWidth, yEnd, BTN_ARENA_BUTTON_PATH)
    if validateImageFound(loc) {
        cords := getRandomCoords(loc.x, loc.y, BTN_ARENA_BUTTON_WIDTH, BTN_ARENA_BUTTON_HEIGHT)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        shortDelay()
        Click
        fightScreen()
    }
}

fightScreen() {
    if(!waitForBattleScreen()) {
        MsgBox "Something went wrong, try again later"
        ExitApp
    }
    removeUnits()
    delay()
    addUnits(UNIT_SELECTION)
    delay()
    cords := getAutoBattle()
    MouseMove cords.x, cords.y, MOUSE_SPEED
    shortDelay()
    Click
    delay()
    battleLoop()
    delay()
}

ge(cords) {
    MouseMove cords.x, cords.y, MOUSE_SPEED
    shortDelay()
    Click
    fightScreen()
}

battleground(cords) {
    MouseMove cords.x, cords.y, MOUSE_SPEED
    shortDelay()
    Click
    delay()    
    fightScreen()
}

battleLoop() {
    flag := true
    cords := ''
    while (flag) {
        if ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" pixelVariation " " BTN_GREEN_OK_PATH) {
            cords := getRandomCoords(X, Y, BTN_GREEN_OK_WIDTH, BTN_GREEN_OK_HEIGHT)
            MouseMove cords.x, cords.y, MOUSE_SPEED
            shortDelay()
            Click
            flag := false
        } else if ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" pixelVariation " " BTN_AUTO_BATTLE2_PATH) {
            delay()
            cords := getRandomCoords(X, Y, BTN_AUTO_BATTLE2_WIDTH, BTN_AUTO_BATTLE2_HEIGHT)
            MouseMove cords.x, cords.y, MOUSE_SPEED
            shortDelay()
            Click
        }
    }
    shortDelay()
    checkForReward()
}

pressStartOfFriends() {
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_FRONT_OF_FRIENDS_PATH)
    if validateImageFound(loc) {
        cords := getRandomCoords(loc.x, loc.y, BTN_FRONT_OF_FRIENDS_WIDTH, BTN_FRONT_OF_FRIENDS_HEIGHT)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        shortDelay()
        Click
        return true
    } else {
        return false
    }
}

openFriends() {
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_EXPAND_FRIENDS_PATH)
    if validateImageFound(loc) {
        cords := getRandomCoords(loc.x, loc.y, BTN_EXPAND_FRIENDS_WIDTH, BTN_EXPAND_FRIENDS_HEIGHT)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        shortDelay()
        Click
        return true
    } else {
        return false
    }
}

closeFriends() {
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_COLLAPSE_FRIENDS_PATH)
    if validateImageFound(loc) {
        cords := getRandomCoords(loc.x, loc.y, BTN_COLLAPSE_FRIENDS_WIDTH, BTN_COLLAPSE_FRIENDS_HEIGHT)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        shortDelay()
        Click
        return true
    } else {
        return false
    }

}

pressNextFriendPage() {
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_NEXT_FRIEND_PAGE_PATH)
    if validateImageFound(loc) {
        cords := getRandomCoords(loc.x, loc.y, BTN_NEXT_FRIEND_PAGE_WIDTH, BTN_NEXT_FRIEND_PAGE_HEIGHT)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        shortDelay()
        Click
        shortDelay()
        cords := getRandomCoords(cords.x + 20, cords.y - 100, 100, 100)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        return true
    } else {
        return false
    }
}

getGreenOkButton() {
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_GREEN_OK_PATH)
    if validateImageFound(loc)
        return getRandomCoords(loc.x, loc.y, BTN_GREEN_OK_WIDTH, BTN_GREEN_OK_HEIGHT)    
    else
        exitWithError("Green OK button not found")
}

getUnitButton() {
    unit := determineUnitType(UNIT_TYPE)
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, unit.path)
    if validateImageFound(loc)
        return getRandomCoords(loc.x, loc.y, unit.width, unit.height)
    else
        exitWithError("Unit button not found")
}

getAttackButton() {
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_ATTACK_PATH)
    if validateImageFound(loc)
        return getRandomCoords(loc.x, loc.y, BTN_ATTACK_WIDTH, BTN_ATTACK_HEIGHT)
    else
        exitWithError("Attack button not found")
}

getArtilleryUnitButton(Age) {
    switch Age, "Off"
    {
        case "Progressive":
            loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_ARTILLERY_PROGRESSIVE_PATH)
            if validateImageFound(loc)
                return getRandomCoords(loc.x, loc.y, BTN_ARTILLERY_PROGRESSIVE_WIDTH, BTN_ARTILLERY_PROGRESSIVE_HEIGHT)
            else
                exitWithError("Artillery Progressive button not found")
    }
}

getAutoBattle() {
    loc := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_AUTO_BATTLE_PATH)
    if validateImageFound(loc)
        return getRandomCoords(loc.x, loc.y, BTN_AUTO_BATTLE_WIDTH, BTN_AUTO_BATTLE_HEIGHT)
    else
        exitWithError("Auto Battle button not found")
}

checkForReward() {
    counter := 0
    loop {
        delay()
        if ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" pixelVariation " " BTN_BROWN_OK_PATH) {
            cords := getRandomCoords(X, Y, BTN_BROWN_OK_WIDTH, BTN_BROWN_OK_HEIGHT)
            MouseMove cords.x, cords.y, MOUSE_SPEED
            shortDelay()
            Click
            break
        } else {
            if counter > 5
                break
            else
                counter++
        }
    }
}

removeUnits() {
    if ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" pixelVariation " " BTN_EMPTY_TROOPS_PATH) {
        return
    } else {        
        REMOVE_UNIT := coordinates["remove_units"]
        cords := getRandomCoords(REMOVE_UNIT.X, REMOVE_UNIT.Y, REMOVE_UNIT.WIDTH, REMOVE_UNIT.HEIGHT)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        clickUnits(cords.x, cords.y, 8 )
    }
}

addUnits(unitList) {
    addUnit("Fast", unitList.Fast)
    addUnit("Heavy", unitList.Heavy)
    addUnit("Light", unitList.Light)
    addUnit("Artillery", unitList.Artillery)
    addUnit("Ranged", unitList.Ranged)
    addUnit("Rogue", unitList.Rogue)
}

addUnit(unitType, count) {
    if count > 0 {
        cords := getTabCords(unitType)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        shortDelay()
        Click
        delay()
        FIRST_UNIT := coordinates["first_unit"]
        cords := getRandomCoords(FIRST_UNIT.X, FIRST_UNIT.Y, FIRST_UNIT.WIDTH, FIRST_UNIT.HEIGHT)
        MouseMove cords.x, cords.y, MOUSE_SPEED
        shortDelay()
        clickUnits(cords.x, cords.y, count)
    }
}

getTabCords(tab) {
    switch tab
    {
        Case 'Artillery':
            cords := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_ARTILLERY_PATH)
            return getRandomCoords(cords.x, cords.y, BTN_ARTILLERY_WIDTH, BTN_ARTILLERY_HEIGHT)
        Case 'Fast':
            cords := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_FAST_PATH)
            return getRandomCoords(cords.x, cords.y, BTN_FAST_WIDTH, BTN_FAST_HEIGHT)
        Case 'Heavy':
            cords := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_HEAVY_PATH)
            return getRandomCoords(cords.x, cords.y, BTN_HEAVY_WIDTH, BTN_HEAVY_HEIGHT)
        Case 'Light':
            cords := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_LIGHT_PATH)
            return getRandomCoords(cords.x, cords.y, BTN_LIGHT_WIDTH, BTN_LIGHT_HEIGHT)
        Case 'Ranged':
            cords := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_RANGED_PATH)
            return getRandomCoords(cords.x, cords.y, BTN_RANGED_WIDTH, BTN_RANGED_HEIGHT)
        Case 'Rogue':
            cords := findImg(0, 0, A_ScreenWidth, A_ScreenHeight, BTN_LIGHT_PATH)
            return getRandomCoords(cords.x, cords.y, BTN_LIGHT_WIDTH, BTN_LIGHT_HEIGHT)
    }
}

clickUnits(x, y, count) {
    loop count {
        Click
        Sleep Random(1 , 150)
    }
}

waitForBattleScreen() {
    _current := A_NOW
    WHILE A_NOW - _current < 5000 {
        if ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" pixelVariation " " BTN_ARMY_MANAGEMENT_PATH) {
            return true
        }
    }
    return false
}