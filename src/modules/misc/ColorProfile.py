#!/usr/bin/env python3

class DisplayColorProfile:
    """Stub implementation for Linux - color profile management is not supported."""
    def __init__(self):
        pass

    def getMainDisplayId(self):
        return None

    def getDisplayUUID(self, display_id):
        return None

    def resetDisplayProfile(self):
        return True

    def setCustomProfile(self, profile_path):
        return True

    def getCurrentColorProfile(self):
        return "System Default"