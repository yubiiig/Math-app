import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../widgets/stacked_fraction_input.dart';
import '../services/app_backend.dart';

class StudentView extends StatefulWidget {
  const StudentView({Key? key}) : super(key: key);

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final AppBackend _backend = AppBackend();

  Room? _currentRoom;
  Assignment? _currentAssignment;
  final Map<String, String> _answers = {};

  void _joinRoom() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    final room = await _backend.getRoomByInviteCode(code);
    if (room != null) {
      setState(() {
        _currentRoom = room;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('존재하지 않는 입장 코드입니다.')),
      );
    }
  }

  void _submit() async {
    if (_currentAssignment == null || _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름을 입력해주세요.')),
      );
      return;
    }

    final submission = Submission(
      submissionId: DateTime.now().millisecondsSinceEpoch.toString(),
      assignmentId: _currentAssignment!.assignmentId,
      deviceId: 'student_device',
      nickname: _nameController.text.trim(),
      answers: _answers,
      submittedAt: DateTime.now(),
      score: 0,
      status: 'submitted',
    );

    await _backend.submitAnswer(submission);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('답안 제출이 완료되었습니다!')),
    );
    setState(() {
      _currentAssignment = null;
      _answers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentRoom == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('학생 - 방 참여')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: '초대 코드 6자리 입력',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _joinRoom,
                child: const Text('입장하기'),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentAssignment == null) {
      return Scaffold(
        appBar: AppBar(title: Text(_currentRoom!.displayName)),
        body: StreamBuilder<List<Assignment>>(
          stream: _backend.getAssignments(_currentRoom!.roomId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final assignments = snapshot.data!;
            if (assignments.isEmpty) {
              return const Center(child: Text('등록된 과제가 없습니다.'));
            }
            return ListView.builder(
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final item = assignments[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    setState(() {
                      _currentAssignment = item;
                    });
                  },
                );
              },
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_currentAssignment!.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름 (닉네임)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ..._currentAssignment!.questions.map((q) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      StackedFractionInput(
                        onChanged: (val) {
                          _answers[q.questionId] = val;
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('제출하기', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
