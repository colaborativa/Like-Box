// **********************************************************************************************************
// Ethernet Shield plus two HT1632 Led Displays
// Magda Sanchez, Colaborativa
// 14-July-2011
// **********************************************************************************************************
/* Ethernet Communication Library */
#include <SPI.h>
#include <Ethernet.h>
#include <Client.h>
#include <Server.h>
#include <Udp.h>
/* Led Display HT1632 Library */
#include <font_5x4.h>
#include <HT1632.h>
#include "ethernet_plus_ht1632.h"
#include "MemoryFree.h"
/*

 SETUP FUNCTION
 
 */
void setup () {
  byte gateway[] = { 192,168,1,1 }; // router
  byte subnet[] = { 255, 255, 255, 0 }; //subnet mask of the network 
  show_DIGITALPLATFORM     = 1;
  current_position = 0;
  counterone = 0;
  countertwo = 0; 
  // Start the serial library:
  Serial.begin(9600);
  delay(1000);
  /* */
  Ethernet.begin(mac, ip, gateway, subnet);
  // Give the Ethernet shield a second to initialize:
  delay(1000);
  // HT1632Class::begin(int pinCS1, int pinCS2, int pinWR,   int pinDATA) 
  HT1632.begin(2, 3, 9, 8);
  //Serial.print("freeMemory()=");
  //Serial.println(freeMemory());
}
/*

 LOOP FUNCTION
 
 */

void loop () {
  if(current_position == 0) {
    if(show_DIGITALPLATFORM == 1){
      getDisplayContent_DIGITALPLATFORM(textDisplayDIGITALPLATFORM);
      show_DIGITALPLATFORM = 0;
    }
    else{
      getDisplayContent_AUXSERVER(textDisplayAUXSERVER);
      show_DIGITALPLATFORM = 1;
    }    
  }
  if(show_DIGITALPLATFORM == 1){
    current_position = drawTextLeftToRight_DIGITALPLATFORM(textDisplayDIGITALPLATFORM[0], textDisplayDIGITALPLATFORM[1]);
  }else{
    current_position = drawTextLeftToRight_AUXSERVER(textDisplayAUXSERVER[0], textDisplayAUXSERVER[1]);
  }
  delay(50);
}  // END LOOP FUNCTION
/* ********************************************************************** */
/*
                      AUXILIARY FUNCTIONS
 
 */
/* ********************************************************************** */
/* 
 Descripcion:
 Esta funcion extrae la informacion obtenida del servidor DIGITALPLATFORM y la
 muestra en el display.
 Parser y ademas añade un titulo descriptivo a la informacion que va a
 mostrarse.  
 (numerovotos_1:ranking_1,numerovotos_2:ranking_2)
 (XX:XX,XX:XX) 
 XX votos
 puesto XX
 Parametros de entrada:
 String display[4]: informacion a mostrar en los dos displays,
 display[0] display 1 1
 display[1] display 1 2
 display[2] display 2 1
 display[3] display 2 2
 Fecha:
 23-10-2011
 */
void getDisplayContent_DIGITALPLATFORM(char display[2][MAX_DISPLAY_DIGITALPLATFORM]) {
  char tempString[2][MAX_DISPLAY_DIGITALPLATFORM];
//  char connectErrorStr[20] = "prueba definitiva";
  char connectErrorStr[2] = "*";
  char serverErrorStr[3]  = "**";
  char pageValueDIGITALPLATFORM[MAX_READ_DIGITALPLATFORM] = "";
  int isconnected = 0;
  int index=0;
  int i=0;
  char * pch;
  strcpy(display[0]," ");
  strcpy(display[1]," ");
  isconnected = connectToServer_DIGITALPLATFORM();
  if ( isconnected == 1){    
    readPageFromServer_DIGITALPLATFORM(pageValueDIGITALPLATFORM); //info1:info2,info3:info4 excluding parenthesis
    pch = strchr(pageValueDIGITALPLATFORM,',');
    index = (pch-pageValueDIGITALPLATFORM+1); 
    if ( !pch){ // Separator NOT found, Put default Value
      strcpy(display[0],serverErrorStr);
      strcpy(display[1],serverErrorStr);
    }
    else{ 
     strcpy(tempString[0],pageValueDIGITALPLATFORM);
     tempString[0][index-1] = '\0'; // end of string
     strcpy(tempString[1],pageValueDIGITALPLATFORM+index); 
      for(i=0;i < 2;i++){
         pch = strchr(pageValueDIGITALPLATFORM,':');
         index = (pch-pageValueDIGITALPLATFORM+1); 
         if (!pch){ // Separator NOT found, Put default Values
          strcpy(display[i],connectErrorStr);
         }
         else{
          // Display 1 primera frase + " votos puesto "+ Display 1 segunda frase
          strcpy(display[i],tempString[i]);
          display[i][index-1] = '\0'; // end of string
          strcat(display[i]," votos  puesto ");
          strcat(display[i],tempString[i]+index);
       }
      } /* end for*/
      /* Checking if strings have different size
      int diff = (strlen(display[0]) -  strlen(display[1]));
      if (diff > 0){ // display[0] > display[1]
        for(int x=0;x<diff;x++){
          strcat(display[1]," "); // append blancks
          } // end for
      }else{        //  display[0] < display[1] 
        if (diff < 0){
        for(int x=0;x<abs(diff);x++){
          strcat(display[0]," "); // append blancks
          } // end for            
        } // end if
      } // end else */
    } // end else 
  } // end else is connected
  else{
    strcpy(display[0], connectErrorStr);
    strcpy(display[1], connectErrorStr);
  }
}

