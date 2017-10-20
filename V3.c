/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/14/2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
#include <stdio.h>
#include <sim800AT.h>
#include <string.h>
#include <delay.h>


#define LOAD1   PORTC.0
#define LOAD2   PORTC.1
#define strCall     1
#define strSms      2
char content[5];  
char qtyNum=10;
char type[4];
char phoneNumber[11];
char phoneNumberSms[11];
char msgStr[100];

eeprom char sdt1[11];
eeprom char sdt2[11];
eeprom char sdt3[11];


eeprom char save1,save2,begin;
eeprom char password[4];

char flag,rxStatus,checkpass,result=0;
bit callFlag=0,smsFlag=0;
// Declare your global variables here


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
 LOAD1=~LOAD1;
 save1=~save1;
 delay_ms(20);

}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
LOAD2=~LOAD2;
save2=~save2;
    delay_ms(20);

}

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Receiver buffer
#define RX_BUFFER_SIZE 250
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif

#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   { 
   rx_buffer[rx_wr_index++]=data;  
   flag=1;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 150
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index=0,tx_rd_index=0;
#else
unsigned int tx_wr_index=0,tx_rd_index=0;
#endif

#if TX_BUFFER_SIZE < 256
unsigned char tx_counter=0;
#else
unsigned int tx_counter=0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

void clearBuffer()
{   char i;

    for(i=0;i<rx_wr_index;i++)
    {
        rx_buffer[i]=msgStr[i]=phoneNumber[i]=phoneNumberSms[i]=content[i]=type[i]=0;
    } 
    rx_wr_index=0;   
    checkpass=0;
    result=0;
    flag=0; 

    
}
/****************************************************************
   content return from sim:
   - call:  RING

            +CLIP: "0964444373",161,"",0,"",0
            
   -sms: +CMT: "+84964444373","","17/10/14,15:04:39+28" 
                #0000 on   
   -kttk: +CUSD: 0, "TK goc la 12d. De biet cac CT dac biet cua Quy khach, bam goi *098#.", 15

******************************************************************/
void comparePhoneNumber(); 
void callHandle();
void smsHandle();
void strHandle()
{
    char i,k,l,pos,e=0,n=0;
            while(strcmp(type,"CLIP")!=0 && strcmp(type,"CMT:")!=0 && strcmp(type,"CUSD")!=0)
            {
                for(i=0;i<4;i++) 
                {
                    type[i]=rx_buffer[strpos(rx_buffer,'+')+1+i];
                }
                e++;
                printf(".");
                delay_ms(50);
                if(e>20)
                { 
                  printf("time out");
                  clearBuffer();
                  break;
                }
            }   
            if(strcmp(type,"CLIP")==0)  //call
            {   
                rxStatus=strCall;
                pos=strpos(rx_buffer,34); // "  // 
                if(rx_buffer[pos+11]==34) qtyNum=10;
                else qtyNum=11;  
                for(k=0;k<qtyNum;k++)
                {
                   phoneNumber[k]=rx_buffer[pos+1+k];
                }
                callFlag=1; 
                if(callFlag)callHandle();
                       
            }
            else  //sms
            {
               if(strcmp(type,"CMT:")==0)
               {    //"+84964444373", ":0 ,:14-15   
                    rxStatus=strSms; 
                    while(strpos(rx_buffer,'.')<=0)
                    {
                       n++;
                       printf(".");
                       delay_ms(50);
                       if(n>20)
                       {
                         printf("time out");
                         clearBuffer();
                         break;
                       }
                    } 
                    if(strcmp(type,"CMT:")==0)
                    {
                        pos=strpos(rx_buffer,'#');
                        if(pos>0)
                        {   
                            for(k=0;k<strpos(rx_buffer,'.')-pos;k++)
                            {
                                msgStr[k]=rx_buffer[pos+1+k];
                            } 
                            for(l=1;l<(strpos(rx_buffer,',')-strpos(rx_buffer,34)-4);l++)
                            {
                                phoneNumberSms[0]='0'; 
                                phoneNumberSms[l]=rx_buffer[strpos(rx_buffer,34)+3+l];
                            }
                            smsFlag=1;     
                            //puts(msgStr);
                            if(smsFlag) smsHandle();   
                        }
                    }
                  
               }
               else 
               {//+CUSD: 0, "TK goc la 12d. De biet cac CT dac biet cua Quy khach, bam goi *098#.", 15
                    if(strcmp(type,"CUSD")==0)
                    {
                       pos=strpos(rx_buffer,34);
                       for(k=0;k<(strrpos(rx_buffer,34)-pos-1);k++)
                       {
                         msgStr[k]=rx_buffer[pos+1+k];
                       }
                       puts(msgStr);
                       clearBuffer();
                    }
                      
                
               }
            } 
         
}
void checkPassword()
{  
   if(msgStr[0]==password[0]&&msgStr[1]==password[1]&&msgStr[2]==password[2]&&msgStr[3]==password[3]) checkpass=1;  
   else
   {
    checkpass=0;
   }
}
void comparePhoneNumber()
{  char dt1[11],dt2[11],dt3[11];
   char i;
   for(i=0;i<11;i++)
   {
        if(sdt1[i]==255) dt1[i]=0; 
        else dt1[i]=sdt1[i]; 
        if(sdt2[i]==255) dt2[i]=0; 
        else dt2[i]=sdt2[i];  
        if(sdt3[i]==255) dt3[i]=0; 
        else dt3[i]=sdt3[i];     
   }
   while(i<11);
   delay_ms(20);
   if(callFlag==1)
   {
      if(strcmp(phoneNumber,dt1)==0||strcmp(phoneNumber,dt2)==0||strcmp(phoneNumber,dt3)==0) result=1;
      else 
      {
        result=0;
      }    
   }  
}
void callHandle()
{   unsigned char n=0;
    comparePhoneNumber();
    while(result==0)
    {
       n++;
       printf(".");
       delay_ms(50);
       if(n>20)
       {
          printf("time out"); 
          printf("ATH\r\n"); 
          clearBuffer(); 
          result=callFlag=0;  
          break;
       }
    }
    if(result==1)
    {
        if(save1==1&&save2==1)
        {   
                        
            LOAD1=0;
            LOAD2=0;
            save1=save2=0; 
            printf("off");
            printf("ATH\r\n"); 
            clearBuffer(); 
            result=callFlag=0; 
        }
        else
        {    
            LOAD1=1;
            LOAD2=1;
            save1=save2=1; 
            printf("on");
            printf("ATH\r\n");
            clearBuffer(); 
            result=callFlag=0; 
        }
    }        
}

