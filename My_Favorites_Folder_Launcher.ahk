#SingleInstance Force
#NoEnv
SetBatchLines -1

; Global Settings
Global SettingsFile := A_ScriptDir "\FolderLauncherSettings.ini"
Global ShowTitleBar := true
Global ForceExplorer := false
Global EnableCtrlExplorer := true
Global Folders := []
Global Hotkeys := []
Global CustomIcons := []
Global IconSize := 48
Global SlotSize := 80
Global Rows := 4
Global Cols := 4
Global TotalSlots := Rows * Cols

; Load Settings
LoadSettings()

; Main Hotkeys
F8::ShowLauncher()
!x::ShowSettings()

Return

LoadSettings() {
    Global
    IfExist, %SettingsFile%
    {
        IniRead, ShowTitleBar, %SettingsFile%, General, ShowTitleBar, 1
        IniRead, ForceExplorer, %SettingsFile%, General, ForceExplorer, 0
        IniRead, EnableCtrlExplorer, %SettingsFile%, General, EnableCtrlExplorer, 1
        
        Loop, %TotalSlots%
        {
            IniRead, path, %SettingsFile%, Folders, Folder%A_Index%, %A_Space%
            Folders.Push(path)
            
            IniRead, hotkey, %SettingsFile%, Hotkeys, Hotkey%A_Index%, %A_Space%
            Hotkeys.Push(hotkey)
            
            IniRead, icon, %SettingsFile%, Icons, Icon%A_Index%, %A_Space%
            CustomIcons.Push(icon)
            
            ; Register hotkey if it exists
            If (hotkey != "")
                RegisterSlotHotkey(A_Index, hotkey)
        }
    }
    Else
    {
        ; Initialize empty slots
        Loop, %TotalSlots%
        {
            Folders.Push("")
            Hotkeys.Push("")
            CustomIcons.Push("")
        }
    }
}

SaveSettings() {
    Global
    IniWrite, %ShowTitleBar%, %SettingsFile%, General, ShowTitleBar
    IniWrite, %ForceExplorer%, %SettingsFile%, General, ForceExplorer
    IniWrite, %EnableCtrlExplorer%, %SettingsFile%, General, EnableCtrlExplorer
    
    Loop, %TotalSlots%
    {
        path := Folders[A_Index]
        IniWrite, %path%, %SettingsFile%, Folders, Folder%A_Index%
        
        hotkey := Hotkeys[A_Index]
        IniWrite, %hotkey%, %SettingsFile%, Hotkeys, Hotkey%A_Index%
        
        icon := CustomIcons[A_Index]
        IniWrite, %icon%, %SettingsFile%, Icons, Icon%A_Index%
    }
}

RegisterSlotHotkey(slotNum, hotkeyStr) {
    Global Folders, ForceExplorer, EnableCtrlExplorer
    
    If (hotkeyStr = "")
        Return
    
    ; Try to register the hotkey
    Try
    {
        Hotkey, %hotkeyStr%, HotkeyHandler%slotNum%, On
    }
    Catch
    {
        MsgBox, 48, Hotkey Error, Failed to register hotkey: %hotkeyStr% for Slot %slotNum%
    }
}

UnregisterAllHotkeys() {
    Global TotalSlots, Hotkeys
    
    Loop, %TotalSlots%
    {
        hotkeyStr := Hotkeys[A_Index]
        If (hotkeyStr != "")
        {
            Try
            {
                Hotkey, %hotkeyStr%, Off
            }
        }
    }
}

; Hotkey handlers for each slot
HotkeyHandler1:
HotkeyHandler2:
HotkeyHandler3:
HotkeyHandler4:
HotkeyHandler5:
HotkeyHandler6:
HotkeyHandler7:
HotkeyHandler8:
HotkeyHandler9:
HotkeyHandler10:
HotkeyHandler11:
HotkeyHandler12:
HotkeyHandler13:
HotkeyHandler14:
HotkeyHandler15:
HotkeyHandler16:
    Global Folders, ForceExplorer, EnableCtrlExplorer
    
    ; Extract slot number
    RegExMatch(A_ThisLabel, "HotkeyHandler(\d+)", match)
    slotNum := match1
    
    folderPath := Folders[slotNum]
    
    If (folderPath = "" || !InStr(FileExist(folderPath), "D"))
        Return
    
    ; Open based on settings
    If (ForceExplorer)
        Run explorer.exe "%folderPath%"
    Else
        Run "%folderPath%"
