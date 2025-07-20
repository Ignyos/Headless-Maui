# MAUI Template Setup Script
# One-time customization script to replace template tokens with project-specific values

param(
    [switch]$Help,
    [switch]$DryRun
)

function Show-Help {
    Write-Host @"
MAUI Template Setup Script

USAGE:
    .\setup.ps1 [OPTIONS]

OPTIONS:
    -DryRun    Show what would be changed without making actual changes
    -Help      Show this help message

DESCRIPTION:
    This script customizes the MAUI template for your specific project by:
    - Prompting for project details (app name, company, etc.)
    - Validating input according to platform requirements
    - Replacing template tokens throughout the project
    - Testing that the project builds successfully
    - Self-destructing to prevent accidental re-runs

    This script should only be run ONCE after forking the template.

EXAMPLES:
    .\setup.ps1              # Interactive setup
    .\setup.ps1 -DryRun      # Preview changes without applying them

"@ -ForegroundColor Cyan
}

function Test-SetupAlreadyRun {
    # Check if tokens still exist - if not, setup was already run
    $projectFile = "AppShell\AppShell.csproj"
    if (-not (Test-Path $projectFile)) {
        Write-Host "❌ Project file not found. Please run this script from the repository root." -ForegroundColor Red
        exit 1
    }
    
    $content = Get-Content $projectFile -Raw
    if ($content -notlike "*@@*@@*") {
        Write-Host "⚠️  This template appears to already be customized." -ForegroundColor Yellow
        Write-Host "   No @@TOKEN@@ placeholders found in project file." -ForegroundColor Yellow
        $confirm = Read-Host "Do you want to continue anyway? (y/N)"
        if ($confirm -ne 'y' -and $confirm -ne 'Y') {
            Write-Host "Setup cancelled." -ForegroundColor Gray
            exit 0
        }
    }
}

function Get-UserInput {
    Write-Host "`n=== MAUI Template Customization ===" -ForegroundColor Cyan
    Write-Host "Please provide the following information for your project:`n" -ForegroundColor White
    
    # Display Title - user-friendly name with spaces, special chars allowed
    Write-Host "📱 Application Display Name" -ForegroundColor Yellow
    Write-Host "   This is the name shown in the title bar, Start menu, and to users." -ForegroundColor Gray
    Write-Host "   Examples: 'My Awesome App', 'Project Manager Pro', 'Data Analyzer'" -ForegroundColor Gray
    do {
        $displayTitle = Read-Host "   Display Name"
        if ([string]::IsNullOrWhiteSpace($displayTitle)) {
            Write-Host "   ❌ Display name cannot be empty." -ForegroundColor Red
        } elseif ($displayTitle.Length -gt 50) {
            Write-Host "   ❌ Display name too long (max 50 characters)." -ForegroundColor Red
        }
    } while ([string]::IsNullOrWhiteSpace($displayTitle) -or $displayTitle.Length -gt 50)
    
    # App Identifier - clean version for code/manifests
    Write-Host "`n🏷️  Application Identifier" -ForegroundColor Yellow
    Write-Host "   Clean name for manifests and package IDs (no spaces or special chars)." -ForegroundColor Gray
    Write-Host "   Examples: 'MyAwesomeApp', 'ProjectManagerPro', 'DataAnalyzer'" -ForegroundColor Gray
    $suggestedId = $displayTitle -replace '[^\w]', ''
    do {
        $appId = Read-Host "   App Identifier [$suggestedId]"
        if ([string]::IsNullOrWhiteSpace($appId)) { $appId = $suggestedId }
        if ($appId -notmatch '^[A-Za-z][A-Za-z0-9_]*$') {
            Write-Host "   ❌ Must start with letter, contain only letters, numbers, and underscores." -ForegroundColor Red
        } elseif ($appId.Length -gt 30) {
            Write-Host "   ❌ Identifier too long (max 30 characters)." -ForegroundColor Red
        }
    } while ($appId -notmatch '^[A-Za-z][A-Za-z0-9_]*$' -or $appId.Length -gt 30)
    
    # Company Name
    Write-Host "`n🏢 Company/Publisher Name" -ForegroundColor Yellow
    Write-Host "   Your organization name for manifests and copyright notices." -ForegroundColor Gray
    Write-Host "   Examples: 'Acme Corporation', 'John Smith Software', 'Freelance Developer'" -ForegroundColor Gray
    do {
        $companyName = Read-Host "   Company Name"
        if ([string]::IsNullOrWhiteSpace($companyName)) {
            Write-Host "   ❌ Company name cannot be empty." -ForegroundColor Red
        } elseif ($companyName.Length -gt 50) {
            Write-Host "   ❌ Company name too long (max 50 characters)." -ForegroundColor Red
        }
    } while ([string]::IsNullOrWhiteSpace($companyName) -or $companyName.Length -gt 50)
    
    # Package ID - reverse domain format
    Write-Host "`n📦 Package Identifier" -ForegroundColor Yellow
    Write-Host "   Reverse domain format for app stores and deployment." -ForegroundColor Gray
    Write-Host "   Examples: 'com.acme.myapp', 'org.johnsmith.projectmanager'" -ForegroundColor Gray
    $companyDomain = $companyName.ToLower() -replace '[^\w]', ''
    $appDomain = $appId.ToLower()
    $suggestedPackageId = "com.$companyDomain.$appDomain"
    do {
        $packageId = Read-Host "   Package ID [$suggestedPackageId]"
        if ([string]::IsNullOrWhiteSpace($packageId)) { $packageId = $suggestedPackageId }
        if ($packageId -notmatch '^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)*$') {
            Write-Host "   ❌ Must be lowercase, dot-separated, each part starting with letter." -ForegroundColor Red
        } elseif ($packageId.Length -gt 60) {
            Write-Host "   ❌ Package ID too long (max 60 characters)." -ForegroundColor Red
        }
    } while ($packageId -notmatch '^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)*$' -or $packageId.Length -gt 60)
    
    # App Description
    Write-Host "`n📝 Application Description" -ForegroundColor Yellow
    Write-Host "   Brief description of what your application does." -ForegroundColor Gray
    Write-Host "   Examples: 'A powerful project management tool', 'Data analysis made simple'" -ForegroundColor Gray
    do {
        $description = Read-Host "   Description"
        if ([string]::IsNullOrWhiteSpace($description)) {
            Write-Host "   ❌ Description cannot be empty." -ForegroundColor Red
        } elseif ($description.Length -gt 100) {
            Write-Host "   ❌ Description too long (max 100 characters for manifests)." -ForegroundColor Red
        }
    } while ([string]::IsNullOrWhiteSpace($description) -or $description.Length -gt 100)
    
    return @{
        DisplayTitle = $displayTitle.Trim()
        AppIdentifier = $appId.Trim()
        CompanyName = $companyName.Trim()
        PackageId = $packageId.Trim().ToLower()
        Description = $description.Trim()
    }
}

