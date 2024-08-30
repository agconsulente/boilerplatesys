<#
 # @project: boilsys
 # @created: 2024-08-29
 # @description: Boilerplate system for projects
 # @version: 0.1.0
 # @license: MIT
 # @author: Alberto Gucciardi Consulente
 # @website: https://www.agconsulente.net/boilsys
 # @repository: https://github.com/agconsulente/boilsys
 # @dependencies: None
 #>

# Setup all parameters from console
Param(
    $ProjectName='',
    $Path=$HOME,
    $GitUserName='',
    $GitBaseRepo='master',
    $ProjectLanguage='PHP'
)
function Get-ParameterCheck {
    if($ProjectName -eq '') {
        $ProjectName = Read-Host "Enter the project name";
    }
    if($Path -eq $HOME) {
        $Respone = Read-Host "Do you want to create the project in the current directory? (Y/N)";
        if($Respone -eq 'N') {
            $Path = Read-Host "Enter the path where you want to create the project";
        }
    }
    if($GitUserName -eq '') {
        $GitUserName = Read-Host "Enter your git username";
    }
    if($GitBaseRepo -eq 'master') {
        $Respone = Read-Host "Do you want to use a different base repository? (Y/N)";
        if($Respone -eq 'Y') {
            $GitBaseRepo = Read-Host "Enter the base repository";
        }
    }
    if( $ProjectLanguage -eq 'PHP') {
        $Respone = Read-Host "Do you want to use a different language? (Y/N)";
        if($Respone -eq 'Y') {
            $ProjectLanguage = Read-Host "Enter the project language";
        }
    }
}

# Start and test point
function Main{
    Get-ParameterCheck
}
Main