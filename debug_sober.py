import subprocess
import os

def run(cmd):
    try:
        return subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True).decode().strip()
    except Exception as e:
        return f"Error: {e}"

print("--- 1. Window Manager Check (wmctrl) ---")
print(run("wmctrl -lG | grep -i sober"))

print("\n--- 2. Process Tree (pgrep + ps) ---")
# Find all PIDs that have 'sober' in their command line
pids = run("pgrep -f sober").split()
if pids and "Error" not in pids[0]:
    for pid in pids:
        details = run(f"ps -p {pid} -o pid,ppid,state,comm,args")
        print(f"PID {pid}:\n{details}\n")
else:
    print("No PIDs found matching 'sober'")

print("\n--- 3. Bubblewrap Check ---")
print(run("pgrep -a bwrap"))

print("\n--- 4. Active Window Focus (xdotool) ---")
# Run this while you have the sober window focused!
print("Focus the Sober window now (waiting 3 seconds)...")
import time
time.sleep(3)
win_id = run("xdotool getactivewindow")
print(f"Active Window ID: {win_id}")
if win_id and "Error" not in win_id:
    print(f"Active Window Name: {run(f'xdotool getwindowname {win_id}')}")
    print(f"Active Window PID: {run(f'xdotool getwindowpid {win_id}')}")
