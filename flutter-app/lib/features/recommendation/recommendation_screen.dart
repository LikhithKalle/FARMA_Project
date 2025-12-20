import 'package:flutter/material.dart';
import '../../models/recommendation.dart';
import '../../services/tts_service.dart';

class RecommendationScreen extends StatefulWidget {
  final List<Recommendation> recommendations;

  const RecommendationScreen({super.key, required this.recommendations});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  late final TtsService _ttsService;
  TtsState _currentTtsState = TtsState.stopped;
  String? _currentlySpeaking;

  @override
  void initState() {
    super.initState();
    _ttsService = TtsService();
    _ttsService.onStateChanged = () {
      setState(() {
        _currentTtsState = _ttsService.ttsState;
      });
    };
    // Set initial language - this can be dynamic based on user selection
    _ttsService.setLanguage('en-US');
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }

  void _handleTts(Recommendation recommendation) {
    final textToSpeak = '${recommendation.cropName}. ${recommendation.suitabilityExplanation}';
    if (_currentTtsState == TtsState.playing && _currentlySpeaking == recommendation.cropName) {
      _ttsService.stop();
      _currentlySpeaking = null;
    } else {
      _ttsService.speak(textToSpeak);
      _currentlySpeaking = recommendation.cropName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Recommendations'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        itemCount: widget.recommendations.length,
        itemBuilder: (context, index) {
          final recommendation = widget.recommendations[index];
          final isSpeaking = _currentTtsState == TtsState.playing && _currentlySpeaking == recommendation.cropName;

          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation.cropName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildRiskIndicator(recommendation.riskLevel),
                  const SizedBox(height: 15),
                  Text(
                    recommendation.suitabilityExplanation,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Water Requirement: ${recommendation.waterRequirement}',
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(isSpeaking ? Icons.stop_circle_outlined : Icons.volume_up, color: Colors.blue, size: 30),
                        tooltip: isSpeaking ? 'Stop' : 'Read Aloud',
                        onPressed: () => _handleTts(recommendation),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () { /* TODO: Implement What-If Comparison */ },
                        child: const Text('What-If Analysis'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildRiskIndicator(RiskLevel riskLevel) {
    IconData icon;
    Color color;
    String text;

    switch (riskLevel) {
      case RiskLevel.Low:
        icon = Icons.check_circle;
        color = Colors.green;
        text = 'Low Risk';
        break;
      case RiskLevel.Medium:
        icon = Icons.warning;
        color = Colors.orange;
        text = 'Medium Risk';
        break;
      case RiskLevel.High:
        icon = Icons.error;
        color = Colors.red;
        text = 'High Risk';
        break;
    }

    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
