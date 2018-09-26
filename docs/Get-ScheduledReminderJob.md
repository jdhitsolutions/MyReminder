---
external help file: myreminder-help.xml
Module Name: myreminder
online version:
schema: 2.0.0
---

# Get-ScheduledReminderJob

## SYNOPSIS

Get scheduled reminder jobs.

## SYNTAX

```yaml
Get-ScheduledReminderJob [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION

Get scheduled reminder jobs. You can use this command to filter out reminder jobs from other scheduled jobs.

## EXAMPLES

### Example 1

```powershell
PS C:\> get-scheduledreminderjob


ID Name            Schedule   When                      TimeRemaining  Wait(Min) Message
-- ----            --------   ----                      -------------  --------- -------
 6 Reminder-1      Daily      9/27/2018 11:45:00 AM          23:19:55          1 Test 1
 7 Reminder-2      Weekly     10/3/2018 11:50:00 AM        6.23:24:55          1 Test 2
 8 Reminder-3      Daily      9/28/2018 11:55:00 AM        1.23:29:54          1 Test 3
11 EndOfDay        Once       9/26/2018 5:00:00 PM           04:34:54          2 Go home
```

### Example 2

```powershell
PS C:\> get-scheduledreminderjob reminder*

ID Name            Schedule   When                      TimeRemaining  Wait(Min) Message
-- ----            --------   ----                      -------------  --------- -------
 6 Reminder-1      Daily      9/27/2018 11:45:00 AM          23:19:55          1 Test 1
 7 Reminder-2      Weekly     10/3/2018 11:50:00 AM        6.23:24:55          1 Test 2
 8 Reminder-3      Daily      9/28/2018 11:55:00 AM        1.23:29:54          1 Test 3
```

### Example 3

```powershell
PS C:\> get-scheduledreminderjob reminder-2 | get-jobtrigger | set-jobtrigger -At "11:00AM"
```

Get the Reminder-2 job and modify the time to 11:00AM today.

## PARAMETERS

### -Name

The name of a scheduled reminder job. See examples.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
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

[New-ScheduledReminderJob]()

[Get-ScheduledJob]()
