#include "modbusmanager.h"
#include <QtConcurrent/QtConcurrent>
#include <sys/time.h>
#include <QDebug>


ModbusManager::ModbusManager(QObject* parent)
    :QObject{parent}
{
    connect(this, &ModbusManager::internalModbusConnectionResult,
            this, &ModbusManager::handleiMCR, Qt::QueuedConnection);
}

ModbusManager::~ModbusManager()
{
    disconnectDevice();
}

void ModbusManager::setConnected(bool connected)
{
    if (m_isConnected != connected)
    {
        m_isConnected = connected;
        qDebug() << "isSetConneted";
    }
}

void ModbusManager::setDevConnectionMsg(const QString& msg)
{
    if (m_devConnectionMsg != msg)
    {
        m_devConnectionMsg = msg;
        emit devConnectionMsgChanged();
    }
}

void ModbusManager::setDevIp(const QString& ip)
{
    if (m_devIp != ip)
    {
        m_devIp = ip;
        emit settingIpChanged();
    }
}

void ModbusManager::setDevPort(const int port)
{
    if (m_devPort != port)
    {
        m_devPort = port;
        emit settingPortChanged();
    }
}

void ModbusManager::setDevStatus(const bool status, int device_code)
{
    switch (device_code)
    {
        case 1: // Oxygen 1
            if (m_oxy1Opened != status)
            {
                m_oxy1Opened = status;
                emit oxy1StatusChanged();
                break;
            }
        case 2: // Oxygen 2
            if (m_oxy2Opened != status)
            {
                m_oxy2Opened = status;
                emit oxy2StatusChanged();
                break;
            }
        case 3: // Vaccum
            if (m_vacOpened != status)
            {
                m_vacOpened = status;
                emit vacStatusChanged();
                break;
            }
        default:
            qDebug() << "Device code doesn't exist";
    }
}

void ModbusManager::connectToDevice(const QString& ip, int port)
{
    if (m_isConnected) { disconnectDevice(); }

    QByteArray ipBytes = ip.toUtf8();

    QtConcurrent::run([this, ipBytes, port]() {
        modbus_t* ctx = modbus_new_tcp(ipBytes.constData(), port);
        if (!ctx)
        {
            emit internalModbusConnectionResult(false, nullptr, "[Modbus]: Unable to establish tcp context");
            qDebug() << "connection failed";
            return;
        }

        struct timeval timeout;
        timeout.tv_sec = 2;
        timeout.tv_usec = 0;
        modbus_set_response_timeout(ctx, &timeout);

        if (modbus_connect(ctx) == -1)
        {
            emit internalModbusConnectionResult(false, nullptr, "[Modbus]: Device connections failed");
            return;
        }

        emit internalModbusConnectionResult(true, ctx, "[Modbus]: Connected to devices successsfully");
        qDebug() << "connected successfully";
    });
}

void ModbusManager::disconnectDevice()
{
    if (m_ctx)
    {
        modbus_close(m_ctx);
        modbus_free(m_ctx);
        m_ctx = nullptr;
    }
}

void ModbusManager::handleiMCR(bool success, void* ctx, const QString& msg)
{
    if (success)
    {
        m_ctx = static_cast<modbus_t*>(ctx);
        qDebug() << "m_ctx is created";
        setConnected(true);
    } else
    {
        setConnected(false);
        qDebug() << "m_ctx is not created";
    }
}

void ModbusManager::writeSingleCoil(int address, bool status, int device_code)
{
    if (!m_ctx || !m_isConnected)
    {
        setDevConnectionMsg("[Modbus]: Write failed. No devices connection");
        qDebug() << "Write failed";
        return;
    }

    modbus_t* ctx = m_ctx;

    setDevConnectionMsg("[Modbus]: Turning device " + QString::number(device_code) + (status ? "ON" : "OFF"));

    QtConcurrent::run([this, ctx, address, status, device_code]() {
        if (!ctx) return;

        int bitValue = status ? 1 : 0;
        int rc = modbus_write_bit(ctx, address, bitValue);

        if (rc == -1)
        {
            QString errStr = QString::fromUtf8(modbus_strerror(errno));
            setDevConnectionMsg(errStr);
        } else
        {
            setDevConnectionMsg("[Modbus]: Device " + QString::number(device_code) + (status ? " is turned on" : " is turned off"));
            setDevStatus(status, device_code);
        }
    });









}
