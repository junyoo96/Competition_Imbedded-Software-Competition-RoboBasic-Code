'******** 2족 보행로봇 초기 영점 프로그램 ********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER
DIM	다리걷기연속체크 AS BYTE
DIM 문시퀀스구분용체크 AS BYTE
DIM 가스밸브시퀀스구분용체크 AS BYTE
DIM 전진달리기연속체크 AS BYTE
DIM 전진달리기연속분기체크 AS BYTE

DIM 곡선방향 AS BYTE

DIM 넘어진확인 AS BYTE
DIM 기울기확인횟수 AS BYTE
DIM 보행횟수 AS BYTE
DIM 보행COUNT AS BYTE

DIM 적외선거리값  AS BYTE
DIM 적외선거리값_Old AS BYTE
''내가 추가한 적외선거리값 변수
DIM 적외선거리값_두번째 AS BYTE
DIM 적외선거리값_두번째_OLD AS BYTE
DIM 적외선거리값_세번째 AS BYTE
DIM 적외선거리값_세번째_OLD AS BYTE
DIM 적외선거리값_중간값 AS BYTE


DIM S11  AS BYTE
DIM S16  AS BYTE
'************************************************
DIM NO_0 AS BYTE
DIM NO_1 AS BYTE
DIM NO_2 AS BYTE
DIM NO_3 AS BYTE
DIM NO_4 AS BYTE

DIM NUM AS BYTE

DIM BUTTON_NO AS INTEGER
DIM SOUND_BUSY AS BYTE
DIM TEMP_INTEGER AS INTEGER

'**** 기울기센서포트 설정 ****
CONST 앞뒤기울기AD포트 = 0
CONST 좌우기울기AD포트 = 1
CONST 기울기확인시간 = 20  'ms


CONST min = 61	'뒤로넘어졌을때
CONST max = 107	'앞으로넘어졌을때
CONST COUNT_MAX = 3


CONST 머리이동속도 = 10
'************************************************
' 걸음_SHORT용 걸음기울기 조정용 변수
'************************************************
'125,103
CONST 왼발무게왼쪽무릎기울기 =125
CONST 왼발무게왼쪽허벅지기울기 =103

'140,104
CONST 왼발내딛왼쪽무릎기울기 =140
CONST 왼발내딛왼쪽허벅지기울기 =104

'120,100
CONST 오른발무게오른쪽무릎기울기 =120
CONST 오른발무게오른쪽허벅지기울기  =100

'146,105
CONST 오른발내딛오른쪽무릎기울기=146
CONST 오른발내딛오른쪽허벅지기울기 =105


DIM 걸음방향 AS BYTE
DIM 걸음연속분기체크 AS BYTE

'************************************************
PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6D,0,1,1,0,1,1		'모터18~23번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,0,1,0		'모터12~17번

'************************************************

OUT 52,0	'머리 LED 켜기
'***** 초기선언 '************************************************

보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
보행횟수 = 1
모터ONOFF = 0
문시퀀스구분용체크=0
가스밸브시퀀스구분용체크=0

걸음연속분기체크=0

'****초기위치 피드백*****************************


TEMPO 230
MUSIC "cdefg"

SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

'이십번로봇목이 약간 비뚤어져 있어서 99로 변경
'SERVO 11, 100
SERVO 11, 99
SERVO 16, S16

GOSUB 전원초기자세
GOSUB 안정화자세

'원래 주석 안되어있음
GOSUB 자이로INIT
GOSUB 자이로MID
GOSUB 자이로ON

'원래껏
GOSUB All_motor_mode3
'시험용
'GOSUB All_motor_Reset

'컴퓨터 통신용
GOTO MAIN	

'리모컨용

'GOTO 리모컨_MAIN

'************************************************

'*********************************************
' Infrared_Distance = 60 ' About 20cm
' Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************
'************************************************
시작음:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
종료음:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
에러음:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '전포트서보모터사용설정

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    모터ONOFF = 0
    GOSUB 시작음			
    RETURN

    '************************************************
    '전포트서보모터사용설정
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '************************************************
    '위치값피드백
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '위치값피드백
MOTOR_SET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2
    RETURN

    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3
    RETURN
    '************************************************
    '***********************************************
    '***********************************************
    '**** 자이로감도 설정 ****
자이로INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** 자이로감도 설정 ****
자이로MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
자이로MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
자이로MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '***********************************************
자이로ON:


    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0


    자이로ONOFF = 1

    RETURN
    '***********************************************
자이로OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    자이로ONOFF = 0
    RETURN

    '************************************************
전원초기자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '************************************************
안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
기본자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    WAIT
    mode = 0

    RETURN
    '******************************************	
기본자세2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 0

    RETURN
    '******************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '******************************************
앉은자세:
    GOSUB 자이로OFF
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 1

    RETURN
    '******************************************
가스밸브_기본자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    mode = 0
    RETURN



    '******************************************
    '**********************************************
    '**********************************************
    'RX_EXIT:
    '
    '    ERX 4800, A, MAIN
    '
    '    GOTO RX_EXIT
    '    '**********************************************
    'GOSUB_RX_EXIT:
    '
    '    ERX 4800, A, GOSUB_RX_EXIT2
    '
    '    GOTO GOSUB_RX_EXIT
    '
    'GOSUB_RX_EXIT2:
    '    RETURN
    '**********************************************


    '************************************************
    '************************************************
    '연속후진:
    '    넘어진확인 = 0
    '    보행속도 = 12
    '    좌우속도 = 4
    '    GOSUB Leg_motor_mode3
    '
    '
    '
    '    IF 보행순서 = 0 THEN
    '        보행순서 = 1
    '
    '        SPEED 4
    '        MOVE G6A, 88,  71, 152,  91, 110
    '        MOVE G6D,108,  76, 145,  93,  96
    '        MOVE G6B,100
    '        MOVE G6C,100
    '        WAIT
    '
    '        SPEED 10
    '        MOVE G6A, 90, 100, 100, 115, 110
    '        MOVE G6D,110,  76, 145,  93,  96
    '        MOVE G6B,90
    '        MOVE G6C,110
    '        WAIT
    '
    '        GOTO 연속후진_1	
    '    ELSE
    '        보행순서 = 0
    '
    '        SPEED 4
    '        MOVE G6D,  88,  71, 152,  91, 110
    '        MOVE G6A, 108,  76, 145,  93,  96
    '        MOVE G6C, 100
    '        MOVE G6B, 100
    '        WAIT
    '
    '        SPEED 10
    '        MOVE G6D, 90, 100, 100, 115, 110
    '        MOVE G6A,110,  76, 145,  93,  96
    '        MOVE G6C,90
    '        MOVE G6B,110
    '        WAIT
    '
    '
    '        GOTO 연속후진_2
    '
    '    ENDIF
    '
    '
    '연속후진_1:
    '    ETX 4800,12 '진행코드를 보냄
    '    SPEED 보행속도
    '
    '    MOVE G6D,110,  76, 145, 93,  96
    '    MOVE G6A,90, 98, 145,  69, 110
    '    WAIT
    '
    '    SPEED 좌우속도
    '    MOVE G6D, 90,  60, 137, 120, 110
    '    MOVE G6A,107,  85, 137,  93,  96
    '    WAIT
    '
    '
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '
    '    SPEED 11
    '
    '    MOVE G6D,90, 90, 120, 105, 110
    '    MOVE G6A,112,  76, 146,  93, 96
    '    MOVE G6B,110
    '    MOVE G6C,90
    '    WAIT
    '
    '    ERX 4800,A, 연속후진_2
    '    IF A <> A_old THEN
    '연속후진_1_EXIT:
    '        HIGHSPEED SETOFF
    '        SPEED 5
    '
    '        MOVE G6A, 106,  76, 145,  93,  96		
    '        MOVE G6D,  85,  72, 148,  91, 106
    '        MOVE G6B, 100
    '        MOVE G6C, 100
    '        WAIT	
    '
    '        SPEED 3
    '        GOSUB 기본자세2
    '        GOTO RX_EXIT
    '    ENDIF
    '    '**********
    '
    '연속후진_2:
    '    ETX 4800,12 '진행코드를 보냄
    '    SPEED 보행속도
    '    MOVE G6A,110,  76, 145, 93,  96
    '    MOVE G6D,90, 98, 145,  69, 110
    '    WAIT
    '
    '
    '    SPEED 좌우속도
    '    MOVE G6A, 90,  60, 137, 120, 110
    '    MOVE G6D,107  85, 137,  93,  96
    '    WAIT
    '
    '
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '
    '    SPEED 11
    '    MOVE G6A,90, 90, 120, 105, 110
    '    MOVE G6D,112,  76, 146,  93,  96
    '    MOVE G6B, 90
    '    MOVE G6C,110
    '    WAIT
    '
    '
    '    ERX 4800,A, 연속후진_1
    '    IF A <> A_old THEN
    '연속후진_2_EXIT:
    '        HIGHSPEED SETOFF
    '        SPEED 5
    '
    '        MOVE G6D, 106,  76, 145,  93,  96		
    '        MOVE G6A,  85,  72, 148,  91, 106
    '        MOVE G6B, 100
    '        MOVE G6C, 100
    '        WAIT	
    '
    '        SPEED 3
    '        GOSUB 기본자세2
    '        GOTO RX_EXIT
    '    ENDIF  	
    '
    '    GOTO 연속후진_1
    '**********************************************

    '    '******************************************
    '걷기_SHORT_시작:
    '    GOSUB All_motor_mode3
    '    '보행COUNT = 0
    '
    '    SPEED 7
    '    HIGHSPEED SETON
    '
    '    IF 보행순서 = 0 THEN
    '        '보행순서 = 1
    '        MOVE G6A,95,  76, 147,  93, 101
    '        MOVE G6D,101,  76, 147,  93, 98
    '        MOVE G6B,100
    '        MOVE G6C,100
    '        WAIT
    '
    '        'GOTO 횟수_전진종종걸음_1
    '        'ELSE
    '        '        보행순서 = 0
    '        '        MOVE G6D,95,  76, 147,  93, 101
    '        '        MOVE G6A,101,  76, 147,  93, 98
    '        '        MOVE G6B,100
    '        '        MOVE G6C,100
    '        '        WAIT
    '        '
    '        '        GOTO 횟수_전진종종걸음_4
    '    ENDIF
    '
    '    RETURN
    '
    '    '**********************
    '
    '걷기_SHORT_1:
    '
    '    MOVE G6A,95,  90, 125, 100, 104
    '    MOVE G6D,104,  77, 147,  93,  102
    '    MOVE G6B, 85
    '    MOVE G6C,115
    '    WAIT
    '
    '걷기_SHORT_2:
    '
    '    MOVE G6A,103,   73, 140, 103,  100
    '    MOVE G6D, 95,  85, 147,  85, 102
    '    WAIT
    '
    '    'GOSUB 앞뒤기울기측정
    '    '    IF 넘어진확인 = 1 THEN
    '    '        넘어진확인 = 0
    '    '
    '    '        GOTO MAIN_2
    '    '    ENDIF
    '
    '    '보행COUNT = 보행COUNT + 1
    '    '    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_전진종종걸음_2_stop
    '
    '    '    ERX 4800,A, 횟수_전진종종걸음_4
    '    '    IF A <> A_old THEN
    '    '횟수_전진종종걸음_2_stop:
    '    '
    '    '        MOVE G6D,95,  90, 125, 95, 104
    '    '        MOVE G6A,104,  76, 145,  91,  102
    '    '        MOVE G6C, 100
    '    '        MOVE G6B,100
    '    '        WAIT
    '    '        HIGHSPEED SETOFF
    '    '        SPEED 15
    '    '        GOSUB 안정화자세
    '    '        SPEED 5
    '    '        GOSUB 기본자세2
    '    '
    '    '        'DELAY 400
    '    '        GOTO RX_EXIT
    '    '    ENDIF
    '
    '    '*********************************
    '
    '걷기_SHORT_4:
    '    MOVE G6A,104,  77, 147,  93,  102
    '    MOVE G6D,95,  90, 125, 100, 104
    '    MOVE G6C, 85
    '    MOVE G6B,115
    '    WAIT
    '
    '걷기_SHORT_5:
    '    MOVE G6D,103,    73, 140, 103,  100
    '    MOVE G6A, 95,  85, 147,  85, 102
    '    WAIT
    '
    '    '넘어짐 확인
    '    'GOSUB 앞뒤기울기측정
    '    '    IF 넘어진확인 = 1 THEN
    '    '        넘어진확인 = 0
    '    '        GOTO RX_EXIT
    '    '    ENDIF
    '
    '    RETURN
    '
    '걷기_SHORT_멈춤:
    '
    '    MOVE G6A,95,  90, 125, 95, 104
    '    MOVE G6D,104,  76, 145,  91,  102
    '    MOVE G6B, 100
    '    MOVE G6C,100
    '    WAIT
    '
    '    HIGHSPEED SETOFF
    '    SPEED 5
    '    GOSUB 안정화자세
    '    RETURN
    '
    '
    '    '*************************************

    '******************************************
걷기_SHORT_시작:
    GOSUB All_motor_mode3
    '보행COUNT = 0

    SPEED 7
    HIGHSPEED SETON

    IF 보행순서 = 0 THEN
        '보행순서 = 1
        '오른쪽으로 몸 옮김

        SPEED 5
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        'GOTO 횟수_전진종종걸음_1
        'ELSE
        '        보행순서 = 0
        '        MOVE G6D,95,  76, 147,  93, 101
        '        MOVE G6A,101,  76, 147,  93, 98
        '        MOVE G6B,100
        '        MOVE G6C,100
        '        WAIT
        '
        '        GOTO 횟수_전진종종걸음_4
    ENDIF

    RETURN

    '**********************
걷기_SHORT_연속:

    SPEED 7

    'IF  걸음연속분기체크=1 THEN

걷기_SHORT_1:

    '왼발 중심이동
    MOVE G6A,95,  90, 125, 99, 104
    MOVE G6D,102,  77, 147,  92,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT

    'ENDIF

걷기_SHORT_2:

    걸음연속분기체크=1

    '직선 걸음
    IF 걸음방향=2 OR  걸음방향=1 THEN

        '왼발 내딛기
        MOVE G6A,103,   73, 140, 102,  100
        MOVE G6D, 93,  85, 147,  84, 102
        WAIT



    ELSEIF 걸음방향=3 THEN
        '오른쪽으로 작게 휘게 할 때
        'A,+4
        'D, -4
        MOVE G6A,107,   73, 140, 103,  100
        MOVE G6D, 89,  85, 147,  85, 102
        WAIT


    ELSEIF 걸음방향=4 THEN
        '왼쪽으로 크게 휘게 할 때 (잘못된거아님)

        'test
        'A,+8
        'D, -8
        MOVE G6A,111,   73, 140, 103,  100
        MOVE G6D, 93,  85, 147,  85, 102
        WAIT



    ENDIF

    'GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '
    '        GOTO MAIN_2
    '    ENDIF

    '보행COUNT = 보행COUNT + 1
    '    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_전진종종걸음_2_stop

    '    ERX 4800,A, 횟수_전진종종걸음_4
    '    IF A <> A_old THEN
    '횟수_전진종종걸음_2_stop:
    '
    '        MOVE G6D,95,  90, 125, 95, 104
    '        MOVE G6A,104,  76, 145,  91,  102
    '        MOVE G6C, 100
    '        MOVE G6B,100
    '        WAIT
    '        HIGHSPEED SETOFF
    '        SPEED 15
    '        GOSUB 안정화자세
    '        SPEED 5
    '        GOSUB 기본자세2
    '
    '        'DELAY 400
    '        GOTO RX_EXIT
    '    ENDIF

    '*********************************

걷기_SHORT_4:

    '오른쪽으로 중심이동	
    MOVE G6D,93,  93, 120, 99, 104
    MOVE G6A,104,  75, 147,  92,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT

걷기_SHORT_5:

    IF 걸음방향=2 OR 걸음방향=3 THEN

        '오른발 내딛기
        MOVE G6D,105,    73, 140, 102,  100
        MOVE G6A, 95,  85, 147,  84, 102
        WAIT

    ELSEIF 걸음방향 = 1 THEN
        '왼쪽으로 휘게 할 때
        'A, -4
        'D, +4


        MOVE G6D,109,    73, 140, 102,  100
        MOVE G6A, 89,  85, 147,  84, 102
        WAIT





    ELSEIF 걸음방향=6 THEN
        '오른쪽으로 크게 휘게 할 때 (잘못된거아님)

        'test
        'A,-8
        'D,+8
        MOVE G6D,113,   73, 140, 103,  100
        MOVE G6A, 87,  85, 147,  85, 102
        WAIT

    ENDIF

    '넘어짐 확인
    'GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF

    RETURN

걷기_SHORT_멈춤:

    걸음연속분기체크=0

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    HIGHSPEED SETOFF
    SPEED 5
    GOSUB 안정화자세
    RETURN

    '******************************************
    '******************************************
    '걷기_FAST
    '******************************************
    '******************************************
걷기_FAST_시작:

    보행COUNT=0
    HIGHSPEED SETON
    보행속도=8

    ''안정화자세
    '  MOVE G6A,98,  76, 145,  93, 101, 100
    '        MOVE G6D,98,  76, 145,  93, 101, 100
    '        MOVE G6B,100,  35,  90
    '        MOVE G6C,100,  35,  90
    '        WAIT

    SPEED 보행속도
    '왼발 앞으로
    ' MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT

    '테스트1
    MOVE G6A,98,  60, 145,  110, 101, 100
    MOVE G6D,98,  86, 145,  93, 101, 100
    WAIT

    RETURN