Return

ShowLauncher() {
    Global
    
    If WinExist("FolderLauncher")
    {
        Gui Launcher:Destroy
        Return
    }
    
    Gui Launcher:New, +AlwaysOnTop HwndLauncherHwnd, FolderLauncher
    If (!ShowTitleBar)
        Gui Launcher:+ToolWindow -Caption
    
    Gui Launcher:Color, 1a1a1a
    Gui Launcher:Font, s9 cWhite, Segoe UI
    
    xPos := 10
    yPos := 10
    
    Loop, %Rows%
    {
        row := A_Index
        Loop, %Cols%
        {
            col := A_Index
            idx := (row - 1) * Cols + col
            
            xPos := 10 + (col - 1) * SlotSize
            yPos := 10 + (row - 1) * (SlotSize + 20)
            
            folderPath := Folders[idx]
            customIcon := CustomIcons[idx]
            
            ; Create folder icon button with slot number
            If (folderPath != "" && InStr(FileExist(folderPath), "D"))
            {
                ; Get folder icon
                iconFile := "shell32.dll"
                iconNum := 4  ; Default folder icon
                
                ; Use custom icon if specified
                If (customIcon != "" && FileExist(customIcon))
                {
                    iconFile := customIcon
                    iconNum := 1
                }
                
                SplitPath, folderPath, folderName
                
                ; Create button with folder icon
                Gui Launcher:Add, Picture, x%xPos% y%yPos% w%IconSize% h%IconSize% BackgroundTrans gSlot%idx% vIcon%idx% Icon%iconNum%, %iconFile%
                
                ; Always show labels for folders
                labelY := yPos + IconSize + 2
                StringLeft, shortName, folderName, 10
                Gui Launcher:Add, Text, x%xPos% y%labelY% w%IconSize% cWhite Center BackgroundTrans, %shortName%
            }
            Else
            {
                ; Empty slot
                Gui Launcher:Add, Text, x%xPos% y%yPos% w%IconSize% h%IconSize% BackgroundTrans Border gSlot%idx% vIcon%idx% Center 0x200, +
                labelY := yPos + IconSize + 2
                Gui Launcher:Add, Text, x%xPos% y%labelY% w%IconSize% cWhite Center BackgroundTrans, Empty
            }
        }
    }
    
    guiWidth := Cols * SlotSize + 2
    guiHeight := Rows * (SlotSize + 15) + 10
    
    ; Adjust for title bar if shown
    If (ShowTitleBar)
        Gui Launcher:Show, w%guiWidth% h%guiHeight%
    Else
    {
        clientWidth := Cols * SlotSize + 2
        clientHeight := Rows * (SlotSize + 15) + 10
        Gui Launcher:Show, w%clientWidth% h%clientHeight%
    }
    Return
}

; Individual slot handlers
Slot1:
Slot2:
Slot3:
Slot4:
Slot5:
Slot6:
Slot7:
Slot8:
Slot9:
Slot10:
Slot11:
Slot12:
Slot13:
Slot14:
Slot15:
Slot16:
    Global Folders, ForceExplorer, EnableCtrlExplorer
    
    ; Extract slot number from the label name
    RegExMatch(A_ThisLabel, "Slot(\d+)", match)
    slotNum := match1
    
    ; Get the folder path for this slot
    folderPath := Folders[slotNum]
    
    If (folderPath = "" || !InStr(FileExist(folderPath), "D"))
    {
        MsgBox, 48, Empty Slot, No folder assigned to this slot.`n`nUse Settings (Alt+X) to assign folders.
        Return
    }
    
    ; Check if Ctrl is pressed
    ctrlPressed := GetKeyState("Ctrl", "P")
    
    ; Determine how to open the folder
    If (ForceExplorer)
    {
        ; Force Explorer is enabled - always use Windows Explorer
        Run explorer.exe "%folderPath%"
    }
    Else If (ctrlPressed && EnableCtrlExplorer)
    {
        ; Ctrl+Click with EnableCtrlExplorer - open with Windows Explorer
        Run explorer.exe "%folderPath%"
    }
    Else
    {
        ; Normal click - use default file explorer
        Run "%folderPath%"
    }
    
    Gui Launcher:Destroy
