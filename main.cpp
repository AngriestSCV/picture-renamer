#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <iostream>

#include "filesystem"

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
