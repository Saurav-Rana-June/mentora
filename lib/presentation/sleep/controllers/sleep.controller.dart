import 'package:get/get.dart';

class SleepController extends GetxController {
  final selectedTabIndex = 0.obs;

  final tabs = ["Sounds", "Music", "Stories"];

  RxInt selectedIndexCategory = 0.obs;

  RxInt selectedSoundIndex = (-1).obs;

  RxList<String> categories = <String>[
    'All',
    'Popular',
    'Nature',
    'Traffic',
    'Animals',
    'Household',
    'Music',
  ].obs;

  RxList<CalmMusic> calmMusics = <CalmMusic>[
    CalmMusic(
      title: "Peaceful Piano & Soft Rain",
      duration: "3 mins read",
      imageUrl: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
    ),
    CalmMusic(
      title: "Deep Sleep Meditation Music",
      duration: "5 mins read",
      imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
    ),
    CalmMusic(
      title: "Relaxing Nature Sounds",
      duration: "4 mins read",
      imageUrl: "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
    ),
    CalmMusic(
      title: "Ocean Waves & Soft Breeze",
      duration: "6 mins read",
      imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
    ),
    CalmMusic(
      title: "Forest Ambience for Focus",
      duration: "7 mins read",
      imageUrl: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e",
    ),
    CalmMusic(
      title: "Healing Tibetan Bowls",
      duration: "8 mins read",
      imageUrl: "https://images.unsplash.com/photo-1506126613408-eca07ce68773",
    ),
    CalmMusic(
      title: "Soft Guitar Evening Calm",
      duration: "5 mins read",
      imageUrl: "https://images.unsplash.com/photo-1511379938547-c1f69419868d",
    ),
    CalmMusic(
      title: "Morning Mindfulness Bells",
      duration: "4 mins read",
      imageUrl: "https://images.unsplash.com/photo-1500534314209-a26db0f5d74a",
    ),
    CalmMusic(
      title: "Rainy Night for Deep Sleep",
      duration: "9 mins read",
      imageUrl: "https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d",
    ),
    CalmMusic(
      title: "Zen Garden Meditation",
      duration: "6 mins read",
      imageUrl: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
    ),
    CalmMusic(
      title: "Soft Flute Serenity",
      duration: "5 mins read",
      imageUrl: "https://images.unsplash.com/photo-1500534314209-a26db0f5d74a",
    ),
    CalmMusic(
      title: "Night Sky Ambient Tones",
      duration: "7 mins read",
      imageUrl: "https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3",
    ),
    CalmMusic(
      title: "Deep Focus Background Calm",
      duration: "10 mins read",
      imageUrl: "https://images.unsplash.com/photo-1506126613408-eca07ce68773",
    ),
    CalmMusic(
      title: "Water Stream Relaxation",
      duration: "6 mins read",
      imageUrl: "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
    ),
    CalmMusic(
      title: "Evening Wind Chimes",
      duration: "4 mins read",
      imageUrl: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
    ),
  ].obs;

  RxList<Story> stories = <Story>[
    Story(
      title: "A Quiet Morning by the Lake",
      duration: "4 mins read",
      imageUrl: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
    ),
    Story(
      title: "The Night the Stars Spoke",
      duration: "6 mins read",
      imageUrl: "https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3",
    ),
    Story(
      title: "Whispers of the Forest",
      duration: "5 mins read",
      imageUrl: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e",
    ),
    Story(
      title: "Rain on the Old Window",
      duration: "7 mins read",
      imageUrl: "https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d",
    ),
    Story(
      title: "The Calm Between Waves",
      duration: "5 mins read",
      imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
    ),
    Story(
      title: "A Letter Never Sent",
      duration: "6 mins read",
      imageUrl: "https://images.unsplash.com/photo-1500534314209-a26db0f5d74a",
    ),
    Story(
      title: "Lanterns in the Evening Wind",
      duration: "4 mins read",
      imageUrl: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
    ),
    Story(
      title: "The Sound of Falling Leaves",
      duration: "5 mins read",
      imageUrl: "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
    ),
    Story(
      title: "Under the Quiet Moon",
      duration: "6 mins read",
      imageUrl: "https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3",
    ),
    Story(
      title: "The Path Home",
      duration: "7 mins read",
      imageUrl: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e",
    ),
    Story(
      title: "Moments Between Heartbeats",
      duration: "5 mins read",
      imageUrl: "https://images.unsplash.com/photo-1506126613408-eca07ce68773",
    ),
    Story(
      title: "When the Rain Finally Stopped",
      duration: "6 mins read",
      imageUrl: "https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d",
    ),
    Story(
      title: "A Soft Goodbye",
      duration: "4 mins read",
      imageUrl: "https://images.unsplash.com/photo-1500534314209-a26db0f5d74a",
    ),
    Story(
      title: "Echoes in the Valley",
      duration: "7 mins read",
      imageUrl: "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
    ),
    Story(
      title: "The Light After Dusk",
      duration: "5 mins read",
      imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
    ),
  ].obs;

  final List<Sound> sounds = [
    Sound(emoji: "🌧️", title: "Rainy Mood"),
    Sound(emoji: "🔥", title: "Fireplace"),
    Sound(emoji: "🌊", title: "Ocean Waves"),
    Sound(emoji: "🌲", title: "Forest"),
    Sound(emoji: "⛈️", title: "Thunder"),
    Sound(emoji: "❄️", title: "Snowfall"),

    Sound(emoji: "🌬️", title: "Wind Breeze"),
    Sound(emoji: "☀️", title: "Sunny Day"),
    Sound(emoji: "🌙", title: "Night Ambience"),
    Sound(emoji: "🐦", title: "Birds Chirping"),
    Sound(emoji: "🦗", title: "Crickets"),
    Sound(emoji: "🌾", title: "Countryside"),

    Sound(emoji: "💧", title: "Water Drops"),
    Sound(emoji: "🚿", title: "Shower Rain"),
    Sound(emoji: "🏞️", title: "Mountain Air"),
    Sound(emoji: "🌋", title: "Volcano Rumble"),
    Sound(emoji: "🕯️", title: "Candle Crackle"),
    Sound(emoji: "🎐", title: "Wind Chimes"),

    Sound(emoji: "🚂", title: "Train Ride"),
    Sound(emoji: "🌌", title: "Deep Space"),
    Sound(emoji: "🌆", title: "City Night"),
    Sound(emoji: "🏕️", title: "Campfire Night"),
  ];
}

class Sound {
  final String emoji;
  final String title;

  Sound({required this.emoji, required this.title});
}

class CalmMusic {
  final String title;
  final String duration;
  final String imageUrl;

  CalmMusic({
    required this.title,
    required this.duration,
    required this.imageUrl,
  });
}

class Story {
  final String title;
  final String duration;
  final String imageUrl;

  const Story({
    required this.title,
    required this.duration,
    required this.imageUrl,
  });
}
