import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/chat_header.dart';
import '../widgets/empty_state.dart';
import '../widgets/input_area.dart';
import '../widgets/message_bubble.dart';
import '../widgets/sidebar.dart';
import '../widgets/suggestions_bar.dart';
import '../widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollCtrl = ScrollController();
  final _inputKey = GlobalKey<InputAreaState>();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(String text) {
    final chat = context.read<ChatProvider>();
    final settings = context.read<SettingsProvider>();
    chat.sendMessage(text, settings.selectedModel.name);
    _scrollToBottom();
  }

  void _quickSend(String text) {
    _inputKey.currentState?.prefill(text);
    _handleSend(text);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final chat = context.watch<ChatProvider>();

    chat.removeListener(_scrollToBottom);
    chat.addListener(_scrollToBottom);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colors.background,
      drawer: const Drawer(
        elevation: 8,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(),
        child: Sidebar(),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Container(
            color: colors.surface,
            child: Column(
              children: [
                ChatHeader(onMenuTap: () => _scaffoldKey.currentState?.openDrawer()),
                Expanded(
                  child: chat.hasMessages || chat.isTyping
                      ? ListView.separated(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.all(20),
                          itemCount: chat.messages.length + (chat.isTyping ? 1 : 0),
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (_, i) {
                            if (chat.isTyping && i == chat.messages.length) {
                              return const TypingIndicator();
                            }
                            return MessageBubble(message: chat.messages[i]);
                          },
                        )
                      : EmptyState(onQuickSend: _quickSend),
                ),
                if (chat.hasMessages) SuggestionsBar(onTap: _quickSend),
                InputArea(key: _inputKey, onSend: _handleSend),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
