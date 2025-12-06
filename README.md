
# Ecom - Flutter E-commerce App

A simple e-commerce app built with Flutter demonstrating product listing, product details, reviews, favorites, and local persistence using Provider for state management.

## Features

- **Product Listing**  
  Displays a paginated list of products fetched from a public API.  
  Shows product name, description, seller info, and placeholder images.

- **Search & Filter**  
  Search products by name or description.  
  Sort products by seller name (A → Z or Z → A).

- **Product Details**  
  View detailed information about a product, including reviews.  
  Add new reviews locally (no API call).

- **Favorites**  
  Mark/unmark products as favorites.  
  Favorites are saved locally using `shared_preferences`.  
  Dedicated favorites screen for quick access.

- **Pagination & Pull to Refresh**  
  Load more products on scroll.  
  Refresh product list by pulling down.

- **State Management**  
  Uses [Provider](https://pub.dev/packages/provider) for clean and reactive state management.

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0) installed.  
- Android Studio / VSCode or any Flutter-supported IDE.  
- A connected device or emulator to run the app.

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Sreashna/Ecom.git
   cd Ecom
````

2. Get Flutter packages:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

## Project Structure

* `lib/domain/` - Data models (Product, Review, Seller).
* `lib/data/repository/` - API client and repository for data fetching.
* `lib/features/product_list/` - Product listing UI and provider.
* `lib/features/product_details/` - Product details screen and provider.
* `lib/features/favourites/` - Favorites UI and provider.

## Dependencies

* [provider](https://pub.dev/packages/provider)
* [shared_preferences](https://pub.dev/packages/shared_preferences)
* HTTP package or custom API client (if used)

## Architecture

* MVVM-inspired architecture separating UI, business logic, and data layers.
* Uses Provider for state management.
* Repository pattern for API data access.
* Local persistence with `shared_preferences` for favorites.




If you want, I can help you customize it further with your name, specific screenshots, or any other info you want included!
```
