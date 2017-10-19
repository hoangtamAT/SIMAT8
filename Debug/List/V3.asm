
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
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
	.DEF _rxStatus=R7
	.DEF _checkpass=R6
	.DEF _result=R9
	.DEF _rx_wr_index=R8
	.DEF _rx_rd_index=R11
	.DEF _rx_counter=R10
	.DEF _tx_wr_index=R13
	.DEF _tx_rd_index=R12

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
	.DB  0x43,0x4C,0x49,0x50,0x0,0x43,0x4D,0x54
	.DB  0x3A,0x0,0x63,0x61,0x6E,0x32,0x0,0x65
	.DB  0x72,0x72,0x6F,0x72,0x20,0x70,0x61,0x73
	.DB  0x73,0x77,0x6F,0x72,0x64,0x0,0x41,0x54
	.DB  0x48,0xD,0xA,0x0,0x6F,0x6E,0x31,0x0
	.DB  0x6F,0x6E,0x32,0x0,0x6F,0x66,0x66,0x31
	.DB  0x0,0x6F,0x66,0x66,0x32,0x0,0x6F,0x6E
	.DB  0x0,0x6F,0x66,0x66,0x0,0x64,0x6F,0x69
	.DB  0x6D,0x6B,0x0,0x73,0x75,0x63,0x63,0x65
	.DB  0x73,0x73,0x3A,0x0,0x74,0x68,0x65,0x6D
	.DB  0x31,0x0,0x73,0x64,0x74,0x31,0x3A,0x0
	.DB  0x74,0x68,0x65,0x6D,0x32,0x0,0xA,0x73
	.DB  0x64,0x74,0x32,0x3A,0x0,0x74,0x68,0x65
	.DB  0x6D,0x33,0x0,0x73,0x64,0x74,0x33,0x3A
	.DB  0x0,0x72,0x65,0x73,0x65,0x74,0x0,0x70
	.DB  0x61,0x73,0x73,0x77,0x6F,0x72,0x64,0x3A
	.DB  0x0,0x73,0x79,0x6E,0x74,0x61,0x78,0x20
	.DB  0x65,0x72,0x72,0x6F,0x72,0x0,0x70,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x20,0x65
	.DB  0x72,0x72,0x6F,0x72,0x0,0x41,0x54,0xD
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
	.DB  0x41,0x54,0x44,0x0,0x3B,0xD,0x0,0x41
	.DB  0x54,0x2B,0x43,0x4D,0x47,0x53,0x3D,0x0
	.DB  0x41,0x54,0x2B,0x43,0x55,0x53,0x44,0x3D
	.DB  0x31,0xD,0xA,0x0,0x41,0x54,0x44,0x2A
	.DB  0x31,0x30,0x31,0x23,0x3B,0xD,0xA,0x0
	.DB  0x41,0x54,0x44,0x2A,0x31,0x30,0x30,0x2A
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x09
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x05
	.DW  _0x26
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x26+5
	.DW  _0x0*2+5

	.DW  0x04
	.DW  _0x69
	.DW  _0x0*2+36

	.DW  0x04
	.DW  _0x69+4
	.DW  _0x0*2+40

	.DW  0x05
	.DW  _0x69+8
	.DW  _0x0*2+44

	.DW  0x05
	.DW  _0x69+13
	.DW  _0x0*2+49

	.DW  0x03
	.DW  _0x69+18
	.DW  _0x0*2+54

	.DW  0x04
	.DW  _0x69+21
	.DW  _0x0*2+57

	.DW  0x06
	.DW  _0x69+25
	.DW  _0x0*2+61

	.DW  0x06
	.DW  _0x69+31
	.DW  _0x0*2+76

	.DW  0x06
	.DW  _0x69+37
	.DW  _0x0*2+88

	.DW  0x06
	.DW  _0x69+43
	.DW  _0x0*2+101

	.DW  0x06
	.DW  _0x69+49
	.DW  _0x0*2+113

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
;
;#define LOAD1   PORTC.0
;#define LOAD2   PORTC.1
;#define strCall     1
;#define strSms      2
;char type[10];
;char content[5];
;char qtyNum=10;
;char phoneNumber[11];
;char phoneNumberSms[11];
;char msgStr[160];
;eeprom char sdt1[11];
;eeprom char sdt2[11];
;eeprom char sdt3[11];
;
;eeprom char save1,save2,begin;
;eeprom char password[4];
;
;char flag,rxStatus,checkpass,result;
;bit callFlag=0,smsFlag=0;
;// Declare your global variables here
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0037 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0x0
; 0000 0038  LOAD1=~LOAD1;
	SBIS 0x15,0
	RJMP _0x3
	CBI  0x15,0
	RJMP _0x4
_0x3:
	SBI  0x15,0
_0x4:
; 0000 0039  save1=~save1;
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDB
	COM  R30
	RCALL SUBOPT_0x1
	RJMP _0xD7
; 0000 003A  delay_ms(20);
; 0000 003B 
; 0000 003C }
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0040 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x0
; 0000 0041 LOAD2=~LOAD2;
	SBIS 0x15,1
	RJMP _0x5
	CBI  0x15,1
	RJMP _0x6
_0x5:
	SBI  0x15,1
_0x6:
; 0000 0042 save2=~save2;
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDB
	COM  R30
	RCALL SUBOPT_0x2
_0xD7:
	RCALL __EEPROMWRB
; 0000 0043     delay_ms(20);
	RCALL SUBOPT_0x3
; 0000 0044 
; 0000 0045 }
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
;#define RX_BUFFER_SIZE 250
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
; 0000 0062 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	RCALL SUBOPT_0x4
; 0000 0063 char status,data;
; 0000 0064 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0065 data=UDR;
	IN   R16,12
