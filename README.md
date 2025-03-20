# Poster Location Tracker

Hi there! 👋 This is my project for the "Mobile Applications" course - a handy app that helps track where posters and advertisements are placed so they don't get forgotten about and left behind.

## Why I Made This

We've all seen it - campaign posters, event announcements, and ads that stay up long after they're relevant. I wanted to solve this problem by creating an app that:
- Makes it easy to remember where you put up posters
- Helps you find them again when it's time to take them down
- Keeps everything organized by campaigns or events

## What It Does

- 📍 Marks poster locations on a map
- 📁 Organizes locations into groups (like "Election Campaign" or "Music Festival")
- 🌍 Shows everything on a nice TomTom map
- 🌓 Works in both dark and light mode
- 📱 Saves everything right on your phone

## How to Use It

1. **Add a poster location:** Tap "Location," enter a name, choose a group, and save
2. **Find your posters:** Tap "Lists" to see all your poster groups
3. **Navigate to posters:** Tap any location to see it on the map when it's time for removal

## Getting Started

You'll need Flutter installed and a TomTom API key. Just add your key to a `.env` file in the assets folder and you're good to go!

```
TOMTOM_API_KEY=your_key_here
```

Run `flutter pub get` to install dependencies and `flutter run` to start the app.
