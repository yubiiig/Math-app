import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_backend.dart';

class TeacherView extends StatefulWidget {
  const TeacherView({Key? key}) : super(key: key);

  @override
  State<TeacherView> createState() => _TeacherViewState();
}

class _TeacherViewState extends State<TeacherView> {
  final AppBackend _backend = AppBackend();
  final _roomNameController = TextEditingController();
  final _subjectController = TextEditingController();

  void _createRoom() async {
    if (_roomNameController.text.isEmpty) return;

    final newRoom = Room(
      roomId: DateTime.now().millisecondsSinceEpoch.toString(),
      grade: 5,
      classNumber: 1,
      roomName: _roomNameController.text.trim(),
      subject: _subjectController.text.trim(),
      inviteCode: (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString(),
      teacherDeviceId: 'teacher_device',
      createdAt: DateTime.now(),
    );

    await _backend.createRoom(newRoom);
    _roomNameController.clear();
    _subjectController.clear();
    if (mounted) Navigator.pop(context);
  }

  void _showCreateRoomDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 학급 방 만들기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _roomNameController,
              decoration: const InputDecoration(labelText: '방 이름 (예: 5학년 1반 수학)'),
            ),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: '단원/주제'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: _createRoom,
            child: const Text('생성'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('선생님 - 학급 관리')),
      body: StreamBuilder<List<Room>>(
        stream: _backend.getTeacherRooms('teacher_device'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final rooms = snapshot.data!;
          if (rooms.isEmpty) {
            return const Center(child: Text('생성된 방이 없습니다. 아래 + 버튼을 눌러 만들어보세요.'));
          }
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return ListTile(
                title: Text(room.displayName),
                subtitle: Text('초대코드: ${room.inviteCode}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateRoomDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
