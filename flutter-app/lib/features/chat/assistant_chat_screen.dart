import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as Math;
import 'package:flutter_tts/flutter_tts.dart';
import '../../services/api_service.dart';
import '../../services/translation_service.dart';
import '../recommendations/recommendation_result_screen.dart';
import 'map_picker_screen.dart';
import 'package:latlong2/latlong.dart';

class AssistantChatScreen extends StatefulWidget {
  const AssistantChatScreen({super.key});

  @override
  State<AssistantChatScreen> createState() => _AssistantChatScreenState();
}

class _AssistantChatScreenState extends State<AssistantChatScreen> {
  // Styles & Colors matching the design
  static const Color primaryColor = Color(0xFF13EC6A);
  static const Color backgroundLight = Color(0xFFF6F8F7);
  static const Color backgroundDark = Color(0xFF102217);
  static const Color surfaceDark = Color(0xFF1A2C22);
  static const Color surfaceHighlight = Color(0xFF23392D);
  static const Color textDark = Color(0xFF111814);
  static const Color receivedMsgColor = Color(0xFF1A2C22);
  static const Color sentMsgColor = Color(0xFF23392D);

  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FlutterTts _flutterTts = FlutterTts();
  
  // Dynamic Chat State
  final List<Map<String, dynamic>> _messages = []; // {text, isUser, isAnimating}
  String? _sessionId;
  bool _isLoading = false;
  int? _animatingMessageIndex; // Track which message is currently animating
  bool _isTtsEnabled = true; // Speaker on by default
  
  // Interaction State
  List<String>? _currentOptions;
  String? _inputType; // "text", "options", "location", "none"

  @override
  void initState() {
    super.initState();
    _initTts();
    // Start conversation automatically
    _sendMessage("Hi", silent: true); 
  }

  Future<void> _initTts() async {
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    _updateTtsLanguage();
  }

  void _updateTtsLanguage() {
    final langCode = TranslationService.locale.value.languageCode;
    String ttsLang = 'en-US';
    if (langCode == 'hi') ttsLang = 'hi-IN';
    else if (langCode == 'te') ttsLang = 'te-IN';
    _flutterTts.setLanguage(ttsLang);
  }

