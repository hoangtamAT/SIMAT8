#include <mega8.h>
#include <sim800AT.h>
#include <stdio.h>
#include <string.h>
#include <delay.h>

void call(char *number)
{
   printf("ATD");
   puts(number);
   printf(";\r");
   delay_ms(10);
   putchar(26); 
}
void sendSMS(char *number, char *msg)
{
    char p=34;
    printf("AT+CMGS="); 
    putchar(34);
    puts(strcat(number,&p));
    printf("\r");
    delay_ms(100);
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
{
    printf("AT+CUSD=1\r\n");   
    printf("ATD*100*");
    puts(mathe);
    printf("#;\r\n");
}