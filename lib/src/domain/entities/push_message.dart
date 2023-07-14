class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final DateTime sentDate;

  PushMessage({
    required this.messageId, 
    required this.title, 
    required this.body, 
    required this.sentDate,
    this.data,
    this.imageUrl, 
  });


  @override
  String toString() {
    return '''
      PushMessage:, 
        messageId: $messageId 
        title: $title
        body: $body
        data: $data 
        imageUrl: $imageUrl 
        sentDate: $sentDate)
    ''';
  }


  factory PushMessage.fromJson(Map<String, dynamic> json) {
    return PushMessage(
      messageId: json['messageId'],
      title: json['title'],
      body: json['body'],
      data: json['data'],
      imageUrl: json['imageUrl'],
      sentDate: DateTime.parse(json['sentDate'])
    );
  }
}