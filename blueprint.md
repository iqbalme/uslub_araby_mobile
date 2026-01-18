# Kamus Arab App Blueprint

## Overview

This document outlines the structure and features of the Kamus Arab application, a Flutter-based dictionary app. The app provides users with a searchable dictionary, flashcards, and a new "Uslub" feature for idiomatic expressions.

## Project Structure

The project follows a standard Flutter project structure, with the following key directories:

-   `lib/`: Contains the main application code.
    -   `database/`: Manages the SQLite database connection and data models.
    -   `models/`: Defines the data models used in the application.
    -   `screens/`: Contains the UI for each screen of the application.
    -   `app_router.dart`: Defines the application's routing using `go_router`.
    -   `main.dart`: The main entry point of the application.
    -   `main_screen.dart`: The main screen layout with the bottom navigation bar.

## Features

### Dictionary

-   Search for words in the dictionary.
-   View word definitions and examples.
-   Save words for later review.

### Flashcards

-   Create and manage flashcard decks.
-   Practice with flashcard sessions.
-   Track your learning progress with statistics.

### Uslub

-   Browse a collection of Arabic idiomatic expressions ("uslub").
-   View the meaning and example usage of each expression.

### User Profile

-   View and manage your user profile.
-   Access application settings.

## Design and Theming

The application uses the Material 3 design system with a custom color scheme and typography. The `google_fonts` package is used for custom fonts to enhance the visual appeal of the app.

## Navigation

The application uses the `go_router` package for declarative routing. The main navigation is handled by a `BottomNavigationBar` in the `MainScreen`, providing access to the Home, Uslub, Saved Words, Flashcards, and Profile screens.

## Current Task: Add "Uslub" Feature

The following steps were taken to add the "Uslub" feature to the application:

1.  **Create `lib/screens/uslub_screen.dart`**: A new screen was created to display the "uslub" data from the database. The screen fetches data from the `DatabaseHelper` and displays it in a `ListView` of cards.

2.  **Create Placeholder Files**: To avoid analysis errors during development, empty placeholder files were created for all the screens and models referenced in the router configuration.

3.  **Create `lib/main_screen.dart`**: A new `MainScreen` widget was created to host the `BottomNavigationBar`. A new tab for "Uslub" was added to the navigation bar.

4.  **Create `lib/app_router.dart`**: The `GoRouter` configuration was moved to a separate file, `app_router.dart`. The router was updated to include the new `/uslub` route within the `ShellRoute`.

5.  **Update `lib/main.dart`**: The `main.dart` file was updated to use the new `GoRouter` configuration from `app_router.dart`.

6.  **Correct Package Name**: The package name was corrected from `flutter_sqlite_demo` to `kamus_arab` in all relevant import statements.
