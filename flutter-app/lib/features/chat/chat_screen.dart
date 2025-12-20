import 'package:flutter/material.dart';
import '../../models/farmer_context.dart';
import '../../models/recommendation.dart';
import '../../services/recommendation_service.dart';
import '../recommendation/recommendation_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final FarmerContext _farmerContext = FarmerContext();
  final RecommendationService _recommendationService = RecommendationService();

  int _questionIndex = 0;
  final List<String> _questions = [
    'Welcome to FARMA! Let\'s get started. What is your state?',
    'Got it. Now, what is your district?',
    'What is the primary soil type on your land? (e.g., Alluvial, Black, Red)',
    'Which season are you planning for? (e.g., Kharif, Rabi)',
    'What is the area of your land in acres?',
    'Do you have a reliable source of irrigation? (yes/no)',
  ];

  @override
  void initState() {
    super.initState();
    _addBotMessage(_questions[_questionIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FARMA Assistant'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(message['text'], message['isUser']);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  void _addMessage(String text, {required bool isUser}) {
    setState(() {
      _messages.add({'text': text, 'isUser': isUser});
    });
  }

  void _addBotMessage(String text) {
    _addMessage(text, isUser: false);
  }

  void _addUserMessage(String text) {
    _addMessage(text, isUser: true);
  }

  Widget _buildMessage(String message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.green[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(message, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your answer...',
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[700]!),
                ),
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.green[700]),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    final answer = text.trim();
    if (answer.isEmpty) return;

    _addUserMessage(answer);
    _processAnswer(answer);
    _textController.clear();
  }

  void _processAnswer(String answer) {
    switch (_questionIndex) {
      case 0:
        _farmerContext.state = answer;
        break;
      case 1:
        _farmerContext.district = answer;
        break;
      case 2:
        _farmerContext.soilType = answer;
        break;
      case 3:
        _farmerContext.season = answer;
        break;
      case 4:
        _farmerContext.landArea = double.tryParse(answer);
        break;
      case 5:
        _farmerContext.hasIrrigation =
            answer.toLowerCase() == 'yes' || answer.toLowerCase() == 'y';
        break;
    }

    _questionIndex++;

    if (_questionIndex < _questions.length) {
      _addBotMessage(_questions[_questionIndex]);
    } else {
      _getRecommendations();
    }
  }

  Future<void> _getRecommendations() async {
    if (_farmerContext.isComplete) {
      _addBotMessage('Thank you! Analyzing your inputs to generate recommendations...');
      
      // Simulate thinking
      await Future.delayed(const Duration(milliseconds: 500));

      final recommendations = await _recommendationService.getRecommendations(_farmerContext);
      
      _addBotMessage('Here are your personalized crop recommendations.');

      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendationScreen(recommendations: recommendations),
        ),
      );
    } else {
      _addBotMessage('It seems some information is missing or invalid. Let\'s start over.');
      // Reset logic
      setState(() {
        _questionIndex = 0;
        _messages.clear();
      });
      _addBotMessage(_questions[0]);
    }
  }
}
