import 'package:Mentora/presentation/chatAI/controllers/chat_a_i.controller.dart';
import 'package:get/get.dart';

class ChatExpertsController extends GetxController {
  final RxList<MessageModel> messages = <MessageModel>[
    MessageModel(
      message: "Hi 👋 I’m Mentora. I’m here to listen and support you.",
      isMe: false,
    ),
    MessageModel(message: "Hi… I’m not really sure how to start.", isMe: true),
    MessageModel(
      message:
          "That’s completely okay. Take your time — there’s no pressure here.",
      isMe: false,
    ),
    MessageModel(message: "I’ve been feeling overwhelmed lately.", isMe: true),
    MessageModel(
      message:
          "Thank you for sharing that. Feeling overwhelmed can be really heavy. What’s been weighing on you the most?",
      isMe: false,
    ),
    MessageModel(
      message: "Work and personal things… it all feels like too much.",
      isMe: true,
    ),
    MessageModel(
      message:
          "That sounds exhausting. When everything piles up at once, it can feel impossible to breathe. You’re not alone in this.",
      isMe: false,
    ),
    MessageModel(message: "I just want to feel calm again.", isMe: true),
    MessageModel(
      message:
          "Wanting peace is very human 💙 We can take this one small step at a time. Would you like to talk more, or try a short calming exercise together?",
      isMe: false,
    ),
  ].obs;

  final List<Expert> expertsList = [
    Expert(
      image: 'https://randomuser.me/api/portraits/men/32.jpg',
      name: 'Dr. William Butcher',
      speciality: 'Clinical Psychologist',
      callFeature: true,
      videoCallFeature: true,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/women/44.jpg',
      name: 'Dr. Emily Carter',
      speciality: 'Family Therapist',
      callFeature: true,
      videoCallFeature: false,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/men/76.jpg',
      name: 'Dr. Michael Reed',
      speciality: 'Behavioral Specialist',
      callFeature: false,
      videoCallFeature: true,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/women/68.jpg',
      name: 'Dr. Sophia Turner',
      speciality: 'Child Psychologist',
      callFeature: true,
      videoCallFeature: true,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/men/15.jpg',
      name: 'Dr. James Anderson',
      speciality: 'Mental Health Coach',
      callFeature: true,
      videoCallFeature: false,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/women/12.jpg',
      name: 'Dr. Olivia Harris',
      speciality: 'Stress Management',
      callFeature: false,
      videoCallFeature: true,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/men/45.jpg',
      name: 'Dr. Daniel Lewis',
      speciality: 'Cognitive Therapist',
      callFeature: true,
      videoCallFeature: true,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/women/25.jpg',
      name: 'Dr. Isabella Moore',
      speciality: 'Relationship Counselor',
      callFeature: true,
      videoCallFeature: true,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/men/90.jpg',
      name: 'Dr. Ethan Walker',
      speciality: 'Anxiety Specialist',
      callFeature: false,
      videoCallFeature: true,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/women/33.jpg',
      name: 'Dr. Ava Martinez',
      speciality: 'Trauma Therapist',
      callFeature: true,
      videoCallFeature: false,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/men/60.jpg',
      name: 'Dr. Noah Thompson',
      speciality: 'Mindfulness Coach',
      callFeature: true,
      videoCallFeature: true,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/women/77.jpg',
      name: 'Dr. Mia Robinson',
      speciality: 'Emotional Wellness',
      callFeature: false,
      videoCallFeature: true,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/men/22.jpg',
      name: 'Dr. Lucas White',
      speciality: 'Sleep Therapist',
      callFeature: true,
      videoCallFeature: false,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/women/88.jpg',
      name: 'Dr. Charlotte King',
      speciality: 'Depression Specialist',
      callFeature: true,
      videoCallFeature: true,
    ),
    Expert(
      image: 'https://randomuser.me/api/portraits/men/5.jpg',
      name: 'Dr. Henry Scott',
      speciality: 'Addiction Counselor',
      callFeature: false,
      videoCallFeature: true,
    ),
  ];

