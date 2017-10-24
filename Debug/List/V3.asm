
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _qtyNum=R5
	.DEF _flag=R4
	.DEF _checkpass=R7
	.DEF _result=R6
	.DEF _rx_wr_index=R9
	.DEF _rx_rd_index=R8
	.DEF _rx_counter=R11
	.DEF _tx_wr_index=R10
	.DEF _tx_rd_index=R13
	.DEF _tx_counter=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP _ext_int1_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xA,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0

_0x0:
	.DB  0x31,0x26,0x32,0x20,0x4F,0x4E,0x0,0x31
	.DB  0x3A,0x4F,0x4E,0x20,0x32,0x3A,0x4F,0x46
	.DB  0x46,0x0,0x31,0x3A,0x4F,0x46,0x46,0x20
	.DB  0x32,0x3A,0x4F,0x4E,0x0,0x31,0x26,0x32
	.DB  0x20,0x4F,0x46,0x46,0x0,0x43,0x4C,0x49
	.DB  0x50,0x0,0x43,0x4D,0x54,0x3A,0x0,0x43
	.DB  0x55,0x53,0x44,0x0,0x73,0x2E,0x0,0x54
	.DB  0x4B,0x20,0x67,0x6F,0x63,0x0,0x4D,0x61
	.DB  0x20,0x73,0x6F,0x20,0x74,0x68,0x65,0x0
	.DB  0x54,0x61,0x69,0x20,0x6B,0x68,0x6F,0x61
	.DB  0x6E,0x0,0x74,0x69,0x6D,0x65,0x20,0x6F
	.DB  0x75,0x74,0x0,0x41,0x54,0x48,0xD,0xA
	.DB  0x0,0x6D,0x61,0x74,0x20,0x6B,0x68,0x61
	.DB  0x75,0x3A,0x20,0x30,0x30,0x30,0x30,0x0
	.DB  0x6D,0x61,0x74,0x20,0x6B,0x68,0x61,0x75
	.DB  0x20,0x73,0x61,0x69,0x0,0x6F,0x6E,0x31
	.DB  0x0,0x6F,0x6E,0x32,0x0,0x6F,0x66,0x66
	.DB  0x31,0x0,0x6F,0x66,0x66,0x32,0x0,0x6F
	.DB  0x6E,0x0,0x6F,0x66,0x66,0x0,0x64,0x6F
	.DB  0x69,0x6D,0x6B,0x0,0x44,0x6F,0x69,0x20
	.DB  0x6D,0x61,0x74,0x20,0x6B,0x68,0x61,0x75
	.DB  0x20,0x74,0x68,0x61,0x6E,0x68,0x20,0x63
	.DB  0x6F,0x6E,0x67,0x0,0x73,0x64,0x74,0x31
	.DB  0x0,0x44,0x61,0x20,0x74,0x68,0x65,0x6D
	.DB  0x20,0x73,0x64,0x74,0x31,0x0,0x73,0x64
	.DB  0x74,0x32,0x0,0x44,0x61,0x20,0x74,0x68
	.DB  0x65,0x6D,0x20,0x73,0x64,0x74,0x32,0x0
	.DB  0x73,0x64,0x74,0x33,0x0,0x44,0x61,0x20
	.DB  0x74,0x68,0x65,0x6D,0x20,0x73,0x64,0x74
	.DB  0x33,0x0,0x6B,0x74,0x74,0x6B,0x0,0x6E
	.DB  0x61,0x70,0x74,0x69,0x65,0x6E,0x0,0x74
	.DB  0x68,0x6F,0x6E,0x67,0x62,0x61,0x6F,0x20
	.DB  0x6F,0x6E,0x0,0x42,0x61,0x74,0x20,0x74
	.DB  0x68,0x6F,0x6E,0x67,0x20,0x62,0x61,0x6F
	.DB  0x0,0x74,0x68,0x6F,0x6E,0x67,0x62,0x61
	.DB  0x6F,0x20,0x6F,0x66,0x66,0x0,0x54,0x61
	.DB  0x74,0x20,0x74,0x68,0x6F,0x6E,0x67,0x20
	.DB  0x62,0x61,0x6F,0x0,0x6B,0x74,0x74,0x74
	.DB  0x0,0x4C,0x6F,0x69,0x20,0x63,0x75,0x20
	.DB  0x70,0x68,0x61,0x70,0x0,0x41,0x54,0xD
	.DB  0xA,0x0,0x41,0x54,0x45,0x30,0xD,0xA
	.DB  0x0,0x41,0x54,0x2B,0x43,0x4D,0x47,0x46
	.DB  0x3D,0x31,0xD,0xA,0x0,0x41,0x54,0x2B
	.DB  0x43,0x4E,0x4D,0x49,0x3D,0x32,0x2C,0x32
	.DB  0x2C,0x30,0x2C,0x30,0x2C,0x30,0xD,0xA
	.DB  0x0,0x41,0x54,0x2B,0x43,0x55,0x53,0x44
	.DB  0x3D,0x31,0xD,0xA,0x0,0x41,0x54,0x2B
	.DB  0x43,0x4D,0x47,0x44,0x41,0x3D,0x44,0x45
	.DB  0x4C,0x20,0x41,0x4C,0x4C,0xD,0xA,0x0
_0x2020000:
	.DB  0x41,0x54,0x2B,0x43,0x4D,0x47,0x53,0x3D
	.DB  0x0,0xD,0x0,0x41,0x54,0x2B,0x43,0x55
	.DB  0x53,0x44,0x3D,0x31,0xD,0xA,0x0,0x41
	.DB  0x54,0x44,0x2A,0x31,0x30,0x31,0x23,0x3B
	.DB  0xD,0xA,0x0,0x41,0x54,0x44,0x2A,0x31
	.DB  0x30,0x30,0x2A,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x09
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x07
	.DW  _0x1F
	.DW  _0x0*2

	.DW  0x0B
	.DW  _0x1F+7
	.DW  _0x0*2+7

	.DW  0x0B
	.DW  _0x1F+18
	.DW  _0x0*2+18

	.DW  0x08
	.DW  _0x1F+29
	.DW  _0x0*2+29

	.DW  0x05
	.DW  _0x26
	.DW  _0x0*2+37

	.DW  0x05
	.DW  _0x26+5
	.DW  _0x0*2+42

	.DW  0x05
	.DW  _0x26+10
	.DW  _0x0*2+47

	.DW  0x05
	.DW  _0x26+15
	.DW  _0x0*2+37

	.DW  0x05
	.DW  _0x26+20
	.DW  _0x0*2+42

	.DW  0x05
	.DW  _0x26+25
	.DW  _0x0*2+42

	.DW  0x05
	.DW  _0x26+30
	.DW  _0x0*2+47

	.DW  0x07
	.DW  _0x26+35
	.DW  _0x0*2+55

	.DW  0x0A
	.DW  _0x26+42
	.DW  _0x0*2+62

	.DW  0x0A
	.DW  _0x26+52
	.DW  _0x0*2+72

	.DW  0x07
	.DW  _0x26+62
	.DW  _0x0*2+55

	.DW  0x0A
	.DW  _0x26+69
	.DW  _0x0*2+62

	.DW  0x0A
	.DW  _0x26+79
	.DW  _0x0*2+72

	.DW  0x0F
	.DW  _0xA6
	.DW  _0x0*2+97

	.DW  0x0D
	.DW  _0xA6+15
	.DW  _0x0*2+112

	.DW  0x04
	.DW  _0xA6+28
	.DW  _0x0*2+125

	.DW  0x04
	.DW  _0xA6+32
	.DW  _0x0*2+129

	.DW  0x05
	.DW  _0xA6+36
	.DW  _0x0*2+133

	.DW  0x05
	.DW  _0xA6+41
	.DW  _0x0*2+138

	.DW  0x03
	.DW  _0xA6+46
	.DW  _0x0*2+143

	.DW  0x04
	.DW  _0xA6+49
	.DW  _0x0*2+146

	.DW  0x06
	.DW  _0xA6+53
	.DW  _0x0*2+150

	.DW  0x18
	.DW  _0xA6+59
	.DW  _0x0*2+156

	.DW  0x05
	.DW  _0xA6+83
	.DW  _0x0*2+180

	.DW  0x0D
	.DW  _0xA6+88
	.DW  _0x0*2+185

	.DW  0x05
	.DW  _0xA6+101
	.DW  _0x0*2+198

	.DW  0x0D
	.DW  _0xA6+106
	.DW  _0x0*2+203

	.DW  0x05
	.DW  _0xA6+119
	.DW  _0x0*2+216

	.DW  0x0D
	.DW  _0xA6+124
	.DW  _0x0*2+221

	.DW  0x05
	.DW  _0xA6+137
	.DW  _0x0*2+234

	.DW  0x08
	.DW  _0xA6+142
	.DW  _0x0*2+239

	.DW  0x0C
	.DW  _0xA6+150
	.DW  _0x0*2+247

	.DW  0x0E
	.DW  _0xA6+162
	.DW  _0x0*2+259

	.DW  0x0D
	.DW  _0xA6+176
	.DW  _0x0*2+273

	.DW  0x0E
	.DW  _0xA6+189
	.DW  _0x0*2+286

	.DW  0x05
	.DW  _0xA6+203
	.DW  _0x0*2+300

	.DW  0x0C
	.DW  _0xA6+208
	.DW  _0x0*2+305

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10/14/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <sim800AT.h>
;#include <string.h>
;#include <delay.h>
;
;#define STT1    "1&2 ON"
;#define STT2    "1:ON 2:OFF"
;#define STT3    "1:OFF 2:ON"
;#define STT4    "1&2 OFF"
;
;#define LOAD1   PORTC.0
;#define LOAD2   PORTC.1
;char content[15];
;char syntax[15];
;char qtyNum=10;
;char type[4];
;char phoneNumber[11];
;char msgStr[100];
;
;eeprom char sdt1[11];
;eeprom char sdt2[11];
;eeprom char sdt3[11];
;eeprom char lastNumber[11];
;
;eeprom char save1,save2,begin,tb;
;eeprom char password[4];
;
;char flag,checkpass,result=0;
;bit callFlag=0,smsFlag=0;
;// Declare your global variables here
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 003B {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0x0
; 0000 003C  LOAD1=~LOAD1;
	SBIS 0x15,0
	RJMP _0x3
	CBI  0x15,0
	RJMP _0x4
_0x3:
	SBI  0x15,0
_0x4:
; 0000 003D  save1=~save1;
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDB
	COM  R30
	RCALL SUBOPT_0x1
	RJMP _0x12F
; 0000 003E  delay_ms(20);
; 0000 003F 
; 0000 0040 }
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0044 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x0
; 0000 0045 LOAD2=~LOAD2;
	SBIS 0x15,1
	RJMP _0x5
	CBI  0x15,1
	RJMP _0x6
