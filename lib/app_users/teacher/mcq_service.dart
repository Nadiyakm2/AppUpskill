import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upskill_app/app_users/students/mcq_model.dart';

class MCQService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<MCQ>> fetchMCQs(String category, String difficulty) async {
    final response = await supabase
        .from('mcq_questions')
        .select()
        .eq('category', category)
        .eq('difficulty', difficulty);

    if (response.isEmpty) return [];

    return response.map((q) => MCQ.fromMap(q)).toList();
  }
}
