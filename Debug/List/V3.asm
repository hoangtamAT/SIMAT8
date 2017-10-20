
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
	.DB  0x3A,0x0,0x43,0x55,0x53,0x44,0x0,0x2E
	.DB  0x0,0x74,0x69,0x6D,0x65,0x20,0x6F,0x75
	.DB  0x74,0x0,0x41,0x54,0x48,0xD,0xA,0x0
	.DB  0x6F,0x66,0x66,0x0,0x6F,0x6E,0x0,0x72
	.DB  0x65,0x73,0x65,0x74,0x20,0x73,0x75,0x63
	.DB  0x63,0x65,0x73,0x73,0x0,0x70,0x61,0x73
	.DB  0x73,0x77,0x6F,0x72,0x64,0x20,0x65,0x72
	.DB  0x72,0x6F,0x72,0x0,0x6F,0x6E,0x31,0x0
	.DB  0x6F,0x6E,0x32,0x0,0x6F,0x66,0x66,0x31
	.DB  0x0,0x6F,0x66,0x66,0x32,0x0,0x64,0x6F
	.DB  0x69,0x6D,0x6B,0x0,0x73,0x75,0x63,0x63
	.DB  0x65,0x73,0x73,0x3A,0x0,0x74,0x68,0x65
	.DB  0x6D,0x31,0x0,0x73,0x64,0x74,0x31,0x3A
	.DB  0x0,0x74,0x68,0x65,0x6D,0x32,0x0,0xA
	.DB  0x73,0x64,0x74,0x32,0x3A,0x0,0x74,0x68
	.DB  0x65,0x6D,0x33,0x0,0x73,0x64,0x74,0x33
	.DB  0x3A,0x0,0x6B,0x74,0x74,0x6B,0x0,0x6E
	.DB  0x61,0x70,0x74,0x69,0x65,0x6E,0x0,0x41
	.DB  0x54,0xD,0xA,0x0,0x41,0x54,0x45,0x30
	.DB  0xD,0xA,0x0,0x41,0x54,0x2B,0x43,0x4D
	.DB  0x47,0x46,0x3D,0x31,0xD,0xA,0x0,0x41
	.DB  0x54,0x2B,0x43,0x4E,0x4D,0x49,0x3D,0x32
	.DB  0x2C,0x32,0x2C,0x30,0x2C,0x30,0x2C,0x30
	.DB  0xD,0xA,0x0,0x41,0x54,0x2B,0x43,0x55
	.DB  0x53,0x44,0x3D,0x31,0xD,0xA,0x0,0x41
	.DB  0x54,0x2B,0x43,0x4D,0x47,0x44,0x41,0x3D
	.DB  0x44,0x45,0x4C,0x20,0x41,0x4C,0x4C,0xD
	.DB  0xA,0x0,0x31,0x30,0x39,0x0,0x68,0x68
	.DB  0x68,0x68,0x68,0x68,0x0
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
	.DW  _0x1E
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x1E+5
	.DW  _0x0*2+5

	.DW  0x05
	.DW  _0x1E+10
	.DW  _0x0*2+10

	.DW  0x05
	.DW  _0x1E+15
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x1E+20
	.DW  _0x0*2+5

	.DW  0x05
	.DW  _0x1E+25
	.DW  _0x0*2+5

	.DW  0x05
	.DW  _0x1E+30
	.DW  _0x0*2+10

	.DW  0x04
	.DW  _0x7B
	.DW  _0x0*2+68

	.DW  0x04
	.DW  _0x7B+4
	.DW  _0x0*2+72

	.DW  0x05
	.DW  _0x7B+8
	.DW  _0x0*2+76

	.DW  0x05
	.DW  _0x7B+13
	.DW  _0x0*2+81

	.DW  0x03
	.DW  _0x7B+18
	.DW  _0x0*2+36

	.DW  0x04
	.DW  _0x7B+21
	.DW  _0x0*2+32

	.DW  0x06
	.DW  _0x7B+25
	.DW  _0x0*2+86

	.DW  0x06
	.DW  _0x7B+31
	.DW  _0x0*2+101

	.DW  0x06
	.DW  _0x7B+37
	.DW  _0x0*2+113

	.DW  0x06
	.DW  _0x7B+43
	.DW  _0x0*2+126

	.DW  0x05
	.DW  _0x7B+49
	.DW  _0x0*2+138

	.DW  0x08
	.DW  _0x7B+54
	.DW  _0x0*2+143

	.DW  0x04
	.DW  _0xDB
	.DW  _0x0*2+226

	.DW  0x07
	.DW  _0xDB+4
	.DW  _0x0*2+230

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
;char content[5];
;char qtyNum=10;
;char type[4];
;char phoneNumber[11];
;char phoneNumberSms[11];
;char msgStr[100];
;
;eeprom char sdt1[11];
;eeprom char sdt2[11];
;eeprom char sdt3[11];
;
;
;eeprom char save1,save2,begin;
;eeprom char password[4];
;
;char flag,rxStatus,checkpass,result=0;
;bit callFlag=0,smsFlag=0;
;// Declare your global variables here
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0039 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0x0
; 0000 003A  LOAD1=~LOAD1;
	SBIS 0x15,0
	RJMP _0x3
	CBI  0x15,0
	RJMP _0x4
_0x3:
	SBI  0x15,0
_0x4:
; 0000 003B  save1=~save1;
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDB
	COM  R30
	RCALL SUBOPT_0x1
	RJMP _0xEB
; 0000 003C  delay_ms(20);
; 0000 003D 
; 0000 003E }
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0042 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x0
; 0000 0043 LOAD2=~LOAD2;
	SBIS 0x15,1
	RJMP _0x5
	CBI  0x15,1
	RJMP _0x6
_0x5:
	SBI  0x15,1
_0x6:
; 0000 0044 save2=~save2;
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDB
	COM  R30
	RCALL SUBOPT_0x2
_0xEB:
	RCALL __EEPROMWRB
; 0000 0045     delay_ms(20);
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x3
; 0000 0046 
; 0000 0047 }
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
; 0000 0064 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	RCALL SUBOPT_0x4
; 0000 0065 char status,data;
; 0000 0066 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0067 data=UDR;
	IN   R16,12
; 0000 0068 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x7
; 0000 0069    {
; 0000 006A    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R8
	INC  R8
	LDI  R31,0
	RCALL SUBOPT_0x5
	ST   Z,R16
; 0000 006B    flag=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 006C #if RX_BUFFER_SIZE == 256
; 0000 006D    // special case for receiver buffer size=256
; 0000 006E    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 006F #else
; 0000 0070    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(250)
	CP   R30,R8
	BRNE _0x8
	CLR  R8
; 0000 0071    if (++rx_counter == RX_BUFFER_SIZE)
_0x8:
	INC  R10
	LDI  R30,LOW(250)
	CP   R30,R10
	BRNE _0x9
; 0000 0072       {
; 0000 0073       rx_counter=0;
	CLR  R10
; 0000 0074       rx_buffer_overflow=1;
	SET
	BLD  R2,2
; 0000 0075       }
; 0000 0076 #endif
; 0000 0077    }
_0x9:
; 0000 0078 }
_0x7:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0xEA
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 007F {
; 0000 0080 char data;
; 0000 0081 while (rx_counter==0);
;	data -> R17
; 0000 0082 data=rx_buffer[rx_rd_index++];
; 0000 0083 #if RX_BUFFER_SIZE != 256
; 0000 0084 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0085 #endif
; 0000 0086 #asm("cli")
; 0000 0087 --rx_counter;
; 0000 0088 #asm("sei")
; 0000 0089 return data;
; 0000 008A }
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
; 0000 00A0 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	RCALL SUBOPT_0x4
; 0000 00A1 if (tx_counter)
	RCALL SUBOPT_0x6
	CPI  R30,0
	BREQ _0xE
