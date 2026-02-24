import 'dart:convert';
import 'dart:io';

/// Data model for a quote returned by the Stoic Quotes API.
class StoicQuote {
  /// Creates a quote with [text] and [author].
  StoicQuote({required this.text, required this.author});

  /// Quote text.
  final String text;

  /// Quote author.
  final String author;
}

/// Minimal HTTP client wrapper for the Stoic Quotes API.
///
/// Visible flow:
/// - Sends an HTTP GET request to [_url]
/// - Parses the JSON response
/// - Extracts `text` and `author` fields into a [StoicQuote]
class StoicQuoteService {
  /// Creates the service.
  ///
  /// If [client] is omitted, a new [HttpClient] is created.
  StoicQuoteService({HttpClient? client}) : _client = client ?? HttpClient();

  final HttpClient _client;

  static const String _url = 'https://stoic-quotes.com/api/quote';

  /// Fetches a random quote, attempting to keep the response short.
  ///
  /// The method retries up to [maxAttempts] times until the quote has at most
  /// [maxWords] words. If all attempts are longer, it fetches once more and
  /// trims the text to [maxWords].
  Future<StoicQuote> fetchShortRandomQuote({
    int maxWords = 20,
    int maxAttempts = 8,
  }) async {
    int attempts = 0;

    while (attempts < maxAttempts) {
      attempts++;

      final StoicQuote quote = await _fetchOnce();
      if (_isShortEnough(quote.text, maxWords)) {
        return quote;
      }
    }

    final StoicQuote last = await _fetchOnce();
    final String trimmed = _trimToWords(last.text, maxWords);
    return StoicQuote(text: trimmed, author: last.author);
  }

  Future<StoicQuote> _fetchOnce() async {
    final Uri uri = Uri.parse(_url);
    final HttpClientRequest request = await _client.getUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');

    final HttpClientResponse response = await request.close();
    final String body = await response.transform(utf8.decoder).join();

    final Object? decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid JSON response');
    }

    final Object? textObj = decoded['text'];
    final Object? authorObj = decoded['author'];

    final String text = (textObj is String) ? textObj.trim() : '';
    final String author = (authorObj is String) ? authorObj.trim() : '';

    if (text.isEmpty || author.isEmpty) {
      throw const FormatException('Missing quote fields');
    }

    return StoicQuote(text: text, author: author);
  }

  bool _isShortEnough(String text, int maxWords) {
    final int count = _countWords(text);
    if (count <= maxWords) {
      return true;
    }
    return false;
  }

  int _countWords(String s) {
    final String t = s.trim();
    if (t.isEmpty) return 0;

    final List<String> parts = t.split(RegExp(r'\s+'));
    return parts.length;
  }

  String _trimToWords(String s, int maxWords) {
    final String t = s.trim();
    final List<String> parts = t.split(RegExp(r'\s+'));

    if (parts.length <= maxWords) {
      return t;
    }

    final List<String> first = parts.sublist(0, maxWords);
    final String joined = first.join(' ');
    return '$joined…';
  }
}
