# PlantTracker iOS App PRD

## 1. Introduction

### 1.1 Purpose
This Product Requirements Document (PRD) outlines the specifications for PlantTracker, an iOS mobile application designed to help users document and track the growth of their plants over time through photographs.

### 1.2 Product Overview
PlantTracker is a personal plant documentation app that allows users to create plant entries, capture photos of plants at different growth stages, add notes to those photos, and view a chronological timeline of plant development. The app works offline with local storage and focuses on simplicity and ease of use.

### 1.3 Target Users
- Plant enthusiasts
- Home gardeners
- Plant collectors
- Anyone who wants to track the growth and development of their plants

## 2. Product Features

### 2.1 Plant Management

#### 2.1.1 Plant Entries
Users can create plant entries with the following information:
- Custom name (required)
- Scientific name (optional)
- Location (optional)

#### 2.1.2 Plant Editing
Users can edit plant details after creation.

#### 2.1.3 Plant Deletion
Users can delete plants with a confirmation step to prevent accidental deletion.

### 2.2 Photo Documentation

#### 2.2.1 Photo Capture
Users can add photos to plants via:
- Device camera
- Photo library selection

#### 2.2.2 Photo Metadata
Each photo includes:
- Automatic date stamping
- Optional notes/observations

#### 2.2.3 Photo Management
Users can:
- View photos in chronological order (most recent first)
- Delete individual photos
- Edit notes associated with photos

## 3. User Interface

### 3.1 Home Screen
- List of all plants with name, location (if provided), and photo previews
- Each plant card displays photos in chronological order (most recent first)
- "+" button in the top right for adding new plants or photos

### 3.2 Plant Detail View
- Displays plant name, scientific name (if provided), and location (if provided)
- "Edit" button to modify plant details
- Chronological display of all photos (most recent first) with dates and notes
- "+" button to add new photos to this plant
- Tap on any photo to view it in full screen

### 3.3 Photo Capture Options Modal
Appears when tapping "+" on home screen or plant detail view, with options:
- Add Plant (shortcut to Add Plant screen)
- Take Photo (opens camera)
- Choose from Library (opens photo library)
- Cancel

### 3.4 Add Plant Screen
- Fields for entering:
  - Plant name (required)
  - Scientific name (optional)
  - Location (optional)
- Save button to create the plant and return to previous screen
- Cancel button to discard changes and return to previous screen
- Delete button (only when editing an existing plant)

### 3.5 Add Photo Screen
- Preview of selected/captured photo
- Plant selection dropdown (including option to add new plant)
- Date field (auto-populated with current date, but editable)
- Notes field for observations
- Save button to add the photo to selected plant
- Cancel button to discard the photo

### 3.6 Photo Detail View
- Full-screen view of the selected photo
- Date and notes displayed
- Edit and delete options
- Navigation to move between photos chronologically

## 4. User Flows

### 4.1 Adding a New Plant Directly
1. User taps "+" from home screen
2. Photo capture options modal appears
3. User selects "Add Plant"
4. Add Plant screen appears
5. User fills in plant details
6. User taps "Save" to create plant and return to home screen

### 4.2 Adding a New Plant During Photo Capture
1. User taps "+" from home screen
2. Photo capture options modal appears
3. User selects "Take Photo" or "Choose from Library"
4. User captures/selects photo
5. Add Photo screen appears
6. User selects "+Add New Plant" from plant dropdown
7. Add Plant screen slides in
8. User fills in plant details
9. User taps "Save" to return to Add Photo screen with new plant selected
10. User adds optional notes
11. User taps "Save" to add photo to the new plant

### 4.3 Adding Photos to Existing Plant
1. User navigates to plant in home list
2. User taps "+" within plant detail view
3. Photo capture options modal appears
4. User selects "Take Photo" or "Choose from Library"
5. User captures/selects photo
6. Add Photo screen appears with current plant pre-selected
7. User adds optional notes
8. User taps "Save" to add photo to plant timeline

### 4.4 Editing Plant Details
1. User navigates to plant in home list
2. User taps "Edit" button next to plant name
3. Edit Plant screen appears with current details
4. User modifies desired fields
5. User taps "Save" to update plant details

### 4.5 Viewing Photo Details
1. User navigates to plant in home list
2. User taps on a photo
3. Photo Detail screen appears
4. User can view notes, edit notes, delete photo, or navigate to other photos

## 5. Technical Specifications

### 5.1 Development
- Native iOS app (Swift/SwiftUI)
- Minimum iOS version: iOS 15+
- Target devices: iPhone (optimized for all screen sizes)
- iPad support secondary but desirable

### 5.2 Data Storage
- Local CoreData database for offline functionality
- Photo storage in app's Documents directory
- No cloud sync required

### 5.3 Camera Integration
- Access to device camera
- Access to photo library
- Image compression for storage efficiency

### 5.4 Performance Considerations
- Efficient image handling to prevent memory issues
- Pagination for plants with many photos
- Image caching for smooth scrolling

## 6. Accessibility Considerations
- Support for Dynamic Type
- VoiceOver compatibility
- Sufficient color contrast
- Haptic feedback for important actions

## 7. Future Considerations
These features are not part of the initial release but may be considered for future updates:
- Optional data backup solution
- Basic statistics (growth rate, time between photos)
- Simple filtering/sorting options
- Landscape orientation support
- Care reminders and schedules
- Plant identification integration
- Social sharing capabilities

## 8. Success Metrics
The success of the app will be measured by:
- User engagement (frequency of photo additions)
- Number of plants tracked per user
- App retention rate
- User satisfaction via feedback