; 0000 0066 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x7
; 0000 0067    {
; 0000 0068    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R8
	INC  R8
	LDI  R31,0
	RCALL SUBOPT_0x5
	ST   Z,R16
; 0000 0069    flag=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 006A #if RX_BUFFER_SIZE == 256
; 0000 006B    // special case for receiver buffer size=256
; 0000 006C    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 006D #else
; 0000 006E    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(250)
	CP   R30,R8
	BRNE _0x8
	CLR  R8
; 0000 006F    if (++rx_counter == RX_BUFFER_SIZE)
_0x8:
	INC  R10
	LDI  R30,LOW(250)
	CP   R30,R10
	BRNE _0x9
; 0000 0070       {
; 0000 0071       rx_counter=0;
	CLR  R10
; 0000 0072       rx_buffer_overflow=1;
	SET
	BLD  R2,2
; 0000 0073       }
; 0000 0074 #endif
; 0000 0075    }
_0x9:
; 0000 0076 }
_0x7:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0xD6
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 007D {
; 0000 007E char data;
; 0000 007F while (rx_counter==0);
;	data -> R17
; 0000 0080 data=rx_buffer[rx_rd_index++];
; 0000 0081 #if RX_BUFFER_SIZE != 256
; 0000 0082 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0083 #endif
; 0000 0084 #asm("cli")
; 0000 0085 --rx_counter;
; 0000 0086 #asm("sei")
; 0000 0087 return data;
; 0000 0088 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 150
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
; 0000 009E {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	RCALL SUBOPT_0x4
; 0000 009F if (tx_counter)
	RCALL SUBOPT_0x6
	CPI  R30,0
	BREQ _0xE
; 0000 00A0    {
; 0000 00A1    --tx_counter;
	RCALL SUBOPT_0x6
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 00A2    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00A3 #if TX_BUFFER_SIZE != 256
; 0000 00A4    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(150)
	CP   R30,R12
	BRNE _0xF
	CLR  R12
; 0000 00A5 #endif
; 0000 00A6    }
_0xF:
; 0000 00A7 }
_0xE:
_0xD6:
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
; 0000 00AE {
_putchar:
; .FSTART _putchar
; 0000 00AF while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0x10:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x96)
	BREQ _0x10
; 0000 00B0 #asm("cli")
	cli
; 0000 00B1 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	RCALL SUBOPT_0x6
	CPI  R30,0
	BRNE _0x14
	SBIC 0xB,5
	RJMP _0x13
_0x14:
; 0000 00B2    {
; 0000 00B3    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00B4 #if TX_BUFFER_SIZE != 256
; 0000 00B5    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(150)
	CP   R30,R13
	BRNE _0x16
	CLR  R13
; 0000 00B6 #endif
; 0000 00B7    ++tx_counter;
_0x16:
	RCALL SUBOPT_0x6
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0000 00B8    }
; 0000 00B9 else
	RJMP _0x17
_0x13:
; 0000 00BA    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00BB #asm("sei")
_0x17:
	sei
; 0000 00BC }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;
;void clearBuffer()
; 0000 00C1 {   char i;
_clearBuffer:
; .FSTART _clearBuffer
; 0000 00C2 
; 0000 00C3     for(i=0;i<rx_wr_index;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x19:
	CP   R17,R8
	BRSH _0x1A
; 0000 00C4     {
; 0000 00C5         rx_buffer[i]=msgStr[i]=phoneNumber[i]=phoneNumberSms[i]=content[i]=0;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	MOVW R24,R30
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_phoneNumber)
	SBCI R31,HIGH(-_phoneNumber)
	MOVW R22,R30
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_phoneNumberSms)
	SBCI R31,HIGH(-_phoneNumberSms)
	RCALL SUBOPT_0x9
	SUBI R26,LOW(-_content)
	SBCI R27,HIGH(-_content)
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	MOVW R26,R22
	ST   X,R30
	MOVW R26,R24
	ST   X,R30
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00C6     }
	SUBI R17,-1
	RJMP _0x19
_0x1A:
; 0000 00C7     rx_wr_index=0;
	CLR  R8
; 0000 00C8     flag=0;
	CLR  R4
; 0000 00C9 
; 0000 00CA 
; 0000 00CB }
	LD   R17,Y+
	RET
; .FEND
;/****************************************************************
;   content return from sim:
;   - call:  RING
;
;            +CLIP: "0964444373",161,"",0,"",0
;
;   -sms: +CMT: "+84964444373","","17/10/14,15:04:39+28"
;                #0000 on
;
;******************************************************************/
;void comparePhoneNumber();
;void callHandle();
;void smsHandle();
;void strHandle()
; 0000 00DA {
_strHandle:
; .FSTART _strHandle
; 0000 00DB     char i,k,l,pos,en=0;
; 0000 00DC     while(strpos(rx_buffer,'+')<0);
	RCALL __SAVELOCR6
;	i -> R17
;	k -> R16
;	l -> R19
;	pos -> R18
;	en -> R21
	LDI  R21,0
_0x1B:
	RCALL SUBOPT_0xC
	BRMI _0x1B
; 0000 00DD     if(strpos(rx_buffer,'+')>=0)
	RCALL SUBOPT_0xC
	BRPL PC+2
	RJMP _0x1E
; 0000 00DE     {
; 0000 00DF             for(i=0;i<4;i++)
	LDI  R17,LOW(0)
_0x20:
	CPI  R17,4
	BRSH _0x21
; 0000 00E0             {
; 0000 00E1                 type[i]=rx_buffer[strpos(rx_buffer,'+')+1+i];
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_type)
	SBCI R31,HIGH(-_type)
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xD
	LDI  R26,LOW(43)
	RCALL _strpos
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xF
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00E2                 en++;
	SUBI R21,-1
; 0000 00E3             }
	SUBI R17,-1
	RJMP _0x20
_0x21:
; 0000 00E4             while(en<4);
_0x22:
	CPI  R21,4
	BRLO _0x22
; 0000 00E5             delay_ms(20);
	RCALL SUBOPT_0x3
; 0000 00E6             if(strcmp(type,"CLIP")==0)  //call
	RCALL SUBOPT_0x10
	__POINTW2MN _0x26,0
	RCALL SUBOPT_0x11
	BRNE _0x25
; 0000 00E7             {
; 0000 00E8                 rxStatus=strCall;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 00E9                 pos=strpos(rx_buffer,34); // "  //
	RCALL SUBOPT_0xD
	LDI  R26,LOW(34)
	RCALL _strpos
	MOV  R18,R30
; 0000 00EA                 if(rx_buffer[pos+11]==34) qtyNum=10;
	RCALL SUBOPT_0x12
	__ADDW1MN _rx_buffer,11
	LD   R26,Z
	CPI  R26,LOW(0x22)
	BRNE _0x27
	LDI  R30,LOW(10)
	RJMP _0xCD
; 0000 00EB                 else qtyNum=11;
_0x27:
	LDI  R30,LOW(11)
_0xCD:
	MOV  R5,R30
; 0000 00EC                 for(k=0;k<qtyNum;k++)
	LDI  R16,LOW(0)
_0x2A:
	CP   R16,R5
	BRSH _0x2B
; 0000 00ED                 {
; 0000 00EE                    phoneNumber[k]=rx_buffer[pos+1+k];
	RCALL SUBOPT_0x13
	SUBI R30,LOW(-_phoneNumber)
	SBCI R31,HIGH(-_phoneNumber)
	MOVW R0,R30
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xB
; 0000 00EF                 }
	SUBI R16,-1
	RJMP _0x2A
_0x2B:
; 0000 00F0                 callFlag=1;
	SET
	BLD  R2,0
; 0000 00F1                 //puts(phoneNumber);
; 0000 00F2                 delay_ms(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0x14
; 0000 00F3                 //clearBuffer();
; 0000 00F4                 if(callFlag)callHandle();
	SBRC R2,0
	RCALL _callHandle
; 0000 00F5 
; 0000 00F6             }
; 0000 00F7             else  //sms
	RJMP _0x2D
_0x25:
; 0000 00F8             {
; 0000 00F9                if(strcmp(type,"CMT:")==0)
	RCALL SUBOPT_0x10
	__POINTW2MN _0x26,5
	RCALL SUBOPT_0x11
	BREQ PC+2
	RJMP _0x2E
; 0000 00FA                {    //"+84964444373", ":0 ,:14-15
; 0000 00FB 
; 0000 00FC                     pos=strpos(rx_buffer,'#');
	RCALL SUBOPT_0xD
	LDI  R26,LOW(35)
	RCALL _strpos
	MOV  R18,R30
; 0000 00FD                     rxStatus=strSms;
	LDI  R30,LOW(2)
	MOV  R7,R30
; 0000 00FE                     if(strpos(rx_buffer,'.')>pos&&pos>=0)
	RCALL SUBOPT_0xD
	LDI  R26,LOW(46)
	RCALL _strpos
	MOVW R26,R30
	RCALL SUBOPT_0x12
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x30
	CPI  R18,0
	BRSH _0x31
_0x30:
	RJMP _0x2F
_0x31:
; 0000 00FF                     {
; 0000 0100                         for(k=0;k<((strpos(rx_buffer,'.'))-pos);k++)
	LDI  R16,LOW(0)
_0x33:
	RCALL SUBOPT_0xD
	LDI  R26,LOW(46)
	RCALL _strpos
	MOVW R26,R30
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x15
	MOV  R26,R16
	RCALL SUBOPT_0x16
	BRGE _0x34
; 0000 0101                         {
; 0000 0102                             msgStr[k]=rx_buffer[pos+1+k];
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x8
	MOVW R0,R30
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xB
; 0000 0103                         }
	SUBI R16,-1
	RJMP _0x33
_0x34:
; 0000 0104                         for(l=1;l<(strpos(rx_buffer,',')-strpos(rx_buffer,34)-4);l++)
	LDI  R19,LOW(1)
_0x36:
	RCALL SUBOPT_0xD
	LDI  R26,LOW(44)
	RCALL _strpos
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xD
	LDI  R26,LOW(34)
	RCALL _strpos
	POP  R26
	POP  R27
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x15
	MOV  R26,R19
	RCALL SUBOPT_0x16
	BRGE _0x37
; 0000 0105                         {
; 0000 0106                             phoneNumberSms[0]='0';
	LDI  R30,LOW(48)
	STS  _phoneNumberSms,R30
; 0000 0107                             phoneNumberSms[l]=rx_buffer[strpos(rx_buffer,34)+3+l];
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_phoneNumberSms)
	SBCI R31,HIGH(-_phoneNumberSms)
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xD
	LDI  R26,LOW(34)
	RCALL _strpos
	ADIW R30,3
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	RCALL SUBOPT_0xF
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0108                         }
	SUBI R19,-1
	RJMP _0x36
_0x37:
; 0000 0109                         smsFlag=1;
	SET
	BLD  R2,1
; 0000 010A                         //puts(msgStr);
; 0000 010B                         if(smsFlag) smsHandle();
	SBRC R2,1
	RCALL _smsHandle
; 0000 010C 
; 0000 010D                     }
; 0000 010E                     else
_0x2F:
; 0000 010F                     {
; 0000 0110                        // loi cu phap
; 0000 0111 
; 0000 0112 
; 0000 0113                     }
; 0000 0114                }
; 0000 0115                else
_0x2E:
; 0000 0116                {
; 0000 0117 
; 0000 0118 
; 0000 0119                     //printf("can1");
; 0000 011A                     //clearBuffer();
; 0000 011B 
; 0000 011C                }
; 0000 011D             }
_0x2D:
; 0000 011E 
; 0000 011F     }
; 0000 0120     else
	RJMP _0x3B
