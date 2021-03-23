#include "DeviceListModel.h"
#include <QJsonObject>

enum ColumnType: int {
    Name = Qt::UserRole,
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
    switch (role) {
    case Qt::DisplayRole:
    {
            QJsonObject item = mJson[index.row() - 1].toObject();
            switch (static_cast<ColumnType>(index.column())) {
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
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> DeviceListModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[ColumnType::Name] = "name";
    names[ColumnType::IP] = "ip";
    names[ColumnType::Port] = "port";
    return names;
}
