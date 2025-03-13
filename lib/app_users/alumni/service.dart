import 'package:supabase_flutter/supabase_flutter.dart';

class AlumniService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch all alumni
  Future<List<Map<String, dynamic>>> fetchAlumni() async {
    final response = await _supabase.from('alumni').select();
    if (response.isNotEmpty) {
      return List<Map<String, dynamic>>.from(response);
    }
    return [];
  }

  // Fetch a single alumni by ID
  Future<Map<String, dynamic>?> getAlumniById(String id) async {
    final response = await _supabase
        .from('alumni')
        .select()
        .eq('id', id)
        .single();

    return response;
  }

  // Add a new alumni
  Future<void> addAlumni(String name, String company, String position, String email) async {
    await _supabase.from('alumni').insert({
      'name': name,
      'company': company,
      'position': position,
      'email': email,
    });
  }

  // Update alumni details
  Future<void> updateAlumni(String id, Map<String, dynamic> data) async {
    await _supabase.from('alumni').update(data).eq('id', id);
  }

  // Delete alumni
  Future<void> deleteAlumni(String id) async {
    await _supabase.from('alumni').delete().eq('id', id);
  }
}
