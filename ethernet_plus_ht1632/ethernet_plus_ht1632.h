/* Variable Definitions */
/* */
#define DEBUG                  0
/* */
#define MAX_DISPLAY_DIGITALPLATFORM           32 // characters, length of sentence in display
#define MAX_READ_DIGITALPLATFORM              64 // characters read from server BETWEEN PARENTHESIS
#define MAX_DISPLAY_AUXSERVER        96 // characters, length of sentence in display
#define MAX_READ_AUXSERVER          192 // characters read from server BETWEEN PARENTHESIS
// this configuration leaves 273 bytes of free memory

#define INCOMINGDATA        1000 // characters read from server (ALL OF THEM) 253 y 163 para cada caso
#define CHECKIFAVAILABLE   15000  // number of times the server is checked for availability before starting reading info, 
                                 // by 50 miliseconds will give the total waiting time = 100 X 50 = 5 seconds
/* */
#define BOARD_NUMBER     10

#define SISTEMA_PRUEBAS  0 /* =1, IDs DE BECARIOS DEL AÑO 2010 (SISTEMA DE PRUEBAS) 
                              =0, IDs DE BECARIOS AÑO 2011 (SISTEMA DEFINITIVO)
                           */
/* CONFIGURACION DE RED */
#if SISTEMA_PRUEBAS == 1    /* SISTEMA EN PRUEBAS DIGITALPLATFORM */
byte serverDIGITALPLATFORM[] = { xxx,xxx,xxx,xxx }; //REPLACED BY IP SERVER
#if BOARD_NUMBER == 2 
  byte mac[] = { 0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX  }; // REPLACED BY MAC ADDRESS ETHERNET SHIELD
  byte ip[] = { 192,168,1,101 };
  const int id_one = XXXX; // REPLACED BY CODE ID 
  const int id_two = XXXX; // REPLACED BY CODE ID 
#else
  #if BOARD_NUMBER == 4 
  byte mac[] = { 0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX  }; // REPLACED BY MAC ADDRESS ETHERNET SHIELD
  byte ip[] = { 192,168,1,102 }; // Checked!
  const int id_one = XXXX; // REPLACED BY CODE ID 
  const int id_two = XXXX; // REPLACED BY CODE ID 
  #else
    #if BOARD_NUMBER == 6 
    byte mac[] = { 0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX  }; // REPLACED BY MAC ADDRESS ETHERNET SHIELD   
    byte ip[] = { 192,168,1,103 };
    const int id_one = XXXX; // REPLACED BY CODE ID 
    const int id_two = XXXX; // REPLACED BY CODE ID  
    #else
      #if BOARD_NUMBER == 8 
      byte mac[] ={ 0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX  }; // REPLACED BY MAC ADDRESS ETHERNET SHIELD
      byte ip[] = { 192,168,1,104 };
      const int id_one = XXXX; // REPLACED BY CODE ID 
      const int id_two = XXXX; // REPLACED BY CODE ID 
      #else
        #if BOARD_NUMBER == 10
          byte mac[] ={ 0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX  }; // REPLACED BY MAC ADDRESS ETHERNET SHIELD
          byte ip[] = { 192,168,1,105 }; // Auto-asigned
          const int id_one = XXXX; // REPLACED BY CODE ID 
          const int id_two = XXXX; // REPLACED BY CODE ID 
        #endif
    #endif
    #endif
  #endif
#endif             /* *************************** */
#else              /* SISTEMA DEFINITIVO DIGITALPLATFORM */
                   /* *************************** */
byte serverDIGITALPLATFORM[] = { XXX,XXX,XXX,XXX }; // REPLACED BY IP SERVER
#if BOARD_NUMBER == 2 
  byte mac[] = { 0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX  }; // REPLACED BY MAC ADDRESS ETHERNET SHIELD
  byte ip[] = { 192,168,1,101 };
  const int id_one =  XXXX; // REPLACED BY CODE ID     
  const int id_two = XXXX; // REPLACED BY CODE ID   
#else
  #if BOARD_NUMBER == 4 
  byte mac[] = { 0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX  }; // REPLACED BY MAC ADDRESS ETHERNET SHIELD
  byte ip[] = { 192,168,1,102 };
  const int id_one = XXXX; // REPLACED BY CODE ID  
  const int id_two = XXXX; // REPLACED BY CODE ID 
  #else
    #if BOARD_NUMBER == 6 
    byte mac[] ={ 0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX  }; // REPLACED BY MAC ADDRESS ETHERNET SHIELD 
    byte ip[] = { 192,168,1,103 };
    const int id_one = XXXX; // REPLACED BY CODE ID 
    const int id_two = XXXX; // REPLACED BY CODE ID 
    #else
      #if BOARD_NUMBER == 8 
      byte mac[] = { 0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX  }; // REPLACED BY MAC ADDRESS ETHERNET SHIELD
      byte ip[] = { 192,168,1,104 };
      const int id_one = XXXX; // REPLACED BY CODE ID 
      const int id_two = XXXX; // REPLACED BY CODE ID 
      #else
         #if BOARD_NUMBER == 10
          byte mac[] = { 0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX  }; // REPLACED BY MAC ADDRESS ETHERNET SHIELD
          byte ip[] = { 192,168,1,105 };
          const int id_one =XXXX; // REPLACED BY CODE ID   
          const int id_two = XXXX; // REPLACED BY CODE ID  
        #endif
    #endif
    #endif
  #endif
#endif
#endif
// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte serverDREAMHOST[] = { XXX,XXX,XXX,XXX }; // AUXSERVERDNS  
Client clientDIGITALPLATFORM(serverDIGITALPLATFORM, 80);  // port 80 is typical www page
Client clientDREAMHOST(serverDREAMHOST, 80);  // port 80 is typical www page
/* OTRAS VARIABLES GLOBALES */
/* */
char textDisplayDIGITALPLATFORM[2][MAX_DISPLAY_DIGITALPLATFORM];
char textDisplayDREAMHOST[2][MAX_DISPLAY_DREAMHOST];
int show_DIGITALPLATFORM;
int current_position;
int counterone;
int countertwo;  