_0x5:
	SBI  0x15,1
_0x6:
; 0000 0046 save2=~save2;
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDB
	COM  R30
	RCALL SUBOPT_0x2
_0x12F:
	RCALL __EEPROMWRB
; 0000 0047     delay_ms(20);
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x3
; 0000 0048 
; 0000 0049 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 110
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0066 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	RCALL SUBOPT_0x4
; 0000 0067 char status,data;
; 0000 0068 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0069 data=UDR;
	IN   R16,12
; 0000 006A if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x7
; 0000 006B    {
; 0000 006C    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	RCALL SUBOPT_0x5
	ST   Z,R16
; 0000 006D    flag=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 006E #if RX_BUFFER_SIZE == 256
; 0000 006F    // special case for receiver buffer size=256
; 0000 0070    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0071 #else
; 0000 0072    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(110)
	CP   R30,R9
	BRNE _0x8
	CLR  R9
; 0000 0073    if (++rx_counter == RX_BUFFER_SIZE)
_0x8:
	INC  R11
	LDI  R30,LOW(110)
	CP   R30,R11
	BRNE _0x9
; 0000 0074       {
; 0000 0075       rx_counter=0;
	CLR  R11
; 0000 0076       rx_buffer_overflow=1;
	SET
	BLD  R2,2
; 0000 0077       }
; 0000 0078 #endif
; 0000 0079    }
_0x9:
; 0000 007A }
_0x7:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x12E
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0081 {
; 0000 0082 char data;
; 0000 0083 while (rx_counter==0);
;	data -> R17
; 0000 0084 data=rx_buffer[rx_rd_index++];
; 0000 0085 #if RX_BUFFER_SIZE != 256
; 0000 0086 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0087 #endif
; 0000 0088 #asm("cli")
; 0000 0089 --rx_counter;
; 0000 008A #asm("sei")
; 0000 008B return data;
; 0000 008C }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 1
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 00A2 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	RCALL SUBOPT_0x4
; 0000 00A3 if (tx_counter)
	TST  R12
	BREQ _0xE
