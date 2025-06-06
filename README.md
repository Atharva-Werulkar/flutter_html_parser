# Flutter HTML Parser

A simple Flutter app that demonstrates how to parse HTML strings and render them as Flutter widgets, supporting common HTML tags and inline formatting.

## Features
- Parse and render HTML tags: `<h1>`, `<h2>`, `<h3>`, `<p>`, `<ul>`, `<ol>`, `<li>`, `<br>`, `<img>`, and more
- Support for inline tags: `<b>`, `<strong>`, `<i>`, `<em>`, `<u>`, `<a>` (styled as links)
- Handles nested and mixed HTML content
- Displays images from network sources
- Simple UI for entering and previewing HTML

## Getting Started

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) installed

### Installation
1. Clone this repository or copy the project files.
2. Add the following dependencies to your `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     html: ^0.15.4
   ```
3. Run:
   ```sh
   flutter pub get
   ```

### Running the App
```
flutter run
```

## Usage
- Enter your HTML content in the text field.
- The parsed Flutter widgets will be displayed below in real time.

### Example HTML
```
<h1>Welcome to Flutter HTML Parser</h1>
<p>This is a <b>bold</b>, <i>italic</i>, and <u>underlined</u> text example.</p>
<ul>
  <li>First bullet item</li>
  <li>Second bullet item with <b>bold</b> text</li>
</ul>
<img src="https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png" />
```

## Limitations
- Only a subset of HTML tags and inline styles are supported.
- `<a>` tags are styled as links but are not clickable by default (see code comments to enable tap support).
- Inline CSS styles (e.g., `style="color:red;"`) are not parsed.

## License
MIT License
