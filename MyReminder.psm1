#requires -version 4.0

#region defined functions 

Function New-ScheduledReminderJob {

# .ExternalHelp MyReminder-help.xml

[cmdletbinding(DefaultParameterSetName="Minutes",SupportsShouldProcess)]
[OutputType("Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition")]

Param(
[Parameter(
Position=0,
Mandatory,
HelpMessage="Enter the alert message text",
ValueFromPipelineByPropertyName
)]
[string]$Message,

[Parameter(
ValueFromPipelineByPropertyName
)]
[Parameter(ParameterSetName='Daily')]
[Parameter(ParameterSetName='Weekly')]
[Parameter(ParameterSetName='Once')]
[ValidateNotNullorEmpty()]
[Alias("date","dt","when","time")]
[datetime]$At,

[Parameter(ParameterSetName='Minutes')]
[int]$Minutes = 1,

[Parameter(ParameterSetName='Once',ValueFromPipelineByPropertyName)]
[switch]$Once,

[Parameter(ParameterSetName='Daily',ValueFromPipelineByPropertyName)]
[switch]$Daily,

[Parameter(ParameterSetName='Daily',ValueFromPipelineByPropertyName)]
[int]$DaysInterval,

[Parameter(ParameterSetName='Weekly', ValueFromPipelineByPropertyName)]
[switch]$Weekly,

[Parameter(ParameterSetName='Weekly',ValueFromPipelineByPropertyName)]
[int]$WeeksInterval,

[Parameter(ParameterSetName='Weekly', Mandatory,ValueFromPipelineByPropertyName)]
[ValidateNotNullOrEmpty()]
[System.DayOfWeek[]]$DaysOfWeek,

[Parameter(
HelpMessage="The name of a scheduled reminder job.",
ValueFromPipelineByPropertyName
)]
[Alias("Name")]
[string]$JobName,

[Parameter(
HelpMessage="The number of minutes to display the popup message",
ValueFromPipelineByPropertyName
)]
[ValidateScript({$_ -ge 1})]
[int]$Wait = 1
)

Begin {
    Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"  
} #begin

Process {
     Write-Verbose "[PROCESS] Parameter set = $($PSCmdlet.ParameterSetName)"
     [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
     Write-Verbose "[PROCESS] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n" 
     
     If (-Not $At) {
        #calculate the scheduled job time from the number of minutes
        Write-Verbose "[PROCESS] Calculating AT $minutes minute(s) from now"
        [datetime]$At= (Get-Date).AddMinutes($minutes)
        #Add to PSBoundParameters for splatting purposes
        $PSBoundParameters.Add("At",$At)
        #this also implies -Once
        $PSBoundParameters.Add("Once",$True)
    }

    #create the scheduled job trigger
    #remove bound parameters that don't belong to New-JobTrigger
    $PSBoundParameters.remove("JobName") | Out-Null
    $PSBoundParameters.remove("Message") | Out-Null
    $PSBoundParameters.remove("Wait") | Out-Null
    $PSBoundParameters.remove("Whatif") | Out-Null
    $PSBoundParameters.remove("Confirm") | Out-Null
    $PSBoundParameters.remove("Minutes") | Out-Null

    $Trigger = New-JobTrigger @PSBoundParameters

    Write-Verbose "[PROCESS] Reminder Time = $At"

    if (-Not $JobName) {
        #get last job ID to build the jobname
        #ignore any errors if job not found
        Write-Verbose "[PROCESS] Checking for previous Reminder scheduled jobs"
        $lastjob = Get-ScheduledJob -Name "Reminder*" -ErrorAction SilentlyContinue | sort ID | select -last 1
    
        if ($lastjob) {
            #define a regular expression
            [regex]$rx ="\d+$"
            #extract the counter number
            [string]$counter = ([int]$rx.Match($lastJob.name).Value +1)
        }
        else {
            [string]$counter = 1
        }
        #define the job name
        $jobName = "Reminder-$Counter"

    } #if no job name specified

    Write-Verbose "[PROCESS] Jobname = $jobname"
    
    #define the msg.exe expression   
    [int]$WaitTime = $Wait * 60
    Write-Verbose "[PROCESS] Display Wait time = $WaitTime seconds"
    Write-Verbose "[PROCESS] Defining expression"

    #define the command to run
    [string]$cmd = "msg.exe $env:username /Time:$WaitTime $Message"
    
    Write-Verbose "[PROCESS] Command to execute = $cmd"
    
    <#
    The scriptblock to run. Don't remove the comment for 
    ScheduledReminderJob as that is used identify these
    type of jobs.
    #>

    $action = @"
        #ScheduledReminderJob
        Param(`$cmd,`$jobname)
        Invoke-Expression `$cmd
"@

    If ($PSboundParameters.ContainsKey("Once")) {
    $action+= @"

    #forcibly remove the scheduledjob
    Get-ScheduledJob -Name `$jobname | Unregister-ScheduledJob -Force
"@
    }
    $sb = [scriptblock]::Create($action)

    Write-Verbose "[PROCESS] Scriptblock = $($sb | Out-String)"

    #add some options to support laptop users
    Write-Verbose "[PROCESS] Creating scheduled job options"
    $options = New-ScheduledJobOption -ContinueIfGoingOnBattery -WakeToRun

    #create the scheduled job
    Write-Verbose "[PROCESS] Registering the scheduled reminder job"
    
    $regParams = @{
        ScriptBlock = $sb
        Name = $jobName 
        MaxResultCount =  1 
        Trigger = $Trigger
        ArgumentList = @($cmd,$jobname)

    }

    $obj = Register-ScheduledJob @regParams
    #insert the new typename
    $obj.psobject.Typenames.Insert(0,"My.ScheduledReminder")
    $obj

} #process

End {
    Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
} #end

} #end function

