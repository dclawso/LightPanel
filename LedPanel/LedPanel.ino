#include <AltSoftSerial.h>

#include <FastLED.h>

#define DATA_PIN    3
//#define CLK_PIN   4
#define LED_TYPE    WS2811
#define COLOR_ORDER GRB
#define NUM_LEDS    256
CRGB leds[NUM_LEDS];

// Params for width and height
const uint8_t kMatrixWidth = 8;
const uint8_t kMatrixHeight = 32;

// Param for different pixel layouts
const bool    kMatrixSerpentineLayout = true;
const bool    kMatrixVertical = false;

#define BRIGHTNESS          90
#define FRAMES_PER_SECOND  120

AltSoftSerial bt;

uint16_t XY( uint8_t x, uint8_t y)
{
  uint16_t i;
  
  if( kMatrixSerpentineLayout == false) {
    if (kMatrixVertical == false) {
      i = (y * kMatrixWidth) + x;
    } else {
      i = kMatrixHeight * (kMatrixWidth - (x+1))+y;
    }
  }

  if( kMatrixSerpentineLayout == true) {
    if (kMatrixVertical == false) {
      if( y & 0x01) {
        // Odd rows run backwards
        uint8_t reverseX = (kMatrixWidth - 1) - x;
        i = (y * kMatrixWidth) + reverseX;
      } else {
        // Even rows run forwards
        i = (y * kMatrixWidth) + x;
      }
    } else { // vertical positioning
      if ( x & 0x01) {
        i = kMatrixHeight * (kMatrixWidth - (x+1))+y;
      } else {
        i = kMatrixHeight * (kMatrixWidth - x) - (y+1);
      }
    }
  }
  
  return i;
}


void setup() {
   Serial.begin(9600);
   bt.begin(9600);
   delay(3000);
   FastLED.addLeds<LED_TYPE,DATA_PIN,COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);
  //FastLED.addLeds<LED_TYPE,DATA_PIN,CLK_PIN,COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);

  // set master brightness control
  FastLED.setBrightness(BRIGHTNESS);


  uint16_t pos;
  for (pos=0;pos<NUM_LEDS;pos++) {
    leds[pos] = CRGB::White;
  }
}

uint8_t y = 0;

void showLed(unsigned long cur) {
  static unsigned long last = 0;
  if ((cur - last) > 1000) {
    last = cur;
    FastLED.show(); 
  }
}

char cmdbuf[16];
char safe = 0;
int cmdbufindex=0;

unsigned char hexchartoval(char c) {
  c = toupper(c);
  c -= '0';
  if (c > 9) {
    c -= 'A' - '9' - 1;
  }
  return c;
}
unsigned char getFromAscii(char *p) {
  return (hexchartoval(p[0]) << 4) | hexchartoval(p[1]);
}

int setIntensity() {
  int i = atoi(&cmdbuf[1]);

  if (i > 100) {
    return 1;
  }
  FastLED.setBrightness(i);
  return 0;
}

int setColor() {
  if ((cmdbufindex & 0xf) != 7) {
    return 1;  
  }
  unsigned char r = getFromAscii(&cmdbuf[1]);
  unsigned char g = getFromAscii(&cmdbuf[3]);
  unsigned char b = getFromAscii(&cmdbuf[5]);

  int i;
  for (i=0; i<NUM_LEDS; i++) {
    leds[i].r = r;
    leds[i].g = g;
    leds[i].b = b;
  }
}

void processcmd() {
  cmdbuf[cmdbufindex] = 0;
  int rc = -1;
  switch (cmdbuf[0]) {
    case 'i':
    case 'I':
      rc = setIntensity();
      break;
     case 'c':
     case 'C':
       rc = setColor();
       break;
  }
  cmdbufindex = 0;
  bt.println(rc);
}

void handleSerial() {
  char c;

  if (bt.available()) {
    c = bt.read();
    bt.print(c);
    if (c == 0x08) {
      if ((cmdbufindex & 0xf) > 0) {
        cmdbufindex--;
        bt.print('\b');
        bt.print(' ');
        bt.print('\b');
      }
    } else if (c == 0x0d) {
      bt.print('\n');
      processcmd();
    } else {
      cmdbuf[cmdbufindex++ & 0xf] = c;
    }
  }
}
void loop() {
  unsigned long cur = millis();
  showLed(cur);

  handleSerial();
}
