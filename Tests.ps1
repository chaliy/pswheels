$here = (Split-Path -parent $MyInvocation.MyCommand.Definition)
Import-Module -name ($here + "\PsWheels\PsWheels.psm1") -Force
pushd 

function Test($name){
	Write-Host "Test: $name" -ForegroundColor Green		
}

function Assert-Contains($path, $token){

	if (-not ((Get-Content $path -Raw) -like "*$token*")){
		Write-Host "Fail: $path does not contain $token" -ForegroundColor Red
	} else {
	    Write-Host "Success: $path contains $token" -ForegroundColor DarkGreen
	}
}

#------------------------------------
Test "Should replace all child stuff"

mkdir ($here + "\Temp\AllChildStuff") -Force | Out-Null
cd ($here + "\Temp\AllChildStuff")
ac File1.txt Foo=bar

Invoke-Replace Foo Bar -Verbose

Assert-Contains File1.txt "Bar=bar"

#------------------------------------
Test "Should replace all child stuff"

mkdir ($here + "\Temp\FromPathes") -Force | Out-Null
cd ($here + "\Temp\FromPathes")
ac File1.txt Foo=bar
mkdir "Child" -Force | Out-Null
ac Child\File2.txt bar=Foo

Get-ChildItem -Recurse -File |
	Invoke-Replace Foo Bar -Verbose

Assert-Contains File1.txt "Bar=bar"
Assert-Contains Child\File2.txt "bar=Bar"

#------------------------------------
Test "Should take in account Exclude"

mkdir ($here + "\Temp\FromPathes") -Force | Out-Null
cd ($here + "\Temp\FromPathes")
ac File1.txt Foo=bar
mkdir "Child" -Force | Out-Null
ac Child\File2.txt bar=Foo

Invoke-Replace Foo Bar -Exclude "File2*" -Verbose

Assert-Contains File1.txt "Bar=bar"
Assert-Contains Child\File2.txt "bar=Foo"

popd
ri ($here + "\Temp") -Recurse -Force