걷기_FAST_연속:

    SPEED 보행속도
    '오른발 앞으로

    'IF 걸음방향=2 OR 걸음방향=3 THEN

    '직진걸음( 기울게 하고 싶은 방향 발의 바깥쪽으로 발목을 해주면됨)
    MOVE G6D,98,  60, 145,  109, 101, 100
    MOVE G6A,96,  86, 145,  93, 101, 100
    WAIT

    '직진걸음(약간 왼쪽으로 가게 )
    'D,+2
    'MOVE G6D,98,  60, 145,  109, 101, 100
    '    MOVE G6A,100,  86, 145,  93, 101, 100
    '    WAIT

    ' ELSEIF 걸음방향=4 THEN
    '
    '        '직진걸음
    '        MOVE G6D,98,  60, 145,  109, 101, 100
    '        MOVE G6A,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '    ELSEIF 걸음방향=1 THEN
    '
    '        '테스트2(왼쪽으로 휘게)
    '
    '        MOVE G6D,98,  60, 145,  109, 101, 100
    '        MOVE G6A,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '        'A,
    '        'D,+4
    '        MOVE G6A,98,  86, 145,  93, 101, 100
    '        MOVE G6D,102,  60, 145,  109, 101, 100
    '        WAIT
    '
    '    ENDIF

    '--------------------------------------------

    SPEED 보행속도

    '왼발 앞으로
    'IF 걸음방향=2 OR 걸음방향=1 THEN

    '직진걸음
    MOVE G6A,98,  60, 145,  110, 101, 100
    MOVE G6D,98,  86, 145,  93, 101, 100
    WAIT	

    'ELSEIF 걸음방향=3 THEN
    '
    '        MOVE G6A,98,  60, 145,  110, 101, 100
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '        '테스트2(오른쪽으로 휘게)
    '        'A,+4
    '        'D,
    '        MOVE G6A,102,  60, 145,  110, 101, 100
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        WAIT

    'ELSEIF 걸음방향=4 THEN
    '
    '        '테스트2(왼쪽으로 휘게)
    '
    '        HIGHSPEED SETOFF
    '        SPEED 7
    '
    '        MOVE G6A,98,  60, 145,  110, 101, 100
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '        'A,+8
    '        'D,
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        MOVE G6A,106,  60, 145,  109, 101, 100
    '        WAIT
    '
    '        HIGHSPEED SETON
    '
    '    ENDIF


    RETURN

걷기_FAST_멈춤:

    SPEED 보행속도
    '오른발 앞으로
    ' MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  103, 101, 100
    '    WAIT

    '테스트1
    MOVE G6A,98,  60, 145,  110, 101, 100
    MOVE G6D,98,  76, 145,  110, 101, 100
    WAIT

    SPEED 5
    '안정화자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    HIGHSPEED SETOFF

    RETURN

    '**********************************************
걷기_FAST_시퀀스:

    GOSUB 걷기_FAST_시작
    '9
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_멈춤

    RETURN

    '**********************************************
    'CLOSE걷기_시작:
    '
    '    보행COUNT=0
    '
    '    보행속도=7
    '    ''안정화자세
    '    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90
    '    '    MOVE G6C,100,  35,  90
    '    '    WAIT
    '
    '    SPEED 보행속도
    '    '왼발 앞으로
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    GOTO CLOSE걷기_1
    '
    '    '******************************************
    '    '******************************************
    'CLOSE걷기_1:
    '
    '    SPEED 보행속도
    '    '오른발 앞으로
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  70, 145,  103, 101, 100
    '    WAIT
    '
    '    SPEED 보행속도
    '    '왼발 앞으로
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    보행COUNT = 보행COUNT + 1
    '    IF 보행COUNT > 보행횟수 THEN
    '        GOTO CLOSE걷기_멈춤
    '
    '    ELSE
    '        GOTO CLOSE걷기_1
    '
    '    ENDIF
    '
    '    RETURN
    '    '******************************************
    '    '******************************************
    'CLOSE걷기_멈춤:
    '
    '    SPEED 보행속도
    '    '오른발 앞으로
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  103, 101, 100
    '    WAIT
    '
    '    SPEED 5
    '    '안정화자세
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '
    '    RETURN
    '
    '******************************************
    '**********************************************
    '가스밸브 ATTACH에 쓸 동작
CLOSE걷기_시작:

    보행COUNT=0

    '팔올리는 자세
    MOVE G6B,60,  176,  145
    MOVE G6C,62,  180,  147

    '보행속도=7
    보행속도=9
    ''안정화자세
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,100,  35,  90
    '    WAIT

    SPEED 보행속도
    '왼발 앞으로
    MOVE G6A,98,  71, 145,  108, 101, 100
    MOVE G6D,98,  74, 145,  93, 101, 100
    WAIT

    GOTO CLOSE걷기_1

    '******************************************
    '******************************************
CLOSE걷기_1:

    SPEED 보행속도
    '오른발 앞으로
    MOVE G6A,98,  74, 145,  93, 101, 100
    MOVE G6D,98,  71, 145,  108, 101, 100
    WAIT

    SPEED 보행속도
    '왼발 앞으로
    MOVE G6A,98,  71, 145,  108, 101, 100
    MOVE G6D,98,  74, 145,  93, 101, 100
    WAIT

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN
        GOTO CLOSE걷기_멈춤

    ELSE
        GOTO CLOSE걷기_1

    ENDIF

    RETURN
    '******************************************
    '******************************************
CLOSE걷기_멈춤:

    SPEED 보행속도
    '오른발 앞으로
    MOVE G6A,98,  71, 145,  103, 101, 100
    MOVE G6D,98,  74, 145,  103, 101, 100
    WAIT

    SPEED 15
    '안정화자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN




    '******************************************
전진달리기_시작:
    넘어진확인 = 0
    전진달리기연속체크=0
    전진달리기연속분기체크=0

    GOSUB All_motor_mode3
    보행COUNT = 0
    DELAY 50

    SPEED 5
    'IF 보행순서 = 0 THEN
    '보행순서 = 1
    '오른쪽으로 살짝기울어짐
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    WAIT

    SPEED 8
    'SPEED 6
    HIGHSPEED SETON

    '시작할때 왼쪽으로 많이 기울어서 지운코드(지우지마삼 )
    '        MOVE G6A,95,  80, 120, 120, 104
    '        MOVE G6D,104,  77, 146,  91,  102
    '        MOVE G6B, 80
    '        MOVE G6C,120
    '        WAIT	
    '
    'GOTO 전진달리기50_2
    'ELSE
    '보행순서 = 0
    '        MOVE G6D,95,  76, 145,  93, 101
    '        MOVE G6A,101,  77, 145,  93, 98
    '        WAIT
    '
    '        MOVE G6D,95,  80, 120, 120, 104
    '        MOVE G6A,104,  77, 146,  91,  102
    '        MOVE G6C, 80
    '        MOVE G6B,120
    '        WAIT


    ' GOTO 전진달리기50_5
    '    ENDIF

    RETURN

    '   **********************
전진달리기_연속:

    IF 전진달리기연속분기체크=0 THEN

        IF 전진달리기연속체크=1 THEN

전진달리기50_1:

            '왼발로 무게중심 이동
            MOVE G6A,95,  95, 100, 120, 104
            MOVE G6D,104,  77, 147,  93,  102
            MOVE G6B, 80
            MOVE G6C,120
            WAIT

        ENDIF

전진달리기50_2:

        전진달리기연속체크=1

        '왼발 살짝 앞으로 보냄
        MOVE G6A,95,  75, 122, 120, 104
        MOVE G6D,106,  78, 147,  90,  100
        WAIT

전진달리기50_3:
        '왼발 앞으로(땅에닿음)
        'MOVE G6A,103,  69, 145, 103,  100
        '        MOVE G6D, 95, 87, 160,  68, 102
        '        WAIT

        '기우는방향의 발목을 안쪽으로 넣어주면 고쳐짐
        '왼발 앞으로(땅에닿음)
        MOVE G6A,100,  69, 145, 103,  100
        MOVE G6D, 97, 87, 160,  68, 102
        WAIT

        전진달리기연속분기체크=1

        RETURN

        'GOSUB 앞뒤기울기측정
        '            IF 넘어진확인 = 1 THEN
        '                넘어진확인 = 0
        '                GOTO RX_EXIT
        '            ENDIF
        '
        '        보행COUNT = 보행COUNT + 1
        '            IF 보행COUNT > 보행횟수 THEN  GOTO 전진달리기50_3_stop
        '
        '        ERX 4800,A, 전진달리기50_4
        '            IF A <> A_old THEN
전진달리기_멈춤_0:

        전진달리기연속분기체크=0

        '뒤에 있던 오른발 가져옴
        MOVE G6D,90,  93, 115, 100, 104
        MOVE G6A,104,  74, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 안정화자세


        RETURN

    ELSEIF 전진달리기연속분기체크=1 THEN
        '*********************************

전진달리기50_4:
        '오른발로 무게중심이동
        MOVE G6D,95,  95, 100, 120, 104
        MOVE G6A,104,  77, 147,  93,  102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


전진달리기50_5:
        '오른발 살짝 앞으로 보냄
        MOVE G6D,95,  75, 122, 120, 104
        MOVE G6A,104,  78, 147,  90,  100
        WAIT


전진달리기50_6:
        '오른발 앞으로(땅에닿음)
        MOVE G6D,103,  69, 145, 103,  100
        MOVE G6A, 95, 87, 160,  68, 102
        WAIT

        전진달리기연속분기체크=0

        RETURN

전진달리기_멈춤_1:

        전진달리기연속분기체크=0

        '뒤에 있던 왼발 가져오기
        MOVE G6A,90,  93, 115, 100, 104
        MOVE G6D,104,  74, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 안정화자세

        RETURN

    ENDIF


    '******************************************
    '******************************************
    '******************************************
문_달리기_시작:
    넘어진확인 = 0
    전진달리기연속체크=0
    전진달리기연속분기체크=0

    GOSUB All_motor_mode3
    보행COUNT = 0
    DELAY 50

    'SPEED 8
    SPEED 6
    HIGHSPEED SETON

    'IF 보행순서 = 0 THEN

    '팔올리고
    MOVE G6B, 185,18,90
    MOVE G6C, 185,18,90
    WAIT

    '오른팔구부리고
    MOVE G6B, 185,18,90
    MOVE G6C, 185,18,60
    WAIT

    '보행순서 = 1
    MOVE G6A,95,  75, 144,  93, 101
    MOVE G6D,101,  76, 144,  93, 98
    WAIT

    MOVE G6A,95,  79, 119, 120, 104
    MOVE G6D,104,  76, 145,  91,  102
    WAIT

    'GOTO 문_달리기50_2
    '    ELSE
    '        보행순서 = 0
    '        MOVE G6D,95,  76, 145,  93, 101
    '        MOVE G6A,101,  77, 145,  93, 98
    '        WAIT
    '
    '        MOVE G6D,95,  80, 120, 120, 104
    '        MOVE G6A,104,  77, 146,  91,  102
    '        WAIT


    'GOTO 전진달리기50_5
    'ENDIF

    RETURN

    '   **********************
문_달리기_연속:

    IF 전진달리기연속분기체크=0 THEN

        IF 전진달리기연속체크=1 THEN

문_달리기50_1:
            MOVE G6A,95,  94, 99, 120, 104
            MOVE G6D,104,  76, 146,  93,  102
            WAIT

        ENDIF

문_달리기50_2:

        전진달리기연속체크=1

        MOVE G6A,95,  74, 121, 120, 104
        MOVE G6D,104,  77, 146,  90,  100
        WAIT

문_달리기50_3:
        MOVE G6A,103,  68, 144, 103,  100
        MOVE G6D, 95, 86, 159,  68, 102
        WAIT

        전진달리기연속분기체크=1

        RETURN

        'GOSUB 앞뒤기울기측정
        '            IF 넘어진확인 = 1 THEN
        '                넘어진확인 = 0
        '                GOTO RX_EXIT
        '            ENDIF
        '
        '        보행COUNT = 보행COUNT + 1
        '            IF 보행COUNT > 보행횟수 THEN  GOTO 전진달리기50_3_stop
        '
        '        ERX 4800,A, 전진달리기50_4
        '            IF A <> A_old THEN
문_달리기_멈춤_0:

        전진달리기연속분기체크=0

        MOVE G6D,90,  92, 114, 100, 104
        MOVE G6A,104,  73, 144,  91,  102
        WAIT
        HIGHSPEED SETOFF

        SPEED 10
        MOVE G6C, 100,38,90
        MOVE G6B,100,38,90

        SPEED 5
        GOSUB 안정화자세


        RETURN

    ELSEIF 전진달리기연속분기체크=1 THEN
        '*********************************

문_달리기50_4:
        MOVE G6D,95,  94, 99, 120, 104
        MOVE G6A,104,  76, 146,  93,  102
        WAIT


문_달리기50_5:
        MOVE G6D,95,  74, 121, 120, 104
        MOVE G6A,104,  77, 146,  90,  100
        WAIT


문_달리기50_6:
        MOVE G6D,103,  68, 144, 103,  100
        MOVE G6A, 95, 86, 159,  68, 102
        WAIT

        전진달리기연속분기체크=0

        RETURN

문_달리기_멈춤_1:

        전진달리기연속분기체크=0

        MOVE G6A,90,  92, 114, 100, 104
        MOVE G6D,104,  73, 144,  91,  102
        WAIT
        HIGHSPEED SETOFF

        SPEED 10
        MOVE G6C, 100,38,90
        MOVE G6B,100,38,90

        SPEED 5
        GOSUB 안정화자세

        RETURN

    ENDIF


    '******************************************




    '******************************************
    '밸브 전진 할때 사용
연속전진:
    보행COUNT = 0
    보행속도 = 8
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 10'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        GOTO 연속전진_1
    ELSE
        보행순서 = 0

        SPEED 4

        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 10

        MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 147,  93,  96,100
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO 연속전진_2	

    ENDIF


    '*******************************

연속전진_1:

    'ETX 4800,11 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT


    SPEED 보행속도

    'GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    '    IF 보행COUNT > 보행횟수 THEN  GOTO 연속전진멈춤

    ' ERX 4800,A, 연속전진_2
    '    IF A = 11 THEN
    '        GOTO 연속전진_2
    '    ELSE
    '
    '여기가 왼발 앞으로 하고 멈춤
연속전진멈춤_왼발:
    ' GOSUB Leg_motor_mode3

    MOVE G6A,112,  76, 146,  93, 96,100
    MOVE G6D,90, 100, 100, 115, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT
    HIGHSPEED SETOFF

    SPEED 8
    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 152,  91, 106,100
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT	

    SPEED 2
    GOSUB 기본자세2

    RETURN

    '**********

연속전진_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

연속전진_3:
    ETX 4800,11 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도

    ' GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, 연속전진_4
    '    IF A = 11 THEN
    '        GOTO 연속전진_4
    '    ELSE

연속전진멈춤_오른발:

    MOVE G6A, 90, 100, 100, 115, 110,100
    MOVE G6D,112,  76, 146,  93,  96,100
    MOVE G6B,90
    MOVE G6C,110
    WAIT
    HIGHSPEED SETOFF
    SPEED 8

    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 152,  91, 106,100
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT	
    SPEED 2
    GOSUB 기본자세2

    'GOTO RX_EXIT
    RETURN



    '연속전진_4:
    '    '왼발들기10
    '    MOVE G6A,90, 90, 120, 105, 110,100
    '    MOVE G6D,110,  76, 146,  93,  96,100
    '    MOVE G6B, 90
    '    MOVE G6C,110
    '    WAIT
    '
    '    GOTO 연속전진_1

    '************************************************
    '************************************************
오른쪽옆으로_SHORT:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 안정화자세
    GOSUB All_motor_mode3

    RETURN

    '*************

왼쪽옆으로_SHORT: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 안정화자세
    GOSUB All_motor_mode3

    RETURN

    '**********************************************
왼쪽옆으로70:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    '1 다리 왼쪽으로 펴기
    'SPEED 10
    '    MOVE G6A, 90,  90, 120, 105, 110, 100	
    '    MOVE G6D,100,  76, 145,  93, 107, 100	
    '    WAIT

    '1 다리 왼쪽으로 펴기 TEST
    ' SPEED 10
    '    MOVE G6A, 90,  92, 120, 108, 110, 100	
    '    MOVE G6D,100,  76, 145,  93, 107, 100	
    '    WAIT

    '왼쪽으로 가면서 좀 앞으로 가게 한거
    '1 다리 왼쪽으로 펴기 TEST2
    SPEED 10
    MOVE G6A, 90,  98, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100	
    WAIT

    '2 다리 왼쪽으로 모으기
    SPEED 13
    MOVE G6A, 102,  76, 145, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    '3 다리 왼쪽으로 거의 모으기
    SPEED 13
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    '4
    '다리 다 모으기
    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT

    '5
    '안정화자세
    SPEED 8
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN

    '******************************************

    '******************************************
오른쪽옆으로70:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    '1
    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 145,  93, 107, 100
    WAIT

    '2
    SPEED 13
    MOVE G6D, 102,  76, 145, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    '3
    SPEED 13
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    '4
    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    '5
    '안정화자세
    SPEED 8
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN

    '**********************************************

오른쪽옆으로_LONG:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    DELAY  10

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 145,  93, 107, 100
    WAIT

    SPEED 13
    MOVE G6D, 102,  76, 145, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT


    '  ERX 4800, A ,오른쪽옆으로70연속_loop
    '    IF A = A_OLD THEN  GOTO 오른쪽옆으로70연속_loop
    '오른쪽옆으로70연속_stop:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    GOSUB All_motor_mode3

    RETURN
    '**********************************************
