---
external help file: myreminder-help.xml
Module Name: myreminder
online version:
schema: 2.0.0
---

# Remove-ScheduledReminderJob

## SYNOPSIS

Remove a scheduled reminder job.

## SYNTAX

### Name

```yaml
Remove-ScheduledReminderJob [-Name] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ID

```yaml
Remove-ScheduledReminderJob [-ID <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

User this command to remove a scheduled reminder job. Although you could also use Unregister-Scheduledjob. 

## EXAMPLES

### Example 1

```powershell
PS C:\>  remove-scheduledreminderjob -name standup
```

### Example 2

```powershell
PS C:\> Get-ScheduledReminderJob | Remove-ScheduledReminderJob
```

Remove all reminder jobs.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID

The scheduled reminder job ID.

```yaml
Type: Int32
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name

The name of a scheduled reminder job.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: 0
Default value: None
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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-ScheduledReminderJob]()

[New-ScheduledReminderJob]()