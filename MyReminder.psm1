#requires -version 4.0

<#
TODO: 
    
    Add parameters to set as recurring reminder
    Export and import reminders
    
#>


#region defined functions 

Function New-ScheduledReminderJob {

# .ExternalHelp MyReminder-help.xml

[cmdletbinding(DefaultParameterSetName="Minutes",SupportsShouldProcess)]
[OutputType("Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition")]

Param(
[Parameter(Position=0,Mandatory,HelpMessage="Enter the alert message text")]
[string]$Message,
[Parameter(ParameterSetName="Time")]
[ValidateNotNullorEmpty()]
[Alias("date","dt")]
[datetime]$Time,

[Parameter(ParameterSetName="Minutes")]
[ValidateScript({$_ -ge 1})]
[int]$Minutes = 1,

[Alias("Name")]
[Parameter(HelpMessage="The name of a scheduled reminder job.")]
[string]$JobName,

[ValidateScript({$_ -ge 1})]
[int]$Wait = 1
)

Begin {
    Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"  
   
} #begin

Process {
 Write-Verbose -Message "[PROCESS] Parameter set = $($PSCmdlet.ParameterSetName)"
    If ($PSCmdlet.ParameterSetName -eq 'Minutes') {
     #calculate the scheduled job time from the number of minutes
     [datetime]$Time= (Get-Date).AddMinutes($minutes)
    }

    #create the scheduled job trigger
    $Trigger = New-JobTrigger -At $Time -Once
    Write-Verbose "[PROCESS] Reminder Time = $Time"

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

    $sb = {
        #ScheduledReminderJob
        Param($cmd,$jobname)
        Invoke-Expression $cmd
        #forcibly remove the scheduledjob
        Get-ScheduledJob -Name $jobname | Unregister-ScheduledJob -Force
    }

    Write-Verbose "[PROCESS] Scriptblock = $($sb | Out-String)"

    #add some options to support laptop users
    Write-Verbose "[PROCESS] Creating scheduled job options"
    $options = New-ScheduledJobOption -ContinueIfGoingOnBattery -WakeToRun

    #create the scheduled job
    Write-Verbose "[PROCESS] Registering the scheduled reminder job"
    
    $obj = Register-ScheduledJob -ScriptBlock $sb -Name $jobName -MaxResultCount 1 -Trigger $Trigger -ArgumentList $cmd,$jobname
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

#endregion

#region Type/format extensions

Update-TypeData -TypeName My.ScheduledReminder -MemberName When -MemberType ScriptProperty -Value {$this.jobtriggers[0].At} -force

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