/* ********************************************************************** */
/* (display1:display2)
 visitado desde madrid 77 me gusta = DISPLAY1
 visitado desde cordoba 88 me gusta = DISPLAY2
 */
/* ********************************************************************** */
int connectToServer_DIGITALPLATFORM(){
  static int contador=0;
  //connect to the server
  if(DEBUG){ 
    Serial.println("connectToServer_DIGITALPLATFORM:connecting..."); 
  }
  if (clientDIGITALPLATFORM.connect()) {
    // this call is infinite when there is no internet connection (try to look into the library itself) 
    if(DEBUG){ 
      Serial.println("connectToServer_DIGITALPLATFORM:connected"); 
    }
    char phpCall[128];
    if(SISTEMA_PRUEBAS == 1){ 
      sprintf (phpCall,"GET http://server.DIGITALPLATFORM.es/arquia/fundacion2010/becas/Convocatoria/2010/ObtenerVotosRanking?beca_uno=%d&beca_dos=%d&contador=%d",id_one,id_two,contador); // Maqueta
    }else{
      sprintf (phpCall,"GET http://fundacion.arquia.es/becas/Convocatoria/2011/ObtenerVotosRanking?beca_uno=%d&beca_dos=%d&contador=%d",id_one,id_two,contador); // Definitivo
    }
    if( contador == 10){
      contador = 0;
    }else{
      contador++;
    }
    clientDIGITALPLATFORM.print(phpCall); 
    clientDIGITALPLATFORM.println(" HTTP/1.1");
    if(SISTEMA_PRUEBAS == 1){ 
      clientDIGITALPLATFORM.println("Host: server.DIGITALPLATFORM.es");
    }else{
       clientDIGITALPLATFORM.println("Host: fundacion.arquia.es");
    }
    clientDIGITALPLATFORM.println();
    if(DEBUG){ 
      Serial.println("connectToServer_DIGITALPLATFORM:After server call");
    }
    delay(1000);
    //Connected - Read the page
    return 1;
  }
  else{
    if(DEBUG){ 
      Serial.println("connectToServer_DIGITALPLATFORM:not connected!");
    }
    clientDIGITALPLATFORM.flush();
    clientDIGITALPLATFORM.stop();
    return 0;
    /*
    DHCP Lease Time is set up to 24 hours meaning that we will have to renew it every 24 hours.
     */
  }
}

/* ********************************************************************** */
void readPageFromServer_DIGITALPLATFORM(char inString[MAX_READ_DIGITALPLATFORM]){
  int stringPos = 0; // string index counter
  boolean startRead = false;
  //read the page, and capture & return everything between '<' and '>'
  stringPos = 0;
  //memset( &inString, 0, MAX_READ ); //clear inString memory
  int count  = 0;
  int ncheck = 0;
  //Serial.println("client available");
  while( ncheck < CHECKIFAVAILABLE && count < INCOMINGDATA && stringPos < MAX_READ_DIGITALPLATFORM){
    ncheck++;
    int avail_chars = clientDIGITALPLATFORM.available();
     if( avail_chars > 0) {
      count++;
      char c = clientDIGITALPLATFORM.read();
      if(DEBUG){ 
        Serial.print(c);
      }
      if (c == '(' ) { //'<' is our begining character
        startRead = true; //Ready to start reading the part 
      }
      else if(startRead){
        if(c != ')'){ //'>' is our ending character
          inString[stringPos] = c;
          stringPos ++;
        }
        else{
          //got what we need here! We can disconnect now
          startRead = false;
          clientDIGITALPLATFORM.flush();
          clientDIGITALPLATFORM.stop();
          if(DEBUG){  
            Serial.println("disconnecting.");
          }
          return;
        }
      }
    }/*else{ // server not available, wait a little bite
      delay(0); // in miliseconds 
    }*/

  } /* end while */
  clientDIGITALPLATFORM.flush();
  clientDIGITALPLATFORM.stop();
  if(DEBUG){  
    Serial.println("disconnecting.");
  }
  return;
}
/*

 
 AUXSERVER
 
 
 */
