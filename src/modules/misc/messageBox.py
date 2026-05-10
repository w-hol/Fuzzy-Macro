import os
import sys
import subprocess

def msgBox(title, text):
    try:
        import tkinter as tk
        from tkinter import messagebox
        root = tk.Tk()
        root.withdraw()
        messagebox.showinfo(title, text)
        root.destroy()
    except Exception:
        print(f"[{title}] {text}")

def msgBoxOkCancel(title, text):
    try:
        import tkinter as tk
        from tkinter import messagebox
        root = tk.Tk()
        root.withdraw()
        result = messagebox.askokcancel(title, text)
        root.destroy()
        return result
    except Exception:
        return False