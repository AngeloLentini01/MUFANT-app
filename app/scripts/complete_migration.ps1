# PowerShell script to complete the migration to the new database schema

# 1. Remove old files
Write-Host "Removing old files..."
Remove-Item -Path "lib\data\dbManagers\db_user_manager.dart" -ErrorAction SilentlyContinue
Remove-Item -Path "lib\data\dbManagers\db_museum_activity_manager.dart" -ErrorAction SilentlyContinue
Remove-Item -Path "lib\presentation\views\loginPage\login_page.dart" -ErrorAction SilentlyContinue
Remove-Item -Path "lib\presentation\views\loginPage\registration_page.dart" -ErrorAction SilentlyContinue
Remove-Item -Path "lib\presentation\views\loginPage\login_page.dart.bak" -ErrorAction SilentlyContinue
Remove-Item -Path "lib\presentation\views\loginPage\registration_page.dart.bak" -ErrorAction SilentlyContinue

# 2. Rename new files to remove "_new" suffix
Write-Host "Renaming new files..."
Rename-Item -Path "lib\data\dbManagers\db_user_manager_new.dart" -NewName "db_user_manager.dart" -ErrorAction SilentlyContinue
Rename-Item -Path "lib\data\dbManagers\db_museum_activity_manager_new.dart" -NewName "db_museum_activity_manager.dart" -ErrorAction SilentlyContinue
Rename-Item -Path "lib\presentation\views\loginPage\login_page_new.dart" -NewName "login_page.dart" -ErrorAction SilentlyContinue
Rename-Item -Path "lib\presentation\views\loginPage\registration_page_new.dart" -NewName "registration_page.dart" -ErrorAction SilentlyContinue

# 3. Update imports in all files
Write-Host "Updating imports in files..."
$files = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse
foreach ($file in $files) {
    (Get-Content $file.FullName) | 
        ForEach-Object { $_ -replace "db_user_manager_new", "db_user_manager" } |
        ForEach-Object { $_ -replace "db_museum_activity_manager_new", "db_museum_activity_manager" } |
        ForEach-Object { $_ -replace "login_page_new", "login_page" } |
        ForEach-Object { $_ -replace "registration_page_new", "registration_page" } |
        Set-Content $file.FullName
}

# 4. Run flutter clean and pub get
Write-Host "Running flutter clean and pub get..."
flutter clean
flutter pub get

Write-Host "Migration completed!"
