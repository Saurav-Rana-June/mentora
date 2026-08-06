class MeditationSession {
  final String id;
  final String title;
  final String category;
  final String duration;
  final String imageUrl;
  final bool isFeatured;
  final String description;
  final String soundTrack;

  const MeditationSession({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.imageUrl,
    required this.isFeatured,
    this.description = "Take a deep breath and let go of external distractions. Find a comfortable position and focus on the flow of your breath. Let this guided meditation restore your inner balance and clarity.",
    this.soundTrack = "https://soundcloud.com/meditation-music/cadunia",
  });

  factory MeditationSession.fromJson(Map<String, dynamic> json) {
    return MeditationSession(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      isFeatured: json['isFeatured'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      soundTrack: json['soundTrack'] as String? ?? 'https://soundcloud.com/meditation-music/cadunia',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'duration': duration,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
      'description': description,
      'soundTrack': soundTrack,
    };
  }
}

const List<MeditationSession> mockMeditationSessions = [
  MeditationSession(
    id: '1',
    title: 'Morning Clarity & Focus',
    category: 'Focus',
    duration: '10 min',
    imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=600',
    isFeatured: true,
    description: 'Start your morning with a clear mind and sharp attention. This session will ground your awareness and help you approach your day with purpose and calm alignment.',
    soundTrack: 'https://soundcloud.com/meditation-music/cadunia',
  ),
  MeditationSession(
    id: '2',
    title: 'Deep Restful Sleep Wind Down',
    category: 'Sleep',
    duration: '25 min',
    imageUrl: 'https://images.unsplash.com/photo-1511295742364-92767fa62d9f?q=80&w=600',
    isFeatured: true,
    description: 'Transition smoothly into a deep, healing sleep. Soft breathing patterns and gentle body scans will release muscle tension and calm your racing thoughts.',
    soundTrack: 'https://soundcloud.com/meditation-music/sets/the-meditation-collection',
  ),
  MeditationSession(
    id: '3',
    title: 'Calming the Storm Within',
    category: 'Stress Relief',
    duration: '15 min',
    imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=600',
    isFeatured: true,
    description: 'Release accumulated stress and anxiety. Learn powerful grounding techniques to stabilize your mind and reclaim peace in moments of turbulence.',
    soundTrack: 'https://soundcloud.com/meditation-music/relaxation',
  ),
  MeditationSession(
    id: '4',
    title: 'Release Performance Anxiety',
    category: 'Anxiety',
    duration: '12 min',
    imageUrl: 'https://images.unsplash.com/photo-1508672019048-805c876b67e2?q=80&w=600',
    isFeatured: false,
  ),
  MeditationSession(
    id: '5',
    title: 'Mindful Forest Walking',
    category: 'Focus',
    duration: '15 min',
    imageUrl: 'https://images.unsplash.com/photo-1470246973918-29a93221c455?q=80&w=600',
    isFeatured: false,
  ),
  MeditationSession(
    id: '6',
    title: 'Self-Love & Breathing Exercises',
    category: 'Self-Esteem',
    duration: '8 min',
    imageUrl: 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=600',
    isFeatured: false,
  ),
  MeditationSession(
    id: '7',
    title: 'Loving-Kindness Meditation',
    category: 'Kindness',
    duration: '20 min',
    imageUrl: 'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?q=80&w=600',
    isFeatured: false,
  ),
  MeditationSession(
    id: '8',
    title: 'Attitude of Daily Gratitude',
    category: 'Gratitude',
    duration: '10 min',
    imageUrl: 'https://images.unsplash.com/photo-1472653425572-cf5b2c73f475?q=80&w=600',
    isFeatured: false,
  ),
  MeditationSession(
    id: '9',
    title: 'Cooling the Heat of Anger',
    category: 'Anger',
    duration: '7 min',
    imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=600',
    isFeatured: false,
  ),
  MeditationSession(
    id: '10',
    title: 'Healing Through Quiet Grief',
    category: 'Grief',
    duration: '18 min',
    imageUrl: 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?q=80&w=600',
    isFeatured: false,
  ),
];