void smsHandle()
{   
    char k,i1,i,poskey,i2,endstr=0,lastspace,firstspace,n=0;
    char syntax[15];  
    char ndt1[11],ndt2[11],ndt3[11]; 
    poskey=11; 
    lastspace=strrpos(msgStr,32); 
    firstspace=strpos(msgStr,32);
    endstr=strrpos(msgStr,'.'); 
    
    for(i=0;i<endstr-5;i++)
        {
          content[i]=msgStr[5+i];
        } 
    for(i2=0;i2<(lastspace-(firstspace+1));i2++)
        {
          syntax[i2]=msgStr[firstspace+1+i2];
        }
    for(i2=(lastspace-(firstspace+1));i2<15;i2++)
        {
            syntax[i2]=0;
        }
    if(msgStr[0]=='c' && msgStr[1]=='t' && msgStr[2]=='a' && msgStr[3]=='G')
    {
      char rs;
      for(rs=0;rs<4;rs++)
      {
        password[rs]='0';
      }  
      printf("reset success");
      clearBuffer();
      smsFlag=0;
    }  
    checkPassword(); 
    while(checkpass==0)
    {  checkPassword();
       n++;
       delay_ms(50);
       if(n>40)
       {
         printf("password error");
         clearBuffer(); 
         checkpass=0;
         smsFlag=0;
         break;
       }
    } 
    if(checkpass==1)
    {     
        if(strcmp(content,"on1")==0)
        {
          LOAD1=1;
          save1=1; 
          //printf("on1"); 
          clearBuffer();
          smsFlag=0;
          
        }else{
           if(strcmp(content,"on2")==0)
            {
              LOAD2=1;
              save2=1;  
              //printf("on2"); 
              clearBuffer();
              smsFlag=0;
            }else{
                if(strcmp(content,"off1")==0)
                {
                  LOAD1=0;
                  save1=0; 
                  //printf("off1");  
                  clearBuffer();
                  smsFlag=0;
                } else{
                    
                    if(strcmp(content,"off2")==0)
                    {
                      LOAD2=0;
                      save2=0;  
                      //printf("off2"); 
                      clearBuffer();
                      smsFlag=0;
                    }else {
                    
                        if(strcmp(content,"on")==0)
                        {
                          LOAD1=1;
                          LOAD2=1;
                          save1=1;
                          save2=1;
                          //printf("on");
                          clearBuffer();
                          smsFlag=0;
                        }else{
                        
                            if(strcmp(content,"off")==0)
                            {
                              LOAD1=0;
                              LOAD2=0;
                              save1=0;
                              save2=0;
                              //printf("off"); 
                              clearBuffer();
                              smsFlag=0;
                            }
                            else 
                            {
                              if(strcmp(syntax,"doimk")==0)
                                {
                                  for(k=0;k<4;k++)
                                  {
                                    password[k]=msgStr[poskey+k];
                                  }
                                  //sendSMS(phoneNumber,"Doi mat khau thanh cong");
                                  printf("success:"); 
                                  putchar(password[0]); 
                                  putchar(password[1]);
                                  putchar(password[2]);
                                  putchar(password[3]);
                                  clearBuffer();
                                  smsFlag=0; 
                                  
                                }
                                else
                                {
                                  if(strcmp(syntax,"them1")==0)
                                  {  
                                    for(i1=0;i1<11;i1++)
                                    {
                                      if(msgStr[poskey+i1]<48||msgStr[poskey+i1]>57) sdt1[i1]=ndt1[i1]=0;
                                      else sdt1[i1]=ndt1[i1]=msgStr[poskey+i1];
                                    }
                                    while(i1<11);
                                    printf("sdt1:");
                                    puts(ndt1); 
                                    clearBuffer();  
                                    smsFlag=0;
                                  }
                                  else
                                  {
                                     if(strcmp(syntax,"them2")==0)
                                      {  
                                        for(i1=0;i1<11;i1++)
                                        {
                                          if(msgStr[poskey+i1]<48||msgStr[poskey+i1]>57) sdt2[i1]=ndt2[i1]=0;
                                          else sdt2[i1]=ndt2[i1]=msgStr[poskey+i1];
                                        } 
                                        while(i1<11);
                                        printf("\nsdt2:");
                                        puts(ndt2); 
                                        clearBuffer(); 
                                        smsFlag=0;
                                      }
                                      else
                                      {
                                         if(strcmp(syntax,"them3")==0)
                                          { 
                                            for(i1=0;i1<11;i1++)
                                            {
                                              if(msgStr[poskey+i1]<48||msgStr[poskey+i1]>57) sdt3[i1]=ndt3[i1]=0;
                                              else sdt3[i1]=ndt3[i1]=msgStr[poskey+i1];
                                            } 
                                            while(i1<11);
                                            printf("sdt3:");
                                            puts(ndt3);
                                            clearBuffer();
                                            smsFlag=0;
                                          }
                                          else
                                          {
                                               if(strcmp(content,"kttk")==0)
                                               {
                                                 KTTK(); 
                                                 clearBuffer();
                                                 smsFlag=0;
                                               }
                                               else
                                               {
                                                 if(strcmp(syntax,"naptien")==0)
                                                 {  char mathe[13];
                                                    char mt;
                                                    for(mt=0;mt<13;mt++)
                                                    { 
                                                      if(msgStr[13+mt]<48||msgStr[13+mt]>57) mathe[mt]='0';
                                                      else mathe[mt]=msgStr[13+mt];
                                                    }
                                                    naptien(mathe);
                                                    clearBuffer();
                                                    smsFlag=0;
                                                 }
                                               }
                                          }
                                      }
                                  }
                                }
                            }  
                        } 
                    }
                } 
            }
        }       
    } 
}


