#include <mega8.h>
#include <sim800AT.h>
#include <stdio.h>
#include <string.h>
#include <delay.h>

//void call(char *number)
//{  char i;
//   printf("ATD");
//   for(i=0;i<strlen(number);i++)
//   {  
//     putchar(number[i]);
//   }
//   printf(";\r");
//   delay_ms(20);
//   putchar(26); 
//}
void sendSMS(char *number, char *msg)
{
    char i;
    printf("AT+CMGS="); 
    putchar(34); 
    for(i=0;i<11;i++)
    { 
      if(number[i]>46 && number[i]<58) putchar(number[i]); 
    } 
    putchar(34); 
    printf("\r");
    delay_ms(50);
    puts(msg);
    delay_ms(10);
    putchar(26);
}
void KTTK()
{
    printf("AT+CUSD=1\r\n");
    printf("ATD*101#;\r\n");
}
void naptien(char *mathe)
{   char i;
    printf("AT+CUSD=1\r\n");   
    printf("ATD*100*");
    for(i=0;i<13;i++)
    {
      if(mathe[i]>46 && mathe[i]<58) putchar(mathe[i]);
    }
    printf("#;\r\n");
}