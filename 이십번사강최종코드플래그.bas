'******** 2�� ����κ� �ʱ� ���� ���α׷� ********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE
DIM ������� AS BYTE
DIM �������� AS BYTE
DIM ����üũ AS BYTE
DIM ����ONOFF AS BYTE
DIM ���̷�ONOFF AS BYTE
DIM ����յ� AS INTEGER
DIM �����¿� AS INTEGER
DIM	�ٸ��ȱ⿬��üũ AS BYTE
DIM �����������п�üũ AS BYTE
DIM ���������������п�üũ AS BYTE
DIM �����޸��⿬��üũ AS BYTE
DIM �����޸��⿬�Ӻб�üũ AS BYTE

DIM ����� AS BYTE

DIM �Ѿ���Ȯ�� AS BYTE
DIM ����Ȯ��Ƚ�� AS BYTE
DIM ����Ƚ�� AS BYTE
DIM ����COUNT AS BYTE

DIM ���ܼ��Ÿ���  AS BYTE
DIM ���ܼ��Ÿ���_Old AS BYTE
''���� �߰��� ���ܼ��Ÿ��� ����
DIM ���ܼ��Ÿ���_�ι�° AS BYTE
DIM ���ܼ��Ÿ���_�ι�°_OLD AS BYTE
DIM ���ܼ��Ÿ���_����° AS BYTE
DIM ���ܼ��Ÿ���_����°_OLD AS BYTE
DIM ���ܼ��Ÿ���_�߰��� AS BYTE


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

'**** ���⼾����Ʈ ���� ****
CONST �յڱ���AD��Ʈ = 0
CONST �¿����AD��Ʈ = 1
CONST ����Ȯ�νð� = 20  'ms


CONST min = 61	'�ڷγѾ�������
CONST max = 107	'�����γѾ�������
CONST COUNT_MAX = 3


CONST �Ӹ��̵��ӵ� = 10
'************************************************
' ����_SHORT�� �������� ������ ����
'************************************************
'125,103
CONST �޹߹��Կ��ʹ������� =125
CONST �޹߹��Կ������������ =103

'140,104
CONST �޹߳�����ʹ������� =140
CONST �޹߳��������������� =104

'120,100
CONST �����߹��Կ����ʹ������� =120
CONST �����߹��Կ��������������  =100

'146,105
CONST �����߳�������ʹ�������=146
CONST �����߳����������������� =105


DIM �������� AS BYTE
DIM �������Ӻб�üũ AS BYTE

'************************************************
PTP SETON 				'�����׷캰 ���������� ����
PTP ALLON				'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5��
DIR G6D,0,1,1,0,1,1		'����18~23��
DIR G6B,1,1,1,1,1,1		'����6~11��
DIR G6C,0,0,0,0,1,0		'����12~17��

'************************************************

OUT 52,0	'�Ӹ� LED �ѱ�
'***** �ʱ⼱�� '************************************************

������� = 0
����üũ = 0
����Ȯ��Ƚ�� = 0
����Ƚ�� = 1
����ONOFF = 0
�����������п�üũ=0
���������������п�üũ=0

�������Ӻб�üũ=0

'****�ʱ���ġ �ǵ��*****************************


TEMPO 230
MUSIC "cdefg"

SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

'�̽ʹ��κ����� �ణ ��Ծ��� �־ 99�� ����
'SERVO 11, 100
SERVO 11, 99
SERVO 16, S16

GOSUB �����ʱ��ڼ�
GOSUB ����ȭ�ڼ�

'���� �ּ� �ȵǾ�����
GOSUB ���̷�INIT
GOSUB ���̷�MID
GOSUB ���̷�ON

'������
GOSUB All_motor_mode3
'�����
'GOSUB All_motor_Reset

'��ǻ�� ��ſ�
GOTO MAIN	

'��������

'GOTO ������_MAIN

'************************************************

'*********************************************
' Infrared_Distance = 60 ' About 20cm
' Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************
'************************************************
������:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
������:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
������:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '����Ʈ�������ͻ�뼳��

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    ����ONOFF = 0
    GOSUB ������			
    RETURN

    '************************************************
    '����Ʈ�������ͻ�뼳��
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    ����ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB ������	
    RETURN
    '************************************************
    '��ġ���ǵ��
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '��ġ���ǵ��
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
    '**** ���̷ΰ��� ���� ****
���̷�INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** ���̷ΰ��� ���� ****
���̷�MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
���̷�MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
���̷�MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '***********************************************
���̷�ON:


    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0


    ���̷�ONOFF = 1

    RETURN
    '***********************************************
���̷�OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    ���̷�ONOFF = 0
    RETURN

    '************************************************
�����ʱ��ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '************************************************
����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
�⺻�ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    WAIT
    mode = 0

    RETURN
    '******************************************	
�⺻�ڼ�2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 0

    RETURN
    '******************************************	
�����ڼ�:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '******************************************
�����ڼ�:
    GOSUB ���̷�OFF
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 1

    RETURN
    '******************************************
�������_�⺻�ڼ�:
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
    '��������:
    '    �Ѿ���Ȯ�� = 0
    '    ����ӵ� = 12
    '    �¿�ӵ� = 4
    '    GOSUB Leg_motor_mode3
    '
    '
    '
    '    IF ������� = 0 THEN
    '        ������� = 1
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
    '        GOTO ��������_1	
    '    ELSE
    '        ������� = 0
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
    '        GOTO ��������_2
    '
    '    ENDIF
    '
    '
    '��������_1:
    '    ETX 4800,12 '�����ڵ带 ����
    '    SPEED ����ӵ�
    '
    '    MOVE G6D,110,  76, 145, 93,  96
    '    MOVE G6A,90, 98, 145,  69, 110
    '    WAIT
    '
    '    SPEED �¿�ӵ�
    '    MOVE G6D, 90,  60, 137, 120, 110
    '    MOVE G6A,107,  85, 137,  93,  96
    '    WAIT
    '
    '
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
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
    '    ERX 4800,A, ��������_2
    '    IF A <> A_old THEN
    '��������_1_EXIT:
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
    '        GOSUB �⺻�ڼ�2
    '        GOTO RX_EXIT
    '    ENDIF
    '    '**********
    '
    '��������_2:
    '    ETX 4800,12 '�����ڵ带 ����
    '    SPEED ����ӵ�
    '    MOVE G6A,110,  76, 145, 93,  96
    '    MOVE G6D,90, 98, 145,  69, 110
    '    WAIT
    '
    '
    '    SPEED �¿�ӵ�
    '    MOVE G6A, 90,  60, 137, 120, 110
    '    MOVE G6D,107  85, 137,  93,  96
    '    WAIT
    '
    '
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
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
    '    ERX 4800,A, ��������_1
    '    IF A <> A_old THEN
    '��������_2_EXIT:
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
    '        GOSUB �⺻�ڼ�2
    '        GOTO RX_EXIT
    '    ENDIF  	
    '
    '    GOTO ��������_1
    '**********************************************

    '    '******************************************
    '�ȱ�_SHORT_����:
    '    GOSUB All_motor_mode3
    '    '����COUNT = 0
    '
    '    SPEED 7
    '    HIGHSPEED SETON
    '
    '    IF ������� = 0 THEN
    '        '������� = 1
    '        MOVE G6A,95,  76, 147,  93, 101
    '        MOVE G6D,101,  76, 147,  93, 98
    '        MOVE G6B,100
    '        MOVE G6C,100
    '        WAIT
    '
    '        'GOTO Ƚ��_������������_1
    '        'ELSE
    '        '        ������� = 0
    '        '        MOVE G6D,95,  76, 147,  93, 101
    '        '        MOVE G6A,101,  76, 147,  93, 98
    '        '        MOVE G6B,100
    '        '        MOVE G6C,100
    '        '        WAIT
    '        '
    '        '        GOTO Ƚ��_������������_4
    '    ENDIF
    '
    '    RETURN
    '
    '    '**********************
    '
    '�ȱ�_SHORT_1:
    '
    '    MOVE G6A,95,  90, 125, 100, 104
    '    MOVE G6D,104,  77, 147,  93,  102
    '    MOVE G6B, 85
    '    MOVE G6C,115
    '    WAIT
    '
    '�ȱ�_SHORT_2:
    '
    '    MOVE G6A,103,   73, 140, 103,  100
    '    MOVE G6D, 95,  85, 147,  85, 102
    '    WAIT
    '
    '    'GOSUB �յڱ�������
    '    '    IF �Ѿ���Ȯ�� = 1 THEN
    '    '        �Ѿ���Ȯ�� = 0
    '    '
    '    '        GOTO MAIN_2
    '    '    ENDIF
    '
    '    '����COUNT = ����COUNT + 1
    '    '    IF ����COUNT > ����Ƚ�� THEN  GOTO Ƚ��_������������_2_stop
    '
    '    '    ERX 4800,A, Ƚ��_������������_4
    '    '    IF A <> A_old THEN
    '    'Ƚ��_������������_2_stop:
    '    '
    '    '        MOVE G6D,95,  90, 125, 95, 104
    '    '        MOVE G6A,104,  76, 145,  91,  102
    '    '        MOVE G6C, 100
    '    '        MOVE G6B,100
    '    '        WAIT
    '    '        HIGHSPEED SETOFF
    '    '        SPEED 15
    '    '        GOSUB ����ȭ�ڼ�
    '    '        SPEED 5
    '    '        GOSUB �⺻�ڼ�2
    '    '
    '    '        'DELAY 400
    '    '        GOTO RX_EXIT
    '    '    ENDIF
    '
    '    '*********************************
    '
    '�ȱ�_SHORT_4:
    '    MOVE G6A,104,  77, 147,  93,  102
    '    MOVE G6D,95,  90, 125, 100, 104
    '    MOVE G6C, 85
    '    MOVE G6B,115
    '    WAIT
    '
    '�ȱ�_SHORT_5:
    '    MOVE G6D,103,    73, 140, 103,  100
    '    MOVE G6A, 95,  85, 147,  85, 102
    '    WAIT
    '
    '    '�Ѿ��� Ȯ��
    '    'GOSUB �յڱ�������
    '    '    IF �Ѿ���Ȯ�� = 1 THEN
    '    '        �Ѿ���Ȯ�� = 0
    '    '        GOTO RX_EXIT
    '    '    ENDIF
    '
    '    RETURN
    '
    '�ȱ�_SHORT_����:
    '
    '    MOVE G6A,95,  90, 125, 95, 104
    '    MOVE G6D,104,  76, 145,  91,  102
    '    MOVE G6B, 100
    '    MOVE G6C,100
    '    WAIT
    '
    '    HIGHSPEED SETOFF
    '    SPEED 5
    '    GOSUB ����ȭ�ڼ�
    '    RETURN
    '
    '
    '    '*************************************

    '******************************************
�ȱ�_SHORT_����:
    GOSUB All_motor_mode3
    '����COUNT = 0

    SPEED 7
    HIGHSPEED SETON

    IF ������� = 0 THEN
        '������� = 1
        '���������� �� �ű�

        SPEED 5
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        'GOTO Ƚ��_������������_1
        'ELSE
        '        ������� = 0
        '        MOVE G6D,95,  76, 147,  93, 101
        '        MOVE G6A,101,  76, 147,  93, 98
        '        MOVE G6B,100
        '        MOVE G6C,100
        '        WAIT
        '
        '        GOTO Ƚ��_������������_4
    ENDIF

    RETURN

    '**********************
�ȱ�_SHORT_����:

    SPEED 7

    'IF  �������Ӻб�üũ=1 THEN

�ȱ�_SHORT_1:

    '�޹� �߽��̵�
    MOVE G6A,95,  90, 125, 99, 104
    MOVE G6D,102,  77, 147,  92,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT

    'ENDIF

�ȱ�_SHORT_2:

    �������Ӻб�üũ=1

    '���� ����
    IF ��������=2 OR  ��������=1 THEN

        '�޹� �����
        MOVE G6A,103,   73, 140, 102,  100
        MOVE G6D, 93,  85, 147,  84, 102
        WAIT



    ELSEIF ��������=3 THEN
        '���������� �۰� �ְ� �� ��
        'A,+4
        'D, -4
        MOVE G6A,107,   73, 140, 103,  100
        MOVE G6D, 89,  85, 147,  85, 102
        WAIT


    ELSEIF ��������=4 THEN
        '�������� ũ�� �ְ� �� �� (�߸��Ȱžƴ�)

        'test
        'A,+8
        'D, -8
        MOVE G6A,111,   73, 140, 103,  100
        MOVE G6D, 93,  85, 147,  85, 102
        WAIT



    ENDIF

    'GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '
    '        GOTO MAIN_2
    '    ENDIF

    '����COUNT = ����COUNT + 1
    '    IF ����COUNT > ����Ƚ�� THEN  GOTO Ƚ��_������������_2_stop

    '    ERX 4800,A, Ƚ��_������������_4
    '    IF A <> A_old THEN
    'Ƚ��_������������_2_stop:
    '
    '        MOVE G6D,95,  90, 125, 95, 104
    '        MOVE G6A,104,  76, 145,  91,  102
    '        MOVE G6C, 100
    '        MOVE G6B,100
    '        WAIT
    '        HIGHSPEED SETOFF
    '        SPEED 15
    '        GOSUB ����ȭ�ڼ�
    '        SPEED 5
    '        GOSUB �⺻�ڼ�2
    '
    '        'DELAY 400
    '        GOTO RX_EXIT
    '    ENDIF

    '*********************************

�ȱ�_SHORT_4:

    '���������� �߽��̵�	
    MOVE G6D,93,  93, 120, 99, 104
    MOVE G6A,104,  75, 147,  92,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT

�ȱ�_SHORT_5:

    IF ��������=2 OR ��������=3 THEN

        '������ �����
        MOVE G6D,105,    73, 140, 102,  100
        MOVE G6A, 95,  85, 147,  84, 102
        WAIT

    ELSEIF �������� = 1 THEN
        '�������� �ְ� �� ��
        'A, -4
        'D, +4


        MOVE G6D,109,    73, 140, 102,  100
        MOVE G6A, 89,  85, 147,  84, 102
        WAIT





    ELSEIF ��������=6 THEN
        '���������� ũ�� �ְ� �� �� (�߸��Ȱžƴ�)

        'test
        'A,-8
        'D,+8
        MOVE G6D,113,   73, 140, 103,  100
        MOVE G6A, 87,  85, 147,  85, 102
        WAIT

    ENDIF

    '�Ѿ��� Ȯ��
    'GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO RX_EXIT
    '    ENDIF

    RETURN

�ȱ�_SHORT_����:

    �������Ӻб�üũ=0

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    HIGHSPEED SETOFF
    SPEED 5
    GOSUB ����ȭ�ڼ�
    RETURN

    '******************************************
    '******************************************
    '�ȱ�_FAST
    '******************************************
    '******************************************
�ȱ�_FAST_����:

    ����COUNT=0
    HIGHSPEED SETON
    ����ӵ�=8

    ''����ȭ�ڼ�
    '  MOVE G6A,98,  76, 145,  93, 101, 100
    '        MOVE G6D,98,  76, 145,  93, 101, 100
    '        MOVE G6B,100,  35,  90
    '        MOVE G6C,100,  35,  90
    '        WAIT

    SPEED ����ӵ�
    '�޹� ������
    ' MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT

    '�׽�Ʈ1
    MOVE G6A,98,  60, 145,  110, 101, 100
    MOVE G6D,98,  86, 145,  93, 101, 100
    WAIT

    RETURN