_0x1E:
; 0000 0121     {
; 0000 0122         printf("can2");
	__POINTW1FN _0x0,10
	RCALL SUBOPT_0x17
; 0000 0123         clearBuffer();
	RCALL _clearBuffer
; 0000 0124     }
_0x3B:
; 0000 0125 
; 0000 0126 }
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND

	.DSEG
_0x26:
	.BYTE 0xA
;void checkPassword()
; 0000 0128 {

	.CSEG
_checkPassword:
; .FSTART _checkPassword
; 0000 0129    if(msgStr[0]==password[0]&&msgStr[1]==password[1]&&msgStr[2]==password[2]&&msgStr[3]==password[3]) checkpass=1;
	RCALL SUBOPT_0x18
	LDS  R26,_msgStr
	CP   R30,R26
	BRNE _0x3D
	RCALL SUBOPT_0x19
	__GETB2MN _msgStr,1
	CP   R30,R26
	BRNE _0x3D
	RCALL SUBOPT_0x1A
	__GETB2MN _msgStr,2
	CP   R30,R26
	BRNE _0x3D
	RCALL SUBOPT_0x1B
	__GETB2MN _msgStr,3
	CP   R30,R26
	BREQ _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 012A    else
	RJMP _0x3F
_0x3C:
; 0000 012B    {
; 0000 012C     checkpass=0;
	CLR  R6
; 0000 012D     printf("error password");
	__POINTW1FN _0x0,15
	RCALL SUBOPT_0x17
; 0000 012E     delay_ms(200);
	RCALL SUBOPT_0x1C
; 0000 012F     clearBuffer();
	RCALL _clearBuffer
; 0000 0130    }
_0x3F:
; 0000 0131 }
	RET
; .FEND
;void comparePhoneNumber()
; 0000 0133 {  char dt1[11],dt2[11],dt3[11];
_comparePhoneNumber:
; .FSTART _comparePhoneNumber
; 0000 0134    char i;
; 0000 0135    for(i=0;i<11;i++)
	SBIW R28,33
	ST   -Y,R17
;	dt1 -> Y+23
;	dt2 -> Y+12
;	dt3 -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x41:
	CPI  R17,11
	BRSH _0x42
; 0000 0136    {
; 0000 0137         if(sdt1[i]==255) dt1[i]=0;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_sdt1)
	SBCI R27,HIGH(-_sdt1)
	RCALL SUBOPT_0x1D
	BRNE _0x43
	RCALL SUBOPT_0x7
	MOVW R26,R28
	ADIW R26,23
	RCALL SUBOPT_0x1E
	RJMP _0xCE
; 0000 0138         else dt1[i]=sdt1[i];
_0x43:
	RCALL SUBOPT_0x7
	MOVW R26,R28
	ADIW R26,23
	RCALL SUBOPT_0x1F
	SUBI R26,LOW(-_sdt1)
	SBCI R27,HIGH(-_sdt1)
	RCALL __EEPROMRDB
	MOVW R26,R0
_0xCE:
	ST   X,R30
; 0000 0139         if(sdt2[i]==255) dt2[i]=0;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_sdt2)
	SBCI R27,HIGH(-_sdt2)
	RCALL SUBOPT_0x1D
	BRNE _0x45
	RCALL SUBOPT_0x7
	MOVW R26,R28
	ADIW R26,12
	RCALL SUBOPT_0x1E
	RJMP _0xCF
; 0000 013A         else dt2[i]=sdt2[i];
_0x45:
	RCALL SUBOPT_0x7
	MOVW R26,R28
	ADIW R26,12
	RCALL SUBOPT_0x1F
	SUBI R26,LOW(-_sdt2)
	SBCI R27,HIGH(-_sdt2)
	RCALL __EEPROMRDB
	MOVW R26,R0
_0xCF:
	ST   X,R30
; 0000 013B         if(sdt3[i]==255) dt3[i]=0;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_sdt3)
	SBCI R27,HIGH(-_sdt3)
	RCALL SUBOPT_0x1D
	BRNE _0x47
	RCALL SUBOPT_0x7
	MOVW R26,R28
	ADIW R26,1
	RCALL SUBOPT_0x1E
	RJMP _0xD0
