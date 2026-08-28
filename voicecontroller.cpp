#include "voicecontroller.h"
#include <QDebug>

VoiceController::VoiceController(QObject* parent)
    : QObject(parent)
{}

VoiceController::~VoiceController()
{
    stopListening();
    if (m_recognizer) vosk_recognizer_free(m_recognizer);
    if (m_model) vosk_model_free(m_model);
}

bool VoiceController::startListening(const QString& modelPath)
{
    vosk_set_log_level(-1);

    m_model = vosk_model_new(modelPath.toUtf8().constData());
    if (!m_model)
    {
        qDebug() << "Failed to load vosk model from: " << modelPath;
        return false;
    }

    QString grammar = "[\"turn on oxygen\", \"turn off oxygen\", \"[unk]\"]";

    m_recognizer = vosk_recognizer_new_grm(m_model, 16000.0f, grammar.toUtf8().constData());
    if (!m_recognizer) return false;

    QAudioFormat format;
    format.setSampleRate(16000);
    format.setChannelCount(1);
    format.setSampleSize(16);
    format.setCodec("audio/pcm");
    format.setByteOrder(QAudioFormat::LittleEndian);
    format.setSampleType(QAudioFormat::SignedInt);

    m_audioInput = new QAudioInput(format, this);
    m_audioStream = m_audioInput->start();
    connect(m_audioStream, &QIODevice::readyRead, this, &VoiceController::processAudioStream);
}

void VoiceController::processAudioStream()
{
    if (!m_audioStream || !m_recognizer) return;

    QByteArray pcmData = m_audioStream->readAll();

    int isFinal = vosk_recognizer_accept_waveform(
                m_recognizer,
                pcmData.constData(),
                pcmData.size()
    );

    if (isFinal)
    {
        const char* jsonResult = vosk_recognizer_result(m_recognizer);

        QJsonDocument doc = QJsonDocument::fromJson(jsonResult);
        QString recognizedText = doc.object().value("text").toString().trimmed();

        if (!recognizedText.isEmpty() && recognizedText != "[unk]")
        {
            emit commandRecognized(recognizedText);
        }
    }
}

void VoiceController::stopListening()
{
    if (m_audioInput)
    {
        m_audioInput->stop();
        delete m_audioInput;
        m_audioInput = nullptr;
    }
}


