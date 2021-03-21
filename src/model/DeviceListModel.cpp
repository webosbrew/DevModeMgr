#include "DeviceListModel.h"
#include "src/service/DeviceManager.h"

enum class ColumnType: int {
    Name = 0,
    IP,
    Port,
    Max,
};

DeviceListModel::DeviceListModel()
{
}

int DeviceListModel::rowCount(const QModelIndex &) const
{
    return 1 + mJson.size();
}

int DeviceListModel::columnCount(const QModelIndex &) const
{
    return static_cast<int>(ColumnType::Max);
}

QVariant DeviceListModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case Qt::DisplayRole:
    {
        if (index.row() == 0) {
            switch (static_cast<ColumnType>(index.column())) {
            case ColumnType::Name:
                return "Name";
            case ColumnType::IP:
                return "IP";
            case ColumnType::Port:
                return "Port";
            default:
                return QVariant();
            }
        } else{
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
    }
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> DeviceListModel::roleNames() const
{
    return { {Qt::DisplayRole, "display"} };
}
