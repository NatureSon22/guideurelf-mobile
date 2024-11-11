import 'package:app/pages/model/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream<List<Map<String, dynamic>>> getUsers() {
  //   String role = _auth.currentUser.
  // }
  // {uid: McKtCyGQqLhPeSyChpHqB4Lqj8x2, role: user, campus: Binagonan, email: momo@gmail.com}

  Future<String> createMessage(String departmentUID) async {
    // Create the chatRoomID
    List<String> chatRoomID = [departmentUID, _auth.currentUser!.uid];
    chatRoomID.sort();
    String id = chatRoomID.join("_");

    // Add the chat room document and get its ID
    DocumentReference chatRoomRef =
        await _firestore.collection("ChatRooms").add({
      "id": id,
      "participants": {
        "user": _auth.currentUser!.uid,
        "personnel": departmentUID
      },
      "status": "ACTIVE",
      "lastMessageTimestamp": Timestamp.now(),
    });

    // Return the document ID
    return chatRoomRef.id;
  }

  Stream<List<Map<String, dynamic>>> getDepartments(String campus) {
    return _firestore
        .collection("Users")
        .where("role", isEqualTo: "personnel")
        .where("campus", isEqualTo: campus)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getChatsDepartment(String departmentUID) {
    List<String> chatRoomID = [_auth.currentUser!.uid, departmentUID];
    chatRoomID.sort();
    String id = chatRoomID.join("_");

    return _firestore
        .collection("ChatRooms")
        .where("id", isEqualTo: id)
        .orderBy("lastMessageTimestamp", descending: true)
        .orderBy("status")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              // Include the document ID in the data map
              final data = doc.data();
              data['docId'] = doc.id; // Add the document ID to the data map
              return data; // Return the modified data map
            }).toList());
  }

  Future<List<Map<String, dynamic>>> checkChat(String departmentUID) async {
    String chatRoomID =
        [departmentUID, _auth.currentUser!.uid].reversed.join("_");

    // Fetch chat room documents from the Firestore collection where the ID matches.
    List<Map<String, dynamic>> chatRooms = await _firestore
        .collection("chatRooms")
        .where("id", isEqualTo: chatRoomID)
        .get()
        .then((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

    // Return the list of chat room data.
    return chatRooms;
  }

  void markMessagesAsRead(String chatRoomID, String userRole) async {
    await _firestore.collection("ChatRooms").doc(chatRoomID).update({
      "hasUnReadMessage": userRole == "personnel"
          ? {"personnel": false, "user": true}
          : {"personnel": true, "user": false},
    });
  }

  Stream<List<Map<String, dynamic>>> getMessages(String chatRoomID) {
    return _firestore
        .collection("ChatRooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("time")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  ...doc.data(),
                  "id": doc.id // Optional: Include the document ID if needed
                })
            .toList());
  }

  Future<void> sendMessage(
      String chatRoomID, String message, String userRole) async {
    if (message.isEmpty) return;

    Message newMessage = Message(
        senderId: _auth.currentUser!.uid, text: message, time: Timestamp.now());

    await _firestore
        .collection("ChatRooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap);

    // Update the chat room's main document with the latest message info
    await _firestore.collection("ChatRooms").doc(chatRoomID).update({
      "lastMessageTimestamp": Timestamp.now(),
      "hasUnReadMessage": userRole == "personnel"
          ? {"personnel": false, "user": true}
          : {"personnel": true, "user": false},
    });
  }

  Future<bool> checkDepartmentActive(String departmentUID) async {
    // Get activeTime from Firestore
    QuerySnapshot snapshot = await _firestore
        .collection("Users")
        .where("uid", isEqualTo: departmentUID)
        .get();

    if (snapshot.docs.isEmpty) {
      return false; // If no document found, assume not active
    }

    Map<String, dynamic> departmentData =
        snapshot.docs.first.data() as Map<String, dynamic>;
    Map<String, dynamic>? activeTime = departmentData["activeTime"];

    // Ensure activeTime is not null
    if (activeTime == null ||
        activeTime["timeStart"] == null ||
        activeTime["timeEnd"] == null) {
      return false;
    }

    // Parse timeStart and timeEnd
    String timeStartStr = activeTime["timeStart"];
    String timeEndStr = activeTime["timeEnd"];

    DateTime now = DateTime.now();

    // Parse the start and end times
    DateTime startTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeStartStr.split(":")[0]),
        int.parse(timeStartStr.split(":")[1]));
    DateTime endTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeEndStr.split(":")[0]),
        int.parse(timeEndStr.split(":")[1]));

    // Check if the current time is within the active period
    return now.isAfter(startTime) && now.isBefore(endTime);
  }
}
