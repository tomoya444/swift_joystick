/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleWrite.cpp
    Ported to Arduino ESP32 by Evandro Copercini
*/

//2台目esp32用

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <stdint.h>

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID2        "f7355c47-0b31-0360-4a2a-8d50c12be45b"
#define CHARACTERISTIC_UUID5 "aeb5483e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID6 "aeb5483e-36e1-4688-b7f5-ea07361b26a9"
#define CHARACTERISTIC_UUID7 "aeb5483e-36e1-4688-b7f5-ea07361b26b1"
#define CHARACTERISTIC_UUID8 "aeb5483e-36e1-4688-b7f5-ea07361b26b2"

const int vol_pin1 = 14;//圧力センサ用アナログピン
const int vol_pin2 = 15;
const int vol_pin3 = 12;
const int vol_pin4 = 13;

int deviceConnected = false;

char sensorValues[20];

void changeUUID(BLEUUID newUUID);

class MyCallbacks: public BLECharacteristicCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      Serial.println("device connected");
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      Serial.println("device disconnected");
    }
    void onWrite(BLECharacteristic *pCharacteristic) {
      std::string value = pCharacteristic->getValue();

      if (value.length() > 0) {
        Serial.print("*********");
        Serial.print(value.c_str());
        Serial.print("-");
        Serial.print(atoi(value.c_str()));
        Serial.print("-");
        if (atoi(value.c_str()) == 1)
        {
          //digitalWrite(LED_PIN,HIGH);
          //Serial.print("LEDON");
        }
        else
        {
          //digitalWrite(LED_PIN,LOW);
          //Serial.print("LEDOFF");
        }

        Serial.println("*********");
      }
    }
};

//characteristics定義
BLECharacteristic *pCharacteristic5;
BLECharacteristic *pCharacteristic6;
BLECharacteristic *pCharacteristic7;
BLECharacteristic *pCharacteristic8;

void setup() {
  Serial.begin(115200);
  Serial.println("1- Download and install an BLE scanner app in your phone");
  Serial.println("2- Scan for BLE devices in the app");
  Serial.println("3- Connect to MyESP32");
  Serial.println("4- Go to CUSTOM CHARACTERISTIC in CUSTOM SERVICE and write something");
  Serial.println("5- See the magic =)");
  // changeUUID関数の呼び出し例
  BLEUUID newUUID = BLEUUID("6bbc26aa-058c-4ce5-88c4-5746bb8eb16a");
  changeUUID(newUUID);

  BLEDevice::init("BLE_DEVICE2");
  BLEServer *pServer = BLEDevice::createServer();

  BLEService *pService = pServer->createService(SERVICE_UUID2);

  pCharacteristic5 = pService->createCharacteristic(
                      CHARACTERISTIC_UUID5,
                      BLECharacteristic::PROPERTY_READ |
                      BLECharacteristic::PROPERTY_WRITE |
                      BLECharacteristic::PROPERTY_NOTIFY
                    );


  pCharacteristic6 = pService->createCharacteristic(
                       CHARACTERISTIC_UUID6,
                       BLECharacteristic::PROPERTY_READ |
                       BLECharacteristic::PROPERTY_WRITE |
                       BLECharacteristic::PROPERTY_NOTIFY
                     );

  pCharacteristic7 = pService->createCharacteristic(
                       CHARACTERISTIC_UUID7,
                       BLECharacteristic::PROPERTY_READ |
                       BLECharacteristic::PROPERTY_WRITE |
                       BLECharacteristic::PROPERTY_NOTIFY
                     );

  pCharacteristic8 = pService->createCharacteristic(
                       CHARACTERISTIC_UUID8,
                       BLECharacteristic::PROPERTY_READ |
                       BLECharacteristic::PROPERTY_WRITE |
                       BLECharacteristic::PROPERTY_NOTIFY
                     );
                     
  pCharacteristic5->setCallbacks(new MyCallbacks());

  pCharacteristic5->setValue("Hello World");
  pService->start();

  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();


}
int prevVal = LOW;
void loop() {
  // put your main code here, to run repeatedly:

  int sensorValue = analogRead(vol_pin1);
  int sensorValue2 = analogRead(vol_pin2);
  int sensorValue3 = analogRead(vol_pin3);
  int sensorValue4 = analogRead(vol_pin4);

  int convertValue = mapToRange(sensorValue);
  int convertValue2 = mapToRange(sensorValue2);
  int convertValue3 = mapToRange(sensorValue3);
  int convertValue4 = mapToRange(sensorValue4);


  Serial.print(convertValue);
  Serial.print(" ");
  Serial.print(convertValue2);
  Serial.print(" ");
  Serial.print(convertValue3);
  Serial.print(" ");
  Serial.println(convertValue4);
  
  //Serial.println(SERVICE_UUID );
  pCharacteristic5->setValue((uint8_t*)&convertValue, 4);

  //pCharacteristic->notify();
  //sendCombinedValues(convertValue, convertValue2);
  sendValues(convertValue, convertValue2, convertValue3, convertValue4);
  delay(100);


}

int mapToRange(int value) {
  float inputMin = 4095.0;
  float inputMax = 2500.0;
  float outputMin = -127.0;
  float outputMax = 127.0;
  float a = 0.00015;

  int normalizedValue = (value - inputMin);
  float mappedValue =  a * pow(normalizedValue, 2) + outputMin;
  if (mappedValue > 127) {
    mappedValue = 127;
  }
  return round(mappedValue);
}

void changeUUID(BLEUUID newUUID) {
  BLEAdvertisementData data;
  BLEDevice::getAdvertising()->stop(); // 広告を停止
  data.setFlags(0x6); // フラグの設定（具体的な意味は不明）
  data.setCompleteServices(newUUID);
  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising(); // Advertisingオブジェクトを取得
  pAdvertising->setAdvertisementData(data);
  pAdvertising->start(); // 広告を開始
  Serial.println("reset");
}

void sendValues(int value1, int value2, int value3, int value4) {
  pCharacteristic5->setValue((uint8_t*)&value1, sizeof(value1));
  pCharacteristic5->notify();

  pCharacteristic6->setValue((uint8_t*)&value2, sizeof(value2));
  pCharacteristic6->notify();

  pCharacteristic7->setValue((uint8_t*)&value3, sizeof(value3));
  pCharacteristic7->notify();

  pCharacteristic8->setValue((uint8_t*)&value4, sizeof(value4));
  pCharacteristic8->notify();
  
}