; 0000 013C         else dt3[i]=sdt3[i];
_0x47:
	RCALL SUBOPT_0x7
	MOVW R26,R28
	ADIW R26,1
	RCALL SUBOPT_0x1F
	SUBI R26,LOW(-_sdt3)
	SBCI R27,HIGH(-_sdt3)
	RCALL __EEPROMRDB
	MOVW R26,R0
_0xD0:
	ST   X,R30
; 0000 013D    }
	SUBI R17,-1
	RJMP _0x41
_0x42:
; 0000 013E    while(i<11);
_0x49:
	CPI  R17,11
	BRLO _0x49
; 0000 013F    puts(dt1);
	MOVW R26,R28
	ADIW R26,23
	RCALL _puts
; 0000 0140    delay_ms(20);
	RCALL SUBOPT_0x3
; 0000 0141    if(callFlag==1)
	SBRS R2,0
	RJMP _0x4C
; 0000 0142    {
; 0000 0143       if(strcmp(phoneNumber,dt1)==0||strcmp(phoneNumber,dt2)==0||strcmp(phoneNumber,dt3)==0) result=1;
	RCALL SUBOPT_0x20
	MOVW R26,R28
	ADIW R26,25
	RCALL SUBOPT_0x11
	BREQ _0x4E
	RCALL SUBOPT_0x20
	MOVW R26,R28
	ADIW R26,14
	RCALL SUBOPT_0x11
	BREQ _0x4E
	RCALL SUBOPT_0x20
	MOVW R26,R28
	ADIW R26,3
	RCALL SUBOPT_0x11
	BRNE _0x4D
_0x4E:
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0144       else
	RJMP _0x50
_0x4D:
; 0000 0145       {
; 0000 0146         result=0;
	CLR  R9
; 0000 0147         delay_ms(200);
	RCALL SUBOPT_0x1C
; 0000 0148         clearBuffer();
	RCALL _clearBuffer
; 0000 0149       }
_0x50:
; 0000 014A    }
; 0000 014B }
_0x4C:
	LDD  R17,Y+0
	ADIW R28,34
	RET
