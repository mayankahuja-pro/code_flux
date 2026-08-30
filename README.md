# CodeFlux

### Developer Productivity Dashboard for Developers

CodeFlux is a modern Flutter application that helps developers track coding sessions, manage daily tasks, maintain coding streaks, run focused work sessions, and analyze weekly productivity.

Built as a portfolio project to demonstrate practical Flutter development, state management, local persistence, reusable UI architecture, and data visualization.

---

## Overview

Developers often use separate tools for task management, focus sessions, and productivity tracking.

CodeFlux brings these workflows together into a single mobile dashboard.

The application provides a simple workflow:

```text
Plan → Focus → Track → Analyze
```

Users can create daily tasks, start a focused coding session, track completed sessions, and review their productivity over time.

---

 Screenshots
<table> <tr> <td align="center"> <img src="https://github.com/user-attachments/assets/3111ca46-9d95-44f2-9f5b-9770f82312b2" alt="Dashboard" width="200"/> <br /> <b>Dashboard</b> </td> <td align="center"> <img src="https://github.com/user-attachments/assets/e0b6eeba-24f8-48d4-8cf7-9b5e24a93198" alt="Focus session" width="200"/> <br /> <b>Focus</b> </td> <td align="center"> <img src="https://github.com/user-attachments/assets/08589bae-0813-4f9b-915c-caa27b7243c6" alt="Add Task" width="200"/> <br /> <b>App Overview</b> </td> <td align="center"> <img src="https://github.com/user-attachments/assets/0fdfece1-5632-4411-8351-476291df6daa" alt="Analytics" width="200"/> <br /> <b>Analytics</b> </td> </tr> </table>


## Key Features

### Productivity Dashboard

* Today's coding time
* Weekly coding time
* Productivity score
* Current coding streak
* Today's tasks
* Quick access to Focus mode

### Focus Timer

* 25-minute Pomodoro session
* Start
* Pause
* Resume
* Reset
* Automatic session completion
* Completed session tracking

### Task Management

* Create tasks
* Mark tasks as completed
* Delete tasks
* Separate pending and completed tasks
* Local persistence

### Productivity Statistics

* Total coding time
* Weekly coding activity
* Average daily coding time
* Completed sessions
* Current streak
* Weekly productivity chart

### Local Persistence

Application data is stored locally using SharedPreferences.

Tasks and coding sessions remain available after restarting the application.

---

## Tech Stack

| Category         | Technology        |
| ---------------- | ----------------- |
| Framework        | Flutter           |
| Language         | Dart              |
| UI               | Material 3        |
| State Management | Provider          |
| Local Storage    | SharedPreferences |
| Charts           | fl_chart          |
| Date Formatting  | intl              |
| Platform         | Android           |

---

## Architecture

CodeFlux intentionally uses a simple architecture rather than introducing unnecessary abstraction layers.

```text
┌─────────────────────────────┐
│           Screens           │
│                             │
│ Home • Focus • Tasks • Stats│
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│   ProductivityProvider      │
│                             │
│ State + Business Logic      │
│ Tasks + Sessions + Metrics  │
└──────────────┬──────────────┘
               │
        ┌──────┴───────┐
        ▼              ▼
┌────────────┐  ┌────────────────┐
│   Models   │  │ StorageService │
│            │  │                │
│ Task       │  │ Persistence    │
│ Session    │  │ Serialization  │
└────────────┘  └───────┬────────┘
                        │
                        ▼
                SharedPreferences
```

### Project Structure

```text
lib/
├── main.dart
│
├── models/
│   ├── coding_session.dart
│   └── task.dart
│
├── providers/
│   └── productivity_provider.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── focus_screen.dart
│   ├── tasks_screen.dart
│   └── statistics_screen.dart
│
├── widgets/
│   ├── stat_card.dart
│   ├── task_tile.dart
│   ├── productivity_chart.dart
│   └── coding_streak.dart
│
├── services/
│   └── storage_service.dart
│
├── theme/
│   └── app_theme.dart
│
└── utils/
    └── constants.dart
```

---

## State Management

CodeFlux uses `Provider` with `ChangeNotifier` for application-level state.

The provider manages:

* Tasks
* Coding sessions
* Loading state
* Productivity calculations
* Coding streak
* Daily and weekly statistics

Widgets listen for state changes using:

```dart
context.watch<ProductivityProvider>()
```

Actions that do not require listening use:

```dart
context.read<ProductivityProvider>()
```

When application state changes:

```dart
notifyListeners();
```

is called so dependent widgets rebuild automatically.

---

## Data Persistence

CodeFlux uses a dedicated `StorageService` to keep persistence logic separate from the UI.

The application serializes models before storing them.

### Saving

```text
Task / CodingSession
        ↓
     toJson()
        ↓
       Map
        ↓
   jsonEncode()
        ↓
SharedPreferences
```

### Loading

```text
SharedPreferences
        ↓
    jsonDecode()
        ↓
       Map
        ↓
 fromJson()
        ↓
Task / CodingSession
```

This keeps the data model independent from the storage implementation.

