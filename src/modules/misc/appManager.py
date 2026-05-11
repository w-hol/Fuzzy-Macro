import subprocess

class AppManager:
    def isAppOpen(self, app="sober"):
        try:
            return subprocess.call(["pgrep", "-f", app], stdout=subprocess.DEVNULL) == 0
        except:
            return False

    def isAppFocused(self, app="sober"):
        try:
            active_window_id = subprocess.check_output(["xdotool", "getactivewindow"], stderr=subprocess.DEVNULL).decode().strip()
            active_window_name = subprocess.check_output(["xdotool", "getwindowname", active_window_id], stderr=subprocess.DEVNULL).decode().lower()
            return app.lower() in active_window_name
        except:
            return False

    def closeApp(self, app="sober"):
        subprocess.call(["pkill", "-f", app], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    def forceQuitApp(self, app="sober"):
        subprocess.call(["pkill", "-9", "-f", app], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    def getWindowSize(self, windowName="sober"):
        try:
            out = subprocess.check_output(["wmctrl", "-lG"], stderr=subprocess.DEVNULL).decode()
            for line in out.splitlines():
                if windowName.lower() in line.lower():
                    parts = line.split()
                    x, y, w, h = map(int, parts[2:6])
                    return x, y, w, h
        except:
            pass
        return 0, 0, 1920, 1080

    def maximiseAppWindow(self, app="sober"):
        subprocess.call(["wmctrl", "-r", app, "-b", "add,maximized_vert,maximized_horz"])

    def setAppFullscreen(self, app="sober", fullscreen=True):
        if fullscreen:
            subprocess.call(["wmctrl", "-r", app, "-b", "add,fullscreen"])
        else:
            subprocess.call(["wmctrl", "-r", app, "-b", "remove,fullscreen"])

# Single instance
manager = AppManager()

# Expose methods
isAppOpen = manager.isAppOpen
isAppFocused = manager.isAppFocused
closeApp = manager.closeApp
forceQuitApp = manager.forceQuitApp
getWindowSize = manager.getWindowSize
maximiseAppWindow = manager.maximiseAppWindow
setAppFullscreen = manager.setAppFullscreen
# Stub openApp as it's typically OS-specific
openApp = lambda app: False