; .FEND
;void callHandle()
; 0000 014D {
_callHandle:
; .FSTART _callHandle
; 0000 014E     comparePhoneNumber();
	RCALL _comparePhoneNumber
; 0000 014F             if(result==1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x51
; 0000 0150             {
; 0000 0151                 if(save1==1&&save2==1)
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x21
	BRNE _0x53
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x21
	BREQ _0x54
_0x53:
	RJMP _0x52
_0x54:
; 0000 0152                 {
; 0000 0153 
; 0000 0154                     LOAD1=0;
	CBI  0x15,0
; 0000 0155                     LOAD2=0;
	CBI  0x15,1
; 0000 0156                     save1=save2=0;
	RCALL SUBOPT_0x2
	LDI  R30,LOW(0)
	RJMP _0xD1
; 0000 0157                     printf("ATH\r\n");
; 0000 0158                     clearBuffer();
; 0000 0159                     result=callFlag=0;
; 0000 015A                 }
; 0000 015B                 else
_0x52:
; 0000 015C                 {
; 0000 015D                     LOAD1=1;
	SBI  0x15,0
; 0000 015E                     LOAD2=1;
	SBI  0x15,1
; 0000 015F                     save1=save2=1;
	RCALL SUBOPT_0x2
	LDI  R30,LOW(1)
_0xD1:
	RCALL __EEPROMWRB
	RCALL SUBOPT_0x1
	RCALL __EEPROMWRB
; 0000 0160                     printf("ATH\r\n");
	__POINTW1FN _0x0,30
	RCALL SUBOPT_0x17
; 0000 0161                     clearBuffer();
	RCALL SUBOPT_0x22
; 0000 0162                     result=callFlag=0;
	BLD  R2,0
	CLR  R9
; 0000 0163                 }
; 0000 0164             }
; 0000 0165 }
_0x51:
	RET
; .FEND
;
;void smsHandle()
; 0000 0168 {
_smsHandle:
; .FSTART _smsHandle
; 0000 0169     char k,i1,i,poskey,i2,endstr,lastspace,firstspace;
; 0000 016A     char syntax[15];
; 0000 016B     char ndt1[11],ndt2[11],ndt3[11];
; 0000 016C     poskey=11;
	SBIW R28,50
	RCALL __SAVELOCR6
;	k -> R17
;	i1 -> R16
;	i -> R19
;	poskey -> R18
;	i2 -> R21
;	endstr -> R20
;	lastspace -> Y+55
;	firstspace -> Y+54
;	syntax -> Y+39
;	ndt1 -> Y+28
;	ndt2 -> Y+17
;	ndt3 -> Y+6
	LDI  R18,LOW(11)
; 0000 016D     lastspace=strrpos(msgStr,32);
	RCALL SUBOPT_0x23
	RCALL _strrpos
	STD  Y+55,R30
; 0000 016E     firstspace=strpos(msgStr,32);
	RCALL SUBOPT_0x23
	RCALL _strpos
	STD  Y+54,R30
; 0000 016F     endstr=strrpos(msgStr,'.');
	LDI  R30,LOW(_msgStr)
	LDI  R31,HIGH(_msgStr)
	RCALL SUBOPT_0x24
	LDI  R26,LOW(46)
	RCALL _strrpos
	MOV  R20,R30
; 0000 0170     for(i=0;i<endstr-5;i++)
	LDI  R19,LOW(0)
_0x5F:
	MOV  R30,R20
	LDI  R31,0
	SBIW R30,5
	MOV  R26,R19
	RCALL SUBOPT_0x16
	BRGE _0x60
; 0000 0171         {
; 0000 0172           content[i]=msgStr[5+i];
	MOV  R26,R19
	LDI  R27,0
	SUBI R26,LOW(-_content)
	SBCI R27,HIGH(-_content)
	MOV  R30,R19
	LDI  R31,0
	__ADDW1MN _msgStr,5
	LD   R30,Z
	ST   X,R30
; 0000 0173         }
	SUBI R19,-1
	RJMP _0x5F
_0x60:
; 0000 0174     for(i2=0;i2<(lastspace-(firstspace+1));i2++)
	LDI  R21,LOW(0)
_0x62:
	LDD  R26,Y+55
	CLR  R27
	LDD  R30,Y+54
	LDI  R31,0
	ADIW R30,1
	RCALL SUBOPT_0x15
	MOV  R26,R21
	RCALL SUBOPT_0x16
	BRGE _0x63
; 0000 0175         {
; 0000 0176           syntax[i2]=msgStr[firstspace+1+i2];
	MOV  R30,R21
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,39
	RCALL SUBOPT_0x25
	MOVW R0,R30
	LDD  R30,Y+54
	LDI  R31,0
	RCALL SUBOPT_0xE
	MOV  R30,R21
	LDI  R31,0
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0xB
; 0000 0177         }
	SUBI R21,-1
	RJMP _0x62
_0x63:
; 0000 0178     for(i2=(lastspace-(firstspace+1));i2<15;i2++)
	LDD  R30,Y+54
	SUBI R30,-LOW(1)
	LDD  R26,Y+55
	SUB  R26,R30
	MOV  R21,R26
_0x65:
	CPI  R21,15
	BRSH _0x66
; 0000 0179         {
; 0000 017A             syntax[i2]=0;
	MOV  R30,R21
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,39
	RCALL SUBOPT_0x27
; 0000 017B         }
	SUBI R21,-1
	RJMP _0x65
_0x66:
; 0000 017C     puts(syntax);
	MOVW R26,R28
	ADIW R26,39
	RCALL _puts
; 0000 017D     checkPassword();
	RCALL _checkPassword
; 0000 017E     if(checkpass==1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x67
; 0000 017F     {
; 0000 0180         if(strcmp(content,"on1")==0)
	RCALL SUBOPT_0x28
	__POINTW2MN _0x69,0
	RCALL SUBOPT_0x11
	BRNE _0x68
; 0000 0181         {
; 0000 0182           LOAD1=1;
	SBI  0x15,0
; 0000 0183           save1=1;
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x29
; 0000 0184           //printf("on1");
; 0000 0185           clearBuffer();
; 0000 0186           smsFlag=0;
	BLD  R2,1
; 0000 0187 
; 0000 0188         }else{
	RJMP _0x6C
_0x68:
; 0000 0189            if(strcmp(content,"on2")==0)
	RCALL SUBOPT_0x28
	__POINTW2MN _0x69,4
	RCALL SUBOPT_0x11
	BRNE _0x6D
; 0000 018A             {
; 0000 018B               LOAD2=1;
	SBI  0x15,1
; 0000 018C               save2=1;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x29
; 0000 018D               //printf("on2");
; 0000 018E               clearBuffer();
; 0000 018F               smsFlag=0;
	BLD  R2,1
; 0000 0190             }else{
	RJMP _0x70
_0x6D:
; 0000 0191                 if(strcmp(content,"off1")==0)
	RCALL SUBOPT_0x28
	__POINTW2MN _0x69,8
	RCALL SUBOPT_0x11
	BRNE _0x71
; 0000 0192                 {
; 0000 0193                   LOAD1=0;
	CBI  0x15,0
; 0000 0194                   save1=0;
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2A
; 0000 0195                   //printf("off1");
; 0000 0196                   clearBuffer();
; 0000 0197                   smsFlag=0;
	BLD  R2,1
; 0000 0198                 } else{
	RJMP _0x74
_0x71:
; 0000 0199 
; 0000 019A                     if(strcmp(content,"off2")==0)
	RCALL SUBOPT_0x28
	__POINTW2MN _0x69,13
	RCALL SUBOPT_0x11
	BRNE _0x75
; 0000 019B                     {
; 0000 019C                       LOAD2=0;
	CBI  0x15,1
; 0000 019D                       save2=0;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2A
; 0000 019E                       //printf("off2");
; 0000 019F                       clearBuffer();
; 0000 01A0                       smsFlag=0;
	BLD  R2,1
; 0000 01A1                     }else {
	RJMP _0x78
_0x75:
; 0000 01A2 
; 0000 01A3                         if(strcmp(content,"on")==0)
	RCALL SUBOPT_0x28
	__POINTW2MN _0x69,18
	RCALL SUBOPT_0x11
	BRNE _0x79
; 0000 01A4                         {
; 0000 01A5                           LOAD1=1;
	SBI  0x15,0
; 0000 01A6                           LOAD2=1;
	SBI  0x15,1
; 0000 01A7                           save1=1;
	RCALL SUBOPT_0x1
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 01A8                           save2=1;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x29
; 0000 01A9                           //printf("on");
; 0000 01AA                           clearBuffer();
; 0000 01AB                           smsFlag=0;
	BLD  R2,1
; 0000 01AC                         }else{
	RJMP _0x7E
_0x79:
; 0000 01AD 
; 0000 01AE                             if(strcmp(content,"off")==0)
	RCALL SUBOPT_0x28
	__POINTW2MN _0x69,21
	RCALL SUBOPT_0x11
	BRNE _0x7F
; 0000 01AF                             {
; 0000 01B0                               LOAD1=0;
	CBI  0x15,0
; 0000 01B1                               LOAD2=0;
	CBI  0x15,1
; 0000 01B2                               save1=0;
	RCALL SUBOPT_0x1
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 01B3                               save2=0;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2A
; 0000 01B4                               //printf("off");
; 0000 01B5                               clearBuffer();
; 0000 01B6                               smsFlag=0;
	BLD  R2,1
; 0000 01B7                             }
; 0000 01B8                             else
	RJMP _0x84
_0x7F:
; 0000 01B9                             {
; 0000 01BA                               if(strcmp(syntax,"doimk")==0)
	RCALL SUBOPT_0x2B
	__POINTW2MN _0x69,25
	RCALL SUBOPT_0x11
	BRNE _0x85
; 0000 01BB                                 {
; 0000 01BC                                   for(k=0;k<4;k++)
	LDI  R17,LOW(0)
_0x87:
	CPI  R17,4
	BRSH _0x88
; 0000 01BD                                   {
; 0000 01BE                                     password[k]=msgStr[poskey+k];
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_password)
	SBCI R31,HIGH(-_password)
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x26
	MOVW R26,R0
	RCALL __EEPROMWRB
; 0000 01BF                                   }
	SUBI R17,-1
	RJMP _0x87
_0x88:
; 0000 01C0                                   //sendSMS(phoneNumber,"Doi mat khau thanh cong");
; 0000 01C1                                   printf("success:");
	__POINTW1FN _0x0,67
	RCALL SUBOPT_0x17
; 0000 01C2                                   putchar(password[0]);
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x2D
; 0000 01C3                                   putchar(password[1]);
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x2D
; 0000 01C4                                   putchar(password[2]);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x2D
; 0000 01C5                                   putchar(password[3]);
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x2D
; 0000 01C6                                   clearBuffer();
	RCALL SUBOPT_0x22
; 0000 01C7                                   smsFlag=0;
	BLD  R2,1
; 0000 01C8 
; 0000 01C9                                 }
; 0000 01CA                                 else
	RJMP _0x89
_0x85:
; 0000 01CB                                 {
; 0000 01CC                                   if(strcmp(syntax,"them1")==0)
	RCALL SUBOPT_0x2B
	__POINTW2MN _0x69,31
	RCALL SUBOPT_0x11
	BRNE _0x8A
; 0000 01CD                                   {
; 0000 01CE                                     for(i1=0;i1<11;i1++)
	LDI  R16,LOW(0)
_0x8C:
	CPI  R16,11
	BRSH _0x8D
; 0000 01CF                                     {
; 0000 01D0                                       if(msgStr[poskey+i1]<48||msgStr[poskey+i1]>57) sdt1[i1]=ndt1[i1]=0;
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2F
	BRLO _0x8F
	LD   R26,Z
	CPI  R26,LOW(0x3A)
	BRLO _0x8E
_0x8F:
	RCALL SUBOPT_0x13
	SUBI R30,LOW(-_sdt1)
	SBCI R31,HIGH(-_sdt1)
	MOVW R0,R30
	RCALL SUBOPT_0x13
	MOVW R26,R28
	ADIW R26,28
	RCALL SUBOPT_0x27
	MOVW R26,R0
	RJMP _0xD2
; 0000 01D1                                       else sdt1[i1]=ndt1[i1]=msgStr[poskey+i1];
_0x8E:
	RCALL SUBOPT_0x13
	SUBI R30,LOW(-_sdt1)
	SBCI R31,HIGH(-_sdt1)
	MOVW R22,R30
	RCALL SUBOPT_0x13
	MOVW R26,R28
	ADIW R26,28
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0xB
	MOVW R26,R22
_0xD2:
	RCALL __EEPROMWRB
; 0000 01D2                                     }
	SUBI R16,-1
	RJMP _0x8C
_0x8D:
; 0000 01D3                                     while(i1<11);
_0x92:
	CPI  R16,11
	BRLO _0x92
; 0000 01D4                                     printf("sdt1:");
	__POINTW1FN _0x0,82
	RCALL SUBOPT_0x17
; 0000 01D5                                     puts(ndt1);
	MOVW R26,R28
	ADIW R26,28
	RCALL _puts
; 0000 01D6                                     clearBuffer();
	RJMP _0xD3
; 0000 01D7                                   }
; 0000 01D8                                   else
_0x8A:
; 0000 01D9                                   {
; 0000 01DA                                      if(strcmp(syntax,"them2")==0)
	RCALL SUBOPT_0x2B
	__POINTW2MN _0x69,37
	RCALL SUBOPT_0x11
	BRNE _0x96
; 0000 01DB                                       {
; 0000 01DC                                         for(i1=0;i1<11;i1++)
	LDI  R16,LOW(0)
_0x98:
	CPI  R16,11
	BRSH _0x99
; 0000 01DD                                         {
; 0000 01DE                                           if(msgStr[poskey+i1]<48||msgStr[poskey+i1]>57) sdt2[i1]=ndt2[i1]=0;
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2F
	BRLO _0x9B
	LD   R26,Z
	CPI  R26,LOW(0x3A)
	BRLO _0x9A
_0x9B:
	RCALL SUBOPT_0x13
	SUBI R30,LOW(-_sdt2)
	SBCI R31,HIGH(-_sdt2)
	MOVW R0,R30
	RCALL SUBOPT_0x13
	MOVW R26,R28
	ADIW R26,17
	RCALL SUBOPT_0x27
	MOVW R26,R0
	RJMP _0xD4
; 0000 01DF                                           else sdt2[i1]=ndt2[i1]=msgStr[poskey+i1];
_0x9A:
	RCALL SUBOPT_0x13
	SUBI R30,LOW(-_sdt2)
	SBCI R31,HIGH(-_sdt2)
	MOVW R22,R30
	RCALL SUBOPT_0x13
	MOVW R26,R28
	ADIW R26,17
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0xB
	MOVW R26,R22
_0xD4:
	RCALL __EEPROMWRB
; 0000 01E0                                         }
	SUBI R16,-1
	RJMP _0x98
_0x99:
; 0000 01E1                                         while(i1<11);
_0x9E:
	CPI  R16,11
	BRLO _0x9E
; 0000 01E2                                         puts(msgStr);
	LDI  R26,LOW(_msgStr)
	LDI  R27,HIGH(_msgStr)
	RCALL _puts
; 0000 01E3                                         printf("\nsdt2:");
	__POINTW1FN _0x0,94
	RCALL SUBOPT_0x17
; 0000 01E4                                         puts(ndt2);
	MOVW R26,R28
	ADIW R26,17
	RCALL _puts
; 0000 01E5                                         clearBuffer();
	RJMP _0xD3
; 0000 01E6                                       }
; 0000 01E7                                       else
_0x96:
; 0000 01E8                                       {
; 0000 01E9                                          if(strcmp(syntax,"them3")==0)
	RCALL SUBOPT_0x2B
	__POINTW2MN _0x69,43
	RCALL SUBOPT_0x11
	BRNE _0xA2
; 0000 01EA                                           {
; 0000 01EB                                             for(i1=0;i1<11;i1++)
	LDI  R16,LOW(0)
_0xA4:
	CPI  R16,11
	BRSH _0xA5
; 0000 01EC                                             {
; 0000 01ED                                               if(msgStr[poskey+i1]<48||msgStr[poskey+i1]>57) sdt3[i1]=ndt3[i1]=0;
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2F
	BRLO _0xA7
	LD   R26,Z
	CPI  R26,LOW(0x3A)
	BRLO _0xA6
_0xA7:
	RCALL SUBOPT_0x13
	SUBI R30,LOW(-_sdt3)
	SBCI R31,HIGH(-_sdt3)
	MOVW R0,R30
	RCALL SUBOPT_0x13
	MOVW R26,R28
	ADIW R26,6
	RCALL SUBOPT_0x27
	MOVW R26,R0
	RJMP _0xD5
; 0000 01EE                                               else sdt3[i1]=ndt3[i1]=msgStr[poskey+i1];
_0xA6:
	RCALL SUBOPT_0x13
	SUBI R30,LOW(-_sdt3)
	SBCI R31,HIGH(-_sdt3)
	MOVW R22,R30
	RCALL SUBOPT_0x13
	MOVW R26,R28
	ADIW R26,6
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0xB
	MOVW R26,R22
_0xD5:
	RCALL __EEPROMWRB
; 0000 01EF                                             }
	SUBI R16,-1
	RJMP _0xA4
_0xA5:
; 0000 01F0                                             while(i1<11);
_0xAA:
	CPI  R16,11
	BRLO _0xAA
; 0000 01F1                                             printf("sdt3:");
	__POINTW1FN _0x0,107
	RCALL SUBOPT_0x17
; 0000 01F2                                             puts(ndt3);
	MOVW R26,R28
	ADIW R26,6
	RCALL _puts
; 0000 01F3                                             clearBuffer();
	RJMP _0xD3
; 0000 01F4                                           }
; 0000 01F5                                           else
_0xA2:
; 0000 01F6                                           {
; 0000 01F7                                             if(strcmp(syntax,"reset")==0)
	RCALL SUBOPT_0x2B
	__POINTW2MN _0x69,49
	RCALL SUBOPT_0x11
	BRNE _0xAE
; 0000 01F8                                             {
; 0000 01F9                                               for(i1=0;i1<4;i1++)
	LDI  R16,LOW(0)
_0xB0:
	CPI  R16,4
	BRSH _0xB1
; 0000 01FA                                               {
; 0000 01FB                                                 password[i1]='0';
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_password)
	SBCI R27,HIGH(-_password)
	RCALL SUBOPT_0x30
; 0000 01FC                                               }
	SUBI R16,-1
	RJMP _0xB0
_0xB1:
; 0000 01FD                                               while(i1<4);
_0xB2:
	CPI  R16,4
	BRLO _0xB2
; 0000 01FE                                               printf("password:");
	__POINTW1FN _0x0,119
	RCALL SUBOPT_0x17
; 0000 01FF                                               putchar(password[0]);
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x2D
; 0000 0200                                               putchar(password[1]);
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x2D
; 0000 0201                                               putchar(password[2]);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x2D
; 0000 0202                                               putchar(password[3]);
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x2D
; 0000 0203                                               clearBuffer();
	RJMP _0xD3
; 0000 0204                                             }
; 0000 0205                                             else
_0xAE:
; 0000 0206                                             {
; 0000 0207                                                printf("syntax error");
	__POINTW1FN _0x0,129
	RCALL SUBOPT_0x17
; 0000 0208                                                clearBuffer();
_0xD3:
	RCALL _clearBuffer
; 0000 0209 
; 0000 020A                                             }
; 0000 020B                                           }
; 0000 020C                                       }
; 0000 020D                                   }
; 0000 020E                                 }
_0x89:
; 0000 020F                             }
_0x84:
; 0000 0210                         }
_0x7E:
; 0000 0211                     }
_0x78:
; 0000 0212                 }
_0x74:
; 0000 0213             }
_0x70:
; 0000 0214         }
_0x6C:
; 0000 0215 
; 0000 0216 
; 0000 0217     }
; 0000 0218     else
	RJMP _0xB6
_0x67:
; 0000 0219     {
; 0000 021A       printf("password error");
	__POINTW1FN _0x0,142
	RCALL SUBOPT_0x17
; 0000 021B       clearBuffer();
	RCALL _clearBuffer
; 0000 021C     }
_0xB6:
; 0000 021D 
; 0000 021E }
	RCALL __LOADLOCR6
	ADIW R28,56
	RET
