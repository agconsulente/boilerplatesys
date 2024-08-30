<#
 #
 # @project: boilsys
 # @created: 2024-08-29
 # @description: Boilerplate system for projects
 # @version: 0.1.0
 # @license: MIT
 # @author: Alberto Gucciardi Consulente
 # @website: https://www.agconsulente.net/boilsys
 # @repository: https://github.com/agconsulente/boilsys
 # @dependencies: None
 #
 #>

# Setup all parameters from console
Param(
    $ProjectName="",
    $ProjectParentPath="$HOME\github",
    $GitUserName="",
    $GitBaseBranch="master",
    $ProjectLanguage="PHP"
)

<#
 #
 # @function: Get-ParameterCheck
 # @description: Check all parameters and ask for the missing ones
 # @return: boolean
 # .SYNOPSIS
 #  Check all parameters and ask for the missing ones or the ones that need to be changed
 # .DESCRIPTION
 #  Check all parameters and ask for the missing ones or the ones that need to be changed
 #
 #>
function Get-ParameterCheck {
    $ProjectNameCheck = $false;
    if($ProjectName -eq '') {
        $ProjectName = Read-Host "Enter the project name (required)";
        if(!($ProjectName -eq ''))
        {
            $ProjectNameCheck = $true;
        }
    }
    $ProjectParentPathCheck = $false;
    if($ProjectParentPath -eq "$HOME\github") {
        $Respone = Read-Host "Do you want to create the project folder in the current directory - $ProjectParentPath - ? (Y/N)";
        if($Respone -eq 'N') {
            $ProjectParentPath = Read-Host "Enter the new path where you want to create the project folder (required)";
        }
        if(!($ProjectParentPath -eq ''))
        {
            $ProjectParentPathCheck = $true;
        }
    }
    $GitUserNameCheck = $false;
    if($GitUserName -eq '') {
        $GitUserName = Read-Host "Enter your git username";
        if(!($GitUserName -eq ''))
        {
            $GitUserNameCheck = $true;
        }
    }
    $GitBaseBranchCheck = $false;
    if($GitBaseBranch -eq 'master') {
        $Respone = Read-Host "The default branch is - $GitBaseBranch -. Do you want to use a different base repository? (Y/N)";
        if($Respone -eq 'Y') {
            $GitBaseBranch = Read-Host "Enter the base repository";
        }
        if(!($GitBaseBranch -eq ''))
        {
            $GitBaseBranchCheck = $true;
        }
    }
    $ProjectLanguageCheck = $false;
    if( $ProjectLanguage -eq 'PHP') {
        $Respone = Read-Host "The default language is $ProjectLanguage. Do you want to use a different language? (Y/N)";
        if($Respone -eq 'Y') {
            $ProjectLanguage = Read-Host "Enter the project language";
        }
        if(!($ProjectLanguage -eq ''))
        {
            $ProjectLanguageCheck = $true;
        }
    }
    if($ProjectNameCheck -eq $true -and $ProjectParentPathCheck -eq $true -and $GitUserNameCheck -eq $true -and $GitBaseBranchCheck -eq $true -and $ProjectLanguageCheck -eq $true) {
        return $true;
    }
    else {
        return $false;
    }
}

<#
 #
 # @function Set-ProjectFolder
 # @description Create the project folder
 # @return: boolean  
 # .SYNOPSIS
 # Create the project folder
 # .DESCRIPTION
 # Create the project folder
 #
 #>
function Set-ProjectFolder {
    $ProjectPath = "$ProjectParentPath\$ProjectName";
    if(!(Test-Path $ProjectPath)) {
        New-Item -Path $ProjectPath -ItemType Directory
        Set-Location $ProjectPath;
        if(!(Test-Path $ProjectPath\.git)){
            git init --initial-branch=$GitBaseBranch . 
            $BaseBranchCheck = git branch --show-current;
        }
        
    }
    else {
        Write-Host "The project folder already exists so, we move into it!";
        Set-Location $ProjectPath;
        if(!(Test-Path $ProjectPath\.git)){
            git init --initial-branch=$GitBaseBranch . 
            $BaseBranchCheck = git branch --show-current;
        }
    }

    if($BaseBranchCheck -eq $GitBaseBranch) {
        return true;
    }
    else {
        return false;
    }
}

<#
 #
 # @function Set-PHPProjectSubfolders
 # @description Create the project subfolders for a PHP project
 # @return: boolean
 # .SYNOPSIS
 # Create the project subfolders for a PHP project
 # .DESCRIPTION
 # Create the project subfolders for a PHP project
 # .EXAMPLE
 # Set-PHPProjectSubfolders 
 #
 #>
function Set-PHPProjectSubfolders{
    $ProjectSubfolders = @("src","tests","docs","config","public","resources","vendor");
    $ProjectSubFoldersTest= @();
    $PublicSubfolders = @("css","js","img");
    foreach($ProjectSubfolder in $ProjectSubfolders){
        if(!(Test-Path $ProjectSubfolder)){
            New-Item -Path $ProjectSubfolder -ItemType Directory
        }
        if(Test-Path $ProjectSubfolder){
            $ProjectSubFoldersTest += $true;
        }
    }
    $PublicSubfoldersTest = @();
    if(Test-Path "public"){
        foreach($PublicSubfolder in $PublicSubfolders){
            if(!(Test-Path "public\$PublicSubfolder")){
                New-Item -Path "public\$PublicSubfolder" -ItemType Directory
            }
            if(Test-Path "public\$PublicSubfolder"){
                $PublicSubfoldersTest += $true;
            }
        }
    }
}



# Start and test point
function Main{
    # check all parameters
    if(Get-ParameterCheck -eq $false) {
        Write-Host "There was an error in the parameters";
        break;
    }
    else {
        Write-Host "All parameters are correct!";
         # create the project folder
        $SetProjectFolder = Set-ProjectFolder;
        if($SetProjectFolder -eq $true) {
            Write-Host "The project folder was created successfully!";
            $SetPHPProjectSubfoldersCheck = Set-PHPProjectSubfolders;
            if($SetPHPProjectSubfoldersCheck -eq $true) {
                Write-Host "The project subfolders were created successfully!";
            }
            else {
                Write-Host "There was an error in the project subfolders creation!";
                break;
            }
        }
        else {
            Write-Host "There was an error in the project folder creation!";
            break;
        }
    }
}
Main
