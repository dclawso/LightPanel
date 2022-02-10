// MIT License
//
// Copyright (c) 2022 David Lawson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <AltSoftSerial.h>

#include <FastLED.h>

#define CMDBUF_SIZE 32
#define CMDBUF_INDEX_MASK (CMDBUF_SIZE - 1)

#define DATA_PIN    3
//#define CLK_PIN   4
#define LED_TYPE    WS2811
#define COLOR_ORDER GRB
#define NUM_LEDS    256
CRGB leds[NUM_LEDS];

CRGB foreground = CRGB(0xffffff);

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

char cmdbuf[CMDBUF_SIZE];
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

void getColor(CRGB& rgb, char *p) {
  rgb.r = getFromAscii(&p[0]);
  rgb.g = getFromAscii(&p[2]);
  rgb.b = getFromAscii(&p[4]);
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
  if ((cmdbufindex & CMDBUF_INDEX_MASK) != 7) {
    return 1;  
  }

  getColor(foreground, &cmdbuf[1]);

  int i;

  for (i=0; i<NUM_LEDS; i++) {
    leds[i] = foreground;
  }
  
  return 0;
}

void drawRow(int y, CRGB& color) {
  for (int i=0; i<kMatrixHeight; i++) {
    leds[XY(i,y)] = color;
  }
}

int setMeter() {
  int numChars = cmdbufindex & CMDBUF_INDEX_MASK;
  if (numChars != 4 && numChars != 10 && numChars != 16) {
    return 1;
  }

  char tempchar = cmdbuf[3];
  cmdbuf[3] = 0;
  int percentage = atoi(&cmdbuf[1]);
  if (percentage < 0 || percentage > 100) {
    return 1;
  }
  cmdbuf[3] = tempchar;

  CRGB bg = ~foreground;
  CRGB fg = foreground;

  if (numChars >= 10) {
    getColor(fg, &cmdbuf[4]);
  }

  if (numChars >= 16) {
    getColor(bg, &cmdbuf[10]);
  }

  int fgRows = kMatrixWidth * percentage / 100;
  int bgRows = kMatrixWidth - fgRows;

  for (int i=0; i<kMatrixWidth; i++) {
    drawRow(i, (i > fgRows) ? bg : fg);
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
    case 'P':
    case 'p':
      rc = setMeter();
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
      if ((cmdbufindex & CMDBUF_INDEX_MASK) > 0) {
        cmdbufindex--;
        bt.print('\b');
        bt.print(' ');
        bt.print('\b');
      }
    } else if (c == 0x0d) {
      bt.print('\n');
      processcmd();
    } else {
      cmdbuf[cmdbufindex++ & CMDBUF_INDEX_MASK] = c;
    }
  }
}
void loop() {
  unsigned long cur = millis();
  showLed(cur);

  handleSerial();
}
