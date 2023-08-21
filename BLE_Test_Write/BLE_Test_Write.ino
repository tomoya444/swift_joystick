/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleWrite.cpp
    Ported to Arduino ESP32 by Evandro Copercini
*/

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <stdint.h>

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "f7355c47-0b31-0360-4a2a-8d50c12be45a"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID2 "beb5483e-36e1-4688-b7f5-ea07361b26a9"

const int vol_pin1 = 14;//圧力センサ用アナログピン
const int vol_pin2 = 15;

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
BLECharacteristic *pCharacteristic;
BLECharacteristic *pCharacteristic2;

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

  BLEDevice::init("BLE_DEVICE");
  BLEServer *pServer = BLEDevice::createServer();

  BLEService *pService = pServer->createService(SERVICE_UUID);

  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ |
                      BLECharacteristic::PROPERTY_WRITE |
                      BLECharacteristic::PROPERTY_NOTIFY
                    );


  pCharacteristic2 = pService->createCharacteristic(
                       CHARACTERISTIC_UUID2,
                       BLECharacteristic::PROPERTY_READ |
                       BLECharacteristic::PROPERTY_WRITE |
                       BLECharacteristic::PROPERTY_NOTIFY
                     );
  pCharacteristic->setCallbacks(new MyCallbacks());

  pCharacteristic->setValue("Hello World");
  pService->start();

  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();


}
int prevVal = LOW;
void loop() {
  // put your main code here, to run repeatedly:

  int sensorValue = analogRead(vol_pin1);
  int sensorValue2 = analogRead(vol_pin2);

  int convertValue = mapToRange(sensorValue);
  int convertValue2 = mapToRange(sensorValue2);

  Serial.print(convertValue);
  Serial.print(" ");
  Serial.println(convertValue2);
  //Serial.println(SERVICE_UUID );
  pCharacteristic->setValue((uint8_t*)&convertValue, 4);

  //pCharacteristic->notify();
  //sendCombinedValues(convertValue, convertValue2);
  sendValues(convertValue, convertValue2);
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

void sendValues(int value1, int value2) {
  pCharacteristic->setValue((uint8_t*)&value1, sizeof(value1));
  pCharacteristic->notify();

  pCharacteristic2->setValue((uint8_t*)&value2, sizeof(value2));
  pCharacteristic2->notify();
}


/*
  void sendCombinedValues(int val1, int val2) {
  byte buffer[2];
  buffer[0] = val1;
  buffer[1] = val2;
  pCharacteristic->setValue(buffer, sizeof(buffer));
  //memcpy(buffer, &val1, sizeof(val1));
  //memcpy(buffer + sizeof(val1), &val2, sizeof(val2));
  //pCharacteristic->setValue(buffer, sizeof(buffer));
  pCharacteristic->notify();
  }
*/
