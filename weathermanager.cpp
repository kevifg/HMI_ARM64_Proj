#include "weathermanager.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrlQuery>
#include <QtMath>
#include <QDebug>


WeatherManager::WeatherManager(QObject* parent)
    :QObject{parent}
{
    m_requestTimeoutTimer.setSingleShot(true);  //set watch dot
    m_requestTimeoutTimer.setInterval(REQUEST_TIMEOUT_MS);
    connect(&m_requestTimeoutTimer, &QTimer::timeout,
            this, &WeatherManager::onRequestTimeout);

    m_refreshTimer.setInterval(NORMAL_INTERVAL_MS);
    connect(&m_refreshTimer, &QTimer::timeout, this, [this]() {
        fetchWeather(m_cityQuery);
    });
    m_refreshTimer.start();
}

void WeatherManager::fetchWeather(const QString& cityQuery)
{
    if (!cityQuery.isEmpty())
    {
        m_cityQuery = cityQuery;
    }

    if (m_currentReply)
    {
        m_requestTimeoutTimer.stop();
        m_currentReply->abort();
        m_currentReply->deleteLater();
        m_currentReply = nullptr;
    }

    QUrl url("https://api.openweathermap.org/data/2.5/weather");
    QUrlQuery query;
    query.addQueryItem("q", cityQuery);
    query.addQueryItem("units", "metric");
    query.addQueryItem("appid", m_apikey);
    url.setQuery(query);

    QNetworkRequest request(url);

    m_currentReply = m_netManager.get(request);

    m_requestTimeoutTimer.start();

    connect(m_currentReply, &QNetworkReply::finished,
            this, &WeatherManager::onNetworkReply);
}

void WeatherManager::onRequestTimeout()
{
    if (m_currentReply)
    {
        m_currentReply->abort();
    }
}

void WeatherManager::onNetworkReply()
{
    m_requestTimeoutTimer.stop();

    if (!m_currentReply) return;

    QNetworkReply* reply = m_currentReply;
    m_currentReply = nullptr;
    reply->deleteLater();

    // Handle Network Errors or Timeouts
    if (reply->error() != QNetworkReply::NoError)
    {
        m_city = "Offline";
        m_condition = (reply->error() == QNetworkReply::OperationCanceledError)
                ? "Timeout" : "Network Error";
        emit weatherChanged();

        m_refreshTimer.setInterval(RETRY_INTERVAL_MS);
        return;
    }

    QByteArray responseData = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(responseData);

    if (doc.isObject())
    {
        QJsonObject rootObj = doc.object();

        m_city = rootObj.value("name").toString("Unknown");

        if (rootObj.contains("main") && rootObj["main"].isObject())
        {
            double temp = rootObj["main"].toObject().value("temp").toDouble();
            m_temperature = QString::number(qRound(temp)) + "°C";
        }

        if (rootObj.contains("weather") && rootObj["weather"].isArray())
        {
            QJsonArray weatherArray = rootObj["weather"].toArray();
            if (!weatherArray.isEmpty())
            {
                QJsonObject weatherObj = weatherArray.at(0).toObject();
                m_condition = weatherObj.value("main").toString();

                if (m_condition == "Clouds") m_icon = "qrc:/icons/Clouds.svg";
                else if (m_condition == "Rain") m_icon = "qrc:/icons/Rain.svg";
                else if (m_condition == "Clear" || m_condition == "Drizzle") m_icon = "qrc:/icons/Clear.svg";
                else if (m_condition == "Thunder") m_icon = "qrc:/icons/Thunder.svg";
                else m_icon ="qrc:/icons/Default.svg";
            }
        }
        // Restore normal interval refresh cycle after successful fetch
        m_refreshTimer.setInterval(NORMAL_INTERVAL_MS);
        emit weatherChanged();
    }
}