; 0000 00A2    {
; 0000 00A3    --tx_counter;
	RCALL SUBOPT_0x6
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 00A4    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00A5 #if TX_BUFFER_SIZE != 256
; 0000 00A6    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(150)
	CP   R30,R12
	BRNE _0xF
	CLR  R12
; 0000 00A7 #endif
; 0000 00A8    }
_0xF:
; 0000 00A9 }
_0xE:
_0xEA:
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
; 0000 00B0 {
_putchar:
; .FSTART _putchar
; 0000 00B1 while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0x10:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x96)
	BREQ _0x10
; 0000 00B2 #asm("cli")
	cli
; 0000 00B3 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	RCALL SUBOPT_0x6
	CPI  R30,0
	BRNE _0x14
	SBIC 0xB,5
	RJMP _0x13
_0x14:
; 0000 00B4    {
; 0000 00B5    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00B6 #if TX_BUFFER_SIZE != 256
; 0000 00B7    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(150)
	CP   R30,R13
	BRNE _0x16
	CLR  R13
; 0000 00B8 #endif
; 0000 00B9    ++tx_counter;
_0x16:
	RCALL SUBOPT_0x6
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0000 00BA    }
; 0000 00BB else
	RJMP _0x17
_0x13:
; 0000 00BC    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00BD #asm("sei")
_0x17:
	sei
; 0000 00BE }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;
;void clearBuffer()
; 0000 00C3 {   char i;
_clearBuffer:
; .FSTART _clearBuffer
; 0000 00C4 
; 0000 00C5     for(i=0;i<rx_wr_index;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x19:
	CP   R17,R8
	BRSH _0x1A
; 0000 00C6     {
; 0000 00C7         rx_buffer[i]=msgStr[i]=phoneNumber[i]=phoneNumberSms[i]=content[i]=type[i]=0;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_phoneNumber)
	SBCI R31,HIGH(-_phoneNumber)
	MOVW R24,R30
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_phoneNumberSms)
	SBCI R31,HIGH(-_phoneNumberSms)
	MOVW R22,R30
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_content)
	SBCI R31,HIGH(-_content)
	RCALL SUBOPT_0x9
	SUBI R26,LOW(-_type)
	SBCI R27,HIGH(-_type)
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	MOVW R26,R22
	ST   X,R30
	MOVW R26,R24
	ST   X,R30
	POP  R26
	POP  R27
	ST   X,R30
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00C8     }
	SUBI R17,-1
	RJMP _0x19
_0x1A:
; 0000 00C9     rx_wr_index=0;
	CLR  R8
; 0000 00CA     checkpass=0;
	CLR  R6
; 0000 00CB     result=0;
	CLR  R9
; 0000 00CC     flag=0;
	CLR  R4
; 0000 00CD 
; 0000 00CE 
; 0000 00CF }
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
;void strHandle()
; 0000 00DF {
_strHandle:
; .FSTART _strHandle
; 0000 00E0     char i,k,l,pos,e=0,n=0;
; 0000 00E1             while(strcmp(type,"CLIP")!=0 && strcmp(type,"CMT:")!=0 && strcmp(type,"CUSD")!=0)
	RCALL __SAVELOCR6
;	i -> R17
;	k -> R16
;	l -> R19
;	pos -> R18
;	e -> R21
;	n -> R20
	LDI  R21,0
	LDI  R20,0
_0x1B:
	RCALL SUBOPT_0xC
	__POINTW2MN _0x1E,0
	RCALL SUBOPT_0xD
	BREQ _0x1F
	RCALL SUBOPT_0xC
	__POINTW2MN _0x1E,5
	RCALL SUBOPT_0xD
	BREQ _0x1F
	RCALL SUBOPT_0xC
	__POINTW2MN _0x1E,10
	RCALL SUBOPT_0xD
	BRNE _0x20
_0x1F:
	RJMP _0x1D
_0x20:
; 0000 00E2             {
; 0000 00E3                 for(i=0;i<4;i++)
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,4
	BRSH _0x23
; 0000 00E4                 {
; 0000 00E5                     type[i]=rx_buffer[strpos(rx_buffer,'+')+1+i];
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_type)
	SBCI R31,HIGH(-_type)
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xE
	LDI  R26,LOW(43)
	RCALL _strpos
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x10
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00E6                 }
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 00E7                 e++;
	SUBI R21,-1
; 0000 00E8                 printf(".");
	RCALL SUBOPT_0x11
; 0000 00E9                 delay_ms(50);
; 0000 00EA                 if(e>20)
	CPI  R21,21
	BRLO _0x24
; 0000 00EB                 {
; 0000 00EC                   printf("time out");
	RCALL SUBOPT_0x12
; 0000 00ED                   clearBuffer();
; 0000 00EE                   break;
	RJMP _0x1D
; 0000 00EF                 }
; 0000 00F0             }
_0x24:
	RJMP _0x1B
_0x1D:
; 0000 00F1             if(strcmp(type,"CLIP")==0)  //call
	RCALL SUBOPT_0xC
	__POINTW2MN _0x1E,15
	RCALL SUBOPT_0xD
	BRNE _0x25
; 0000 00F2             {
; 0000 00F3                 rxStatus=strCall;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 00F4                 pos=strpos(rx_buffer,34); // "  //
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x13
	MOV  R18,R30
; 0000 00F5                 if(rx_buffer[pos+11]==34) qtyNum=10;
	RCALL SUBOPT_0x14
	__ADDW1MN _rx_buffer,11
	LD   R26,Z
	CPI  R26,LOW(0x22)
	BRNE _0x26
	LDI  R30,LOW(10)
	RJMP _0xE1
; 0000 00F6                 else qtyNum=11;
_0x26:
	LDI  R30,LOW(11)
_0xE1:
	MOV  R5,R30
; 0000 00F7                 for(k=0;k<qtyNum;k++)
	LDI  R16,LOW(0)
_0x29:
	CP   R16,R5
	BRSH _0x2A
; 0000 00F8                 {
; 0000 00F9                    phoneNumber[k]=rx_buffer[pos+1+k];
	RCALL SUBOPT_0x15
	SUBI R30,LOW(-_phoneNumber)
	SBCI R31,HIGH(-_phoneNumber)
	MOVW R0,R30
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xB
; 0000 00FA                 }
	SUBI R16,-1
	RJMP _0x29
_0x2A:
; 0000 00FB                 callFlag=1;
	SET
	BLD  R2,0
; 0000 00FC                 if(callFlag)callHandle();
	SBRC R2,0
	RCALL _callHandle
; 0000 00FD 
; 0000 00FE             }
; 0000 00FF             else  //sms
	RJMP _0x2C
