// class Client {
//   final String name;
//   final String email;
//   final String phone;
//   final String imageUrl;
//   final List<String> properties;
//   final List<Map<String, String>> activeStaff;
//   final List<Map<String, String>> recentRequests;
//   final List<Map<String, String>> chatHistory;

//   Client({
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.imageUrl,
//     required this.properties,
//     required this.activeStaff,
//     required this.recentRequests,
//     required this.chatHistory,
//   });
class Client {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final int properties;
  final String lastInteraction;

  Client({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.properties,
    required this.lastInteraction,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'properties': properties,
      'lastInteraction': lastInteraction,
 
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) => Client(
        id: map['id'],
        name: map['name'],
        phone: map['phone'],
        email: map['email'],
        properties: map['properties'],
        lastInteraction: map['lastInteraction'], 
      );
}




