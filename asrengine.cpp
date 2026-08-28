#include "asrengine.h"

#include <QDebug>
#include <cstring>


AsrEngine::AsrEngine(QObject* parent)
    : QObject(parent)
{}

AsrEngine::~AsrEngine()
{
    if(m_stream)
    {
        SherpaOnnxDestroyOnlineStream(m_stream);
    }
    if (m_recognizer)
    {
        SherpaOnnxDestroyOnlineRecognizer(m_recognizer);
    }
}

bool AsrEngine::init(const QString& modelDir)
{
    SherpaOnnxOnlineRecognizerConfig config;
    std::memset(&config, 0, sizeof(config));

    config.feat_config.sample_rate = 16000;
    config.feat_config.feature_dim = 80;

    std::string encoder = (modelDir + "/encoder-epoch-99-avg-1.onnx").toStdString();
    std::string decoder = (modelDir + "/decoder-epoch-99-avg-1.onnx").toStdString();
    std::string joiner = (modelDir + "/joiner-epoch-99-avg-1.onnx").toStdString();
    std::string tokens = (modelDir + "/tokens.txt").toStdString();

    config.model_config.transducer.encoder = encoder.c_str();
    config.model_config.transducer.decoder = decoder.c_str();
    config.model_config.transducer.joiner  = joiner.c_str();
    config.model_config.tokens             = tokens.c_str();

    config.model_config.num_threads = 2;
    config.model_config.provider = "cpu";

    config.enable_endpoint = 1;
    config.rule1_min_trailing_silence = 2.0f;
    config.rule2_min_trailing_silence = 1.2f;

    m_recognizer = SherpaOnnxCreateOnlineRecognizer(&config);
    if (!m_recognizer)
    {
        qCritical() << "ERROR: Failed to initialize Sherpa-ONNX recognizer";
        return false;
    }
    m_stream = SherpaOnnxCreateOnlineStream(m_recognizer);
    if (!m_stream)
    {
        qCritical() << "ERROR: Failed to create stream!";
        return false;
    }
    return true;
}

void AsrEngine::processAudioChunk(const QByteArray& pcmData)
{
    if (!m_recognizer || !m_stream || pcmData.isEmpty()) return;

    // Convert raw int16 PCM bytes to float vector normalized to [-1.0f, 1.0f]
    const int16_t* pcm16 = reinterpret_cast<const int16_t*>(pcmData.constData());
    int sampleCount = pcmData.size() / sizeof(int16_t);

    std::vector<float> floatSamples(sampleCount);
    for (int i =0; i < sampleCount; ++i)
    {
        floatSamples[i] = pcm16[i] / 32768.0f;
    }

    SherpaOnnxOnlineStreamAcceptWaveform(m_stream, 16000, floatSamples.data(), floatSamples.size());

    while (SherpaOnnxIsOnlineStreamReady(m_recognizer, m_stream))
    {
        SherpaOnnxDecodeOnlineStream(m_recognizer, m_stream);
    }

    // Retrieve recognition result
    const SherpaOnnxOnlineRecognizerResult* result = SherpaOnnxGetOnlineStreamResult(m_recognizer, m_stream);
    if (result && result->text)
    {
        QString currentText = QString::fromUtf8(result->text);
        if (!currentText.isEmpty() && currentText != m_lastText)
        {
            m_lastText = currentText;
            emit textRecognized(m_lastText);
        }
        SherpaOnnxDestroyOnlineRecognizerResult(result);
    }

    // Check if the user stopped speaking
    if (SherpaOnnxOnlineStreamIsEndpoint(m_recognizer, m_stream))
    {
        SherpaOnnxOnlineStreamReset(m_recognizer, m_stream); // Reset stream for the next sentece
        m_lastText.clear();
    }
}
