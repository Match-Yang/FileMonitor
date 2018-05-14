#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include "configmanager.h"
#include "filewatcher.h"

int main(int argc, char *argv[]) {
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

  QGuiApplication app(argc, argv);

  QQuickStyle::setStyle("Material");

  QQmlApplicationEngine engine;
  FileWatcher watcher;
  engine.rootContext()->setContextProperty("configManager",
                                           ConfigManager::instance());
  engine.rootContext()->setContextProperty("fileWatcher", &watcher);
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
  if (engine.rootObjects().isEmpty()) return -1;

  return app.exec();
}
