#ifndef LANGUAGEMANAGER_H
#define LANGUAGEMANAGER_H

#include <QTranslator>
#include <QQmlEngine>
#include <QObject>
#include <QGuiApplication>

class LanguageManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString emptyString READ emptyString NOTIFY languageChanged)
    Q_PROPERTY(QString currentLanguage READ currentLanguage NOTIFY languageChanged)

private:
    QQmlEngine* m_engine;
    QTranslator m_translator;
    QString m_currentLanguage = "English";

signals:
    void languageChanged();

public:
    explicit LanguageManager(QQmlEngine* engine, QObject* parent = nullptr);

    QString emptyString() const { return ""; }
    QString currentLanguage() const { return m_currentLanguage; }

    Q_INVOKABLE void selectLanguage(const QString& langCode);
};

#endif // LANGUAGEMANAGER_H