void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=0 Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 0.977 kHz
//0.26214s
TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
GICR|=(1<<INT1) | (1<<INT0);
MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
GIFR=(1<<INTF1) | (1<<INTF0);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600 (Double Speed Mode)
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (1<<U2X) | (1<<MPCM);
UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x0C;


// Global enable interrupts
#asm("sei")
while(strpos(rx_buffer,'O')<0)
{   
    printf("AT\r\n");
    printf(DISABLE_ECHO);   
    delay_ms(1000);
    if(strpos(rx_buffer,'O')<0) clearBuffer();  
}
printf(FORMAT_SMS_TEXT);
delay_ms(200);
printf(DISABLE_ECHO);
delay_ms(200);
printf(READ_WHEN_NEWSMS);
delay_ms(200);
printf(ENABLE_USSD);
delay_ms(200);
printf(DELETE_ALL_MSG);
delay_ms(200);
if(begin==255)
{

  password[0]='0'; 
  password[1]='0';
  password[2]='0';
  password[3]='0'; 
  begin=0;
}
if(save1==1) LOAD1=1;
else LOAD1=0;
if(save2==1) LOAD2=1;
else LOAD2=0;
clearBuffer();
sendSMS("109","hhhhhh");
while (1)
      {     if(flag) strHandle();  
      }
}
