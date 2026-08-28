#ifndef WEATHERMANAGER_H
#define WEATHERMANAGER_H

#include <QObject>
#include <QString>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QTimer>

class WeatherManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString city READ city NOTIFY weatherChanged)
    Q_PROPERTY(QString temperature READ temperature NOTIFY weatherChanged)
    Q_PROPERTY(QString condition READ condition NOTIFY weatherChanged)
    Q_PROPERTY(QString icon READ icon NOTIFY weatherChanged)

private:

    QNetworkAccessManager m_netManager;
    QNetworkReply* m_currentReply = nullptr;

    QTimer m_refreshTimer;
    QTimer m_requestTimeoutTimer;

    QString m_cityQuery = "Taipei";
    QString m_city ="--";
    QString m_temperature = "--°C";
    QString m_condition = "--";
    QString m_icon = "qrc:/icons/unknown.svg";

    const QString m_apikey = "5a9fc42d6f64323376ba67253ea664b1";

    const int NORMAL_INTERVAL_MS = 15 * 60 * 1000;
    const int RETRY_INTERVAL_MS = 1 * 60 * 1000;
    const int REQUEST_TIMEOUT_MS = 10 * 1000;

signals:

    void weatherChanged();

private slots:

    void onNetworkReply();
    void onRequestTimeout();

public:

    explicit WeatherManager(QObject* parent = nullptr);

    QString city() const { return m_city; }
    QString temperature() const { return m_temperature; }
    QString condition() const { return m_condition; }
    QString icon() const { return m_icon; }

    Q_INVOKABLE void fetchWeather(const QString& cityQuery);
};

#endif // WEATHERMANAGER_H
