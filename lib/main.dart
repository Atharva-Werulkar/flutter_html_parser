import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
// import 'package:url_launcher/url_launcher_string.dart'; // Uncomment if using url_launcher

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTML Parser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      ),
      home: const HtmlParserDemo(),
    );
  }
}

class HtmlParserDemo extends StatefulWidget {
  const HtmlParserDemo({super.key});

  @override
  State<HtmlParserDemo> createState() => _HtmlParserDemoState();
}

class _HtmlParserDemoState extends State<HtmlParserDemo>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String _htmlInput = '';
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Set a comprehensive HTML demo example
    _htmlInput = '''<h1>HTML Parser Demo</h1>
<h2>A showcase of supported elements</h2>
<h3>See how your HTML renders in Flutter</h3>

<p>This paragraph demonstrates <b>bold text</b>, <i>italic text</i>, and <u>underlined text</u>. You can also combine them like <b><i>bold and italic</i></b> or <u><b>underlined bold</b></u> text!</p>

<p>Below is a bulleted list:</p>
<ul>
  <li>Simple list item</li>
  <li>List item with <b>bold text</b></li>
  <li>List item with <i>italic text</i></li>
  <li>List item with <a href="https://flutter.dev">a hyperlink</a></li>
</ul>

<p>And here's a numbered list:</p>
<ol>
  <li>First numbered item</li>
  <li>Second numbered item with <b>bold formatting</b></li>
  <li>Third numbered item with <i>italic formatting</i></li>
</ol>

<p><a href="https://flutter.dev">This is a link to the Flutter website</a></p>

<p>Line breaks work too:<br>This text appears on a new line<br>And so does this!</p>

<p>Below is an image from Flutter.dev:</p>
<img src="https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png" />

<h2>Usage Tips</h2>
<p>Try editing this HTML to see how changes appear in the preview tab. You can modify text, add new elements, or remove existing ones!</p>''';

    _controller.text = _htmlInput;
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Inline parser must be declared before use
  Widget _parseInline(dom.Element element) {
    TextSpan buildSpan(dom.Node node) {
      if (node is dom.Text) {
        return TextSpan(text: node.text);
      }
      if (node is dom.Element) {
        TextStyle style = const TextStyle(fontSize: 16, color: Colors.black);

        // Apply appropriate styling based on tag
        if (node.localName == 'b' || node.localName == 'strong') {
          style = style.copyWith(fontWeight: FontWeight.bold);
        }
        if (node.localName == 'i' || node.localName == 'em') {
          style = style.copyWith(fontStyle: FontStyle.italic);
        }
        if (node.localName == 'u') {
          style = style.copyWith(decoration: TextDecoration.underline);
        } // Handle links differently
        if (node.localName == 'a') {
          style = style.copyWith(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          );

          // Process link content
          List<TextSpan> children = [];
          if (node.nodes.isNotEmpty) {
            children = node.nodes.map(buildSpan).toList();
            return TextSpan(style: style, children: children);
          } else {
            // If no child nodes, use the text directly
            return TextSpan(text: node.text, style: style);
          }
        }

        // For all other elements, process their children
        if (node.nodes.isNotEmpty) {
          final children = node.nodes.map(buildSpan).toList();
          return TextSpan(style: style, children: children);
        }
        // Fallback for empty elements
        return TextSpan(text: node.text, style: style);
      }
      return const TextSpan(text: "");
    }

    return RichText(text: buildSpan(element), overflow: TextOverflow.visible);
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    src,
                    height: 200,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.red[100],
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.red[800],
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'HTML Parser',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.code), text: 'HTML Code'),
                Tab(icon: Icon(Icons.preview), text: 'Preview'),
              ],
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildHtmlInputTab(), _buildPreviewTab()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _tabController.animateTo(1);
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Preview'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHtmlInputTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'HTML Input',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  _controller.clear();
                  setState(() => _htmlInput = '');
                },
                icon: const Icon(Icons.clear),
                color: Colors.grey[600],
                tooltip: 'Clear',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Enter your HTML code here...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(
                  fontFamily: 'Monaco',
                  fontSize: 14,
                  height: 1.5,
                ),
                onChanged: (val) => setState(() => _htmlInput = val),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Flutter Preview',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _htmlInput.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.preview,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No HTML to preview',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter HTML code in the first tab',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _parseHtmlString(_htmlInput),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
