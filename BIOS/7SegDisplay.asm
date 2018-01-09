;7段LED数码管显示模块
ORG_DATA	0DFC;定义数据
	LEDDATA	DW	0
ORG_CODE	0C88;定义代码
		SW		$S0,0($SP)				;将$S0寄存器内容压栈
		ADDI	$SP,$SP,-4
		SW		$S1,0($SP)				;将$S1寄存器内容压栈
		ADDI	$SP,$SP,-4
		ADDI	$S0,$ZERO,1
		BEQ		$A0,$S0,FUN1
		SW		$A2,LEDDATA($ZERO)		;功能0，先保存新的当前显示值
		SW		$A2,0FF00($ZERO)		;输出数码管
		J		LEDEXIT
FUN1:	LW		$S1,LEDDATA($ZERO)		;读出当前显示值
		BEQ		$A1,$ZERO,LOCA0			;根据输出的位数跳转到相应的处理程序
		ADDI	$S0,$ZERO,1
		BEQ		$A1,$S0,LOCA1
		ADDI	$S0,$ZERO,2
		BEQ		$A1,$S0,LOCA2
		ADDI	$S0,$ZERO,3
		BEQ		$A1,$S0,LOCA3
		J		LEDEXIT
LOCA0:	ANDI	$S1,$S1,FFFFFFF0		;位0输出
		ORI		$S1,$S1,$A2
		J		DISPL1
LOCA1:	ANDI	$S1,$S1,FFFFFF0F		;位1输出
		SLL		$S0,$A2,4				;输出数据左移二进制4位
		ANDI	$S0,$S0,000000F0
		ORI		$S1,$S1,$S0
		J		DISPL1
LOCA2:	ANDI	$S1,$S1,FFFFF0FF		;位2输出
		SLL		$S0,$A2,8				;输出数据左移二进制8位
		ANDI	$S0,$S0,00000F00
		ORI		$S1,$S1,$S0
		J		DISPL1
LOCA3:	ANDI	$S1,$S1,FFFF0FFF		;位3输出
		SLL		$S0,$A2,0C				;输出数据左移二进制12位
		ANDI	$S0,$S0,0000F000
		ORI		$S1,$S1,$S0
DISPL1:	SW		$S1,0FF00($ZERO)		;输出数码管
		SW		$S1,LEDDATA($ZERO)		;保存新的当前显示值
LEDEXIT:ADDI	$SP,$SP,4
		LW		$S1,0($SP)
		ADDI	$SP,$SP,4				;恢复$S0的值
		LW		$S0,0($SP)
		JR		$RA						;子程序返回