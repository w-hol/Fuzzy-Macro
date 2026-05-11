import subprocess

class AppManager:
    def isAppOpen(self, app="Sober"):
        try:
            # Check if flatpak lists it as running
            out = subprocess.check_output(["flatpak", "ps"], stderr=subprocess.DEVNULL).decode()
            return "org.vinegarhq.Sober" in out
        except:
            return False

    def isAppFocused(self, app="Sober"):
        try:
            # Diagnostic showed window name is exactly "Sober"
            active_window_id = subprocess.check_output(["xdotool", "getactivewindow"], stderr=subprocess.DEVNULL).decode().strip()
            active_window_name = subprocess.check_output(["xdotool", "getwindowname", active_window_id], stderr=subprocess.DEVNULL).decode()
            return app in active_window_name
        except:
            return False

    def closeApp(self, app="Sober"):
        try:
            subprocess.call(["flatpak", "kill", "org.vinegarhq.Sober"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except:
            pass

    def forceQuitApp(self, app="Sober"):
        try:
            subprocess.call(["flatpak", "kill", "org.vinegarhq.Sober"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except:
            pass

    def getWindowSize(self, windowName="Sober"):
        try:
            # wmctrl output includes extra metadata; we need to be flexible
            out = subprocess.check_output(["wmctrl", "-lG"], stderr=subprocess.DEVNULL).decode()
            for line in out.splitlines():
                if windowName in line:
                    parts = line.split()
                    # wmctrl -lG format: ID, Desktop, X, Y, W, H, Machine, Title
                    # Parts[2]=X, Parts[3]=Y, Parts[4]=W, Parts[5]=H
                    x, y, w, h = map(int, parts[2:6])
                    return x, y, w, h
        except:
            pass
        return 0, 0, 1920, 1080
    
    def maximiseAppWindow(self, app="Sober"):
        # Use case-sensitive name from diagnostic
        subprocess.call(["wmctrl", "-r", "Sober", "-b", "add,maximized_vert,maximized_horz"])

    def setAppFullscreen(self, app="Sober", fullscreen=True):
        if fullscreen:
            subprocess.call(["wmctrl", "-r", "Sober", "-b", "add,fullscreen"])
        else:
            subprocess.call(["wmctrl", "-r", "Sober", "-b", "remove,fullscreen"])

    def openDeeplink(self, deeplink):
        try:
            subprocess.Popen(["xdg-open", deeplink])
        except Exception as e:
            print(f"Failed to open deeplink: {e}")
            
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
openDeeplink = manager.openDeeplink
openApp = lambda app: False
