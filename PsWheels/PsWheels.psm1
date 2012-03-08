##
##    Adds some common wheels to work with files
##

function Invoke-Replace {
[CmdletBinding()]
Param(	
    [Parameter(Mandatory=$true, Position=0)]
    [String]$Pattern,
	[Parameter(Mandatory=$true, Position=1)]
    [String]$Replacement,
    [Parameter(ValueFromPipeline=$true, Mandatory=$false, ParameterSetName="Path", 
    	HelpMessage = "Specifies a path to one or more locations. Wildcards are permitted. The default location is the current directory (.).")] 
    [String[]]$Path,
    [Parameter(Mandatory=$false, 
    	HelpMessage="Omits the specified items. The value of this parameter qualifies the Path parameter. Enter a path element or pattern, such as ""*.txt"". Wildcards are permitted.")]     
    [String[]]$Exclude    
)	
	Begin {
		 if($PSVersionTable.PSVersion.Major -lt 3) {
	        Write-Error "PsGet requires PowerShell 3.0 or better; you have version $($Host.Version)."    
	        return
	    }
	}
	Process {

		function PretifyPath([string]$FilePath){
			$FilePath.Replace((Get-Location), ".")
		}

		function ReplaceInFile($FilePath){		
			$Raw = (Get-Content $FilePath -Raw)
			if ($Raw -like "*$Pattern*" ) {
				$PrettyPath = PretifyPath($FilePath)
				"Replace: $PrettyPath"
				Set-Content $FilePath $Raw.Replace($Pattern, $Replacement)
			}
		}

		switch($PSCmdlet.ParameterSetName) {
	        "Path" {
	        	$PrettyPath = PretifyPath($Path)
	            Write-Verbose "Replace $Pattern with $Replacement for path '$PrettyPath'"	        
	            Get-ChildItem $Path -Exclude:$Exclude | % { ReplaceInFile $_ }
	            break
	        }
	        default {
	        	Write-Verbose "Replace $Pattern with $Replacement in all child content"	        	        	
	        	Get-ChildItem -Recurse -File -Exclude:$Exclude | % { ReplaceInFile $_ }
	            break
	        }
	    }
    }
<#
.Synopsis
    Replace text with other text in files
.Description    
	[TBD] 
.Parameter Path
	Specifies a path to one or more locations. Wildcards are permitted. The default location is the current directory (.).	
	Derives from Get-ChildItem Path parameter.
.Parameter Exclude	
    Omits the specified items. The value of this parameter qualifies the Path parameter. Enter a path element or pattern, such as "*.txt". Wildcards are permitted.
    Derives from Get-ChildItem Exclude parameter.
.Example
    Invoke-Replace Foo Bar

    Description
    -----------
    Replaces all "Foo" with "Bar" in all child files.

#>
}

Export-ModuleMember Invoke-Replace
