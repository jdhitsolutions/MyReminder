---
external help file: myreminder-Help.xml
online version: 
schema: 2.0.0
---

# New-ScheduledReminderJob
## SYNOPSIS
Create a scheduled reminder background job.

## SYNTAX

### Minutes (Default)
```
New-ScheduledReminderJob [-Message] <String> [-Minutes <Int32>] [-JobName <String>] [-Wait <Int32>] [-WhatIf]
 [-Confirm]
```

### Time
```
New-ScheduledReminderJob [-Message] <String> [-Time <DateTime>] [-JobName <String>] [-Wait <Int32>] [-WhatIf]
 [-Confirm]
```

## DESCRIPTION
This command uses the MSG.EXE command line tool to send a reminder message to the currently logged on user, presumably yourself.
The intention is to set ad-hoc popup reminders for the current user. The message will automatically dismiss after 1 minute unless you use the Wait parameter.

You can schedule the reminder for a certain number of minutes set the reminder to run at a specific date and time.
The default is to schedule a reminder in 1 minute.

The function creates a scheduled background job so that you can close your PowerShell session without losing the job as well as persisting during reboots.
The scheduled job will be removed upon completion. You can use the scheduled job cmdlets to view and modify.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> new-scheduledreminderjob "Switch over laundry" -minutes 40 -name SwitchLaundry

Id         Name            JobTriggers     Command                        Enabled
--         ----            -----------     -------                        -------
1          SwitchLaundry   1               ...                            True
```
This command creates a new job that will display a message in 40 minutes. The message will be displayed for 1 minute, which is the default.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> new-scheduledreminderjob "Go home" -time "5:00PM" -wait 2

Id         Name            JobTriggers     Command                       Enabled
--         ----            -----------     -------                       -------
7          Reminder-1      1               ...                           True
```
Create a reminder to be displayed at 5:00PM today for 2 minutes using the default naming pattern.

## PARAMETERS

### -Message
The text to display in the popup from MSG.EXE.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -Minutes
The number of minutes to wait before displaying the popup message.

```yaml
Type: Int32
Parameter Sets: Minutes
Aliases: 

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobName
A name to assign to the job.
If you don't specify a name, the function will use the name Reminder-N where N is an incrementing counter starting at 1.
This parameter has an alias of Name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
The number of minutes to display the message before it automatically is dismissed.
The default is 1 minute.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Time
The date and time to display the popup. If you enter just a time, it will default to the current day.See examples.
This parameter has aliases of date and dt.

```yaml
Type: DateTime
Parameter Sets: Time
Aliases: date, dt

Required: False
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None

## OUTPUTS

### [Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition]

## NOTES
Last Updated: August 30, 2016
Version     : 3.1
Author      : Jeff Hicks (@JeffHicks)
              http://jdhitsolutions.com/blog

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

  
## RELATED LINKS

[msg.exe]()

[Register-ScheduledJob]()