Return

ShowSettings() {
    Global
    
    if WinExist("FolderLauncherSettings") {
        Gui Settings:Destroy
        return
    }
    
    Gui Settings:New, HwndSettingsHwnd, FolderLauncherSettings
    Gui Settings:Color, 1a1a1a
    Gui Settings:Font, s10 cWhite, Segoe UI
    
    ; Register custom message handler for edit control colors
    OnMessage(0x0133, "WM_CTLCOLOREDIT")
    
    ; Create tab control
    Gui Settings:Add, Tab, x10 y10 w630 h770, Main|Slots 1-8|Slots 9-16
    
    ; --- Main Tab ---
    Gui Settings:Tab, Main
    Gui Settings:Add, Text, x20 y40 cWhite, General Settings and Tips:
    Gui Settings:Add, Checkbox, x20 y70 vShowTitleBarCheck cWhite, Show Title Bar
    if (ShowTitleBar)
        GuiControl Settings:, ShowTitleBarCheck, 1
    
    Gui Settings:Add, Checkbox, x20 y100 vForceExplorerCheck cWhite, Make Explorer Default (Always Open with Windows Explorer)
    if (ForceExplorer)
        GuiControl Settings:, ForceExplorerCheck, 1
    
    Gui Settings:Add, Checkbox, x20 y130 vEnableCtrlExplorerCheck cWhite, Enable Ctrl+Click to Open with Explorer
    if (EnableCtrlExplorer)
        GuiControl Settings:, EnableCtrlExplorerCheck, 1
    
    Gui Settings:Font, s10 cFFFF00, Segoe UI
    Gui Settings:Add, Text, x20 y170 w600, NOTE: Hotkeys work even when launcher is hidden. Changes require saving.
    Gui Settings:Font, s10 cWhite, Segoe UI
	
	; --- Hotkey instructions ---
    Gui Settings:Font, s10 c00FF90, Segoe UI
    Gui Settings:Add, Text, x20 y210, HOTKEYS SYMBOLS: ! = Alt, # = Win, ^ = Ctrl, + = Shift  |  Example: ^!f = Ctrl+Alt+F.
    
	; --- Slots Instructions ---
    Gui Settings:Font, s10 cFE66E9, Segoe UI
    Gui Settings:Add, Text, x20 y250, SLOTS: Every Slot can have its own custom icon and hotkey.
	
	; --- Author ---
	Gui Settings:Font, s12 cFFFFFF, Arial
    Gui Settings:Add, Text, x400 y750, Copyright: AndrianAngel (Github)
	
	; --- update ---
	Gui Settings:Font, s20 cFFFFFF, Adobe Gothic Std B
    Gui Settings:Add, Text, x250 y490, --- 2026 ---
    
	; --- TITLE ---
    Gui Settings:Font, s16 cFFFFFF, Adobe Gothic Std B
    Gui Settings:Add, Text, x70 y450, ---------- MY FAVORITES FOLDER LAUNCHER ----------
	
	; --- Additional Tip ---
    Gui Settings:Font, s10 c00FFFF, Segoe UI
    Gui Settings:Add, Text, x20 y290, Ctrl+Left Click Open_With_Explorer Feature: Use this without Make_Explorer_Default Feature. 

	
	; --- Slots 1-8 Tab ---
    Gui Settings:Tab, Slots 1-8
    yPos := 50
    Loop, 8 {
        slotNum := A_Index
        currentPath := Folders[slotNum]
        currentHotkey := Hotkeys[slotNum]
        currentIcon := CustomIcons[slotNum]
        
        Gui Settings:Add, Text, x20 y%yPos% w60 cWhite, Slot %slotNum%:
        Gui Settings:Add, Edit, x90 y%yPos% w450 h25 vFolderPath%slotNum% Background2d2d2d cWhite HwndHEdit%slotNum%, %currentPath%
        DllCall("UxTheme\SetWindowTheme", "Ptr", HEdit%slotNum%, "Str", "DarkMode_Explorer", "Ptr", 0)
        Gui Settings:Add, Button, x550 y%yPos% w80 h25 vBrowse%slotNum% gBrowseFolder HwndHBtn%slotNum%, Browse
        DllCall("UxTheme\SetWindowTheme", "Ptr", HBtn%slotNum%, "Str", "DarkMode_Explorer", "Ptr", 0)
        
        yPos += 30
        Gui Settings:Font, s8 cAAAAAA, Segoe UI
        Gui Settings:Add, Text, x90 y%yPos% w60, Icon (.ico):
        Gui Settings:Font, s10 cWhite, Segoe UI
        Gui Settings:Add, Edit, x150 y%yPos% w310 h22 vIconPath%slotNum% Background2d2d2d cWhite HwndHEditIcon%slotNum%, %currentIcon%
        DllCall("UxTheme\SetWindowTheme", "Ptr", HEditIcon%slotNum%, "Str", "DarkMode_Explorer", "Ptr", 0)
        Gui Settings:Add, Button, x470 y%yPos% w70 h22 vBrowseIcon%slotNum% gBrowseIcon HwndHBtnIcon%slotNum%, Browse
        DllCall("UxTheme\SetWindowTheme", "Ptr", HBtnIcon%slotNum%, "Str", "DarkMode_Explorer", "Ptr", 0)
        
        yPos += 25
        Gui Settings:Font, s8 cAAAAAA, Segoe UI
        Gui Settings:Add, Text, x90 y%yPos% w60, Hotkey:
        Gui Settings:Font, s10 cWhite, Segoe UI
        Gui Settings:Add, Edit, x150 y%yPos% w150 h22 vHotkey%slotNum% Background2d2d2d cWhite HwndHEditHK%slotNum%, %currentHotkey%
        DllCall("UxTheme\SetWindowTheme", "Ptr", HEditHK%slotNum%, "Str", "DarkMode_Explorer", "Ptr", 0)
        
        yPos += 35
    }
    
    ; --- Slots 9-16 Tab ---
    Gui Settings:Tab, Slots 9-16
    yPos := 50
    Loop, 8 {
        slotNum := A_Index + 8
        currentPath := Folders[slotNum]
        currentHotkey := Hotkeys[slotNum]
        currentIcon := CustomIcons[slotNum]
        
        Gui Settings:Add, Text, x20 y%yPos% w60 cWhite, Slot %slotNum%:
        Gui Settings:Add, Edit, x90 y%yPos% w450 h25 vFolderPath%slotNum% Background2d2d2d cWhite HwndHEdit%slotNum%, %currentPath%
        DllCall("UxTheme\SetWindowTheme", "Ptr", HEdit%slotNum%, "Str", "DarkMode_Explorer", "Ptr", 0)
        Gui Settings:Add, Button, x550 y%yPos% w80 h25 vBrowse%slotNum% gBrowseFolder HwndHBtn%slotNum%, Browse
        DllCall("UxTheme\SetWindowTheme", "Ptr", HBtn%slotNum%, "Str", "DarkMode_Explorer", "Ptr", 0)
        
        yPos += 30
        Gui Settings:Font, s8 cAAAAAA, Segoe UI
        Gui Settings:Add, Text, x90 y%yPos% w60, Icon (.ico):
        Gui Settings:Font, s10 cWhite, Segoe UI
        Gui Settings:Add, Edit, x150 y%yPos% w310 h22 vIconPath%slotNum% Background2d2d2d cWhite HwndHEditIcon%slotNum%, %currentIcon%
        DllCall("UxTheme\SetWindowTheme", "Ptr", HEditIcon%slotNum%, "Str", "DarkMode_Explorer", "Ptr", 0)
        Gui Settings:Add, Button, x470 y%yPos% w70 h22 vBrowseIcon%slotNum% gBrowseIcon HwndHBtnIcon%slotNum%, Browse
        DllCall("UxTheme\SetWindowTheme", "Ptr", HBtnIcon%slotNum%, "Str", "DarkMode_Explorer", "Ptr", 0)
        
        yPos += 25
        Gui Settings:Font, s8 cAAAAAA, Segoe UI
        Gui Settings:Add, Text, x90 y%yPos% w60, Hotkey:
        Gui Settings:Font, s10 cWhite, Segoe UI
        Gui Settings:Add, Edit, x150 y%yPos% w150 h22 vHotkey%slotNum% Background2d2d2d cWhite HwndHEditHK%slotNum%, %currentHotkey%
        DllCall("UxTheme\SetWindowTheme", "Ptr", HEditHK%slotNum%, "Str", "DarkMode_Explorer", "Ptr", 0)
        
        yPos += 35
    }
    
    ; Back to default (no tab)
    Gui Settings:Tab
    
    ; Save/Cancel buttons
    Gui Settings:Add, Button, x20 y790 w100 gSaveSettingsBtn HwndHBtnSave, Save
    Gui Settings:Add, Button, x130 y790 w100 gCancelSettings HwndHBtnCancel, Cancel
    DllCall("UxTheme\SetWindowTheme", "Ptr", HBtnSave, "Str", "DarkMode_Explorer", "Ptr", 0)
    DllCall("UxTheme\SetWindowTheme", "Ptr", HBtnCancel, "Str", "DarkMode_Explorer", "Ptr", 0)
    
    Gui Settings:Show, w650 h840 Center
}

