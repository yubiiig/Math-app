import 'package:flutter/material.dart';

class StackedFractionInput extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String initialValue;

  const StackedFractionInput({
    Key? key,
    required this.onChanged,
    this.initialValue = '',
  }) : super(key: key);

  @override
  State<StackedFractionInput> createState() => _StackedFractionInputState();
}

class _StackedFractionInputState extends State<StackedFractionInput> {
  late TextEditingController _numController;
  late TextEditingController _denController;
  late TextEditingController _singleController;
  bool _isFractionMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue.contains('/')) {
      final parts = widget.initialValue.split('/');
      _numController = TextEditingController(text: parts[0]);
      _denController = TextEditingController(text: parts.length > 1 ? parts[1] : '');
      _singleController = TextEditingController();
      _isFractionMode = true;
    } else {
      _numController = TextEditingController();
      _denController = TextEditingController();
      _singleController = TextEditingController(text: widget.initialValue);
      _isFractionMode = false;
    }

    _numController.addListener(_notifyValue);
    _denController.addListener(_notifyValue);
    _singleController.addListener(_notifyValue);
  }

  void _notifyValue() {
    if (_isFractionMode) {
      final num = _numController.text.trim();
      final den = _denController.text.trim();
      widget.onChanged(den.isNotEmpty ? '$num/$den' : num);
    } else {
      widget.onChanged(_singleController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text("일반 입력"),
              selected: !_isFractionMode,
              onSelected: (val) {
                setState(() {
                  _isFractionMode = false;
                  _notifyValue();
                });
              },
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text("분수 버튼 (½)"),
              selected: _isFractionMode,
              onSelected: (val) {
                setState(() {
                  _isFractionMode = true;
                  _notifyValue();
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        _isFractionMode ? _buildStackedFraction() : _buildSingleInput(),
      ],
    );
  }

  Widget _buildStackedFraction() {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8B5A2B), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _numController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              isDense: true,
              hintText: "분자",
              border: InputBorder.none,
            ),
          ),
          const Divider(color: Colors.black87, thickness: 3, height: 8),
          TextField(
            controller: _denController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              isDense: true,
              hintText: "분모",
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleInput() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: _singleController,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: "정답 입력",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8B5A2B), width: 2),
          ),
        ),
      ),
    );
  }
}
