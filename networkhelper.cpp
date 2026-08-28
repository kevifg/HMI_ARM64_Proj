#include "networkhelper.h"

NetworkHelper::NetworkHelper(QObject* parent)
    :QObject(parent)
{}

QStringList NetworkHelper::getEthernetConnections()
{
    QProcess process;
    process.start("bash", QStringList() << "-c" <<
                  "nmcli -t -f NAME,TYPE connection show --active | grep '802-3-ethernet' | cut -d: -f1");
    process.waitForFinished();

    QString output = process.readAllStandardOutput().trimmed();
    if (output.isEmpty())
    {
        qDebug() << "connection isn't read";
        return QStringList();
    }
    return output.split('\n');
}

QString NetworkHelper::getIpForConnection(const QString& connName)
{
    if (connName.isEmpty()) return "N/A";

    QProcess process;
    QString cmd = QString("nmcli -t -f IP4.ADDRESS connection show '%1' | head -n1 | cut -d: -f2 | cut -d/ -f1").arg(connName);
    process.start("bash", QStringList() << "-c" << cmd);
    process.waitForFinished();

    QString ip = process.readAllStandardOutput().trimmed();
    return ip.isEmpty() ? "Disconnected" : ip;

}

bool NetworkHelper::setStaticIp(const QString& connName, const QString& newIp, const QString& gateway)
{
    if (connName.isEmpty() || newIp.isEmpty()) return false;
    qDebug() << connName;
    QString cmd = QString("nmcli con mod '%1' ipv4.address '%2/24' ipv4.gateway '%3' ipv4.method manual && nmcli con up '%1'")
            .arg(connName, newIp, gateway);
    return (QProcess::execute("bash", QStringList() << "-c" << cmd) == 0);
}
