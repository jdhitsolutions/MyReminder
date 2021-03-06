#
# Module manifest for module 'myreminder'
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'myreminder.psm1'

CompatiblePSEditions = "Desktop"

# Version number of this module.
ModuleVersion = '3.2.2'

# ID used to uniquely identify this module
GUID = 'e9a86bb7-11c8-4199-86c1-fac2914cdc44'

# Author of this module
Author = 'Jeff Hicks'

# Company or vendor of this module
CompanyName = 'JDH Information Technology Solutions, Inc.'

# Copyright statement for this module
Copyright = '(c) 2015-2018 JDH Information Technology Solutions, Inc.'

# Description of the functionality provided by this module
Description = 'A PowerShell module that uses scheduled jobs as a popup reminder or alerting system.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
DotNetFrameworkVersion = '5.1'

# Minimum version of the common language runtime (CLR) required by this module
CLRVersion = '4.0'

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = ''

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = 'My.ScheduledReminder.format.ps1xml'

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = 'New-ScheduledReminderJob','Get-ScheduledReminderJob','Remove-ScheduledReminderJob'

# Cmdlets to export from this module
#CmdletsToExport = '*'

# Variables to export from this module
# VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = 'remind','nsrj','gsrj'

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'reminder','popup','alert'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/jdhitsolutions/MyReminder/blob/master/LICENSE.txt'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/jdhitsolutions/MyReminder'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable


# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

