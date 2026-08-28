#ifndef NETWORKHELPER_H
#define NETWORKHELPER_H

#include <QObject>
#include <QStringList>
#include <QNetworkInterface>
#include <QProcess>

class NetworkHelper : public QObject
{
    Q_OBJECT
public:
    explicit NetworkHelper(QObject* parent = nullptr);

    Q_INVOKABLE QStringList getEthernetConnections();
    Q_INVOKABLE QString getIpForConnection(const QString& connName);
    Q_INVOKABLE bool setStaticIp(const QString& interfaceName, const QString& newIp, const QString& gateway);
};

#endif // NETWORKHELPER_H
