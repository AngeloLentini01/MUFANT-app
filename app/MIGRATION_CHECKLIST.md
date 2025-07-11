# MUFANT App Database Migration Checklist

## Files Ready for Migration

- [x] Created `db_user_manager_new.dart` - Implements the user operations for the new schema
- [x] Created `db_museum_activity_manager_new.dart` - Implements museum activity operations for the new schema
- [x] Created `database_helper.dart` - Handles database setup and migrations
- [x] Created `data_migration_helper.dart` - Handles migrating data from old to new schema
- [x] Created `UserSessionManager` - Manages user login state across the app
- [x] Created `ProfilePageAuth` - Handles conditional rendering based on login state

## Updates for Finishing Migration

- [ ] Run the `complete_migration.ps1` PowerShell script to:
  - Remove old files
  - Rename new files to remove "_new" suffix
  - Update imports in all files
  - Run flutter clean and pub get

## Files to Test After Migration

- [ ] Login functionality (`login_page.dart`)
- [ ] Registration functionality (`registration_page.dart`)
- [ ] User profile view and edit (`profile_page_auth.dart`)
- [ ] Museum activities list and details
- [ ] Cart functionality
- [ ] Payment processing

## Potential Issues to Watch For

- Import errors - Make sure all imports referencing the old files are updated
- Database access issues - Test all database operations thoroughly
- Model inconsistencies - Ensure all code is using the new model classes

## Future Improvements

- Consider refactoring any remaining references to old model classes in `model/cart/` and `model/items/`
- Review error handling in database operations
- Add comprehensive logging for database operations
- Improve user session management with refresh tokens or biometric authentication

## Commands for Testing

```bash
# Clean the project
flutter clean

# Get dependencies
flutter pub get

# Run analyzer to find potential issues
flutter analyze

# Run the app in debug mode
flutter run

# Run tests
flutter test
```