�ȱ�_FAST_����:

    SPEED ����ӵ�
    '������ ������

    'IF ��������=2 OR ��������=3 THEN

    '��������( ���� �ϰ� ���� ���� ���� �ٱ������� �߸��� ���ָ��)
    MOVE G6D,98,  60, 145,  109, 101, 100
    MOVE G6A,96,  86, 145,  93, 101, 100
    WAIT

    '��������(�ణ �������� ���� )
    'D,+2
    'MOVE G6D,98,  60, 145,  109, 101, 100
    '    MOVE G6A,100,  86, 145,  93, 101, 100
    '    WAIT

    ' ELSEIF ��������=4 THEN
    '
    '        '��������
    '        MOVE G6D,98,  60, 145,  109, 101, 100
    '        MOVE G6A,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '    ELSEIF ��������=1 THEN
    '
    '        '�׽�Ʈ2(�������� �ְ�)
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

    SPEED ����ӵ�

    '�޹� ������
    'IF ��������=2 OR ��������=1 THEN

    '��������
    MOVE G6A,98,  60, 145,  110, 101, 100
    MOVE G6D,98,  86, 145,  93, 101, 100
    WAIT	

    'ELSEIF ��������=3 THEN
    '
    '        MOVE G6A,98,  60, 145,  110, 101, 100
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '        '�׽�Ʈ2(���������� �ְ�)
    '        'A,+4
    '        'D,
    '        MOVE G6A,102,  60, 145,  110, 101, 100
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        WAIT

    'ELSEIF ��������=4 THEN
    '
    '        '�׽�Ʈ2(�������� �ְ�)
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

�ȱ�_FAST_����:

    SPEED ����ӵ�
    '������ ������
    ' MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  103, 101, 100
    '    WAIT

    '�׽�Ʈ1
    MOVE G6A,98,  60, 145,  110, 101, 100
    MOVE G6D,98,  76, 145,  110, 101, 100
    WAIT

    SPEED 5
    '����ȭ�ڼ�
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    HIGHSPEED SETOFF

    RETURN

    '**********************************************
�ȱ�_FAST_������:

    GOSUB �ȱ�_FAST_����
    '9
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����

    RETURN

    '**********************************************
    'CLOSE�ȱ�_����:
    '
    '    ����COUNT=0
    '
    '    ����ӵ�=7
    '    ''����ȭ�ڼ�
    '    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90
    '    '    MOVE G6C,100,  35,  90
    '    '    WAIT
    '
    '    SPEED ����ӵ�
    '    '�޹� ������
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    GOTO CLOSE�ȱ�_1
    '
    '    '******************************************
    '    '******************************************
    'CLOSE�ȱ�_1:
    '
    '    SPEED ����ӵ�
    '    '������ ������
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  70, 145,  103, 101, 100
    '    WAIT
    '
    '    SPEED ����ӵ�
    '    '�޹� ������
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    ����COUNT = ����COUNT + 1
    '    IF ����COUNT > ����Ƚ�� THEN
    '        GOTO CLOSE�ȱ�_����
    '
    '    ELSE
    '        GOTO CLOSE�ȱ�_1
    '
    '    ENDIF
    '
    '    RETURN
    '    '******************************************
    '    '******************************************
    'CLOSE�ȱ�_����:
    '
    '    SPEED ����ӵ�
    '    '������ ������
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  103, 101, 100
    '    WAIT
    '
    '    SPEED 5
    '    '����ȭ�ڼ�
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '
    '    RETURN
    '
    '******************************************
    '**********************************************
    '������� ATTACH�� �� ����
CLOSE�ȱ�_����:

    ����COUNT=0

    '�ȿø��� �ڼ�
    MOVE G6B,60,  176,  145
    MOVE G6C,62,  180,  147

    '����ӵ�=7
    ����ӵ�=9
    ''����ȭ�ڼ�
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,100,  35,  90
    '    WAIT

    SPEED ����ӵ�
    '�޹� ������
    MOVE G6A,98,  71, 145,  108, 101, 100
    MOVE G6D,98,  74, 145,  93, 101, 100
    WAIT

    GOTO CLOSE�ȱ�_1

    '******************************************
    '******************************************
CLOSE�ȱ�_1:

    SPEED ����ӵ�
    '������ ������
    MOVE G6A,98,  74, 145,  93, 101, 100
    MOVE G6D,98,  71, 145,  108, 101, 100
    WAIT

    SPEED ����ӵ�
    '�޹� ������
    MOVE G6A,98,  71, 145,  108, 101, 100
    MOVE G6D,98,  74, 145,  93, 101, 100
    WAIT

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN
        GOTO CLOSE�ȱ�_����

    ELSE
        GOTO CLOSE�ȱ�_1

    ENDIF

    RETURN
    '******************************************
    '******************************************
CLOSE�ȱ�_����:

    SPEED ����ӵ�
    '������ ������
    MOVE G6A,98,  71, 145,  103, 101, 100
    MOVE G6D,98,  74, 145,  103, 101, 100
    WAIT

    SPEED 15
    '����ȭ�ڼ�
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN




    '******************************************
�����޸���_����:
    �Ѿ���Ȯ�� = 0
    �����޸��⿬��üũ=0
    �����޸��⿬�Ӻб�üũ=0

    GOSUB All_motor_mode3
    ����COUNT = 0
    DELAY 50

    SPEED 5
    'IF ������� = 0 THEN
    '������� = 1
    '���������� ��¦������
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    WAIT

    SPEED 8
    'SPEED 6
    HIGHSPEED SETON

    '�����Ҷ� �������� ���� ��� �����ڵ�(���������� )
    '        MOVE G6A,95,  80, 120, 120, 104
    '        MOVE G6D,104,  77, 146,  91,  102
    '        MOVE G6B, 80
    '        MOVE G6C,120
    '        WAIT	
    '
    'GOTO �����޸���50_2
    'ELSE
    '������� = 0
    '        MOVE G6D,95,  76, 145,  93, 101
    '        MOVE G6A,101,  77, 145,  93, 98
    '        WAIT
    '
    '        MOVE G6D,95,  80, 120, 120, 104
    '        MOVE G6A,104,  77, 146,  91,  102
    '        MOVE G6C, 80
    '        MOVE G6B,120
    '        WAIT


    ' GOTO �����޸���50_5
    '    ENDIF

    RETURN

    '   **********************
�����޸���_����:

    IF �����޸��⿬�Ӻб�üũ=0 THEN

        IF �����޸��⿬��üũ=1 THEN

�����޸���50_1:

            '�޹߷� �����߽� �̵�
            MOVE G6A,95,  95, 100, 120, 104
            MOVE G6D,104,  77, 147,  93,  102
            MOVE G6B, 80
            MOVE G6C,120
            WAIT

        ENDIF

�����޸���50_2:

        �����޸��⿬��üũ=1

        '�޹� ��¦ ������ ����
        MOVE G6A,95,  75, 122, 120, 104
        MOVE G6D,106,  78, 147,  90,  100
        WAIT

�����޸���50_3:
        '�޹� ������(��������)
        'MOVE G6A,103,  69, 145, 103,  100
        '        MOVE G6D, 95, 87, 160,  68, 102
        '        WAIT

        '���¹����� �߸��� �������� �־��ָ� ������
        '�޹� ������(��������)
        MOVE G6A,100,  69, 145, 103,  100
        MOVE G6D, 97, 87, 160,  68, 102
        WAIT

        �����޸��⿬�Ӻб�üũ=1

        RETURN

        'GOSUB �յڱ�������
        '            IF �Ѿ���Ȯ�� = 1 THEN
        '                �Ѿ���Ȯ�� = 0
        '                GOTO RX_EXIT
        '            ENDIF
        '
        '        ����COUNT = ����COUNT + 1
        '            IF ����COUNT > ����Ƚ�� THEN  GOTO �����޸���50_3_stop
        '
        '        ERX 4800,A, �����޸���50_4
        '            IF A <> A_old THEN
�����޸���_����_0:

        �����޸��⿬�Ӻб�üũ=0

        '�ڿ� �ִ� ������ ������
        MOVE G6D,90,  93, 115, 100, 104
        MOVE G6A,104,  74, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB ����ȭ�ڼ�


        RETURN

    ELSEIF �����޸��⿬�Ӻб�üũ=1 THEN
        '*********************************

�����޸���50_4:
        '�����߷� �����߽��̵�
        MOVE G6D,95,  95, 100, 120, 104
        MOVE G6A,104,  77, 147,  93,  102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


�����޸���50_5:
        '������ ��¦ ������ ����
        MOVE G6D,95,  75, 122, 120, 104
        MOVE G6A,104,  78, 147,  90,  100
        WAIT


�����޸���50_6:
        '������ ������(��������)
        MOVE G6D,103,  69, 145, 103,  100
        MOVE G6A, 95, 87, 160,  68, 102
        WAIT

        �����޸��⿬�Ӻб�üũ=0

        RETURN

�����޸���_����_1:

        �����޸��⿬�Ӻб�üũ=0

        '�ڿ� �ִ� �޹� ��������
        MOVE G6A,90,  93, 115, 100, 104
        MOVE G6D,104,  74, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB ����ȭ�ڼ�

        RETURN

    ENDIF


    '******************************************
    '******************************************
    '******************************************
��_�޸���_����:
    �Ѿ���Ȯ�� = 0
    �����޸��⿬��üũ=0
    �����޸��⿬�Ӻб�üũ=0

    GOSUB All_motor_mode3
    ����COUNT = 0
    DELAY 50

    'SPEED 8
    SPEED 6
    HIGHSPEED SETON

    'IF ������� = 0 THEN

    '�ȿø���
    MOVE G6B, 185,18,90
    MOVE G6C, 185,18,90
    WAIT

    '�����ȱ��θ���
    MOVE G6B, 185,18,90
    MOVE G6C, 185,18,60
    WAIT

    '������� = 1
    MOVE G6A,95,  75, 144,  93, 101
    MOVE G6D,101,  76, 144,  93, 98
    WAIT

    MOVE G6A,95,  79, 119, 120, 104
    MOVE G6D,104,  76, 145,  91,  102
    WAIT

    'GOTO ��_�޸���50_2
    '    ELSE
    '        ������� = 0
    '        MOVE G6D,95,  76, 145,  93, 101
    '        MOVE G6A,101,  77, 145,  93, 98
    '        WAIT
    '
    '        MOVE G6D,95,  80, 120, 120, 104
    '        MOVE G6A,104,  77, 146,  91,  102
    '        WAIT


    'GOTO �����޸���50_5
    'ENDIF

    RETURN

    '   **********************
��_�޸���_����:

    IF �����޸��⿬�Ӻб�üũ=0 THEN

        IF �����޸��⿬��üũ=1 THEN

��_�޸���50_1:
            MOVE G6A,95,  94, 99, 120, 104
            MOVE G6D,104,  76, 146,  93,  102
            WAIT

        ENDIF

��_�޸���50_2:

        �����޸��⿬��üũ=1

        MOVE G6A,95,  74, 121, 120, 104
        MOVE G6D,104,  77, 146,  90,  100
        WAIT

��_�޸���50_3:
        MOVE G6A,103,  68, 144, 103,  100
        MOVE G6D, 95, 86, 159,  68, 102
        WAIT

        �����޸��⿬�Ӻб�üũ=1

        RETURN

        'GOSUB �յڱ�������
        '            IF �Ѿ���Ȯ�� = 1 THEN
        '                �Ѿ���Ȯ�� = 0
        '                GOTO RX_EXIT
        '            ENDIF
        '
        '        ����COUNT = ����COUNT + 1
        '            IF ����COUNT > ����Ƚ�� THEN  GOTO �����޸���50_3_stop
        '
        '        ERX 4800,A, �����޸���50_4
        '            IF A <> A_old THEN
��_�޸���_����_0:

        �����޸��⿬�Ӻб�üũ=0

        MOVE G6D,90,  92, 114, 100, 104
        MOVE G6A,104,  73, 144,  91,  102
        WAIT
        HIGHSPEED SETOFF

        SPEED 10
        MOVE G6C, 100,38,90
        MOVE G6B,100,38,90

        SPEED 5
        GOSUB ����ȭ�ڼ�


        RETURN

    ELSEIF �����޸��⿬�Ӻб�üũ=1 THEN
        '*********************************

��_�޸���50_4:
        MOVE G6D,95,  94, 99, 120, 104
        MOVE G6A,104,  76, 146,  93,  102
        WAIT


��_�޸���50_5:
        MOVE G6D,95,  74, 121, 120, 104
        MOVE G6A,104,  77, 146,  90,  100
        WAIT


��_�޸���50_6:
        MOVE G6D,103,  68, 144, 103,  100
        MOVE G6A, 95, 86, 159,  68, 102
        WAIT

        �����޸��⿬�Ӻб�üũ=0

        RETURN

��_�޸���_����_1:

        �����޸��⿬�Ӻб�üũ=0

        MOVE G6A,90,  92, 114, 100, 104
        MOVE G6D,104,  73, 144,  91,  102
        WAIT
        HIGHSPEED SETOFF

        SPEED 10
        MOVE G6C, 100,38,90
        MOVE G6B,100,38,90

        SPEED 5
        GOSUB ����ȭ�ڼ�

        RETURN

    ENDIF


    '******************************************




    '******************************************
    '��� ���� �Ҷ� ���
��������:
    ����COUNT = 0
    ����ӵ� = 8
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

    GOSUB Leg_motor_mode3

    IF ������� = 0 THEN
        ������� = 1

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

        GOTO ��������_1
    ELSE
        ������� = 0

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


        GOTO ��������_2	

    ENDIF


    '*******************************

��������_1:

    'ETX 4800,11 '�����ڵ带 ����
    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT


    SPEED ����ӵ�

    'GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO MAIN
    '    ENDIF

    ' ����COUNT = ����COUNT + 1
    '    IF ����COUNT > ����Ƚ�� THEN  GOTO ������������

    ' ERX 4800,A, ��������_2
    '    IF A = 11 THEN
    '        GOTO ��������_2
    '    ELSE
    '
    '���Ⱑ �޹� ������ �ϰ� ����
������������_�޹�:
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
    GOSUB �⺻�ڼ�2

    RETURN

    '**********

��������_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

��������_3:
    ETX 4800,11 '�����ڵ带 ����

    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�

    ' GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, ��������_4
    '    IF A = 11 THEN
    '        GOTO ��������_4
    '    ELSE

������������_������:

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
    GOSUB �⺻�ڼ�2

    'GOTO RX_EXIT
    RETURN



    '��������_4:
    '    '�޹ߵ��10
    '    MOVE G6A,90, 90, 120, 105, 110,100
    '    MOVE G6D,110,  76, 146,  93,  96,100
    '    MOVE G6B, 90
    '    MOVE G6C,110
    '    WAIT
    '
    '    GOTO ��������_1

    '************************************************
    '************************************************
�����ʿ�����_SHORT:
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
    GOSUB ����ȭ�ڼ�
    GOSUB All_motor_mode3

    RETURN

    '*************

���ʿ�����_SHORT: '****
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
    GOSUB ����ȭ�ڼ�
    GOSUB All_motor_mode3

    RETURN

    '**********************************************
���ʿ�����70:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    '1 �ٸ� �������� ���
    'SPEED 10
    '    MOVE G6A, 90,  90, 120, 105, 110, 100	
    '    MOVE G6D,100,  76, 145,  93, 107, 100	
    '    WAIT

    '1 �ٸ� �������� ��� TEST
    ' SPEED 10
    '    MOVE G6A, 90,  92, 120, 108, 110, 100	
    '    MOVE G6D,100,  76, 145,  93, 107, 100	
    '    WAIT

    '�������� ���鼭 �� ������ ���� �Ѱ�
    '1 �ٸ� �������� ��� TEST2
    SPEED 10
    MOVE G6A, 90,  98, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100	
    WAIT

    '2 �ٸ� �������� ������
    SPEED 13
    MOVE G6A, 102,  76, 145, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    '3 �ٸ� �������� ���� ������
    SPEED 13
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    '4
    '�ٸ� �� ������
    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT

    '5
    '����ȭ�ڼ�
    SPEED 8
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN

    '******************************************

    '******************************************