Function Get-ScheduledReminderJob {

# .ExternalHelp MyReminder-help.xml

[cmdletbinding()]
[OutputType("Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition")]
Param(
[string]$Name
)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
    Write-Verbose "[BEGIN  ] Getting all scheduled reminder jobs"
    $jobs = (Get-ScheduledJob).Where({$_.command -match "#ScheduledReminderJob"})
} #begin


Process {

    if ($jobs) {
        Write-Verbose "[PROCESS] Found $($jobs.count) scheduled reminder job(s)"

        if ($name) {
            #filter results for name
            Write-Verbose "[PROCESS] filtering for $name"
            $jobs.where({$_.name -like $name}).foreach({
             $_.psobject.Typenames.Insert(0,"My.ScheduledReminder")
             $_
            }) 
        
        }
        else {
            #write results
            Write-Verbose "[PROCESS] writing all reminder jobs to the pipeline"
            ($jobs).foreach({
             $_.psobject.Typenames.Insert(0,"My.ScheduledReminder")
             $_
            })       
        
        }
   
    } #if $jobs
    else {
        Write-Host "No scheduled reminder jobs found." -ForegroundColor magenta
    }

} #process


End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

} #end function

Function Remove-ScheduledReminderJob {
[cmdletbinding(SupportsShouldProcess)]

Param(
[Parameter(Position = 0,Mandatory,ParameterSetName = "Name")]
#the assigned reminder job name
[string]$Name,
[Parameter(ValueFromPipelineByPropertyName,ParameterSetName = "ID")]
#the scheduled job ID number
[int]$ID
)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
    #display PSBoundparameters formatted nicely for Verbose output  
   [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
   Write-Verbose "[BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n" 
} #begin

Process {
   Write-Verbose "[PROCESS] Using Parameter set: $($PSCmdlet.ParameterSetName)"
    Try {
        #remove -Whatif
        $PSBoundParameters.Remove("Whatif") | Out-Null
        $task = Get-Scheduledjob @PSBoundParameters -ErrorAction Stop
     }
    Catch {
        Write-Warning $_.exception.Message
        #bail out
        Return
     }
   Write-Verbose "[PROCESS] Removing reminder job $($task.id)"     
   $task | Unregister-ScheduledJob

} #process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end


} #endfunction

Function Export-ScheduledReminderJob {
[cmdletbinding(SupportsShouldProcess)]
Param(

[ValidateScript({$_.EndsWith(".csv")})]
[string]$Path = ".\ScheduledReminders_$((get-date).ToShortDateString().Replace("/","_")).csv",
[switch]$Append,
[System.Text.Encoding]$Encoding

)

Write-Verbose "Starting: $($MyInvocation.Mycommand)"

#display PSBoundparameters formatted nicely for Verbose output  
[string]$pb = ($PSBoundParameters | format-table -AutoSize | Out-String).TrimEnd()
Write-Verbose "PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | out-string) `n" 

#get jobs
$jobs = Get-ScheduledReminderJob

if ($jobs) {
    #only export if there are reminder jobs
    Write-Verbose "Exporting reminder jobs to $Path"
    if (-Not ($PSBoundParameters.ContainsKey("Path"))) {
        #use the default path value
        $PSBoundParameters.Path = $Path
    }
    $jobs | Select Name,When,Wait,Message | Export-Csv @PSBoundParameters
}
else {
    Write-Warning "No reminder jobs found to export"
}
Write-Verbose "Ending: $($MyInvocation.Mycommand)"

} #end function

#endregion

#region Type/format extensions

Update-TypeData -TypeName My.ScheduledReminder -MemberName When -MemberType ScriptProperty -Value {
#use the SCHTASKS.EXE command line tool to get next run time
$find = schtasks /query /tn "\Microsoft\Windows\PowerShell\ScheduledJobs\$($this.Name)" /fo csv /nh | 
convertFrom-CSV -Header "TaskPath","NextRun","Status"

$find.NextRun -as [datetime]

} -force

Update-TypeData -TypeName My.ScheduledReminder -MemberName Schedule -MemberType ScriptProperty -Value {
#use the SCHTASKS.EXE command line tool to get next run time
$find = schtasks /query /tn "\Microsoft\Windows\PowerShell\ScheduledJobs\$($this.Name)" /fo csv /v | 
convertFrom-CSV

if ($find.'Start Time' -match "One") {
    "Once"
}
else {
    $find.'Start Time'
}


} -force


Update-TypeData -TypeName My.ScheduledReminder -MemberName Wait -MemberType ScriptProperty -Value {
[regex]$rx = "(?<=Time:)\d+"
$data = $this.InvocationInfo.parameters.item(0).where({$_.name -eq 'ArgumentList'}).value[0]
$rx.Match($data).Value
} -force

Update-TypeData -TypeName My.ScheduledReminder -MemberName Message -MemberType ScriptProperty -Value {
[regex]$rx = "(?<=\d+\s).*$"
$data = $this.InvocationInfo.parameters.item(0).where({$_.name -eq 'ArgumentList'}).value[0]
$rx.Match($data).Value
} -force

Update-TypeData -typeName My.ScheduledReminder -DefaultDisplayPropertySet "ID","Name","When","Wait","Message" -Force

#endregion

#region Aliases

Set-Alias -Name tickle -Value New-ScheduledReminderJob
Set-Alias -Name nsrj -Value New-ScheduledReminderJob
Set-Alias -Name gsrj -Value Get-ScheduledReminderJob

#endregion

