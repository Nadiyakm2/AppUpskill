import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CertificateVerificationPage extends StatefulWidget {
  @override
  _CertificateVerificationPageState createState() =>
      _CertificateVerificationPageState();
}

class _CertificateVerificationPageState
    extends State<CertificateVerificationPage> {
  Future<List<Map<String, dynamic>>> fetchCertificates() async {
    final response = await Supabase.instance.client.from('certificates').select();

    return response as List<Map<String, dynamic>>;
  }

  Future<void> approveCertificate(int id) async {
    await Supabase.instance.client
        .from('certificates')
        .update({'status': 'Approved'})
        .eq('id', id);
    
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate Verification'),
        backgroundColor: Color(0xFFE6E6FA),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCertificates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No certificates available.'));
          } else {
            final certificates = snapshot.data!;
            return ListView.builder(
              itemCount: certificates.length,
              itemBuilder: (context, index) {
                final certificate = certificates[index];
                return Card(
                  color: Color(0xFFFFCCCB),
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Certificate ID: ${certificate['id']}'),
                    subtitle: Text('Status: ${certificate['status']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        approveCertificate(certificate['id']);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