�����ʿ�����70:
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
    '����ȭ�ڼ�
    SPEED 8
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN

    '**********************************************

�����ʿ�����_LONG:
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


    '  ERX 4800, A ,�����ʿ�����70����_loop
    '    IF A = A_OLD THEN  GOTO �����ʿ�����70����_loop
    '�����ʿ�����70����_stop:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    GOSUB All_motor_mode3

    RETURN
    '**********************************************
���ʿ�����_LONG:
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

    '   ERX 4800, A ,���ʿ�����70����_loop	
    '    IF A = A_OLD THEN  GOTO ���ʿ�����70����_loop
    '���ʿ�����70����_stop:

    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    GOSUB All_motor_mode3

    RETURN

    '**********************************************
    '************************************************
    '*********************************************

    '������3:
    '    MOTORMODE G6A,3,3,3,3,2
    '    MOTORMODE G6D,3,3,3,3,2
    '������3_LOOP:
    '
    '    IF ������� = 0 THEN
    '        ������� = 1
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
    '        ������� = 0
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
    '    GOSUB �⺻�ڼ�2
    '
    '
    '    GOTO RX_EXIT
    '
    '    '**********************************************
    '��������3:
    '    MOTORMODE G6A,3,3,3,3,2
    '    MOTORMODE G6D,3,3,3,3,2
    '
    '��������3_LOOP:
    '
    '    IF ������� = 0 THEN
    '        ������� = 1
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
    '        ������� = 0
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
    '    GOSUB �⺻�ڼ�2
    '
    '    GOTO RX_EXIT

    '******************************************************
    '**********************************************
������_SHORT:

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

    '����ȭ�ڼ�
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOSUB All_motor_mode3

    RETURN

    '**********************************************
��������_SHORT:
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
    'SHORT���� �ڷ� �и��� ��� �ڷιи��� ���� �ݴ������� �߸��� �����߽��� �ű�� ��
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
    'GOSUB �⺻�ڼ�2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOSUB All_motor_mode3

    RETURN



    '**********************************************
    '**********************************************
������_LONG:
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
��������_LONG:
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
��������60:
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

    '����ȭ�ڼ�
    SPEED 8
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN
    '****************************************

������60:

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

    '����ȭ�ڼ�
    SPEED 8
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN

�ڷ��Ͼ��:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB ���̷�OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB �⺻�ڼ�

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
    GOSUB �⺻�ڼ�

    �Ѿ���Ȯ�� = 1

    DELAY 200
    GOSUB ���̷�ON

    RETURN


    '**********************************************
�������Ͼ��:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB ���̷�OFF

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
    GOSUB �⺻�ڼ�
    �Ѿ���Ȯ�� = 1

    '******************************
    DELAY 200
    GOSUB ���̷�ON
    RETURN

    '******************************************
    '******************************************
�յڱ�������:
    FOR i = 0 TO COUNT_MAX
        A = AD(�յڱ���AD��Ʈ)	'���� �յ�
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF A < MIN THEN
        GOSUB �����
    ELSEIF A > MAX THEN
        GOSUB �����
    ENDIF

    RETURN
    '**************************************************
�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A < MIN THEN GOSUB �������Ͼ��
    IF A < MIN THEN
        'ETX  4800,16
        GOSUB �ڷ��Ͼ��

    ENDIF
    RETURN

�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A > MAX THEN GOSUB �ڷ��Ͼ��
    IF A > MAX THEN
        'ETX  4800,15
        GOSUB �������Ͼ��
    ENDIF
    RETURN
    '**************************************************
�¿��������:
    FOR i = 0 TO COUNT_MAX
        B = AD(�¿����AD��Ʈ)	'���� �¿�
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB �⺻�ڼ�	
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
Number_Play: '  BUTTON_NO = ���ڴ���


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
���ܼ��Ÿ�����Ȯ��:

    '5����Ʈ�� ���ܼ��Ÿ��� ����
    ���ܼ��Ÿ��� = AD(5)

    ' IF ���ܼ��Ÿ��� > 50 THEN '50 = ���ܼ��Ÿ��� = 25cm
    '        MUSIC "C"
    '        DELAY 200
    '    ENDIF
    '
    ���ܼ��Ÿ���_Old=���ܼ��Ÿ���
    ���ܼ��Ÿ���_Old=160-���ܼ��Ÿ���_Old/2

    ���ܼ��Ÿ���_Old=  ���ܼ��Ÿ���_Old+100

    IF ���ܼ��Ÿ���_Old>180 THEN

        ���ܼ��Ÿ���_Old=180

    ELSEIF ���ܼ��Ÿ���_Old<100  THEN
        ���ܼ��Ÿ���_Old=100

    ENDIF

    ETX 4800, ���ܼ��Ÿ���_Old

    RETURN


    '******************************************
    '************************************************
    '��ܿ����߳����� 3cm