function Show-ConfigurationSummary {
    param([hashtable]$Config)
    
    Write-Host "`n=== Configuration Summary ===" -ForegroundColor Cyan
    Write-Host "Display Title:    $($Config.DisplayTitle)" -ForegroundColor White
    Write-Host "App Identifier:   $($Config.AppIdentifier)" -ForegroundColor White
    Write-Host "Company Name:     $($Config.CompanyName)" -ForegroundColor White
    Write-Host "Package ID:       $($Config.PackageId)" -ForegroundColor White
    Write-Host "Description:      $($Config.Description)" -ForegroundColor White
    Write-Host "=================================" -ForegroundColor Cyan
    
    if (-not $DryRun) {
        Write-Host "`n⚠️  This will modify your project files. Make sure you have committed any changes." -ForegroundColor Yellow
        $confirm = Read-Host "Continue with setup? (Y/n)"
        if ($confirm -eq 'n' -or $confirm -eq 'N') {
            Write-Host "Setup cancelled." -ForegroundColor Gray
            exit 0
        }
    }
}

function Get-FilesToUpdate {
    $files = @()
    
    # Find all files that might contain tokens
    $searchPaths = @(
        "AppShell\*.csproj",
        "AppShell\*.xaml",
        "AppShell\*.cs",
        "AppShell\wwwroot\*",
        "AppShell\Platforms\**\*",
        "README.md"
    )
    
    foreach ($pattern in $searchPaths) {
        $matchingFiles = Get-ChildItem $pattern -Recurse -File -ErrorAction SilentlyContinue
        foreach ($file in $matchingFiles) {
            # Skip binary files and build output
            if ($file.Extension -in @('.exe', '.dll', '.pdb', '.cache', '.bin')) { continue }
            if ($file.DirectoryName -like '*\bin\*' -or $file.DirectoryName -like '*\obj\*') { continue }
            
            # Check if file contains tokens
            try {
                $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
                if ($content -and $content -like "*@@*@@*") {
                    $files += $file.FullName
                }
            }
            catch {
                # Skip files that can't be read as text
                continue
            }
        }
    }
    
    return $files | Sort-Object
}