  Future<void> _speakText(String text) async {
    if (!_isTtsEnabled) return; // Don't speak if muted
    _updateTtsLanguage();
    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text, {bool silent = false}) async {
    if (text.trim().isEmpty) return;

    if (!silent) {
       setState(() {
         _messages.add({"text": text, "isUser": true});
         _currentOptions = null; // Hide options after selection
         _inputType = "none";
       });
       _msgController.clear();
       _scrollToBottom();
    }

    setState(() => _isLoading = true);

    try {
      final api = ApiService();
      // "Silent" messages like initial "Hi" don't show as user bubbles but trigger bot response
      final response = await api.sendChatMessage(
        text, 
        _sessionId, 
        languageCode: TranslationService.locale.value.languageCode
      );
      
      _sessionId = response['session_id'];
      final botText = response['response'] ?? "I didn't understand that.";
      final recommendations = response['recommendations'];
      final newOptions = response['options'] != null 
          ? List<String>.from(response['options']) 
          : null;
      final newInputType = response['input_type'] ?? "text";

        // Create a copy of recommendations to persist
        final List<dynamic>? recs = recommendations;
        
        if (mounted) {
          setState(() {
             _messages.add({"text": botText, "isUser": false, "isAnimating": true});
             _animatingMessageIndex = _messages.length - 1;
             _currentOptions = newOptions;
             _inputType = newInputType;
             _isLoading = false;
             if (recs != null && recs.isNotEmpty) {
                _lastRecommendations = recs;
             }
          });
          _scrollToBottom();
          // Trigger TTS for bot message
          _speakText(botText);
  
          // If recommendations exist, show them or navigate
          if (recs != null && recs.isNotEmpty) {
             // Small delay so user sees the "Analyzing..." message
             Future.delayed(const Duration(seconds: 1), () {
             if (mounted) {
               Navigator.push(
                 context, 
                 MaterialPageRoute(builder: (context) => RecommendationResultScreen(recommendations: recommendations))
               );
             }
           });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({"text": "Error connecting to assistant. Please try again.", "isUser": false});
          _isLoading = false;
          _inputType = "text"; // Allow retry
        });
      }
    }
  }

  Future<void> _handleManualLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerScreen()),
    );

    if (result != null && result is LatLng) {
      // Send LOC:{lat},{long}
       _sendMessage("LOC:${result.latitude},${result.longitude}");
    }
  }

  Future<void> _handleLocation() async {
    setState(() => _isLoading = true);
    
    // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission denied')));
           setState(() => _isLoading = false);
        }
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
       if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied.')));
           setState(() => _isLoading = false);
       }
       return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      
      // Send LOC:{lat},{long} to backend for reverse geocoding
      _sendMessage("LOC:${position.latitude},${position.longitude}");
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Persistent Recommendations
  List<dynamic>? _lastRecommendations;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? backgroundDark : backgroundLight;
    final Color textColor = isDark ? Colors.white : textDark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: primaryColor, size: 18),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                TranslationService.tr('farm_assistant'), 
                style: GoogleFonts.lexend(fontWeight: FontWeight.bold, color: textColor, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
            IconButton(
              icon: Icon(_isTtsEnabled ? Icons.volume_up : Icons.volume_off),
              onPressed: () {
                setState(() => _isTtsEnabled = !_isTtsEnabled);
                if (!_isTtsEnabled) {
                  _flutterTts.stop();
                }
              },
              tooltip: _isTtsEnabled ? 'Mute' : 'Unmute',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                 setState(() {
                   _lastRecommendations = null; 
                   _messages.clear();
                 });
                 _sendMessage("reset", silent: true);
              },
              tooltip: TranslationService.tr('restart'),
            )
        ],
      ),
      body: Column(
        children: [
          // Chat List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                   return TypingIndicator(isDark: isDark);
                }
                
                final msg = _messages[index];
                final isUser = msg['isUser'] as bool;
                final text = msg['text'] as String;
                final isAnimating = msg['isAnimating'] == true && _animatingMessageIndex == index;
                final isLastBotMessage = !isUser && index == _messages.length - 1 && !_isLoading;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMessageBubble(text, isUser, isDark, isAnimating: isAnimating, messageIndex: index),
                    // Show options right after the last bot message
                    if (isLastBotMessage && _currentOptions != null && _currentOptions!.isNotEmpty)
                      _buildInlineOptions(isDark),
                  ],
                );
              },
            ),
          ),

          // Input Area (only show if no inline options)
          if (_currentOptions == null || _currentOptions!.isEmpty)
            _buildInputArea(isDark, textColor),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isDark, Color textColor) {
      // 1. If loading, show nothing
      if (_isLoading) return const SizedBox.shrink();

      // 2. If options are available, show chips
      if (_currentOptions != null && _currentOptions!.isNotEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? Colors.black26 : Colors.white,
            width: double.infinity,
            child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.end,
                children: _currentOptions!.asMap().entries.map((entry) {
                    final int idx = entry.key;
                    final String option = entry.value;
                    final bool isLocation = (_inputType == "location" && idx == 0) || option == "Use Current Location";
                    final bool isManual = option == "Search Manually";
                    
                    return ActionChip(
                        label: Text(
                             option, 
                             style: GoogleFonts.lexend(
                                 color: (isLocation || isManual) ? backgroundDark : primaryColor,
                                 fontWeight: FontWeight.bold
                             )
                        ),
                        backgroundColor: (isLocation || isManual) ? primaryColor : (isDark ? surfaceHighlight : Colors.grey[100]),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        avatar: isLocation ? const Icon(Icons.my_location, size: 16, color: backgroundDark) : 
                                (isManual ? const Icon(Icons.map, size: 16, color: backgroundDark) : null),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        onPressed: () {
                           if (isLocation) {
                               _handleLocation();
                           } else if (isManual) {
                               _handleManualLocation();
                           } else {
                               _sendMessage(option);
                           }
                        },
                    );
                }).toList().cast<Widget>(),
            ),
          );
      }

      // 3. If recommendations exist (COMPLETE STATE), show "View Results" button
      if (_lastRecommendations != null && _lastRecommendations!.isNotEmpty) {
         return Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? Colors.black26 : Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.assessment),
                label: Text(TranslationService.tr('view_recs'), style: GoogleFonts.lexend(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: backgroundDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                   Navigator.push(
                     context, 
                     MaterialPageRoute(builder: (context) => RecommendationResultScreen(recommendations: _lastRecommendations))
                   );
                },
              ),
            ),
         );
      }

      // 4. Default: Text Input
      if (_inputType == "text" || _inputType == null) {
         return Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? Colors.black26 : Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: TranslationService.tr('type_answer'),
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: isDark ? surfaceHighlight : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onSubmitted: (val) => _sendMessage(val),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: backgroundDark),
                    onPressed: () => _sendMessage(_msgController.text),
                  ),
                )
              ],
            ),
          );
      }
      
      return const SizedBox.shrink();
  }

  // Options displayed inline right below the bot message
  Widget _buildInlineOptions(bool isDark) {
    if (_currentOptions == null || _currentOptions!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: _currentOptions!.asMap().entries.map((entry) {
          final int idx = entry.key;
          final String option = entry.value;
          final bool isLocation = (_inputType == "location" && idx == 0) || option == "Use Current Location";
          final bool isManual = option == "Search Manually";
          
          return ActionChip(
            label: Text(
              option,
              style: GoogleFonts.lexend(
                color: (isLocation || isManual) ? backgroundDark : primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            backgroundColor: (isLocation || isManual) ? primaryColor : (isDark ? surfaceHighlight : Colors.grey[100]),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            avatar: isLocation ? const Icon(Icons.my_location, size: 16, color: backgroundDark) : 
                    (isManual ? const Icon(Icons.map, size: 16, color: backgroundDark) : null),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            onPressed: () {
              if (isLocation) {
                _handleLocation();
              } else if (isManual) {
                _handleManualLocation();
              } else {
                _sendMessage(option);
              }
            },
          );
        }).toList().cast<Widget>(),
      ),
    );
  }

  void _onAnimationComplete(int messageIndex) {
    if (mounted) {
      setState(() {
        if (_animatingMessageIndex == messageIndex) {
          _messages[messageIndex]['isAnimating'] = false;
          _animatingMessageIndex = null;
        }
      });
    }
  }

  Widget _buildMessageBubble(String text, bool isUser, bool isDark, {bool isAnimating = false, int? messageIndex}) {
    final textColor = isUser ? backgroundDark : (isDark ? Colors.white : textDark);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              backgroundColor: surfaceHighlight,
              radius: 16,
              child: Icon(Icons.smart_toy, size: 18, color: primaryColor),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: isUser 
                        ? primaryColor.withOpacity(0.9) 
                        : (isDark ? receivedMsgColor : Colors.white),
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isUser ? 20 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 20)
                    ),
                    boxShadow: [
                       BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                    ]
                ),
                child: isUser || !isAnimating
                  ? Text(
                      text,
                      style: GoogleFonts.lexend(
                          color: textColor,
                          fontSize: 15,
                          height: 1.4
                      )
                  )
                  : AnimatedTypingText(
                      text: text,
                      textColor: textColor,
                      onComplete: () => _onAnimationComplete(messageIndex ?? 0),
                    ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 16,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            )
          ],
        ],
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  final bool isDark;
  const TypingIndicator({super.key, required this.isDark});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return FadeTransition(
            opacity: DelayTween(begin: 0.0, end: 1.0, delay: index * 0.2).animate(_controller),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: widget.isDark ? Colors.white70 : Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class DelayTween extends Tween<double> {
  final double delay;
  DelayTween({super.begin, super.end, required this.delay});

  @override
  double lerp(double t) {
    return super.lerp((Math.sin((t - delay) * 2 * Math.pi) + 1) / 2);
  }
}

// Animated typing text widget - shows words one by one
class AnimatedTypingText extends StatefulWidget {
  final String text;
  final Color textColor;
  final VoidCallback? onComplete;
  final Duration wordDelay;

  const AnimatedTypingText({
    super.key,
    required this.text,
    required this.textColor,
    this.onComplete,
    this.wordDelay = const Duration(milliseconds: 80),
  });

  @override
  State<AnimatedTypingText> createState() => _AnimatedTypingTextState();
}

class _AnimatedTypingTextState extends State<AnimatedTypingText> {
  String _displayedText = '';
  List<String> _words = [];
  int _currentWordIndex = 0;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(' ');
    _animateNextWord();
  }

  void _animateNextWord() {
    if (!mounted) return;
    
    if (_currentWordIndex < _words.length) {
      setState(() {
        if (_displayedText.isEmpty) {
          _displayedText = _words[_currentWordIndex];
        } else {
          _displayedText = '$_displayedText ${_words[_currentWordIndex]}';
        }
        _currentWordIndex++;
      });
      
      Future.delayed(widget.wordDelay, _animateNextWord);
    } else {
      // Animation complete
      if (!_isComplete) {
        _isComplete = true;
        widget.onComplete?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: GoogleFonts.lexend(
        color: widget.textColor,
        fontSize: 15,
        height: 1.4,
      ),
    );
  }
}
