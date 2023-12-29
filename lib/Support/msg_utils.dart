import 'package:flutter/material.dart';

class MessageUtils {
  static void expandableMessageCard(
    String messageText,
    Function(String) updateMessage,
    BuildContext context,
  ) {
    final int chunkSize = 200;
    List<String> messageParts = [];
    List<String> displayedParts = [];
    bool showReadMore = false;

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

    // Function to show the next part of the message
    void showNextPart() {
      if (messageParts.isNotEmpty) {
        displayedParts.add(messageParts.removeAt(0));
        showReadMore = messageParts.isNotEmpty;
      }
    }

    // Initial call to show the first part
    showNextPart();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          title: const Text('Expanded Message'),
          content: SingleChildScrollView(
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
                      showNextPart();
                      updateMessage(messageText); // Perform any action on update
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
