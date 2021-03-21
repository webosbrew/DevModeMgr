#ifndef DEVICELISTMODEL_H
#define DEVICELISTMODEL_H

#include <QAbstractTableModel>
#include <QtQml>
#include <QJsonArray>

class DeviceListModel : public QAbstractTableModel
{
    Q_OBJECT
    QML_ELEMENT
    QML_ADDED_IN_MINOR_VERSION(1)
    Q_PROPERTY(QJsonArray json READ json WRITE setJson NOTIFY jsonChanged)
public:
    DeviceListModel();
    int rowCount(const QModelIndex & = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setJson(QJsonArray &json) {
        if (json != mJson) {
            mJson = json;
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
