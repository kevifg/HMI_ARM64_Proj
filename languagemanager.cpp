#include "languagemanager.h"
#include <QDebug>

LanguageManager::LanguageManager(QQmlEngine* engine, QObject* parent)
    : QObject(parent), m_engine(engine)
{}

void LanguageManager::selectLanguage(const QString& langCode)
{
    qApp->removeTranslator(&m_translator);
    qDebug() << "current seleced language: " << langCode;

    if (langCode != "en")
    {
        if (m_translator.load(QString(":/langs/app_%1.qm").arg(langCode)))
        {
                qApp->installTranslator(&m_translator);
                if (langCode == "zh_TW") m_currentLanguage = "繁體中文";

                qDebug() << "translator is installed";
        } else qWarning() << "translator is failed";
    } else m_currentLanguage = "English";

    emit languageChanged();
}

