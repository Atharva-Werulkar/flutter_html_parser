# 🚀 Flutter HTML Parser

<div align="center">
  <p>
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
  </p>
  
  <p>
    <strong>A beautiful, minimalistic Flutter app that converts HTML code into Flutter UI widgets with real-time preview</strong>
  </p>
</div>

## ✨ Features

- **🎨 Modern UI**: Clean, minimalistic design with tabbed interface
- **⚡ Real-time Preview**: Instant conversion from HTML to Flutter widgets
- **📱 Responsive Design**: Works seamlessly on all screen sizes
- **🔧 Rich HTML Support**: Supports headings, paragraphs, lists, images, and inline formatting
- **🎯 User-friendly**: Intuitive interface with clear input and preview sections

### Supported HTML Tags

| Tag | Description | Support |
|-----|-------------|---------|
| `<h1>`, `<h2>`, `<h3>` | Headings | ✅ |
| `<p>` | Paragraphs | ✅ |
| `<b>`, `<strong>` | Bold text | ✅ |
| `<i>`, `<em>` | Italic text | ✅ |
| `<u>` | Underlined text | ✅ |
| `<a>` | Links (styled) | ✅ |
| `<ul>`, `<ol>`, `<li>` | Lists | ✅ |
| `<br>` | Line breaks | ✅ |
| `<img>` | Images | ✅ |

## 📱 Screenshots

*Add your app screenshots here when available*

## 🚀 Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (Version 3.0 or higher)
- [Dart](https://dart.dev/get-dart) (Version 2.17 or higher)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter_html_parser.git
   cd flutter_html_parser
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  html: ^0.15.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## 🎯 Usage

1. **Enter HTML Code**: Use the "HTML Code" tab to input your HTML
2. **Preview Results**: Switch to the "Preview" tab to see the Flutter widgets
3. **Real-time Updates**: Changes in HTML are reflected instantly in the preview

### Example HTML

```html
<h1>Welcome to Flutter HTML Parser</h1>
<p>This is a <b>bold</b>, <i>italic</i>, and <u>underlined</u> text example.</p>
<ul>
  <li>First bullet item</li>
  <li>Second bullet item with <b>bold</b> text</li>
</ul>
<ol>
  <li>Numbered item one</li>
  <li>Numbered item two</li>
</ol>
<a href="https://flutter.dev">Visit Flutter</a>
<br>
<img src="https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png" />
```

## 🏗️ Architecture

The app follows a clean architecture pattern:

- **HTML Parsing**: Uses the `html` package to parse HTML strings
- **Widget Conversion**: Recursive parser converts DOM nodes to Flutter widgets
- **State Management**: Simple `setState` for real-time updates
- **UI Components**: Material 3 design with custom styling

## 🔄 How It Works

1. HTML string is parsed using the `html` package
2. DOM tree is traversed recursively
3. Each node is converted to appropriate Flutter widget
4. Inline styles are handled using `RichText` and `TextSpan`
5. Block elements create separate widgets

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Roadmap

- [ ] CSS inline styles support
- [ ] More HTML tags (tables, forms, etc.)
- [ ] Export to Flutter code
- [ ] Dark theme support
- [ ] Custom styling options
- [ ] HTML validation

## 🐛 Known Issues

- Inline CSS styles are not yet supported
- Complex nested structures may need refinement
- Link tap functionality requires manual implementation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) team for the amazing framework
- [html](https://pub.dev/packages/html) package contributors
- Material Design team for design inspiration

---

<div align="center">
  <p>Made with ❤️ using Flutter</p>
  <p>
    <a href="https://github.com/yourusername/flutter_html_parser/issues">Report Bug</a>
    ·
    <a href="https://github.com/yourusername/flutter_html_parser/issues">Request Feature</a>
  </p>
</div>
