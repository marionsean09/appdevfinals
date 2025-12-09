import 'package:haha/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _db = FirestoreService();
  User? _user;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _db.getUserProfile(_user!.uid).then((doc) {
        setState(() => _profileData = doc.data() as Map<String, dynamic>?);
      });
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            if (_profileData != null)
              ProfileCard(
                name: _profileData!['name'] ?? 'No name',
                email: _profileData!['email'] ?? '',
                avatarUrl: _profileData!['avatarUrl'] ?? '',
              )
            else
              CircularProgressIndicator(),
            SizedBox(height: 12),
            Expanded(
              child: StreamBuilder(
                stream: _db.getAnnouncementsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('No announcements'));
                  }

                  final docs = (snapshot.data as dynamic).docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text(data['title'] ?? 'Untitled'),
                          subtitle: Text(data['body'] ?? ''),
                          trailing: Text(
                            (data['createdAt'] != null)
                                ? (data['createdAt']
                                        .toDate()
                                        .toString()
                                        .split(' ')
                                        .first)
                                : '',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}