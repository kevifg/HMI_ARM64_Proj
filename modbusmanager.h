#ifndef MODBUSMANAGER_H
#define MODBUSMANAGER_H

#include <QObject>
#include <QString>
#include <modbus/modbus.h>


class ModbusManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool oxy1Opened READ oxy1Opened NOTIFY oxy1StatusChanged)
    Q_PROPERTY(bool oxy2Opened READ oxy2Opened NOTIFY oxy2StatusChanged)
    Q_PROPERTY(bool vacOpened READ vacOpened NOTIFY vacStatusChanged)
    Q_PROPERTY(QString devConnectionMsg READ devConnectionMsg NOTIFY devConnectionMsgChanged)
    Q_PROPERTY(QString ipFromSetting READ ipFromSetting NOTIFY settingIpChanged)
    Q_PROPERTY(int portFromSetting READ portFromSetting NOTIFY settingPortChanged)

private:
    bool m_oxy1Opened = false;
    bool m_oxy2Opened = false;
    bool m_vacOpened = false;
    bool m_isConnected = false;

    int m_devPort = 502;

    QString m_devConnectionMsg = "NONE";
    QString m_devIp = "192.168.0.202";

    modbus_t* m_ctx = nullptr;


    void setConnected(bool connected);
    void setDevConnectionMsg(const QString& msg);
    void setDevStatus(const bool status, int device_code);


signals:
    void oxy1StatusChanged();
    void oxy2StatusChanged();
    void vacStatusChanged();
    void devConnectionMsgChanged();
    void settingIpChanged();
    void settingPortChanged();
    void internalModbusConnectionResult(bool success, void* ctx, const QString& msg);

private slots:
    void handleiMCR(bool success, void* ctx, const QString& msg);

public:
    explicit ModbusManager(QObject* parent = nullptr);
    ~ModbusManager();

    Q_INVOKABLE void connectToDevice(const QString& ip, int port = 502);
    Q_INVOKABLE void disconnectDevice();
    Q_INVOKABLE void writeSingleCoil(int address, bool status, int device_code);
    Q_INVOKABLE void setDevIp(const QString& ip);
    Q_INVOKABLE void setDevPort(const int port);
    //Q_INVOKABLE void setSettingTcpInputText(const QString& currentInputIp, const int currentInputPort);

    bool oxy1Opened() const { return m_oxy1Opened; }
    bool oxy2Opened() const { return m_oxy2Opened; }
    bool vacOpened() const { return m_vacOpened; }
    QString devConnectionMsg() const { return m_devConnectionMsg; }

    QString ipFromSetting() const { return m_devIp; }
    int portFromSetting() const { return m_devPort; }
};

#endif // MODBUSMANAGER_H
