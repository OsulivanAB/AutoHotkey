#Requires AutoHotkey v2.0

; The delay function adds a random delay between 200 and 500 milliseconds.
delay() {
    Sleep Random(2, 250)
}

; Function: shortDelay
; Description: This function adds a short delay between 100 to 200 milliseconds.
shortDelay() {
    Sleep Random(1 , 100)
}

; Function: longDelay
; Description: This function adds a short delay between 100 to 200 milliseconds.
longDelay() {
    Sleep Random(5000 , 8000)
}


; getRandomCoords(x, y, w, h)
; Returns a random x and y coordinate within a given width and height range.
; Parameters:
;   x (int): The starting x coordinate.
;   y (int): The starting y coordinate.
;   w (int): The width range.
;   h (int): The height range.
; Returns:
;   A dictionary containing the random x and y coordinates.
getRandomCoords(x, y, w, h) {
    _x := Random(x, x + w)
    _y := Random(y, y + h)
    return {x: _x, y: _y}
}

; Finds a button on the screen by searching for an image file.
; 
; @param xStart The x-coordinate of the top-left corner of the search area.
; @param yStart The y-coordinate of the top-left corner of the search area.
; @param xEnd The x-coordinate of the bottom-right corner of the search area.
; @param yEnd The y-coordinate of the bottom-right corner of the search area.
; @param path The path to the image file to search for.
; @return An object containing the x and y coordinates of the found button.
; @throws A message box with an error message if the button is not found after 60 attempts.
findImg(xStart, yStart, xEnd, yEnd, path) {
    counter := 0
    loop {
        delay()
        if ImageSearch(&X, &Y, xStart, yStart, xEnd, yEnd, "*" pixelVariation " " path) {
            return {x: X, y: Y}
        } else if counter > 30 {
            return -1
        } else {
            counter++
        }
    }
}

; Validates whether an image was found or not
; @param result The result of the image search
; @return True if the image was found, false otherwise
validateImageFound(result) {
    if result == -1
        return false
    else
        return true
}

; Exits the script and displays an error message in a message box.
; @param message The error message to display.
exitWithError(message) {
    MsgBox message
    ExitApp
}

determineUnitType(unitType) {
    switch unitType
    {
        Case 'Artillery':
            return {path: BTN_ARTILLERY_PATH, width: BTN_ARTILLERY_WIDTH, height: BTN_ARTILLERY_HEIGHT}
        Case 'Fast':
            return {path: BTN_FAST_PATH, width: BTN_FAST_WIDTH, height: BTN_FAST_HEIGHT}
        Case 'Heavy':
            return {path: BTN_HEAVY_PATH, width: BTN_HEAVY_WIDTH, height: BTN_HEAVY_HEIGHT}
        Case 'Light':
            return {path: BTN_LIGHT_PATH, width: BTN_LIGHT_WIDTH, height: BTN_LIGHT_HEIGHT}
        Case 'Ranged':
            return {path: BTN_RANGED_PATH, width: BTN_RANGED_WIDTH, height: BTN_RANGED_HEIGHT}
        Case 'Random':
            ranNum := Random(1, 5)
            switch ranNum
            {
                Case 1:
                    return determineUnitType('Artillery')
                Case 2:
                    return determineUnitType('Fast')
                Case 3:
                    return determineUnitType('Heavy')
                Case 4:
                    return determineUnitType('Light')
                Case 5:
                    return determineUnitType('Ranged')
            }
        Default:
            MsgBox "Invalid unit type: " UNIT_TYPE
    }
}