; .FEND

	.DSEG
_0x69:
	.BYTE 0x37
;
;
;void main(void)
; 0000 0222 {

	.CSEG
_main:
; .FSTART _main
; 0000 0223 // Declare your local variables here
; 0000 0224 
; 0000 0225 // Input/Output Ports initialization
; 0000 0226 // Port B initialization
; 0000 0227 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0228 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0229 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 022A PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 022B 
; 0000 022C // Port C initialization
; 0000 022D // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out
; 0000 022E DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(3)
	OUT  0x14,R30
; 0000 022F // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0
; 0000 0230 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0231 
; 0000 0232 // Port D initialization
; 0000 0233 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=In
; 0000 0234 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 0235 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=0 Bit0=T
; 0000 0236 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 0237 
; 0000 0238 // Timer/Counter 0 initialization
; 0000 0239 // Clock source: System Clock
; 0000 023A // Clock value: 0.977 kHz
; 0000 023B //0.26214s
; 0000 023C TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 023D TCNT0=0x00;
	OUT  0x32,R30
; 0000 023E 
; 0000 023F // Timer/Counter 1 initialization
; 0000 0240 // Clock source: System Clock
; 0000 0241 // Clock value: Timer1 Stopped
; 0000 0242 // Mode: Normal top=0xFFFF
; 0000 0243 // OC1A output: Disconnected
; 0000 0244 // OC1B output: Disconnected
; 0000 0245 // Noise Canceler: Off
; 0000 0246 // Input Capture on Falling Edge
; 0000 0247 // Timer1 Overflow Interrupt: Off
; 0000 0248 // Input Capture Interrupt: Off
; 0000 0249 // Compare A Match Interrupt: Off
; 0000 024A // Compare B Match Interrupt: Off
; 0000 024B TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 024C TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 024D TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 024E TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 024F ICR1H=0x00;
	OUT  0x27,R30
; 0000 0250 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0251 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0252 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0253 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0254 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0255 
; 0000 0256 // Timer/Counter 2 initialization
; 0000 0257 // Clock source: System Clock
; 0000 0258 // Clock value: Timer2 Stopped
; 0000 0259 // Mode: Normal top=0xFF
; 0000 025A // OC2 output: Disconnected
; 0000 025B ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 025C TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 025D TCNT2=0x00;
	OUT  0x24,R30
; 0000 025E OCR2=0x00;
	OUT  0x23,R30
; 0000 025F 
; 0000 0260 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0261 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0262 
; 0000 0263 // External Interrupt(s) initialization
; 0000 0264 // INT0: On
; 0000 0265 // INT0 Mode: Falling Edge
; 0000 0266 // INT1: On
; 0000 0267 // INT1 Mode: Falling Edge
; 0000 0268 GICR|=(1<<INT1) | (1<<INT0);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 0269 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 026A GIFR=(1<<INTF1) | (1<<INTF0);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 026B 
; 0000 026C // USART initialization
; 0000 026D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 026E // USART Receiver: On
; 0000 026F // USART Transmitter: On
; 0000 0270 // USART Mode: Asynchronous
; 0000 0271 // USART Baud Rate: 9600 (Double Speed Mode)
; 0000 0272 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (1<<U2X) | (1<<MPCM);
	LDI  R30,LOW(3)
	OUT  0xB,R30
; 0000 0273 UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0274 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0275 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0276 UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 0277 
; 0000 0278 // Analog Comparator initialization
; 0000 0279 // Analog Comparator: Off
; 0000 027A // The Analog Comparator's positive input is
; 0000 027B // connected to the AIN0 pin
; 0000 027C // The Analog Comparator's negative input is
; 0000 027D // connected to the AIN1 pin
; 0000 027E ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 027F SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0280 
; 0000 0281 // ADC initialization
; 0000 0282 // ADC disabled
; 0000 0283 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0284 
; 0000 0285 // SPI initialization
; 0000 0286 // SPI disabled
; 0000 0287 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0288 
; 0000 0289 // TWI initialization
; 0000 028A // TWI disabled
; 0000 028B TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 028C 
; 0000 028D // Global enable interrupts
; 0000 028E #asm("sei")
	sei
; 0000 028F while(strpos(rx_buffer,'O')<0)
_0xB7:
	RCALL SUBOPT_0xD
	LDI  R26,LOW(79)
	RCALL _strpos
	TST  R31
	BRPL _0xB9
; 0000 0290 {
; 0000 0291     printf("AT\r\n");
	__POINTW1FN _0x0,157
	RCALL SUBOPT_0x17
; 0000 0292     printf(DISABLE_ECHO);
	__POINTW1FN _0x0,162
	RCALL SUBOPT_0x17
; 0000 0293     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0294     if(strpos(rx_buffer,'O')<0) clearBuffer();
	RCALL SUBOPT_0xD
	LDI  R26,LOW(79)
	RCALL _strpos
	TST  R31
	BRPL _0xBA
	RCALL _clearBuffer
; 0000 0295 }
_0xBA:
	RJMP _0xB7
_0xB9:
; 0000 0296 printf(FORMAT_SMS_TEXT);
	__POINTW1FN _0x0,169
	RCALL SUBOPT_0x17
; 0000 0297 delay_ms(200);
	RCALL SUBOPT_0x1C
; 0000 0298 printf(DISABLE_ECHO);
	__POINTW1FN _0x0,162
	RCALL SUBOPT_0x17
; 0000 0299 delay_ms(200);
	RCALL SUBOPT_0x1C
; 0000 029A printf(READ_WHEN_NEWSMS);
	__POINTW1FN _0x0,181
	RCALL SUBOPT_0x17
; 0000 029B delay_ms(200);
	RCALL SUBOPT_0x1C
; 0000 029C printf(ENABLE_USSD);
	__POINTW1FN _0x0,201
	RCALL SUBOPT_0x17
; 0000 029D delay_ms(200);
	RCALL SUBOPT_0x1C
; 0000 029E printf(DELETE_ALL_MSG);
	__POINTW1FN _0x0,213
	RCALL SUBOPT_0x17
; 0000 029F delay_ms(200);
	RCALL SUBOPT_0x1C
; 0000 02A0 if(begin==255)
	LDI  R26,LOW(_begin)
	LDI  R27,HIGH(_begin)
	RCALL SUBOPT_0x1D
	BRNE _0xBB
; 0000 02A1 {
; 0000 02A2 
; 0000 02A3   password[0]='0';
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	RCALL SUBOPT_0x30
; 0000 02A4   password[1]='0';
	__POINTW2MN _password,1
	RCALL SUBOPT_0x30
; 0000 02A5   password[2]='0';
	__POINTW2MN _password,2
	RCALL SUBOPT_0x30
; 0000 02A6   password[3]='0';
	__POINTW2MN _password,3
	RCALL SUBOPT_0x30
; 0000 02A7   sdt1[0]='0';
	LDI  R26,LOW(_sdt1)
	LDI  R27,HIGH(_sdt1)
	RCALL SUBOPT_0x30
; 0000 02A8   sdt1[1]='9';
	__POINTW2MN _sdt1,1
	LDI  R30,LOW(57)
	RCALL __EEPROMWRB
; 0000 02A9   sdt1[2]='6';
	__POINTW2MN _sdt1,2
	LDI  R30,LOW(54)
	RCALL __EEPROMWRB
; 0000 02AA   sdt1[3]='4';
	__POINTW2MN _sdt1,3
	RCALL SUBOPT_0x31
; 0000 02AB   sdt1[4]='4';
	__POINTW2MN _sdt1,4
	RCALL SUBOPT_0x31
; 0000 02AC   sdt1[5]='4';
	__POINTW2MN _sdt1,5
	RCALL SUBOPT_0x31
; 0000 02AD   sdt1[6]='4';
	__POINTW2MN _sdt1,6
	RCALL SUBOPT_0x31
; 0000 02AE   sdt1[7]='3';
	__POINTW2MN _sdt1,7
	LDI  R30,LOW(51)
	RCALL __EEPROMWRB
; 0000 02AF   sdt1[8]='7';
	__POINTW2MN _sdt1,8
	LDI  R30,LOW(55)
	RCALL __EEPROMWRB
; 0000 02B0   sdt1[9]='3';
	__POINTW2MN _sdt1,9
	LDI  R30,LOW(51)
	RCALL __EEPROMWRB
; 0000 02B1   begin=0;
	LDI  R26,LOW(_begin)
	LDI  R27,HIGH(_begin)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 02B2 }
; 0000 02B3 if(save1==1) LOAD1=1;
_0xBB:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x21
	BRNE _0xBC
	SBI  0x15,0
; 0000 02B4 else LOAD1=0;
	RJMP _0xBF
_0xBC:
	CBI  0x15,0
; 0000 02B5 if(save2==1) LOAD2=1;
_0xBF:
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x21
	BRNE _0xC2
	SBI  0x15,1
; 0000 02B6 else LOAD2=0;
	RJMP _0xC5
_0xC2:
	CBI  0x15,1
; 0000 02B7 clearBuffer();
_0xC5:
	RCALL _clearBuffer
; 0000 02B8 while (1)
_0xC8:
; 0000 02B9       {     if(flag) strHandle();
	TST  R4
	BREQ _0xCB
	RCALL _strHandle
; 0000 02BA 
; 0000 02BB             //strHandle();
; 0000 02BC //          if(smsFlag==1)
; 0000 02BD //          {
; 0000 02BE //              checkPassword();
; 0000 02BF //              action();
; 0000 02C0 //          }
; 0000 02C1 //          else{
; 0000 02C2 //            if(callFlag==1)
; 0000 02C3 //            {
; 0000 02C4 //                if(strcmp(phoneNumber,"0964444373")==0)
; 0000 02C5 //                {
; 0000 02C6 //                  printf("ATH\r\n");
; 0000 02C7 //                  LOAD1=~LOAD1;
; 0000 02C8 //                  LOAD2=~LOAD2;
; 0000 02C9 //                  save1=~save1;
; 0000 02CA //                  save2=~save2;
; 0000 02CB //                  clearBuffer();
; 0000 02CC //                  callFlag=0;
; 0000 02CD //                }else{
; 0000 02CE //                  clearBuffer();
; 0000 02CF //                  callFlag=0;
; 0000 02D0 //                }
; 0000 02D1 //            }
; 0000 02D2 //            else strHandle();
; 0000 02D3 //          }
; 0000 02D4 //
; 0000 02D5 
; 0000 02D6 
; 0000 02D7 
; 0000 02D8       }
_0xCB:
	RJMP _0xC8
; 0000 02D9 }
_0xCC:
	RJMP _0xCC
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
	RCALL SUBOPT_0x32
	ST   -Y,R17
