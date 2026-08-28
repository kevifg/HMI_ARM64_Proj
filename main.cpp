#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIODevice>
#include <QAudioFormat>
#include <QAudioInput>

#include "modbusmanager.h"
#include "weathermanager.h"
#include "languagemanager.h"
#include "networkhelper.h"
#include "asrengine.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    qputenv("QT_VIRTUALKEYBOARD_DESKTOP_DISABLE", QByteArray("0"));


    QGuiApplication app(argc, argv);

    ModbusManager modbusManager;
    WeatherManager weatherManager;
    NetworkHelper networkHelper;
    AsrEngine asr;
//    VoiceController voiceController;

    QQmlApplicationEngine engine;

    engine.addImportPath(QCoreApplication::applicationDirPath() + "/../qml");
    engine.addImportPath("/usr/lib/aarch64-linux-gnu/qt5/qml");
    LanguageManager languagemanager(&engine);

    engine.rootContext()->setContextProperty("modbusManager", &modbusManager);
    engine.rootContext()->setContextProperty("weatherManager", &weatherManager);
    engine.rootContext()->setContextProperty("languagemanager", &languagemanager);
    engine.rootContext()->setContextProperty("networkHelper", &networkHelper);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty()) return -1;

    // modbusmanager attempts to connect to default address at the start-up
    QString ip = modbusManager.ipFromSetting();
    int port = modbusManager.portFromSetting();
    modbusManager.connectToDevice(ip, port);

    // weatherManager attemps to fetch weather data at the start-up
    weatherManager.fetchWeather("Taipei");

    // set up sherpa-OXXN speech-to-text functionality
    QString modelPath = "/home/user/Documents/QT_Programs/Proj_1_1/models";
    if (!asr.init(modelPath))
    {
        return -1;
    }

    QObject::connect(&asr, &AsrEngine::textRecognized, [](const QString& text) {
        qDebug() << "[Recognized]: " << text;
    });

    // Configure Qt5 Audio Format (16kHz, Mono, Signed 16-bit PCM)
    QAudioFormat format;
    format.setSampleRate(16000);
    format.setChannelCount(1);
    format.setSampleSize(16);
    format.setCodec("audio/pcm");
    format.setByteOrder(QAudioFormat::LittleEndian);
    format.setSampleType(QAudioFormat::SignedInt);

    QAudioDeviceInfo info = QAudioDeviceInfo::defaultInputDevice();
    if (!info.isFormatSupported(format))
    {
        qWarning() << "Default format not supported, trying nearest format.";
        format = info.nearestFormat(format);
    }

    // Start Mic Input
    QAudioInput audioInput(format);
    QIODevice* audioDevice = audioInput.start();

    if (!audioDevice)
    {
        qCritical() << "Failed to open default microphone device!";
        return -1;
    }

    // Connect audio readyRead signal to feed PCM data to Sherpa-ONNX
    QObject::connect(audioDevice, &QIODevice::readyRead, [&]() {
        QByteArray pcmData = audioDevice->readAll();
        asr.processAudioChunk(pcmData);
    });



//    voiceController.startListening("~/vosk-model-small-en-us-0.15");
//    QObject::connect(&voiceController, &VoiceController::commandRecognized, [](const QString& cmd) {
//       if (cmd == "turn on oxygen")
//       {
//           qDebug() << "turn on oxygen";
//       } else if (cmd == "turn off oxygen")
//       {
//           qDebug() << "turn off oxygen";
//       }
//    });


    return app.exec();
}