_0x25:
; 0000 0100             {
; 0000 0101                if(strcmp(type,"CMT:")==0)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x1E,20
	RCALL SUBOPT_0xD
	BREQ PC+2
	RJMP _0x2D
; 0000 0102                {    //"+84964444373", ":0 ,:14-15
; 0000 0103                     rxStatus=strSms;
	LDI  R30,LOW(2)
	MOV  R7,R30
; 0000 0104                     while(strpos(rx_buffer,'.')<=0)
_0x2E:
	RCALL SUBOPT_0xE
	LDI  R26,LOW(46)
	RCALL _strpos
	RCALL __CPW01
	BRLT _0x30
; 0000 0105                     {
; 0000 0106                        n++;
	SUBI R20,-1
; 0000 0107                        printf(".");
	RCALL SUBOPT_0x11
; 0000 0108                        delay_ms(50);
; 0000 0109                        if(n>20)
	CPI  R20,21
	BRLO _0x31
; 0000 010A                        {
; 0000 010B                          printf("time out");
	RCALL SUBOPT_0x12
; 0000 010C                          clearBuffer();
; 0000 010D                          break;
	RJMP _0x30
; 0000 010E                        }
; 0000 010F                     }
_0x31:
	RJMP _0x2E
_0x30:
; 0000 0110                     if(strcmp(type,"CMT:")==0)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x1E,25
	RCALL SUBOPT_0xD
	BREQ PC+2
	RJMP _0x32
; 0000 0111                     {
; 0000 0112                         pos=strpos(rx_buffer,'#');
	RCALL SUBOPT_0xE
	LDI  R26,LOW(35)
	RCALL _strpos
	MOV  R18,R30
; 0000 0113                         if(pos>0)
	CPI  R18,1
	BRLO _0x33
; 0000 0114                         {
; 0000 0115                             for(k=0;k<strpos(rx_buffer,'.')-pos;k++)
	LDI  R16,LOW(0)
_0x35:
	RCALL SUBOPT_0xE
	LDI  R26,LOW(46)
	RCALL _strpos
	MOVW R26,R30
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	BRGE _0x36
; 0000 0116                             {
; 0000 0117                                 msgStr[k]=rx_buffer[pos+1+k];
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x8
	MOVW R0,R30
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xB
; 0000 0118                             }
	SUBI R16,-1
	RJMP _0x35
_0x36:
; 0000 0119                             for(l=1;l<(strpos(rx_buffer,',')-strpos(rx_buffer,34)-4);l++)
	LDI  R19,LOW(1)
_0x38:
	RCALL SUBOPT_0xE
	LDI  R26,LOW(44)
	RCALL _strpos
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x13
	POP  R26
	POP  R27
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x18
	BRGE _0x39
; 0000 011A                             {
; 0000 011B                                 phoneNumberSms[0]='0';
	LDI  R30,LOW(48)
	STS  _phoneNumberSms,R30
; 0000 011C                                 phoneNumberSms[l]=rx_buffer[strpos(rx_buffer,34)+3+l];
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_phoneNumberSms)
	SBCI R31,HIGH(-_phoneNumberSms)
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x13
	ADIW R30,3
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	RCALL SUBOPT_0x10
	POP  R26
	POP  R27
	ST   X,R30
; 0000 011D                             }
	SUBI R19,-1
	RJMP _0x38
_0x39:
; 0000 011E                             smsFlag=1;
	SET
	BLD  R2,1
; 0000 011F                             //puts(msgStr);
; 0000 0120                             if(smsFlag) smsHandle();
	SBRC R2,1
	RCALL _smsHandle
; 0000 0121                         }
; 0000 0122                     }
_0x33:
; 0000 0123 
; 0000 0124                }
_0x32:
; 0000 0125                else
	RJMP _0x3B
_0x2D:
; 0000 0126                {//+CUSD: 0, "TK goc la 12d. De biet cac CT dac biet cua Quy khach, bam goi *098#.", 15
; 0000 0127                     if(strcmp(type,"CUSD")==0)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x1E,30
	RCALL SUBOPT_0xD
	BRNE _0x3C
; 0000 0128                     {
; 0000 0129                        pos=strpos(rx_buffer,34);
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x13
	MOV  R18,R30
; 0000 012A                        for(k=0;k<(strrpos(rx_buffer,34)-pos-1);k++)
	LDI  R16,LOW(0)
_0x3E:
	RCALL SUBOPT_0xE
	LDI  R26,LOW(34)
	RCALL _strrpos
	MOVW R26,R30
	RCALL SUBOPT_0x14
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	BRGE _0x3F
; 0000 012B                        {
; 0000 012C                          msgStr[k]=rx_buffer[pos+1+k];
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x8
	MOVW R0,R30
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xB
; 0000 012D                        }
	SUBI R16,-1
	RJMP _0x3E
_0x3F:
; 0000 012E                        puts(msgStr);
	LDI  R26,LOW(_msgStr)
	LDI  R27,HIGH(_msgStr)
	RCALL SUBOPT_0x19
; 0000 012F                        clearBuffer();
; 0000 0130                     }
; 0000 0131 
; 0000 0132 
; 0000 0133                }
_0x3C:
_0x3B:
; 0000 0134             }
_0x2C:
; 0000 0135 
; 0000 0136 }
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND

	.DSEG
_0x1E:
	.BYTE 0x23
;void checkPassword()
; 0000 0138 {

	.CSEG
_checkPassword:
; .FSTART _checkPassword
; 0000 0139    if(msgStr[0]==password[0]&&msgStr[1]==password[1]&&msgStr[2]==password[2]&&msgStr[3]==password[3]) checkpass=1;
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	RCALL __EEPROMRDB
	LDS  R26,_msgStr
	CP   R30,R26
	BRNE _0x41
	__POINTW2MN _password,1
	RCALL __EEPROMRDB
	__GETB2MN _msgStr,1
	CP   R30,R26
	BRNE _0x41
	__POINTW2MN _password,2
	RCALL __EEPROMRDB
	__GETB2MN _msgStr,2
	CP   R30,R26
	BRNE _0x41
	__POINTW2MN _password,3
	RCALL __EEPROMRDB
	__GETB2MN _msgStr,3
	CP   R30,R26
	BREQ _0x42
_0x41:
	RJMP _0x40
_0x42:
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 013A    else
	RJMP _0x43
_0x40:
; 0000 013B    {
; 0000 013C     checkpass=0;
	CLR  R6
; 0000 013D    }
_0x43:
; 0000 013E }
	RET
; .FEND
;void comparePhoneNumber()
; 0000 0140 {  char dt1[11],dt2[11],dt3[11];
_comparePhoneNumber:
; .FSTART _comparePhoneNumber
; 0000 0141    char i;
; 0000 0142    for(i=0;i<11;i++)
	SBIW R28,33
	ST   -Y,R17
;	dt1 -> Y+23
;	dt2 -> Y+12
;	dt3 -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x45:
	CPI  R17,11
	BRSH _0x46
; 0000 0143    {
; 0000 0144         if(sdt1[i]==255) dt1[i]=0;
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_sdt1)
	SBCI R27,HIGH(-_sdt1)
	RCALL SUBOPT_0x1B
	BRNE _0x47
	RCALL SUBOPT_0x7
	MOVW R26,R28
	ADIW R26,23
	RCALL SUBOPT_0x1C
	RJMP _0xE2
; 0000 0145         else dt1[i]=sdt1[i];
_0x47:
	RCALL SUBOPT_0x7
	MOVW R26,R28
	ADIW R26,23
	RCALL SUBOPT_0x1D
	SUBI R26,LOW(-_sdt1)
	SBCI R27,HIGH(-_sdt1)
	RCALL __EEPROMRDB
	MOVW R26,R0
_0xE2:
	ST   X,R30
; 0000 0146         if(sdt2[i]==255) dt2[i]=0;
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_sdt2)
	SBCI R27,HIGH(-_sdt2)
	RCALL SUBOPT_0x1B
	BRNE _0x49
	RCALL SUBOPT_0x7
	MOVW R26,R28
	ADIW R26,12
	RCALL SUBOPT_0x1C
	RJMP _0xE3
; 0000 0147         else dt2[i]=sdt2[i];
_0x49:
	RCALL SUBOPT_0x7
	MOVW R26,R28
	ADIW R26,12
	RCALL SUBOPT_0x1D
	SUBI R26,LOW(-_sdt2)
	SBCI R27,HIGH(-_sdt2)
	RCALL __EEPROMRDB
	MOVW R26,R0
