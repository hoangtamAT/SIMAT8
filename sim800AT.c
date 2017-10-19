#include <mega8.h>
#include <sim800AT.h>
#include <stdio.h>
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
    printf("AT+CMGS=");
    puts(number);
    printf("\r");
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