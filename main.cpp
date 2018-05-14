#include <QDebug>
#define _XOPEN_SOURCE 600
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#define __USE_BSD
#include <string.h>
#include <sys/ioctl.h>
#include <sys/select.h>
#include <termios.h>

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include "configmanager.h"
#include "filewatcher.h"
#include "ptymanager.h"

int main(int argc, char *argv[]) {
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

  QGuiApplication app(argc, argv);

  QQuickStyle::setStyle("Material");

  QQmlApplicationEngine engine;
  FileWatcher watcher;
  PtyManager pty_manager;
  engine.rootContext()->setContextProperty("configManager",
                                           ConfigManager::instance());
  engine.rootContext()->setContextProperty("fileWatcher", &watcher);
  engine.rootContext()->setContextProperty("ptyManager", &pty_manager);
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
  if (engine.rootObjects().isEmpty()) return -1;

  return app.exec();
}
