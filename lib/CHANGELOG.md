<!-- ------------------------------------------------------------------------------------------- -->
<!-- ------------------------------------------------------------------------------------------- -->
<!-- --------------------------------- Format for Known Issues --------------------------------- -->
<!-- ------------------------------------------------------------------------------------------- -->

<!-- ## [Known Issues] - Send bug reports in Settings > Help > Feedback Form -->
<!-- - Incorrect grade step calculation <strong>[Fixed in Beta M-X.X.X]</strong> -->


<!-- ------------------------------------------------------------------------------------------- -->
<!-- ------------------------------- Format for Released Versions ------------------------------ -->
<!-- ------------------------------------------------------------------------------------------- -->
<!-- ## [Stable/Beta M-X.X.X] - YYYY-MM-DD -->
<!-- ### Added/Improved/Fixed/Removed -->
<!-- - Specifics -->


<!-- ------------------------------------------------------------------------------------------- -->
<!-- ------------------------------------ Versioning Guide ------------------------------------- -->
<!-- ------------------------------------------------------------------------------------------- -->

<!-- ALL versions with SEVEN or FEWER entries: increase THIRD digit -->
<!-- ALL versions with EIGHT or MORE entries: increase SECOND digit -->
<!-- STABLE versions with LOTS of entries: increase FIRST digit -->
<!-- ALL updates within a day must be in the same version, -->
<!-- unless separated by an announcement or stability -->


<!-- ------------------------------------------------------------------------------------------- -->
<!-- -------------------------------------- Special HTML --------------------------------------- -->
<!-- ------------------------------------------------------------------------------------------- -->

<!-- Use the following HTML before information specific to Beta -->
<!-- <em>[Beta]</em> -->

<!-- Use the following HTML before information specific to mobile users -->
<!-- <em>[Mobile]</em> -->


<!-- ------------------------------------------------------------------------------------------- -->
<!-- ------------------------------------------------------------------------------------------- -->

## [Beta M-0.1.1] - 2020-03-02
### Added
- Pulling down on the login screen now refreshes the screen<ul>
- It returns to the first stage of the app where a login is attempted with stored credentials</ul>

### Fixed
- Issues with courses with no graded assignments

## [Beta M-0.1.0] - 2020-02-28
### Added
- Debug toasts can be enabled in settings
- Logo and icon buttons now respond to theme changes
- A non-functional menu button
- Loading animation while sending requests to the server
- Pull down to refresh on main screen<ul>
- Checks login status
- Gets any updated settings from the server
- Gets any new grades that may have been synced on a different device</ul>

### Improved
- Main page now contains colored cards for each course
- Main page now loads courses before sending request to sync with PowerSchool
- Changing theme is now supported
- Back button from the main screen no longer causes unintended app behavior
- Pre-load screen now displays logo and is dark themed

### Removed
- Gradient around logo

## [Beta M-0.0.4] - 2020-01-27
### Added
- Watermark over pages that don't work yet
- Light theme is back
- Temporary gradient near logo to make it always visible

### Improved
- Login screen is now bypassed if valid cookie is stored on app open
- This cookie persists through app closes and will allow automatic logins within a 4 hour period
- App now connects to https://beta.graderoom.me/

## [Beta M-0.0.3] - 2020-01-22
### Added
- Grades can now be viewed on the main screen
- This grid currently displays class names, overall grades, and overall letter grades

### Improved
- Login and signup now allow moving through fields with the mobile keyboard
- Database now clears correctly when syncing new data

## [Beta M-0.0.2] - 2020-01-20
### Added
- Offline storage allows viewing grades when PowerSchool is down

### Removed
- Temporarily removed light theme due to conflicts with icon

## [Beta M-0.0.1] - 2020-01-03
### Added
- Settings screen
- Empty forgot-password screen
- Functioning login and logout
- Logout can be accessed in settings

### Improved
- Font
- You now stay logged in as long as your session persists (4 hours)

## [Beta M-0.0.0] - 2020-12-28
### Added
- First commit
- Basic login page
- Basic themes