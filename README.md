# Movie List Flutter App

This Flutter application displays a list of movies retrieved from a remote API. Users can search for movies, paginate through results, and view movie details, including their titles and ratings.

## Features

- **Movie List:** Fetches and displays a paginated list of movies.
- **Search:** Filters movies by title using a search bar (minimum 3 characters).
- **Pagination:** Navigate between pages with visible page numbers and ellipses for large lists.
- **Dynamic Content:** Handles loading states while fetching data from the API.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/tuceturan/theMovies.git
   ```

2. Navigate to the project directory:

   ```bash
   cd flutter-movie-list
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

## Dependencies

- **http:** For making API requests.

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.15.0
```

## File Structure

- **`main.dart`**: Contains the main entry point and the application structure.
- **`MovieService`**: Handles API calls to fetch movies.
- **UI Components:** Widgets for displaying movie cards, pagination buttons, and the search bar.


## API Integration

The application fetches movies from a sample API.:

```dart
static const String _apiUrl = "https://api.themoviedb.org";
```

### API Endpoints

- **Search Movies:**
  `GET /search/movie?api_key={api_key}&page={page}`

- **Popular Movies:**
  `GET /movie/popular?api_key={api_key}&page={page}`

### API Requirements

- **API Key:** Replace `{api_key}` with your valid API key.

- **Response Example:**
  ```json
  {
    "results": [
      {
        "title": "Movie Title",
        "popularity": "8.5",
        "poster_path": "/poster.jpg"
      }
    ]
  }
  ```

## Customization

- **Theme:** Modify the `primarySwatch` in `ThemeData` to change the application theme.


## Contributing

1. Fork the repository.
2. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add new feature"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Create a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

