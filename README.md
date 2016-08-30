# MyReminder #

This PowerShell module is an extension of scheduled jobs and is designed to display a popup reminder for the current user (you) at a given time.

The commands in the module are wrappers for the scheduled job commands that will create and display a scheduled job reminder. The module defines an additional type name that is used with custom type and formatting extensions.

The benefit of using a scheduled job is that PowerShell does not need to be running and the reminder job will persist between sessions and reboots.

## Limitations ##

* This module is NOT designed to run on PowerShell Core (ie Linux or macOS).
* The scheduled reminder is intended for the current or interactive user. This system is not designed or intended to send reminders to remote computers.

_last update August 30, 2016_