; 0000 00A4    {
; 0000 00A5    --tx_counter;
	DEC  R12
; 0000 00A6    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00A7 #if TX_BUFFER_SIZE != 256
; 0000 00A8    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xF
	CLR  R13
; 0000 00A9 #endif
; 0000 00AA    }
_0xF:
; 0000 00AB }
_0xE:
_0x12E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00B2 {
_putchar:
; .FSTART _putchar
; 0000 00B3 while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0x10:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ _0x10
; 0000 00B4 #asm("cli")
	cli
; 0000 00B5 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R12
	BRNE _0x14
	SBIC 0xB,5
	RJMP _0x13
_0x14:
; 0000 00B6    {
; 0000 00B7    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R10
	INC  R10
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00B8 #if TX_BUFFER_SIZE != 256
; 0000 00B9    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x16
	CLR  R10
; 0000 00BA #endif
; 0000 00BB    ++tx_counter;
_0x16:
	INC  R12
; 0000 00BC    }
; 0000 00BD else
	RJMP _0x17
_0x13:
; 0000 00BE    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00BF #asm("sei")
_0x17:
	sei
; 0000 00C0 }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;
;
;void clearBuffer()
; 0000 00C6 {   char i;
_clearBuffer:
; .FSTART _clearBuffer
; 0000 00C7 
; 0000 00C8     for(i=0;i<rx_wr_index;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x19:
	CP   R17,R9
	BRSH _0x1A
; 0000 00C9     {
; 0000 00CA         rx_buffer[i]=msgStr[i]=phoneNumber[i]=content[i]=type[i]=0;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	MOVW R24,R30
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x8
	MOVW R22,R30
	RCALL SUBOPT_0x6
	SUBI R30,LOW(-_content)
	SBCI R31,HIGH(-_content)
	RCALL SUBOPT_0x9
	SUBI R26,LOW(-_type)
	SBCI R27,HIGH(-_type)
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL SUBOPT_0xA
	MOVW R26,R22
	ST   X,R30
	MOVW R26,R24
	ST   X,R30
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00CB     }
	SUBI R17,-1
	RJMP _0x19
_0x1A:
; 0000 00CC     rx_wr_index=0;
	CLR  R9
; 0000 00CD     checkpass=0;
	CLR  R7
; 0000 00CE     result=0;
	CLR  R6
; 0000 00CF     flag=0;
	CLR  R4
; 0000 00D0 }
	RJMP _0x2080003
; .FEND
;/****************************************************************
;   content return from sim:
;   - call:  RING
;
;            +CLIP: "0964444373",161,"",0,"",0
;
;   -sms: +CMT: "+84964444373","","17/10/14,15:04:39+28"
;                #0000 on
;   -kttk: +CUSD: 0, "TK goc la 12d. De biet cac CT dac biet cua Quy khach, bam goi *098#.", 15
;
;******************************************************************/
;void comparePhoneNumber();
;void callHandle();
;void smsHandle();
;unsigned char checkStatus();
;
;void sendSTT()
; 0000 00E2 {
_sendSTT:
; .FSTART _sendSTT
; 0000 00E3     switch(checkStatus())
	RCALL _checkStatus
; 0000 00E4        {
; 0000 00E5          case 1: sendSMS(phoneNumber,STT1);
	CPI  R30,LOW(0x1)
	BRNE _0x1E
	RCALL SUBOPT_0xB
	__POINTW2MN _0x1F,0
	RJMP _0x11D
; 0000 00E6                  break;
; 0000 00E7          case 2: sendSMS(phoneNumber,STT2);
_0x1E:
	CPI  R30,LOW(0x2)
	BRNE _0x20
	RCALL SUBOPT_0xB
	__POINTW2MN _0x1F,7
	RJMP _0x11D
; 0000 00E8                  break;
; 0000 00E9          case 3: sendSMS(phoneNumber,STT3);
_0x20:
	CPI  R30,LOW(0x3)
	BRNE _0x21
	RCALL SUBOPT_0xB
	__POINTW2MN _0x1F,18
	RJMP _0x11D
; 0000 00EA                  break;
; 0000 00EB          case 4: sendSMS(phoneNumber,STT4);
_0x21:
	CPI  R30,LOW(0x4)
	BRNE _0x1D
	RCALL SUBOPT_0xB
	__POINTW2MN _0x1F,29
_0x11D:
	RCALL _sendSMS
; 0000 00EC                  break;
; 0000 00ED        }
_0x1D:
; 0000 00EE }
	RET
; .FEND

	.DSEG
_0x1F:
	.BYTE 0x25
;void strHandle()
; 0000 00F0 {

	.CSEG
_strHandle:
; .FSTART _strHandle
; 0000 00F1     char i,k,l,pos,e=0,n=0;
; 0000 00F2     char sendNumber[11];
; 0000 00F3             while(strcmp(type,"CLIP")!=0 && strcmp(type,"CMT:")!=0 && strcmp(type,"CUSD")!=0)
	SBIW R28,11
	RCALL __SAVELOCR6
;	i -> R17
;	k -> R16
;	l -> R19
;	pos -> R18
;	e -> R21
;	n -> R20
;	sendNumber -> Y+6
	LDI  R21,0
	LDI  R20,0
_0x23:
	RCALL SUBOPT_0xC
	__POINTW2MN _0x26,0
	RCALL SUBOPT_0xD
	BREQ _0x27
	RCALL SUBOPT_0xC
	__POINTW2MN _0x26,5
	RCALL SUBOPT_0xD
	BREQ _0x27
	RCALL SUBOPT_0xC
	__POINTW2MN _0x26,10
	RCALL SUBOPT_0xD
	BRNE _0x28
_0x27:
	RJMP _0x25
_0x28:
; 0000 00F4             {
; 0000 00F5                 for(i=0;i<4;i++)
	LDI  R17,LOW(0)
_0x2A:
	CPI  R17,4
	BRSH _0x2B
; 0000 00F6                 {
; 0000 00F7                     type[i]=rx_buffer[strpos(rx_buffer,'+')+1+i];
	RCALL SUBOPT_0x6
	SUBI R30,LOW(-_type)
	SBCI R31,HIGH(-_type)
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xE
	LDI  R26,LOW(43)
	RCALL _strpos
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x10
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00F8                 }
	SUBI R17,-1
	RJMP _0x2A
_0x2B:
; 0000 00F9                 e++;
	SUBI R21,-1
; 0000 00FA                 //printf(".");
; 0000 00FB                 delay_ms(50);
	RCALL SUBOPT_0x11
; 0000 00FC                 if(e>20)
	CPI  R21,21
	BRLO _0x2C
; 0000 00FD                 {
; 0000 00FE                   //printf("time out");
; 0000 00FF                   clearBuffer();
	RCALL _clearBuffer
; 0000 0100                   break;
	RJMP _0x25
; 0000 0101                 }
; 0000 0102             }
_0x2C:
	RJMP _0x23
_0x25:
; 0000 0103             if(strcmp(type,"CLIP")==0)  //call
	RCALL SUBOPT_0xC
	__POINTW2MN _0x26,15
	RCALL SUBOPT_0xD
	BREQ PC+2
	RJMP _0x2D
; 0000 0104             {
; 0000 0105                 pos=strpos(rx_buffer,34); // "  //
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x12
	MOV  R18,R30
; 0000 0106                 if(rx_buffer[pos+11]==34) qtyNum=10;
	RCALL SUBOPT_0x13
	__ADDW1MN _rx_buffer,11
	LD   R26,Z
	CPI  R26,LOW(0x22)
	BRNE _0x2E
	LDI  R30,LOW(10)
	RJMP _0x11E
; 0000 0107                 else qtyNum=11;
_0x2E:
	LDI  R30,LOW(11)
_0x11E:
	MOV  R5,R30
; 0000 0108                 for(k=0;k<qtyNum;k++)
	LDI  R16,LOW(0)
_0x31:
	CP   R16,R5
	BRSH _0x32
; 0000 0109                 {
; 0000 010A                    phoneNumber[k]=rx_buffer[pos+1+k];
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x8
	MOVW R0,R30
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xA
; 0000 010B                 }
	SUBI R16,-1
	RJMP _0x31
_0x32:
; 0000 010C                 if(lastNumber[0]!=phoneNumber[0] || lastNumber[2]!=phoneNumber[2] || lastNumber[4]!=phoneNumber[4] ||
; 0000 010D                 lastNumber[6]!=phoneNumber[6] || lastNumber[9]!=phoneNumber[9])
	RCALL SUBOPT_0x15
	BRNE _0x34
	RCALL SUBOPT_0x16
	BRNE _0x34
	RCALL SUBOPT_0x17
	BRNE _0x34
	RCALL SUBOPT_0x18
	BRNE _0x34
	__POINTW2MN _lastNumber,9
	RCALL __EEPROMRDB
	MOV  R26,R30
	__GETB1MN _phoneNumber,9
	CP   R30,R26
	BREQ _0x33
_0x34:
; 0000 010E                 {
; 0000 010F                    for(k=0;k<11;k++)
	LDI  R16,LOW(0)
_0x37:
	CPI  R16,11
	BRSH _0x38
; 0000 0110                    {
; 0000 0111                      if(phoneNumber[k]<48||phoneNumber[k]>57) lastNumber[k]=0;
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x19
	BRLO _0x3A
	RCALL SUBOPT_0x1A
	BRLO _0x39
_0x3A:
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(0)
	RJMP _0x11F
; 0000 0112                      else lastNumber[k]=phoneNumber[k];
_0x39:
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x8
	LD   R30,Z
_0x11F:
	RCALL __EEPROMWRB
; 0000 0113                    }
	SUBI R16,-1
	RJMP _0x37
_0x38:
; 0000 0114                 }
; 0000 0115                 callFlag=1;
_0x33:
	SET
	BLD  R2,0
; 0000 0116                 if(callFlag)callHandle();
	SBRC R2,0
	RCALL _callHandle
; 0000 0117 
; 0000 0118             }
; 0000 0119             else  //sms
	RJMP _0x3E
_0x2D:
; 0000 011A             {
; 0000 011B                if(strcmp(type,"CMT:")==0)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x26,20
	RCALL SUBOPT_0xD
	BREQ PC+2
	RJMP _0x3F
; 0000 011C                {    //"+84964444373", ":0 ,:14-15
; 0000 011D                     while(strpos(rx_buffer,'.')<=0)
_0x40:
	RCALL SUBOPT_0xE
	LDI  R26,LOW(46)
	RCALL _strpos
	RCALL __CPW01
	BRLT _0x42
; 0000 011E                     {
; 0000 011F                        n++;
	SUBI R20,-1
; 0000 0120                        //printf(".");
; 0000 0121                        delay_ms(50);
	RCALL SUBOPT_0x11
; 0000 0122                        if(n>20)
	CPI  R20,21
	BRLO _0x43
; 0000 0123                        {
; 0000 0124                          //printf("time out");
; 0000 0125                          clearBuffer();
	RCALL _clearBuffer
; 0000 0126                          break;
	RJMP _0x42
; 0000 0127                        }
; 0000 0128                     }
_0x43:
	RJMP _0x40
_0x42:
; 0000 0129                     if(strcmp(type,"CMT:")==0)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x26,25
	RCALL SUBOPT_0xD
	BREQ PC+2
	RJMP _0x44
; 0000 012A                     {
; 0000 012B                         pos=strpos(rx_buffer,'#');
	RCALL SUBOPT_0xE
	LDI  R26,LOW(35)
	RCALL _strpos
	MOV  R18,R30
; 0000 012C                         if(pos>0)
	CPI  R18,1
	BRSH PC+2
	RJMP _0x45
; 0000 012D                         {
; 0000 012E                             for(k=0;k<strpos(rx_buffer,'.')-pos;k++)
	LDI  R16,LOW(0)
_0x47:
	RCALL SUBOPT_0xE
	LDI  R26,LOW(46)
	RCALL _strpos
	MOVW R26,R30
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	BRGE _0x48
; 0000 012F                             {
; 0000 0130                                 msgStr[k]=rx_buffer[pos+1+k];
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x7
	MOVW R0,R30
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xA
; 0000 0131                             }
	SUBI R16,-1
	RJMP _0x47
_0x48:
; 0000 0132                             for(l=1;l<(strpos(rx_buffer,',')-strpos(rx_buffer,34)-4);l++)
	LDI  R19,LOW(1)
_0x4A:
	RCALL SUBOPT_0xE
	LDI  R26,LOW(44)
	RCALL _strpos
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x12
	POP  R26
	POP  R27
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1E
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x4B
; 0000 0133                             {
; 0000 0134                                 phoneNumber[0]='0';
	LDI  R30,LOW(48)
	STS  _phoneNumber,R30
; 0000 0135                                 phoneNumber[l]=rx_buffer[strpos(rx_buffer,34)+3+l];
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x8
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x12
	ADIW R30,3
	MOVW R26,R30
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x10
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0136                             }
	SUBI R19,-1
	RJMP _0x4A
_0x4B:
; 0000 0137                             if(lastNumber[0]!=phoneNumber[0] || lastNumber[2]!=phoneNumber[2] || lastNumber[4]!=phoneNum ...
; 0000 0138                             lastNumber[6]!=phoneNumber[6] || lastNumber[7]!=phoneNumber[7])
	RCALL SUBOPT_0x15
	BRNE _0x4D
	RCALL SUBOPT_0x16
	BRNE _0x4D
	RCALL SUBOPT_0x17
	BRNE _0x4D
	RCALL SUBOPT_0x18
	BRNE _0x4D
	__POINTW2MN _lastNumber,7
	RCALL __EEPROMRDB
	MOV  R26,R30
	__GETB1MN _phoneNumber,7
	CP   R30,R26
	BREQ _0x4C
_0x4D:
; 0000 0139                             {
; 0000 013A                                for(l=0;l<11;l++)
	LDI  R19,LOW(0)
_0x50:
	CPI  R19,11
	BRSH _0x51
; 0000 013B                                { printf("s.");
	__POINTW1FN _0x0,52
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
; 0000 013C                                  if(phoneNumber[l]<48||phoneNumber[l]>57) lastNumber[l]=0;
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x19
	BRLO _0x53
	RCALL SUBOPT_0x1A
	BRLO _0x52
_0x53:
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x22
	LDI  R30,LOW(0)
	RJMP _0x120
; 0000 013D                                  else lastNumber[l]=phoneNumber[l];
_0x52:
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x8
	LD   R30,Z
_0x120:
	RCALL __EEPROMWRB
; 0000 013E                                }
	SUBI R19,-1
	RJMP _0x50
_0x51:
; 0000 013F                             }
; 0000 0140                             //puts(phoneNumber);
; 0000 0141                             smsFlag=1;
_0x4C:
	SET
	BLD  R2,1
; 0000 0142                             //puts(msgStr);
; 0000 0143                             if(smsFlag) smsHandle();
	SBRC R2,1
	RCALL _smsHandle
; 0000 0144                         }
; 0000 0145                     }
_0x45:
; 0000 0146 
; 0000 0147                }
_0x44:
; 0000 0148                else
	RJMP _0x57
_0x3F:
; 0000 0149                {//+CUSD: 0, "TK goc la 12d. De biet cac CT dac biet cua Quy khach, bam goi *098#.", 15
; 0000 014A                     if(strcmp(type,"CUSD")==0)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x26,30
	RCALL SUBOPT_0xD
	BREQ PC+2
	RJMP _0x58
; 0000 014B                     {
; 0000 014C                        pos=strpos(rx_buffer,34);
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x12
	MOV  R18,R30
; 0000 014D                        for(k=0;k<(strrpos(rx_buffer,34)-pos-1);k++)
	LDI  R16,LOW(0)
_0x5A:
	RCALL SUBOPT_0xE
	LDI  R26,LOW(34)
	RCALL _strrpos
	MOVW R26,R30
	RCALL SUBOPT_0x13
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	BRGE _0x5B
; 0000 014E                        {
; 0000 014F                          msgStr[k]=rx_buffer[pos+1+k];
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x7
	MOVW R0,R30
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xA
; 0000 0150                        }
	SUBI R16,-1
	RJMP _0x5A
_0x5B:
; 0000 0151                        n=0;
	LDI  R20,LOW(0)
; 0000 0152                        while(strcmp(msgStr,"TK goc")<0 && strcmp(msgStr,"Ma so the")<0 && strcmp(msgStr,"Tai khoan")<0)
_0x5C:
	RCALL SUBOPT_0x23
	__POINTW2MN _0x26,35
	RCALL SUBOPT_0xD
	BRGE _0x5F
	RCALL SUBOPT_0x23
	__POINTW2MN _0x26,42
	RCALL SUBOPT_0xD
	BRGE _0x5F
	RCALL SUBOPT_0x23
	__POINTW2MN _0x26,52
	RCALL SUBOPT_0xD
	BRLT _0x60
_0x5F:
	RJMP _0x5E
_0x60:
; 0000 0153                        {
; 0000 0154                          n++;
	SUBI R20,-1
; 0000 0155                          delay_ms(50);
	RCALL SUBOPT_0x11
; 0000 0156                          if(n>20)
	CPI  R20,21
	BRLO _0x61
; 0000 0157                          { printf("time out");
	__POINTW1FN _0x0,82
	RCALL SUBOPT_0x24
; 0000 0158                            clearBuffer();
	RCALL SUBOPT_0x25
; 0000 0159                            flag=0;
; 0000 015A                            smsFlag=0;
; 0000 015B                            break;
	RJMP _0x5E
; 0000 015C                          }
; 0000 015D                        }
_0x61:
	RJMP _0x5C
_0x5E:
; 0000 015E                        if(strcmp(msgStr,"TK goc")>=0 || strcmp(msgStr,"Ma so the")>=0 || strcmp(msgStr,"Tai khoan")>=0)
	RCALL SUBOPT_0x23
	__POINTW2MN _0x26,62
	RCALL SUBOPT_0xD
	BRGE _0x63
	RCALL SUBOPT_0x23
	__POINTW2MN _0x26,69
	RCALL SUBOPT_0xD
	BRGE _0x63
	RCALL SUBOPT_0x23
	__POINTW2MN _0x26,79
	RCALL SUBOPT_0xD
	BRLT _0x62
_0x63:
; 0000 015F                        {
; 0000 0160                          for(l=0;l<11;l++)
	LDI  R19,LOW(0)
_0x66:
	CPI  R19,11
	BRSH _0x67
; 0000 0161                          {
; 0000 0162                            if(lastNumber[l]<48|| lastNumber[l]>57) sendNumber[l]=0;
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x22
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x30)
	BRLO _0x69
	CPI  R30,LOW(0x3A)
	BRLO _0x68
_0x69:
	RCALL SUBOPT_0x1F
	MOVW R26,R28
	ADIW R26,6
	RCALL SUBOPT_0x26
	RJMP _0x121
; 0000 0163                            else sendNumber[l]=lastNumber[l];
_0x68:
	RCALL SUBOPT_0x1F
	MOVW R26,R28
	ADIW R26,6
	RCALL SUBOPT_0x27
	MOVW R0,R30
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x28
_0x121:
	ST   X,R30
; 0000 0164                          }
	SUBI R19,-1
	RJMP _0x66
_0x67:
; 0000 0165                          sendSMS(sendNumber,msgStr);
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x20
	LDI  R26,LOW(_msgStr)
	LDI  R27,HIGH(_msgStr)
	RCALL _sendSMS
; 0000 0166                          clearBuffer();
	RCALL SUBOPT_0x25
; 0000 0167                          flag=0;
; 0000 0168                          smsFlag=0;
; 0000 0169                        }
; 0000 016A                        //puts(msgStr);
; 0000 016B 
; 0000 016C                     }
_0x62:
; 0000 016D 
; 0000 016E 
; 0000 016F                }
_0x58:
_0x57:
; 0000 0170             }
_0x3E:
; 0000 0171 
; 0000 0172 }
	RCALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.DSEG
