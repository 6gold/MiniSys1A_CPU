ORG_CODE	0D30;定义代码
		SW		$S0,0($SP)		;将$S0寄存器内容压栈
		ADDI	$SP,$SP,-4
		SW		$S1,0($SP)		;将$S0寄存器内容压栈
		ADDI	$SP,$SP,-4
		ADDI	$S0,$ZERO,1
		BEQ		$A0,$S0,KFUN1
KLOP:	LW		$S1,FF12($ZERO)	;读键状态
		ANDI	$S1,$S1,1
		BEQ		$S1,$ZERO,KLOP	;等待按键
		LW		$S1,FF10($ZERO)	;读键值
		J		CODED			;去编码
KFUN1:	LW		$S1,FF12($ZERO)	;读键状态
		ANDI	$S1,$S1,1
		BEQ		$S1,$ZERO,NOKEY	;无键
		J		READKEY
NOKEY:	ADDI	$V0,$ZERO,0FF	;返回0FFH，无键值
		J		KEYEXIT
READKEY:LW		$S1,FF10($ZERO)	;读键值
CODED:	ADDI	$S0,$ZERO,0EE
		BNE		$S1,$S0,KEY1
		ADDI	$V0,$ZERO,0		;返回编码0，键值0EEH
		J		KEYEXIT
KEY1:	ADDI	$S0,$ZERO,0ED
		BNE		$S1,$S0,KEY2
		ADDI	$V0,$ZERO,1
		J		KEYEXIT
KEY2:	ADDI	$S0,$ZERO,0EB
		BNE		$S1,$S0,KEY3
		ADDI	$V0,$ZERO,2
		J		KEYEXIT
KEY3:	ADDI	$S0,$ZERO,0E7
		BNE		$S1,$S0,KEY4
		ADDI	$V0,$ZERO,3
		J		KEYEXIT
KEY4:	ADDI	$S0,$ZERO,0DE
		BNE		$S1,$S0,KEY5
		ADDI	$V0,$ZERO,4
		J		KEYEXIT
KEY5:	ADDI	$S0,$ZERO,0DD
		BNE		$S1,$S0,KEY6
		ADDI	$V0,$ZERO,5
		J		KEYEXIT
KEY6:	ADDI	$S0,$ZERO,0DB
		BNE		$S1,$S0,KEY7
		ADDI	$V0,$ZERO,6
		J		KEYEXIT
KEY7:	ADDI	$S0,$ZERO,0D7
		BNE		$S1,$S0,KEY8
		ADDI	$V0,$ZERO,7
		J		KEYEXIT
KEY8:	ADDI	$S0,$ZERO,0BE
		BNE		$S1,$S0,KEY9
		ADDI	$V0,$ZERO,8
		J		KEYEXIT
KEY9:	ADDI	$S0,$ZERO,0BD
		BNE		$S1,$S0,KEY10
		ADDI	$V0,$ZERO,9
		J		KEYEXIT
KEY10:	ADDI	$S0,$ZERO,0BB
		BNE		$S1,$S0,KEY11
		ADDI	$V0,$ZERO,0A
		J		KEYEXIT
KEY11:	ADDI	$S0,$ZERO,0B7
		BNE		$S1,$S0,KEY12
		ADDI	$V0,$ZERO,0B
		J		KEYEXIT
KEY12:	ADDI	$S0,$ZERO,7E
		BNE		$S1,$S0,KEY13
		ADDI	$V0,$ZERO,0C
		J		KEYEXIT
KEY13:	ADDI	$S0,$ZERO,7D
		BNE		$S1,$S0,KEY14
		ADDI	$V0,$ZERO,0D
		J		KEYEXIT
KEY14:	ADDI	$S0,$ZERO,7B
		BNE		$S1,$S0,KEY15
		ADDI	$V0,$ZERO,0E
		J		KEYEXIT
KEY15:	ADDI	$S0,$ZERO,7B
		BNE		$S1,$S0,KEY16
		ADDI	$V0,$ZERO,0F
		J		KEYEXIT
KEY16:	ADDI	$V0,$ZERO,0FF
KEYEXIT:ADDI	$SP,$SP,4		;恢复$S1的值
		LW		$S1,0($SP)
		ADDI	$SP,$SP,4		;恢复$S0的值
		LW		$S0,0($SP)
		JR		$RA				;子程序返回