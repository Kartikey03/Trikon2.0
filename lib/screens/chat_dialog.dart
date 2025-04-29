import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChatDialog extends StatefulWidget {
  const ChatDialog({super.key});

  @override
  State<ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _isInitializing = false;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();

  final String _serverUrl = 'https://trikon-2.onrender.com';

  @override
  void initState() {
    super.initState();
    _checkSystemStatus();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkSystemStatus() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await http.get(Uri.parse('$_serverUrl/health'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _isInitialized = data['system_initialized'] ?? false;
          _isInitializing = data['is_initializing'] ?? false;
          _errorMessage = data['error'];
        });

        // If system is initializing, poll until initialization completes
        if (_isInitializing) {
          _pollUntilInitialized();
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to connect to server';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pollUntilInitialized() async {
    // Add system message
    _addMessage(
      'Trix is warming up! This might take a minute or two...',
      false,
      isSystem: true,
    );

    // Poll the server every 5 seconds until initialization completes
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      try {
        final response = await http.get(Uri.parse('$_serverUrl/health'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _isInitialized = data['system_initialized'] ?? false;
            _isInitializing = data['is_initializing'] ?? false;
            _errorMessage = data['error'];
          });

          if (_isInitialized) {
            _addMessage(
              'Trix is ready now! Ask me anything about Trikon 2.0!',
              false,
              isSystem: true,
            );
          } else if (_errorMessage != null) {
            _addMessage(
              'Oops! There was an error: $_errorMessage',
              false,
              isSystem: true,
            );
          }

          // Continue polling if still initializing and no error
          return _isInitializing && _errorMessage == null;
        }
        return false;
      } catch (e) {
        setState(() {
          _errorMessage = 'Network error while polling: $e';
        });
        return false;
      }
    });
  }

  Future<void> _initializeSystem() async {
    try {
      setState(() {
        _isLoading = true;
        _isInitializing = true;
        _errorMessage = null;
      });

      _addMessage(
        'Starting Trix initialization...',
        false,
        isSystem: true,
      );

      final response = await http.post(Uri.parse('$_serverUrl/initialize'));

      if (response.statusCode == 200 || response.statusCode == 302) {
        // System is initializing, start polling
        _pollUntilInitialized();
      } else {
        setState(() {
          _errorMessage = 'Failed to start initialization. Status: ${response.statusCode}';
        });

        _addMessage(
          'Failed to initialize Trix. Please try again later.',
          false,
          isSystem: true,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
        _isInitializing = false;
      });

      _addMessage(
        'Network error while trying to initialize Trix: $e',
        false,
        isSystem: true,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleSubmitted(String text) async {
    _textController.clear();

    if (text.trim().isEmpty) return;

    // Add user message to chat
    _addMessage(text, true);

    // Check if system is initialized
    if (!_isInitialized) {
      _addMessage(
        'Trix is not ready yet. Please wait for initialization to complete.',
        false,
        isSystem: true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Show typing indicator
      _addMessage('', false, isTyping: true);

      final response = await http.post(
        Uri.parse('$_serverUrl/ask'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'question': text}),
      );

      // Remove typing indicator
      setState(() {
        _messages.removeWhere((message) => message.isTyping);
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _addMessage(data['answer'], false);
      } else {
        final error = response.body;
        _addMessage(
          'Error: ${error.isNotEmpty ? error : "Unknown error occurred"}',
          false,
          isError: true,
        );
      }
    } catch (e) {
      // Remove typing indicator
      setState(() {
        _messages.removeWhere((message) => message.isTyping);
      });

      _addMessage(
        'Network error: $e',
        false,
        isError: true,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addMessage(String text, bool isUser, {bool isSystem = false, bool isError = false, bool isTyping = false}) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        isSystem: isSystem,
        isError: isError,
        isTyping: isTyping,
        timestamp: DateTime.now(),
      ));
    });

    // Scroll to the bottom after adding a message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        constraints: BoxConstraints(
          maxHeight: 600,
          maxWidth: 500,
        ),
        child: Column(
          children: [
            // Dialog AppBar
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/trix.jpg"),
                        radius: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Chat with Trix',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Status bar
            if (_errorMessage != null || !_isInitialized || _isInitializing)
              Container(
                padding: const EdgeInsets.all(8.0),
                color: _errorMessage != null
                    ? Colors.red[100]
                    : (_isInitializing ? Colors.amber[100] : Colors.blue[100]),
                child: Row(
                  children: [
                    Icon(
                      _errorMessage != null
                          ? Icons.error
                          : (_isInitializing ? Icons.hourglass_empty : Icons.info),
                      color: _errorMessage != null
                          ? Colors.red
                          : (_isInitializing ? Colors.amber[800] : Colors.blue),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage ??
                            (_isInitializing
                                ? 'Trix is initializing. This may take a few minutes...'
                                : 'Trix is not yet initialized'),
                        style: TextStyle(
                          color: _errorMessage != null
                              ? Colors.red[900]
                              : (_isInitializing ? Colors.amber[900] : Colors.blue[900]),
                        ),
                      ),
                    ),
                    if (!_isInitialized && !_isInitializing)
                      TextButton(
                        onPressed: _initializeSystem,
                        child: const Text('Initialize'),
                      ),
                  ],
                ),
              ),

            // Messages list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                reverse: true, // Scroll to bottom for new messages
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages.reversed.toList()[index].buildWidget(context);
                },
              ),
            ),

            // Input area
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _isLoading ? null : _handleSubmitted,
                      decoration: const InputDecoration(
                        hintText: 'Ask Trix something...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24.0)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF0F0F0),
                      ),
                      enabled: !_isLoading,
                    ),
                  ),
                  SizedBox(width: 4),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () => _handleSubmitted(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isSystem;
  final bool isError;
  final bool isTyping;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isSystem = false,
    this.isError = false,
    this.isTyping = false,
    required this.timestamp,
  });

  Widget buildWidget(BuildContext context) {
    if (isTyping) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/trix.jpg"),
              radius: 20,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SizedBox(
                width: 50,
                child: LinearProgressIndicator(),
              ),
            ),
          ],
        ),
      );
    }

    final messageAlignment = isUser ? MainAxisAlignment.end : MainAxisAlignment.start;
    final messageBgColor = isUser
        ? Colors.deepPurple[100]
        : (isSystem
        ? Colors.blue[50]
        : (isError ? Colors.red[50] : Colors.grey[200]));
    final textColor = isUser
        ? Colors.deepPurple[900]
        : (isSystem
        ? Colors.blue[900]
        : (isError ? Colors.red[900] : Colors.black87));

    final timeFormatted = DateFormat('h:mm a').format(timestamp);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: messageAlignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/trix.jpg"),
              radius: 20,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: messageBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
                  child: Text(
                    timeFormatted,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}