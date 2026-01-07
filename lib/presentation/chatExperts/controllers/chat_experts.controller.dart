import 'package:get/get.dart';

class ChatExpertsController extends GetxController {
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
