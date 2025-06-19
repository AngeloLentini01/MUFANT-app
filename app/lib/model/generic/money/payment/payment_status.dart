/// Enumeration of possible payment transaction statuses.
/// Used to track the state of payments in the system.
///
/// @property PENDING Payment has been initiated but not completed
/// @property SUCCESS Payment has been successfully processed
/// @property FAILED Payment processing encountered an error
enum PaymentStatus { pending, success, failed }