_0x2000003:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
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
	LDD  R17,Y+0
	RJMP _0x2080001
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	RCALL SUBOPT_0x32
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2080001:
	ADIW R28,3
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	RCALL SUBOPT_0x32
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x33
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x33
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x34
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x36
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x38
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x38
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x39
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x39
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x3A
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x3A
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x33
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x39
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x33
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x39
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x36
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x33
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x36
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
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
	RCALL SUBOPT_0x24
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	RCALL SUBOPT_0x24
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

	.CSEG
_strcmp:
; .FSTART _strcmp
	RCALL SUBOPT_0x32
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
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x32
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x32
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
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
_type:
	.BYTE 0xA
_content:
	.BYTE 0x5
_phoneNumber:
	.BYTE 0xB
_phoneNumberSms:
	.BYTE 0xB
_msgStr:
	.BYTE 0xA0

	.ESEG
_sdt1:
	.BYTE 0xB
_sdt2:
	.BYTE 0xB
_sdt3:
	.BYTE 0xB
_save1:
	.BYTE 0x1
_save2:
	.BYTE 0x1
_begin:
	.BYTE 0x1
_password:
	.BYTE 0x4

	.DSEG
_rx_buffer:
	.BYTE 0xFA
_tx_buffer:
	.BYTE 0x96
