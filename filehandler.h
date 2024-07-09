#ifndef FILEHANDLER_H
#define FILEHANDLER_H

#include <QObject>
#include <QFile>
#include <QFileInfo>

class FileHandler : public QObject
{
    Q_OBJECT
public:
    explicit FileHandler(QObject *parent = nullptr);

    Q_INVOKABLE bool renameFile(const QString &oldPath, const QString &newPath);
    Q_INVOKABLE bool deleteFile(const QString &path);
};

#endif // FILEHANDLER_H
