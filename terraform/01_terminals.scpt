#!/usr/bin/osascript
on run argv
  set BASEDIR to item 1 of argv as string
  tell application "iTerm2"
    # open first terminal start consumer raw event salesforce_contacts
    tell current session of current tab of current window
        write text "cd " & BASEDIR
        write text "bash ./01-consumer-raw-events.sh"
        split horizontally with default profile
        split vertically with default profile
    end tell
    # open second terminal and start ice-breaker
    tell second session of current tab of current window
        write text "cd " & BASEDIR
        write text "bash ./01_start_ice_breaker.sh"
    end tell
    # open third terminal and consume salesfroce_myleads
    tell third session of current tab of current window
        write text "cd " & BASEDIR
        write text "bash ./01-consumer-salesforce_calls.sh"
    end tell
  end tell
end run