BrowseFolder:
    Global TotalSlots
    
    ; Get the focused control name
    GuiControlGet, ctrl, Settings:FocusV
    
    ; Extract slot number from button name
    slotNum := 0
    Loop, %TotalSlots%
    {
        If (ctrl = "Browse" . A_Index)
        {
            slotNum := A_Index
            Break
        }
    }
    
    If (slotNum = 0)
        Return
    
    FileSelectFolder, selected, , 3, Select Folder
    If (selected != "")
        GuiControl Settings:, FolderPath%slotNum%, %selected%
Return

BrowseIcon:
    Global TotalSlots
    
    ; Get the focused control name
    GuiControlGet, ctrl, Settings:FocusV
    
    ; Extract slot number from button name
    slotNum := 0
    Loop, %TotalSlots%
    {
        If (ctrl = "BrowseIcon" . A_Index)
        {
            slotNum := A_Index
            Break
        }
    }
    
    If (slotNum = 0)
        Return
    
    FileSelectFile, selected, 3, , Select Icon File, Icon Files (*.ico)
    If (selected != "")
        GuiControl Settings:, IconPath%slotNum%, %selected%
Return

SaveSettingsBtn:
    Global Folders, Hotkeys, CustomIcons, ShowTitleBar, ForceExplorer, EnableCtrlExplorer, TotalSlots
    
    Gui Settings:Submit, NoHide
    
    ; Unregister old hotkeys
    UnregisterAllHotkeys()
    
    ; Save new settings
    Loop, %TotalSlots%
    {
        GuiControlGet, path, Settings:, FolderPath%A_Index%
        Folders[A_Index] := path
        
        GuiControlGet, hotkey, Settings:, Hotkey%A_Index%
        Hotkeys[A_Index] := hotkey
        
        GuiControlGet, icon, Settings:, IconPath%A_Index%
        CustomIcons[A_Index] := icon
        
        ; Register new hotkey
        If (hotkey != "")
            RegisterSlotHotkey(A_Index, hotkey)
    }
    
    GuiControlGet, ShowTitleBar, Settings:, ShowTitleBarCheck
    GuiControlGet, ForceExplorer, Settings:, ForceExplorerCheck
    GuiControlGet, EnableCtrlExplorer, Settings:, EnableCtrlExplorerCheck
    
    SaveSettings()
    Gui Settings:Destroy
    
    If WinExist("FolderLauncher")
        Gui Launcher:Destroy
    
    MsgBox, 64, Success, Settings saved!`n`nPress F8 to toggle launcher.`nHotkeys are now active.
Return

CancelSettings:
    OnMessage(0x0133, "")  ; Unregister message handler
    Gui Settings:Destroy
Return

SettingsGuiClose:
    OnMessage(0x0133, "")  ; Unregister message handler
    Gui Settings:Destroy
Return

WM_CTLCOLOREDIT(wParam, lParam) {
    ; Set text color to white
    DllCall("SetTextColor", "Ptr", wParam, "UInt", 0xFFFFFF)
    ; Set background color to dark gray (2d2d2d)
    DllCall("SetBkColor", "Ptr", wParam, "UInt", 0x2d2d2d)
    ; Return brush for background
    Return DllCall("CreateSolidBrush", "UInt", 0x2d2d2d, "Ptr")
}

LauncherGuiClose:
    Gui Launcher:Destroy
Return

ReloadScript:
    Reload
Return

ExitScript:
    ExitApp
Return