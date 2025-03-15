import 'package:flutter/material.dart';
import 'package:workout/pages/workout_list_page.dart';

class WorkoutRecordPage extends StatefulWidget {
  final DateTime initialDate;

  WorkoutRecordPage({Key? key, required this.initialDate}) : super(key: key);

  @override
  _WorkoutRecordPageState createState() => _WorkoutRecordPageState();
}

class _WorkoutRecordPageState extends State<WorkoutRecordPage> {
  late DateTime selectedDate;
  TimeOfDay selectedTime = TimeOfDay.now();

  String selectedCategory = "헬스";

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // DB로 수정해야함
  void _saveWorkoutRecord() {
    // 저장할 데이터
    final workoutData = {
      "date": "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
      "time": selectedTime.format(context),
      "category": selectedCategory,
    };

    // 예제: 현재는 콘솔에 출력, 이후 DB 저장으로 변경 가능
    print("운동 기록 저장: $workoutData");

    // 저장 후 메시지 표시 (Flutter SnackBar)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("운동 기록이 저장되었습니다."),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Color(0xFF1C1C1E),
        title: Text('운동 기록', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton("헬스"),
                _buildCategoryButton("홈트"),
                
              ],
            ),
            SizedBox(height: 24),

            // 날짜 및 시간 선택 위젯
            _buildDateTimePicker("날짜 및 시간", selectedDate, selectedTime),

            SizedBox(height: 24),

            // 운동한 시간 입력 필드
            _buildDurationPicker(),

            SizedBox(height: 18),

            Divider(
              color: Colors.grey, // 구분선 색상
              thickness: 1.0, // 구분선 두께
              indent: 12.0, // 시작 지점 여백
              endIndent: 12.0, // 끝 지점 여백
            ),

            SizedBox(height: 18),

            // 상세 기록 입력 필드
            _buildDetailInput(),

            Spacer(), // 남은 공간을 채워서 버튼이 아래에 오도록 설정

            // 🚀 저장하기 버튼 추가
            SizedBox(
              width: double.infinity, // 전체 너비 차지
              child: ElevatedButton(
                onPressed: _saveWorkoutRecord, // 저장 함수 호출
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent, // 버튼 색상
                  padding: EdgeInsets.symmetric(vertical: 14.0), // 패딩 추가
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // 둥근 모서리
                  ),
                ),
                child: Text(
                  "저장하기",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16), // 버튼과 하단 간격 추가
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String label) {
    bool isSelected = selectedCategory == label; // 현재 선택 상태 확인
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label; // 선택된 카테고리 업데이트
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.greenAccent.withOpacity(0.2) : Colors.transparent, // 선택된 경우 배경색 적용
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.greenAccent : Colors.white, // 선택된 경우 글자 색상 변경
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(String label, DateTime date, TimeOfDay time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        GestureDetector(
          onTap: () async {
            await _selectDate(context);
            await _selectTime(context);
          },
          child: Container(
            width: 206, // 컨테이너 너비 조정
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 4), // 줄 간격 추가
                Text(
                  time.format(context),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "운동한 시간",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        Row(
          children: [
            // 시 박스
            Container(
              width: 60,
              padding: EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "0",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
            // 시와 분 사이 구분자
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(":",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            // 분 박스
            Container(
              width: 60,
              padding: EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "0",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
            // 분과 초 사이 구분자
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(":",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            // 초 박스
            Container(
              width: 60,
              padding: EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "0",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "상세 기록 (선택)",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text("운동 보기", style: TextStyle(color: Colors.greenAccent)),
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) => WorkoutListPage())
                  );
                },             
              ),
              Icon(Icons.add, color: Colors.greenAccent),
            ],
          ),
        ),
      ],
    );
  }
}