---

## Focus Timer Flow

The focus timer uses Dart's `Timer.periodic()` to update the countdown every second.

```text
              Start
                │
                ▼
             Running
             /     \
            /       \
        Pause      Complete
          │           │
          ▼           ▼
        Resume    Save Session
          │           │
          └─────┬─────┘
                ▼
              Reset
```

Only completed focus sessions are recorded in the current version.

---

## Productivity Calculation

The application derives statistics from stored coding sessions.

Examples include:

```text
Today's Coding Time
        ↓
Sessions completed today
        ↓
Sum of session durations
```

```text
Weekly Coding Time
        ↓
Filter sessions from last 7 days
        ↓
Sum durations
```

```text
Coding Streak
        ↓
Find unique coding dates
        ↓
Check consecutive days
        ↓
Calculate current streak
```

This keeps the dashboard dynamically connected to the underlying application state.

---

## User Flow

```text
Launch App
    │
    ▼
Home Dashboard
    │
    ├───────────────┐
    │               │
    ▼               ▼
Tasks            Focus
    │               │
    │          Start Session
    │               │
    │          Complete Session
    │               │
    │               ▼
    │        Coding Session
    │               │
    └───────┬───────┘
            ▼
       Statistics
            │
            ▼
      Productivity Insights
```

---

## Getting Started

### Requirements

* Flutter SDK
* Dart SDK
* Android Studio or compatible IDE
* Android emulator or physical Android device

Check the Flutter installation:

```bash
flutter doctor
```

### Clone

```bash
git clone <your-repository-url>
cd codeflux
```

### Install Dependencies

```bash
flutter pub get
```

### Run

```bash
flutter run
```

### Analyze

```bash
flutter analyze
```

### Run Tests

```bash
flutter test
```

---

## Development Approach

The project was intentionally built with a small and understandable architecture.

Instead of introducing:

* Clean Architecture
* Multiple repository abstractions
* Dependency injection frameworks
* Complex state-management layers

CodeFlux uses:

```text
Screens
   ↓
Provider
   ↓
Models + StorageService
```

This keeps the codebase easy to understand while still maintaining a clear separation between presentation, state, data models, and persistence.

---

## What This Project Demonstrates

### Flutter

* Widget composition
* Stateful and Stateless widgets
* Widget lifecycle
* Navigation
* Material 3
* Responsive layouts
* Reusable components

### State Management

* ChangeNotifier
* Provider
* Reactive UI updates
* Shared application state

### Dart

* Null safety
* Classes and constructors
* Factory constructors
* Collections
* `map`
* `where`
* `fold`
* `Future`
* `async/await`
* Timers

### Data

* Model design
* JSON serialization
* JSON deserialization
* Local persistence
* Derived statistics

### UI/UX

* Reusable widgets
* Loading states
* Empty states
* Dark-mode friendly design
* Data visualization

---

## Future Roadmap

The current version is intentionally local-first. A future version could evolve into a full-stack productivity platform.

### Phase 1 — Backend

```text
Flutter
   ↓
Dio / HTTP
   ↓
FastAPI
   ↓
PostgreSQL
```

Potential endpoints:

```text
GET    /tasks
POST   /tasks
PATCH  /tasks/{id}
DELETE /tasks/{id}

GET    /coding-sessions
POST   /coding-sessions
```

### Phase 2 — Authentication

* User registration
* Login
* JWT authentication
* Refresh tokens
* Protected API endpoints

### Phase 3 — Cloud Synchronization

```text
Local Storage
      ↕
Synchronization Layer
      ↕
FastAPI Backend
      ↕
PostgreSQL
```

This would allow users to access their productivity data across devices.

### Phase 4 — GitHub Integration

Potential GitHub integration could provide:

* Repository activity
* Commit statistics
* Pull request activity
* Contribution information

The dashboard could then combine manually tracked focus time with actual GitHub activity.

### Phase 5 — Advanced Analytics

* Monthly productivity trends
* Productivity goals
* Historical streaks
* Session breakdowns
* Custom focus durations
* Productivity insights

---

## Engineering Decisions

### Why Provider?

Provider is lightweight and appropriate for the relatively small state-management requirements of CodeFlux.

It provides reactive state updates without adding unnecessary architectural complexity.

### Why SharedPreferences?

The current application stores a small amount of structured local data, making SharedPreferences sufficient for this version.

For a larger application with more complex querying requirements, a database solution such as SQLite/Drift or a backend database would be more appropriate.

### Why Separate StorageService?

Persistence should not be tightly coupled to the screens.

Keeping storage logic in `StorageService` makes it easier to replace:

```text
SharedPreferences
```

with:

```text
REST API
Database
Cloud Storage
```

in a future version.

---

## Project Status

Current version:

**Completed — Local-first Flutter portfolio application**

Implemented:

* Dashboard
* Task management
* Focus timer
* Coding session tracking
* Productivity statistics
* Weekly chart
* Coding streak
* Local persistence
* Material 3 UI

---

## License

This project was created as a portfolio and learning project.
