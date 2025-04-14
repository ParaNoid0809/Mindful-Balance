# Mindful Balance

Mindful Balance is a Flutter application designed to help users track their mood and emotional well-being through journaling and mood analysis. The app utilizes AI to predict moods based on user input and provides visualizations of mood trends over time. 
![WhatsApp Image 2025-04-14 at 19 46 40_358898dd](https://github.com/user-attachments/assets/e77e9069-63c4-4cdc-bb9b-66cb49adc54c)

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [API Integration](#api-integration)
- [File Structure](#file-structure)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Mood Logging**: Users can log their mood by entering journal entries.
- **Mood Prediction**: The app uses an AI service to predict the user's mood based on their journal text.
- **Mood Trends Visualization**: Users can view their mood trends over time with interactive charts.
- **User-Friendly Interface**: The app features a clean and intuitive UI for easy navigation.

## Technologies Used

- **Flutter**: The framework used for building the app.
- **Dart**: The programming language used for Flutter development.
- **Dio**: A powerful HTTP client for making API requests.
- **rxdart**: A reactive programming library for managing streams.
- **fl_chart**: A library for creating beautiful charts in Flutter.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/mindfulbalance.git
   cd mindfulbalance
   ```

2. Install the dependencies:
   ```bash
   flutter pub get
   ```

3. Set up the Android environment:
   - Ensure you have Android Studio installed and configured.
   - Open the project in Android Studio and run it on an emulator or physical device.

4. (Optional) Configure the API endpoint in `lib/services/mood_service.dart` if needed.

## Usage

1. Launch the app on your device or emulator.
2. Navigate to the "Log Your Mood" page to enter your journal entries.
3. Click on "Analyze Mood" to get mood predictions based on your input.
4. View the mood trends and distribution in the "Mood Trends" section.

## API Integration

The app integrates with the following API endpoint for mood prediction:

- **Endpoint**: `https://mindfulbalance-api-1.onrender.com/predict/mood`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "journal": "<user's journal text>",
    "language": "en"
  }
  ```
- **Response**: The API returns a JSON object containing the predicted mood and confidence level.

## File Structure
lib/
├── models/
│ └── mood_entry.dart # Data model for mood entries
├── pages/
│ ├── log_mood.dart # Mood logging page
│ ├── moodtrends.dart # Mood trends visualization page
│ └── mindfulness.dart # Main mindfulness hub page
├── providers/
│ └── mood_data_provider.dart # Provider for mood data
├── services/
│ └── mood_service.dart # Service for API integration
├── widgets/
│ └── mood_trends_chart.dart # Widget for displaying mood trends
└── main.dart # Entry point of the application


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

