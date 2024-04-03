#include <WaspXBeeZB.h>
#include <WaspFrame.h>
#include <WaspSensorEvent_v30.h>

float humid_grupa4;
float temp_grupa4;
uint8_t dest[1];

char GW_ADDRESS[] = "0013A20040F8DC49";
uint8_t GW_lastHex = 0x49;
uint8_t message;
uint8_t PANID[8] = {0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x44};
 

void setup()
{
  USB.ON();
  xbeeZB.ON();

  ///////////////////////////////////////////////
  // 1. Disable Coordinator mode
  ///////////////////////////////////////////////

  xbeeZB.setCoordinator(DISABLED);

  // check at command flag
  if (xbeeZB.error_AT == 0)
  {
    USB.println(F("1. Coordinator mode disabled"));
  }
  else
  {
    USB.println(F("1. Error while disabling Coordinator mode"));
  }

  ///////////////////////////////////////////////
  // 2. Set PANID
  ///////////////////////////////////////////////
  xbeeZB.setPAN(PANID);

  // check at command flag
  if (xbeeZB.error_AT == 0)
  {
    USB.println(F("PAN id je uspjesno postavljen"));
  }
  else
  {
    USB.println(F("Greska prilikom postavljanja"));
  }

  ///////////////////////////////////////////////
  // 3. Set channels to be scanned before creating network
  ///////////////////////////////////////////////
  
  xbeeZB.setScanningChannels(0x24, 0x14);
  if (xbeeZB.error_AT == 0)
  {
    USB.println(F("Grupa 4 uspjesno spojen na gateway"));
  }
  else
  {
    USB.println(F("Nije uspjesno spojeno"));
  }
  
  xbeeZB.writeValues();

  delay(10000);
  xbeeZB.getOperating64PAN();
  xbeeZB.getAssociationIndication();
 
  while( xbeeZB.associationIndication != 0 )
  { 
    delay(2000);

    xbeeZB.getOperating64PAN();

    USB.print(F("operating 64-b PAN ID: "));
    USB.printHex(xbeeZB.operating64PAN[0]);
    USB.printHex(xbeeZB.operating64PAN[1]);
    USB.printHex(xbeeZB.operating64PAN[2]);
    USB.printHex(xbeeZB.operating64PAN[3]);
    USB.printHex(xbeeZB.operating64PAN[4]);
    USB.printHex(xbeeZB.operating64PAN[5]);
    USB.printHex(xbeeZB.operating64PAN[6]);
    USB.printHex(xbeeZB.operating64PAN[7]);
    USB.println();     
    
    xbeeZB.getAssociationIndication();
  }

  USB.println(F("\nGrupa 4 router se uspjesno spojio na mrezu!"));

  xbeeZB.getOperating16PAN();
  xbeeZB.getOperating64PAN();
  xbeeZB.getChannel();

  USB.print(F("operating 16-b PAN ID: "));
  USB.printHex(xbeeZB.operating16PAN[0]);
  USB.printHex(xbeeZB.operating16PAN[1]);
  USB.println();

  USB.print(F("operating 64-b PAN ID: "));
  USB.printHex(xbeeZB.operating64PAN[0]);
  USB.printHex(xbeeZB.operating64PAN[1]);
  USB.printHex(xbeeZB.operating64PAN[2]);
  USB.printHex(xbeeZB.operating64PAN[3]);
  USB.printHex(xbeeZB.operating64PAN[4]);
  USB.printHex(xbeeZB.operating64PAN[5]);
  USB.printHex(xbeeZB.operating64PAN[6]);
  USB.printHex(xbeeZB.operating64PAN[7]);
  USB.println();

  USB.print(F("Kanal na kojem smo: "));
  USB.printHex(xbeeZB.channel);
  USB.println();
}

void loop()
{
  message = xbeeZB.receivePacketTimeout(10000);
  if( message != 0 ) 
  {
    USB.println("Saljem podatke sa senzora na Davidov GW");
    Events.ON();
    
    temp_grupa4 = Events.getTemperature();
    humid_grupa4 = Events.getHumidity();
    
    frame.createFrame(ASCII);
    frame.addSensor(SENSOR_EVENTS_TC, temp_grupa4);
    frame.addSensor(SENSOR_EVENTS_HUM, humid_grupa4);
    
    xbeeZB.send(GW_ADDRESS, frame.buffer, frame.length);
    
    USB.print("Temperatura ocitana na ruteru za grupu 4: ");
    USB.print(temp_grupa4);
    USB.println();
    USB.print("Vlaga ocitana na ruteru za grupu 4: ");
    USB.print(humid_grupa4);
    USB.println();
  } else {
    dest[0] = xbeeZB._srcMAC[7]; 
    if(GW_lastHex = dest[0]) 
    {
      USB.println("Dobio sam podatke s Davidovog GW");
      //xbeeZB.send(ADRESA_KOME_SALJEM, xbeeZB._payload, xbeeZB._length); 
    }
  }
}




