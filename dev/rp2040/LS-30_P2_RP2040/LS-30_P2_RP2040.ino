/*********************************************************************
 Adafruit invests time and resources providing this open source code,
 please support Adafruit and open-source hardware by purchasing
 products from Adafruit!
 MIT license, check LICENSE for more information
 Copyright (c) 2019 Ha Thach for Adafruit Industries
 All text above, and the splash screen below must be included in
 any redistribution

 Modified LS-30 rotary stick firmware by DJ HARD RICH / atrac17
 
 To compile use https://github.com/earlephilhower/arduino-pico
 Select USB Stack: Adafruit TinyUSB under "Tools"
*********************************************************************/

#include "Adafruit_TinyUSB.h"



// HID report descriptor using TinyUSB's template
// Single Report (no ID) descriptor
uint8_t const desc_hid_report[] =
{
  TUD_HID_REPORT_DESC_KEYBOARD()
};

// USB HID object. For ESP32 these values cannot be changed after this declaration
// desc report, desc len, protocol, interval, use out endpoint
Adafruit_USBD_HID usb_hid(desc_hid_report, sizeof(desc_hid_report), HID_ITF_PROTOCOL_KEYBOARD, 2, false);

//------------- Input Pins -------------//
// Array of pins and its keycode.
// Notes: these pins can be replaced by PIN_BUTTONn if defined in setup()
// RP2040: D0-D21
#ifdef ARDUINO_ARCH_RP2040
  uint8_t pins[] = { D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16, D17, D18, D19, D20, D21 };
#else
  uint8_t pins[] = { A0, A1, A2, A3 };
#endif

// number of pins
uint8_t pincount = sizeof(pins)/sizeof(pins[0]);

// For keycode definition check out https://github.com/hathach/tinyusb/blob/master/src/class/hid/hid.h
uint8_t hidcode[] = { HID_KEY_R, HID_KEY_F, HID_KEY_D, HID_KEY_G, HID_KEY_A, HID_KEY_S, HID_KEY_Q, HID_KEY_6, HID_KEY_2, HID_KEY_Z, HID_KEY_X, HID_KEY_C, HID_KEY_V, HID_KEY_B, HID_KEY_CAPS_LOCK, HID_KEY_E, HID_KEY_T, HID_KEY_3, HID_KEY_4, HID_KEY_7, HID_KEY_8 };

#if defined(ARDUINO_SAMD_CIRCUITPLAYGROUND_EXPRESS) || defined(ARDUINO_NRF52840_CIRCUITPLAY) || defined(ARDUINO_FUNHOUSE_ESP32S2)
  bool activeState = true;
#else
  bool activeState = false;
#endif

 

// the setup function runs once when you press reset or power the board
void setup()
{
#if defined(ARDUINO_ARCH_MBED) && defined(ARDUINO_ARCH_RP2040)
  // Manual begin() is required on core without built-in support for TinyUSB such as mbed rp2040
  TinyUSB_Device_Init(0);
#endif

  // Notes: following commented-out functions has no affect on ESP32
  // usb_hid.setBootProtocol(HID_ITF_PROTOCOL_KEYBOARD);
   usb_hid.setPollInterval(1);
  // usb_hid.setReportDescriptor(desc_hid_report, sizeof(desc_hid_report));
   usb_hid.setStringDescriptor("LS-30 STICK P2");


  usb_hid.begin();

  // led pin
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);


  // overwrite input pin with PIN_BUTTONx
#ifdef PIN_BUTTON1
  pins[0] = PIN_BUTTON1;
#endif

#ifdef PIN_BUTTON2
  pins[1] = PIN_BUTTON2;
#endif

#ifdef PIN_BUTTON3
  pins[2] = PIN_BUTTON3;
#endif

#ifdef PIN_BUTTON4
  pins[3] = PIN_BUTTON4;
#endif

#ifdef PIN_BUTTON5
    pins[4] = PIN_BUTTON5;
#endif

#ifdef PIN_BUTTON6
    pins[5] = PIN_BUTTON6;
#endif

#ifdef PIN_BUTTON7
    pins[6] = PIN_BUTTON7;
#endif

#ifdef PIN_BUTTON8
    pins[7] = PIN_BUTTON8;
#endif

#ifdef PIN_BUTTON9
    pins[8] = PIN_BUTTON9;
#endif

#ifdef PIN_BUTTON10
    pins[9] = PIN_BUTTON10;
#endif

#ifdef PIN_BUTTON11
    pins[10] = PIN_BUTTON11;
#endif

#ifdef PIN_BUTTON12
    pins[11] = PIN_BUTTON12;
#endif

#ifdef PIN_BUTTON13
    pins[12] = PIN_BUTTON13;
#endif

#ifdef PIN_BUTTON14
    pins[13] = PIN_BUTTON14;
#endif

#ifdef PIN_BUTTON15
    pins[14] = PIN_BUTTON15;
#endif

#ifdef PIN_BUTTON16
    pins[15] = PIN_BUTTON16;
#endif

#ifdef PIN_BUTTON17
    pins[16] = PIN_BUTTON17;
#endif

#ifdef PIN_BUTTON18
    pins[17] = PIN_BUTTON18;
#endif

#ifdef PIN_BUTTON19
    pins[18] = PIN_BUTTON19;
#endif

#ifdef PIN_BUTTON20
    pins[19] = PIN_BUTTON20;
#endif

#ifdef PIN_BUTTON21
    pins[20] = PIN_BUTTON21;
#endif


  // Set up pin as input
  for (uint8_t i=0; i<pincount; i++)
  {
    pinMode(pins[i], activeState ? INPUT_PULLDOWN : INPUT_PULLUP);
  }

  // wait until device mounted
  while( !TinyUSBDevice.mounted() ) delay(1);
}


void loop()
{
  // poll gpio once each 2 ms
  // delay(2);

  // used to avoid send multiple consecutive zero report for keyboard
  static bool keyPressedPreviously = false;

  uint8_t count=0;
  uint8_t keycode[6] = { 0 };

  // scan normal key and send report
  for(uint8_t i=0; i < pincount; i++)
  {
    if ( activeState == digitalRead(pins[i]) )
    {
      // if pin is active (low), add its hid code to key report
      keycode[count++] = hidcode[i];

      // 6 is max keycode per report
      if (count == 6) break;
    }
  }

  if ( TinyUSBDevice.suspended() && count )
  {
    // Wake up host if we are in suspend mode
    // and REMOTE_WAKEUP feature is enabled by host
    TinyUSBDevice.remoteWakeup();
  }

  // skip if hid is not ready e.g still transferring previous report
  if ( !usb_hid.ready() ) return;

  if ( count )
  {
    // Send report if there is key pressed
    uint8_t const report_id = 0;
    uint8_t const modifier = 0;

    keyPressedPreviously = true;
    usb_hid.keyboardReport(report_id, modifier, keycode);
  }else
  {
    // Send All-zero report to indicate there is no keys pressed
    // Most of the time, it is, though we don't need to send zero report
    // every loop(), only a key is pressed in previous loop()
    if ( keyPressedPreviously )
    {
      keyPressedPreviously = false;
      usb_hid.keyboardRelease(0);
    }
  }
}
