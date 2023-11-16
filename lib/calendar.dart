import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? selectedDay;
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final defaultBoxDeco = BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
    );

    final defaultTextStyle = TextStyle(
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      // 언어를 한글로 설정 (포스팅 아래 내용 확인 -> intl 라이브러리 )

      // 포커싱 날짜 (오늘 날짜를 기준으로 함)
      focusedDay: focusedDay,
      // 최소 년도
      firstDay: DateTime(1800),
      // 최대 년도
      lastDay: DateTime(3000),
      headerStyle: HeaderStyle(
        // default로 설정 돼 있는 2 weeks 버튼을 없애줌 (아마 2주단위로 보기 버튼인듯?)
        formatButtonVisible: false,
        // 달력 타이틀을 센터로
        titleCentered: true,
        // 말 그대로 타이틀 텍스트 스타일링
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
      calendarStyle: CalendarStyle(
          // 오늘 날짜에 하이라이팅의 유무
          isTodayHighlighted: false,
          // 캘린더의 평일 배경 스타일링(default면 평일을 의미)
          defaultDecoration: defaultBoxDeco,
          // 캘린더의 주말 배경 스타일링
          weekendDecoration: defaultBoxDeco,
          // 선택한 날짜 배경 스타일링
          selectedDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          // 기본 값이 BoxShape.circle로 돼 있는데 우리는 rectangle로 해 줄 예정
          // 만약 여기 설정을 해주지 않는다면 기본 설정인 circle과 우리의 설정인 rectangle이 겹쳐서 에러가 발생

          // 텍스트 스타일링들
          defaultTextStyle: defaultTextStyle,
          weekendTextStyle: defaultTextStyle,
          selectedTextStyle: defaultTextStyle.copyWith(color: Colors.black)),
      // 원하는 날짜 클릭 시 이벤트
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        // 클릭 할 때 state를 변경
        setState(() {
          this.selectedDay = selectedDay;
          // 우리가 달력 내에서 전 달 날짜를 클릭 할 때 옮겨주도록 state를 변경시켜 줌
          this.focusedDay = selectedDay;
        });
      },

      // selectedDayPredicate를 통해 해당 날짜가 맞는지 비교 후 true false 비교 후 반환해 줌
      selectedDayPredicate: (DateTime date) {
        if (selectedDay == null) {
          return false;
        }

        return date.year == selectedDay!.year &&
            date.month == selectedDay!.month &&
            date.day == selectedDay!.day;
      },
    );
  }
}