_0xE3:
	ST   X,R30
; 0000 0148         if(sdt3[i]==255) dt3[i]=0;
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_sdt3)
	SBCI R27,HIGH(-_sdt3)
	RCALL SUBOPT_0x1B
	BRNE _0x4B
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1C
	RJMP _0xE4
; 0000 0149         else dt3[i]=sdt3[i];
_0x4B:
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1D
	SUBI R26,LOW(-_sdt3)
	SBCI R27,HIGH(-_sdt3)
	RCALL __EEPROMRDB
	MOVW R26,R0
_0xE4:
	ST   X,R30
; 0000 014A    }
	SUBI R17,-1
	RJMP _0x45
_0x46:
; 0000 014B    while(i<11);
_0x4D:
	CPI  R17,11
	BRLO _0x4D
; 0000 014C    delay_ms(20);
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x3
; 0000 014D    if(callFlag==1)
	SBRS R2,0
	RJMP _0x50
; 0000 014E    {
; 0000 014F       if(strcmp(phoneNumber,dt1)==0||strcmp(phoneNumber,dt2)==0||strcmp(phoneNumber,dt3)==0) result=1;
	RCALL SUBOPT_0x1F
	MOVW R26,R28
	ADIW R26,25
	RCALL SUBOPT_0xD
	BREQ _0x52
	RCALL SUBOPT_0x1F
	MOVW R26,R28
	ADIW R26,14
	RCALL SUBOPT_0xD
	BREQ _0x52
	RCALL SUBOPT_0x1F
	MOVW R26,R28
	ADIW R26,3
	RCALL SUBOPT_0xD
	BRNE _0x51
_0x52:
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0150       else
	RJMP _0x54
_0x51:
; 0000 0151       {
; 0000 0152         result=0;
	CLR  R9
; 0000 0153       }
_0x54:
; 0000 0154    }
; 0000 0155 }
_0x50:
	LDD  R17,Y+0
	ADIW R28,34
	RET
