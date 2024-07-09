#include <QFileSystemModel>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <iostream>
#include "QQmlContext"

#include "filesystem"
#include "directoryview.h"
#include "filehandler.h"

int main(int argc, char *argv[])
{
    auto aaa = std::filesystem::directory_iterator("C:\\src\\");

    for(auto &a : aaa){
        if(a.is_directory())
            std::cout << "Dir: ";
        else
            std::cout << "Fil: ";
        std::cout << a.path() << std::endl;
    }

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QFileSystemModel *fsm = new DirectoryView(&engine);
    FileHandler fileHandler;

    fsm->setRootPath(QDir::homePath());
    fsm->setResolveSymlinks(true);

    auto root = engine.rootContext();
    root->setContextProperty("fileSystemModel", fsm);
    root->setContextProperty("rootPathIndex", fsm->index(fsm->rootPath()));
    root->setContextProperty("fileHandler", &fileHandler);

    qmlRegisterUncreatableType<DirectoryView>("local.DirectoryView", 1, 0,
                                                   "DirectoryView", "Cannot create a DirectoryView instance.");


    const QUrl url(QStringLiteral("qrc:/picture-renamer/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