��ܿ����߳�����1cm:

    GOSUB All_motor_mode3

    '������ ���� ����ֱ� ''''
    SPEED 5
    MOVE G6A, 100, 110,  112, 92,  101, 100
    MOVE G6D,  100,  112, 112, 92, 101, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹߸� ��������
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  85,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT 	

    '������ ���ǹ߸����   ����ֱ�
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT 	

    '������ ����  ����ֱ�
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  105, 63, 119, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ����ֱ�
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  15, 139, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹������� �������
    SPEED 2
    MOVE G6A, 112, 110,  112, 77,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹��� ���̵��
    SPEED 1
    MOVE G6A, 112, 125,  102, 65,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT	

    '�޹��� ���
    SPEED 5
    MOVE G6A, 108, 140,  92, 82,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '���� �����߷� �����ϰ� �������� ����
    SPEED 5
    MOVE G6A, 105, 140,  92, 102,  81, 100
    MOVE G6D,  95,  15, 169, 149, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� , ������ �����
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  81, 100
    MOVE G6D,  95,  35, 149, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ���� �������� ����� ';';'
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  96, 100
    MOVE G6D,  100,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ �߸� �������� ����̱�
    SPEED 5
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  105,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������ ��ü ���̱�
    SPEED 3
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  110,  45, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ���� �ణ �ø���
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  110,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ���� �ణ �ø��� (������ �߸� �߽� ���)
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������ �������
    SPEED 3
    MOVE G6A, 97, 105,  103, 132,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������ ������� 2
    SPEED 3
    MOVE G6A, 97, 110,  97, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������ ������� 3
    SPEED 3
    MOVE G6A, 97, 110,  107, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������1
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������2
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  107,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������3
    SPEED 3
    MOVE G6A, 97, 55,  149, 136,  96, 100
    MOVE G6D,  107,  55, 149, 139, 104, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT


    SPEED 4
    GOSUB �⺻�ڼ�''�˼� ���

    ETX 4800, 254

    RETURN

    '************************************************

    '********************************************
    '��ܿ����߿�����1cm
��ܿ����߿�����1cm:
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
    '�޹߷� �����ϰ� ������ �������� ���ø��� ����
    SPEED 8
    MOVE G6D, 90, 110, 110, 100, 114
    MOVE G6A,113,  71, 155,  90,  94
    WAIT


    '���ø� �������� �������� ��������� �����̴� ����
    'MOVE G6D,  80, 55, 130, 140, 114
    'MOVE G6A,113,  70, 155,  90,  94
    SPEED 12
    MOVE G6D,  80, 55, 130, 140, 114
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    '��ܿ� ���ʹ� ����� ����(�����ʹ߿� �����߽� �Ǹ�)
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

    '������ ��� �ȿø��鼭 �����߽����
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
    '������ �Ȱ��� �޹߸� ������ ����̱�
    'SPEED 8
    'MOVE G6D, 114, 90, 100, 150,95,
    'MOVE G6A,95,  90, 165,  70, 105
    'WAIT
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,95,  105, 165,  55, 105
    WAIT

    '�״�� �޹� ���ø���
    'SPEED 8
    'MOVE G6D, 114, 90, 100, 150,95,
    'MOVE G6A,95,  90, 165,  70, 105
    'WAIT
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,95,  135, 135,  55, 105
    WAIT

    '�޹��� ���ø��� �ް�ݰ�������
    'SPEED 12
    'MOVE G6D, 114, 90, 100, 150,95,
    'MOVE G6A,90,  120, 40,  140, 108
    'WAIT
    SPEED 5
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,90,  135, 40,  140, 108
    WAIT

    '�޹��������� �� ���� �ٴڿ� ���̱�
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

    '�� �ٴڿ� ���̱�(�̶����� �����ڼ�)
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

    '�����ڼ�
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

    '��������ᱸ��_�ȿø���:
    '
    '    SPEED 15
    '    '�ȼ����ø����ڼ�
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  189,  90
    '    WAIT
    '
    '    RETURN
    '
    '    '������ ������� �ᱸ���ϴ� ����
    '�������_��װ��ȳ�����:
    '
    '    SPEED 15
    '    '�� ������
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
    '    '������� �ᱸ��
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
    '    '�� ������
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
    '    '������� �ᱸ��
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
    '    '�� ������
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
    '    '������� �ᱸ��
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
    '    '�� ������
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
    '    '������� �ᱸ��
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
    '    '�ȳ������ڼ�1
    '    SPEED 15
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,45,  189,  165
    '    WAIT
    '
    '    '�ȳ������ڼ�2
    '    SPEED 15
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,60,  159,  165
    '    WAIT
    '
    '    '�ȳ������ڼ�3
    '    SPEED 15
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  159,  165
    '    WAIT
    '
    '    '�ȳ������ڼ�4
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
    '�������_�ȱ�_����:
    '
    '    ����ӵ� =10
    '
    '    ''����ȭ�ڼ�
    '    '	MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90
    '    '    MOVE G6C,100,  35,  90
    '    '    WAIT
    '
    '    '�޹� ������
    '    SPEED ����ӵ�
    '    MOVE G6A,98, 66, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    GOTO �������_�ȱ�_1
    '
    '�������_�ȱ�_1:
    '
    '    '������ ������
    '    'SPEED ����ӵ�
    '    '	MOVE G6A,98, 76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  66, 145,  103, 101, 100
    '    '    MOVE G6B,100,  35,  90
    '    '    MOVE G6C,100,  35,  90
    '    '    WAIT
    '
    '    SPEED ����ӵ�
    '    MOVE G6A,98, 76, 145,  93, 101, 100
    '    MOVE G6D,98,  69, 145,  100, 101, 100
    '    WAIT
    '
    '    '�޹� ������
    '    SPEED ����ӵ�
    '    MOVE G6A,98, 66, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    'GOSUB �յڱ�������
    '    '    IF �Ѿ���Ȯ�� = 1 THEN
    '    '        �Ѿ���Ȯ�� = 0
    '    '        GOTO RX_EXIT
    '    '    ENDIF
    '
    '    ����COUNT = ����COUNT + 1
    '    IF ����COUNT > ����Ƚ�� THEN  GOTO �������_�ȱ�_����
    '
    '    GOTO �������_�ȱ�_1
    '
    '    RETURN
    '
    '�������_�ȱ�_����:
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
    '�������_�ȱ�:
    '
    '    ����Ƚ��=2
    '    GOSUB �������_�ȱ�_����
    '    RETURN
    '
    '    '**********************************************
    '�������_������:
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
    '    GOSUB �������_�⺻�ڼ�
    '    RETURN
    '
    '    '**********************************************
    '    '**********************************************
    '�������_��������:
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
    '    GOSUB �������_�⺻�ڼ�
    '    RETURN


    '**********************************************
    '**********************************************
    '
    '�������_���ʿ�����:
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
    '    GOSUB �������_�⺻�ڼ�
    '    GOSUB All_motor_mode3
    '    RETURN
    '
    '    '**********************************************
    '    '**********************************************
    '
    '
    '�������_�����ʿ�����:
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
    '    GOSUB �������_�⺻�ڼ�
    '    GOSUB All_motor_mode3
    '    RETURN
    '
    '    '******************************************	
    '    '******************************************	
    '�������_�ȰŸ����߱�:
    '
    '    '����ȭ�ڼ�
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,100,  35,  90
    '
    '    '�Ÿ����߷��� �� �ø���
    '    SPEED 3
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,150,  15,  90
    '    MOVE G6C,150,  15,  90
    '
    '    RETURN

    '*************************************
    '    '*************************************
    '�������_CLOSE�ȱ�_����:
    '    ����COUNT=0
    '
    '    SPEED 5
    '    '�޹� �����������
    '    MOVE G6A,98,  78, 145,  101, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    GOTO �������_CLOSE�ȱ�_1
    '
    '�������_CLOSE�ȱ�_1:
    '
    '    SPEED 5
    '    '������ �����������
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  78, 145,  101, 101, 100
    '    WAIT
    '
    '    SPEED 5
    '    '�޹� �����������
    '    MOVE G6A,98,  78, 145,  101, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    'GOSUB �յڱ�������
    '    '    IF �Ѿ���Ȯ�� = 1 THEN
    '    '        �Ѿ���Ȯ�� = 0
    '    '        GOTO RX_EXIT
    '    '    ENDIF
    '
    '    GOTO �������_CLOSE�ȱ�_����
    '
    '�������_CLOSE�ȱ�_����:
    '
    '    SPEED 3
    '    '������ �����ΰ���  �޹��ϰ� ���߱�
    '    MOVE G6A,98,  78, 145,  101, 101, 100
    '    MOVE G6D,98,  78, 145,  101, 101, 100
    '    WAIT
    '
    '    SPEED 5
    '    GOSUB ����ȭ�ڼ�
    '
    '    RETURN
    '
    '******************************************
    '******************************************


    '******************************************	
    '******************************************	
    '���ܼ� �Ÿ��� 130�̻� ������������ �ȵǰ� 114�̸� ���� ������ �ȵ�
    '������
    '�������_������:
    '
    '    'GOSUB �������_�ȰŸ����߱�
    '    '
    '    '    DELAY 1000
    '    '
    '    '    ����Ƚ��=10
    '    '    GOSUB �������_CLOSE�ȱ�_����
    '    '    GOSUB �������_CLOSE�ȱ�_1
    '    '    GOSUB �������_CLOSE�ȱ�_����
    '    '
    '    '    DELAY 1000
    '
    '    GOSUB ����ȭ�ڼ�
    '
    '    DELAY 500
    '
    '    GOSUB ��������ᱸ��_�ȿø���
    '    DELAY 500
    '    GOSUB �������_��װ��ȳ�����
    '    GOSUB �������_CLOSE�ȱ�_����
    '    GOSUB �������_CLOSE�ȱ�_1
    '    GOSUB �������_CLOSE�ȱ�_����
    '
    '    GOSUB ��������ᱸ��_�ȿø���
    '    DELAY 500
    '    GOSUB �������_��װ��ȳ�����
    '    GOSUB �������_CLOSE�ȱ�_����
    '    GOSUB �������_CLOSE�ȱ�_1
    '    GOSUB �������_CLOSE�ȱ�_����
    '
    '    GOSUB ��������ᱸ��_�ȿø���
    '    DELAY 500
    '    GOSUB �������_��װ��ȳ�����
    '
    '    RETURN

    '�ֽŲ�
�������_������:

    '���ݰ�(���2)-�Ȳ�ġ�����ڼ�
    'GOSUB �������_�ȿø����ڼ�
    '
    '    GOSUB �������_�Ⱥ��̴��ڼ�
    '
    '    GOSUB ��������_LONG
    '
    '    GOSUB �������_�ȿø����ڼ�
    '    GOSUB ���ʿ�����_LONG
    '    GOSUB �������_�Ⱥ��̴��ڼ�
    '    DELAY 200
    '    GOSUB ������_LONG
    '    DELAY 200
    '    GOSUB �ȱ�_FAST_����
    '    GOSUB �ȱ�_FAST_����
    '    GOSUB �ȱ�_FAST_����
    '    DELAY 200
    '    GOSUB �������_�Ȳ�ġ_�����̱�
    '    DELAY 200
    '    GOSUB ��������_SHORT
    '
    '    GOSUB �������_�ȿø����ڼ�
    '    GOSUB ���ʿ�����_LONG
    '    GOSUB �������_�Ⱥ��̴��ڼ�
    '    DELAY 200
    '    GOSUB ������_LONG
    '    DELAY 200
    '    GOSUB �ȱ�_FAST_����
    '    GOSUB �ȱ�_FAST_����
    '    GOSUB �ȱ�_FAST_����
    '    DELAY 200
    '    GOSUB �������_�Ȳ�ġ_�����̱�
    '    DELAY 200
    '    GOSUB ��������_SHORT

    '������ (���1)- �Ⱥ��̴��ڼ� ������Ʒ�(c) 60
    'GOSUB �������_�ȿø����ڼ�
    '
    '        GOSUB �������_�Ⱥ��̴��ڼ�
    '
    '        GOSUB ���ʿ�����70
    '        GOSUB ������_LONG
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �������_�Ȳ�ġ_�����̱�
    '        GOSUB ��������_SHORT
    '
    '        GOSUB ���ʿ�����70
    '        GOSUB ������_LONG
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �������_�Ȳ�ġ_�����̱�
    '        GOSUB ��������_SHORT
    '
    '        GOSUB ���ʿ�����70
    '        GOSUB ������_LONG
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �������_�Ȳ�ġ_�����̱�
    '        GOSUB ��������_SHORT
    '
    '        GOSUB ���ʿ�����70
    '        GOSUB ������_LONG
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �ȱ�_FAST_����
    '        GOSUB �������_�Ȳ�ġ_�����̱�
    '        GOSUB ��������_SHORT

    '���3
    ����Ƚ��=3
    GOSUB CLOSE�ȱ�_����
    GOSUB CLOSE�ȱ�_����
    GOSUB CLOSE�ȱ�_����

    '1
    GOSUB ���ʿ�����_LONG
    'GOSUB ���ʿ�����_T
    GOSUB CLOSE�ȱ�_����
    GOSUB �������_�����ȿ���������
    GOSUB �������_�����ȿ����ø���
    GOSUB CLOSE�ȱ�_����


    '2
    'GOSUB CLOSE�ȱ�_����
    GOSUB ���ʿ�����_LONG
    'GOSUB ���ʿ�����_SHORT
    GOSUB CLOSE�ȱ�_����
    GOSUB �������_�����ȿ���������
    GOSUB �������_�����ȿ����ø���
    GOSUB CLOSE�ȱ�_����


    '3
    'GOSUB CLOSE�ȱ�_����
    GOSUB ���ʿ�����_LONG
    GOSUB CLOSE�ȱ�_����
    GOSUB �������_�����ȿ���������
    'GOSUB ���ʿ�����_SHORT


    'GOSUB �������_���ȿø���

    RETURN

    '******************************************	
�������_�ȿø����ڼ�:

    SPEED 15
    '�ȼ����ø����ڼ�
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,85,  189,  90
    WAIT

    RETURN

    '�������_�ȴ��ø����ڼ�:
    '
    '    SPEED 15
    '    '�ȼ����ø����ڼ�
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,75,  189,  90
    '    WAIT
    '
    '    RETURN

�������_�Ⱥ��̴��ڼ�:

    ' SPEED 3
    '    '    '�ȼ����ø����ڼ�
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,52,  189,  110
    '    WAIT

    SPEED 3
    '    '�ȼ����ø����ڼ�
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,80,  189,  110
    WAIT
    'C,60

    RETURN

�������_�ȳ������ڼ�:

    ' SPEED 3
    '    '    '�ȼ����ø����ڼ�
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,52,  189,  110
    '    WAIT

    SPEED 3
    '    '�ȼ����ø����ڼ�
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,59,  189,  110
    WAIT

    RETURN

    '�������_�ȴ��������ڼ�:
    '
    '    ' SPEED 3
    '    '    '    '�ȼ����ø����ڼ�
    '    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,52,  189,  110
    '    '    WAIT
    '
    '    SPEED 3
    '    '    '�ȼ����ø����ڼ�
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,40,  189,  110
    '    WAIT
    '
    '    RETURN

�������_�ȿ������������ڼ�:

    ' SPEED 3
    '    '    '�ȼ����ø����ڼ�
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,52,  189,  110
    '    WAIT

    SPEED 5
    '    '�ȼ����ø����ڼ�
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,15,  189,  110
    WAIT

    RETURN

    '******************************************	
�������_�Ȳ�ġ_�����̱�:

    '��������
    SPEED 10
    MOVE G6B,,  ,  ,
    MOVE G6C,,  ,  110

    '��������
    SPEED 15
    MOVE G6B,,  ,  ,
    MOVE G6C,,  ,  150

    '�Ȳ�ġ������
    'SPEED 10
    '    MOVE G6B,,  ,  90,
    '    MOVE G6C,35,  ,  170

    '��������
    SPEED 10
    MOVE G6B,,  ,  ,
    MOVE G6C,,  ,  110

    RETURN

    '******************************************	
�������_FAST����_���ڼ�:
    SPEED 3
    '    '�ȼ����ø����ڼ�
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,40,  185,  130
    MOVE G6C,40,  185,  130
    WAIT

    RETURN

    '******************************************	
�������_�����ȿ����ø���:

    SPEED 3
    MOVE G6C,62,  180,  147

    RETURN
    '******************************************

    '******************************************	
�������_�����ȿ���������:

    '������ �������� ����
    SPEED 3
    MOVE G6B,60,  176,  145
    MOVE G6C,62,  180,  163

    '������ ������
    SPEED 3
    MOVE G6B,60,  176,  145
    MOVE G6C,10,  183,  167

    RETURN
    '******************************************
    '******************************************	
�������_�������߰�������:

    SPEED 3
    MOVE G6B,60,  176,  145
    MOVE G6C,18,  183,  142

    RETURN
    '******************************************


�������ȱ�_����:
    �Ѿ���Ȯ�� = 0
    �����޸��⿬��üũ=0
    �����޸��⿬�Ӻб�üũ=0

    GOSUB All_motor_mode3
    ����COUNT = 0
    DELAY 50

    'SPEED 8
    SPEED 6
    HIGHSPEED SETON

    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        WAIT

        MOVE G6A,95,  80, 120, 120, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT

        GOTO �������ȱ�_2
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        WAIT

        MOVE G6D,95,  80, 120, 120, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

        GOTO �������ȱ�_5

    ENDIF



    '   **********************
�������ȱ�_����:

    ' IF �����޸��⿬�Ӻб�üũ=0 THEN
    '
    '        IF �����޸��⿬��üũ=1 THEN

�������ȱ�_1:
    MOVE G6A,95,  95, 100, 120, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT

    ' ENDIF

�������ȱ�_2:

    �����޸��⿬��üũ=1

    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  78, 147,  90,  100
    WAIT

�������ȱ�_3:
    MOVE G6A,103,  69, 145, 103,  100
    MOVE G6D, 95, 87, 160,  68, 102
    WAIT

    �����޸��⿬�Ӻб�üũ=1

    GOTO �������ȱ�_����_0

    'GOSUB �յڱ�������
    '            IF �Ѿ���Ȯ�� = 1 THEN
    '                �Ѿ���Ȯ�� = 0
    '                GOTO RX_EXIT
    '            ENDIF
    '
    '        ����COUNT = ����COUNT + 1
    '            IF ����COUNT > ����Ƚ�� THEN  GOTO �����޸���50_3_stop
    '
    '        ERX 4800,A, �����޸���50_4
    '            IF A <> A_old THEN
�������ȱ�_����_0:

    �����޸��⿬�Ӻб�üũ=0

    MOVE G6D,90,  93, 115, 100, 104
    MOVE G6A,104,  74, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 5
    GOSUB ����ȭ�ڼ�


    RETURN

    ' ELSEIF �����޸��⿬�Ӻб�üũ=1 THEN
    '*********************************

�������ȱ�_4:
    MOVE G6D,95,  95, 100, 120, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


�������ȱ�_5:
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  78, 147,  90,  100
    WAIT


�������ȱ�_6:
    MOVE G6D,103,  69, 145, 103,  100
    MOVE G6A, 95, 87, 160,  68, 102
    WAIT

    �����޸��⿬�Ӻб�üũ=0

    GOTO �������ȱ�_����_1

�������ȱ�_����_1:

    �����޸��⿬�Ӻб�üũ=0

    MOVE G6A,90,  93, 115, 100, 104
    MOVE G6D,104,  74, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 5
    GOSUB ����ȭ�ڼ�

    RETURN

    ' ENDIF

    '******************************************
    '******************************************
�������_�ȱ�_FAST_����:

    ����COUNT=0
    'HIGHSPEED SETON
    ����ӵ�=12

    '�ȿø��� �ڼ�
    SPEED 10
    MOVE G6B,50,  180,  138
    MOVE G6C,50,  185,  141

    ''����ȭ�ڼ�
    '  MOVE G6A,98,  76, 145,  93, 101, 100
    '        MOVE G6D,98,  76, 145,  93, 101, 100
    '        MOVE G6B,100,  35,  90
    '        MOVE G6C,100,  35,  90
    '        WAIT


    '�޹� ������
    ' MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT

    SPEED 3
    '�׽�Ʈ1
    MOVE G6A,98,  61, 140,  112, 101, 100
    MOVE G6D,98,  87, 140,  95, 101, 100
    WAIT

    RETURN

�������_�ȱ�_FAST_����:

    SPEED ����ӵ�
    '������ ������

    'IF ��������=2 OR ��������=3 THEN

    '��������( ���� �ϰ� ���� ���� ���� �ٱ������� �߸��� ���ָ��)
    MOVE G6D,98,  61, 140,  111, 101, 100
    MOVE G6A,92,  87, 140,  95, 101, 100
    WAIT

    '��������(�ణ �������� ���� )
    'D,+2
    'MOVE G6D,98,  60, 145,  109, 101, 100
    '    MOVE G6A,100,  86, 145,  93, 101, 100
    '    WAIT

    ' ELSEIF ��������=4 THEN
    '
    '        '��������
    '        MOVE G6D,98,  60, 145,  109, 101, 100
    '        MOVE G6A,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '    ELSEIF ��������=1 THEN
    '
    '        '�׽�Ʈ2(�������� �ְ�)
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

    SPEED ����ӵ�

    '�޹� ������
    'IF ��������=2 OR ��������=1 THEN

    '��������
    MOVE G6A,98,  61, 140,  112, 101, 100
    MOVE G6D,98,  87, 140,  95, 101, 100
    WAIT	

    'ELSEIF ��������=3 THEN
    '
    '        MOVE G6A,98,  60, 145,  110, 101, 100
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        WAIT
    '
    '        '�׽�Ʈ2(���������� �ְ�)
    '        'A,+4
    '        'D,
    '        MOVE G6A,102,  60, 145,  110, 101, 100
    '        MOVE G6D,98,  86, 145,  93, 101, 100
    '        WAIT

    'ELSEIF ��������=4 THEN
    '
    '        '�׽�Ʈ2(�������� �ְ�)
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

�������_�ȱ�_FAST_����:

    SPEED ����ӵ�
    MOVE G6D,98,  61, 140,  111, 101, 100
    MOVE G6A,96,  87, 140,  95, 101, 100
    WAIT

    '�׽�Ʈ1
    'SPEED 2
    '    MOVE G6A,98,  60, 145,  106, 101, 100
    '    MOVE G6D,98,  76, 145,  106, 101, 100
    '    WAIT

    SPEED 2
    '����ȭ�ڼ�
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    SPEED 5
    '�� ������
    MOVE G6A,98,  78, 145,  93, 101, 100
    MOVE G6D,98,  78, 145,  93, 101, 100

    'HIGHSPEED SETOFF

    RETURN

    '**********************************************
�������_���ȿø���:

    '�����ڼ�
    SPEED 5
    MOVE G6B,40,  185,  135
    MOVE G6C,40,  185,  135

    '���ȿø���
    SPEED 5
    MOVE G6B,100,  185,  100
    MOVE G6C,40,  185,  130

    '�Ȳ�ġ���
    SPEED 10
    MOVE G6B,100,  185,  100
    MOVE G6C,40,  188,  180

    '�Ȳ�ġ������
    SPEED 10
    MOVE G6B,100,  185,  130
    MOVE G6C,40,  188,  165

    DELAY 1000

    '���ȳ�����
    SPEED 3
    MOVE G6B,10,  155,  160
    MOVE G6C,40,  188,  165

    '���Ȼ�¦�ø��� (���� ������ )
    SPEED 3
    MOVE G6B,15,  145,  160
    MOVE G6C,40,  188,  165

    '���㸮�ڷ� ������(�� ������ ������ �޹߷� ���� )
    SPEED 5
    MOVE G6A,98,  78, 145,  85, 101, 100
    MOVE G6D,98,  78, 145,  85, 101, 100

    RETURN

    '**********************************************
�ͳ�_����_�غ��ڼ�:

    ����COUNT=0

    '�� ������
    'SPEED 5
    SPEED 10
    MOVE G6A,101,  76, 145,  93, 101, 100
    MOVE G6D,101,  76, 145,  93, 101, 100
    MOVE G6B,  45,  29,  81, 100, 100, 101
    MOVE G6C,  45,  29,  81, 100, 100, 100
    WAIT

    '�߸� ������ ������, ���� ������ ������
    'SPEED 5
    SPEED 10
    MOVE G6A,101,  126, 85,  113, 101, 100
    MOVE G6D,101,  126, 85,  113, 101, 100
    MOVE G6B,  45,  29,  81, 100, 100, 101
    MOVE G6C,  45,  29,  81, 100, 100, 100
    WAIT

    DELAY 100

    '���� �� ������
    'SPEED 5
    SPEED 10
    MOVE G6A,101,  158, 35,  113, 101, 100
    MOVE G6D,101,  158, 35,  113, 101, 100
    MOVE G6B,  45,  29,  81, 100, 100, 101
    MOVE G6C,  45,  29,  81, 100, 100, 100
    WAIT

    'GOTO RX_EXIT

    DELAY 200

    '���� �� ������2
    'SPEED 5
    SPEED 3
    MOVE G6A,101,  146, 35,  83, 101, 100
    MOVE G6D,101,  146, 35,  83, 101, 100
    MOVE G6B,  45,  29,  81, 100, 100, 101
    MOVE G6C,  45,  29,  81, 100, 100, 100
    WAIT

    'DELAY 100

    '�Ѿ��� �� ���� ���

    'SPEED 3
    SPEED 10
    MOVE G6A, 101,  45, 106,  90, 103, 100
    MOVE G6D, 101,  45, 108,  90, 103, 100
    MOVE G6B,  35,  29,  81, 100, 100, 101
    MOVE G6C,  35,  29,  81, 100, 120, 100
    WAIT



    RETURN

    '******************************************	

�ͳ�_����:


    HIGHSPEED SETON
    SPEED 8

    '���� ���� �� �� ��� �����°�(�ι�°����) ���� �ϸ� ��
    '�� ������������ ������

    '�� ������
    ' MOVE G6A, 101,  45, 106,  90, 103, 100
    '    MOVE G6D, 101,  45, 106,  90, 103, 100
    '    MOVE G6B,  42,  28,  81, 100, 100, 101
    '    MOVE G6C,  42,  32,  81, 100, 120, 100
    '    WAIT

    '�� ������ test
    MOVE G6A, 101,  45, 106,  90, 99, 100
    MOVE G6D, 101,  45, 106,  90, 103, 100
    MOVE G6B,  47,  26,  84, 100, 100, 101
    MOVE G6C,  47,  37,  83, 100, 120, 100
    WAIT

    HIGHSPEED SETOFF

    '�� �ڷ�
    'SPEED 6
    '    MOVE G6A, 101,  45, 106,  90, 103, 100
    '    MOVE G6D, 101,  45, 106,  90, 103, 100
    '    MOVE G6B,  11,  28,  81, 100, 100, 101
    '    MOVE G6C,  15,  32,  81, 100, 120, 100
    '    WAIT

    '�� �ڷ� test
    SPEED 6
    MOVE G6A, 101,  45, 106,  90, 99, 100
    MOVE G6D, 101,  45, 106,  90, 103, 100
    MOVE G6B,  11,  26,  84, 100, 100, 101
    MOVE G6C,  11,  37,  83, 100, 120, 100
    WAIT

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN
        GOTO �ͳ�_����_�Ͼ��

    ELSE
        GOTO �ͳ�_����
    ENDIF

    RETURN

    '******************************************	
    '******************************************	

�ͳ�_����_�Ͼ��:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    'GOSUB ���̷�OFF

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
    GOSUB ����ȭ�ڼ�
    '�Ѿ���Ȯ�� = 1

    'GOSUB ���̷�ON

    RETURN

    '******************************************	
    '******************************************	
�ͳ�_������:

    GOSUB �ͳ�_����_�غ��ڼ�

    DELAY 1000

    '12
    ����Ƚ��=13
    GOSUB �ͳ�_����

    RETURN

    '******************************************	
    '******************************************	

��ܴ���:

    'GOSUB ���̷�OFF

    '�ɱ�
    'SPEED 15
    SPEED 10
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,130,  30,  85
    MOVE G6C,130,  30,  85, ,80
    WAIT



    '�� ������
    SPEED 15
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,170,  30,  85
    MOVE G6C,170,  30,  85
    WAIT

    '���� �ø���
    SPEED 3
    MOVE G6A,100, 155,  47, 140, 100, 100
    MOVE G6D,100, 155,  47, 140, 100, 100
    MOVE G6B,170,  30,  85
    MOVE G6C,170,  30,  85
    WAIT

    '���� �Ⱥ��̱�
    SPEED 10	
    MOVE G6A, 100, 65,  155, 125, 100, 100
    MOVE G6D, 100, 65,  155, 125, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100
    WAIT

    '�� õõ�� ������
    'SPEED 3
    '    MOVE G6A, 100, 65,  155, 125, 100, 100
    '    MOVE G6D, 100, 65,  155, 125, 100, 100
    '    MOVE G6B,155,  10, 100
    '    MOVE G6C,155,  10, 100
    '    WAIT

    '�� õõ�� ������TEST
    SPEED 3
    MOVE G6A, 100, 10,  155, 125, 100, 100
    MOVE G6D, 100, 10,  155, 125, 100, 100
    MOVE G6B,152,  10, 100
    MOVE G6C,158,  10, 100
    WAIT

    '�� �ɸ��°� �ø���
    SPEED 3
    MOVE G6A, 100, 10,  155, 125, 100, 100
    MOVE G6D, 100, 10,  155, 125, 100, 100
    MOVE G6B,122,  10, 100
    MOVE G6C,125,  10, 100
    WAIT


    '�� �ø��� ���� 2
    SPEED 10
    MOVE G6A, 100, 10,  155, 125, 100, 100
    MOVE G6D, 100, 10,  155, 125, 100, 100
    MOVE G6B,122,  70,  20
    MOVE G6C,125,  70,  20,,15
    WAIT




    '���� ����
    SPEED 10
    MOVE G6A,100, 160, 110, 140, 100, 100
    MOVE G6D,100, 160, 110, 140, 100, 100
    MOVE G6B,140,  70,  20
    MOVE G6C,143,  70,  20,,15
    WAIT

    DELAY 500

    '�޹� ������
    'SPEED 15
    '    MOVE G6A,100,  56, 110,  26, 100, 100
    '    MOVE G6D,100,  71, 177, 162, 100, 100
    '    MOVE G6B,172,  10, 100
    '    MOVE G6C,175,  10, 100
    '    WAIT

    '�޹� ������TEST
    SPEED 15
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  61, 177, 162, 100, 100
    MOVE G6B,172,  10, 100
    MOVE G6C,175,  10, 100
    WAIT

    '������ ������
    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  70, 120, 30, 100, 100
    MOVE G6B,172,  10, 100
    MOVE G6C,175,  10, 100
    WAIT

    '��� ������ '���⼭ �Ѿ�� �Ǵµ�
    SPEED 15
    MOVE G6A,100,  55, 110,  15, 100, 100
    MOVE G6D,100,  55, 110,  15, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,190,  10, 100
    WAIT

    '�߸� , ���� �ű��
    SPEED 15
    MOVE G6A,100,  60, 120,  15, 100, 100
    MOVE G6D,100,  60, 120,  15, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,190,  10, 100
    WAIT

    '���� �߸� ��������
    SPEED 15
    MOVE G6A,100,  100, 80,  15, 100, 100
    MOVE G6D,100,  100, 80,  15, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,190,  10, 100
    WAIT

    DELAY 1000

    '�߸� ��������, �� ������
    'SPEED 15
    SPEED 12
    MOVE G6A,100,  130, 80,  15, 100, 100
    MOVE G6D,100,  130, 80,  15, 100, 100
    MOVE G6B,185,  130, 160
    MOVE G6C,190,  130, 160
    WAIT

    '�߸� ��������, �� ������ 2
    'SPEED 15
    SPEED 10 'TEST
    MOVE G6A,100,  150, 80,  15, 100, 100
    MOVE G6D,100,  150, 80,  15, 100, 100
    MOVE G6B,185,  140, 150
    MOVE G6C,190,  140, 150
    WAIT

    '�߸� �������� �� ������ 3
    SPEED 10
    MOVE G6A,100,  165, 80,  15, 100, 100
    MOVE G6D,100,  165, 80,  15, 100, 100
    MOVE G6B,185,  170, 120
    MOVE G6C,190,  170, 120
    WAIT

    '�� ������
    SPEED 15
    MOVE G6A,100,  165, 80,  15, 100, 100
    MOVE G6D,100,  165, 80,  15, 100, 100
    MOVE G6B,70,  50, 60
    MOVE G6C,70,  50, 60
    WAIT

    '�߸�, ���� �����
    SPEED 7
    MOVE G6A,100,  165, 100,  15, 100, 100
    MOVE G6D,100,  165, 100,  15, 100, 100
    MOVE G6B,40,  50, 60
    MOVE G6C,40,  50, 60
    WAIT

    '�߸� , ���� ����� 2
    SPEED 7
    MOVE G6A,100,  145, 100,  55, 100, 100
    MOVE G6D,100,  145, 100,  55, 100, 100
    MOVE G6B,40,  50, 60
    MOVE G6C,40,  50, 60
    WAIT

    '�߸� , ���� ����� 3' ���⼭ ���� �Ͼ
    SPEED 7
    MOVE G6A,100,  115, 100,  95, 100, 100
    MOVE G6D,100,  115, 100,  95, 100, 100
    MOVE G6B,40,  50, 60
    MOVE G6C,40,  50, 60
    WAIT

    '    SPEED 13
    '    GOSUB �����ڼ�

    SPEED 10
    GOSUB ����ȭ�ڼ�

    GOSUB ���̷�ON

    RETURN
    '******************************************
    '*******************************
    '*************************************************
���_����:

    ����COUNT=0

    '�����ڼ�TEST
    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,181,  16,  86
    MOVE G6C,185,  19,  86
    WAIT

    '�߰��ڼ�
    SPEED 3
    MOVE G6A,100, 155,  28, 146, 100, 100
    MOVE G6D,100, 155,  28, 146, 100, 100
    MOVE G6B,181,  16,  86
    MOVE G6C,185,  19,  86
    WAIT



    '������ �������� �մ���  TEST
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

    'GOTO ���������_LOOP

���_����_LOOP:

    '���� �� ���
    'MOVE G6A, 100, 160,  55, 160, 100
    '    MOVE G6D, 100, 145,  75, 160, 100
    '    MOVE G6B, 175,  26,  68
    '    MOVE G6C, 190,  50,  65
    '    WAIT

    '���� �� ���test
    MOVE G6A, 100, 160,  45, 160, 100
    MOVE G6D, 100, 145,  75, 160, 100
    MOVE G6B, 175,  26,  68
    MOVE G6C, 190,  40,  15
    WAIT

    'ERX 4800, A, ����_1
    'IF A = 8 THEN GOTO ����_1
    'IF A = 9 THEN GOTO �����������_LOOP
    'IF A = 7 THEN GOTO ���������_LOOP

    GOTO ���_����_1

    'GOTO �����Ͼ��

���_����_1:

    '���� �ٸ� ������ ���� �ϱ� ,�����ȵ� ������
    'MOVE G6A, 100, 150,  50, 160, 100
    '    MOVE G6D, 100, 140, 120, 120, 100
    '    MOVE G6B, 160,  26,  72
    '    MOVE G6C, 190,  28,  70
    '    WAIT

    '���� �ٸ� ������ ���� �ϱ� ,�����ȵ� ������test
    MOVE G6A, 100, 150,  50, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  26,  72
    MOVE G6C, 190,  28,  70
    WAIT

    '������ ���
    ' MOVE G6D, 100, 160,  55, 160, 100
    '    MOVE G6A, 100, 145,  75, 160, 100
    '    MOVE G6C, 175,  25,  70
    '    MOVE G6B, 190,  50,  40
    '    WAIT

    '������ ��� �׽�Ʈ
    MOVE G6D, 100, 160,  45, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 175,  28,  70
    MOVE G6B, 190,  40,  15
    WAIT

    'ERX 4800, A, ����_2
    'IF A = 8 THEN GOTO ����_2
    'IF A = 9 THEN GOTO �����������_LOOP
    'IF A = 7 THEN GOTO ���������_LOOP

    GOTO ���_����_2

    'GOTO �����Ͼ��

���_����_2:
    '������ �����ΰ��� ���, ���ȵ� ������
    ' MOVE G6D, 100, 140,  80, 160, 100
    '    MOVE G6A, 100, 140, 120, 120, 100
    '    MOVE G6C, 160,  25,  70
    '    MOVE G6B, 190,  25,  70
    '    WAIT

    '������ �����ΰ��� ���, ���ȵ� ������ TEST
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 175,  27,  70
    MOVE G6B, 190,  29,  71
    WAIT


    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO ���_�����Ͼ��


    GOTO ��_����_LOOP


���_�����Ͼ��:
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

    '�߸� ���� ���� test1
    SPEED 10	
    MOVE G6A,  100, 165,  45, 162, 100
    MOVE G6D,  100, 165,  45, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '�� Ʋ��
    SPEED 10	
    MOVE G6A,  77, 160,  47, 162, 135
    MOVE G6D,  80, 165,  45, 162, 135
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '��������
    SPEED 10	
    MOVE G6A,  76, 165,  37, 162, 135
    MOVE G6D,  80, 165,  35, 162, 135
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '�㸮 ����
    SPEED 10	
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT

    '�߸񼼿��
    SPEED 10	
    MOVE G6A,  70, 145,  23, 162, 135
    MOVE G6D,  70, 145,  23, 162, 135
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT

    '�� ���� ������

    SPEED 10	
    MOVE G6A,  80, 150,  23, 162, 115
    MOVE G6D,  80, 150,  23, 162, 115
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT


    '�� ������
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    SPEED 10
    GOSUB ����ȭ�ڼ�

    RETURN




    '******************************************
    '���_CLOSE�ȱ�_����:
    '
    '    ����COUNT=0
    '
    '    ����ӵ�=7
    '    ''����ȭ�ڼ�
    '    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90
    '    '    MOVE G6C,100,  35,  90
    '    '    WAIT
    '
    '    SPEED ����ӵ�
    '    '�޹� ������
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    GOTO ���_CLOSE�ȱ�_1
    '
    '    '******************************************
    '    '******************************************
    '���_CLOSE�ȱ�_1:
    '
    '    SPEED ����ӵ�
    '    '������ ������
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  70, 145,  103, 101, 100
    '    WAIT
    '
    '    SPEED ����ӵ�
    '    '�޹� ������
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    WAIT
    '
    '    ����COUNT = ����COUNT + 1
    '    IF ����COUNT > ����Ƚ�� THEN
    '        GOTO ���_CLOSE�ȱ�_����
    '
    '    ELSE
    '        GOTO ���_CLOSE�ȱ�_1
    '
    '    ENDIF
    '
    '
    '    '******************************************
    '    '******************************************
    '���_CLOSE�ȱ�_����:
    '
    '    SPEED ����ӵ�
    '    '������ ������
    '    MOVE G6A,98,  70, 145,  103, 101, 100
    '    MOVE G6D,98,  76, 145,  103, 101, 100
    '    WAIT
    '
    '    SPEED 5
    '    '����ȭ�ڼ�
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '
    '    RETURN

    '******************************************
    '******************************************

��ܽ�����:

    ' GOSUB �ȱ�_FAST_����
    '    '4
    '    GOSUB �ȱ�_FAST_����
    '    GOSUB �ȱ�_FAST_����
    '    GOSUB �ȱ�_FAST_����
    '    GOSUB �ȱ�_FAST_����
    '    GOSUB �ȱ�_FAST_����

    ' ����Ƚ��=5
    '    GOSUB ���_CLOSE�ȱ�_����
    '
    DELAY 500

    GOSUB ��ܴ���

    RETURN

    '����Ƚ��=10
    '
    '    GOSUB ���_����
    '
    '    'GOSUB ������60
    '    '    GOSUB ������60
    '    '
    '    '    GOSUB ������_LONG
    '
    '    RETURN

    '******************************************	
    '**********************************************
    '���_ATTACH
���_CLOSE�ȱ�_����:

    ����COUNT=0

    '����ӵ�=7
    ����ӵ�=9
    ''����ȭ�ڼ�
    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,100,  35,  90
    '    WAIT

    SPEED ����ӵ�
    '�޹� ������
    MOVE G6A,98,  71, 145,  108, 101, 100
    MOVE G6D,98,  74, 145,  93, 101, 100
    WAIT

    GOTO ���_CLOSE�ȱ�_1

    '******************************************
    '******************************************
���_CLOSE�ȱ�_1:

    SPEED ����ӵ�
    '������ ������
    MOVE G6A,98,  74, 145,  93, 101, 100
    MOVE G6D,98,  71, 145,  108, 101, 100
    WAIT

    SPEED ����ӵ�
    '�޹� ������
    MOVE G6A,98,  71, 145,  108, 101, 100
    MOVE G6D,98,  74, 145,  93, 101, 100
    WAIT

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN
        GOTO ���_CLOSE�ȱ�_����

    ELSE
        GOTO ���_CLOSE�ȱ�_1

    ENDIF

    RETURN
    '******************************************
    '******************************************
���_CLOSE�ȱ�_����:

    SPEED ����ӵ�
    '������ ������
    MOVE G6A,98,  71, 145,  103, 101, 100
    MOVE G6D,98,  74, 145,  103, 101, 100
    WAIT

    SPEED 15
    '����ȭ�ڼ�
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN



    '******************************************

    'Down
DOWN:

    SPEED 15

    '������ 20�̿���

    '�߹غ���
    MOVE G6B,,  , , , , 101
    MOVE G6C,,  ,  , , 25,
    WAIT

    RETURN

    '******************************************
    '���߿� oblique�ʿ��Ѹ� �� ����
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

    'GAS����

FRONT:

    SPEED 15

    'FRONT
    MOVE G6B,,  ,  , , ,101
    MOVE G6C,,  ,  , ,72
    WAIT

    RETURN

    '******************************************
���ʺ���:
    '���ʺ���
    ' MOVE G6B,20,  ,  , , , 40
    '    MOVE G6C,,  ,  , , 52,
    '    WAIT

    SPEED 15

    MOVE G6B,,  ,  , , , 55
    MOVE G6C,,  ,  , , 53,
    WAIT

    RETURN

    '******************************************
�����ʺ���:
    '�����ʺ���

    SPEED 15

    MOVE G6B,, ,  , , , 145
    MOVE G6C,,  ,  , , 53,
    WAIT

    RETURN

    '**********************************************
UP_���ʺ���:
    SPEED 15

    MOVE G6B,,  ,  , , , 50
    MOVE G6C,,  ,  , , 98,
    WAIT

    RETURN

    '**********************************************
UP_�����ʺ���:
    SPEED 15

    MOVE G6B,,  ,  , , , 150
    MOVE G6C,,  ,  , , 98,
    WAIT

    RETURN

    '**********************************************

��ֹ�����:

    '����ȭ�ڼ�
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT

    SPEED 4
    '�������� ���� �߽� �ű��(�޹߸�,�����߸� �������� ����̱�)
    MOVE G6A, 108,  76, 146,  93,  96
    MOVE G6D,  88,  74, 144,  95, 110
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT

    SPEED 10
    '������ ���
    MOVE G6A,112,  79, 147,  93,  96,100
    MOVE G6D, 90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 10
    '������ ����
    MOVE G6A,112,  76, 147,  93,  96,100
    MOVE G6D, 90, 80, 120, 130, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    RETURN

    '******************************************
    '******************************************
��ֹ�_������_������_�ȵ��:

    SPEED 10
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  30,  80,
    MOVE G6C,120,  30,  80
    WAIT

    DELAY 500

    HIGHSPEED SETON
    SPEED 8
    '������ ������ �ȵ��
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  30,  80,
    MOVE G6C,120,  100,  80
    WAIT

    SPEED 8
    '������ �� ����� ������
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  30,  80,
    MOVE G6C,120,  30,  80
    WAIT

    HIGHSPEED SETOFF
    DELAY 500	

    '����ȭ�ڼ�(�Ͼ��)
    SPEED 7
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT

    RETURN

    '******************************************
    '******************************************
��ֹ�_����_������_�ȵ��:

    SPEED 10
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  30,  80,
    MOVE G6C,120,  30,  80
    WAIT

    DELAY 500

    HIGHSPEED SETON
    SPEED 8
    '���� ������ �ȵ��
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  100,  80,
    MOVE G6C,120,  30,  80
    WAIT

    SPEED 8
    '���� �� ����� �� ������
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,120,  30,  80,
    MOVE G6C,120,  30,  80
    WAIT

    HIGHSPEED SETOFF
    DELAY 500

    '����ȭ�ڼ�(�Ͼ��)
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
    '��ֹ�_�Ͼ��_���ʾ�ġ���:
    '
    '    ''����ȭ�ڼ�
    '    '    SPEED 7
    '    '    MOVE G6A,98,  76, 145,  93, 101, 100
    '    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    '    MOVE G6B,100,  35,  90,
    '    '    MOVE G6C,100,  35,  90
    '    '    WAIT
    '
    '    '���� ������
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '
    '    '���� ����
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,140, 15,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    HIGHSPEED SETON
    '
    '    '���Ȳ�ġ �����̱�
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,140, 10,  30,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    HIGHSPEED SETOFF
    '
    '    '���Ȳ�ġ ���ڸ�
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,140, 15,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    '����ȭ�ڼ�
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
    '��ֹ�_�Ͼ��_�����ʾ�ġ���:
    '
    '    '���� ������
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '
    '    '������ ����
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 15,  90
    '    WAIT
    '
    '    HIGHSPEED SETON
    '
    '    '�����Ȳ�ġ �����̱�
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 10,  30
    '    WAIT
    '
    '    HIGHSPEED SETOFF
    '
    '    '�����Ȳ�ġ ���ڸ�
    '    SPEED 15
    '    MOVE G6A,98,  146, 55,  113, 101, 100
    '    MOVE G6D,98,  146, 55,  113, 101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 15,  90
    '    WAIT
    '
    '    '����ȭ�ڼ�
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
    '��ֹ�_��_���ʾ�_ġ���:
    '
    '    '���� ������
    '    SPEED 5
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    DELAY 1000
    '
    '    '���� ����
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,140, 15,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    HIGHSPEED SETON
    '
    '    '���Ȳ�ġ �����̱�
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,140, 10,  30,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    HIGHSPEED SETOFF
    '
    '    '���Ȳ�ġ ���ڸ�
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,140, 15,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    '����ȭ�ڼ�
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
��ֹ�_�ٸ�������_��_���ʾ�_ġ���:

    '���� ������
    SPEED 5
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,100,  23,  90,
    MOVE G6C,100,  23,  90, ,20
    WAIT

    DELAY 300

    '���� ����
    SPEED 15
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,140, 50,  90,
    MOVE G6C,100,  23,  90
    WAIT


    SPEED 5
    '�� ������
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  65,  85
    MOVE G6C,130,  50,  85
    WAIT

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT


    '�� ���� ������
    'test
    SPEED 5	
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  80, 150,  25, 162, 115
    MOVE G6B,160, 65,  75,
    MOVE G6C,120,  50,  90
    WAIT

    '�㸮 ����
    SPEED 10	
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,179, 65,  70,
    MOVE G6C,120,  50,  90
    WAIT

    '�� ����
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,159, 30,  75,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETON

    '���Ȳ�ġ �����̱�
    '170
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,169, 10,  65,
    '    MOVE G6C,120, 50,  90
    '    WAIT

    '���Ȳ�ġ �����̱�test
    '170
    SPEED 10	
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,170, 10,  30,
    MOVE G6C,120,  50,  90
    WAIT

    '���Ȳ�ġ �����̱�test2
    '170
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 25,  30,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    DELAY 500

    '���Ȳ�ġ �����̱� �����λ���
    '170
    SPEED 10
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,170, 65,  70,
    MOVE G6C,120,  50,  90
    WAIT


    '���Ȳ�ġ �����̱�
    '160
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 10,  60,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETOFF

    '�� ���� ������

    SPEED 5
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  80, 150,  25, 162, 115
    MOVE G6B,170, 65,  70,
    MOVE G6C,120,  50,  90
    WAIT

    '�� ������
    SPEED 5
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85
    MOVE G6C,130,  50,  85,,20
    WAIT

    '����ȭ�ڼ�
    SPEED 5
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,100,  35,  90
    WAIT

    RETURN

    '******************************************
��ֹ�_�ٸ�������_��_�����ʾ�_ġ���:

	'

    '���� ������
    SPEED 5
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,100,  65,  35,
    MOVE G6C,100,  65,  35, ,20
    WAIT
    
    '�� ������ 
    SPEED 5
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,90,  65,  30,
    MOVE G6C,140,  65,  30, ,20
    WAIT

    DELAY 300

    '���� ����
    SPEED 15
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6C,140, 25,  90,
    MOVE G6B,90,  35,  90
    WAIT

    DELAY 300


    SPEED 5
    '�� ������
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6C,140, 25,  90,
    MOVE G6B,90,  35,  90
    WAIT

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    DELAY 300

    '�� ���� ������
    'test
    SPEED 5	
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  83, 150,  25, 162, 115
    MOVE G6C,160, 25,  90,
    MOVE G6B,90,  35,  90
    WAIT

    '�㸮 ����
    'SPEED 10	
    SPEED 5
    MOVE G6A,  70, 165,  25, 152, 135
    MOVE G6D,  70, 165,  25, 152, 135
    MOVE G6C,179, 65,  70,
    MOVE G6B,90,  45,  90
    WAIT



    '�� ����
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,159, 30,  75,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETON

    '���Ȳ�ġ �����̱�
    '170
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,169, 10,  65,
    '    MOVE G6C,120, 50,  90
    '    WAIT

    '���Ȳ�ġ �����̱�test
    '170
    SPEED 10	
    MOVE G6A,  70, 165,  25, 152, 135
    MOVE G6D,  70, 165,  25, 152, 135
    MOVE G6C,170, 10,  30,
    MOVE G6B,90,  45,  90
    WAIT

    '���Ȳ�ġ �����̱�test2
    '170
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 25,  30,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    DELAY 500

    '���Ȳ�ġ �����̱� �����λ���
    '170
    SPEED 10
    MOVE G6A,  70, 165,  25, 152, 135
    MOVE G6D,  70, 165,  25, 152, 135
    MOVE G6C,170, 65,  70,
    MOVE G6B,90,  45,  90
    WAIT


    '���Ȳ�ġ �����̱�
    '160
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 10,  60,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETOFF

    '�� ���� ������

    SPEED 5
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  83, 150,  25, 162, 115
    MOVE G6C,170, 65,  70,
    MOVE G6B,115,  50,  90
    WAIT

    '�� ������
    SPEED 5
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,120,  40,  85
    MOVE G6C,120,  40,  85,,20
    WAIT

    '����ȭ�ڼ�
    SPEED 5
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,100,  35,  90
    WAIT

    RETURN




    '*************************************
    '��ֹ�_��_�����ʾ�_ġ���:
    '
    '    '���� ������
    '    SPEED 5
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT
    '
    '    DELAY 1000
    '
    '    '���� ����
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 15,  90
    '    WAIT
    '
    '    HIGHSPEED SETON
    '
    '    '���Ȳ�ġ �����̱�
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 10,  30
    '    WAIT
    '
    '    HIGHSPEED SETOFF
    '
    '    '���Ȳ�ġ ���ڸ�
    '    SPEED 15
    '    MOVE G6A, 98, 165,  27, 131,  101, 100
    '    MOVE G6D, 98, 165,  27, 131,  101, 100
    '    MOVE G6B,100,  35,  90
    '    MOVE G6C,140, 15,  90
    '    WAIT
    '
    '    '����ȭ�ڼ�
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
�ٸ��ȱ�_����:
    ����COUNT = 0
    '����ӵ�=15
    ����ӵ� = 7
    �¿�ӵ�= 6
    '�¿�ӵ� = 6

    �Ѿ���Ȯ�� = 0
    �ٸ��ȱ⿬��üũ=0

    GOSUB Leg_motor_mode3

    '����ȭ�ڼ�
    ' MOVE G6A,98,  76, 145,  93, 101, 100
    '    MOVE G6D,98,  76, 145,  93, 101, 100
    '    MOVE G6B,100,  35,  90,
    '    MOVE G6C,100,  35,  90
    '    WAIT

    '�޹߷� �����߽� �ű��
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

    '�޹߷� �����߽� �� �ű�� 		
    'A,+4,+16,-24,+10,
    'D,+1,0,+1,0,0
    'MOVE G6A, 90, 90, 120, 105, 110,100
    '    MOVE G6D,111,  76, 147,  93,  96,100
    '    MOVE G6B,90
    '    MOVE G6C,110
    '    WAIT

    '�޹߷� �����߽� �� �ű�� 	test	
    'A,+4,+16,-24,+10,
    'D,+1,0,+1,0,0
    MOVE G6A, 90, 90, 120, 105, 114,100
    MOVE G6D,112,  76, 147,  93,  96,100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    RETURN

    '*******************************
�ٸ��ȱ�_����:

    IF �ٸ��ȱ⿬��üũ=1 THEN

�ٸ��ȱ�_4:

        '�޹߷� ���� �߽� �ű��
        'A,0,0,-1,0,0
        'D,+4,-10,-25,+36,0
        'MOVE G6A,90, 90, 120, 105, 110,100
        '        MOVE G6D,110,  76, 146,  93,  96,100
        '        MOVE G6B, 90
        '        MOVE G6C,110
        '        WAIT

        '�޹߷� ���� �߽� �ű��TEST
        'A,0,0,-1,0,0
        'D,+4,-10,-25,+36,0
        'MOVE G6A,90, 90, 120, 105, 112,100
        '        MOVE G6D,110,  76, 146,  93,  96,100
        '        MOVE G6B, 90
        '        MOVE G6C,110
        '        WAIT

        '�޹߷� ���� �߽� �ű��TEST(�� )
        'A,0,0,-1,0,0
        'D,+4,-10,-25,+36,0
        MOVE G6A,90, 90, 120, 105, 113,100
        MOVE G6D,111,  76, 146,  93,  96,100
        MOVE G6B, 90
        MOVE G6C,110
        WAIT

    ENDIF

�ٸ��ȱ�_1:

    �ٸ��ȱ⿬��üũ=1

    '�޹� ������
    '�ٸ��ȱ���� �� ������ �����ϰ� ���Ѱ�
    'A,-4,-34,+25,+10,0
    'D,+1,0,0,0,0
    'SPEED ����ӵ�
    '    MOVE G6A, 86,  56, 145, 115, 112
    '    MOVE G6D,110,  76, 147,  93,  96
    '    WAIT

    '�޹� ������TEST (�� )
    '�ٸ��ȱ���� �� ������ �����ϰ� ���Ѱ�
    'A,-4,-34,+25,+10,0
    'D,+1,0,0,0,0
    'HIGHSPEED SETON
    '    SPEED ����ӵ�
    ' MOVE G6A, 86,  54, 145, 115, 112
    '    MOVE G6D,111,  76, 147,  93,  96
    '    WAIT

    '�޹� ������TEST2
    '�ٸ��ȱ���� �� ������ �����ϰ� ���Ѱ�
    'A,-4,-34,+25,+10,0
    'D,+1,0,0,0,0
    HIGHSPEED SETON
    SPEED ����ӵ�
    MOVE G6A, 91,  55, 145, 115, 114
    MOVE G6D,110,  76, 147,  93,  96
    WAIT

    HIGHSPEED SETOFF

    '�޹� �����(��)
    'A,+23,+20,+2,-22,-14
    'D,-22,+24,+2,-24,+14
    ' SPEED �¿�ӵ�
    '    GOSUB Leg_motor_mode3
    '    MOVE G6A,109,  76, 147, 93,  96
    '    MOVE G6D,88, 100, 145,  69, 111
    '    WAIT

    '�޹� ����� TEST
    'A,+23,+20,+2,-22,-14
    'D,-22,+24,+2,-24,+14
    'SPEED �¿�ӵ�
    '    GOSUB Leg_motor_mode3
    '    MOVE G6A,107,  76, 147, 93,  96
    '    MOVE G6D,90, 100, 145,  69, 111
    '    WAIT

    '�޹� ����� TEST2
    'A,+23,+20,+2,-22,-14
    'D,-22,+24,+2,-24,+14
    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3
    MOVE G6A,107,  76, 147, 93,  97
    MOVE G6D,90, 100, 145,  69, 112
    WAIT

    HIGHSPEED SETON
    SPEED ����ӵ�

    ' GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO MAIN
    '    ENDIF

    '**********

�ٸ��ȱ�_2:

    '�����߷� �����߽� �ű��
    'A,0,0,0,0,0
    'D,+3,-10,-25,+36,0
    MOVE G6A,107,  76, 147,  93, 97,100
    MOVE G6D,92, 90, 120, 105, 112,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT


�ٸ��ȱ�_3:

    '������ ������
    SPEED ����ӵ�
    'A,-1,0,0,0,0
    'D,-4,-34,+25,+10,0
    MOVE G6D, 89,  56, 145, 115, 111
    MOVE G6A,107,  76, 147,  93,  97
    WAIT

    HIGHSPEED SETOFF

    '������ �����
    'A,-22,+24,-2,-24,+14
    'D,+23,+20,+2,-22,-14
    'SPEED �¿�ӵ�
    '    MOVE G6D,110,  76, 147, 93,  96
    '    MOVE G6A,86, 100, 145,  69, 110
    '    WAIT

    '������ �����  TEST
    'A,-22,+24,-2,-24,+14
    'D,+23,+20,+2,-22,-14
    ' SPEED �¿�ӵ�
    ' MOVE G6D,110,  76, 147, 93,  96
    '    MOVE G6A,86, 100, 145,  69, 112
    '    WAIT

    '������ �����  TEST2
    'A,-22,+24,-2,-24,+14
    'D,+23,+20,+2,-22,-14
    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  95
    MOVE G6A,86, 100, 145,  69, 113
    WAIT

    HIGHSPEED SETON

    SPEED ����ӵ�

    'GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO MAIN
    '    ENDIF

    RETURN

�ٸ��ȱ�_����:

    '�޹� �������ϰ� ���߱�
    MOVE G6A, 90, 100, 100, 115, 110,100
    MOVE G6D,112,  76, 146,  93,  96,100
    MOVE G6B,90
    MOVE G6C,110
    WAIT
    HIGHSPEED SETOFF
    SPEED 8

    '�޹� �� �ڸ��� ��������
    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 152,  91, 106,100
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT	
    SPEED 2
    GOSUB ����ȭ�ڼ�

    RETURN

    '******************************************

    '******************************************
    '******************************************
��_�ȱ�����:

    '�ȱ�����
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  185,  190
    WAIT

    RETURN

    '******************************************
    '******************************************

��_�����_20:
    '�ȱ�����
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  185,  150
    WAIT

    RETURN

    '******************************************
    '******************************************

��_�����_40:
    '�ȱ�����
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  185,  110
    WAIT

    RETURN

    '******************************************
    '******************************************
��_�����_60:
    '�ȱ�����
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  185,  70
    WAIT

    RETURN

    '******************************************
    '******************************************
��_�����_80:
    '�ȱ�����
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  145,  90
    WAIT

    RETURN

    '******************************************
    '******************************************
��_�ȵڷ��ϱ�:
    '�ȱ�����
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,10,  55,  10
    WAIT

    RETURN

    '******************************************
    '******************************************

��_�ȵ��:

    SPEED 5
    '�ȿ����� ���� ���
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,130,  35,  90
    MOVE G6C,130,  35,  90
    WAIT

    SPEED 5
    '�Ȳ�ġ ������
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,130,  35,  20
    MOVE G6C,130,  35,  20
    WAIT

    SPEED 5
    '�ȿø���
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,170,  35,  25
    MOVE G6C,170,  35,  25
    WAIT

    SPEED 5
    '�Ⱦ�����
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,170,  20,  90
    MOVE G6C,170,  17,  86
    WAIT

    RETURN

    '******************************************
    '******************************************
��_CLOSE�ȱ�_����:
    ����COUNT=0

    '�޹� ������
    MOVE G6A,98,  70, 145,  103, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    WAIT

    GOTO ��_CLOSE�ȱ�_1

    '******************************************
    '******************************************
��_CLOSE�ȱ�_1:

    '������ ������
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  70, 145,  103, 101, 100
    WAIT

    '�޹� ������
    MOVE G6A,98,  70, 145,  103, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    WAIT

    'IF �����������п�üũ=1 THEN
    '
    '        ����COUNT = ����COUNT + 1
    '        IF ����COUNT > ����Ƚ�� THEN  RETURN
    '
    '        GOTO ��_CLOSE�ȱ�_1	
    '
    '    ENDIF

    GOTO ��_CLOSE�ȱ�_����


    '******************************************
    '******************************************
��_CLOSE�ȱ�_����:

    '������ ������
    MOVE G6A,98,  70, 145,  103, 101, 100
    MOVE G6D,98,  76, 145,  103, 101, 100
    WAIT

    '����ȭ�ڼ�
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN

    '******************************************
    '******************************************

��_��������_LONG:
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

    '����ȭ�ڼ�(��� �־���� ���̶�)
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100

    RETURN

    '******************************************
    '******************************************
    '��_������:

    'GOSUB ��_�ȵ��

    ' '��_CLOSE�ȱ�_���п�
    '    �����������п�üũ=1
    '
    '    GOSUB ��_�ȱ�����
    '
    '    '�� _�ȱ� ������
    '    ����Ƚ��=20
    '    GOSUB ��_CLOSE�ȱ�_����
    '    GOSUB ��_CLOSE�ȱ�_1
    '    GOSUB ��_CLOSE�ȱ�_����
    '
    '    'DELAY 1000
    '
    '    '1
    '    GOSUB ��_�����_20
    '
    '    '�� _�ȱ� ������
    '    ����Ƚ��=10
    '    GOSUB ��_CLOSE�ȱ�_����
    '    GOSUB ��_CLOSE�ȱ�_1
    '    GOSUB ��_CLOSE�ȱ�_����
    '
    '    'DELAY 1000
    '
    '    '2
    '    GOSUB ��_�����_40
    '
    '    '�� _�ȱ� ������
    '    ����Ƚ��=10
    '    GOSUB ��_CLOSE�ȱ�_����
    '    GOSUB ��_CLOSE�ȱ�_1
    '    GOSUB ��_CLOSE�ȱ�_����
    '
    '    'DELAY 1000
    '
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '
    '    '3
    '    GOSUB ��_�����_60
    '
    '    '�� _�ȱ� ������
    '    ����Ƚ��=10
    '    GOSUB ��_CLOSE�ȱ�_����
    '    GOSUB ��_CLOSE�ȱ�_1
    '    GOSUB ��_CLOSE�ȱ�_����
    '
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '
    '    'DELAY 1000
    '
    '    '4
    '    GOSUB ��_�����_80
    '
    '    '�� _�ȱ� ������
    '    ����Ƚ��=10
    '    GOSUB ��_CLOSE�ȱ�_����
    '    GOSUB ��_CLOSE�ȱ�_1
    '    GOSUB ��_CLOSE�ȱ�_����
    '
    '    'DELAY 1000
    '
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '    GOSUB ��_��������_LONG
    '    DELAY 100
    '
    '    '�� _�ȱ� ������
    '    ����Ƚ��=30
    '    GOSUB ��_CLOSE�ȱ�_����
    '    GOSUB ��_CLOSE�ȱ�_1
    '    GOSUB ��_CLOSE�ȱ�_����
    '
    '    'DELAY 1000
    '
    '    GOSUB ��_�ȵڷ��ϱ�
    '
    '    '�� _�ȱ� ������
    '    ����Ƚ��=5
    '    GOSUB ��_CLOSE�ȱ�_����
    '    GOSUB ��_CLOSE�ȱ�_1
    '    GOSUB ��_CLOSE�ȱ�_����
    '
    '    'DELAY 2000
    '
    '    GOSUB ����ȭ�ڼ�
    '
    '    RETURN

    '*******************************
    '*************************************************
��_����:

    ����COUNT=0

    '�����ڼ�TEST
    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,181,  16,  86
    MOVE G6C,185,  19,  86
    WAIT

    '�߰��ڼ�
    SPEED 3
    MOVE G6A,100, 155,  28, 146, 100, 100
    MOVE G6D,100, 155,  28, 146, 100, 100
    MOVE G6B,181,  16,  86
    MOVE G6C,185,  19,  86
    WAIT



    '������ �������� �մ���  TEST
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

    'GOTO ���������_LOOP

��_����_LOOP:

    '���� �� ���
    MOVE G6A, 100, 160,  55, 160, 100
    MOVE G6D, 100, 145,  75, 160, 100
    MOVE G6B, 175,  32,  72
    MOVE G6C, 190,  50,  45
    WAIT

    'ERX 4800, A, ����_1
    'IF A = 8 THEN GOTO ����_1
    'IF A = 9 THEN GOTO �����������_LOOP
    'IF A = 7 THEN GOTO ���������_LOOP

    GOTO ��_����_1

    'GOTO �����Ͼ��

��_����_1:
    '���� �ٸ� ������ ���� �ϱ� ,�����ȵ� ������
    'MOVE G6A, 100, 150,  70, 160, 100
    '    MOVE G6D, 100, 140, 120, 120, 100
    '    MOVE G6B, 160,  25,  70
    '    MOVE G6C, 190,  25,  70
    '    WAIT

    '���� �ٸ� ������ ���� �ϱ� ,�����ȵ� ������ �׽�Ʈ
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  30,  72
    MOVE G6C, 190,  28,  70
    WAIT

    '������ ���
    ' MOVE G6D, 100, 160,  55, 160, 100
    '    MOVE G6A, 100, 145,  75, 160, 100
    '    MOVE G6C, 175,  25,  70
    '    MOVE G6B, 190,  50,  40
    '    WAIT

    '������ ��� �׽�Ʈ
    MOVE G6D, 100, 160,  55, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 175,  28,  70
    MOVE G6B, 190,  50,  41
    WAIT

    'ERX 4800, A, ����_2
    'IF A = 8 THEN GOTO ����_2
    'IF A = 9 THEN GOTO �����������_LOOP
    'IF A = 7 THEN GOTO ���������_LOOP

    GOTO ��_����_2

    'GOTO �����Ͼ��

��_����_2:
    '������ �����ΰ��� ���, ���ȵ� ������
    ' MOVE G6D, 100, 140,  80, 160, 100
    '    MOVE G6A, 100, 140, 120, 120, 100
    '    MOVE G6C, 160,  25,  70
    '    MOVE G6B, 190,  25,  70
    '    WAIT

    '������ �����ΰ��� ���, ���ȵ� ������ TEST
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 175,  27,  70
    MOVE G6B, 190,  34,  74
    WAIT


    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO ��_�����Ͼ��


    GOTO ��_����_LOOP


��_�����Ͼ��:
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

    '�߸� ���� ���� test1
    SPEED 5
    MOVE G6A,  100, 160,  45, 162, 100
    MOVE G6D,  100, 165,  45, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    DELAY 500

    '�� Ʋ��
    SPEED 5	
    MOVE G6A,  77, 160,  47, 162, 135
    MOVE G6D,  80, 165,  45, 162, 135
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '��������
    SPEED 5	
    MOVE G6A,  73, 165,  37, 162, 135
    MOVE G6D,  76, 165,  35, 162, 135
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '�㸮 ����
    SPEED 5
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT

    '�߸񼼿��
    SPEED 5
    MOVE G6A,  70, 145,  23, 162, 135
    MOVE G6D,  70, 145,  23, 162, 135
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT

    '�� ���� ������

    SPEED 5
    MOVE G6A,  80, 150,  23, 162, 115
    MOVE G6D,  80, 150,  23, 162, 115
    MOVE G6B,  145, 15, 90
    MOVE G6C,  145, 15, 90
    WAIT

    DELAY 500

    '�� ������
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    SPEED 5
    GOSUB ����ȭ�ڼ�

    RETURN



    '****************************************************************
    '******************************************	
��_������:

    '���� �� ������
    'GOSUB ��_�޸���_����
    '    '12
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����
    '    GOSUB ��_�޸���_����_1
    '    GOSUB ������������

    '���2(����)
    '����Ƚ��=10
    '
    '    GOSUB ��_����
    '    DELAY 300
    '    GOSUB ������������


    '���3(�����ΰ���)
    ' GOSUB ������60
    '    GOSUB ������60
    '
    '    DELAY 1000
    'GOSUB ������_LONG

    GOSUB UP
    DELAY 500

    GOSUB �����ʿ�����70
    GOSUB �����ʿ�����70
    GOSUB �����ʿ�����70
    GOSUB �����ʿ�����70
    GOSUB �����ʿ�����70
    GOSUB �����ʿ�����70
    GOSUB �����ʿ�����70
    GOSUB �����ʿ�����70
    GOSUB �����ʿ�����70
    GOSUB �����ʿ�����70
    GOSUB �����ʿ�����70
    RETURN

    '******************************************	
������������:

    GOSUB ������60
    DELAY 100
    GOSUB ������60
    'DELAY 100
    'GOSUB ������_LONG
    RETURN

    '******************************************	

�Ѿ���Ȯ��_������:
    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0	
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

    '�� MAIN�� �����̿� ����� ó�� ��ſ��� Ȯ���ϱ� ���Ѱ�

    '******************************************
MAIN: '�󺧼���	


    '�����̿��� ������ ����Ȯ�� ��ȣ ����
    ERX 4800, A, MAIN
    '�����̷� ���� Ȯ�� �ƴٰ� ������ ����
    ETX 4800, 254
    PRINT "SOUND 11 !" '�ȳ�

    '******************************************

    '�� MAIN_2�� �����̿����� �κ� ���� ������ ���� ��

    '******************************************

MAIN_2:

    '***********************************
    '�ϴ� �ּ�ó�����־���

    'GOSUB �յڱ�������
    'GOSUB �¿��������
    'GOSUB ���ܼ��Ÿ�����Ȯ��

    '�����̿��� ���� ��� ����
    ERX 4800,A,MAIN_2

    A_Old= A

    '========================================

    '�Ѿ���Ȯ��

    '========================================

    ''���� �������� �Ѿ��� Ȯ��

    'GOSUB �Ѿ���Ȯ��_������

    '========================================

    '�Ϲ� �ȱ⵿�� (FAST)

    '========================================


    IF A_Old= 100  THEN
        'GOSUB �ȱ�_SHORT_����
        'GOSUB �ȱ�_FAST_����
        'GOSUB �ٸ��ȱ�_����
        GOSUB �����޸���_����

    ELSEIF A_Old = 101 THEN    	
        'GOSUB �ȱ�_SHORT_����
        'GOSUB �ȱ�_FAST_����
        'GOSUB �ٸ��ȱ�_����

        IF �����޸��⿬�Ӻб�üũ=1 THEN
            GOSUB �����޸���_����_0
        ELSEIF �����޸��⿬�Ӻб�üũ=0 THEN
            GOSUB �����޸���_����_1
        ENDIF

        '��������
    ELSEIF A_Old = 102 THEN
        '��������=2
        'GOSUB �ȱ�_SHORT_����
        'GOSUB �ȱ�_FAST_����
        'GOSUB �ٸ��ȱ�_����
        GOSUB �����޸���_����

        '���������ڰ���
    ELSEIF A_Old = 103 THEN    	
        ��������=1
        GOSUB �ȱ�_SHORT_����
        'GOSUB �ȱ�_FAST_����
        '�����������ڰ���
    ELSEIF A_Old = 104 THEN    	
        ��������=3
        GOSUB �ȱ�_SHORT_����
        'GOSUB �ȱ�_FAST_����
        '   '����ū�ڰ���
    ELSEIF A_Old = 105 THEN    	
        ��������=4
        GOSUB �ȱ�_SHORT_����
        'GOSUB �ȱ�_FAST_����
        'GOSUB ������_SHORT

        '������ū�ڰ���
    ELSEIF A_Old = 106 THEN    	
        ��������=6
        GOSUB �ȱ�_SHORT_����
        'GOSUB ��������_SHORT

        'FAST����( ��ܾտ����� �� )
    ELSEIF A_Old = 123 THEN    	
        'GOSUB �ȱ�_FAST_����
        'GOSUB �ȱ�_FAST_������
        ����Ƚ�� =3
        GOSUB ���_CLOSE�ȱ�_����
        GOSUB ���_CLOSE�ȱ�_����
        GOSUB ���_CLOSE�ȱ�_����
        GOSUB ���_CLOSE�ȱ�_����
        GOSUB ���_CLOSE�ȱ�_����

    ELSEIF A_Old = 124 THEN    	
        GOSUB �ȱ�_FAST_����

    ELSEIF A_Old = 125 THEN    	
        ��������=2
        GOSUB �ȱ�_FAST_����

        '������� �տ��� ������ ���� �� ���
        '���ATTACH
    ELSEIF A_Old = 128 THEN    	

        GOSUB �������_�ȱ�_FAST_����
        GOSUB �������_�ȱ�_FAST_����
        GOSUB �������_�ȱ�_FAST_����
        GOSUB �������_�ȱ�_FAST_����
        GOSUB �������_�ȱ�_FAST_����

        '========================================

        '�Ӹ� �����̴� ����

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

        GOSUB ���ʺ���

    ELSEIF A_Old = 132  THEN    	

        GOSUB �����ʺ���

    ELSEIF A_Old = 134  THEN    	

        GOSUB UP_���ʺ���

    ELSEIF A_Old = 135  THEN    	

        GOSUB UP_�����ʺ���



        '========================================

        'ȸ�� ����

        '========================================

    ELSEIF A_Old = 111 THEN    	

        GOSUB ������_SHORT

    ELSEIF A_Old = 112 THEN

        GOSUB ��������_SHORT

    ELSEIF A_Old = 129 THEN    	

        GOSUB ������_LONG

    ELSEIF A_Old = 130 THEN    	

        GOSUB ��������_LONG

        '
        '========================================

        '������ �ȱ� ����

        '========================================

    ELSEIF A_Old = 113 THEN    	

        GOSUB ���ʿ�����_SHORT

    ELSEIF A_Old = 114 THEN

        GOSUB �����ʿ�����_SHORT  	

    ELSEIF A_Old = 126 THEN    	

        GOSUB ���ʿ�����_LONG

    ELSEIF A_Old = 127 THEN    	

        GOSUB �����ʿ�����_LONG

        '========================================

        '��� ������ ����

        '========================================

        ' ELSEIF A_Old = 130 THEN    	
        '
        '        GOSUB ��ܿ����߳�����1cm
        '
        '    ELSEIF A_Old = 131 THEN    	
        '
        '        GOSUB ��ܿ����߿�����1cm
        '
        '========================================

        '���̱����
    ELSEIF A_Old = 115 THEN    	

        'GOSUB CLOSE�ȱ�_����
        '        GOSUB CLOSE�ȱ�_1
        '        GOSUB CLOSE�ȱ�_����

        '�̸������ε� ������� ���� ������ ��
        GOSUB ��_CLOSE�ȱ�_����


        '========================================
        '========================================

        '�ͳ� ����

        '========================================

    ELSEIF A_Old = 116 THEN    	

        GOSUB �ͳ�_������

        '========================================

        '���� ��� ����

        '========================================

        '������ ���� ������� �ᱸ�� ������
    ELSEIF A_Old=117 THEN

        GOSUB �������_������

        '========================================

        '�� ����

        '========================================

    ELSEIF A_Old= 118 THEN

        GOSUB ��_������

    ELSEIF A_Old= 133 THEN

        GOSUB ������������

        '========================================

        '��� ����

        '==================================

    ELSEIF A_Old = 119 THEN    	

        GOSUB ��ܽ�����

        '========================================

        '��ֹ� ����

        '==================================


    ELSEIF A_Old = 120 THEN    	

        GOSUB ��ֹ�_�ٸ�������_��_���ʾ�_ġ���

    ELSEIF A_Old = 121 THEN    	

        GOSUB ��ֹ�_�ٸ�������_��_�����ʾ�_ġ���
        'GOSUB �Ѿ���Ȯ��_������

        ' ELSEIF A_Old = 137 THEN    	
        '
        '        GOSUB ��ֹ�_����_������_�ȵ��
        '
        '    ELSEIF A_Old = 138 THEN    	
        '
        '        GOSUB ��ֹ�_������_������_�ȵ��
        '
        '    ELSEIF A_Old = 139 THEN    	
        '
        '        GOSUB ��ֹ�_�Ͼ��_���ʾ�ġ���
        '
        '    ELSEIF A_Old = 140 THEN    	
        '
        '        GOSUB ��ֹ�_�Ͼ��_�����ʾ�ġ��

        '========================================

        '���ܼ� �Ÿ����� Ȯ��

        '==================================
        '
        '    ELSEIF A_Old = 120 THEN    	
        '
        '        GOSUB ���ܼ��Ÿ�����Ȯ��


        '========================================

        '�����ڼ�

        '========================================

    ELSEIF A_Old = 122 THEN    	

        GOSUB ����ȭ�ڼ�

        '========================================

    ENDIF


    '========================================

    '���� ��

    '========================================

    '========================================

    '������ ���ܼ� ������ ���۵� ����

    '========================================

    '  '�ȱ�_short����
    IF A_Old = 100 THEN

        GOSUB ���ܼ��Ÿ�����Ȯ��

        '�ȱ�_short����
    ELSEIF A_Old = 102 THEN    	

        GOSUB ���ܼ��Ÿ�����Ȯ��

        '���������ڰ���
    ELSEIF A_Old = 103 THEN    	

        GOSUB ���ܼ��Ÿ�����Ȯ��

        '�����������ڰ���
    ELSEIF A_Old = 104 THEN    	

        GOSUB ���ܼ��Ÿ�����Ȯ��

        '����ū�ڰ���
    ELSEIF A_Old = 105 THEN    	

        GOSUB ���ܼ��Ÿ�����Ȯ��
        '     '������ū�ڰ���
    ELSEIF A_Old = 106 THEN    	

        GOSUB ���ܼ��Ÿ�����Ȯ��

        '������꿡�� ���� CLOSE
    ELSEIF A_Old = 115 THEN    	

        GOSUB ���ܼ��Ÿ�����Ȯ��

        'Init(����ȭ�ڼ�)
    ELSEIF A_Old = 122 THEN    	

        GOSUB ���ܼ��Ÿ�����Ȯ��

        '��������(�������)
    ELSEIF A_Old = 128 THEN    	

        GOSUB ���ܼ��Ÿ�����Ȯ��

        '���ܼ��Ÿ�����Ȯ��
    ELSEIF A_Old = 136 THEN    	

        GOSUB ���ܼ��Ÿ�����Ȯ��


        '     '��_CLOSE�ȱ�_����
        '    ELSEIF A_Old = 205 THEN    	
        '
        '        GOSUB ���ܼ��Ÿ�����Ȯ��
        '
        '        '��_CLOSE�ȱ�_����
        '    ELSEIF A_Old = 155 THEN    	
        '
        '        GOSUB ���ܼ��Ÿ�����Ȯ��
        '
        '        '�������_CLOSE�ȱ�_����
        '    ELSEIF A_Old = 204 THEN    	
        '
        '        GOSUB ���ܼ��Ÿ�����Ȯ��
        '
        '        '�������_CLOSE�ȱ�_����
        '    ELSEIF A_Old = 154 THEN    	
        '
        '        GOSUB ���ܼ��Ÿ�����Ȯ��
        '
        '        '�ٸ��ȱ�_����
        '    ELSEIF A_Old = 200 THEN    	
        '
        '        GOSUB ���ܼ��Ÿ�����Ȯ��
        '
        '        '�ٸ��ȱ�_����
        '    ELSEIF A_Old = 150 THEN    	
        '
        '        GOSUB ���ܼ��Ÿ�����Ȯ��  	

    ELSE
        '���� ���� ��ȣ �����̿��� ������
        ETX 4800,254
    ENDIF


    GOTO MAIN_2

    '*******************************************
    '		MAIN2 ����
    '*******************************************

    '*******************************************
    '		�������� MAIN ����
    '*******************************************

    '****************************************************************
RX_EXIT:

    ERX 4800, A, ������_MAIN

    GOTO RX_EXIT

GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN

    '****************************************************************

������_MAIN: '�󺧼���

    ETX 4800, 38 ' ���� ���� Ȯ�� �۽� ��


������_MAIN_2:

    '***********************************
    '�ϴ� �ּ�ó�����־���

    'GOSUB �յڱ�������
    'GOSUB �¿��������
    'GOSUB ���ܼ��Ÿ�����Ȯ��

    ERX 4800,A,������_MAIN_2	

    A_old = A

    '**** �Էµ� A���� 0 �̸� MAIN �󺧷� ����
    '**** 1�̸� KEY1 ��, 2�̸� key2��... ���¹�
    ON A GOTO ������_MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

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
        GOSUB �⺻�ڼ�

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN �󺧷� ����
    '*******************************************

    '���� �� 10
KEY1:
    ETX  4800,1

    GOSUB ������_SHORT
    '
    GOTO RX_EXIT
    '***************	
    'Ƚ��_������������
KEY2:
    ETX  4800,2	

    '��������=2
    '    '����Ƚ��=10
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����
    '    GOSUB �ٸ��ȱ�_����

    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����
    GOSUB �����޸���_����_0



    GOTO RX_EXIT
    '***************
    '��������10
KEY3:
    ETX  4800,3

    GOSUB ��������_SHORT

    GOTO RX_EXIT
    '***************
    ' ���ʿ�����20
KEY4:
    ETX  4800,4
    'GOTO ���ʿ�����20
    'GOSUB ���ʿ�����_SHORT
    GOSUB ���ʿ�����70
    'GOTO �������_���ʿ�����

    GOTO RX_EXIT
    '***************
    '���ܼ��Ÿ��� �б�
KEY5:
    ETX  4800,5

    J = AD(5)	'���ܼ��Ÿ��� �б�
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
    '������ ������ 20
KEY6:
    ETX  4800,6

    GOSUB �����ʿ�����_SHORT

    GOTO RX_EXIT
    '***************
    '������20
KEY7:
    ETX  4800,7

    'GOSUB ���ʿ�����_LONG
    GOSUB ������60


    GOTO RX_EXIT
    '***************

KEY8:
    ETX  4800,8

    GOSUB ��������

    GOTO RX_EXIT
    '***************
    '��������20
KEY9:
    ETX  4800,9
    'GOTO ��������20
    'GOTO ��������20

    'GOSUB �����ʿ�����_LONG
    GOSUB ��������_LONG

    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX  4800,10
    ����Ƚ��=5
    'GOTO CLOSE�ȱ�_����
    'GOTO ��ܿ����߿�����1cm����

    GOTO RX_EXIT
    '***************
    '�Ӹ�
KEY11: ' ��
    ETX  4800,11
    '80cm�������� ����Ƚ�� 15
    '����Ƚ��=15
    '��������=2
    '    ����Ƚ��=20
    '    GOTO �ȱ�_FAST_����

    ��������=2

    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����
    GOSUB �ȱ�_FAST_����


    GOTO RX_EXIT
    '***************
KEY12: ' ��
    ETX  4800,12

    'GOTO �������Ͼ��
    'GOTO �������_�ȱ�_����
    'GOSUB ���_CLOSE�ȱ�_����
    'GOSUB ���_CLOSE�ȱ�_����
    'GOSUB �������_CLOSE�ȱ�_����
    'GOTO ��_����_������
    'GOSUB ��
    GOSUB �������ȱ�_����

    GOTO RX_EXIT
    '***************
KEY13: '��
    ETX  4800,13
    'GOTO �����ʿ�����70����
    'GOTO �ٸ��ȱ�_����
    ����Ƚ��=3
    GOSUB CLOSE�ȱ�_����

    GOTO RX_EXIT
    '***************
KEY14: ' ��
    ETX  4800,14
    GOSUB ���ʿ�����70
    '����Ƚ��=1
    'GOTO ��ܴ���
    'GOTO ��������

    GOTO RX_EXIT
    '***************
KEY15: ' A
    ETX  4800,15

    GOSUB ��ܽ�����

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
    GOSUB �����ڼ�	
    GOSUB ������

    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF ����ONOFF = 1  THEN
        OUT 52,1
        DELAY 200
        OUT 52,0
        DELAY 200
    ENDIF
    ERX 4800,A,KEY16_1
    ETX  4800,A
    IF  A = 16 THEN 	'�ٽ� �Ŀ���ư�� �����߸� ����
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
        GOSUB Leg_motor_mode2
        GOSUB �⺻�ڼ�2
        GOSUB ���̷�ON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1

    GOTO RX_EXIT
    '***************
KEY17: ' C
    ETX  4800,17
    GOSUB �ͳ�_������


    GOTO RX_EXIT
    '***************
KEY18: ' E
    ETX  4800,18	

    GOSUB ��ֹ�_�ٸ�������_��_���ʾ�_ġ���

    GOTO RX_EXIT

KEY18_wait:

    ERX 4800,A,KEY18_wait	

    IF  A = 26 THEN
        GOSUB ������
        GOSUB ���̷�ON
        GOTO RX_EXIT
    ENDIF

    GOTO KEY18_wait


    GOTO RX_EXIT
    '***************

    '���� : ��ܿ����߿�����1cm
KEY19: ' P2
    ETX  4800,19
    'GOTO ��ֹ�_��_�����ʾ�_ġ���

    GOTO RX_EXIT
    '***************
    '�������_�ᱸ��
KEY20: ' B	
    ETX  4800,20

    GOSUB ��_������

    GOTO RX_EXIT
    '***************
    '����_���� 0��
KEY21: ' ��
    ETX  4800,21
    GOSUB UP
    GOTO RX_EXIT
    '***************
    '�����ڼ�_�ȱ�_����:
KEY22: ' *	
    ETX  4800,22
    '����Ƚ��=1
    'GOSUB ��ֹ�_��_���ʾ�_ġ���

    GOTO RX_EXIT
    '***************
    '�ͳ�_����_�Ͼ��
KEY23: ' G
    ETX  4800,23
    GOSUB �������_������

    GOTO RX_EXIT
KEY23_wait:


    ERX 4800,A,KEY23_wait	

    IF  A = 26 THEN
        GOSUB ������
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOTO KEY23_wait


    GOTO RX_EXIT
    '***************
KEY24: ' #
    ETX  4800,24
    GOSUB �������_�ȿø����ڼ�

    GOSUB �������_�Ⱥ��̴��ڼ�

    GOSUB ���ʿ�����70
    GOSUB ���ʿ�����70
    GOSUB ���ʿ�����70
    GOSUB ���ʿ�����70
    GOSUB ���ʿ�����70

    GOTO RX_EXIT
    '***************
KEY25: ' P1
    ETX  4800,25

    'GOSUB ��ֹ�_��_�����ʾ�_ġ���
    'GOTO ��_����
    'GOTO �����δ���
    'GOTO CLOSE�ȱ�_����

    GOTO RX_EXIT
    '***************
KEY26: ' ��
    ETX  4800,26

    'SPEED 5
    '    GOSUB �⺻�ڼ�2	
    '    TEMPO 220
    '    MUSIC "ff"
    '    GOSUB �⺻�ڼ�

    SPEED 5
    GOSUB ����ȭ�ڼ�

    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX  4800,27

    ����COUNT=0
    ����Ƚ��=10
    'GOTO ������_����_����

    GOTO RX_EXIT
    '***************
KEY28: ' ��
    ETX  4800,28
    GOSUB ���ʺ���


    GOTO RX_EXIT
    '***************
    '����_���� 20��
KEY29: ' ��
    ETX  4800,29

    GOSUB OBLIQUE

    GOTO RX_EXIT
    '***************
KEY30: ' ��
    ETX  4800,30
    GOSUB �����ʺ���

    GOTO RX_EXIT
    '***************
KEY31: ' ��
    ETX  4800,31
    'GOTO �߹�_����_90��
    GOSUB DOWN

    GOTO RX_EXIT
    '***************
    '�ͳ�_����
KEY32: ' F
    ETX  4800,32
    GOSUB ��ֹ�_�ٸ�������_��_�����ʾ�_ġ���
    GOTO RX_EXIT
    '***************