; .FEND
;void callHandle()
; 0000 0157 {   unsigned char n=0;
_callHandle:
; .FSTART _callHandle
; 0000 0158     comparePhoneNumber();
	ST   -Y,R17
;	n -> R17
	LDI  R17,0
	RCALL _comparePhoneNumber
; 0000 0159     while(result==0)
_0x55:
	TST  R9
	BRNE _0x57
; 0000 015A     {
; 0000 015B        n++;
	SUBI R17,-1
; 0000 015C        printf(".");
	RCALL SUBOPT_0x11
; 0000 015D        delay_ms(50);
; 0000 015E        if(n>20)
	CPI  R17,21
	BRLO _0x58
; 0000 015F        {
; 0000 0160           printf("time out");
	__POINTW1FN _0x0,17
	RCALL SUBOPT_0x20
; 0000 0161           printf("ATH\r\n");
	__POINTW1FN _0x0,26
	RCALL SUBOPT_0x20
; 0000 0162           clearBuffer();
	RCALL SUBOPT_0x21
; 0000 0163           result=callFlag=0;
; 0000 0164           break;
	RJMP _0x57
; 0000 0165        }
; 0000 0166     }
_0x58:
	RJMP _0x55
_0x57:
; 0000 0167     if(result==1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x59
; 0000 0168     {
; 0000 0169         if(save1==1&&save2==1)
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x22
	BRNE _0x5B
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x22
	BREQ _0x5C
_0x5B:
	RJMP _0x5A
_0x5C:
; 0000 016A         {
; 0000 016B 
; 0000 016C             LOAD1=0;
	CBI  0x15,0
; 0000 016D             LOAD2=0;
	RCALL SUBOPT_0x23
; 0000 016E             save1=save2=0;
	RCALL SUBOPT_0x1
	RCALL __EEPROMWRB
; 0000 016F             printf("off");
	__POINTW1FN _0x0,32
	RJMP _0xE5
; 0000 0170             printf("ATH\r\n");
; 0000 0171             clearBuffer();
; 0000 0172             result=callFlag=0;
; 0000 0173         }
; 0000 0174         else
_0x5A:
; 0000 0175         {
; 0000 0176             LOAD1=1;
	SBI  0x15,0
; 0000 0177             LOAD2=1;
	RCALL SUBOPT_0x24
; 0000 0178             save1=save2=1;
	RCALL SUBOPT_0x1
	RCALL __EEPROMWRB
; 0000 0179             printf("on");
	__POINTW1FN _0x0,36
_0xE5:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 017A             printf("ATH\r\n");
	__POINTW1FN _0x0,26
	RCALL SUBOPT_0x20
; 0000 017B             clearBuffer();
	RCALL SUBOPT_0x21
; 0000 017C             result=callFlag=0;
; 0000 017D         }
; 0000 017E     }
; 0000 017F }
_0x59:
_0x2080003:
	LD   R17,Y+
	RET
; .FEND
;
;void smsHandle()
; 0000 0182 {
_smsHandle:
; .FSTART _smsHandle
; 0000 0183     char k,i1,i,poskey,i2,endstr=0,lastspace,firstspace,n=0;
; 0000 0184     char syntax[15];
; 0000 0185     char ndt1[11],ndt2[11],ndt3[11];
; 0000 0186     poskey=11;
	SBIW R28,51
	LDI  R30,LOW(0)
	STD  Y+48,R30
	RCALL __SAVELOCR6
;	k -> R17
;	i1 -> R16
;	i -> R19
;	poskey -> R18
;	i2 -> R21
;	endstr -> R20
;	lastspace -> Y+56
;	firstspace -> Y+55
;	n -> Y+54
;	syntax -> Y+39
;	ndt1 -> Y+28
;	ndt2 -> Y+17
;	ndt3 -> Y+6
	LDI  R20,0
	LDI  R18,LOW(11)
; 0000 0187     lastspace=strrpos(msgStr,32);
	RCALL SUBOPT_0x25
	RCALL _strrpos
	STD  Y+56,R30
; 0000 0188     firstspace=strpos(msgStr,32);
	RCALL SUBOPT_0x25
	RCALL _strpos
	STD  Y+55,R30
; 0000 0189     endstr=strrpos(msgStr,'.');
	LDI  R30,LOW(_msgStr)
	LDI  R31,HIGH(_msgStr)
	RCALL SUBOPT_0x26
	LDI  R26,LOW(46)
	RCALL _strrpos
	MOV  R20,R30
; 0000 018A 
; 0000 018B     for(i=0;i<endstr-5;i++)
	LDI  R19,LOW(0)
_0x67:
	MOV  R30,R20
	LDI  R31,0
	SBIW R30,5
	RCALL SUBOPT_0x18
	BRGE _0x68
; 0000 018C         {
; 0000 018D           content[i]=msgStr[5+i];
	MOV  R26,R19
	LDI  R27,0
	SUBI R26,LOW(-_content)
	SBCI R27,HIGH(-_content)
	MOV  R30,R19
	LDI  R31,0
	__ADDW1MN _msgStr,5
	LD   R30,Z
	ST   X,R30
; 0000 018E         }
	SUBI R19,-1
	RJMP _0x67
_0x68:
; 0000 018F     for(i2=0;i2<(lastspace-(firstspace+1));i2++)
	LDI  R21,LOW(0)
_0x6A:
	LDD  R26,Y+56
	CLR  R27
	LDD  R30,Y+55
	LDI  R31,0
	ADIW R30,1
	RCALL SUBOPT_0x16
	MOV  R26,R21
	LDI  R27,0
	RCALL SUBOPT_0x27
	BRGE _0x6B
; 0000 0190         {
; 0000 0191           syntax[i2]=msgStr[firstspace+1+i2];
	MOV  R30,R21
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,39
	RCALL SUBOPT_0x28
	MOVW R0,R30
	LDD  R30,Y+55
	LDI  R31,0
	RCALL SUBOPT_0xF
	MOV  R30,R21
	LDI  R31,0
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0xB
; 0000 0192         }
	SUBI R21,-1
	RJMP _0x6A
_0x6B:
; 0000 0193     for(i2=(lastspace-(firstspace+1));i2<15;i2++)
	LDD  R30,Y+55
	SUBI R30,-LOW(1)
	LDD  R26,Y+56
	SUB  R26,R30
	MOV  R21,R26
_0x6D:
	CPI  R21,15
	BRSH _0x6E
; 0000 0194         {
; 0000 0195             syntax[i2]=0;
	MOV  R30,R21
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,39
	RCALL SUBOPT_0x2A
; 0000 0196         }
	SUBI R21,-1
	RJMP _0x6D
_0x6E:
; 0000 0197     if(msgStr[0]=='c' && msgStr[1]=='t' && msgStr[2]=='a' && msgStr[3]=='G')
	LDS  R26,_msgStr
	CPI  R26,LOW(0x63)
	BRNE _0x70
	__GETB2MN _msgStr,1
	CPI  R26,LOW(0x74)
	BRNE _0x70
	__GETB2MN _msgStr,2
	CPI  R26,LOW(0x61)
	BRNE _0x70
	__GETB2MN _msgStr,3
	CPI  R26,LOW(0x47)
	BREQ _0x71
_0x70:
	RJMP _0x6F
_0x71:
; 0000 0198     {
; 0000 0199       char rs;
; 0000 019A       for(rs=0;rs<4;rs++)
	SBIW R28,1
;	lastspace -> Y+57
;	firstspace -> Y+56
;	n -> Y+55
;	syntax -> Y+40
;	ndt1 -> Y+29
;	ndt2 -> Y+18
;	ndt3 -> Y+7
;	rs -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0x73:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRSH _0x74
; 0000 019B       {
; 0000 019C         password[rs]='0';
	LDI  R27,0
	SUBI R26,LOW(-_password)
	SBCI R27,HIGH(-_password)
	RCALL SUBOPT_0x2B
; 0000 019D       }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x73
_0x74:
; 0000 019E       printf("reset success");
	__POINTW1FN _0x0,39
	RCALL SUBOPT_0x20
; 0000 019F       clearBuffer();
	RCALL SUBOPT_0x2C
; 0000 01A0       smsFlag=0;
; 0000 01A1     }
	ADIW R28,1
; 0000 01A2     checkPassword();
_0x6F:
	RCALL _checkPassword
; 0000 01A3     while(checkpass==0)
_0x75:
	TST  R6
	BRNE _0x77
; 0000 01A4     {  checkPassword();
	RCALL _checkPassword
; 0000 01A5        n++;
	LDD  R30,Y+54
	SUBI R30,-LOW(1)
	STD  Y+54,R30
; 0000 01A6        delay_ms(50);
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x3
; 0000 01A7        if(n>40)
	LDD  R26,Y+54
	CPI  R26,LOW(0x29)
	BRLO _0x78
; 0000 01A8        {
; 0000 01A9          printf("password error");
	__POINTW1FN _0x0,53
	RCALL SUBOPT_0x20
; 0000 01AA          clearBuffer();
	RCALL _clearBuffer
; 0000 01AB          checkpass=0;
	CLR  R6
; 0000 01AC          smsFlag=0;
	RCALL SUBOPT_0x2D
; 0000 01AD          break;
	RJMP _0x77
; 0000 01AE        }
; 0000 01AF     }
_0x78:
	RJMP _0x75
_0x77:
; 0000 01B0     if(checkpass==1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x79
; 0000 01B1     {
; 0000 01B2         if(strcmp(content,"on1")==0)
	RCALL SUBOPT_0x2E
	__POINTW2MN _0x7B,0
	RCALL SUBOPT_0xD
	BRNE _0x7A
; 0000 01B3         {
; 0000 01B4           LOAD1=1;
	SBI  0x15,0
; 0000 01B5           save1=1;
	RCALL SUBOPT_0x1
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x2F
; 0000 01B6           //printf("on1");
; 0000 01B7           clearBuffer();
; 0000 01B8           smsFlag=0;
; 0000 01B9 
; 0000 01BA         }else{
	RJMP _0x7E
_0x7A:
; 0000 01BB            if(strcmp(content,"on2")==0)
	RCALL SUBOPT_0x2E
	__POINTW2MN _0x7B,4
	RCALL SUBOPT_0xD
	BRNE _0x7F
; 0000 01BC             {
; 0000 01BD               LOAD2=1;
	RCALL SUBOPT_0x24
; 0000 01BE               save2=1;
; 0000 01BF               //printf("on2");
; 0000 01C0               clearBuffer();
	RCALL SUBOPT_0x2C
; 0000 01C1               smsFlag=0;
; 0000 01C2             }else{
	RJMP _0x82
_0x7F:
; 0000 01C3                 if(strcmp(content,"off1")==0)
	RCALL SUBOPT_0x2E
	__POINTW2MN _0x7B,8
	RCALL SUBOPT_0xD
	BRNE _0x83
; 0000 01C4                 {
; 0000 01C5                   LOAD1=0;
	CBI  0x15,0
; 0000 01C6                   save1=0;
	RCALL SUBOPT_0x1
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x2F
; 0000 01C7                   //printf("off1");
; 0000 01C8                   clearBuffer();
; 0000 01C9                   smsFlag=0;
; 0000 01CA                 } else{
	RJMP _0x86
_0x83:
; 0000 01CB 
; 0000 01CC                     if(strcmp(content,"off2")==0)
	RCALL SUBOPT_0x2E
	__POINTW2MN _0x7B,13
	RCALL SUBOPT_0xD
	BRNE _0x87
; 0000 01CD                     {
; 0000 01CE                       LOAD2=0;
	RCALL SUBOPT_0x23
; 0000 01CF                       save2=0;
; 0000 01D0                       //printf("off2");
; 0000 01D1                       clearBuffer();
	RCALL SUBOPT_0x2C
; 0000 01D2                       smsFlag=0;
; 0000 01D3                     }else {
	RJMP _0x8A
_0x87:
; 0000 01D4 
; 0000 01D5                         if(strcmp(content,"on")==0)
	RCALL SUBOPT_0x2E
	__POINTW2MN _0x7B,18
	RCALL SUBOPT_0xD
	BRNE _0x8B
; 0000 01D6                         {
; 0000 01D7                           LOAD1=1;
	SBI  0x15,0
; 0000 01D8                           LOAD2=1;
	SBI  0x15,1
; 0000 01D9                           save1=1;
	RCALL SUBOPT_0x1
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 01DA                           save2=1;
	RCALL SUBOPT_0x2
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x2F
; 0000 01DB                           //printf("on");
; 0000 01DC                           clearBuffer();
; 0000 01DD                           smsFlag=0;
; 0000 01DE                         }else{
	RJMP _0x90
_0x8B:
; 0000 01DF 
; 0000 01E0                             if(strcmp(content,"off")==0)
	RCALL SUBOPT_0x2E
	__POINTW2MN _0x7B,21
	RCALL SUBOPT_0xD
	BRNE _0x91
; 0000 01E1                             {
; 0000 01E2                               LOAD1=0;
	CBI  0x15,0
; 0000 01E3                               LOAD2=0;
	CBI  0x15,1
; 0000 01E4                               save1=0;
	RCALL SUBOPT_0x1
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 01E5                               save2=0;
	RCALL SUBOPT_0x2
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x2F
; 0000 01E6                               //printf("off");
; 0000 01E7                               clearBuffer();
; 0000 01E8                               smsFlag=0;
; 0000 01E9                             }
; 0000 01EA                             else
	RJMP _0x96
_0x91:
; 0000 01EB                             {
; 0000 01EC                               if(strcmp(syntax,"doimk")==0)
	RCALL SUBOPT_0x30
	__POINTW2MN _0x7B,25
	RCALL SUBOPT_0xD
	BRNE _0x97
; 0000 01ED                                 {
; 0000 01EE                                   for(k=0;k<4;k++)
	LDI  R17,LOW(0)
_0x99:
	CPI  R17,4
	BRSH _0x9A
; 0000 01EF                                   {
; 0000 01F0                                     password[k]=msgStr[poskey+k];
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_password)
	SBCI R31,HIGH(-_password)
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x29
	MOVW R26,R0
	RCALL __EEPROMWRB
; 0000 01F1                                   }
	SUBI R17,-1
	RJMP _0x99
_0x9A:
; 0000 01F2                                   //sendSMS(phoneNumber,"Doi mat khau thanh cong");
; 0000 01F3                                   printf("success:");
	__POINTW1FN _0x0,92
	RCALL SUBOPT_0x20
; 0000 01F4                                   putchar(password[0]);
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	RCALL SUBOPT_0x32
; 0000 01F5                                   putchar(password[1]);
	__POINTW2MN _password,1
	RCALL SUBOPT_0x32
; 0000 01F6                                   putchar(password[2]);
	__POINTW2MN _password,2
	RCALL SUBOPT_0x32
; 0000 01F7                                   putchar(password[3]);
	__POINTW2MN _password,3
	RCALL SUBOPT_0x32
; 0000 01F8                                   clearBuffer();
	RCALL SUBOPT_0x2C
; 0000 01F9                                   smsFlag=0;
; 0000 01FA 
; 0000 01FB                                 }
; 0000 01FC                                 else
	RJMP _0x9B
_0x97:
; 0000 01FD                                 {
; 0000 01FE                                   if(strcmp(syntax,"them1")==0)
	RCALL SUBOPT_0x30
	__POINTW2MN _0x7B,31
	RCALL SUBOPT_0xD
	BRNE _0x9C
; 0000 01FF                                   {
; 0000 0200                                     for(i1=0;i1<11;i1++)
	LDI  R16,LOW(0)
_0x9E:
	CPI  R16,11
	BRSH _0x9F
; 0000 0201                                     {
; 0000 0202                                       if(msgStr[poskey+i1]<48||msgStr[poskey+i1]>57) sdt1[i1]=ndt1[i1]=0;
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x34
	BRLO _0xA1
	RCALL SUBOPT_0x35
	BRLO _0xA0
_0xA1:
	RCALL SUBOPT_0x15
	SUBI R30,LOW(-_sdt1)
	SBCI R31,HIGH(-_sdt1)
	MOVW R0,R30
	RCALL SUBOPT_0x15
	MOVW R26,R28
	ADIW R26,28
	RCALL SUBOPT_0x2A
	MOVW R26,R0
	RJMP _0xE6
; 0000 0203                                       else sdt1[i1]=ndt1[i1]=msgStr[poskey+i1];
_0xA0:
	RCALL SUBOPT_0x15
	SUBI R30,LOW(-_sdt1)
	SBCI R31,HIGH(-_sdt1)
	MOVW R22,R30
	RCALL SUBOPT_0x15
	MOVW R26,R28
	ADIW R26,28
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0xB
	MOVW R26,R22
_0xE6:
	RCALL __EEPROMWRB
; 0000 0204                                     }
	SUBI R16,-1
	RJMP _0x9E
_0x9F:
; 0000 0205                                     while(i1<11);
_0xA4:
	CPI  R16,11
	BRLO _0xA4
; 0000 0206                                     printf("sdt1:");
	__POINTW1FN _0x0,107
	RCALL SUBOPT_0x20
; 0000 0207                                     puts(ndt1);
	MOVW R26,R28
	ADIW R26,28
	RCALL SUBOPT_0x19
; 0000 0208                                     clearBuffer();
; 0000 0209                                     smsFlag=0;
	RCALL SUBOPT_0x2D
; 0000 020A                                   }
; 0000 020B                                   else
	RJMP _0xA7
_0x9C:
; 0000 020C                                   {
; 0000 020D                                      if(strcmp(syntax,"them2")==0)
	RCALL SUBOPT_0x30
	__POINTW2MN _0x7B,37
	RCALL SUBOPT_0xD
	BRNE _0xA8
; 0000 020E                                       {
; 0000 020F                                         for(i1=0;i1<11;i1++)
	LDI  R16,LOW(0)
_0xAA:
	CPI  R16,11
	BRSH _0xAB
; 0000 0210                                         {
; 0000 0211                                           if(msgStr[poskey+i1]<48||msgStr[poskey+i1]>57) sdt2[i1]=ndt2[i1]=0;
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x34
	BRLO _0xAD
	RCALL SUBOPT_0x35
	BRLO _0xAC
_0xAD:
	RCALL SUBOPT_0x15
	SUBI R30,LOW(-_sdt2)
	SBCI R31,HIGH(-_sdt2)
	MOVW R0,R30
	RCALL SUBOPT_0x15
	MOVW R26,R28
	ADIW R26,17
	RCALL SUBOPT_0x2A
	MOVW R26,R0
	RJMP _0xE7
; 0000 0212                                           else sdt2[i1]=ndt2[i1]=msgStr[poskey+i1];
_0xAC:
	RCALL SUBOPT_0x15
	SUBI R30,LOW(-_sdt2)
	SBCI R31,HIGH(-_sdt2)
	MOVW R22,R30
	RCALL SUBOPT_0x15
	MOVW R26,R28
	ADIW R26,17
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0xB
	MOVW R26,R22
_0xE7:
	RCALL __EEPROMWRB
; 0000 0213                                         }
	SUBI R16,-1
	RJMP _0xAA
_0xAB:
; 0000 0214                                         while(i1<11);
_0xB0:
	CPI  R16,11
	BRLO _0xB0
; 0000 0215                                         printf("\nsdt2:");
	__POINTW1FN _0x0,119
	RCALL SUBOPT_0x20
; 0000 0216                                         puts(ndt2);
	MOVW R26,R28
	ADIW R26,17
	RCALL SUBOPT_0x19
; 0000 0217                                         clearBuffer();
; 0000 0218                                         smsFlag=0;
	RCALL SUBOPT_0x2D
; 0000 0219                                       }
; 0000 021A                                       else
	RJMP _0xB3
_0xA8:
; 0000 021B                                       {
; 0000 021C                                          if(strcmp(syntax,"them3")==0)
	RCALL SUBOPT_0x30
	__POINTW2MN _0x7B,43
	RCALL SUBOPT_0xD
	BRNE _0xB4
; 0000 021D                                           {
; 0000 021E                                             for(i1=0;i1<11;i1++)
	LDI  R16,LOW(0)
_0xB6:
	CPI  R16,11
	BRSH _0xB7
; 0000 021F                                             {
; 0000 0220                                               if(msgStr[poskey+i1]<48||msgStr[poskey+i1]>57) sdt3[i1]=ndt3[i1]=0;
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x34
	BRLO _0xB9
	RCALL SUBOPT_0x35
	BRLO _0xB8
_0xB9:
	RCALL SUBOPT_0x15
	SUBI R30,LOW(-_sdt3)
	SBCI R31,HIGH(-_sdt3)
	MOVW R0,R30
	RCALL SUBOPT_0x15
	MOVW R26,R28
	ADIW R26,6
	RCALL SUBOPT_0x2A
	MOVW R26,R0
	RJMP _0xE8
; 0000 0221                                               else sdt3[i1]=ndt3[i1]=msgStr[poskey+i1];
_0xB8:
	RCALL SUBOPT_0x15
	SUBI R30,LOW(-_sdt3)
	SBCI R31,HIGH(-_sdt3)
	MOVW R22,R30
	RCALL SUBOPT_0x15
	MOVW R26,R28
	ADIW R26,6
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0xB
	MOVW R26,R22
_0xE8:
	RCALL __EEPROMWRB
; 0000 0222                                             }
	SUBI R16,-1
	RJMP _0xB6
_0xB7:
; 0000 0223                                             while(i1<11);
_0xBC:
	CPI  R16,11
	BRLO _0xBC
; 0000 0224                                             printf("sdt3:");
	__POINTW1FN _0x0,132
	RCALL SUBOPT_0x20
; 0000 0225                                             puts(ndt3);
	MOVW R26,R28
	ADIW R26,6
	RCALL SUBOPT_0x19
; 0000 0226                                             clearBuffer();
; 0000 0227                                             smsFlag=0;
	RCALL SUBOPT_0x2D
; 0000 0228                                           }
; 0000 0229                                           else
	RJMP _0xBF
_0xB4:
; 0000 022A                                           {
; 0000 022B                                                if(strcmp(content,"kttk")==0)
	RCALL SUBOPT_0x2E
	__POINTW2MN _0x7B,49
	RCALL SUBOPT_0xD
	BRNE _0xC0
; 0000 022C                                                {
; 0000 022D                                                  KTTK();
	RCALL _KTTK
; 0000 022E                                                  clearBuffer();
	RCALL SUBOPT_0x2C
; 0000 022F                                                  smsFlag=0;
; 0000 0230                                                }
; 0000 0231                                                else
	RJMP _0xC1
_0xC0:
; 0000 0232                                                {
; 0000 0233                                                  if(strcmp(syntax,"naptien")==0)
	RCALL SUBOPT_0x30
	__POINTW2MN _0x7B,54
	RCALL SUBOPT_0xD
	BRNE _0xC2
; 0000 0234                                                  {  char mathe[13];
; 0000 0235                                                     char mt;
; 0000 0236                                                     for(mt=0;mt<13;mt++)
	SBIW R28,14
;	lastspace -> Y+70
;	firstspace -> Y+69
;	n -> Y+68
;	syntax -> Y+53
;	ndt1 -> Y+42
;	ndt2 -> Y+31
;	ndt3 -> Y+20
;	mathe -> Y+1
;	mt -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0xC4:
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRSH _0xC5
; 0000 0237                                                     {
; 0000 0238                                                       if(msgStr[13+mt]<48||msgStr[13+mt]>57) mathe[mt]='0';
	RCALL SUBOPT_0x36
	__ADDW1MN _msgStr,13
	LD   R26,Z
	CPI  R26,LOW(0x30)
	BRLO _0xC7
	RCALL SUBOPT_0x35
	BRLO _0xC6
_0xC7:
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x1E
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(48)
	RJMP _0xE9
; 0000 0239                                                       else mathe[mt]=msgStr[13+mt];
_0xC6:
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x1E
	ADD  R26,R30
	ADC  R27,R31
	RCALL SUBOPT_0x36
	__ADDW1MN _msgStr,13
	LD   R30,Z
_0xE9:
	ST   X,R30
; 0000 023A                                                     }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xC4
_0xC5:
; 0000 023B                                                     naptien(mathe);
	RCALL SUBOPT_0x1E
	RCALL _naptien
; 0000 023C                                                     clearBuffer();
	RCALL SUBOPT_0x2C
; 0000 023D                                                     smsFlag=0;
; 0000 023E                                                  }
	ADIW R28,14
; 0000 023F                                                }
_0xC2:
_0xC1:
; 0000 0240                                           }
_0xBF:
; 0000 0241                                       }
_0xB3:
; 0000 0242                                   }
_0xA7:
; 0000 0243                                 }
_0x9B:
; 0000 0244                             }
_0x96:
; 0000 0245                         }
_0x90:
; 0000 0246                     }
_0x8A:
; 0000 0247                 }
_0x86:
; 0000 0248             }
_0x82:
; 0000 0249         }
_0x7E:
; 0000 024A     }
; 0000 024B }
_0x79:
	RCALL __LOADLOCR6
	ADIW R28,57
	RET
; .FEND

	.DSEG
_0x7B:
	.BYTE 0x3E
;
;
;void main(void)
; 0000 024F {

	.CSEG
_main:
; .FSTART _main
; 0000 0250 // Declare your local variables here
; 0000 0251 
; 0000 0252 // Input/Output Ports initialization
; 0000 0253 // Port B initialization
; 0000 0254 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0255 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0256 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0257 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0258 
; 0000 0259 // Port C initialization
; 0000 025A // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out
; 0000 025B DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(3)
	OUT  0x14,R30
; 0000 025C // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0
; 0000 025D PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 025E 
; 0000 025F // Port D initialization
; 0000 0260 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=In
; 0000 0261 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 0262 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=0 Bit0=T
; 0000 0263 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 0264 
; 0000 0265 // Timer/Counter 0 initialization
; 0000 0266 // Clock source: System Clock
; 0000 0267 // Clock value: 0.977 kHz
; 0000 0268 //0.26214s
; 0000 0269 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 026A TCNT0=0x00;
	OUT  0x32,R30
; 0000 026B 
; 0000 026C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 026D TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 026E 
; 0000 026F // External Interrupt(s) initialization
; 0000 0270 // INT0: On
; 0000 0271 // INT0 Mode: Falling Edge
; 0000 0272 // INT1: On
; 0000 0273 // INT1 Mode: Falling Edge
; 0000 0274 GICR|=(1<<INT1) | (1<<INT0);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 0275 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0276 GIFR=(1<<INTF1) | (1<<INTF0);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0277 
; 0000 0278 // USART initialization
; 0000 0279 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 027A // USART Receiver: On
; 0000 027B // USART Transmitter: On
; 0000 027C // USART Mode: Asynchronous
; 0000 027D // USART Baud Rate: 9600 (Double Speed Mode)
; 0000 027E UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (1<<U2X) | (1<<MPCM);
	LDI  R30,LOW(3)
	OUT  0xB,R30
; 0000 027F UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0280 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0281 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0282 UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 0283 
; 0000 0284 
; 0000 0285 // Global enable interrupts
; 0000 0286 #asm("sei")
	sei
; 0000 0287 while(strpos(rx_buffer,'O')<0)
_0xCA:
	RCALL SUBOPT_0xE
	LDI  R26,LOW(79)
	RCALL _strpos
	TST  R31
	BRPL _0xCC
; 0000 0288 {
; 0000 0289     printf("AT\r\n");
	__POINTW1FN _0x0,151
	RCALL SUBOPT_0x20
; 0000 028A     printf(DISABLE_ECHO);
	__POINTW1FN _0x0,156
	RCALL SUBOPT_0x20
; 0000 028B     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 028C     if(strpos(rx_buffer,'O')<0) clearBuffer();
	RCALL SUBOPT_0xE
	LDI  R26,LOW(79)
	RCALL _strpos
	TST  R31
	BRPL _0xCD
	RCALL _clearBuffer
; 0000 028D }
_0xCD:
	RJMP _0xCA
_0xCC:
; 0000 028E printf(FORMAT_SMS_TEXT);
	__POINTW1FN _0x0,163
	RCALL SUBOPT_0x20
; 0000 028F delay_ms(200);
	RCALL SUBOPT_0x37
; 0000 0290 printf(DISABLE_ECHO);
	__POINTW1FN _0x0,156
	RCALL SUBOPT_0x20
; 0000 0291 delay_ms(200);
	RCALL SUBOPT_0x37
; 0000 0292 printf(READ_WHEN_NEWSMS);
	__POINTW1FN _0x0,175
	RCALL SUBOPT_0x20
; 0000 0293 delay_ms(200);
	RCALL SUBOPT_0x37
; 0000 0294 printf(ENABLE_USSD);
	__POINTW1FN _0x0,195
	RCALL SUBOPT_0x20
; 0000 0295 delay_ms(200);
	RCALL SUBOPT_0x37
; 0000 0296 printf(DELETE_ALL_MSG);
	__POINTW1FN _0x0,207
	RCALL SUBOPT_0x20
; 0000 0297 delay_ms(200);
	RCALL SUBOPT_0x37
; 0000 0298 if(begin==255)
	LDI  R26,LOW(_begin)
	LDI  R27,HIGH(_begin)
	RCALL SUBOPT_0x1B
	BRNE _0xCE
; 0000 0299 {
; 0000 029A 
; 0000 029B   password[0]='0';
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	RCALL SUBOPT_0x2B
; 0000 029C   password[1]='0';
	__POINTW2MN _password,1
	RCALL SUBOPT_0x2B
; 0000 029D   password[2]='0';
	__POINTW2MN _password,2
	RCALL SUBOPT_0x2B
; 0000 029E   password[3]='0';
	__POINTW2MN _password,3
	RCALL SUBOPT_0x2B
; 0000 029F   begin=0;
	LDI  R26,LOW(_begin)
	LDI  R27,HIGH(_begin)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 02A0 }
; 0000 02A1 if(save1==1) LOAD1=1;
_0xCE:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x22
	BRNE _0xCF
	SBI  0x15,0
; 0000 02A2 else LOAD1=0;
	RJMP _0xD2
_0xCF:
	CBI  0x15,0
; 0000 02A3 if(save2==1) LOAD2=1;
_0xD2:
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x22
	BRNE _0xD5
	SBI  0x15,1
; 0000 02A4 else LOAD2=0;
	RJMP _0xD8
_0xD5:
	CBI  0x15,1
; 0000 02A5 clearBuffer();
_0xD8:
	RCALL _clearBuffer
; 0000 02A6 sendSMS("109","hhhhhh");
	__POINTW1MN _0xDB,0
	RCALL SUBOPT_0x26
	__POINTW2MN _0xDB,4
	RCALL _sendSMS
; 0000 02A7 while (1)
_0xDC:
; 0000 02A8       {     if(flag) strHandle();
	TST  R4
	BREQ _0xDF
	RCALL _strHandle
; 0000 02A9       }
_0xDF:
	RJMP _0xDC
; 0000 02AA }
_0xE0:
	RJMP _0xE0
; .FEND

	.DSEG
_0xDB:
	.BYTE 0xB
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
	RCALL SUBOPT_0x38
	ST   -Y,R17
_0x2000003:
	RCALL SUBOPT_0x39
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
	RCALL SUBOPT_0x38
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
	RCALL SUBOPT_0x38
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
	RCALL SUBOPT_0x3A
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x3A
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
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3B
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x3D
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3F
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3F
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
	RCALL SUBOPT_0x40
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
	RCALL SUBOPT_0x40
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x41
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
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x41
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
	RCALL SUBOPT_0x3A
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
	RCALL SUBOPT_0x40
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x3A
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
	RCALL SUBOPT_0x40
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x27
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
	RCALL SUBOPT_0x3D
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x3A
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
	RCALL SUBOPT_0x3D
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
	RCALL SUBOPT_0x26
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	RCALL SUBOPT_0x26
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
	RCALL SUBOPT_0x38
	ST   -Y,R17
	__POINTW1FN _0x2020000,7
	RCALL SUBOPT_0x20
	LDI  R26,LOW(34)
	RCALL _putchar
	LDI  R17,LOW(0)
_0x2020007:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL _strlen
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x27
	BRSH _0x2020008
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL SUBOPT_0x42
	SUBI R17,-1
	RJMP _0x2020007
_0x2020008:
	LDI  R26,LOW(34)
	RCALL _putchar
	__POINTW1FN _0x2020000,5
	RCALL SUBOPT_0x20
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x39
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
	__POINTW1FN _0x2020000,16
	RCALL SUBOPT_0x20
	__POINTW1FN _0x2020000,28
	RCALL SUBOPT_0x20
	RET
; .FEND
_naptien:
; .FSTART _naptien
	RCALL SUBOPT_0x38
	ST   -Y,R17
	__POINTW1FN _0x2020000,16
	RCALL SUBOPT_0x20
	__POINTW1FN _0x2020000,40
	RCALL SUBOPT_0x20
	LDI  R17,LOW(0)
_0x202000A:
	RCALL SUBOPT_0x39
	RCALL _strlen
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x27
	BRSH _0x202000B
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x42
	SUBI R17,-1
	RJMP _0x202000A
_0x202000B:
	__POINTW1FN _0x2020000,35
	RCALL SUBOPT_0x20
_0x2080002:
	LDD  R17,Y+0
_0x2080001:
	ADIW R28,3
	RET
; .FEND

	.CSEG
_strcmp:
; .FSTART _strcmp
	RCALL SUBOPT_0x38
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
	RCALL SUBOPT_0x38
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
	RCALL SUBOPT_0x38
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
_content:
	.BYTE 0x5
_type:
	.BYTE 0x4
_phoneNumber:
	.BYTE 0xB
_phoneNumberSms:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_save1)
	LDI  R27,HIGH(_save1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_save2)
	LDI  R27,HIGH(_save2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R30,_tx_counter
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(_type)
	LDI  R31,HIGH(_type)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xD:
	RCALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:31 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x11:
	__POINTW1FN _0x0,15
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	LDI  R26,LOW(50)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	__POINTW1FN _0x0,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	RJMP _clearBuffer

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(34)
	RJMP _strpos

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x15:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	MOV  R26,R16
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	MOV  R26,R19
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	RCALL _puts
	RJMP _clearBuffer

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	RCALL __EEPROMRDB
	CPI  R30,LOW(0xFF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	ADD  R30,R26
	ADC  R31,R27
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	MOVW R26,R28
	ADIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(_phoneNumber)
	LDI  R31,HIGH(_phoneNumber)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:86 WORDS
SUBOPT_0x20:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	RCALL _clearBuffer
	CLT
	BLD  R2,0
	CLR  R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	CBI  0x15,1
	RCALL SUBOPT_0x2
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	SBI  0x15,1
	RCALL SUBOPT_0x2
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(_msgStr)
	LDI  R31,HIGH(_msgStr)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(32)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x26:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x8
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(48)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x2C:
	RCALL _clearBuffer
	CLT
	BLD  R2,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	CLT
	BLD  R2,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(_content)
	LDI  R31,HIGH(_content)
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	RCALL __EEPROMWRB
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x30:
	MOVW R30,R28
	ADIW R30,39
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x31:
	MOVW R0,R30
	MOV  R26,R18
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x32:
	RCALL __EEPROMRDB
	MOV  R26,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x33:
	MOV  R26,R18
	CLR  R27
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x34:
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x8
	LD   R26,Z
	CPI  R26,LOW(0x30)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LD   R26,Z
	CPI  R26,LOW(0x3A)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x37:
	LDI  R26,LOW(200)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3A:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3C:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3D:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	RCALL SUBOPT_0x3B
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
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
SUBOPT_0x40:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x42:
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RJMP _putchar


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
