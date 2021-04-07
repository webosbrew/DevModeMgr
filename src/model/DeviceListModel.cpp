#include "DeviceListModel.h"
#include <QJsonObject>

enum ColumnType: int {
    Name = Qt::UserRole + 1,
    IP,
    Port,
    Max,
};

DeviceListModel::DeviceListModel(QObject *parent)
{
    Q_UNUSED(parent);
}

int DeviceListModel::rowCount(const QModelIndex &) const
{
    return mJson.size();
}

QVariant DeviceListModel::data(const QModelIndex &index, int role) const
{
    QJsonObject item = mJson[index.row()].toObject();
    switch (role) {
    case ColumnType::Name:
        return item["name"].toString();
    case ColumnType::IP:
        return item["deviceinfo"].toObject()["ip"].toString();
    case ColumnType::Port:
        return item["deviceinfo"].toObject()["port"].toString();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> DeviceListModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[ColumnType::Name] = "name";
    names[ColumnType::IP] = "ip";
    names[ColumnType::Port] = "port";
    return names;
}
