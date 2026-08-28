#ifndef VOICECONTROLLER_H
#define VOICECONTROLLER_H

#include <iostream>
#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QAudioInput>
#include <QIODevice>
#include <vosk_api.h>

class VoiceController : public QObject
{
    Q_OBJECT

private:

    VoskModel* m_model = nullptr;
    VoskRecognizer* m_recognizer = nullptr;
    QAudioInput* m_audioInput = nullptr;
    QIODevice* m_audioStream = nullptr;
    QString parseJsonResult(const char* jsonStr);

signals:
    void commandRecognized(const QString& command);

private slots:
    void processAudioStream();

public:    

    explicit VoiceController(QObject* parent = nullptr);
    ~VoiceController();

    Q_INVOKABLE bool startListening(const QString& modelPath);
    Q_INVOKABLE void stopListening();
};

#endif // VOICECONTROLLER_H