_0x26:
	.BYTE 0x59
;void checkPassword()
; 0000 0174 {

	.CSEG
_checkPassword:
; .FSTART _checkPassword
; 0000 0175    if(msgStr[0]==password[0]&&msgStr[1]==password[1]&&msgStr[2]==password[2]&&msgStr[3]==password[3]) checkpass=1;
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	RCALL __EEPROMRDB
	LDS  R26,_msgStr
	CP   R30,R26
	BRNE _0x6D
	__POINTW2MN _password,1
	RCALL __EEPROMRDB
	__GETB2MN _msgStr,1
	CP   R30,R26
	BRNE _0x6D
	__POINTW2MN _password,2
	RCALL __EEPROMRDB
	__GETB2MN _msgStr,2
	CP   R30,R26
	BRNE _0x6D
	__POINTW2MN _password,3
	RCALL __EEPROMRDB
	__GETB2MN _msgStr,3
	CP   R30,R26
	BREQ _0x6E
_0x6D:
	RJMP _0x6C
_0x6E:
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0176    else
	RJMP _0x6F
_0x6C:
; 0000 0177    {
; 0000 0178     checkpass=0;
	CLR  R7
; 0000 0179    }
_0x6F:
; 0000 017A }
	RET
; .FEND
;void comparePhoneNumber()
; 0000 017C {  char dt1[11],dt2[11],dt3[11];
_comparePhoneNumber:
; .FSTART _comparePhoneNumber
; 0000 017D    char i;
; 0000 017E    for(i=0;i<11;i++)
	SBIW R28,33
	ST   -Y,R17
;	dt1 -> Y+23
;	dt2 -> Y+12
;	dt3 -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x71:
	CPI  R17,11
	BRSH _0x72
; 0000 017F    {
; 0000 0180         if(sdt1[i]==255) dt1[i]=0;
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
	BRNE _0x73
	RCALL SUBOPT_0x6
	MOVW R26,R28
	ADIW R26,23
	RCALL SUBOPT_0x26
	RJMP _0x122
; 0000 0181         else dt1[i]=sdt1[i];
_0x73:
	RCALL SUBOPT_0x6
	MOVW R26,R28
	ADIW R26,23
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x28
_0x122:
	ST   X,R30
; 0000 0182         if(sdt2[i]==255) dt2[i]=0;
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2B
	BRNE _0x75
	RCALL SUBOPT_0x6
	MOVW R26,R28
	ADIW R26,12
	RCALL SUBOPT_0x26
	RJMP _0x123
; 0000 0183         else dt2[i]=sdt2[i];
_0x75:
	RCALL SUBOPT_0x6
	MOVW R26,R28
	ADIW R26,12
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x28
_0x123:
	ST   X,R30
; 0000 0184         if(sdt3[i]==255) dt3[i]=0;
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2B
	BRNE _0x77
	RCALL SUBOPT_0x6
	MOVW R26,R28
	ADIW R26,1
	RCALL SUBOPT_0x26
	RJMP _0x124
; 0000 0185         else dt3[i]=sdt3[i];
_0x77:
	RCALL SUBOPT_0x6
	MOVW R26,R28
	ADIW R26,1
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x28
_0x124:
	ST   X,R30
; 0000 0186    }
	SUBI R17,-1
	RJMP _0x71
_0x72:
; 0000 0187    if(callFlag==1)
	SBRS R2,0
	RJMP _0x79
; 0000 0188    {
; 0000 0189       if(strcmp(phoneNumber,dt1)==0||strcmp(phoneNumber,dt2)==0||strcmp(phoneNumber,dt3)==0) result=1;
	RCALL SUBOPT_0xB
	MOVW R26,R28
	ADIW R26,25
	RCALL SUBOPT_0xD
	BREQ _0x7B
	RCALL SUBOPT_0xB
	MOVW R26,R28
	ADIW R26,14
	RCALL SUBOPT_0xD
	BREQ _0x7B
	RCALL SUBOPT_0xB
	MOVW R26,R28
	ADIW R26,3
	RCALL SUBOPT_0xD
	BRNE _0x7A
_0x7B:
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 018A       else
	RJMP _0x7D
_0x7A:
; 0000 018B       {
; 0000 018C         result=0;
	CLR  R6
; 0000 018D       }
_0x7D:
; 0000 018E    }
; 0000 018F }
_0x79:
	LDD  R17,Y+0
	ADIW R28,34
	RET
