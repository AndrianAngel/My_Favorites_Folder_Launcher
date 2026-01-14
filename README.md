---

## 📂 My Favorites Folder Launcher

A customizable folder launcher utility built with AutoHotkey (AHK), designed to give users quick access to their favorite directories through a grid-based GUI and global hotkeys. The project includes both .ahk source files and a compiled .exe for easy use without requiring AutoHotkey installed.

---

## ✨ Key Features

- Launcher Toggle
  - Press F8 to show or hide the launcher window.
  - Press Alt+X to open the settings panel.

- Folder Grid
  - Supports 16 folder slots arranged in a 4×4 grid.
  - Each slot can be assigned:
    - A folder path (with browse button).
    - A custom icon (.ico file).
    - A hotkey for instant access.

- Settings Panel
  - Organized into three tabs:
    1. Main Tab
       - Checkbox: Show/Hide Title Bar
       - Checkbox: Make Explorer Default (always open with Windows Explorer)
       - Checkbox: Enable Ctrl+Click to Open with Explorer
       - Helpful notes and usage tips displayed in color-coded text.
    2. Slots 1–8 Tab
       - Editable fields for folder paths.
       - Browse buttons for selecting folders.
       - Custom icon fields with browse buttons.
       - Hotkey assignment fields.
    3. Slots 9–16 Tab
       - Same functionality as Slots 1–8, covering the remaining slots.

- Hotkey Support
  - Hotkeys remain active even when the launcher is hidden.
  - Syntax follows AutoHotkey conventions:
    - ! = Alt
    - # = Win
    - ^ = Ctrl
    - + = Shift  
    Example: ^!F = Ctrl+Alt+F

- INI-Based Configuration
  - All settings (folders, icons, hotkeys, preferences) are saved in a FolderLauncherSettings.ini file.
  - Ensures portability and easy backup/restore of configurations.

---

## 🖼️ GUI Design (from screenshots)

- Dark-themed interface with white text for readability.
- Folder icons displayed in a grid with labels underneath.
- Empty slots show a placeholder (+ symbol and “Empty” label).
- Settings window styled with tabs, dark edit controls, and highlighted notes for usability.

---

## ⚙️ Technical Highlights

- Written in AutoHotkey v1.
- Uses Gui commands to build dynamic launcher and settings windows.
- Implements hotkey registration/unregistration with error handling.
- Supports custom message handling (WM_CTLCOLOREDIT) for dark mode edit controls.
- Modular functions:
  - LoadSettings(), SaveSettings(), RegisterSlotHotkey(), UnregisterAllHotkeys()
  - Separate handlers for each slot (Slot1–Slot16) and hotkey (HotkeyHandler1–HotkeyHandler16).

---

## 📝 Notes & Tips

- If you encounter white glitches while configuring settings:
  - Press Save, then Exit Script, and restart the launcher.
- Both .ahk source files and a compiled .exe are provided for convenience.
- Copyright:
  - AndrianAngel (GitHub), 2026.

---

## 🚀 Use Cases

- Quickly open frequently used project folders.
- Assign hotkeys for instant navigation without opening the launcher.
- Customize icons for visual clarity and personalization.
- Portable setup with INI-based configuration, ideal for multi-PC workflows.

---


## 👋 Click behavior and Explorer priority

- Simple left-click: Opens the folder with your default file manager—built-in or third‑party—when Make Explorer Default is unchecked.  
- Ctrl+left-click: Opens the folder with Windows Explorer, regardless of the default file manager.  
- Priority rule: If Make Explorer Default is enabled, all opens use Windows Explorer—this overrides Ctrl behavior and any third‑party defaults.  
- Tip for third‑party managers: To use your third‑party file manager on simple left‑click and reserve Explorer for Ctrl+left‑click, disable Make Explorer Default.

---
