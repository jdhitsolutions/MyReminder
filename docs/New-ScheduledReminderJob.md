---
external help file: myreminder-help.xml
Module Name: myreminder
online version:
schema: 2.0.0
---

# New-ScheduledReminderJob

## SYNOPSIS

Create a scheduled reminder background job.

## SYNTAX

### Minutes (Default)

```yaml
New-ScheduledReminderJob [-Message] <String> [-At <DateTime>] [-Minutes <Int32>] [-JobName <String>]
 [-Wait <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Once

```yaml
New-ScheduledReminderJob [-Message] <String> [-At <DateTime>] [-Once] [-JobName <String>] [-Wait <Int32>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Weekly

```yaml
New-ScheduledReminderJob [-Message] <String> [-At <DateTime>] [-Weekly] [-WeeksInterval <Int32>]
 -DaysOfWeek <DayOfWeek[]> [-JobName <String>] [-Wait <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Daily

```yaml
New-ScheduledReminderJob [-Message] <String> [-At <DateTime>] [-Daily] [-DaysInterval <Int32>]
 [-JobName <String>] [-Wait <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

This command uses the MSG.EXE command line tool to send a reminder message to the currently logged on user, presumably  yourself. The intention is to set ad-hoc popup reminders for the current user. The message will automatically dismiss after 1 minute unless you use the Wait parameter.

You can schedule the reminder for a certain number of minutes set the reminder to run at a specific date and time. The default is to schedule a reminder in 1 minute. You can also create recurring daily or weekly reminders.

The function creates a scheduled background job so that you can close your PowerShell session without losing the job as well as persisting during reboots. The scheduled job will be removed upon completion. You can use the scheduled job cmdlets to view and modify any scheduled reminder job..

## EXAMPLES

### Example 1

```powershell
PS C:\> new-scheduledreminderjob "Switch over laundry" -minutes 40 -name SwitchLaundry

  ID Name            Schedule   When                      TimeRemaining  Wait(Min) Message
  -- ----            --------   ----                      -------------  --------- -------
  12 SwitchLaundry   Once       9/26/2018 12:57:26 PM          00:39:58          1 Switch over laundry
```

This command creates a new job that will display a message in 40 minutes. The message will be displayed for 1 minute, which is the default.

### Example 2

```powershell
PS C:\> new-scheduledreminderjob "Go home" -time "5:00PM" -wait 2 -once

  ID Name            Schedule   When                      TimeRemaining  Wait(Min) Message
  -- ----            --------   ----                      -------------  --------- -------
  11 Reminder-4      Once       9/26/2018 5:00:00 PM           04:42:59          2 Go home
```

Create a reminder to be displayed at 5:00PM today for 2 minutes using the default naming pattern. This example is using the time alias for the -At parameter.

### Example 3

```powershell
PS C:\> new-scheduledreminderjob -name "standup" -message "Weekly standup meeting at 1:00" -at "12:50PM" -weekly -daysofWeek Friday -wait 5

  ID Name            Schedule   When                      TimeRemaining  Wait(Min) Message
  -- ----            --------   ----                      -------------  --------- -------
  13 standup         Weekly     9/28/2018 12:50:00 PM        2.00:30:35          5 Weekly standup meeting at 1:00
```

Create a weekly popup reminder for every Friday at 12:50PM. The message will displayed for 5 minutes.

## PARAMETERS

### -Message

The text to display in the popup from MSG.EXE. This should not be an exceptionally long message. You should also try to avoid using single or double quotes. Although single quotes should be automatically turned into curly quotes. If you don't see your message, it may be because msg.exe can't display it.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Minutes

The number of minutes to wait before displaying the popup message. This is the default behavior.

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

A name to assign to the job. If you don't specify a name, the function will use the name Reminder-N where N is an incrementing counter starting at 1. This parameter has an alias of Name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Wait

The number of minutes to display the message before it automatically is dismissed. The default is 1 minute.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -At

Starts the job at the specified date and time. Enter a DateTime object, such as one that the Get-Date cmdlet returns, or a string that can be converted to a date and time, such as "April 19, 2018 15:00", "12/31", or "3am".

You do not need to specify a value if creating a reminder using -Minutes.

```yaml
Type: DateTime
Parameter Sets: Minutes
Aliases: date, dt, when, time

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: DateTime
Parameter Sets: Once, Weekly, Daily
Aliases: date, dt, when, time

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Daily

Run the reminder daily.

```yaml
Type: SwitchParameter
Parameter Sets: Daily
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DaysInterval

Specifies the number of days between occurrences on a daily schedule. For example, a value of 3 starts the scheduled job on days 1, 4, 7 and so on. The default value is 1.

```yaml
Type: Int32
Parameter Sets: Daily
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DaysOfWeek

Specifies the days of the week on which a weekly scheduled job runs. Enter day names, such as "Monday" or integers 0-6 where 0 represents Sunday. This parameter is required in the Weekly parameter set.

```yaml
Type: DayOfWeek[]
Parameter Sets: Weekly
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Once

Set a one-time reminder.

```yaml
Type: SwitchParameter
Parameter Sets: Once
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Weekly

Set a weekly reminder. You will also need to specify the days of the week.

```yaml
Type: SwitchParameter
Parameter Sets: Weekly
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WeeksInterval

Specifies the number of weeks between occurrences on a weekly job schedule. For example, a value of 3 starts the scheduled job on weeks 1, 4, 7 and so on. The default value is 1.

```yaml
Type: Int32
Parameter Sets: Weekly
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### [My.ScheduledReminder]

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-ScheduledReminderJob]()

[msg.exe]()

[Register-ScheduledJob]()