; .FEND
;void callHandle()
; 0000 0191 {   unsigned char n=0;
_callHandle:
; .FSTART _callHandle
; 0000 0192     comparePhoneNumber();
	ST   -Y,R17
;	n -> R17
	LDI  R17,0
	RCALL _comparePhoneNumber
; 0000 0193     while(result==0)
_0x7E:
	TST  R6
	BRNE _0x80
; 0000 0194     {
; 0000 0195        n++;
	SUBI R17,-1
; 0000 0196        //printf(".");
; 0000 0197        delay_ms(50);
	RCALL SUBOPT_0x11
; 0000 0198        if(n>20)
	CPI  R17,21
	BRLO _0x81
; 0000 0199        {
; 0000 019A           //printf("time out");
; 0000 019B           printf("ATH\r\n");
	RCALL SUBOPT_0x2E
; 0000 019C           clearBuffer();
	RCALL _clearBuffer
; 0000 019D           result=callFlag=0;
	RCALL SUBOPT_0x2F
; 0000 019E           flag=0;
; 0000 019F           break;
	RJMP _0x80
; 0000 01A0        }
; 0000 01A1     }
_0x81:
	RJMP _0x7E
_0x80:
; 0000 01A2     if(result==1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x82
; 0000 01A3     {
; 0000 01A4         if(save1==1&&save2==1)
	RCALL SUBOPT_0x30
	BRNE _0x84
	RCALL SUBOPT_0x31
	BREQ _0x85
_0x84:
	RJMP _0x83
_0x85:
; 0000 01A5         {
; 0000 01A6 
; 0000 01A7             LOAD1=0;
	CBI  0x15,0
; 0000 01A8             LOAD2=0;
	RCALL SUBOPT_0x32
; 0000 01A9             save1=save2=0;
	RCALL SUBOPT_0x1
	RCALL __EEPROMWRB
; 0000 01AA             //printf("off");
; 0000 01AB             printf("ATH\r\n");
	RCALL SUBOPT_0x2E
; 0000 01AC             delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x3
; 0000 01AD             if(tb!=1) sendSTT();
	RCALL SUBOPT_0x33
	BREQ _0x8A
	RCALL _sendSTT
; 0000 01AE             clearBuffer();
_0x8A:
	RJMP _0x125
; 0000 01AF             result=callFlag=0;
; 0000 01B0             flag=0;
; 0000 01B1         }
; 0000 01B2         else
_0x83:
; 0000 01B3         {
; 0000 01B4             LOAD1=1;
	SBI  0x15,0
; 0000 01B5             LOAD2=1;
	RCALL SUBOPT_0x34
; 0000 01B6             save1=save2=1;
	RCALL SUBOPT_0x1
	RCALL __EEPROMWRB
; 0000 01B7             //printf("on");
; 0000 01B8             printf("ATH\r\n");
	RCALL SUBOPT_0x2E
; 0000 01B9             delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x3
; 0000 01BA             if(tb!=1) sendSTT();
	RCALL SUBOPT_0x33
	BREQ _0x90
	RCALL _sendSTT
; 0000 01BB             clearBuffer();
_0x90:
_0x125:
	RCALL _clearBuffer
; 0000 01BC             result=callFlag=0;
	RCALL SUBOPT_0x2F
; 0000 01BD             flag=0;
; 0000 01BE         }
; 0000 01BF     }
; 0000 01C0 }
_0x82:
_0x2080003:
	LD   R17,Y+
	RET
; .FEND
;
;unsigned char checkStatus()
; 0000 01C3 {
_checkStatus:
; .FSTART _checkStatus
; 0000 01C4       if(save1==1)
	RCALL SUBOPT_0x30
	BRNE _0x91
; 0000 01C5       {
; 0000 01C6         if(save2==1)
	RCALL SUBOPT_0x31
	BRNE _0x92
; 0000 01C7         { // thiet bi 1 va 2 dang bat
; 0000 01C8           return 1;
	LDI  R30,LOW(1)
	RET
; 0000 01C9         }
; 0000 01CA         else
_0x92:
; 0000 01CB         { //thiet bi 1 dang bat, thiet bi 2 dang tat
; 0000 01CC           return 2;
	LDI  R30,LOW(2)
	RET
; 0000 01CD         }
; 0000 01CE       }
; 0000 01CF       else
	RJMP _0x94
_0x91:
; 0000 01D0       {
; 0000 01D1         if(save2==1)
	RCALL SUBOPT_0x31
	BRNE _0x95
; 0000 01D2         { //thiet bi 1 dang tat, thiet bi 2 dang bat
; 0000 01D3           return 3;
	LDI  R30,LOW(3)
	RET
; 0000 01D4         }
; 0000 01D5         else
_0x95:
; 0000 01D6         { //thiet bi 1 va 2 dang tat
; 0000 01D7           return 4;
	LDI  R30,LOW(4)
	RET
; 0000 01D8         }
; 0000 01D9       }
_0x94:
; 0000 01DA }
	RET
; .FEND
;
;void smsHandle()
; 0000 01DD {
_smsHandle:
; .FSTART _smsHandle
; 0000 01DE     unsigned char i,poskey,i2,endstr=0,lastspace,firstspace,n=0;
; 0000 01DF     //char ndt1[11],ndt2[11],ndt3[11];
; 0000 01E0     poskey=11;
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
	RCALL __SAVELOCR6
;	i -> R17
;	poskey -> R16
;	i2 -> R19
;	endstr -> R18
;	lastspace -> R21
;	firstspace -> R20
;	n -> Y+6
	LDI  R18,0
	LDI  R16,LOW(11)
; 0000 01E1     lastspace=strrpos(msgStr,32);
	RCALL SUBOPT_0x23
	LDI  R26,LOW(32)
	RCALL _strrpos
	MOV  R21,R30
; 0000 01E2     firstspace=strpos(msgStr,32);
	RCALL SUBOPT_0x23
	LDI  R26,LOW(32)
	RCALL _strpos
	MOV  R20,R30
; 0000 01E3     endstr=strrpos(msgStr,'.');
	RCALL SUBOPT_0x23
	LDI  R26,LOW(46)
	RCALL _strrpos
	MOV  R18,R30
; 0000 01E4 
; 0000 01E5     for(i=0;i<endstr-5;i++)
	LDI  R17,LOW(0)
_0x98:
	RCALL SUBOPT_0x13
	SBIW R30,5
	RCALL SUBOPT_0x29
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x99
; 0000 01E6         {
; 0000 01E7           content[i]=msgStr[5+i];
	RCALL SUBOPT_0x29
	SUBI R26,LOW(-_content)
	SBCI R27,HIGH(-_content)
	RCALL SUBOPT_0x6
	__ADDW1MN _msgStr,5
	LD   R30,Z
	ST   X,R30
; 0000 01E8         }
	SUBI R17,-1
	RJMP _0x98
_0x99:
; 0000 01E9     for(i2=0;i2<(lastspace-(firstspace+1));i2++)
	LDI  R19,LOW(0)
_0x9B:
	MOV  R26,R21
	CLR  R27
	MOV  R30,R20
	LDI  R31,0
	ADIW R30,1
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1E
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x9C
; 0000 01EA         {
; 0000 01EB           syntax[i2]=msgStr[firstspace+1+i2];
	RCALL SUBOPT_0x1F
	SUBI R30,LOW(-_syntax)
	SBCI R31,HIGH(-_syntax)
	MOVW R0,R30
	MOV  R30,R20
	LDI  R31,0
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x7
	LD   R30,Z
	RCALL SUBOPT_0xA
; 0000 01EC         }
	SUBI R19,-1
	RJMP _0x9B
_0x9C:
; 0000 01ED     for(i2=(lastspace-(firstspace+1));i2<15;i2++)
	MOV  R26,R20
	SUBI R26,-LOW(1)
	MOV  R30,R21
	SUB  R30,R26
	MOV  R19,R30
_0x9E:
	CPI  R19,15
	BRSH _0x9F
; 0000 01EE         {
; 0000 01EF             syntax[i2]=0;
	RCALL SUBOPT_0x1F
	SUBI R30,LOW(-_syntax)
	SBCI R31,HIGH(-_syntax)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 01F0         }
	SUBI R19,-1
	RJMP _0x9E
_0x9F:
; 0000 01F1     if(msgStr[0]=='c' && msgStr[1]=='t' && msgStr[2]=='a' && msgStr[3]=='G')
	LDS  R26,_msgStr
	CPI  R26,LOW(0x63)
	BRNE _0xA1
	__GETB2MN _msgStr,1
	CPI  R26,LOW(0x74)
	BRNE _0xA1
	__GETB2MN _msgStr,2
	CPI  R26,LOW(0x61)
	BRNE _0xA1
	__GETB2MN _msgStr,3
	CPI  R26,LOW(0x47)
	BREQ _0xA2
_0xA1:
	RJMP _0xA0
_0xA2:
; 0000 01F2     {
; 0000 01F3       char rs;
; 0000 01F4       for(rs=0;rs<4;rs++)
	SBIW R28,1
;	n -> Y+7
;	rs -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0xA4:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRSH _0xA5
; 0000 01F5       {
; 0000 01F6         password[rs]='0';
	LDI  R27,0
	SUBI R26,LOW(-_password)
	SBCI R27,HIGH(-_password)
	RCALL SUBOPT_0x35
; 0000 01F7       }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xA4
_0xA5:
; 0000 01F8       //printf("reset success");
; 0000 01F9       sendSMS(phoneNumber,"mat khau: 0000");
	RCALL SUBOPT_0xB
	__POINTW2MN _0xA6,0
	RCALL _sendSMS
; 0000 01FA       clearBuffer();
	RCALL SUBOPT_0x25
; 0000 01FB       flag=0;
; 0000 01FC       smsFlag=0;
; 0000 01FD     }
	ADIW R28,1
; 0000 01FE     checkPassword();
_0xA0:
	RCALL _checkPassword
; 0000 01FF     while(checkpass==0)
_0xA7:
	TST  R7
	BRNE _0xA9
; 0000 0200     {  checkPassword();
	RCALL _checkPassword
; 0000 0201        n++;
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
; 0000 0202        delay_ms(50);
	RCALL SUBOPT_0x11
; 0000 0203        if(n>40)
	LDD  R26,Y+6
	CPI  R26,LOW(0x29)
	BRLO _0xAA
; 0000 0204        {
; 0000 0205          //printf("password error");
; 0000 0206          sendSMS(phoneNumber,"mat khau sai");
	RCALL SUBOPT_0xB
	__POINTW2MN _0xA6,15
	RCALL _sendSMS
; 0000 0207          clearBuffer();
	RCALL _clearBuffer
; 0000 0208          checkpass=0;
	CLR  R7
; 0000 0209          flag=0;
	CLR  R4
; 0000 020A          smsFlag=0;
	CLT
	BLD  R2,1
; 0000 020B          break;
	RJMP _0xA9
; 0000 020C        }
; 0000 020D     }
_0xAA:
	RJMP _0xA7
_0xA9:
; 0000 020E     if(checkpass==1)
	LDI  R30,LOW(1)
	CP   R30,R7
	BREQ PC+2
	RJMP _0xAB
; 0000 020F     {
; 0000 0210         if(strcmp(content,"on1")==0)
	RCALL SUBOPT_0x36
	__POINTW2MN _0xA6,28
	RCALL SUBOPT_0xD
	BRNE _0xAC
; 0000 0211         {
; 0000 0212           LOAD1=1;
	SBI  0x15,0
; 0000 0213           save1=1;
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x37
; 0000 0214           if(tb!=1) sendSTT();
	RCALL SUBOPT_0x33
	BREQ _0xAF
	RCALL _sendSTT
; 0000 0215           clearBuffer();
_0xAF:
	RJMP _0x126
; 0000 0216           flag=0;
; 0000 0217           smsFlag=0;
; 0000 0218 
; 0000 0219         }else{
_0xAC:
; 0000 021A            if(strcmp(content,"on2")==0)
	RCALL SUBOPT_0x36
	__POINTW2MN _0xA6,32
	RCALL SUBOPT_0xD
	BRNE _0xB1
; 0000 021B             {
; 0000 021C               LOAD2=1;
	RCALL SUBOPT_0x34
; 0000 021D               save2=1;
; 0000 021E               if(tb!=1) sendSTT();
	RCALL SUBOPT_0x33
	BREQ _0xB4
	RCALL _sendSTT
; 0000 021F               clearBuffer();
_0xB4:
	RJMP _0x126
; 0000 0220               flag=0;
; 0000 0221               smsFlag=0;
; 0000 0222             }else{
_0xB1:
; 0000 0223                 if(strcmp(content,"off1")==0)
	RCALL SUBOPT_0x36
	__POINTW2MN _0xA6,36
	RCALL SUBOPT_0xD
	BRNE _0xB6
; 0000 0224                 {
; 0000 0225                   LOAD1=0;
	CBI  0x15,0
; 0000 0226                   save1=0;
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x38
; 0000 0227                   if(tb!=1) sendSTT();
	RCALL SUBOPT_0x33
	BREQ _0xB9
	RCALL _sendSTT
; 0000 0228                   clearBuffer();
_0xB9:
	RJMP _0x126
; 0000 0229                   flag=0;
; 0000 022A                   smsFlag=0;
; 0000 022B                 } else{
_0xB6:
; 0000 022C 
; 0000 022D                     if(strcmp(content,"off2")==0)
	RCALL SUBOPT_0x36
	__POINTW2MN _0xA6,41
	RCALL SUBOPT_0xD
	BRNE _0xBB
; 0000 022E                     {
; 0000 022F                       LOAD2=0;
	RCALL SUBOPT_0x32
; 0000 0230                       save2=0;
; 0000 0231                       if(tb!=1) sendSTT();
	RCALL SUBOPT_0x33
	BREQ _0xBE
	RCALL _sendSTT
; 0000 0232                       clearBuffer();
_0xBE:
	RJMP _0x126
; 0000 0233                       flag=0;
; 0000 0234                       smsFlag=0;
; 0000 0235                     }else {
_0xBB:
; 0000 0236 
; 0000 0237                         if(strcmp(content,"on")==0)
	RCALL SUBOPT_0x36
	__POINTW2MN _0xA6,46
	RCALL SUBOPT_0xD
	BRNE _0xC0
; 0000 0238                         {
; 0000 0239                           LOAD1=1;
	SBI  0x15,0
; 0000 023A                           LOAD2=1;
	SBI  0x15,1
; 0000 023B                           save1=1;
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x37
; 0000 023C                           save2=1;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x37
; 0000 023D                           if(tb!=1) sendSTT();
	RCALL SUBOPT_0x33
	BREQ _0xC5
	RCALL _sendSTT
; 0000 023E                           clearBuffer();
_0xC5:
	RJMP _0x126
; 0000 023F                           flag=0;
; 0000 0240                           smsFlag=0;
; 0000 0241                         }else{
_0xC0:
; 0000 0242 
; 0000 0243                             if(strcmp(content,"off")==0)
	RCALL SUBOPT_0x36
	__POINTW2MN _0xA6,49
	RCALL SUBOPT_0xD
	BRNE _0xC7
; 0000 0244                             {
; 0000 0245                               LOAD1=0;
	CBI  0x15,0
; 0000 0246                               LOAD2=0;
	CBI  0x15,1
; 0000 0247                               save1=0;
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x38
; 0000 0248                               save2=0;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x38
; 0000 0249                               if(tb!=1) sendSTT();
	RCALL SUBOPT_0x33
	BREQ _0xCC
	RCALL _sendSTT
; 0000 024A                               clearBuffer();
_0xCC:
	RJMP _0x126
; 0000 024B                               flag=0;
; 0000 024C                               smsFlag=0;
; 0000 024D                             }
; 0000 024E                             else
_0xC7:
; 0000 024F                             {
; 0000 0250                               if(strcmp(syntax,"doimk")==0)
	RCALL SUBOPT_0x39
	__POINTW2MN _0xA6,53
	RCALL SUBOPT_0xD
	BRNE _0xCE
; 0000 0251                                 {
; 0000 0252                                   for(i=0;i<4;i++)
	LDI  R17,LOW(0)
_0xD0:
	CPI  R17,4
	BRSH _0xD1
; 0000 0253                                   {
; 0000 0254                                     if(msgStr[poskey+i]<48 || msgStr[poskey+i]>57) password[i]='0';
	MOV  R26,R16
	CLR  R27
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x19
	BRLO _0xD3
	RCALL SUBOPT_0x1A
	BRLO _0xD2
_0xD3:
	RCALL SUBOPT_0x29
	SUBI R26,LOW(-_password)
	SBCI R27,HIGH(-_password)
	LDI  R30,LOW(48)
	RJMP _0x127
; 0000 0255                                     else password[i]=msgStr[poskey+i];
_0xD2:
	RCALL SUBOPT_0x6
	SUBI R30,LOW(-_password)
	SBCI R31,HIGH(-_password)
	MOVW R0,R30
	MOV  R26,R16
	CLR  R27
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x7
	LD   R30,Z
	MOVW R26,R0
_0x127:
	RCALL __EEPROMWRB
; 0000 0256                                   }
	SUBI R17,-1
	RJMP _0xD0
_0xD1:
; 0000 0257                                   //sendSMS(phoneNumber,"Doi mat khau thanh cong");
; 0000 0258                                   //printf("success:");
; 0000 0259                                   sendSMS(phoneNumber,"Doi mat khau thanh cong");
	RCALL SUBOPT_0xB
	__POINTW2MN _0xA6,59
	RJMP _0x128
; 0000 025A                                   clearBuffer();
; 0000 025B                                   flag=0;
; 0000 025C                                   smsFlag=0;
; 0000 025D 
; 0000 025E                                 }
; 0000 025F                                 else
_0xCE:
; 0000 0260                                 {
; 0000 0261                                   if(strcmp(syntax,"sdt1")==0)
	RCALL SUBOPT_0x39
	__POINTW2MN _0xA6,83
	RCALL SUBOPT_0xD
	BRNE _0xD7
; 0000 0262                                   {
; 0000 0263                                     for(i=0;i<11;i++)
	LDI  R17,LOW(0)
_0xD9:
	CPI  R17,11
	BRSH _0xDA
; 0000 0264                                     {
; 0000 0265                                       if(msgStr[10+i]<48||msgStr[10+i]>57) sdt1[i]=0;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x19
	BRLO _0xDC
	RCALL SUBOPT_0x1A
	BRLO _0xDB
_0xDC:
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(0)
	RJMP _0x129
; 0000 0266                                       else sdt1[i]=msgStr[10+i];
_0xDB:
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3A
	LD   R30,Z
_0x129:
	RCALL __EEPROMWRB
; 0000 0267                                     }
	SUBI R17,-1
	RJMP _0xD9
_0xDA:
; 0000 0268                                     //puts(msgStr);
; 0000 0269                                     //printf("\n");
; 0000 026A                                     //puts(phoneNumber);
; 0000 026B 
; 0000 026C                                     sendSMS(phoneNumber,"Da them sdt1");
	RCALL SUBOPT_0xB
	__POINTW2MN _0xA6,88
	RJMP _0x128
; 0000 026D                                     clearBuffer();
; 0000 026E                                     flag=0;
; 0000 026F                                     smsFlag=0;
; 0000 0270                                   }
; 0000 0271                                   else
_0xD7:
; 0000 0272                                   {
; 0000 0273                                      if(strcmp(syntax,"sdt2")==0)
	RCALL SUBOPT_0x39
	__POINTW2MN _0xA6,101
	RCALL SUBOPT_0xD
	BRNE _0xE0
; 0000 0274                                       {
; 0000 0275                                         for(i=0;i<11;i++)
	LDI  R17,LOW(0)
_0xE2:
	CPI  R17,11
	BRSH _0xE3
; 0000 0276                                         {
; 0000 0277                                           if(msgStr[10+i]<48||msgStr[10+i]>57) sdt2[i]=0;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x19
	BRLO _0xE5
	RCALL SUBOPT_0x1A
	BRLO _0xE4
_0xE5:
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2C
	LDI  R30,LOW(0)
	RJMP _0x12A
; 0000 0278                                           else sdt2[i]=msgStr[10+i];
_0xE4:
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3A
	LD   R30,Z
_0x12A:
	RCALL __EEPROMWRB
; 0000 0279                                         }
	SUBI R17,-1
	RJMP _0xE2
_0xE3:
; 0000 027A //                                        printf("\nsdt2:");
; 0000 027B //                                        puts(ndt2);
; 0000 027C                                         sendSMS(phoneNumber,"Da them sdt2");
	RCALL SUBOPT_0xB
	__POINTW2MN _0xA6,106
	RJMP _0x128
; 0000 027D                                         clearBuffer();
; 0000 027E                                         flag=0;
; 0000 027F                                         smsFlag=0;
; 0000 0280                                       }
; 0000 0281                                       else
_0xE0:
; 0000 0282                                       {
; 0000 0283                                          if(strcmp(syntax,"sdt3")==0)
	RCALL SUBOPT_0x39
	__POINTW2MN _0xA6,119
	RCALL SUBOPT_0xD
	BRNE _0xE9
; 0000 0284                                           {
; 0000 0285                                             for(i=0;i<11;i++)
	LDI  R17,LOW(0)
_0xEB:
	CPI  R17,11
	BRSH _0xEC
; 0000 0286                                             {
; 0000 0287                                               if(msgStr[10+i]<48||msgStr[10+i]>57) sdt3[i]=0;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x19
	BRLO _0xEE
	RCALL SUBOPT_0x1A
	BRLO _0xED
_0xEE:
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2D
	LDI  R30,LOW(0)
	RJMP _0x12B
; 0000 0288                                               else sdt3[i]=msgStr[10+i];
_0xED:
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3A
	LD   R30,Z
_0x12B:
	RCALL __EEPROMWRB
; 0000 0289                                             }
	SUBI R17,-1
	RJMP _0xEB
_0xEC:
; 0000 028A                                             //printf("sdt3:");
; 0000 028B                                             //puts(ndt3);
; 0000 028C                                             sendSMS(phoneNumber,"Da them sdt3");
	RCALL SUBOPT_0xB
	__POINTW2MN _0xA6,124
	RJMP _0x128
; 0000 028D                                             clearBuffer();
; 0000 028E                                             flag=0;
; 0000 028F                                             smsFlag=0;
; 0000 0290                                           }
; 0000 0291                                           else
_0xE9:
; 0000 0292                                           {
; 0000 0293                                                if(strcmp(content,"kttk")==0)
	RCALL SUBOPT_0x36
	__POINTW2MN _0xA6,137
	RCALL SUBOPT_0xD
	BRNE _0xF2
; 0000 0294                                                {
; 0000 0295                                                  KTTK();
	RCALL _KTTK
; 0000 0296                                                  clearBuffer();
	RCALL _clearBuffer
; 0000 0297                                                  smsFlag=0;
	RJMP _0x12C
; 0000 0298                                                }
; 0000 0299                                                else
_0xF2:
; 0000 029A                                                {
; 0000 029B                                                  if(strcmp(syntax,"naptien")==0)
	RCALL SUBOPT_0x39
	__POINTW2MN _0xA6,142
	RCALL SUBOPT_0xD
	BRNE _0xF4
; 0000 029C                                                  {  char mathe[13];
; 0000 029D                                                     //unsigned char mt;
; 0000 029E                                                     for(i=0;i<13;i++)
	SBIW R28,13
;	n -> Y+19
;	mathe -> Y+0
	LDI  R17,LOW(0)
_0xF6:
	CPI  R17,13
	BRSH _0xF7
; 0000 029F                                                     {
; 0000 02A0                                                       if(msgStr[13+i]<48||msgStr[13+i]>57) mathe[i]='0';
	RCALL SUBOPT_0x6
	__ADDW1MN _msgStr,13
	RCALL SUBOPT_0x19
	BRLO _0xF9
	RCALL SUBOPT_0x1A
	BRLO _0xF8
_0xF9:
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3B
	LDI  R30,LOW(48)
	RJMP _0x12D
; 0000 02A1                                                       else mathe[i]=msgStr[13+i];
_0xF8:
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x6
	__ADDW1MN _msgStr,13
	LD   R30,Z
_0x12D:
	ST   X,R30
; 0000 02A2                                                     }
	SUBI R17,-1
	RJMP _0xF6
_0xF7:
; 0000 02A3                                                     naptien(mathe);
	MOVW R26,R28
	RCALL _naptien
; 0000 02A4                                                     clearBuffer();
	RCALL SUBOPT_0x25
; 0000 02A5                                                     flag=0;
; 0000 02A6                                                     smsFlag=0;
; 0000 02A7                                                  }
	ADIW R28,13
; 0000 02A8                                                  else
	RJMP _0xFC
_0xF4:
; 0000 02A9                                                  {
; 0000 02AA                                                    if(strcmp(content,"thongbao on")==0)
	RCALL SUBOPT_0x36
	__POINTW2MN _0xA6,150
	RCALL SUBOPT_0xD
	BRNE _0xFD
; 0000 02AB                                                    {
; 0000 02AC                                                      tb=2;
	LDI  R26,LOW(_tb)
	LDI  R27,HIGH(_tb)
	LDI  R30,LOW(2)
	RCALL __EEPROMWRB
; 0000 02AD                                                      //printf("da bat thong bao");
; 0000 02AE                                                      sendSMS(phoneNumber,"Bat thong bao");
	RCALL SUBOPT_0xB
	__POINTW2MN _0xA6,162
	RCALL _sendSMS
; 0000 02AF                                                      clearBuffer();
	RCALL _clearBuffer
; 0000 02B0                                                      smsFlag=0;
	RJMP _0x12C
; 0000 02B1                                                    }
; 0000 02B2                                                    else
_0xFD:
; 0000 02B3                                                    {
; 0000 02B4                                                      if(strcmp(content,"thongbao off")==0)
	RCALL SUBOPT_0x36
	__POINTW2MN _0xA6,176
	RCALL SUBOPT_0xD
	BRNE _0xFF
; 0000 02B5                                                        {
; 0000 02B6                                                          tb=1;
	LDI  R26,LOW(_tb)
	LDI  R27,HIGH(_tb)
	RCALL SUBOPT_0x37
; 0000 02B7                                                          //printf("da tat thong bao");
; 0000 02B8                                                          sendSMS(phoneNumber,"Tat thong bao");
	RCALL SUBOPT_0xB
	__POINTW2MN _0xA6,189
	RJMP _0x128
; 0000 02B9                                                          clearBuffer();
; 0000 02BA                                                          flag=0;
; 0000 02BB                                                          smsFlag=0;
; 0000 02BC                                                        }
; 0000 02BD                                                        else
_0xFF:
; 0000 02BE                                                        {
; 0000 02BF                                                          if(strcmp(content,"kttt")==0)
	RCALL SUBOPT_0x36
	__POINTW2MN _0xA6,203
	RCALL SUBOPT_0xD
	BRNE _0x101
; 0000 02C0                                                          {
; 0000 02C1                                                            sendSTT();
	RCALL _sendSTT
; 0000 02C2                                                            clearBuffer();
	RJMP _0x126
; 0000 02C3                                                            flag=0;
; 0000 02C4                                                            smsFlag=0;
; 0000 02C5                                                          }
; 0000 02C6                                                          else
_0x101:
; 0000 02C7                                                          {
; 0000 02C8                                                            //printf("Syntax error");
; 0000 02C9                                                            sendSMS(phoneNumber,"Loi cu phap");
	RCALL SUBOPT_0xB
	__POINTW2MN _0xA6,208
_0x128:
	RCALL _sendSMS
; 0000 02CA                                                            clearBuffer();
_0x126:
	RCALL _clearBuffer
; 0000 02CB                                                            flag=0;
	CLR  R4
; 0000 02CC                                                            smsFlag=0;
_0x12C:
	CLT
	BLD  R2,1
; 0000 02CD                                                          }
; 0000 02CE                                                        }
; 0000 02CF                                                    }
; 0000 02D0 
; 0000 02D1                                                  }
_0xFC:
; 0000 02D2 
; 0000 02D3                                                }
; 0000 02D4                                           }
; 0000 02D5                                       }
; 0000 02D6                                   }
; 0000 02D7                                 }
; 0000 02D8                             }
; 0000 02D9                         }
; 0000 02DA                     }
; 0000 02DB                 }
; 0000 02DC             }
; 0000 02DD         }
; 0000 02DE     }
; 0000 02DF }
_0xAB:
	RCALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND

	.DSEG
_0xA6:
	.BYTE 0xDC
;
;
;void main(void)
; 0000 02E3 {

	.CSEG
_main:
; .FSTART _main
; 0000 02E4 // Declare your local variables here
; 0000 02E5 
; 0000 02E6 // Input/Output Ports initialization
; 0000 02E7 // Port B initialization
; 0000 02E8 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02E9 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 02EA // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02EB PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 02EC 
; 0000 02ED // Port C initialization
; 0000 02EE // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out
; 0000 02EF DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(3)
	OUT  0x14,R30
; 0000 02F0 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0
; 0000 02F1 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 02F2 
; 0000 02F3 // Port D initialization
; 0000 02F4 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=In
; 0000 02F5 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 02F6 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=0 Bit0=T
; 0000 02F7 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 02F8 
; 0000 02F9 // Timer/Counter 0 initialization
; 0000 02FA // Clock source: System Clock
; 0000 02FB // Clock value: 0.977 kHz
; 0000 02FC //0.26214s
; 0000 02FD TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 02FE TCNT0=0x00;
	OUT  0x32,R30
; 0000 02FF 
; 0000 0300 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0301 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0302 
; 0000 0303 // External Interrupt(s) initialization
; 0000 0304 // INT0: On
; 0000 0305 // INT0 Mode: Falling Edge
; 0000 0306 // INT1: On
; 0000 0307 // INT1 Mode: Falling Edge
; 0000 0308 GICR|=(1<<INT1) | (1<<INT0);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 0309 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 030A GIFR=(1<<INTF1) | (1<<INTF0);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 030B 
; 0000 030C // USART initialization
; 0000 030D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 030E // USART Receiver: On
; 0000 030F // USART Transmitter: On
; 0000 0310 // USART Mode: Asynchronous
; 0000 0311 // USART Baud Rate: 9600 (Double Speed Mode)
; 0000 0312 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (1<<U2X) | (1<<MPCM);
	LDI  R30,LOW(3)
	OUT  0xB,R30
; 0000 0313 UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0314 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0315 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0316 UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 0317 
; 0000 0318 
; 0000 0319 // Global enable interrupts
; 0000 031A #asm("sei")
	sei
; 0000 031B while(strpos(rx_buffer,'O')<0||strpos(rx_buffer,'K')<0)
_0x103:
	RCALL SUBOPT_0xE
	LDI  R26,LOW(79)
	RCALL SUBOPT_0x3C
	BRMI _0x106
	RCALL SUBOPT_0xE
	LDI  R26,LOW(75)
	RCALL SUBOPT_0x3C
	BRPL _0x105
_0x106:
; 0000 031C {
; 0000 031D     printf("AT\r\n");
	__POINTW1FN _0x0,317
	RCALL SUBOPT_0x24
; 0000 031E     printf(DISABLE_ECHO);
	__POINTW1FN _0x0,322
	RCALL SUBOPT_0x24
; 0000 031F     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0320     if(strpos(rx_buffer,'O')<0||strpos(rx_buffer,'K')<0) clearBuffer();
	RCALL SUBOPT_0xE
	LDI  R26,LOW(79)
	RCALL SUBOPT_0x3C
	BRMI _0x109
	RCALL SUBOPT_0xE
	LDI  R26,LOW(75)
	RCALL SUBOPT_0x3C
	BRPL _0x108
_0x109:
	RCALL _clearBuffer
; 0000 0321 }
_0x108:
	RJMP _0x103
_0x105:
; 0000 0322 printf(FORMAT_SMS_TEXT);
	__POINTW1FN _0x0,329
	RCALL SUBOPT_0x24
; 0000 0323 delay_ms(200);
	RCALL SUBOPT_0x3D
; 0000 0324 printf(DISABLE_ECHO);
	__POINTW1FN _0x0,322
	RCALL SUBOPT_0x24
; 0000 0325 delay_ms(200);
	RCALL SUBOPT_0x3D
; 0000 0326 printf(READ_WHEN_NEWSMS);
	__POINTW1FN _0x0,341
	RCALL SUBOPT_0x24
; 0000 0327 delay_ms(200);
	RCALL SUBOPT_0x3D
; 0000 0328 printf(ENABLE_USSD);
	__POINTW1FN _0x0,361
	RCALL SUBOPT_0x24
; 0000 0329 delay_ms(200);
	RCALL SUBOPT_0x3D
; 0000 032A printf(DELETE_ALL_MSG);
	__POINTW1FN _0x0,373
	RCALL SUBOPT_0x24
; 0000 032B delay_ms(200);
	RCALL SUBOPT_0x3D
; 0000 032C if(begin==255)
	LDI  R26,LOW(_begin)
	LDI  R27,HIGH(_begin)
	RCALL SUBOPT_0x2B
	BRNE _0x10B
; 0000 032D {
; 0000 032E 
; 0000 032F   password[0]='0';
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	RCALL SUBOPT_0x35
; 0000 0330   password[1]='0';
	__POINTW2MN _password,1
	RCALL SUBOPT_0x35
; 0000 0331   password[2]='0';
	__POINTW2MN _password,2
	RCALL SUBOPT_0x35
; 0000 0332   password[3]='0';
	__POINTW2MN _password,3
	RCALL SUBOPT_0x35
; 0000 0333   begin=0;
	LDI  R26,LOW(_begin)
	LDI  R27,HIGH(_begin)
	RCALL SUBOPT_0x38
; 0000 0334 }
; 0000 0335 if(save1==1) LOAD1=1;
_0x10B:
	RCALL SUBOPT_0x30
	BRNE _0x10C
	SBI  0x15,0
; 0000 0336 else LOAD1=0;
	RJMP _0x10F
_0x10C:
	CBI  0x15,0
; 0000 0337 if(save2==1) LOAD2=1;
_0x10F:
	RCALL SUBOPT_0x31
	BRNE _0x112
	SBI  0x15,1
; 0000 0338 else LOAD2=0;
	RJMP _0x115
_0x112:
	CBI  0x15,1
; 0000 0339 clearBuffer();
_0x115:
	RCALL _clearBuffer
; 0000 033A while (1)
_0x118:
; 0000 033B       {     if(flag) strHandle();
	TST  R4
	BREQ _0x11B
	RCALL _strHandle
; 0000 033C       }
_0x11B:
	RJMP _0x118
; 0000 033D }
_0x11C:
	RJMP _0x11C
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_puts:
; .FSTART _puts
	RCALL SUBOPT_0x3E
	ST   -Y,R17
_0x2000003:
	RCALL SUBOPT_0x3F
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000005
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2000003
_0x2000005:
	LDI  R26,LOW(10)
	RCALL _putchar
	RJMP _0x2080002
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	RCALL SUBOPT_0x3E
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x2080001
; .FEND
__print_G100:
; .FSTART __print_G100
	RCALL SUBOPT_0x3E
	SBIW R28,4
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RCALL SUBOPT_0x40
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R19,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x41
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R19,37
	BRNE _0x2000020
	RCALL SUBOPT_0x41
	RJMP _0x20000AD
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R18,LOW(0)
	LDI  R16,LOW(0)
	CPI  R19,43
	BRNE _0x2000021
	LDI  R18,LOW(43)
	RJMP _0x200001B
_0x2000021:
	CPI  R19,32
	BRNE _0x2000022
	LDI  R18,LOW(32)
	RJMP _0x200001B
_0x2000022:
	RJMP _0x2000023
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000024
_0x2000023:
	CPI  R19,48
	BRNE _0x2000025
	ORI  R16,LOW(16)
	LDI  R17,LOW(5)
	RJMP _0x200001B
_0x2000025:
	RJMP _0x2000026
_0x2000024:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x200001B
_0x2000026:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x200002B
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x42
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x44
	RJMP _0x200002C
_0x200002B:
	CPI  R30,LOW(0x73)
	BRNE _0x200002E
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x46
_0x200002F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2000031
	RCALL SUBOPT_0x41
	RJMP _0x200002F
_0x2000031:
	RJMP _0x200002C
_0x200002E:
	CPI  R30,LOW(0x70)
	BRNE _0x2000033
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x46
_0x2000034:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RCALL SUBOPT_0x40
	BREQ _0x2000036
	RCALL SUBOPT_0x41
	RJMP _0x2000034
_0x2000036:
	RJMP _0x200002C
_0x2000033:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(1)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RJMP _0x20000AE
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(2)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000052
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
_0x20000AE:
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBRS R16,0
	RJMP _0x2000042
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x47
	TST  R21
	BRPL _0x2000043
	MOVW R30,R20
	RCALL __ANEGW1
	MOVW R20,R30
	LDI  R18,LOW(45)
_0x2000043:
	CPI  R18,0
	BREQ _0x2000044
	ST   -Y,R18
	RCALL SUBOPT_0x44
_0x2000044:
	RJMP _0x2000045
_0x2000042:
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x47
_0x2000045:
_0x2000047:
	LDI  R19,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000049:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R20,R30
	CPC  R21,R31
	BRLO _0x200004B
	SUBI R19,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	__SUBWRR 20,21,26,27
	RJMP _0x2000049
_0x200004B:
	SBRC R16,4
	RJMP _0x200004D
	CPI  R19,49
	BRSH _0x200004D
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x200004C
_0x200004D:
	ORI  R16,LOW(16)
	CPI  R19,58
	BRLO _0x200004F
	SBRS R16,1
	RJMP _0x2000050
	SUBI R19,-LOW(7)
	RJMP _0x2000051
_0x2000050:
	SUBI R19,-LOW(39)
_0x2000051:
_0x200004F:
	RCALL SUBOPT_0x41
_0x200004C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRSH _0x2000047
_0x2000052:
_0x200002C:
_0x20000AD:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x20
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	RCALL SUBOPT_0x20
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_sendSMS:
; .FSTART _sendSMS
	RCALL SUBOPT_0x3E
	ST   -Y,R17
	__POINTW1FN _0x2020000,0
	RCALL SUBOPT_0x24
	LDI  R26,LOW(34)
	RCALL _putchar
	LDI  R17,LOW(0)
_0x2020004:
	CPI  R17,11
	BRSH _0x2020005
	RCALL SUBOPT_0x48
	CPI  R26,LOW(0x2F)
	BRLO _0x2020007
	RCALL SUBOPT_0x48
	CPI  R26,LOW(0x3A)
	BRLO _0x2020008
_0x2020007:
	RJMP _0x2020006
_0x2020008:
	RCALL SUBOPT_0x48
	RCALL _putchar
_0x2020006:
	SUBI R17,-1
	RJMP _0x2020004
_0x2020005:
	LDI  R26,LOW(34)
	RCALL _putchar
	__POINTW1FN _0x2020000,9
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x3F
	RCALL _puts
	LDI  R26,LOW(10)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(26)
	RCALL _putchar
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
_KTTK:
; .FSTART _KTTK
	__POINTW1FN _0x2020000,11
	RCALL SUBOPT_0x24
	__POINTW1FN _0x2020000,23
	RCALL SUBOPT_0x24
	RET
; .FEND
_naptien:
; .FSTART _naptien
	RCALL SUBOPT_0x3E
	ST   -Y,R17
	__POINTW1FN _0x2020000,11
	RCALL SUBOPT_0x24
	__POINTW1FN _0x2020000,35
	RCALL SUBOPT_0x24
	LDI  R17,LOW(0)
_0x202000A:
	CPI  R17,13
	BRSH _0x202000B
	RCALL SUBOPT_0x49
	CPI  R26,LOW(0x2F)
	BRLO _0x202000D
	RCALL SUBOPT_0x49
	CPI  R26,LOW(0x3A)
	BRLO _0x202000E
_0x202000D:
	RJMP _0x202000C
_0x202000E:
	RCALL SUBOPT_0x49
	RCALL _putchar
_0x202000C:
	SUBI R17,-1
	RJMP _0x202000A
_0x202000B:
	__POINTW1FN _0x2020000,30
	RCALL SUBOPT_0x24
_0x2080002:
	LDD  R17,Y+0
_0x2080001:
	ADIW R28,3
	RET
; .FEND

	.CSEG
_strcmp:
; .FSTART _strcmp
	RCALL SUBOPT_0x3E
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strpos:
; .FSTART _strpos
	ST   -Y,R26
    ld   r22,y+
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strpos0:
    ld   r23,x+
    cp   r22,r23
    breq strpos1
    adiw r30,1
    tst  r23
    brne strpos0
    ldi  r30,0xff
    ldi  r31,0xff
strpos1:
    ret
; .FEND
_strrpos:
; .FSTART _strrpos
	ST   -Y,R26
    ld   r22,y+
    ld   r26,y+
    ld   r27,y+
    ldi  r30,0xff
    ldi  r31,0xff
    clr  r24
    clr  r25
strrpos0:
    ld   r23,x+
    cp   r22,r23
    brne strrpos1
    movw r30,r24
strrpos1:
    adiw r24,1
    tst  r23
    brne strrpos0
    ret
; .FEND

	.CSEG

	.DSEG
_content:
	.BYTE 0xF
_syntax:
	.BYTE 0xF
_type:
	.BYTE 0x4
_phoneNumber:
	.BYTE 0xB
_msgStr:
	.BYTE 0x64

	.ESEG
_sdt1:
	.BYTE 0xB
_sdt2:
	.BYTE 0xB
_sdt3:
	.BYTE 0xB
_lastNumber:
	.BYTE 0xB
_save1:
	.BYTE 0x1
_save2:
	.BYTE 0x1
_begin:
	.BYTE 0x1
_tb:
	.BYTE 0x1
_password:
	.BYTE 0x4

	.DSEG
_rx_buffer:
	.BYTE 0x6E
_tx_buffer:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_save1)
	LDI  R27,HIGH(_save1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_save2)
	LDI  R27,HIGH(_save2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x6:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	SUBI R30,LOW(-_msgStr)
	SBCI R31,HIGH(-_msgStr)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	SUBI R30,LOW(-_phoneNumber)
	SBCI R31,HIGH(-_phoneNumber)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(_phoneNumber)
	LDI  R31,HIGH(_phoneNumber)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(_type)
	LDI  R31,HIGH(_type)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0xD:
	RCALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	ADIW R30,1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x10:
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x5
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(50)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(34)
	RJMP _strpos

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(_lastNumber)
	LDI  R27,HIGH(_lastNumber)
	RCALL __EEPROMRDB
	MOV  R26,R30
	LDS  R30,_phoneNumber
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	__POINTW2MN _lastNumber,2
	RCALL __EEPROMRDB
	MOV  R26,R30
	__GETB1MN _phoneNumber,2
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	__POINTW2MN _lastNumber,4
	RCALL __EEPROMRDB
	MOV  R26,R30
	__GETB1MN _phoneNumber,4
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	__POINTW2MN _lastNumber,6
	RCALL __EEPROMRDB
	MOV  R26,R30
	__GETB1MN _phoneNumber,6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	LD   R26,Z
	CPI  R26,LOW(0x30)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A:
	LD   R26,Z
	CPI  R26,LOW(0x3A)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_lastNumber)
	SBCI R27,HIGH(-_lastNumber)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	MOV  R26,R16
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	MOV  R26,R19
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1F:
	MOV  R30,R19
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 46 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x20:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x21:
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	SUBI R26,LOW(-_lastNumber)
	SBCI R27,HIGH(-_lastNumber)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(_msgStr)
	LDI  R31,HIGH(_msgStr)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x24:
	RCALL SUBOPT_0x20
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	RCALL _clearBuffer
	CLR  R4
	CLT
	BLD  R2,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x26:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	RCALL __EEPROMRDB
	MOVW R26,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x29:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	SUBI R26,LOW(-_sdt1)
	SBCI R27,HIGH(-_sdt1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	RCALL __EEPROMRDB
	CPI  R30,LOW(0xFF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	SUBI R26,LOW(-_sdt2)
	SBCI R27,HIGH(-_sdt2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	SUBI R26,LOW(-_sdt3)
	SBCI R27,HIGH(-_sdt3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	__POINTW1FN _0x0,91
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	CLT
	BLD  R2,0
	CLR  R6
	CLR  R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	CBI  0x15,1
	RCALL SUBOPT_0x2
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x33:
	LDI  R26,LOW(_tb)
	LDI  R27,HIGH(_tb)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	SBI  0x15,1
	RCALL SUBOPT_0x2
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(48)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(_content)
	LDI  R31,HIGH(_content)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(_syntax)
	LDI  R31,HIGH(_syntax)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	__ADDW1MN _msgStr,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	MOVW R26,R28
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	RCALL _strpos
	TST  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	LDI  R26,LOW(200)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x41:
	ST   -Y,R19
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x43:
	SBIW R30,4
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x44:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	RCALL SUBOPT_0x42
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x47:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R20,X+
	LD   R21,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x48:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x49:
	RCALL SUBOPT_0x3F
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
