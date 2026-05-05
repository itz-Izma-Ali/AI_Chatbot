import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class InputArea extends StatefulWidget {
  final void Function(String) onSend;
  const InputArea({super.key, required this.onSend});

  @override
  State<InputArea> createState() => InputAreaState();
}

class InputAreaState extends State<InputArea> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void prefill(String text) {
    _controller.text = text;
    setState(() => _hasText = text.trim().isNotEmpty);
  }

  void _send() {
    if (!_hasText) return;
    final text = _controller.text.trim();
    widget.onSend(text);
    _controller.clear();
    setState(() => _hasText = false);
  }

  void _showAttachOptions() {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final opt in const [
                ['📷', 'Take Photo'],
                ['🖼️', 'Choose Image'],
                ['📄', 'Upload Document'],
                ['🎤', 'Record Audio'],
                ['📁', 'Browse Files'],
              ])
                ListTile(
                  leading: Text(opt[0], style: const TextStyle(fontSize: 22)),
                  title: Text(opt[1]),
                  onTap: () => Navigator.pop(ctx),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        16 + MediaQuery.of(context).viewInsets.bottom * 0 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.background,
          border: Border.all(
            color: _focus.hasFocus ? colors.primary : colors.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: _showAttachOptions,
              icon: Text('📎', style: TextStyle(fontSize: 18, color: colors.textSecondary)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  maxLines: null,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _send(),
                  inputFormatters: const [],
                  style: TextStyle(fontSize: 15, color: colors.textPrimary),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    border: InputBorder.none,
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: colors.textTertiary),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _hasText
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colors.primary, colors.primaryDark],
                      )
                    : null,
                color: _hasText ? null : colors.border,
                boxShadow: _hasText
                    ? [BoxShadow(color: colors.primaryGlow, blurRadius: 8, offset: const Offset(0, 2))]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _hasText ? _send : null,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.arrow_upward,
                      color: _hasText ? Colors.white : colors.textTertiary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
