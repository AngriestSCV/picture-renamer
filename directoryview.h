#ifndef DIRECTORYVIEW_H
#define DIRECTORYVIEW_H

#include <QFileSystemModel>
#include <QObject>
#include <QQmlApplicationEngine>

class DirectoryView : public QFileSystemModel {
    Q_OBJECT
public:

    DirectoryView(QQmlApplicationEngine* engine): QFileSystemModel(engine){}

    enum Roles  {
        SizeRole = Qt::UserRole + 4,
        DisplayableFilePermissionsRole = Qt::UserRole + 5,
        LastModifiedRole = Qt::UserRole + 6,
        UrlStringRole = Qt::UserRole + 7,
        IsImage,
    };
    Q_ENUM(Roles)

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int,QByteArray> roleNames() const;
};


#endif // DIRECTORYVIEW_H
