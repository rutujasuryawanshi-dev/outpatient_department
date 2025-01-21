import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outpatient_department/constants/Theme.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    // Add user message to the list
    setState(() {
      _messages.add({"sender": "user", "message": _messageController.text.trim()});
    });

    String userMessage = _messageController.text.trim();
    _messageController.clear();

    // Simulate bot response
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({"sender": "bot", "message": _getBotResponse(userMessage)});
      });
    });
  }

  String _getBotResponse(String userMessage) {
    // Example bot responses
    if (userMessage.toLowerCase().contains("hello")) {
      return "Hi! How can I assist you today?";
    } else if (userMessage.toLowerCase().contains("help")) {
      return "Sure! Please tell me what you need help with.";
    }
    return "I'm not sure I understand. Can you rephrase?";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Chatbot",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: ArgonColors.primary,
        elevation: 0,
      ),
      backgroundColor: ArgonColors.primary,
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 30),

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isUser = message['sender'] == "user";
                        return Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: isUser ? ArgonColors.primary : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20).copyWith(
                                topRight: Radius.circular(isUser ? 0 : 20),
                                topLeft: Radius.circular(isUser ? 20 : 0),
                              ),
                            ),
                            child: Text(
                              message['message']!,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: "Type your message...",
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        FloatingActionButton(
                          onPressed: _sendMessage,
                          backgroundColor: ArgonColors.primary,
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
