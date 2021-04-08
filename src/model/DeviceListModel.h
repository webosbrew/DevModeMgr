#ifndef DEVICELISTMODEL_H
#define DEVICELISTMODEL_H

#include <QAbstractListModel>
#include <QtQml>
#include <QJsonArray>

class DeviceListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QJsonArray json READ json WRITE setJson NOTIFY jsonChanged)
public:
    DeviceListModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex & = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setJson(QJsonArray json) {
        if (json != mJson) {
            beginResetModel();
            mJson = json;
            endResetModel();
            emit jsonChanged();
        }
    }
    QJsonArray json() const {
        return mJson;
    }
signals:
    void jsonChanged();
private:
     QJsonArray mJson;
};

#endif // DEVICELISTMODEL_H
