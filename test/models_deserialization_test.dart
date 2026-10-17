import 'package:flutter_test/flutter_test.dart';
import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/data/model/user.model.dart';
import 'package:Mentora/data/model/speciality.model.dart';
import 'package:Mentora/data/model/booked_session.model.dart';

void main() {
  group('Model Deserialization & Serialization Tests', () {
    test('UserModel fromJson and toJson roundtrip', () {
      final json = {
        'id': 42,
        'email': 'patient@mentora.com',
        'createdAt': '2026-10-17T09:00:00.000Z',
        'updatedAt': '2026-10-17T09:00:00.000Z',
      };

      final user = UserModel.fromJson(json);
      expect(user.id, equals(42));
      expect(user.email, equals('patient@mentora.com'));

      final serialized = user.toJson();
      expect(serialized['id'], equals(42));
      expect(serialized['email'], equals('patient@mentora.com'));
    });

    test('Expert model parsing with clinical credentials and telehealth availability', () {
      final json = {
        'id': 1,
        'name': 'Dr. Marcus Vance',
        'speciality': 'Clinical Psychologist',
        'image': 'https://example.com/dr_vance.jpg',
        'callFeature': true,
        'videoCallFeature': true,
        'rating': 4.9,
        'reviewsCount': 120,
        'experienceYears': 8,
        'patientsCount': 500,
        'bio': 'Specialized clinical psychologist.',
        'startingPricePerHour': 85.0,
        'specialties': ['Anxiety', 'CBT', 'Mindfulness'],
        'isAvailable': true,
        'degree': 'Ph.D. in Clinical Psychology',
        'university': 'Columbia University',
        'graduationYear': 2016,
        'licenseNumber': 'PSY-NY-984210',
        'certifications': ['APA Certified'],
        'languages': ['English', 'Spanish'],
        'availableDays': ['Monday', 'Tuesday', 'Wednesday'],
        'workingHoursStart': '09:00 AM',
        'workingHoursEnd': '05:00 PM',
        'availableShifts': ['Morning', 'Afternoon'],
        'sessionDurations': [30, 45, 60],
      };

      final expert = Expert.fromJson(json);
      expect(expert.id, equals(1));
      expect(expert.name, equals('Dr. Marcus Vance'));
      expect(expert.speciality, equals('Clinical Psychologist'));
      expect(expert.degree, equals('Ph.D. in Clinical Psychology'));
      expect(expert.university, equals('Columbia University'));
      expect(expert.graduationYear, equals(2016));
      expect(expert.licenseNumber, equals('PSY-NY-984210'));
      expect(expert.languages, containsAll(['English', 'Spanish']));
      expect(expert.availableDays, contains('Monday'));
      expect(expert.sessionDurations, equals([30, 45, 60]));
      expect(expert.isAvailable, isTrue);
    });

    test('Speciality model parsing', () {
      final json = {
        'id': 5,
        'name': 'Cognitive Behavioral Therapy',
        'description': 'Targeting negative thought patterns.',
        'icon': 'psychology',
        'isActive': true,
      };

      final spec = Speciality.fromJson(json);
      expect(spec.id, equals(5));
      expect(spec.name, equals('Cognitive Behavioral Therapy'));
      expect(spec.icon, equals('psychology'));
      expect(spec.isActive, isTrue);
    });

    test('BookedSessionModel parsing', () {
      final json = {
        'id': 101,
        'userId': 42,
        'doctorId': 1,
        'bookingDate': '2026-10-25',
        'bookingTimeslot': '10:00 AM',
        'timeSlotType': 'Morning',
        'modalityType': 'Video Consultation',
        'duration': 45,
        'status': 'confirmed',
        'doctorName': 'Dr. Marcus Vance',
        'doctorSpeciality': 'Clinical Psychologist',
      };

      final session = BookedSession.fromJson(json);
      expect(session.id, equals(101));
      expect(session.doctorId, equals(1));
      expect(session.bookingDate, equals('2026-10-25'));
      expect(session.bookingTimeslot, equals('10:00 AM'));
      expect(session.modalityType, equals('Video Consultation'));
      expect(session.duration, equals(45));
    });
  });
}
