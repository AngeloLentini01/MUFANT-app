# Push Notification Setup Guide for MUFANT App

## Overview
This guide explains how to set up and use the push notification system in the MUFANT museum app using the `push` package (v3.3.3).

## Features Implemented

### 📱 **Core Functionality**
- ✅ Real-time push notifications (foreground, background, terminated states)
- ✅ Notification persistence with SharedPreferences
- ✅ Interactive notification management (mark as read, delete)
- ✅ Unread notification counter
- ✅ Integration with existing notification screen
- ✅ Test notification capability for development

### 🛠 **Technical Components**

#### 1. **PushNotificationService** (`push_notification_service.dart`)
- Singleton service managing all push notification functionality
- Handles token management, message processing, and notification history
- Provides callbacks for different notification states
- Persists notifications locally using SharedPreferences

#### 2. **Enhanced NotificationScreen** (`notification_screen.dart`)
- Integrates with PushNotificationService for real-time updates
- Shows both demo notifications and actual push notifications
- Includes test button for development/debugging
- Provides swipe actions for notification management

#### 3. **App Initialization** (`main.dart`)
- Initializes push notification service on app startup
- Requests notification permissions
- Sets up proper logging for debugging

## Setup Instructions

### 📋 **Prerequisites**
- Flutter SDK 3.8.1+
- Firebase project (for Android)
- Apple Developer account (for iOS push notifications)

### 🔧 **Configuration Steps**

#### **For Android:**
1. **Firebase Setup:**
   ```bash
   # Add to android/app/build.gradle
   id "com.google.gms.google-services"
   
   # Add to android/build.gradle
   classpath 'com.google.gms:google-services:4.3.10'
   ```

2. **Add google-services.json:**
   - Download from Firebase Console
   - Place in `android/app/` directory

3. **Permissions** (already configured):
   ```xml
   <!-- AndroidManifest.xml -->
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.WAKE_LOCK" />
   <uses-permission android:name="android.permission.VIBRATE" />
   ```

#### **For iOS:**
1. **Apple Developer Setup:**
   - Create push notification key in Apple Developer Console
   - Enable push notifications for your app ID

2. **Configure iOS project:**
   ```swift
   // ios/Runner/Info.plist
   <key>UIBackgroundModes</key>
   <array>
       <string>remote-notification</string>
   </array>
   ```

## Usage Examples

### 🔔 **Basic Usage**

```dart
// Get the service instance
final pushService = PushNotificationService.instance;

// Initialize (done automatically in main.dart)
await pushService.initialize();

// Request permissions
final hasPermission = await pushService.requestPermission();

// Get FCM token for server communication
final token = await pushService.getToken();
print('FCM Token: $token');
```

### 📨 **Handling Notifications**

```dart
// Listen for foreground messages
pushService.setOnMessageReceivedCallback((data) {
  print('New notification: ${data['title']}');
  // Update UI, show local notification, etc.
});

// Handle notification taps
pushService.setOnNotificationTapCallback((data) {
  // Navigate to specific screen based on notification data
  if (data['data']['type'] == 'exhibit') {
    Navigator.pushNamed(context, '/exhibit/${data['data']['exhibit_id']}');
  }
});

// Handle background messages
pushService.setOnBackgroundMessageCallback((data) {
  // Process background notifications
  print('Background notification: ${data['title']}');
});
```

### 🧪 **Testing Notifications**

The app includes a test button in the notification screen that simulates different types of notifications:

```dart
// Simulate a test notification (development only)
pushService.simulateNotification(
  title: '🚀 New Exhibit Unlocked!',
  body: 'Discover the secrets of Mars colonization...',
  data: {
    'type': 'exhibit',
    'exhibit_id': 'mars_colony_sim',
    'priority': 'high'
  },
);
```

### 📊 **Notification Management**

```dart
// Get notification history
final notifications = pushService.notificationHistory;

// Mark notification as read
pushService.markAsRead('notification_id');

// Remove notification
pushService.removeNotification('notification_id');

// Clear all notifications
pushService.clearAllNotifications();

// Get unread count
final unreadCount = pushService.unreadCount;
```

## Server Integration

### 📤 **Sending Notifications**

To send notifications from your server, use the FCM token obtained from the app:

```javascript
// Example Node.js server code
const admin = require('firebase-admin');

// Send notification
const message = {
  token: userFcmToken, // Get from app
  notification: {
    title: '🎯 New Achievement Unlocked!',
    body: 'You completed the Space Exploration quest!'
  },
  data: {
    type: 'achievement',
    achievement_id: 'space_explorer',
    points: '100'
  }
};

await admin.messaging().send(message);
```

### 🎯 **Notification Types**

The app supports different notification types with custom handling:

```dart
// Notification data structure
{
  'title': 'Notification Title',
  'body': 'Notification Body',
  'data': {
    'type': 'exhibit|quiz|achievement|visit_reminder|event',
    'id': 'unique_identifier',
    'priority': 'low|normal|high',
    'action_url': '/screen/to/navigate',
    // Additional custom fields...
  }
}
```

## Debugging & Troubleshooting

### 📱 **Development Tools**
1. **Test Button**: Use the test notification button in the notification screen
2. **Console Logs**: Check debug output for push notification events
3. **FCM Token**: Display token in UI for server testing

### 🐛 **Common Issues**
- **Permissions**: Ensure notification permissions are granted
- **Firebase Config**: Verify google-services.json is properly configured
- **iOS Simulator**: Push notifications don't work on iOS simulator
- **Background Processing**: Ensure proper background mode configuration

### 📝 **Logging**
The service provides detailed logging for debugging:
```dart
// Enable debug logging
flutter run --dart-define=DEBUG_PUSH=true
```

## Next Steps

### 🚀 **Potential Enhancements**
1. **Rich Notifications**: Add images, action buttons, and rich content
2. **Scheduling**: Implement local notification scheduling
3. **Analytics**: Track notification engagement and performance
4. **Personalization**: User preference-based notification filtering
5. **Deep Linking**: Enhanced navigation based on notification content

### 🔗 **Integration Points**
- **User Preferences**: Connect with settings page for notification preferences
- **Analytics**: Track notification opens and conversions
- **Museum Events**: Integrate with calendar and event management
- **Visitor Journey**: Send contextual notifications based on location/progress

## Security Considerations

- **Token Management**: Secure FCM token storage and transmission
- **Data Validation**: Validate notification data on both client and server
- **Permission Handling**: Graceful handling of permission denials
- **Background Processing**: Efficient background message processing

---

**📞 Support**: For issues or questions, check the [push package documentation](https://pub.dev/packages/push) or create an issue in the project repository.
