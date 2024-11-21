
# GitHub Events App

A comprehensive app for fetching, displaying, and interacting with GitHub events. This project demonstrates modern iOS development practices using Swift, Combine, MVVM architecture, and customizable views.

## Features

- **Event Fetching:** Fetches the latest GitHub events via a mockable `EventService`.
- **Event Display:** Clean and responsive UI to list and display event details.
- **Filtering:** Allows filtering of events by type (e.g., `PushEvent`, `WatchEvent`).
- **Auto Refresh:** Automatically refreshes events every 10 seconds using a Combine-based timer.
- **Error Handling:** User-friendly error messages and navigation for failed operations.
- **Dark Mode Support:** Fully supports light and dark themes with adaptive colors.

## Architecture

The app is built with the **MVVM (Model-View-ViewModel)** pattern:
- **Model:** Represents raw GitHub events/event details and their attributes.
- **ViewModel:** Handles data transformation, filtering logic, and publishing updates.
- **View:** Displays event data in a clean, reusable manner with auto-layout.

## Dependencies

- **Combine:** For reactive programming.
- **UIKit:** Used for building responsive, adaptive UI components.

## What's Left to Be Done

- **Unit Testing Coverage:** While some unit tests exist for EventsViewModel, more unit tests could be implemented for Other classes as well. EventsViewModel is used as an example.
