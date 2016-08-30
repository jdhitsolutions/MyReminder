---
external help file: myreminder-Help.xml
online version: 
schema: 2.0.0
---

# Get-ScheduledReminderJob
## SYNOPSIS
Get scheduled reminder jobs.

## SYNTAX

```
Get-ScheduledReminderJob [[-Name] <String>]
```

## DESCRIPTION
Get scheduled reminder jobs. You can use this command to filter out reminder jobs from other scheduled jobs.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> get-scheduledreminderjob


Id         Name            JobTriggers     Command                    Enabled
--         ----            -----------     -------                    -------
8          Reminder-2      1               ...                        True
9          Reminder-3      1               ...                        True
10         HR Meeting      1               ...                        True
```

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> get-scheduledreminderjob reminder*

Id         Name            JobTriggers     Command                    Enabled
--         ----            -----------     -------                    -------
8          Reminder-2      1               ...                        True
9          Reminder-3      1               ...                        True
```

### -------------------------- EXAMPLE 3 --------------------------
```
PS C:\> get-scheduledreminderjob reminder-2 | get-jobtrigger | set-jobtrigger -At "11:00AM"
```

Get the Reminder-2 job and modify the time to 11:00AM today.

### -------------------------- EXAMPLE 4 --------------------------
```
PS C:\> get-scheduledreminderjob hr* | Unregister-ScheduledJob
```

Get the HR Meeting scheduled job as seen in the first example and remove it.

### -------------------------- EXAMPLE 5 --------------------------
```
PS C:\> get-scheduledreminderjob | Unregister-ScheduledJob
```

Get all scheduled reminder jobs and remove them.

## PARAMETERS

### -Name
The name of a scheduled reminder job. See examples.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 0
Default value: 
Accept pipeline input: False
Accept wildcard characters: True
```

## INPUTS

### None

## OUTPUTS

### [Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition]

## NOTES
Last Updated: August 30, 2016
Version     : 3.1

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-ScheduledReminderJob]()

[Get-ScheduledJob]()

