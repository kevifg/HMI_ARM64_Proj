#ifndef ASRENGINE_H
#define ASRENGINE_H

#include <QObject>
#include <QString>
#include <memory>
#include "sherpa-onnx/c-api/c-api.h"

class AsrEngine : public QObject
{
    Q_OBJECT

private:
    const SherpaOnnxOnlineRecognizer* m_recognizer = nullptr;
    const SherpaOnnxOnlineStream* m_stream = nullptr;
    QString m_lastText;

signals:
    void textRecognized(const QString& text);

public:
    explicit AsrEngine(QObject* parent = nullptr);
    ~AsrEngine();

    bool init(const QString& modelDir);
    void processAudioChunk(const QByteArray& pcmData);
};

#endif // ASRENGINE_H
