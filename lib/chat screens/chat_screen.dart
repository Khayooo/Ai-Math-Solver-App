import 'package:ai_math_solver/dashboard/dashboard.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart' hide Content;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // ✅ Added for Markdown rendering
import '../utils/app_strings.dart';
import '../utils/asset_paths.dart';
import '../utils/colors_paths.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late GenerativeModel model;
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: AssetPaths().bot_img,
  );

  @override
  void initState() {
    super.initState();

    // ✅ Initialize Gemini
    model = GenerativeModel(
      model: "gemini-2.5-flash",
      apiKey: "AIzaSyB7NToCpz_ckbWPpQ01ApEEQGHRy-EyMR0",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
          child: Image.asset(AssetPaths().back_button, scale: 3.0),
        ),
        title: Text(
          AppStrings().chat_ai,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Image.asset(AssetPaths().result_screen_history_button, scale: 2.0),
          PopupMenuButton<String>(
            icon: Image.asset(AssetPaths().dotes_button, scale: 2.0),
            color: ColorsPaths().white_color,
            onSelected: (value) {
              if (value == AppStrings().export) {
                // Export logic here
              } else if (value == AppStrings().delete) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppStrings()
                                  .are_you_sure_want_to_delete_this_chat,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Cancel Button
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color:
                                        ColorsPaths().light_orange_color),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    AppStrings().cancle,
                                    style: TextStyle(
                                        color: ColorsPaths().orange_color,
                                        fontSize: 16),
                                  ),
                                ),
                                // Delete button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      messages.clear();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        transform: GradientRotation(90),
                                        colors: [
                                          ColorsPaths().gradient_color_light,
                                          ColorsPaths().gradient_color_light,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17, vertical: 12),
                                    child: Text(
                                      AppStrings().yes_delelte,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                  value: AppStrings().export,
                  child: Row(
                    children: [
                      Image.asset(AssetPaths().export_button, scale: 2.0),
                      const SizedBox(width: 10),
                      Text(AppStrings().Export),
                    ],
                  )),
              PopupMenuItem<String>(
                  value: AppStrings().delete,
                  child: Row(
                    children: [
                      Image.asset(AssetPaths().delete_button, scale: 2.0),
                      const SizedBox(width: 10),
                      Text(
                        AppStrings().Delete,
                        style: TextStyle(color: ColorsPaths().red_color),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  // ✅ Updated chat builder to render Gemini responses in Markdown
  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,

      messageOptions: MessageOptions(
        showOtherUsersAvatar: true,
        showTime: true,
        timeTextColor: Colors.grey,
        currentUserContainerColor: Colors.orangeAccent, // user message color
        containerColor: Colors.grey.shade200, // AI message color
        textColor: Colors.black87,
        messagePadding: const EdgeInsets.all(12),
        borderRadius: 20,
        messageTextBuilder: (ChatMessage message, ChatMessage? previous, ChatMessage? next) {
          // ✅ Render Gemini messages with Markdown
          if (message.user.id == geminiUser.id) {
            return MarkdownBody(
              data: message.text,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            );
          }
          // ✅ Render user messages normally
          return Text(
            message.text,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          );
        },
      ),

      inputOptions: InputOptions(
        inputDecoration: InputDecoration(
          hintText: "Type your message...",
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
        alwaysShowSend: true,
        sendButtonBuilder: (onSend) => IconButton(
          icon: const Icon(Icons.send_rounded, color: Colors.orangeAccent),
          onPressed: onSend,
        ),
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    final question = chatMessage.text.trim();

    try {
      StringBuffer buffer = StringBuffer(); // ✅ store all streamed text

      model.generateContentStream([Content.text(question)]).listen(
            (event) {
          final partial = event.text ?? "";
          if (partial.isEmpty) return;

          buffer.write(partial); // keep appending to the buffer

          // ✅ update last Gemini message dynamically
          setState(() {
            if (messages.isNotEmpty && messages.first.user.id == geminiUser.id) {
              messages[0] = ChatMessage(
                user: geminiUser,
                createdAt: messages[0].createdAt,
                text: buffer.toString(),
              );
            } else {
              messages = [
                ChatMessage(
                  user: geminiUser,
                  createdAt: DateTime.now(),
                  text: buffer.toString(),
                ),
                ...messages,
              ];
            }
          });
        },
        onError: (error) {
          print("❌ Gemini Error: $error");
        },
      );
    } catch (e) {
      print("❌ Exception: $e");
    }
  }
}
