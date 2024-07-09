#include "filehandler.h"
#include <QDebug>

#include <filesystem>

FileHandler::FileHandler(QObject *parent) : QObject(parent) {}

bool FileHandler::renameFile(const QString &oldPath, const QString &newPath)
{
    QFileInfo fileInfo(newPath);
    if (fileInfo.exists()) {
        qDebug() << "File already exists at destination:" << newPath;
        return false;
    }

    QFile file(oldPath);
    if (!file.exists()) {
        qDebug() << "File does not exist:" << oldPath;
        return false;
    }

    bool success = file.rename(newPath);
    if (!success) {
        qDebug() << "Failed to rename file:" << oldPath << "to" << newPath;
    }
    return success;
}


bool FileHandler::deleteFile(const QString &path)
{
    {
        QFileInfo currentFile(path);
        if (!currentFile.exists()) {
            qDebug() << "File not found while deleting:" << path;
            return true;
        }
    }

    std::filesystem::path fpath(path.toStdString());
    std::filesystem::remove(fpath);

    return true;
}