function Update-FileTokens {
    param(
        [string]$FilePath,
        [hashtable]$Config,
        [bool]$DryRun
    )
    
    try {
        $originalContent = Get-Content $FilePath -Raw -Encoding UTF8
        $newContent = $originalContent
        
        # Replace all tokens
        $newContent = $newContent -replace '@@DISPLAY_TITLE@@', $Config.DisplayTitle
        $newContent = $newContent -replace '@@APP_IDENTIFIER@@', $Config.AppIdentifier
        $newContent = $newContent -replace '@@COMPANY_NAME@@', $Config.CompanyName
        $newContent = $newContent -replace '@@PACKAGE_ID@@', $Config.PackageId
        $newContent = $newContent -replace '@@APP_DESCRIPTION@@', $Config.Description
        
        if ($originalContent -ne $newContent) {
            $relativePath = $FilePath -replace [regex]::Escape((Get-Location).Path + '\'), ''
            
            if ($DryRun) {
                Write-Host "   Would update: $relativePath" -ForegroundColor Yellow
                
                # Show what tokens would be replaced
                $tokens = [regex]::Matches($originalContent, '@@[A-Z_]+@@')
                if ($tokens.Count -gt 0) {
                    $uniqueTokens = $tokens | ForEach-Object { $_.Value } | Sort-Object -Unique
                    Write-Host "     Tokens: $($uniqueTokens -join ', ')" -ForegroundColor Gray
                }
            } else {
                Write-Host "   ✅ Updated: $relativePath" -ForegroundColor Green
                Set-Content $FilePath $newContent -Encoding UTF8 -NoNewline
            }
            return $true
        }
        return $false
    }
    catch {
        Write-Host "   ❌ Error updating $FilePath`: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Test-ProjectBuild {
    Write-Host "`nTesting project build..." -ForegroundColor Cyan
    
    try {
        $originalLocation = Get-Location
        Set-Location "AppShell"
        
        Write-Host "Running dotnet build..." -ForegroundColor Gray
        $buildResult = & dotnet build --verbosity quiet 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Project builds successfully!" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ Build failed:" -ForegroundColor Red
            Write-Host $buildResult -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ Build test failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    finally {
        Set-Location $originalLocation
    }
}

function Remove-SetupScript {
    Write-Host "`nCleaning up..." -ForegroundColor Cyan
    
    try {
        # Self-destruct to prevent accidental re-runs
        Write-Host "Removing setup script (one-time use only)..." -ForegroundColor Gray
        Remove-Item $MyInvocation.MyCommand.Path -Force
        Write-Host "✅ Setup script removed." -ForegroundColor Green
    }
    catch {
        Write-Host "⚠️  Could not remove setup script: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host "   Please delete setup.ps1 manually to prevent accidental re-runs." -ForegroundColor Yellow
    }
}

# Main script execution
try {
    if ($Help) {
        Show-Help
        exit 0
    }
    
    Write-Host "🚀 MAUI Template Setup" -ForegroundColor Cyan
    Write-Host "Customizing template for your project...`n" -ForegroundColor White
    
    # Verify we're in the right location and setup hasn't been run
    Test-SetupAlreadyRun
    
    # Get user configuration
    $config = Get-UserInput
    
    # Show summary and confirm
    Show-ConfigurationSummary $config
    
    # Find files to update
    Write-Host "`nScanning for template tokens..." -ForegroundColor Cyan
    $filesToUpdate = Get-FilesToUpdate
    
    if ($filesToUpdate.Count -eq 0) {
        Write-Host "No files with tokens found. Setup may have already been run." -ForegroundColor Yellow
        exit 0
    }
    
    Write-Host "Found $($filesToUpdate.Count) files containing tokens." -ForegroundColor Gray
    
    # Update files
    if ($DryRun) {
        Write-Host "`n=== DRY RUN - No changes will be made ===" -ForegroundColor Yellow
    } else {
        Write-Host "`nUpdating project files..." -ForegroundColor Cyan
    }
    
    $updatedCount = 0
    foreach ($file in $filesToUpdate) {
        if (Update-FileTokens $file $config $DryRun) {
            $updatedCount++
        }
    }
    
    if ($DryRun) {
        Write-Host "`n📋 Dry run complete. $updatedCount files would be updated." -ForegroundColor Yellow
        Write-Host "Run '.\setup.ps1' to apply changes." -ForegroundColor Yellow
    } else {
        Write-Host "`n✅ Updated $updatedCount files successfully!" -ForegroundColor Green
        
        # Test build
        if (Test-ProjectBuild) {
            Write-Host "`n🎉 Setup completed successfully!" -ForegroundColor Green
            Write-Host "`nNext steps:" -ForegroundColor Cyan
            Write-Host "1. Review the changes in your project" -ForegroundColor White
            Write-Host "2. Run 'cd AppShell && dotnet run' to test your app" -ForegroundColor White
            Write-Host "3. Start customizing wwwroot/ for your frontend" -ForegroundColor White
            Write-Host "4. Use '.\publish.ps1' to create installers" -ForegroundColor White
            
            # Clean up
            Remove-SetupScript
        } else {
            Write-Host "`n❌ Setup completed but project build failed." -ForegroundColor Red
            Write-Host "Please review the build errors and fix any issues." -ForegroundColor Red
        }
    }
    
} catch {
    Write-Host "`n❌ Setup failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
