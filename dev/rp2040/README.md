
# RP2040 Rotary Joystick Support

- Rotary control is supported via gamepad or firmware written by [**atrac17**](https://github.com/atrac17) / [**DJ Hard Rich**](https://twitter.com/djhardrich) for [**LS-30 functionality using an RP2040**](). Latency verification done by [**misteraddons**](https://github.com/misteraddons), for more information click [**here**](https://rpubs.com/misteraddons/inputlatency).

<br>

Model | Device | Connection | USB Polling<br>Interval | Sample<br>Number | Frame<br>Probability | Average<br>Latency | Joystick ID |
------|--------|------------|-------------------------|------------------|----------------------|--------------------|-------------|
LS-30 Rotary Encoder | RP2040 | Wired USB | 1ms | 2241 | 95.52% | 0.747 ms | 2e8a:000a |


### Build Instructions

- Download [**Arduino IDE**](https://www.arduino.cc/en/software) for Windows and follow the tutorial below. The set preferences url can be found [**here**](https://github.com/earlephilhower/arduino-pico). For more information, view the [**LS-30 P1 RP2040.ino**](https://github.com/va7deo/SNK68/blob/main/dev/rp2040/LS-30_P1_RP2040/LS-30_P1_RP2040.ino).


| Open File | Select File | Set Preferences | Install RP2040 |
|----|----|----|----|
|<img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/192126534-ab633568-7d34-4c1f-b7b8-e654fb8172d3.png"></img>|<img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/192126535-0a04de95-b219-438a-9038-7fd7216a8c8c.png"></img>|<img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/192126536-65513f14-7dc1-4841-b987-d2bcfb714d8b.png"></img>|<img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/192126543-f0d9fdc5-df93-4953-9d20-fbcb14abb6f8.png"></img>|

| USB Stack | Select Board Type | Verify / Compile | Export Compiled<br>Binary |
|----|----|----|----|
|<img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/192126546-d41eb139-d03b-47cf-bf48-ae17e4ac65d0.png"></img>|<img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/192126548-94dc0442-5c34-441b-9bf6-a0b5466f4613.png"></img>|<img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/192126552-0905dde7-49ae-487a-a72e-b57899f9acc9.png"></img>|<img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/192126553-f54bf882-bcc3-40bb-b5e4-056af685bf47.png"></img>|

### RP2040 to LS-30 Pinout

| RP2040 Pinout | LS-30 Joystick Pinout |
|----|----|
|<img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/192126819-4d9728a3-c35d-4496-bcf3-abe94c6a2244.png"></img>|<img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/192127216-d8679781-da0e-4d55-b6f2-1ab341830924.png"></img>|

# Licensing

Contact the author for special licensing needs. Otherwise follow the MIT license attached.