_tx_counter:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_save1)
	LDI  R27,HIGH(_save1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_save2)
	LDI  R27,HIGH(_save2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(20)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R30,_tx_counter
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	SUBI R30,LOW(-_msgStr)
	SBCI R31,HIGH(-_msgStr)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(43)
	RCALL _strpos
	TST  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	ADIW R30,1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x5
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(_type)
	LDI  R31,HIGH(_type)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	RCALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x13:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:62 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	__POINTW2MN _password,1
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	__POINTW2MN _password,2
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	__POINTW2MN _password,3
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(200)
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	RCALL __EEPROMRDB
	CPI  R30,LOW(0xFF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	ADD  R30,R26
	ADC  R31,R27
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(_phoneNumber)
	LDI  R31,HIGH(_phoneNumber)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	RCALL _clearBuffer
	CLT
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(_msgStr)
	LDI  R31,HIGH(_msgStr)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(32)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x24:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x8
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(_content)
	LDI  R31,HIGH(_content)
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2B:
	MOVW R30,R28
	ADIW R30,39
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2C:
	MOVW R0,R30
	MOV  R26,R18
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	MOV  R26,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	MOV  R26,R18
	CLR  R27
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2F:
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x8
	LD   R26,Z
	CPI  R26,LOW(0x30)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(48)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(52)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x33:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x36:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x34
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
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