int connectToServer_AUXSERVER(){
  static int contador=0;
  //connect to the server
  if(DEBUG){ 
    Serial.println("connecting..."); 
  }
  if (clientAUXSERVER.connect()) {
    // this call is infinite when there is no internet connection (try to look into the library itself) 
    if(DEBUG){ 
      Serial.println("connected"); 
    }
    char phpCall[128];
    if(SISTEMA_PRUEBAS == 1){ 
      sprintf (phpCall,"GET http://www.magdasanchez.es/arduino/getDataToDisplay2010.php?id_one=%d&id_two=%d&contador=%d",id_one,id_two,contador); // pruebas
    }else{
      sprintf (phpCall,"GET http://www.magdasanchez.es/arduino/getDataToDisplay2011.php?id_one=%d&id_two=%d&contador=%d",id_one,id_two,contador); // definitivo
    }
    if( contador == 10){
      contador = 0;
    }else{
      contador++;
    }
    clientAUXSERVER.print(phpCall); 
    clientAUXSERVER.println(" HTTP/1.1");
    clientAUXSERVER.println("Host: www.magdasanchez.es");
    clientAUXSERVER.println();
    if(DEBUG){ 
      Serial.println("after calling cliend php script");
    }
    delay(1000);
    //Connected - Read the page
    return 1;
  }
  else{
    if(DEBUG){ 
      Serial.println("not connected!");
    }
    clientAUXSERVER.flush();
    clientAUXSERVER.stop();
    return 0;
    // DHCP Lease Time is set up to 24 hours meaning that we will have to renew it every 24 hours.
  }
}
/* ********************************************************************** */
void readPageFromServer_AUXSERVER(char inString[MAX_READ_AUXSERVER]){
  int stringPos = 0; // string index counter
  boolean startRead = false;
  //read the page, and capture & return everything between '<' and '>'
  stringPos = 0;
  //memset( &inString, 0, MAX_READ ); //clear inString memory
  int count  = 0;
  int ncheck = 0;
  //Serial.println("client available");
  while( ncheck < CHECKIFAVAILABLE && count < INCOMINGDATA && stringPos < MAX_READ_AUXSERVER){
    ncheck++;
    int avail_chars = clientAUXSERVER.available();
     if( avail_chars > 0) {
      //Serial.println(avail_chars);
      count++;
      char c = clientAUXSERVER.read();
      if(DEBUG){ 
        Serial.print(c);
      }
      if (c == '(' ) { //'<' is our begining character
        startRead = true; //Ready to start reading the part 
      }
      else if(startRead){
        if(c != ')'){ //'>' is our ending character
          inString[stringPos] = c;
          stringPos ++;
        }
        else{
          //got what we need here! We can disconnect now
          startRead = false;
          clientAUXSERVER.flush();
          clientAUXSERVER.stop();
          if(DEBUG){  
            Serial.println("disconnecting.");
          }
          return;
        }
      }
    }/*else{ // server not available, wait a little bite
      delay(0); // in miliseconds 
    }*/

  } /* end while */
  clientAUXSERVER.flush();
  clientAUXSERVER.stop();
  if(DEBUG){  
    Serial.println("disconnecting.");
  }
  return;
}
/*
*/
void getDisplayContent_AUXSERVER(char display[2][MAX_DISPLAY_AUXSERVER]) {
  char tempString[2][MAX_DISPLAY_AUXSERVER];
  //char connectErrorStr[15] = "probando!!";
  char connectErrorStr[15] = "*";
  char serverErrorStr[3]  = "**";
  char pageValue[MAX_READ_AUXSERVER] = "";
  int isconnected = 0;
  int index=0;
  int i=0;
  char * pch;
  strcpy(display[0]," ");
  strcpy(display[1]," ");
  isconnected = connectToServer_AUXSERVER();
  if ( isconnected == 1){    
    readPageFromServer_AUXSERVER(pageValue); //info1:info2,info3:info4 excluding parenthesis
    //Serial.println(pageValue);
    pch = strchr(pageValue,',');
    index = (pch-pageValue+1); 
    if ( !pch){ // Separator NOT found, Put default Value
      strcpy(display[0],serverErrorStr);
      strcpy(display[1],serverErrorStr);
    }
    else{ 
     strcpy(tempString[0],pageValue);
     tempString[0][index-1] = '\0'; // end of string
     strcpy(tempString[1],pageValue+index); 
      for(i=0;i < 2;i++){
         pch = strchr(pageValue,':');
         index = (pch-pageValue+1); 
         if (!pch){ // Separator NOT found, Put default Values
          strcpy(display[i], connectErrorStr);
         }
         else{
          // Display 1 primera frase + " votos puesto "+ Display 1 segunda frase
          strcpy(display[i],tempString[i]);
          display[i][index-1] = '\0'; // end of string
          strcat(display[i]," ");
          strcat(display[i],tempString[i]+index);
       }
      } /* end for*/
    } // end else 
  } // end else is connected
  else{
    strcpy(display[0], connectErrorStr);
    strcpy(display[1], connectErrorStr);
  }
}


