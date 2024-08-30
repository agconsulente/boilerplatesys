<#
 #
 # @project: boilerplatesys
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
        Write-Host "The project folder already exists so, we move into it!" -ForegroundColor Yellow;
        Set-Location $ProjectPath;
        if(!(Test-Path $ProjectPath\.git)){
            git init --initial-branch=$GitBaseBranch . 
            $BaseBranchCheck = git branch --show-current;
        }
    }

    if($BaseBranchCheck -eq $GitBaseBranch) {
        return $true;
    }
    else {
        return $false;
    }
}

<#
 #
 # @function Set-ProjectFiles
 # @description Create the project files
 # @return: boolean
 # .SYNOPSIS
 # Create the project files
 # .DESCRIPTION
 # Create the project files
 #>
 function Set-ProjectFiles{
    $ProjectFiles = @("README.md", "LICENSE", ".gitignore", ".gitattributes");
    $ProjectFilesTest = @();
    foreach ($ProjectFile in $ProjectFiles){
        if(!(Test-Path $ProjectFile)){
            New-Item $ProjectFile -ItemType File -Value ""
        }
        if(Test-Path $ProjectFile){
            $ProjectFilesTest += $true;
        }
    }
    $Counter = 0;
    foreach($ProjectFileTest in $ProjectFilesTest){
        if($ProjectFileTest -eq $true){
            $Counter += 1;
        }
    }
    if($Counter -eq $ProjectFiles.Count){
        return $true;
    }
    else {
        return $false;
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
    $PublicSubfolders = @("css","js","img");
    $ProjectSubFoldersTest= @();
    $PublicSubfoldersTest = @();
    $ProjectSubfoldersTestCounter =0;
    $PublicSubfoldersTestCounter =0;
    foreach($ProjectSubfolder in $ProjectSubfolders){
        if(!(Test-Path $ProjectSubfolder)){
            New-Item -Path $ProjectSubfolder -ItemType Directory
        }
        if(Test-Path $ProjectSubfolder){
            $ProjectSubFoldersTest += $true;
        }
    }
    foreach($ProjectSubFoldersTest in $ProjectSubFoldersTest){
        if($ProjectSubFoldersTest -eq $true){
            $ProjectSubfoldersTestCounter += 1;
        }
    }
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
    foreach($PublicSubFoldersTest in $PublicSubFoldersTest){
        if($PublicSubFoldersTest -eq $true){
            $PublicSubfoldersTestCounter += 1;
        }
    }
    if($ProjectSubfoldersTestCounter -eq $ProjectSubfolders.Count -and $PublicSubfoldersTestCounter -eq $PublicSubfolders.Count){
        return $true;
    }
    else {
        return $false;
    }
}

<#
 #
 # @function Set-PHPProjectFiles
 # @description Create the project files for a PHP project
 # @return: boolean
 # .SYNOPSIS
 # Create the project files for a PHP project
 # .DESCRIPTION
 # Create the project files for a PHP project
 # 
 #>
 function Set-PHPProjectFiles{
    $PHPProjectFiles = @("index.php", "composer.json", "phpunit.xml", "phpcs.xml", "phpmd.xml", "phpunit.xml.dist");
    $PHPProjectFilesTest = @();
    $PHPProjectFilesTestCounter = 0;
    foreach ($PHPProjectFile in $PHPProjectFiles){
        if(!(Test-Path $PHPProjectFile)){
            New-Item $PHPProjectFile -ItemType File -Value ""
        }
        if(Test-Path $PHPProjectFile){
            $PHPProjectFilesTest += $true;
        }
    }
    foreach($PHPProjectFileTest in $PHPProjectFilesTest){
        if($PHPProjectFileTest -eq $true){
            $PHPProjectFilesTestCounter += 1;
        }
    }
    if($PHPProjectFilesTestCounter -eq $ProjectFiles.Count){
        return $true;
    }
    else {
        return $false;
    }
 }

 <#
  #
  # @function Set-JSProjectSubfolders
  # @description Create the project subfolders for a JS project
  # @return: boolean
  # .SYNOPSIS
  # Create the project subfolders for a JS project
  # .DESCRIPTION
  # Create the project subfolders for a JS project 
  #>
public Set-JSProjectSubFolders{
    $JSProjectSubFolders=@("config","doc", "dependencies", "public", "src", "tests", "vendor");
    $PublicSubfolders = @("style", "js", "pages", "img");
    $SrcSubfolders = @("components", "pages", "services", "utils");
    $TestsSubfolders = @("ComponentTests", "ServiceTests", "UtilTests");
    $JSProjectSubFoldersTest = @();
    $PublicSubfoldersTest = @();
    $SrcSubfoldersTest = @();
    $TestsSubfoldersTest = @();
    $JSProjectSubFoldersTestCounter = 0;
    $PublicSubfoldersTestCounter = 0;   
    $SrcSubfoldersTestCounter = 0;
    $TestsSubfoldersTestCounter = 0;
    foreach($JSProjectSubFolder in $JSProjectSubFolders){
        if(!(Test-Path $JSProjectSubFolder)){
            New-Item -Path $JSProjectSubFolder -ItemType Directory
        }
        if(Test-Path $JSProjectSubFolder){
            $JSProjectSubFoldersTest += $true;
        }
    }
    foreach($PublicSubfolder in $PublicSubfolders){
        if(!(Test-Path "public\$PublicSubfolder")){
            New-Item -Path "public\$PublicSubfolder" -ItemType Directory
        }
        if(Test-Path "public\$PublicSubfolder"){
            $PublicSubfoldersTest += $true;
        }
    }
    foreach($SrcSubfolder in $SrcSubfolders){
        if(!(Test-Path "src\$SrcSubfolder")){
            New-Item -Path "src\$SrcSubfolder" -ItemType Directory
        }
        if(Test-Path "src\$SrcSubfolder"){
            $SrcSubfoldersTest += $true;
        }
    }
    foreach($TestsSubfolder in $TestsSubfolders){
        if(!(Test-Path "tests\$TestsSubfolder")){
            New-Item -Path "tests\$TestsSubfolder" -ItemType Directory
        }
        if(Test-Path "tests\$TestsSubfolder"){
            $TestsSubfoldersTest += $true;
        }
    }
    if($JSProjectSubFoldersTestCounter -eq $JSProjectSubFolders.Count -and $PublicSubfoldersTestCounter -eq $PublicSubfolders.Count -and $SrcSubfoldersTestCounter -eq $SrcSubfolders.Count -and $TestsSubfoldersTestCounter -eq $TestsSubfolders.Count){
        return $true;
    }
    else {
        return $false;
    }
}

<#
 #
 # @function Set-JSProjectFiles
 # @description Create the project files for a JS project
 # @return: boolean
 # .SYNOPSIS
 # Create the project files for a JS project
 # .DESCRIPTION
 # Create the project files for a JS project
 # 
 #>
function Set-JSProjectFiles{
    $JSProjectFiles = @("index.html", "package.json", "webpack.config.js", "jest.config.js", "babel.config.js", "src\index.js", "tests\index.test.js", "src\app.js", "tests\app.test.js");
    $JSProjectFilesTest = @();
    $JSProjectFilesTestCounter = 0;
    foreach ($JSProjectFile in $JSProjectFiles){
        if(!(Test-Path $JSProjectFile)){
            New-Item $JSProjectFile -ItemType File -Value ""
        }
        if(Test-Path $JSProjectFile){
            $JSProjectFilesTest += $true;
        }
    }
    foreach($JSProjectFileTest in $JSProjectFilesTest){
        if($JSProjectFileTest -eq $true){
            $JSProjectFilesTestCounter += 1;
        }
    }
    if($JSProjectFilesTestCounter -eq $ProjectFiles.Count){
        return $true;
    }
    else {
        return $false;
    }
}

<#
 #
 # @function Start-BoilerplateSystem
 # @description Start point of the script
 # @return: void
 # .SYNOPSIS
 # Start point of the script
 # .DESCRIPTION
 #
#>
function Start-BoilerplateSystem{
    # check all parameters
    if(Get-ParameterCheck -eq $false) {
        Write-Host "There was an error in the parameters" -ForegroundColor Magenta;
        break;
    }
    else {
        Write-Host "All parameters are correct!" -ForegroundColor Green;
        # create the project folder
        
        if(Set-ProjectFolder -eq $true) {
            Write-Host "The project folder was created successfully!" -ForegroundColor Green;
        }
        else {
            Write-Host "There was an error in the project folder creation!" -ForegroundColor Magenta;
            break;
        }
        if(Set-ProjectFiles -eq $true){
            Write-Host "The project files were created successfully!" -ForegroundColor Green;
        }
        else {
            Write-Host "There was an error in the project files creation!" -ForegroundColor Magenta;
            break;
        }
        if($ProjectLanguage -eq 'PHP' -or $ProjectLanguage -eq 'php') {
            if(Set-PHPProjectSubfolders -eq $true) {
                Write-Host "The project subfolders were created successfully!" -ForegroundColor Green;
            }
            else {
                Write-Host "There was an error in the project subfolders creation!" -ForegroundColor Magenta;
                break;
            }
            if(Set-PHPProjectFiles -eq $true){
                Write-Host "The project files were created successfully!" -ForegroundColor Green;
            }
            else {
                Write-Host "There was an error in the project files creation!" -ForegroundColor Magenta;
                break;
            }
        }
        elseif($ProjectLanguage -eq 'JS' -or $ProjectLanguage -eq "js" -or $ProjectLanguage -eq 'JavaScript' -or $ProjectLanguage -eq 'Javascript' -or $ProjectLanguage -eq 'javascript'){
            if(Set-JSProjectSubFolders -eq $true) {
                Write-Host "The project subfolders were created successfully!" -ForegroundColor Green;
            }
            else {
                Write-Host "There was an error in the project subfolders creation!" -ForegroundColor Magenta;
                break;
            }
            if(Set-JSProjectFiles -eq $true){
                Write-Host "The project files were created successfully!" -ForegroundColor Green;
            }
            else {
                Write-Host "There was an error in the project files creation!" -ForegroundColor Magenta;
                break;
            }
        }
    }
}
Start-BoilerplateSystem
