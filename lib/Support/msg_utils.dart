import 'package:flutter/material.dart';

class MessageUtils {
  static List<String> messageParts = [];
  static List<String> displayedParts = [];
  static bool showReadMore = false;
  // Function to show the next part of the message
  static void showNextPart(List<String> messageParts,
      List<String> displayedParts, bool showReadMore) {
    if (messageParts.isNotEmpty) {
      displayedParts.add(messageParts.removeAt(0));
      showReadMore = messageParts.isNotEmpty;
    }
  }

  static void expandableMessageCard(
    String messageText,
    Function(String) updateMessage,
    BuildContext context,
  ) {
    const int chunkSize = 200;

    int startPos = 0;

    // Split the message into parts based on chunk size
    while (startPos < messageText.length) {
      messageParts.add(messageText.substring(
        startPos,
        startPos + chunkSize < messageText.length
            ? startPos + chunkSize
            : messageText.length,
      ));
      startPos += chunkSize;
    }

    // Initial call to show the first part
    showNextPart(messageParts, displayedParts, showReadMore);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var part in displayedParts)
                  Text(
                    part,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                if (showReadMore)
                  TextButton(
                    onPressed: () {
                      showNextPart(messageParts, displayedParts, showReadMore);
                      updateMessage(
                          messageText); // Perform any action on update
                    },
                    child: const Text('Read More'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