왼쪽옆으로_LONG:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    DELAY  10

    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100
    WAIT

    SPEED 13
    MOVE G6A, 102,  76, 145, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT

    '   ERX 4800, A ,왼쪽옆으로70연속_loop	
    '    IF A = A_OLD THEN  GOTO 왼쪽옆으로70연속_loop
    '왼쪽옆으로70연속_stop:

    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    GOSUB All_motor_mode3

    RETURN

    '**********************************************
    '************************************************
    '*********************************************

    '왼쪽턴3:
    '    MOTORMODE G6A,3,3,3,3,2
    '    MOTORMODE G6D,3,3,3,3,2
    '왼쪽턴3_LOOP:
    '
    '    IF 보행순서 = 0 THEN
    '        보행순서 = 1
    '        SPEED 15
    '        MOVE G6D,100,  73, 145,  93, 100, 100
    '        MOVE G6A,100,  79, 145,  93, 100, 100
    '        WAIT
    '
    '        SPEED 6
    '        MOVE G6D,100,  84, 145,  78, 100, 100
    '        MOVE G6A,100,  68, 145,  108, 100, 100
    '        WAIT
    '
    '        SPEED 9
    '        MOVE G6D,90,  90, 145,  78, 102, 100
    '        MOVE G6A,104,  71, 145,  105, 100, 100
    '        WAIT
    '        SPEED 7
    '        MOVE G6D,90,  80, 130, 102, 104
    '        MOVE G6A,105,  76, 146,  93,  100
    '        WAIT
    '
    '
    '
    '    ELSE
    '        보행순서 = 0
    '        SPEED 15
    '        MOVE G6D,100,  73, 145,  93, 100, 100
    '        MOVE G6A,100,  79, 145,  93, 100, 100
    '        WAIT
    '
    '
    '        SPEED 6
    '        MOVE G6D,100,  88, 145,  78, 100, 100
    '        MOVE G6A,100,  65, 145,  108, 100, 100
    '        WAIT
    '
    '        SPEED 9
    '        MOVE G6D,104,  86, 146,  80, 100, 100
    '        MOVE G6A,90,  58, 145,  110, 100, 100
    '        WAIT
    '
    '        SPEED 7
    '        MOVE G6A,90,  85, 130, 98, 104
    '        MOVE G6D,105,  77, 146,  93,  100
    '        WAIT
    '
    '
    '
    '    ENDIF
    '
    '    SPEED 12
    '    GOSUB 기본자세2
    '
    '
    '    GOTO RX_EXIT
    '
    '    '**********************************************
    '오른쪽턴3:
    '    MOTORMODE G6A,3,3,3,3,2
    '    MOTORMODE G6D,3,3,3,3,2
    '
    '오른쪽턴3_LOOP:
    '
    '    IF 보행순서 = 0 THEN
    '        보행순서 = 1
    '        SPEED 15
    '        MOVE G6A,100,  73, 145,  93, 100, 100
    '        MOVE G6D,100,  79, 145,  93, 100, 100
    '        WAIT
    '
    '
    '        SPEED 6
    '        MOVE G6A,100,  84, 145,  78, 100, 100
    '        MOVE G6D,100,  68, 145,  108, 100, 100
    '        WAIT
    '
    '        SPEED 9
    '        MOVE G6A,90,  90, 145,  78, 102, 100
    '        MOVE G6D,104,  71, 145,  105, 100, 100
    '        WAIT
    '        SPEED 7
    '        MOVE G6A,90,  80, 130, 102, 104
    '        MOVE G6D,105,  76, 146,  93,  100
    '        WAIT
    '
    '
    '
    '    ELSE
    '        보행순서 = 0
    '        SPEED 15
    '        MOVE G6A,100,  73, 145,  93, 100, 100
    '        MOVE G6D,100,  79, 145,  93, 100, 100
    '        WAIT
    '
    '
    '        SPEED 6
    '        MOVE G6A,100,  88, 145,  78, 100, 100
    '        MOVE G6D,100,  65, 145,  108, 100, 100
    '        WAIT
    '
    '        SPEED 9
    '        MOVE G6A,104,  86, 146,  80, 100, 100
    '        MOVE G6D,90,  58, 145,  110, 100, 100
    '        WAIT
    '
    '        SPEED 7
    '        MOVE G6D,90,  85, 130, 98, 104
    '        MOVE G6A,105,  77, 146,  93,  100
    '        WAIT
    '
    '    ENDIF
    '    SPEED 12
    '    GOSUB 기본자세2
    '
    '    GOTO RX_EXIT

    '******************************************************
    '**********************************************
왼쪽턴_SHORT:

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    '1
    '-1,-10,0,+10,+2,0
    '-1,+10,0,-10,+2,0
    SPEED 5
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    '2
    '0,+5,0,-5,0,0
    '0,-5,0,+5,0,0
    SPEED 5
    MOVE G6A,97,  81, 145,  88, 103, 100
    MOVE G6D,97,  71, 145,  98, 103, 100
    WAIT

    '3
    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100

    WAIT

    '4
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    '안정화자세
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOSUB All_motor_mode3

    RETURN

    '**********************************************
오른쪽턴_SHORT:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    '1
    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    '2
    SPEED 5
    MOVE G6A,97,  71, 145,  98, 103, 100
    MOVE G6D,97,  81, 145,  88, 103, 100
    WAIT

    '3
    '
    'SPEED 12
    '    MOVE G6A,94,  66, 145,  103, 101, 100
    '    MOVE G6D,94,  86, 145,  83, 101, 100
    '    WAIT

    '3 test
    'A,+4
    'SHORT턴이 뒤로 밀리는 경우 뒤로밀리는 발의 반대쪽으로 발목의 무게중심을 옮기면 됨
    SPEED 12
    MOVE G6A,98,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT

    '4
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    '5
    'GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOSUB All_motor_mode3

    RETURN



    '**********************************************
    '**********************************************
왼쪽턴_LONG:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    '1
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    'MOVE G6B,110
    '    MOVE G6C,90
    WAIT

    '2
    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    '3
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    '4
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    GOSUB All_motor_mode3

    RETURN

    '**********************************************
오른쪽턴_LONG:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    '1
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    'MOVE G6B,90
    '    MOVE G6C,110
    WAIT

    '2
    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    '3
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    '4
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    GOSUB All_motor_mode3

    RETURN

    '************************************************
오른쪽턴60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    HIGHSPEED SETON

    SPEED 6
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 7
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100
    WAIT

    HIGHSPEED SETOFF

    '안정화자세
    SPEED 8
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN
    '****************************************

왼쪽턴60:

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    HIGHSPEED SETON
    '1 test
    SPEED 6
    MOVE G6A,95,  116, 145,  48, 105, 100
    MOVE G6D,95,  32, 145,  138, 105, 100
    WAIT

    '2 test
    'a, -5,0,0,0,0,0
    'd, -5,0.0,0,0,0
    SPEED 7
    MOVE G6A,90,  116, 145,  48, 105, 100
    MOVE G6D,90,  36, 145,  138, 105, 100
    WAIT

    HIGHSPEED SETOFF

    '안정화자세
    SPEED 8
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN

뒤로일어나기:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB 자이로OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB 기본자세

    MOVE G6A,90, 130, ,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 100, 100, 100
    WAIT

    MOVE G6B,170, 140,  10, 100, 100, 100
    MOVE G6C,170, 140,  10, 100, 100, 100
    WAIT

    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT
    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT



    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10
    GOSUB 기본자세

    넘어진확인 = 1

    DELAY 200
    GOSUB 자이로ON

    RETURN


    '**********************************************
앞으로일어나기:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 15,  70, 140, 100,
    MOVE G6D,100, 15,  70, 140, 100,
    MOVE G6B,20,  140,  15
    MOVE G6C,20,  140,  15
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 6
    MOVE G6A,100, 145,  45, 130, 100,
    MOVE G6D,100, 145,  45, 130, 100,
    WAIT


    SPEED 8
    GOSUB All_motor_mode2
    GOSUB 기본자세
    넘어진확인 = 1

    '******************************
    DELAY 200
    GOSUB 자이로ON
    RETURN

    '******************************************
    '******************************************
앞뒤기울기측정:
    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN
        GOSUB 기울기앞
    ELSEIF A > MAX THEN
        GOSUB 기울기뒤
    ENDIF

    RETURN
    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN
        'ETX  4800,16
        GOSUB 뒤로일어나기

    ENDIF
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN
        'ETX  4800,15
        GOSUB 앞으로일어나기
    ENDIF
    RETURN
    '**************************************************
좌우기울기측정:
    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
    ENDIF
    RETURN
    '******************************************
    '************************************************
SOUND_PLAY_CHK:
    DELAY 60
    SOUND_BUSY = IN(46)
    IF SOUND_BUSY = 1 THEN GOTO SOUND_PLAY_CHK
    DELAY 50

    RETURN
    '************************************************

    '************************************************
NUM_1_9:
    IF NUM = 1 THEN
        PRINT "1"
    ELSEIF NUM = 2 THEN
        PRINT "2"
    ELSEIF NUM = 3 THEN
        PRINT "3"
    ELSEIF NUM = 4 THEN
        PRINT "4"
    ELSEIF NUM = 5 THEN
        PRINT "5"
    ELSEIF NUM = 6 THEN
        PRINT "6"
    ELSEIF NUM = 7 THEN
        PRINT "7"
    ELSEIF NUM = 8 THEN
        PRINT "8"
    ELSEIF NUM = 9 THEN
        PRINT "9"
    ELSEIF NUM = 0 THEN
        PRINT "0"
    ENDIF

    RETURN
    '************************************************
    '************************************************
NUM_TO_ARR:

    NO_4 =  BUTTON_NO / 10000
    TEMP_INTEGER = BUTTON_NO MOD 10000

    NO_3 =  TEMP_INTEGER / 1000
    TEMP_INTEGER = BUTTON_NO MOD 1000

    NO_2 =  TEMP_INTEGER / 100
    TEMP_INTEGER = BUTTON_NO MOD 100

    NO_1 =  TEMP_INTEGER / 10
    TEMP_INTEGER = BUTTON_NO MOD 10

    NO_0 =  TEMP_INTEGER

    RETURN
    '************************************************
Number_Play: '  BUTTON_NO = 숫자대입


    GOSUB NUM_TO_ARR

    PRINT "NPL "
    '*************

    NUM = NO_4
    GOSUB NUM_1_9

    '*************
    NUM = NO_3
    GOSUB NUM_1_9

    '*************
    NUM = NO_2
    GOSUB NUM_1_9
    '*************
    NUM = NO_1
    GOSUB NUM_1_9
    '*************
    NUM = NO_0
    GOSUB NUM_1_9
    PRINT " !"

    GOSUB SOUND_PLAY_CHK
    PRINT "SND 16 !"
    GOSUB SOUND_PLAY_CHK
    RETURN
    '************************************************

    RETURN


    '******************************************
    ' ************************************************
적외선거리센서확인:

    '5번포트로 적외선거리값 들어옴
    적외선거리값 = AD(5)

    ' IF 적외선거리값 > 50 THEN '50 = 적외선거리값 = 25cm
    '        MUSIC "C"
    '        DELAY 200
    '    ENDIF
    '
    적외선거리값_Old=적외선거리값
    적외선거리값_Old=160-적외선거리값_Old/2

    적외선거리값_Old=  적외선거리값_Old+100

    IF 적외선거리값_Old>180 THEN

        적외선거리값_Old=180

    ELSEIF 적외선거리값_Old<100  THEN
        적외선거리값_Old=100

    ENDIF

    ETX 4800, 적외선거리값_Old

    RETURN


    '******************************************
    '************************************************
    '계단오른발내리기 3cm
