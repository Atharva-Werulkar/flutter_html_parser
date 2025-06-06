import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
// import 'package:url_launcher/url_launcher_string.dart'; // Uncomment if using url_launcher

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HtmlParserDemo(),
    );
  }
}

class HtmlParserDemo extends StatefulWidget {
  const HtmlParserDemo({super.key});

  @override
  State<HtmlParserDemo> createState() => _HtmlParserDemoState();
}

class _HtmlParserDemoState extends State<HtmlParserDemo> {
  final TextEditingController _controller = TextEditingController();
  String _htmlInput = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Inline parser must be declared before use
  Widget _parseInline(dom.Element element) {
    TextSpan buildSpan(dom.Node node) {
      if (node is dom.Text) {
        return TextSpan(text: node.text);
      }
      if (node is dom.Element) {
        TextStyle style = const TextStyle();
        if (node.localName == 'b' || node.localName == 'strong') {
          style = style.copyWith(fontWeight: FontWeight.bold);
        }
        if (node.localName == 'i' || node.localName == 'em') {
          style = style.copyWith(fontStyle: FontStyle.italic);
        }
        if (node.localName == 'u') {
          style = style.copyWith(decoration: TextDecoration.underline);
        }
        if (node.localName == 'a') {
          style = style.copyWith(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          );
          // For demo, just style as link. Add recognizer for tap if needed.
          return TextSpan(text: node.text, style: style);
        }
        return TextSpan(
          style: style,
          children: node.nodes.map(buildSpan).toList(),
        );
      }
      return const TextSpan();
    }

    return RichText(text: buildSpan(element));
  }

  List<Widget> _parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    final List<Widget> widgetList = [];

    Widget parseNode(dom.Node node) {
      if (node is dom.Text) {
        if (node.text.trim().isEmpty) return const SizedBox.shrink();
        return Text(node.text);
      }
      if (node is dom.Element) {
        switch (node.localName) {
          case 'h1':
            return Text(
              node.text,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            );
          case 'h2':
            return Text(
              node.text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          case 'h3':
            return Text(
              node.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          case 'p':
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: _parseInline(node),
            );
          case 'br':
            return const SizedBox(height: 8);
          case 'ul':
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: node.children
                    .map(
                      (li) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 16)),
                          Expanded(child: _parseInline(li)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            );
          case 'ol':
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: node.children.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final li = entry.value;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$idx. ', style: const TextStyle(fontSize: 16)),
                      Expanded(child: _parseInline(li)),
                    ],
                  );
                }).toList(),
              ),
            );
          case 'img':
            final src = node.attributes['src'];
            if (src != null && src.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.network(src, height: 150, fit: BoxFit.contain),
              );
            }
            break;
          default:
            // For unknown or inline tags, try to parse as inline
            return _parseInline(node);
        }
      }
      return const SizedBox.shrink();
    }

    for (var node in document.body?.nodes ?? []) {
      final widget = parseNode(node);
      if (widget is! SizedBox) widgetList.add(widget);
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HTML Parser Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Enter HTML',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _htmlInput = val),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _parseHtmlString(_htmlInput),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// In your main.dart, change home: const MyHomePage(title: ...) to home: HtmlParserDemo(),
// and add html, url_launcher to pubspec.yaml dependencies.
