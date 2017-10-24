/******************************************************
library sim800 write

content return from sim800:
    - call: RING

            +CLIP: "0964444373",161,"",0,"",0  
    sms receiver: +CMT: "+84964444373","","17/10/12,18:18:48+28"
                        content sms 

 
****************************************************************************/

#ifndef _SIM800AT_
#define _SIM800AT_INCLUDED_

#define	DELETE_ALL_MSG 	"AT+CMGDA=DEL ALL\r\n" 
#define FORMAT_SMS_TEXT "AT+CMGF=1\r\n"
#define DISABLE_ECHO 	"ATE0\r\n"
#define ENABLE_USSD		"AT+CUSD=1\r\n"
#define READ_WHEN_NEWSMS "AT+CNMI=2,2,0,0,0\r\n"
#define DISCONNECT_CALL	"ATH\r\n";

void call(char *number);
void sendSMS(char *number, char *msg);
void KTTK();
void naptien(char *mathe);


#pragma library sim800AT.c
#endif