계단오른발내리기1cm:

    GOSUB All_motor_mode3

    '오른발 완전 집어넣기 ''''
    SPEED 5
    MOVE G6A, 100, 110,  112, 92,  101, 100
    MOVE G6D,  100,  112, 112, 92, 101, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발목 왼쪽으로
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  85,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT 	

    '오른발 거의발목까지   집어넣기
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT 	

    '오른발 거의  집어넣기
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  105, 63, 119, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 집어넣기
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  15, 139, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '왼무릎수직 최종들기
    SPEED 2
    MOVE G6A, 112, 110,  112, 77,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '왼무릎 많이들기
    SPEED 1
    MOVE G6A, 112, 125,  102, 65,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT	

    '왼무릎 들기
    SPEED 5
    MOVE G6A, 108, 140,  92, 82,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '시험 오른발로 지탱하고 내려가는 동작
    SPEED 5
    MOVE G6A, 105, 140,  92, 102,  81, 100
    MOVE G6D,  95,  15, 169, 149, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 , 오른발 세우기
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  81, 100
    MOVE G6D,  95,  35, 149, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 거의 수직으로 세우기 ';';'
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  96, 100
    MOVE G6D,  100,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 발목 왼쪽으로 기울이기
    SPEED 5
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  105,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 무릎과 상체 숙이기
    SPEED 3
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  110,  45, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 무릎 약간 올리기
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  110,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 무릎 약간 올리기 (오른발 발목 중심 잡기)
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 앞으로 갖고오기
    SPEED 3
    MOVE G6A, 97, 105,  103, 132,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 앞으로 갖고오기 2
    SPEED 3
    MOVE G6A, 97, 110,  97, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 앞으로 갖고오기 3
    SPEED 3
    MOVE G6A, 97, 110,  107, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 내리기1
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 내리기2
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  107,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 내리기3
    SPEED 3
    MOVE G6A, 97, 55,  149, 136,  96, 100
    MOVE G6D,  107,  55, 149, 139, 104, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT


    SPEED 4
    GOSUB 기본자세''검수 대상

    ETX 4800, 254

    RETURN

    '************************************************

    '********************************************
    '계단오른발오르기1cm
계단오른발오르기1cm:
    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    'MOVE G6D, 90, 140, 35, 130, 114
    '왼발로 지탱하고 오른발 수직으로 들어올리는 동작
    SPEED 8
    MOVE G6D, 90, 110, 110, 100, 114
    MOVE G6A,113,  71, 155,  90,  94
    WAIT


    '들어올린 오른발을 수평으로 계단쪽으로 움직이는 동작
    'MOVE G6D,  80, 55, 130, 140, 114
    'MOVE G6A,113,  70, 155,  90,  94
    SPEED 12
    MOVE G6D,  80, 55, 130, 140, 114
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    '계단에 오쪽발 내딛는 동작(오른쪽발에 무게중심 실림)
    'MOVE G6D, 105, 75, 100, 155, 100,
    'MOVE G6A,95,  90, 165,  70, 100
    'MOVE G6C,160,50
    'MOVE G6B,160,40

    SPEED 5
    MOVE G6D, 105, 65, 110, 155, 100,
    MOVE G6A,95,  90, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    DELAY 1500

    '오른발 딛고 팔올리면서 무게중심잡기
    'SPEED 6
    'MOVE G6D, 113, 90, 90, 155,100,
    'MOVE G6A,95,  100, 165,  65, 105
    'MOVE G6C,180,50
    'MOVE G6B,180,30
    SPEED 4
    MOVE G6D, 113, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    '위에와 똑같고 왼발목 앞으로 기울이기
    'SPEED 8
    'MOVE G6D, 114, 90, 100, 150,95,
    'MOVE G6A,95,  90, 165,  70, 105
    'WAIT
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,95,  105, 165,  55, 105
    WAIT

    '그대로 왼발 들어올리기
    'SPEED 8
    'MOVE G6D, 114, 90, 100, 150,95,
    'MOVE G6A,95,  90, 165,  70, 105
    'WAIT
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,95,  135, 135,  55, 105
    WAIT

    '왼무릎 들어올리고 왼골반가져오기
    'SPEED 12
    'MOVE G6D, 114, 90, 100, 150,95,
    'MOVE G6A,90,  120, 40,  140, 108
    'WAIT
    SPEED 5
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,90,  135, 40,  140, 108
    WAIT

    '왼무릎내리고 발 거의 바닥에 붙이기
    'SPEED 10
    '    MOVE G6D, 114, 90, 110, 130,95,
    '    MOVE G6A,90,  95, 90,  145, 108
    '    MOVE G6C,140,50
    '    MOVE G6B,140,30
    '    WAIT

    SPEED 8
    MOVE G6D, 114, 90, 110, 130,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    '발 바닥에 붙이기(이때까지 앉은자세)
    'SPEED 5
    '    MOVE G6A, 98, 90, 110, 125,99,
    '    MOVE G6D,98,  90, 110,  125, 99
    '    MOVE G6B,110,40
    '    MOVE G6C,110,40
    '    WAIT

    SPEED 5
    MOVE G6A, 98, 90, 110, 125,99,
    MOVE G6D,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    DELAY 800

    '차렷자세
    'SPEED 6
    '    MOVE G6A,100,  77, 145,  93, 100, 100
    '    MOVE G6D,100,  77, 145,  93, 100, 100
    '    MOVE G6B,100,  30,  80
    '    MOVE G6C,100,  30,  80
    '    WAIT

    ETX 4800, 254

    RETURN

    '*******************************************************
    '*******************************************************

    '가스밸브잠구기_팔올리기:
    '
    '    SPEED 15
    '    '팔수직올리기자세
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  189,  90
    '    WAIT
    '
    '    RETURN
    '
    '    '실제로 가스밸브 잠구기하는 동작
    '가스밸브_잠그고팔내리기:
    '
    '    SPEED 15
    '    '팔 앞으로
    '    'MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,60,  189,  90
    '    '    WAIT
    '
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,50,  189,  90
    '    WAIT
    '
    '    'SPEED 5
    '    SPEED 10
    '    '가스밸브 잠구기
    '    'MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,40,  189,  160
    '    '    WAIT
    '
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,50,  189,  160
    '    WAIT
    '
    '    SPEED 15
    '    '팔 앞으로
    '    'MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,60,  189,  90
    '    '    WAIT
    '
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,50,  189,  90
    '    WAIT
    '
    '    'SPEED 5
    '    SPEED 10
    '    '가스밸브 잠구기
    '    'MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,40,  189,  160
    '    '    WAIT
    '
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,50,  189,  160
    '    WAIT
    '
    '    SPEED 15
    '    '팔 앞으로
    '    'MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,60,  189,  90
    '    '    WAIT
    '
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,50,  189,  90
    '    WAIT
    '
    '    'SPEED 5
    '    SPEED 10
    '    '가스밸브 잠구기
    '    'MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,40,  189,  160
    '    '    WAIT
    '
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,50,  189,  160
    '    WAIT
    '
    '    SPEED 15
    '    '팔 앞으로
    '    'MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,60,  189,  90
    '    '    WAIT
    '
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,50,  189,  90
    '    WAIT
    '
    '    'SPEED 5
    '    SPEED 10
    '    '가스밸브 잠구기
    '    'MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,40,  189,  160
    '    '    WAIT
    '
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,50,  189,  160
    '    WAIT
    '
    '    DELAY 500
    '
    '    '팔내리기자세1
    '    SPEED 15
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,45,  189,  165
    '    WAIT
    '
    '    '팔내리기자세2
    '    SPEED 15
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,60,  159,  165
    '    WAIT
    '
    '    '팔내리기자세3
    '    SPEED 15
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  159,  165
    '    WAIT
    '
    '    '팔내리기자세4
    '    SPEED 15
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90,
    '    WAIT
    '
    '    RETURN
    '


    '    '******************************************	
    '가스밸브_걷기_시작:
    '
    '    보행속도 =10
    '
    '    ''안정화자세
    '    '	MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90
    '    '    MOVE G6C,100,  35,  90
    '    '    WAIT
    '
    '    '왼발 앞으로
    '    SPEED 보행속도
    '    MOVE G6A,98, 66, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    GOTO 가스밸브_걷기_1
    '
    '가스밸브_걷기_1:
    '
    '    '오른발 앞으로
    '    'SPEED 보행속도
    '    '	MOVE G6A,98, 76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  66, 145,  103, 101, 100
    '    '    MOVE G6B,100,  35,  90
    '    '    MOVE G6C,100,  35,  90
    '    '    WAIT
    '
    '    SPEED 보행속도
    '    MOVE G6A,98, 76, 145,  93, 101, 100
    '    MOVE G6D,98,  69, 145,  100, 101, 100
    '    WAIT
    '
    '    '왼발 앞으로
    '    SPEED 보행속도
    '    MOVE G6A,98, 66, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    'GOSUB 앞뒤기울기측정
    '    '    IF 넘어진확인 = 1 THEN
    '    '        넘어진확인 = 0
    '    '        GOTO RX_EXIT
    '    '    ENDIF
    '
    '    보행COUNT = 보행COUNT + 1
    '    IF 보행COUNT > 보행횟수 THEN  GOTO 가스밸브_걷기_멈춤
    '
    '    GOTO 가스밸브_걷기_1
    '
    '    RETURN
    '
    '가스밸브_걷기_멈춤:
    '
    '    SPEED 5
    '    MOVE G6A,98, 76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    RETURN
    '
    '    '**********************************************
    '
    '가스밸브_걷기:
    '
    '    보행횟수=2
    '    GOSUB 가스밸브_걷기_시작
    '    RETURN
    '
    '    '**********************************************
    '가스밸브_왼쪽턴:
    '
    '    MOTORMODE G6A,3,3,3,3,2
    '    MOTORMODE G6D,3,3,3,3,2
    '    SPEED 5
    '    MOVE G6A,97,  86, 145,  83, 103, 100
    '    MOVE G6D,97,  66, 145,  103, 103, 100
    '    WAIT
    '
    '    SPEED 12
    '    MOVE G6A,94,  86, 145,  83, 101, 100
    '    MOVE G6D,94,  66, 145,  103, 101, 100
    '    WAIT
    '
    '    SPEED 6
    '    MOVE G6A,101,  76, 146,  93, 98, 100
    '    MOVE G6D,101,  76, 146,  93, 98, 100
    '    WAIT
    '
    '    GOSUB 가스밸브_기본자세
    '    RETURN
    '
    '    '**********************************************
    '    '**********************************************
    '가스밸브_오른쪽턴:
    '
    '    MOTORMODE G6A,3,3,3,3,2
    '    MOTORMODE G6D,3,3,3,3,2
    '    SPEED 5
    '    MOVE G6A,97,  66, 145,  103, 103, 100
    '    MOVE G6D,97,  86, 145,  83, 103, 100
    '    WAIT
    '
    '    SPEED 12
    '    MOVE G6A,94,  66, 145,  103, 101, 100
    '    MOVE G6D,94,  86, 145,  83, 101, 100
    '    WAIT
    '    SPEED 6
    '    MOVE G6A,101,  76, 146,  93, 98, 100
    '    MOVE G6D,101,  76, 146,  93, 98, 100
    '    WAIT
    '
    '    GOSUB 가스밸브_기본자세
    '    RETURN


    '**********************************************
    '**********************************************
    '
    '가스밸브_왼쪽옆으로:
    '
    '    MOTORMODE G6A,3,3,3,3,2
    '    MOTORMODE G6D,3,3,3,3,2
    '
    '    SPEED 12
    '    MOVE G6A, 95,  90, 125, 100, 104, 100
    '    MOVE G6D,105,  76, 145,  93, 104, 100
    '    WAIT
    '
    '    SPEED 12
    '    MOVE G6A, 102,  77, 145, 93, 100, 100
    '    MOVE G6D,90,  80, 140,  95, 107, 100
    '    WAIT
    '
    '    SPEED 10
    '    MOVE G6A,95,  76, 145,  93, 102, 100
    '    MOVE G6D,95,  76, 145,  93, 102, 100
    '    WAIT
    '
    '    SPEED 8
    '    GOSUB 가스밸브_기본자세
    '    GOSUB All_motor_mode3
    '    RETURN
    '
    '    '**********************************************
    '    '**********************************************
    '
    '
    '가스밸브_오른쪽옆으로:
    '
    '    MOTORMODE G6A,3,3,3,3,2
    '    MOTORMODE G6D,3,3,3,3,2
    '
    '    SPEED 12
    '    MOVE G6D, 95,  90, 125, 100, 104, 100
    '    MOVE G6A,105,  76, 146,  93, 104, 100
    '    WAIT
    '
    '    SPEED 12
    '    MOVE G6D, 102,  77, 145, 93, 100, 100
    '    MOVE G6A,90,  80, 140,  95, 107, 100
    '    WAIT
    '
    '    SPEED 10
    '    MOVE G6D,95,  76, 145,  93, 102, 100
    '    MOVE G6A,95,  76, 145,  93, 102, 100
    '    WAIT
    '
    '    SPEED 8
    '    GOSUB 가스밸브_기본자세
    '    GOSUB All_motor_mode3
    '    RETURN
    '
    '    '******************************************	
    '    '******************************************	
    '가스밸브_팔거리맞추기:
    '
    '    '안정화자세
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,100,  35,  90
    '
    '    '거리맟추려고 팔 올리기
    '    SPEED 3
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,150,  15,  90
    '    MOVE G6C,150,  15,  90
    '
    '    RETURN

    '*************************************
    '    '*************************************
    '가스밸브_CLOSE걷기_시작:
    '    보행COUNT=0
    '
    '    SPEED 5
    '    '왼발 허벅지앞으로
    '    MOVE G6A,98,  78, 145,  101, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    GOTO 가스밸브_CLOSE걷기_1
    '
    '가스밸브_CLOSE걷기_1:
    '
    '    SPEED 5
    '    '오른발 허벅지앞으로
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  78, 145,  101, 101, 100
    '    WAIT
    '
    '    SPEED 5
    '    '왼발 허벅지앞으로
    '    MOVE G6A,98,  78, 145,  101, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    'GOSUB 앞뒤기울기측정
    '    '    IF 넘어진확인 = 1 THEN
    '    '        넘어진확인 = 0
    '    '        GOTO RX_EXIT
    '    '    ENDIF
    '
    '    GOTO 가스밸브_CLOSE걷기_멈춤
    '
    '가스밸브_CLOSE걷기_멈춤:
    '
    '    SPEED 3
    '    '오른발 앞으로가서  왼발하고 맞추기
    '    MOVE G6A,98,  78, 145,  101, 101, 100
    '    MOVE G6D,98,  78, 145,  101, 101, 100
    '    WAIT
    '
    '    SPEED 5
    '    GOSUB 안정화자세
    '
    '    RETURN
    '
    '******************************************
    '******************************************


    '******************************************	
    '******************************************	
    '적외선 거리로 130이상 떨어져있으면 안되고 114미만 으로 붙으면 안됨
    '옛날꺼
    '가스밸브_시퀀스:
    '
    '    'GOSUB 가스밸브_팔거리맞추기
    '    '
    '    '    DELAY 1000
    '    '
    '    '    보행횟수=10
    '    '    GOSUB 가스밸브_CLOSE걷기_시작
    '    '    GOSUB 가스밸브_CLOSE걷기_1
    '    '    GOSUB 가스밸브_CLOSE걷기_멈춤
    '    '
    '    '    DELAY 1000
    '
    '    GOSUB 안정화자세
    '
    '    DELAY 500
    '
    '    GOSUB 가스밸브잠구기_팔올리기
    '    DELAY 500
    '    GOSUB 가스밸브_잠그고팔내리기
    '    GOSUB 가스밸브_CLOSE걷기_시작
    '    GOSUB 가스밸브_CLOSE걷기_1
    '    GOSUB 가스밸브_CLOSE걷기_멈춤
    '
    '    GOSUB 가스밸브잠구기_팔올리기
    '    DELAY 500
    '    GOSUB 가스밸브_잠그고팔내리기
    '    GOSUB 가스밸브_CLOSE걷기_시작
    '    GOSUB 가스밸브_CLOSE걷기_1
    '    GOSUB 가스밸브_CLOSE걷기_멈춤
    '
    '    GOSUB 가스밸브잠구기_팔올리기
    '    DELAY 500
    '    GOSUB 가스밸브_잠그고팔내리기
    '
    '    RETURN

    '최신꺼
가스밸브_시퀀스:

    '지금것(방법2)-팔꿈치쓰는자세
    'GOSUB 가스밸브_팔올리는자세
    '
    '    GOSUB 가스밸브_팔붙이는자세
    '
    '    GOSUB 오른쪽턴_LONG
    '
    '    GOSUB 가스밸브_팔올리는자세
    '    GOSUB 왼쪽옆으로_LONG
    '    GOSUB 가스밸브_팔붙이는자세
    '    DELAY 200
    '    GOSUB 왼쪽턴_LONG
    '    DELAY 200
    '    GOSUB 걷기_FAST_시작
    '    GOSUB 걷기_FAST_연속
    '    GOSUB 걷기_FAST_멈춤
    '    DELAY 200
    '    GOSUB 가스밸브_팔꿈치_움직이기
    '    DELAY 200
    '    GOSUB 오른쪽턴_SHORT
    '
    '    GOSUB 가스밸브_팔올리는자세
    '    GOSUB 왼쪽옆으로_LONG
    '    GOSUB 가스밸브_팔붙이는자세
    '    DELAY 200
    '    GOSUB 왼쪽턴_LONG
    '    DELAY 200
    '    GOSUB 걷기_FAST_시작
    '    GOSUB 걷기_FAST_연속
    '    GOSUB 걷기_FAST_멈춤
    '    DELAY 200
    '    GOSUB 가스밸브_팔꿈치_움직이기
    '    DELAY 200
    '    GOSUB 오른쪽턴_SHORT

    '옛날것 (방법1)- 팔붙이는자세 어깨위아래(c) 60
    'GOSUB 가스밸브_팔올리는자세
    '
    '        GOSUB 가스밸브_팔붙이는자세
    '
    '        GOSUB 왼쪽옆으로70
    '        GOSUB 왼쪽턴_LONG
    '        GOSUB 걷기_FAST_시작
    '        GOSUB 걷기_FAST_연속
    '        GOSUB 걷기_FAST_멈춤
    '        GOSUB 걷기_FAST_시작
    '        GOSUB 걷기_FAST_연속
    '        GOSUB 걷기_FAST_멈춤
    '        GOSUB 가스밸브_팔꿈치_움직이기
    '        GOSUB 오른쪽턴_SHORT
    '
    '        GOSUB 왼쪽옆으로70
    '        GOSUB 왼쪽턴_LONG
    '        GOSUB 걷기_FAST_시작
    '        GOSUB 걷기_FAST_연속
    '        GOSUB 걷기_FAST_멈춤
    '        GOSUB 걷기_FAST_시작
    '        GOSUB 걷기_FAST_연속
    '        GOSUB 걷기_FAST_멈춤
    '        GOSUB 가스밸브_팔꿈치_움직이기
    '        GOSUB 오른쪽턴_SHORT
    '
    '        GOSUB 왼쪽옆으로70
    '        GOSUB 왼쪽턴_LONG
    '        GOSUB 걷기_FAST_시작
    '        GOSUB 걷기_FAST_연속
    '        GOSUB 걷기_FAST_멈춤
    '        GOSUB 걷기_FAST_시작
    '        GOSUB 걷기_FAST_연속
    '        GOSUB 걷기_FAST_멈춤
    '        GOSUB 가스밸브_팔꿈치_움직이기
    '        GOSUB 오른쪽턴_SHORT
    '
    '        GOSUB 왼쪽옆으로70
    '        GOSUB 왼쪽턴_LONG
    '        GOSUB 걷기_FAST_시작
    '        GOSUB 걷기_FAST_연속
    '        GOSUB 걷기_FAST_멈춤
    '        GOSUB 걷기_FAST_시작
    '        GOSUB 걷기_FAST_연속
    '        GOSUB 걷기_FAST_멈춤
    '        GOSUB 가스밸브_팔꿈치_움직이기
    '        GOSUB 오른쪽턴_SHORT

    '방법3
    보행횟수=3
    GOSUB CLOSE걷기_시작
    GOSUB CLOSE걷기_시작
    GOSUB CLOSE걷기_시작

    '1
    GOSUB 왼쪽옆으로_LONG
    'GOSUB 왼쪽옆으로_T
    GOSUB CLOSE걷기_시작
    GOSUB 가스밸브_오른팔완전내리기
    GOSUB 가스밸브_오른팔완전올리기
    GOSUB CLOSE걷기_시작


    '2
    'GOSUB CLOSE걷기_시작
    GOSUB 왼쪽옆으로_LONG
    'GOSUB 왼쪽옆으로_SHORT
    GOSUB CLOSE걷기_시작
    GOSUB 가스밸브_오른팔완전내리기
    GOSUB 가스밸브_오른팔완전올리기
    GOSUB CLOSE걷기_시작


    '3
    'GOSUB CLOSE걷기_시작
    GOSUB 왼쪽옆으로_LONG
    GOSUB CLOSE걷기_시작
    GOSUB 가스밸브_오른팔완전내리기
    'GOSUB 왼쪽옆으로_SHORT


    'GOSUB 가스밸브_왼팔올리기

    RETURN

    '******************************************	
가스밸브_팔올리는자세:

    SPEED 15
    '팔수직올리기자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,85,  189,  90
    WAIT

    RETURN

    '가스밸브_팔덜올리는자세:
    '
    '    SPEED 15
    '    '팔수직올리기자세
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,75,  189,  90
    '    WAIT
    '
    '    RETURN

가스밸브_팔붙이는자세:

    ' SPEED 3
    '    '    '팔수직올리기자세
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,52,  189,  110
    '    WAIT

    SPEED 3
    '    '팔수직올리기자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,80,  189,  110
    WAIT
    'C,60

    RETURN

가스밸브_팔내리는자세:

    ' SPEED 3
    '    '    '팔수직올리기자세
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,52,  189,  110
    '    WAIT

    SPEED 3
    '    '팔수직올리기자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,59,  189,  110
    WAIT

    RETURN

    '가스밸브_팔더내리는자세:
    '
    '    ' SPEED 3
    '    '    '    '팔수직올리기자세
    '    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,52,  189,  110
    '    '    WAIT
    '
    '    SPEED 3
    '    '    '팔수직올리기자세
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,40,  189,  110
    '    WAIT
    '
    '    RETURN

가스밸브_팔완전히내리는자세:

    ' SPEED 3
    '    '    '팔수직올리기자세
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,52,  189,  110
    '    WAIT

    SPEED 5
    '    '팔수직올리기자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,15,  189,  110
    WAIT

    RETURN

    '******************************************	
가스밸브_팔꿈치_움직이기:

    '원래상태
    SPEED 10
    MOVE G6B,,  ,  ,
    MOVE G6C,,  ,  110

    '안쪽으로
    SPEED 15
    MOVE G6B,,  ,  ,
    MOVE G6C,,  ,  150

    '팔꿈치내리기
    'SPEED 10
    '    MOVE G6B,,  ,  90,
    '    MOVE G6C,35,  ,  170

    '원래상태
    SPEED 10
    MOVE G6B,,  ,  ,
    MOVE G6C,,  ,  110

    RETURN

    '******************************************	
가스밸브_FAST걸음_팔자세:
    SPEED 3
    '    '팔수직올리기자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,40,  185,  130
    MOVE G6C,40,  185,  130
    WAIT

    RETURN

    '******************************************	
가스밸브_오른팔완전올리기:

    SPEED 3
    MOVE G6C,62,  180,  147

    RETURN
    '******************************************

    '******************************************	
가스밸브_오른팔완전내리기:

    '오른팔 안쪽으로 접기
    SPEED 3
    MOVE G6B,60,  176,  145
    MOVE G6C,62,  180,  163

    '오른팔 내리기
    SPEED 3
    MOVE G6B,60,  176,  145
    MOVE G6C,10,  183,  167

    RETURN
    '******************************************
    '******************************************	
가스밸브_오른팔중간내리기:

    SPEED 3
    MOVE G6B,60,  176,  145
    MOVE G6C,18,  183,  142

    RETURN
    '******************************************


가스밸브걷기_시작:
    넘어진확인 = 0
    전진달리기연속체크=0
    전진달리기연속분기체크=0

    GOSUB All_motor_mode3
    보행COUNT = 0
    DELAY 50

    'SPEED 8
    SPEED 6
    HIGHSPEED SETON

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        WAIT

        MOVE G6A,95,  80, 120, 120, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT

        GOTO 가스밸브걷기_2
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        WAIT

        MOVE G6D,95,  80, 120, 120, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

        GOTO 가스밸브걷기_5

    ENDIF



    '   **********************
가스밸브걷기_연속:

    ' IF 전진달리기연속분기체크=0 THEN
    '
    '        IF 전진달리기연속체크=1 THEN

가스밸브걷기_1:
    MOVE G6A,95,  95, 100, 120, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT

    ' ENDIF

가스밸브걷기_2:

    전진달리기연속체크=1

    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  78, 147,  90,  100
    WAIT

가스밸브걷기_3:
    MOVE G6A,103,  69, 145, 103,  100
    MOVE G6D, 95, 87, 160,  68, 102
    WAIT

    전진달리기연속분기체크=1

    GOTO 가스밸브걷기_멈춤_0

    'GOSUB 앞뒤기울기측정
    '            IF 넘어진확인 = 1 THEN
    '                넘어진확인 = 0
    '                GOTO RX_EXIT
    '            ENDIF
    '
    '        보행COUNT = 보행COUNT + 1
    '            IF 보행COUNT > 보행횟수 THEN  GOTO 전진달리기50_3_stop
    '
    '        ERX 4800,A, 전진달리기50_4
    '            IF A <> A_old THEN
가스밸브걷기_멈춤_0:

    전진달리기연속분기체크=0

    MOVE G6D,90,  93, 115, 100, 104
    MOVE G6A,104,  74, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 5
    GOSUB 안정화자세


    RETURN

    ' ELSEIF 전진달리기연속분기체크=1 THEN
    '*********************************

가스밸브걷기_4:
    MOVE G6D,95,  95, 100, 120, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


가스밸브걷기_5:
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  78, 147,  90,  100
    WAIT


가스밸브걷기_6:
    MOVE G6D,103,  69, 145, 103,  100
    MOVE G6A, 95, 87, 160,  68, 102
    WAIT

    전진달리기연속분기체크=0

    GOTO 가스밸브걷기_멈춤_1

가스밸브걷기_멈춤_1:

    전진달리기연속분기체크=0

    MOVE G6A,90,  93, 115, 100, 104
    MOVE G6D,104,  74, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 5
    GOSUB 안정화자세

    RETURN

    ' ENDIF

    '******************************************
    '******************************************
가스밸브_걷기_FAST_시작:

    보행COUNT=0
    'HIGHSPEED SETON
    보행속도=12

    '팔올리는 자세
    SPEED 10
    MOVE G6B,50,  180,  138
    MOVE G6C,50,  185,  141

    ''안정화자세
    '  MOVE G6A,98,  76, 145,  93, 101, 100
    '        MOVE G6D,98,  76, 145,  93, 101, 100
    '        MOVE G6B,100,  35,  90
    '        MOVE G6C,100,  35,  90
    '        WAIT


    '왼발 앞으로
    ' MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT

    SPEED 3
    '테스트1
    MOVE G6A,98,  61, 140,  112, 101, 100
    MOVE G6D,98,  87, 140,  95, 101, 100
    WAIT

    RETURN

가스밸브_걷기_FAST_연속:

    SPEED 보행속도
    '오른발 앞으로

    'IF 걸음방향=2 OR 걸음방향=3 THEN

    '직진걸음( 기울게 하고 싶은 방향 발의 바깥쪽으로 발목을 해주면됨)
    MOVE G6D,98,  61, 140,  111, 101, 100
    MOVE G6A,92,  87, 140,  95, 101, 100
    WAIT

    '직진걸음(약간 왼쪽으로 가게 )
    'D,+2
    'MOVE G6D,98,  60, 145,  109, 101, 100
    '    MOVE G6A,100,  86, 145,  93, 101, 100
    '    WAIT

    ' ELSEIF 걸음방향=4 THEN
    '
    '        '직진걸음
    '        MOVE G6D,98,  60, 145,  109, 101, 100
    '        MOVE G6A,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '    ELSEIF 걸음방향=1 THEN
    '
    '        '테스트2(왼쪽으로 휘게)
    '
    '        MOVE G6D,98,  60, 145,  109, 101, 100
    '        MOVE G6A,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '        'A,
    '        'D,+4
    '        MOVE G6A,98,  86, 145,  93, 101, 100
    '        MOVE G6D,102,  60, 145,  109, 101, 100
    '        WAIT
    '
    '    ENDIF

    '--------------------------------------------

    SPEED 보행속도

    '왼발 앞으로
    'IF 걸음방향=2 OR 걸음방향=1 THEN

    '직진걸음
    MOVE G6A,98,  61, 140,  112, 101, 100
    MOVE G6D,98,  87, 140,  95, 101, 100
    WAIT	

    'ELSEIF 걸음방향=3 THEN
    '
    '        MOVE G6A,98,  60, 145,  110, 101, 100
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '        '테스트2(오른쪽으로 휘게)
    '        'A,+4
    '        'D,
    '        MOVE G6A,102,  60, 145,  110, 101, 100
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        WAIT

    'ELSEIF 걸음방향=4 THEN
    '
    '        '테스트2(왼쪽으로 휘게)
    '
    '        HIGHSPEED SETOFF
    '        SPEED 7
    '
    '        MOVE G6A,98,  60, 145,  110, 101, 100
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '        'A,+8
    '        'D,
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        MOVE G6A,106,  60, 145,  109, 101, 100
    '        WAIT
    '
    '        HIGHSPEED SETON
    '
    '    ENDIF


    RETURN

가스밸브_걷기_FAST_멈춤:

    SPEED 보행속도
    MOVE G6D,98,  61, 140,  111, 101, 100
    MOVE G6A,96,  87, 140,  95, 101, 100
    WAIT

    '테스트1
    'SPEED 2
    '    MOVE G6A,98,  60, 145,  106, 101, 100
    '    MOVE G6D,98,  76, 145,  106, 101, 100
    '    WAIT

    SPEED 2
    '안정화자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    SPEED 5
    '좀 앞으로
    MOVE G6A,98,  78, 145,  93, 101, 100
    MOVE G6D,98,  78, 145,  93, 101, 100

    'HIGHSPEED SETOFF

    RETURN

    '**********************************************
가스밸브_왼팔올리기:

    '원래자세
    SPEED 5
    MOVE G6B,40,  185,  135
    MOVE G6C,40,  185,  135

    '왼팔올리기
    SPEED 5
    MOVE G6B,100,  185,  100
    MOVE G6C,40,  185,  130

    '팔꿈치펴기
    SPEED 10
    MOVE G6B,100,  185,  100
    MOVE G6C,40,  188,  180

    '팔꿈치굽히기
    SPEED 10
    MOVE G6B,100,  185,  130
    MOVE G6C,40,  188,  165

    DELAY 1000

    '왼팔내리기
    SPEED 3
    MOVE G6B,10,  155,  160
    MOVE G6C,40,  188,  165

    '왼팔살짝올리기 (고장 방지용 )
    SPEED 3
    MOVE G6B,15,  145,  160
    MOVE G6C,40,  188,  165

    '왼허리뒤로 보내기(손 앞으로 보낼때 왼발로 지탱 )
    SPEED 5
    MOVE G6A,98,  78, 145,  85, 101, 100
    MOVE G6D,98,  78, 145,  85, 101, 100

    RETURN

    '**********************************************
터널_기어가기_준비자세:

    보행COUNT=0

    '팔 내리기
    'SPEED 5
    SPEED 10
    MOVE G6A,101,  76, 145,  93, 101, 100
    MOVE G6D,101,  76, 145,  93, 101, 100
    MOVE G6B,  45,  29,  81, 100, 100, 101
    MOVE G6C,  45,  29,  81, 100, 100, 100
    WAIT

    '발목 앞으로 굽히기, 무릎 앞으로 굽히기
    'SPEED 5
    SPEED 10
    MOVE G6A,101,  126, 85,  113, 101, 100
    MOVE G6D,101,  126, 85,  113, 101, 100
    MOVE G6B,  45,  29,  81, 100, 100, 101
    MOVE G6C,  45,  29,  81, 100, 100, 100
    WAIT

    DELAY 100

    '무릎 더 굽히기
    'SPEED 5
    SPEED 10
    MOVE G6A,101,  158, 35,  113, 101, 100
    MOVE G6D,101,  158, 35,  113, 101, 100
    MOVE G6B,  45,  29,  81, 100, 100, 101
    MOVE G6C,  45,  29,  81, 100, 100, 100
    WAIT

    'GOTO RX_EXIT

    DELAY 200

    '무릎 더 굽히기2
    'SPEED 5
    SPEED 3
    MOVE G6A,101,  146, 35,  83, 101, 100
    MOVE G6D,101,  146, 35,  83, 101, 100
    MOVE G6B,  45,  29,  81, 100, 100, 101
    MOVE G6C,  45,  29,  81, 100, 100, 100
    WAIT

    'DELAY 100

    '넘어진 후 무릎 펴기

    'SPEED 3
    SPEED 10
    MOVE G6A, 101,  45, 106,  90, 103, 100
    MOVE G6D, 101,  45, 108,  90, 103, 100
    MOVE G6B,  35,  29,  81, 100, 100, 101
    MOVE G6C,  35,  29,  81, 100, 120, 100
    WAIT



    RETURN

    '******************************************	

터널_기어가기:


    HIGHSPEED SETON
    SPEED 8

    '기어가기 방향 휠 때 어깨 벌리는거(두번째인자) 변경 하면 됨
    '더 벌리는쪽으로 기울어짐

    '팔 앞으로
    ' MOVE G6A, 101,  45, 106,  90, 103, 100
    '    MOVE G6D, 101,  45, 106,  90, 103, 100
    '    MOVE G6B,  42,  28,  81, 100, 100, 101
    '    MOVE G6C,  42,  32,  81, 100, 120, 100
    '    WAIT

    '팔 앞으로 test
    MOVE G6A, 101,  45, 106,  90, 99, 100
    MOVE G6D, 101,  45, 106,  90, 103, 100
    MOVE G6B,  47,  26,  84, 100, 100, 101
    MOVE G6C,  47,  37,  83, 100, 120, 100
    WAIT

    HIGHSPEED SETOFF

    '팔 뒤로
    'SPEED 6
    '    MOVE G6A, 101,  45, 106,  90, 103, 100
    '    MOVE G6D, 101,  45, 106,  90, 103, 100
    '    MOVE G6B,  11,  28,  81, 100, 100, 101
    '    MOVE G6C,  15,  32,  81, 100, 120, 100
    '    WAIT

    '팔 뒤로 test
    SPEED 6
    MOVE G6A, 101,  45, 106,  90, 99, 100
    MOVE G6D, 101,  45, 106,  90, 103, 100
    MOVE G6B,  11,  26,  84, 100, 100, 101
    MOVE G6C,  11,  37,  83, 100, 120, 100
    WAIT

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN
        GOTO 터널_기어가기_일어나기

    ELSE
        GOTO 터널_기어가기
    ENDIF

    RETURN

    '******************************************	
    '******************************************	

터널_기어가기_일어나기:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    'GOSUB 자이로OFF

    GOSUB All_motor_Reset

    'DELAY 1000

    'SPEED 15
    '    MOVE G6A,100, 15,  70, 140, 100,
    '    MOVE G6D,100, 15,  70, 140, 100,
    '    MOVE G6B,20,  140,  15
    '    MOVE G6C,20,  140,  15
    '    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60,,20
    WAIT

    SPEED 6
    MOVE G6A,100, 145,  45, 130, 100,
    MOVE G6D,100, 145,  45, 130, 100,
    WAIT


    SPEED 8
    GOSUB All_motor_mode2
    GOSUB 안정화자세
    '넘어진확인 = 1

    'GOSUB 자이로ON

    RETURN

    '******************************************	
    '******************************************	
터널_시퀀스:

    GOSUB 터널_기어가기_준비자세

    DELAY 1000

    '12
    보행횟수=13
    GOSUB 터널_기어가기

    RETURN

    '******************************************	
    '******************************************	

계단덤블링:

    'GOSUB 자이로OFF

    '앉기
    'SPEED 15
    SPEED 10
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,130,  30,  85
    MOVE G6C,130,  30,  85, ,80
    WAIT



    '팔 앞으로
    SPEED 15
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,170,  30,  85
    MOVE G6C,170,  30,  85
    WAIT

    '무릎 올리기
    SPEED 3
    MOVE G6A,100, 155,  47, 140, 100, 100
    MOVE G6D,100, 155,  47, 140, 100, 100
    MOVE G6B,170,  30,  85
    MOVE G6C,170,  30,  85
    WAIT

    '땅에 팔붙이기
    SPEED 10	
    MOVE G6A, 100, 65,  155, 125, 100, 100
    MOVE G6D, 100, 65,  155, 125, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100
    WAIT

    '팔 천천히 내리기
    'SPEED 3
    '    MOVE G6A, 100, 65,  155, 125, 100, 100
    '    MOVE G6D, 100, 65,  155, 125, 100, 100
    '    MOVE G6B,155,  10, 100
    '    MOVE G6C,155,  10, 100
    '    WAIT

    '팔 천천히 내리기TEST
    SPEED 3
    MOVE G6A, 100, 10,  155, 125, 100, 100
    MOVE G6D, 100, 10,  155, 125, 100, 100
    MOVE G6B,152,  10, 100
    MOVE G6C,158,  10, 100
    WAIT

    '팔 걸리는거 올리기
    SPEED 3
    MOVE G6A, 100, 10,  155, 125, 100, 100
    MOVE G6D, 100, 10,  155, 125, 100, 100
    MOVE G6B,122,  10, 100
    MOVE G6C,125,  10, 100
    WAIT


    '팔 올리는 동작 2
    SPEED 10
    MOVE G6A, 100, 10,  155, 125, 100, 100
    MOVE G6D, 100, 10,  155, 125, 100, 100
    MOVE G6B,122,  70,  20
    MOVE G6C,125,  70,  20,,15
    WAIT




    '땅에 눕기
    SPEED 10
    MOVE G6A,100, 160, 110, 140, 100, 100
    MOVE G6D,100, 160, 110, 140, 100, 100
    MOVE G6B,140,  70,  20
    MOVE G6C,143,  70,  20,,15
    WAIT

    DELAY 500

    '왼발 뒤집기
    'SPEED 15
    '    MOVE G6A,100,  56, 110,  26, 100, 100
    '    MOVE G6D,100,  71, 177, 162, 100, 100
    '    MOVE G6B,172,  10, 100
    '    MOVE G6C,175,  10, 100
    '    WAIT

    '왼발 뒤집기TEST
    SPEED 15
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  61, 177, 162, 100, 100
    MOVE G6B,172,  10, 100
    MOVE G6C,175,  10, 100
    WAIT

    '오른발 뒤집기
    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  70, 120, 30, 100, 100
    MOVE G6B,172,  10, 100
    MOVE G6C,175,  10, 100
    WAIT

    '양발 모으기 '여기서 넘어가야 되는듯
    SPEED 15
    MOVE G6A,100,  55, 110,  15, 100, 100
    MOVE G6D,100,  55, 110,  15, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,190,  10, 100
    WAIT

    '발목 , 무릎 옮기기
    SPEED 15
    MOVE G6A,100,  60, 120,  15, 100, 100
    MOVE G6D,100,  60, 120,  15, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,190,  10, 100
    WAIT

    '무릎 발목 안쪽으로
    SPEED 15
    MOVE G6A,100,  100, 80,  15, 100, 100
    MOVE G6D,100,  100, 80,  15, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,190,  10, 100
    WAIT

    DELAY 1000

    '발목 앞쪽으로, 팔 젖히기
    'SPEED 15
    SPEED 12
    MOVE G6A,100,  130, 80,  15, 100, 100
    MOVE G6D,100,  130, 80,  15, 100, 100
    MOVE G6B,185,  130, 160
    MOVE G6C,190,  130, 160
    WAIT

    '발목 앞쪽으로, 팔 젖히기 2
    'SPEED 15
    SPEED 10 'TEST
    MOVE G6A,100,  150, 80,  15, 100, 100
    MOVE G6D,100,  150, 80,  15, 100, 100
    MOVE G6B,185,  140, 150
    MOVE G6C,190,  140, 150
    WAIT

    '발목 앞쪽으로 팔 젖히기 3
    SPEED 10
    MOVE G6A,100,  165, 80,  15, 100, 100
    MOVE G6D,100,  165, 80,  15, 100, 100
    MOVE G6B,185,  170, 120
    MOVE G6C,190,  170, 120
    WAIT

    '팔 앞으로
    SPEED 15
    MOVE G6A,100,  165, 80,  15, 100, 100
    MOVE G6D,100,  165, 80,  15, 100, 100
    MOVE G6B,70,  50, 60
    MOVE G6C,70,  50, 60
    WAIT

    '발목, 무릎 세우기
    SPEED 7
    MOVE G6A,100,  165, 100,  15, 100, 100
    MOVE G6D,100,  165, 100,  15, 100, 100
    MOVE G6B,40,  50, 60
    MOVE G6C,40,  50, 60
    WAIT

    '발목 , 무릎 세우기 2
    SPEED 7
    MOVE G6A,100,  145, 100,  55, 100, 100
    MOVE G6D,100,  145, 100,  55, 100, 100
    MOVE G6B,40,  50, 60
    MOVE G6C,40,  50, 60
    WAIT

    '발목 , 무릎 세우기 3' 여기서 거의 일어섬
    SPEED 7
    MOVE G6A,100,  115, 100,  95, 100, 100
    MOVE G6D,100,  115, 100,  95, 100, 100
    MOVE G6B,40,  50, 60
    MOVE G6C,40,  50, 60
    WAIT

    '    SPEED 13
    '    GOSUB 앉은자세

    SPEED 10
    GOSUB 안정화자세

    GOSUB 자이로ON

    RETURN
    '******************************************
    '*******************************
    '*************************************************
계단_기어가기:

    보행COUNT=0

    '시작자세TEST
    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,181,  16,  86
    MOVE G6C,185,  19,  86
    WAIT

    '중간자세
    SPEED 3
    MOVE G6A,100, 155,  28, 146, 100, 100
    MOVE G6D,100, 155,  28, 146, 100, 100
    MOVE G6B,181,  16,  86
    MOVE G6C,185,  19,  86
    WAIT



    '앞으로 엎어져서 손닿음  TEST
    SPEED 3
    MOVE G6A, 100, 159,  32, 146, 100, 100
    MOVE G6D, 100, 155,  32, 150, 100, 100
    MOVE G6B,181,  16,  86
    MOVE G6C,185,  19,  86
    WAIT	

    DELAY 1000

    GOSUB All_motor_mode2



    'SPEED 8
    SPEED 10
    PTP SETOFF
    PTP ALLOFF
    'HIGHSPEED SETON

    'GOTO 기어가기왼쪽턴_LOOP

계단_기어가기_LOOP:

    '왼쪽 발 들기
    'MOVE G6A, 100, 160,  55, 160, 100
    '    MOVE G6D, 100, 145,  75, 160, 100
    '    MOVE G6B, 175,  26,  68
    '    MOVE G6C, 190,  50,  65
    '    WAIT

    '왼쪽 발 들기test
    MOVE G6A, 100, 160,  45, 160, 100
    MOVE G6D, 100, 145,  75, 160, 100
    MOVE G6B, 175,  26,  68
    MOVE G6C, 190,  40,  15
    WAIT

    'ERX 4800, A, 기어가기_1
    'IF A = 8 THEN GOTO 기어가기_1
    'IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    'IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    GOTO 계단_기어가기_1

    'GOTO 기어가다일어나기

계단_기어가기_1:

    '왼쪽 다리 앞으로 가게 하기 ,오른팔도 앞으로
    'MOVE G6A, 100, 150,  50, 160, 100
    '    MOVE G6D, 100, 140, 120, 120, 100
    '    MOVE G6B, 160,  26,  72
    '    MOVE G6C, 190,  28,  70
    '    WAIT

    '왼쪽 다리 앞으로 가게 하기 ,오른팔도 앞으로test
    MOVE G6A, 100, 150,  50, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  26,  72
    MOVE G6C, 190,  28,  70
    WAIT

    '오른발 들기
    ' MOVE G6D, 100, 160,  55, 160, 100
    '    MOVE G6A, 100, 145,  75, 160, 100
    '    MOVE G6C, 175,  25,  70
    '    MOVE G6B, 190,  50,  40
    '    WAIT

    '오른발 들기 테스트
    MOVE G6D, 100, 160,  45, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 175,  28,  70
    MOVE G6B, 190,  40,  15
    WAIT

    'ERX 4800, A, 기어가기_2
    'IF A = 8 THEN GOTO 기어가기_2
    'IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    'IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    GOTO 계단_기어가기_2

    'GOTO 기어가다일어나기

계단_기어가기_2:
    '오른발 앞으로가서 닿기, 왼팔도 앞으로
    ' MOVE G6D, 100, 140,  80, 160, 100
    '    MOVE G6A, 100, 140, 120, 120, 100
    '    MOVE G6C, 160,  25,  70
    '    MOVE G6B, 190,  25,  70
    '    WAIT

    '오른발 앞으로가서 닿기, 왼팔도 앞으로 TEST
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 175,  27,  70
    MOVE G6B, 190,  29,  71
    WAIT


    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 계단_기어가다일어나기


    GOTO 문_기어가기_LOOP


계단_기어가다일어나기:
    PTP SETON		
    PTP ALLON
    SPEED 15
    'HIGHSPEED SETOFF


    MOVE G6A, 100, 150,  80, 150, 100
    MOVE G6D, 100, 150,  80, 150, 100
    MOVE G6B,185,  40, 60
    MOVE G6C,185,  40, 60
    WAIT

    GOSUB Leg_motor_mode3

    '발목 띄우고 있음 test1
    SPEED 10	
    MOVE G6A,  100, 165,  45, 162, 100
    MOVE G6D,  100, 165,  45, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '발 틀기
    SPEED 10	
    MOVE G6A,  77, 160,  47, 162, 135
    MOVE G6D,  80, 165,  45, 162, 135
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '무릎접기
    SPEED 10	
    MOVE G6A,  76, 165,  37, 162, 135
    MOVE G6D,  80, 165,  35, 162, 135
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '허리 접기
    SPEED 10	
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT

    '발목세우기
    SPEED 10	
    MOVE G6A,  70, 145,  23, 162, 135
    MOVE G6D,  70, 145,  23, 162, 135
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT

    '발 조금 모으기

    SPEED 10	
    MOVE G6A,  80, 150,  23, 162, 115
    MOVE G6D,  80, 150,  23, 162, 115
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT


    '발 모으기
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    SPEED 10
    GOSUB 안정화자세

    RETURN




    '******************************************
    '계단_CLOSE걷기_시작:
    '
    '    보행COUNT=0
    '
    '    보행속도=7
    '    ''안정화자세
    '    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90
    '    '    MOVE G6C,100,  35,  90
    '    '    WAIT
    '
    '    SPEED 보행속도
    '    '왼발 앞으로
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    GOTO 계단_CLOSE걷기_1
    '
    '    '******************************************
    '    '******************************************
    '계단_CLOSE걷기_1:
    '
    '    SPEED 보행속도
    '    '오른발 앞으로
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  70, 145,  103, 101, 100
    '    WAIT
    '
    '    SPEED 보행속도
    '    '왼발 앞으로
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    보행COUNT = 보행COUNT + 1
    '    IF 보행COUNT > 보행횟수 THEN
    '        GOTO 계단_CLOSE걷기_멈춤
    '
    '    ELSE
    '        GOTO 계단_CLOSE걷기_1
    '
    '    ENDIF
    '
    '
    '    '******************************************
    '    '******************************************
    '계단_CLOSE걷기_멈춤:
    '
    '    SPEED 보행속도
    '    '오른발 앞으로
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  103, 101, 100
    '    WAIT
    '
    '    SPEED 5
    '    '안정화자세
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '
    '    RETURN

    '******************************************
    '******************************************

계단시퀀스:

    ' GOSUB 걷기_FAST_시작
    '    '4
    '    GOSUB 걷기_FAST_연속
    '    GOSUB 걷기_FAST_연속
    '    GOSUB 걷기_FAST_연속
    '    GOSUB 걷기_FAST_연속
    '    GOSUB 걷기_FAST_멈춤

    ' 보행횟수=5
    '    GOSUB 계단_CLOSE걷기_시작
    '
    DELAY 500

    GOSUB 계단덤블링

    RETURN

    '보행횟수=10
    '
    '    GOSUB 계단_기어가기
    '
    '    'GOSUB 왼쪽턴60
    '    '    GOSUB 왼쪽턴60
    '    '
    '    '    GOSUB 왼쪽턴_LONG
    '
    '    RETURN

    '******************************************	
    '**********************************************
    '계단_ATTACH
계단_CLOSE걷기_시작:

    보행COUNT=0

    '보행속도=7
    보행속도=9
    ''안정화자세
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,100,  35,  90
    '    WAIT

    SPEED 보행속도
    '왼발 앞으로
    MOVE G6A,98,  71, 145,  108, 101, 100
    MOVE G6D,98,  74, 145,  93, 101, 100
    WAIT

    GOTO 계단_CLOSE걷기_1

    '******************************************
    '******************************************
계단_CLOSE걷기_1:

    SPEED 보행속도
    '오른발 앞으로
    MOVE G6A,98,  74, 145,  93, 101, 100
    MOVE G6D,98,  71, 145,  108, 101, 100
    WAIT

    SPEED 보행속도
    '왼발 앞으로
    MOVE G6A,98,  71, 145,  108, 101, 100
    MOVE G6D,98,  74, 145,  93, 101, 100
    WAIT

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN
        GOTO 계단_CLOSE걷기_멈춤

    ELSE
        GOTO 계단_CLOSE걷기_1

    ENDIF

    RETURN
    '******************************************
    '******************************************
계단_CLOSE걷기_멈춤:

    SPEED 보행속도
    '오른발 앞으로
    MOVE G6A,98,  71, 145,  103, 101, 100
    MOVE G6D,98,  74, 145,  103, 101, 100
    WAIT

    SPEED 15
    '안정화자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN



    '******************************************

    'Down
DOWN:

    SPEED 15

    '원래는 20이였음

    '발밑보기
    MOVE G6B,,  , , , , 101
    MOVE G6C,,  ,  , , 25,
    WAIT

    RETURN

    '******************************************
    '나중에 oblique필요한면 값 수정
OBLIQUE:

    SPEED 15

    MOVE G6B,,  , , , , 101
    MOVE G6C,,  ,  , , 66,
    WAIT


    RETURN

    '******************************************
UP:

    SPEED 15

    'UP
    MOVE G6B,,  ,  , , , 101
    MOVE G6C,,  ,  , , 98,
    WAIT

    RETURN

    '******************************************

    'GAS밸브용

FRONT:

    SPEED 15

    'FRONT
    MOVE G6B,,  ,  , , ,101
    MOVE G6C,,  ,  , ,72
    WAIT

    RETURN

    '******************************************
왼쪽보기:
    '왼쪽보기
    ' MOVE G6B,20,  ,  , , , 40
    '    MOVE G6C,,  ,  , , 52,
    '    WAIT

    SPEED 15

    MOVE G6B,,  ,  , , , 55
    MOVE G6C,,  ,  , , 53,
    WAIT

    RETURN

    '******************************************
오른쪽보기:
    '오른쪽보기

    SPEED 15

    MOVE G6B,, ,  , , , 145
    MOVE G6C,,  ,  , , 53,
    WAIT

    RETURN

    '**********************************************
UP_왼쪽보기:
    SPEED 15

    MOVE G6B,,  ,  , , , 50
    MOVE G6C,,  ,  , , 98,
    WAIT

    RETURN

    '**********************************************
UP_오른쪽보기:
    SPEED 15

    MOVE G6B,,  ,  , , , 150
    MOVE G6C,,  ,  , , 98,
    WAIT

    RETURN

    '**********************************************

장애물차기:

    '안정화자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT

    SPEED 4
    '왼쪽으로 무게 중심 옮기기(왼발목,오른발목 왼쪽으로 기울이기)
    MOVE G6A, 108,  76, 146,  93,  96
    MOVE G6D,  88,  74, 144,  95, 110
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT

    SPEED 10
    '오른발 들기
    MOVE G6A,112,  79, 147,  93,  96,100
    MOVE G6D, 90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 10
    '오른발 차기
    MOVE G6A,112,  76, 147,  93,  96,100
    MOVE G6D, 90, 80, 120, 130, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    RETURN

    '******************************************
    '******************************************
장애물_오른쪽_옆으로_팔들기:

    SPEED 10
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  30,  80,
    MOVE G6C,120,  30,  80
    WAIT

    DELAY 500

    HIGHSPEED SETON
    SPEED 8
    '오른쪽 옆으로 팔들기
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  30,  80,
    MOVE G6C,120,  100,  80
    WAIT

    SPEED 8
    '오른쪽 팔 들었던 내리기
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  30,  80,
    MOVE G6C,120,  30,  80
    WAIT

    HIGHSPEED SETOFF
    DELAY 500	

    '안정화자세(일어나기)
    SPEED 7
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT

    RETURN

    '******************************************
    '******************************************
장애물_왼쪽_옆으로_팔들기:

    SPEED 10
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  30,  80,
    MOVE G6C,120,  30,  80
    WAIT

    DELAY 500

    HIGHSPEED SETON
    SPEED 8
    '왼쪽 옆으로 팔들기
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  100,  80,
    MOVE G6C,120,  30,  80
    WAIT

    SPEED 8
    '왼쪽 팔 들었던 거 내리기
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  30,  80,
    MOVE G6C,120,  30,  80
    WAIT

    HIGHSPEED SETOFF
    DELAY 500

    '안정화자세(일어나기)
    SPEED 7
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT

    RETURN

    '******************************************
    '******************************************
    '
    '장애물_일어서서_왼쪽앞치우기:
    '
    '    ''안정화자세
    '    '    SPEED 7
    '    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,100,  35,  90
    '    '    WAIT
    '
    '    '무릎 굽히기
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '
    '    '왼팔 뻗기
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,140, 15,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    HIGHSPEED SETON
    '
    '    '왼팔꿈치 움직이기
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,140, 10,  30,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    HIGHSPEED SETOFF
    '
    '    '왼팔꿈치 제자리
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,140, 15,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    '안정화자세
    '    SPEED 7
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    RETURN
    '
    '    '******************************************
    '    '*************************************
    '장애물_일어서서_오른쪽앞치우기:
    '
    '    '무릎 굽히기
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '
    '    '오른팔 뻗기
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 15,  90
    '    WAIT
    '
    '    HIGHSPEED SETON
    '
    '    '오른팔꿈치 움직이기
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 10,  30
    '    WAIT
    '
    '    HIGHSPEED SETOFF
    '
    '    '오른팔꿈치 제자리
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 15,  90
    '    WAIT
    '
    '    '안정화자세
    '    SPEED 7
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    RETURN

    '******************************************
    '*************************************
    '장애물_땅_왼쪽앞_치우기:
    '
    '    '무릎 굽히기
    '    SPEED 5
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    DELAY 1000
    '
    '    '왼팔 뻗기
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,140, 15,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    HIGHSPEED SETON
    '
    '    '왼팔꿈치 움직이기
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,140, 10,  30,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    HIGHSPEED SETOFF
    '
    '    '왼팔꿈치 제자리
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,140, 15,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    '안정화자세
    '    SPEED 7
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    RETURN
    '
    '******************************************
장애물_다리벌리고_땅_왼쪽앞_치우기:

    '무릎 굽히기
    SPEED 5
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,100,  23,  90,
    MOVE G6C,100,  23,  90, ,20
    WAIT

    DELAY 300

    '왼팔 뻗기
    SPEED 15
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,140, 50,  90,
    MOVE G6C,100,  23,  90
    WAIT


    SPEED 5
    '발 모으기
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  65,  85
    MOVE G6C,130,  50,  85
    WAIT

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT


    '발 조금 모으기
    'test
    SPEED 5	
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  80, 150,  25, 162, 115
    MOVE G6B,160, 65,  75,
    MOVE G6C,120,  50,  90
    WAIT

    '허리 접기
    SPEED 10	
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,179, 65,  70,
    MOVE G6C,120,  50,  90
    WAIT

    '팔 접기
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,159, 30,  75,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETON

    '왼팔꿈치 움직이기
    '170
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,169, 10,  65,
    '    MOVE G6C,120, 50,  90
    '    WAIT

    '왼팔꿈치 움직이기test
    '170
    SPEED 10	
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,170, 10,  30,
    MOVE G6C,120,  50,  90
    WAIT

    '왼팔꿈치 움직이기test2
    '170
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 25,  30,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    DELAY 500

    '왼팔꿈치 움직이기 밖으로빼기
    '170
    SPEED 10
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,170, 65,  70,
    MOVE G6C,120,  50,  90
    WAIT


    '왼팔꿈치 움직이기
    '160
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 10,  60,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETOFF

    '발 조금 모으기

    SPEED 5
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  80, 150,  25, 162, 115
    MOVE G6B,170, 65,  70,
    MOVE G6C,120,  50,  90
    WAIT

    '발 모으기
    SPEED 5
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85
    MOVE G6C,130,  50,  85,,20
    WAIT

    '안정화자세
    SPEED 5
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,100,  35,  90
    WAIT

    RETURN

    '******************************************
장애물_다리벌리고_땅_오른쪽앞_치우기:

	'

    '무릎 굽히기
    SPEED 5
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,100,  65,  35,
    MOVE G6C,100,  65,  35, ,20
    WAIT
    
    '팔 앞으로 
    SPEED 5
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,90,  65,  30,
    MOVE G6C,140,  65,  30, ,20
    WAIT

    DELAY 300

    '왼팔 뻗기
    SPEED 15
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6C,140, 25,  90,
    MOVE G6B,90,  35,  90
    WAIT

    DELAY 300


    SPEED 5
    '발 모으기
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6C,140, 25,  90,
    MOVE G6B,90,  35,  90
    WAIT

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    DELAY 300

    '발 조금 모으기
    'test
    SPEED 5	
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  83, 150,  25, 162, 115
    MOVE G6C,160, 25,  90,
    MOVE G6B,90,  35,  90
    WAIT

    '허리 접기
    'SPEED 10	
    SPEED 5
    MOVE G6A,  70, 165,  25, 152, 135
    MOVE G6D,  70, 165,  25, 152, 135
    MOVE G6C,179, 65,  70,
    MOVE G6B,90,  45,  90
    WAIT



    '팔 접기
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,159, 30,  75,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETON

    '왼팔꿈치 움직이기
    '170
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,169, 10,  65,
    '    MOVE G6C,120, 50,  90
    '    WAIT

    '왼팔꿈치 움직이기test
    '170
    SPEED 10	
    MOVE G6A,  70, 165,  25, 152, 135
    MOVE G6D,  70, 165,  25, 152, 135
    MOVE G6C,170, 10,  30,
    MOVE G6B,90,  45,  90
    WAIT

    '왼팔꿈치 움직이기test2
    '170
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 25,  30,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    DELAY 500

    '왼팔꿈치 움직이기 밖으로빼기
    '170
    SPEED 10
    MOVE G6A,  70, 165,  25, 152, 135
    MOVE G6D,  70, 165,  25, 152, 135
    MOVE G6C,170, 65,  70,
    MOVE G6B,90,  45,  90
    WAIT


    '왼팔꿈치 움직이기
    '160
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 10,  60,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETOFF

    '발 조금 모으기

    SPEED 5
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  83, 150,  25, 162, 115
    MOVE G6C,170, 65,  70,
    MOVE G6B,115,  50,  90
    WAIT

    '발 모으기
    SPEED 5
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,120,  40,  85
    MOVE G6C,120,  40,  85,,20
    WAIT

    '안정화자세
    SPEED 5
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,100,  35,  90
    WAIT

    RETURN




    '*************************************
    '장애물_땅_오른쪽앞_치우기:
    '
    '    '무릎 굽히기
    '    SPEED 5
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    DELAY 1000
    '
    '    '왼팔 뻗기
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 15,  90
    '    WAIT
    '
    '    HIGHSPEED SETON
    '
    '    '왼팔꿈치 움직이기
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 10,  30
    '    WAIT
    '
    '    HIGHSPEED SETOFF
    '
    '    '왼팔꿈치 제자리
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 15,  90
    '    WAIT
    '
    '    '안정화자세
    '    SPEED 7
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    RETURN

    '******************************************
    '*************************************
다리걷기_시작:
    보행COUNT = 0
    '보행속도=15
    보행속도 = 7
    좌우속도= 6
    '좌우속도 = 6

    넘어진확인 = 0
    다리걷기연속체크=0

    GOSUB Leg_motor_mode3

    '안정화자세
    ' MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT

    '왼발로 무게중심 옮기기
    SPEED 4

    'A,-12,-2,-1,+2,+9
    'D,+12,0,+1,0,-5
    MOVE G6A, 86,  74, 144,  95, 114
    MOVE G6D,110,  76, 146,  93,  96
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    'SPEED 10
    SPEED 8

    '왼발로 무게중심 더 옮기기 		
    'A,+4,+16,-24,+10,
    'D,+1,0,+1,0,0
    'MOVE G6A, 90, 90, 120, 105, 110,100
    '    MOVE G6D,111,  76, 147,  93,  96,100
    '    MOVE G6B,90
    '    MOVE G6C,110
    '    WAIT

    '왼발로 무게중심 더 옮기기 	test	
    'A,+4,+16,-24,+10,
    'D,+1,0,+1,0,0
    MOVE G6A, 90, 90, 120, 105, 114,100
    MOVE G6D,112,  76, 147,  93,  96,100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    RETURN

    '*******************************
다리걷기_연속:

    IF 다리걷기연속체크=1 THEN

다리걷기_4:

        '왼발로 무게 중심 옮기기
        'A,0,0,-1,0,0
        'D,+4,-10,-25,+36,0
        'MOVE G6A,90, 90, 120, 105, 110,100
        '        MOVE G6D,110,  76, 146,  93,  96,100
        '        MOVE G6B, 90
        '        MOVE G6C,110
        '        WAIT

        '왼발로 무게 중심 옮기기TEST
        'A,0,0,-1,0,0
        'D,+4,-10,-25,+36,0
        'MOVE G6A,90, 90, 120, 105, 112,100
        '        MOVE G6D,110,  76, 146,  93,  96,100
        '        MOVE G6B, 90
        '        MOVE G6C,110
        '        WAIT

        '왼발로 무게 중심 옮기기TEST(찐 )
        'A,0,0,-1,0,0
        'D,+4,-10,-25,+36,0
        MOVE G6A,90, 90, 120, 105, 113,100
        MOVE G6D,111,  76, 146,  93,  96,100
        MOVE G6B, 90
        MOVE G6C,110
        WAIT

    ENDIF

다리걷기_1:

    다리걷기연속체크=1

    '왼발 앞으로
    '다리걷기시작 맨 마지막 동작하고 비교한거
    'A,-4,-34,+25,+10,0
    'D,+1,0,0,0,0
    'SPEED 보행속도
    '    MOVE G6A, 86,  56, 145, 115, 112
    '    MOVE G6D,110,  76, 147,  93,  96
    '    WAIT

    '왼발 앞으로TEST (찐 )
    '다리걷기시작 맨 마지막 동작하고 비교한거
    'A,-4,-34,+25,+10,0
    'D,+1,0,0,0,0
    'HIGHSPEED SETON
    '    SPEED 보행속도
    ' MOVE G6A, 86,  54, 145, 115, 112
    '    MOVE G6D,111,  76, 147,  93,  96
    '    WAIT

    '왼발 앞으로TEST2
    '다리걷기시작 맨 마지막 동작하고 비교한거
    'A,-4,-34,+25,+10,0
    'D,+1,0,0,0,0
    HIGHSPEED SETON
    SPEED 보행속도
    MOVE G6A, 91,  55, 145, 115, 114
    MOVE G6D,110,  76, 147,  93,  96
    WAIT

    HIGHSPEED SETOFF

    '왼발 내딛기(찐)
    'A,+23,+20,+2,-22,-14
    'D,-22,+24,+2,-24,+14
    ' SPEED 좌우속도
    '    GOSUB Leg_motor_mode3
    '    MOVE G6A,109,  76, 147, 93,  96
    '    MOVE G6D,88, 100, 145,  69, 111
    '    WAIT

    '왼발 내딛기 TEST
    'A,+23,+20,+2,-22,-14
    'D,-22,+24,+2,-24,+14
    'SPEED 좌우속도
    '    GOSUB Leg_motor_mode3
    '    MOVE G6A,107,  76, 147, 93,  96
    '    MOVE G6D,90, 100, 145,  69, 111
    '    WAIT

    '왼발 내딛기 TEST2
    'A,+23,+20,+2,-22,-14
    'D,-22,+24,+2,-24,+14
    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    MOVE G6A,107,  76, 147, 93,  97
    MOVE G6D,90, 100, 145,  69, 112
    WAIT

    HIGHSPEED SETON
    SPEED 보행속도

    ' GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF

    '**********

다리걷기_2:

    '오른발로 무게중심 옮기기
    'A,0,0,0,0,0
    'D,+3,-10,-25,+36,0
    MOVE G6A,107,  76, 147,  93, 97,100
    MOVE G6D,92, 90, 120, 105, 112,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT


다리걷기_3:

    '오른발 앞으로
    SPEED 보행속도
    'A,-1,0,0,0,0
    'D,-4,-34,+25,+10,0
    MOVE G6D, 89,  56, 145, 115, 111
    MOVE G6A,107,  76, 147,  93,  97
    WAIT

    HIGHSPEED SETOFF

    '오른발 내딛기
    'A,-22,+24,-2,-24,+14
    'D,+23,+20,+2,-22,-14
    'SPEED 좌우속도
    '    MOVE G6D,110,  76, 147, 93,  96
    '    MOVE G6A,86, 100, 145,  69, 110
    '    WAIT

    '오른발 내딛기  TEST
    'A,-22,+24,-2,-24,+14
    'D,+23,+20,+2,-22,-14
    ' SPEED 좌우속도
    ' MOVE G6D,110,  76, 147, 93,  96
    '    MOVE G6A,86, 100, 145,  69, 112
    '    WAIT

    '오른발 내딛기  TEST2
    'A,-22,+24,-2,-24,+14
    'D,+23,+20,+2,-22,-14
    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  95
    MOVE G6A,86, 100, 145,  69, 113
    WAIT

    HIGHSPEED SETON

    SPEED 보행속도

    'GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF

    RETURN

다리걷기_멈춤:

    '왼발 오른발하고 맞추기
    MOVE G6A, 90, 100, 100, 115, 110,100
    MOVE G6D,112,  76, 146,  93,  96,100
    MOVE G6B,90
    MOVE G6C,110
    WAIT
    HIGHSPEED SETOFF
    SPEED 8

    '왼발 그 자리에 내려놓기
    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 152,  91, 106,100
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT	
    SPEED 2
    GOSUB 안정화자세

    RETURN

    '******************************************

    '******************************************
    '******************************************
문_팔굽히기:

    '팔굽히기
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  185,  190
    WAIT

    RETURN

    '******************************************
    '******************************************

문_팔펴기_20:
    '팔굽히기
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  185,  150
    WAIT

    RETURN

    '******************************************
    '******************************************

문_팔펴기_40:
    '팔굽히기
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  185,  110
    WAIT

    RETURN

    '******************************************
    '******************************************
문_팔펴기_60:
    '팔굽히기
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  185,  70
    WAIT

    RETURN

    '******************************************
    '******************************************
문_팔펴기_80:
    '팔굽히기
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  145,  90
    WAIT

    RETURN

    '******************************************
    '******************************************
문_팔뒤로하기:
    '팔굽히기
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  55,  10
    WAIT

    RETURN

    '******************************************
    '******************************************

문_팔들기:

    SPEED 5
    '팔옆으로 먼저 펴기
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,130,  35,  90
    MOVE G6C,130,  35,  90
    WAIT

    SPEED 5
    '팔꿈치 안으로
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,130,  35,  20
    MOVE G6C,130,  35,  20
    WAIT

    SPEED 5
    '팔올리기
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,170,  35,  25
    MOVE G6C,170,  35,  25
    WAIT

    SPEED 5
    '팔앞으로
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,170,  20,  90
    MOVE G6C,170,  17,  86
    WAIT

    RETURN

    '******************************************
    '******************************************
문_CLOSE걷기_시작:
    보행COUNT=0

    '왼발 앞으로
    MOVE G6A,98,  70, 145,  103, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    WAIT

    GOTO 문_CLOSE걷기_1

    '******************************************
    '******************************************
문_CLOSE걷기_1:

    '오른발 앞으로
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  70, 145,  103, 101, 100
    WAIT

    '왼발 앞으로
    MOVE G6A,98,  70, 145,  103, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    WAIT

    'IF 문시퀀스구분용체크=1 THEN
    '
    '        보행COUNT = 보행COUNT + 1
    '        IF 보행COUNT > 보행횟수 THEN  RETURN
    '
    '        GOTO 문_CLOSE걷기_1	
    '
    '    ENDIF

    GOTO 문_CLOSE걷기_멈춤


    '******************************************
    '******************************************
문_CLOSE걷기_멈춤:

    '오른발 앞으로
    MOVE G6A,98,  70, 145,  103, 101, 100
    MOVE G6D,98,  76, 145,  103, 101, 100
    WAIT

    '안정화자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN

    '******************************************
    '******************************************

문_오른쪽턴_LONG:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    '안정화자세(얘는 있어야함 턴이라서)
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN

    '******************************************
    '******************************************
    '문_시퀀스:

    'GOSUB 문_팔들기

    ' '문_CLOSE걷기_구분용
    '    문시퀀스구분용체크=1
    '
    '    GOSUB 문_팔굽히기
    '
    '    '문 _걷기 시퀀스
    '    보행횟수=20
    '    GOSUB 문_CLOSE걷기_시작
    '    GOSUB 문_CLOSE걷기_1
    '    GOSUB 문_CLOSE걷기_멈춤
    '
    '    'DELAY 1000
    '
    '    '1
    '    GOSUB 문_팔펴기_20
    '
    '    '문 _걷기 시퀀스
    '    보행횟수=10
    '    GOSUB 문_CLOSE걷기_시작
    '    GOSUB 문_CLOSE걷기_1
    '    GOSUB 문_CLOSE걷기_멈춤
    '
    '    'DELAY 1000
    '
    '    '2
    '    GOSUB 문_팔펴기_40
    '
    '    '문 _걷기 시퀀스
    '    보행횟수=10
    '    GOSUB 문_CLOSE걷기_시작
    '    GOSUB 문_CLOSE걷기_1
    '    GOSUB 문_CLOSE걷기_멈춤
    '
    '    'DELAY 1000
    '
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '
    '    '3
    '    GOSUB 문_팔펴기_60
    '
    '    '문 _걷기 시퀀스
    '    보행횟수=10
    '    GOSUB 문_CLOSE걷기_시작
    '    GOSUB 문_CLOSE걷기_1
    '    GOSUB 문_CLOSE걷기_멈춤
    '
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '
    '    'DELAY 1000
    '
    '    '4
    '    GOSUB 문_팔펴기_80
    '
    '    '문 _걷기 시퀀스
    '    보행횟수=10
    '    GOSUB 문_CLOSE걷기_시작
    '    GOSUB 문_CLOSE걷기_1
    '    GOSUB 문_CLOSE걷기_멈춤
    '
    '    'DELAY 1000
    '
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '    GOSUB 문_오른쪽턴_LONG
    '    DELAY 100
    '
    '    '문 _걷기 시퀀스
    '    보행횟수=30
    '    GOSUB 문_CLOSE걷기_시작
    '    GOSUB 문_CLOSE걷기_1
    '    GOSUB 문_CLOSE걷기_멈춤
    '
    '    'DELAY 1000
    '
    '    GOSUB 문_팔뒤로하기
    '
    '    '문 _걷기 시퀀스
    '    보행횟수=5
    '    GOSUB 문_CLOSE걷기_시작
    '    GOSUB 문_CLOSE걷기_1
    '    GOSUB 문_CLOSE걷기_멈춤
    '
    '    'DELAY 2000
    '
    '    GOSUB 안정화자세
    '
    '    RETURN

    '*******************************
    '*************************************************
문_기어가기:

    보행COUNT=0

    '시작자세TEST
    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,181,  16,  86
    MOVE G6C,185,  19,  86
    WAIT

    '중간자세
    SPEED 3
    MOVE G6A,100, 155,  28, 146, 100, 100
    MOVE G6D,100, 155,  28, 146, 100, 100
    MOVE G6B,181,  16,  86
    MOVE G6C,185,  19,  86
    WAIT



    '앞으로 엎어져서 손닿음  TEST
    SPEED 3
    MOVE G6A, 100, 155,  35, 147, 98
    MOVE G6D, 100, 155,  32, 150, 100
    MOVE G6B,181,  16,  86
    MOVE G6C,185,  19,  86
    WAIT	

    DELAY 1000

    GOSUB All_motor_mode2



    SPEED 8
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON

    'GOTO 기어가기왼쪽턴_LOOP

문_기어가기_LOOP:

    '왼쪽 발 들기
    MOVE G6A, 100, 160,  55, 160, 100
    MOVE G6D, 100, 145,  75, 160, 100
    MOVE G6B, 175,  32,  72
    MOVE G6C, 190,  50,  45
    WAIT

    'ERX 4800, A, 기어가기_1
    'IF A = 8 THEN GOTO 기어가기_1
    'IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    'IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    GOTO 문_기어가기_1

    'GOTO 기어가다일어나기

문_기어가기_1:
    '왼쪽 다리 앞으로 가게 하기 ,오른팔도 앞으로
    'MOVE G6A, 100, 150,  70, 160, 100
    '    MOVE G6D, 100, 140, 120, 120, 100
    '    MOVE G6B, 160,  25,  70
    '    MOVE G6C, 190,  25,  70
    '    WAIT

    '왼쪽 다리 앞으로 가게 하기 ,오른팔도 앞으로 테스트
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  30,  72
    MOVE G6C, 190,  28,  70
    WAIT

    '오른발 들기
    ' MOVE G6D, 100, 160,  55, 160, 100
    '    MOVE G6A, 100, 145,  75, 160, 100
    '    MOVE G6C, 175,  25,  70
    '    MOVE G6B, 190,  50,  40
    '    WAIT

    '오른발 들기 테스트
    MOVE G6D, 100, 160,  55, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 175,  28,  70
    MOVE G6B, 190,  50,  41
    WAIT

    'ERX 4800, A, 기어가기_2
    'IF A = 8 THEN GOTO 기어가기_2
    'IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    'IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    GOTO 문_기어가기_2

    'GOTO 기어가다일어나기

문_기어가기_2:
    '오른발 앞으로가서 닿기, 왼팔도 앞으로
    ' MOVE G6D, 100, 140,  80, 160, 100
    '    MOVE G6A, 100, 140, 120, 120, 100
    '    MOVE G6C, 160,  25,  70
    '    MOVE G6B, 190,  25,  70
    '    WAIT

    '오른발 앞으로가서 닿기, 왼팔도 앞으로 TEST
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 175,  27,  70
    MOVE G6B, 190,  34,  74
    WAIT


    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 문_기어가다일어나기


    GOTO 문_기어가기_LOOP


문_기어가다일어나기:
    PTP SETON		
    PTP ALLON
    SPEED 15
    HIGHSPEED SETOFF


    MOVE G6A, 100, 150,  80, 150, 100
    MOVE G6D, 100, 150,  80, 150, 100
    MOVE G6B,185,  40, 60
    MOVE G6C,185,  40, 60
    WAIT

    GOSUB Leg_motor_mode3

    '발목 띄우고 있음 test1
    SPEED 5
    MOVE G6A,  100, 160,  45, 162, 100
    MOVE G6D,  100, 165,  45, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    DELAY 500

    '발 틀기
    SPEED 5	
    MOVE G6A,  77, 160,  47, 162, 135
    MOVE G6D,  80, 165,  45, 162, 135
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '무릎접기
    SPEED 5	
    MOVE G6A,  73, 165,  37, 162, 135
    MOVE G6D,  76, 165,  35, 162, 135
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '허리 접기
    SPEED 5
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT

    '발목세우기
    SPEED 5
    MOVE G6A,  70, 145,  23, 162, 135
    MOVE G6D,  70, 145,  23, 162, 135
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT

    '발 조금 모으기

    SPEED 5
    MOVE G6A,  80, 150,  23, 162, 115
    MOVE G6D,  80, 150,  23, 162, 115
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT

    DELAY 500

    '발 모으기
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    SPEED 5
    GOSUB 안정화자세

    RETURN



    '****************************************************************
    '******************************************	
문_시퀀스:

    '옛날 문 시퀀스
    'GOSUB 문_달리기_시작
    '    '12
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_연속
    '    GOSUB 문_달리기_멈춤_1
    '    GOSUB 문다음직각턴

    '방법2(기어가기)
    '보행횟수=10
    '
    '    GOSUB 문_기어가기
    '    DELAY 300
    '    GOSUB 문다음직각턴


    '방법3(옆으로가기)
    ' GOSUB 왼쪽턴60
    '    GOSUB 왼쪽턴60
    '
    '    DELAY 1000
    'GOSUB 왼쪽턴_LONG

    GOSUB UP
    DELAY 500

    GOSUB 오른쪽옆으로70
    GOSUB 오른쪽옆으로70
    GOSUB 오른쪽옆으로70
    GOSUB 오른쪽옆으로70
    GOSUB 오른쪽옆으로70
    GOSUB 오른쪽옆으로70
    GOSUB 오른쪽옆으로70
    GOSUB 오른쪽옆으로70
    GOSUB 오른쪽옆으로70
    GOSUB 오른쪽옆으로70
    GOSUB 오른쪽옆으로70
    RETURN

    '******************************************	
문다음직각턴:

    GOSUB 왼쪽턴60
    DELAY 100
    GOSUB 왼쪽턴60
    'DELAY 100
    'GOSUB 왼쪽턴_LONG
    RETURN

    '******************************************	

넘어짐확인_시퀀스:
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0	
        'GOTO MAIN_2
    ENDIF

    RETURN

    '******************************************
    '******************************************

    'ERX_WAIT:
    '
    '    ERX 4800, A, ERX_WAIT
    '    RETURN

    '******************************************
    '******************************************


    '******************************************

    '이 MAIN은 라파이와 제어기 처음 통신연결 확인하기 위한것

    '******************************************
MAIN: '라벨설정	


    '라파이에서 제어기로 연결확인 신호 보냄
    ERX 4800, A, MAIN
    '라파이로 연결 확인 됐다고 응답을 보냄
    ETX 4800, 254
    PRINT "SOUND 11 !" '안녕

    '******************************************

    '이 MAIN_2는 라파이에서의 로봇 동작 수신을 위한 것

    '******************************************

MAIN_2:

    '***********************************
    '일단 주석처리해주었음

    'GOSUB 앞뒤기울기측정
    'GOSUB 좌우기울기측정
    'GOSUB 적외선거리센서확인

    '라파이에서 동작 명령 수신
    ERX 4800,A,MAIN_2

    A_Old= A

    '========================================

    '넘어짐확인

    '========================================

    ''동작 실행전에 넘어짐 확인

    'GOSUB 넘어짐확인_시퀀스

    '========================================

    '일반 걷기동작 (FAST)

    '========================================


    IF A_Old= 100  THEN
        'GOSUB 걷기_SHORT_시작
        'GOSUB 걷기_FAST_시작
        'GOSUB 다리걷기_시작
        GOSUB 전진달리기_시작

    ELSEIF A_Old = 101 THEN    	
        'GOSUB 걷기_SHORT_멈춤
        'GOSUB 걷기_FAST_멈춤
        'GOSUB 다리걷기_멈춤

        IF 전진달리기연속분기체크=1 THEN
            GOSUB 전진달리기_멈춤_0
        ELSEIF 전진달리기연속분기체크=0 THEN
            GOSUB 전진달리기_멈춤_1
        ENDIF

        '직진걸음
    ELSEIF A_Old = 102 THEN
        '걸음방향=2
        'GOSUB 걷기_SHORT_연속
        'GOSUB 걷기_FAST_연속
        'GOSUB 다리걷기_연속
        GOSUB 전진달리기_연속

        '왼쪽작은휨걸음
    ELSEIF A_Old = 103 THEN    	
        걸음방향=1
        GOSUB 걷기_SHORT_연속
        'GOSUB 걷기_FAST_연속
        '오른쪽작은휨걸음
    ELSEIF A_Old = 104 THEN    	
        걸음방향=3
        GOSUB 걷기_SHORT_연속
        'GOSUB 걷기_FAST_연속
        '   '왼쪽큰휨걸음
    ELSEIF A_Old = 105 THEN    	
        걸음방향=4
        GOSUB 걷기_SHORT_연속
        'GOSUB 걷기_FAST_연속
        'GOSUB 왼쪽턴_SHORT

        '오른쪽큰휨걸음
    ELSEIF A_Old = 106 THEN    	
        걸음방향=6
        GOSUB 걷기_SHORT_연속
        'GOSUB 오른쪽턴_SHORT

        'FAST걸음( 계단앞에서만 씀 )
    ELSEIF A_Old = 123 THEN    	
        'GOSUB 걷기_FAST_시작
        'GOSUB 걷기_FAST_시퀀스
        보행횟수 =3
        GOSUB 계단_CLOSE걷기_시작
        GOSUB 계단_CLOSE걷기_시작
        GOSUB 계단_CLOSE걷기_시작
        GOSUB 계단_CLOSE걷기_시작
        GOSUB 계단_CLOSE걷기_시작

    ELSEIF A_Old = 124 THEN    	
        GOSUB 걷기_FAST_멈춤

    ELSEIF A_Old = 125 THEN    	
        걸음방향=2
        GOSUB 걷기_FAST_연속

        '가스밸브 앞에서 가까이 갔을 때 사용
        '밸브ATTACH
    ELSEIF A_Old = 128 THEN    	

        GOSUB 가스밸브_걷기_FAST_시작
        GOSUB 가스밸브_걷기_FAST_연속
        GOSUB 가스밸브_걷기_FAST_연속
        GOSUB 가스밸브_걷기_FAST_연속
        GOSUB 가스밸브_걷기_FAST_멈춤

        '========================================

        '머리 움직이는 동작

        '========================================

    ELSEIF A_Old = 107 THEN    	

        GOSUB UP

    ELSEIF A_Old = 108 THEN    	

        GOSUB FRONT

    ELSEIF A_Old = 109 THEN    	

        GOSUB OBLIQUE

    ELSEIF A_Old = 110  THEN    	

        GOSUB DOWN

    ELSEIF A_Old = 131  THEN    	

        GOSUB 왼쪽보기

    ELSEIF A_Old = 132  THEN    	

        GOSUB 오른쪽보기

    ELSEIF A_Old = 134  THEN    	

        GOSUB UP_왼쪽보기

    ELSEIF A_Old = 135  THEN    	

        GOSUB UP_오른쪽보기



        '========================================

        '회전 동작

        '========================================

    ELSEIF A_Old = 111 THEN    	

        GOSUB 왼쪽턴_SHORT

    ELSEIF A_Old = 112 THEN

        GOSUB 오른쪽턴_SHORT

    ELSEIF A_Old = 129 THEN    	

        GOSUB 왼쪽턴_LONG

    ELSEIF A_Old = 130 THEN    	

        GOSUB 오른쪽턴_LONG

        '
        '========================================

        '옆으로 걷기 동작

        '========================================

    ELSEIF A_Old = 113 THEN    	

        GOSUB 왼쪽옆으로_SHORT

    ELSEIF A_Old = 114 THEN

        GOSUB 오른쪽옆으로_SHORT  	

    ELSEIF A_Old = 126 THEN    	

        GOSUB 왼쪽옆으로_LONG

    ELSEIF A_Old = 127 THEN    	

        GOSUB 오른쪽옆으로_LONG

        '========================================

        '계단 오르기 동작

        '========================================

        ' ELSEIF A_Old = 130 THEN    	
        '
        '        GOSUB 계단오른발내리기1cm
        '
        '    ELSEIF A_Old = 131 THEN    	
        '
        '        GOSUB 계단오른발오르기1cm
        '
        '========================================

        '붙이기걸음
    ELSEIF A_Old = 115 THEN    	

        'GOSUB CLOSE걷기_시작
        '        GOSUB CLOSE걷기_1
        '        GOSUB CLOSE걷기_멈춤

        '이름은문인데 가스밸브 에서 쓰려고 함
        GOSUB 문_CLOSE걷기_시작


        '========================================
        '========================================

        '터널 동작

        '========================================

    ELSEIF A_Old = 116 THEN    	

        GOSUB 터널_시퀀스

        '========================================

        '가스 밸브 동작

        '========================================

        '실제로 가서 가스밸브 잠구는 시퀀스
    ELSEIF A_Old=117 THEN

        GOSUB 가스밸브_시퀀스

        '========================================

        '문 동작

        '========================================

    ELSEIF A_Old= 118 THEN

        GOSUB 문_시퀀스

    ELSEIF A_Old= 133 THEN

        GOSUB 문다음직각턴

        '========================================

        '계단 덤블링

        '==================================

    ELSEIF A_Old = 119 THEN    	

        GOSUB 계단시퀀스

        '========================================

        '장애물 동작

        '==================================


    ELSEIF A_Old = 120 THEN    	

        GOSUB 장애물_다리벌리고_땅_왼쪽앞_치우기

    ELSEIF A_Old = 121 THEN    	

        GOSUB 장애물_다리벌리고_땅_오른쪽앞_치우기
        'GOSUB 넘어짐확인_시퀀스

        ' ELSEIF A_Old = 137 THEN    	
        '
        '        GOSUB 장애물_왼쪽_옆으로_팔들기
        '
        '    ELSEIF A_Old = 138 THEN    	
        '
        '        GOSUB 장애물_오른쪽_옆으로_팔들기
        '
        '    ELSEIF A_Old = 139 THEN    	
        '
        '        GOSUB 장애물_일어서서_왼쪽앞치우기
        '
        '    ELSEIF A_Old = 140 THEN    	
        '
        '        GOSUB 장애물_일어서서_오른쪽앞치우

        '========================================

        '적외선 거리센서 확인

        '==================================
        '
        '    ELSEIF A_Old = 120 THEN    	
        '
        '        GOSUB 적외선거리센서확인


        '========================================

        '시작자세

        '========================================

    ELSEIF A_Old = 122 THEN    	

        GOSUB 안정화자세

        '========================================

    ENDIF


    '========================================

    '동작 끝

    '========================================

    '========================================

    '끝나고 적외선 보내는 동작들 시작

    '========================================

    '  '걷기_short시작
    IF A_Old = 100 THEN

        GOSUB 적외선거리센서확인

        '걷기_short연속
    ELSEIF A_Old = 102 THEN    	

        GOSUB 적외선거리센서확인

        '왼쪽작은휨걸음
    ELSEIF A_Old = 103 THEN    	

        GOSUB 적외선거리센서확인

        '오른쪽작은휨걸음
    ELSEIF A_Old = 104 THEN    	

        GOSUB 적외선거리센서확인

        '왼쪽큰휨걸음
    ELSEIF A_Old = 105 THEN    	

        GOSUB 적외선거리센서확인
        '     '오른쪽큰휨걸음
    ELSEIF A_Old = 106 THEN    	

        GOSUB 적외선거리센서확인

        '가스밸브에서 쓰는 CLOSE
    ELSEIF A_Old = 115 THEN    	

        GOSUB 적외선거리센서확인

        'Init(안정화자세)
    ELSEIF A_Old = 122 THEN    	

        GOSUB 적외선거리센서확인

        '연속전진(가스밸브)
    ELSEIF A_Old = 128 THEN    	

        GOSUB 적외선거리센서확인

        '적외선거리센서확인
    ELSEIF A_Old = 136 THEN    	

        GOSUB 적외선거리센서확인


        '     '문_CLOSE걷기_시작
        '    ELSEIF A_Old = 205 THEN    	
        '
        '        GOSUB 적외선거리센서확인
        '
        '        '문_CLOSE걷기_연속
        '    ELSEIF A_Old = 155 THEN    	
        '
        '        GOSUB 적외선거리센서확인
        '
        '        '가스밸브_CLOSE걷기_시작
        '    ELSEIF A_Old = 204 THEN    	
        '
        '        GOSUB 적외선거리센서확인
        '
        '        '가스밸브_CLOSE걷기_연속
        '    ELSEIF A_Old = 154 THEN    	
        '
        '        GOSUB 적외선거리센서확인
        '
        '        '다리걷기_시작
        '    ELSEIF A_Old = 200 THEN    	
        '
        '        GOSUB 적외선거리센서확인
        '
        '        '다리걷기_연속
        '    ELSEIF A_Old = 150 THEN    	
        '
        '        GOSUB 적외선거리센서확인  	

    ELSE
        '동작 종료 신호 라파이에게 보내기
        ETX 4800,254
    ENDIF


    GOTO MAIN_2

    '*******************************************
    '		MAIN2 종료
    '*******************************************

    '*******************************************
    '		리모컨용 MAIN 시작
    '*******************************************

    '****************************************************************
RX_EXIT:

    ERX 4800, A, 리모컨_MAIN

    GOTO RX_EXIT

GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN

    '****************************************************************

리모컨_MAIN: '라벨설정

    ETX 4800, 38 ' 동작 멈춤 확인 송신 값


리모컨_MAIN_2:

    '***********************************
    '일단 주석처리해주었음

    'GOSUB 앞뒤기울기측정
    'GOSUB 좌우기울기측정
    'GOSUB 적외선거리센서확인

    ERX 4800,A,리모컨_MAIN_2	

    A_old = A

    '**** 입력된 A값이 0 이면 MAIN 라벨로 가고
    '**** 1이면 KEY1 라벨, 2이면 key2로... 가는문
    ON A GOTO 리모컨_MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

    IF A > 100 AND A < 110 THEN
        BUTTON_NO = A - 100
        GOSUB Number_Play
        GOSUB SOUND_PLAY_CHK
        GOSUB GOSUB_RX_EXIT


    ELSEIF A = 250 THEN
        GOSUB All_motor_mode3
        SPEED 4
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  40,  90,
        MOVE G6C,100,  40,  90,
        WAIT
        DELAY 500
        SPEED 6
        GOSUB 기본자세

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************

    '왼쪽 턴 10
KEY1:
    ETX  4800,1

    GOSUB 왼쪽턴_SHORT
    '
    GOTO RX_EXIT
    '***************	
    '횟수_전진종종걸음
KEY2:
    ETX  4800,2	

    '걸음방향=2
    '    '보행횟수=10
    '    GOSUB 다리걷기_시작
    '    GOSUB 다리걷기_연속
    '    GOSUB 다리걷기_연속
    '    GOSUB 다리걷기_연속
    '    GOSUB 다리걷기_연속
    '    GOSUB 다리걷기_연속
    '    GOSUB 다리걷기_연속
    '    GOSUB 다리걷기_연속
    '    GOSUB 다리걷기_연속
    '    GOSUB 다리걷기_연속
    '    GOSUB 다리걷기_연속
    '    GOSUB 다리걷기_연속
    '    GOSUB 다리걷기_멈춤

    GOSUB 전진달리기_시작
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_연속
    GOSUB 전진달리기_멈춤_0



    GOTO RX_EXIT
    '***************
    '오른쪽턴10
KEY3:
    ETX  4800,3

    GOSUB 오른쪽턴_SHORT

    GOTO RX_EXIT
    '***************
    ' 왼쪽옆으로20
KEY4:
    ETX  4800,4
    'GOTO 왼쪽옆으로20
    'GOSUB 왼쪽옆으로_SHORT
    GOSUB 왼쪽옆으로70
    'GOTO 가스밸브_왼쪽옆으로

    GOTO RX_EXIT
    '***************
    '적외선거리값 읽기
KEY5:
    ETX  4800,5

    J = AD(5)	'적외선거리값 읽기
    J= 160-J/2
    J=J+100

    IF J>180 THEN
        J=180    	
    ELSEIF J<100 THEN
        J=100   	

    ENDIF


    BUTTON_NO =   J
    GOSUB Number_Play
    GOSUB SOUND_PLAY_CHK
    GOSUB GOSUB_RX_EXIT

    GOTO RX_EXIT
    '***************
    '오른쪽 옆으로 20
KEY6:
    ETX  4800,6

    GOSUB 오른쪽옆으로_SHORT

    GOTO RX_EXIT
    '***************
    '왼쪽턴20
KEY7:
    ETX  4800,7

    'GOSUB 왼쪽옆으로_LONG
    GOSUB 왼쪽턴60


    GOTO RX_EXIT
    '***************

KEY8:
    ETX  4800,8

    GOSUB 연속전진

    GOTO RX_EXIT
    '***************
    '오른쪽턴20
KEY9:
    ETX  4800,9
    'GOTO 오른쪽턴20
    'GOTO 오른쪽턴20

    'GOSUB 오른쪽옆으로_LONG
    GOSUB 오른쪽턴_LONG

    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX  4800,10
    보행횟수=5
    'GOTO CLOSE걷기_시작
    'GOTO 계단오른발오르기1cm내것

    GOTO RX_EXIT
    '***************
    '머리
KEY11: ' ▲
    ETX  4800,11
    '80cm기준으로 보행횟수 15
    '보행횟수=15
    '걸음방향=2
    '    보행횟수=20
    '    GOTO 걷기_FAST_시작

    걸음방향=2

    GOSUB 걷기_FAST_시작
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_연속
    GOSUB 걷기_FAST_멈춤


    GOTO RX_EXIT
    '***************
KEY12: ' ▼
    ETX  4800,12

    'GOTO 앞으로일어나기
    'GOTO 가스밸브_걷기_시작
    'GOSUB 계단_CLOSE걷기_시작
    'GOSUB 계단_CLOSE걷기_시작
    'GOSUB 가스밸브_CLOSE걷기_시작
    'GOTO 문_기어가기_시퀀스
    'GOSUB ㅋ
    GOSUB 가스밸브걷기_시작

    GOTO RX_EXIT
    '***************
KEY13: '▶
    ETX  4800,13
    'GOTO 오른쪽옆으로70연속
    'GOTO 다리걷기_시작
    보행횟수=3
    GOSUB CLOSE걷기_시작

    GOTO RX_EXIT
    '***************
KEY14: ' ◀
    ETX  4800,14
    GOSUB 왼쪽옆으로70
    '보행횟수=1
    'GOTO 계단덤블링
    'GOTO 연속전진

    GOTO RX_EXIT
    '***************
KEY15: ' A
    ETX  4800,15

    GOSUB 계단시퀀스

    GOTO RX_EXIT
    '***************
KEY16: ' POWER
    ETX  4800,16

    GOSUB Leg_motor_mode3
    IF MODE = 0 THEN
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
    ENDIF
    SPEED 4
    GOSUB 앉은자세	
    GOSUB 종료음

    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF 모터ONOFF = 1  THEN
        OUT 52,1
        DELAY 200
        OUT 52,0
        DELAY 200
    ENDIF
    ERX 4800,A,KEY16_1
    ETX  4800,A
    IF  A = 16 THEN 	'다시 파워버튼을 눌러야만 복귀
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
        GOSUB Leg_motor_mode2
        GOSUB 기본자세2
        GOSUB 자이로ON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1

    GOTO RX_EXIT
    '***************
KEY17: ' C
    ETX  4800,17
    GOSUB 터널_시퀀스


    GOTO RX_EXIT
    '***************
KEY18: ' E
    ETX  4800,18	

    GOSUB 장애물_다리벌리고_땅_왼쪽앞_치우기

    GOTO RX_EXIT

KEY18_wait:

    ERX 4800,A,KEY18_wait	

    IF  A = 26 THEN
        GOSUB 시작음
        GOSUB 자이로ON
        GOTO RX_EXIT
    ENDIF

    GOTO KEY18_wait


    GOTO RX_EXIT
    '***************

    '내것 : 계단오른발오르기1cm
KEY19: ' P2
    ETX  4800,19
    'GOTO 장애물_땅_오른쪽앞_치우기

    GOTO RX_EXIT
    '***************
    '가스밸브_잠구기
KEY20: ' B	
    ETX  4800,20

    GOSUB 문_시퀀스

    GOTO RX_EXIT
    '***************
    '정면_보기 0도
KEY21: ' △
    ETX  4800,21
    GOSUB UP
    GOTO RX_EXIT
    '***************
    '앉은자세_걷기_내것:
KEY22: ' *	
    ETX  4800,22
    '보행횟수=1
    'GOSUB 장애물_땅_왼쪽앞_치우기

    GOTO RX_EXIT
    '***************
    '터널_기어가기_일어나기
KEY23: ' G
    ETX  4800,23
    GOSUB 가스밸브_시퀀스

    GOTO RX_EXIT
KEY23_wait:


    ERX 4800,A,KEY23_wait	

    IF  A = 26 THEN
        GOSUB 시작음
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOTO KEY23_wait


    GOTO RX_EXIT
    '***************
KEY24: ' #
    ETX  4800,24
    GOSUB 가스밸브_팔올리는자세

    GOSUB 가스밸브_팔붙이는자세

    GOSUB 왼쪽옆으로70
    GOSUB 왼쪽옆으로70
    GOSUB 왼쪽옆으로70
    GOSUB 왼쪽옆으로70
    GOSUB 왼쪽옆으로70

    GOTO RX_EXIT
    '***************
KEY25: ' P1
    ETX  4800,25

    'GOSUB 장애물_땅_오른쪽앞_치우기
    'GOTO 문_덤블링
    'GOTO 앞으로덤블링
    'GOTO CLOSE걷기_시작

    GOTO RX_EXIT
    '***************
KEY26: ' ■
    ETX  4800,26

    'SPEED 5
    '    GOSUB 기본자세2	
    '    TEMPO 220
    '    MUSIC "ff"
    '    GOSUB 기본자세

    SPEED 5
    GOSUB 안정화자세

    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX  4800,27

    보행COUNT=0
    보행횟수=10
    'GOTO 앞으로_덤블링_기어가기

    GOTO RX_EXIT
    '***************
KEY28: ' ◁
    ETX  4800,28
    GOSUB 왼쪽보기


    GOTO RX_EXIT
    '***************
    '정면_보기 20도
KEY29: ' □
    ETX  4800,29

    GOSUB OBLIQUE

    GOTO RX_EXIT
    '***************
KEY30: ' ▷
    ETX  4800,30
    GOSUB 오른쪽보기

    GOTO RX_EXIT
    '***************
KEY31: ' ▽
    ETX  4800,31
    'GOTO 발밑_보기_90도
    GOSUB DOWN

    GOTO RX_EXIT
    '***************
    '터널_기어가기
KEY32: ' F
    ETX  4800,32
    GOSUB 장애물_다리벌리고_땅_오른쪽앞_치우기
    GOTO RX_EXIT
    '***************