  final List<Chat> chatsList = [
    Chat(
      image: 'https://randomuser.me/api/portraits/men/32.jpg',
      name: 'Dr. William Butcher',
      lastMessage: 'How have you been feeling lately?',
      time: '09:45 AM',
      unreadCount: 2,
    ),
    Chat(
      image: 'https://randomuser.me/api/portraits/women/44.jpg',
      name: 'Dr. Emily Carter',
      lastMessage: 'Let’s schedule our next session.',
      time: 'Yesterday',
      unreadCount: 0,
    ),
    Chat(
      image: 'https://randomuser.me/api/portraits/men/76.jpg',
      name: 'Dr. Michael Reed',
      lastMessage: 'Try practicing that exercise daily.',
      time: 'Mon',
      unreadCount: 1,
    ),
    Chat(
      image: 'https://randomuser.me/api/portraits/women/68.jpg',
      name: 'Dr. Sophia Turner',
      lastMessage: 'How is your child doing this week?',
      time: 'Sun',
      unreadCount: 0,
    ),
    Chat(
      image: 'https://randomuser.me/api/portraits/men/15.jpg',
      name: 'Dr. James Anderson',
      lastMessage: 'Remember to track your mood.',
      time: 'Sat',
      unreadCount: 3,
    ),
    Chat(
      image: 'https://randomuser.me/api/portraits/women/12.jpg',
      name: 'Dr. Olivia Harris',
      lastMessage: 'Breathing techniques can help.',
      time: 'Fri',
      unreadCount: 0,
    ),
  ];

  final List<Call> callsList = [
    Call(
      image: 'https://randomuser.me/api/portraits/men/32.jpg',
      name: 'Dr. William Butcher',
      callOutgoing: true,
      time: 'Today, 10:15 AM',
      callFeature: true,
      videoFeature: true,
    ),
    Call(
      image: 'https://randomuser.me/api/portraits/women/44.jpg',
      name: 'Dr. Emily Carter',
      callOutgoing: false,
      time: 'Yesterday, 6:40 PM',
      callFeature: true,
      videoFeature: false,
    ),
    Call(
      image: 'https://randomuser.me/api/portraits/men/76.jpg',
      name: 'Dr. Michael Reed',
      callOutgoing: true,
      time: 'Yesterday, 11:05 AM',
      callFeature: false,
      videoFeature: true,
    ),
    Call(
      image: 'https://randomuser.me/api/portraits/women/68.jpg',
      name: 'Dr. Sophia Turner',
      callOutgoing: false,
      time: 'Mon, 4:20 PM',
      callFeature: true,
      videoFeature: true,
    ),
    Call(
      image: 'https://randomuser.me/api/portraits/men/15.jpg',
      name: 'Dr. James Anderson',
      callOutgoing: true,
      time: 'Sun, 8:00 PM',
      callFeature: true,
      videoFeature: false,
    ),
    Call(
      image: 'https://randomuser.me/api/portraits/women/12.jpg',
      name: 'Dr. Olivia Harris',
      callOutgoing: false,
      time: 'Sat, 3:10 PM',
      callFeature: false,
      videoFeature: true,
    ),
    Call(
      image: 'https://randomuser.me/api/portraits/men/45.jpg',
      name: 'Dr. Daniel Lewis',
      callOutgoing: true,
      time: 'Fri, 9:30 AM',
      callFeature: true,
      videoFeature: true,
    ),
  ];

  RxBool isChatsSelected = true.obs;
}

class Expert {
  final String? image;
  final String? name;
  final String? speciality;
  final bool? callFeature;
  final bool? videoCallFeature;

  Expert({
    this.image,
    this.name,
    this.speciality,
    this.callFeature,
    this.videoCallFeature,
  });
}

class Chat {
  final String? image;
  final String? name;
  final String? lastMessage;
  final String? time;
  final int unreadCount;

  Chat({
    this.image,
    this.name,
    this.lastMessage,
    this.time,
    this.unreadCount = 0,
  });
}

class Call {
  final String? image;
  final String? name;
  final bool? callOutgoing;
  final String? time;
  final bool? callFeature;
  final bool? videoFeature;

  Call({
    this.image,
    this.name,
    this.callOutgoing,
    this.time,
    this.callFeature,
    this.videoFeature,
  });
}
