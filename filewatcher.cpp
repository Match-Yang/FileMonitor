#include "filewatcher.h"

#include <QDebug>
#include <QDir>
#include <QFileInfo>

#include "configmanager.h"

FileWatcher::FileWatcher(QObject *parent) : QObject(parent) {
  watcher_ = new QFileSystemWatcher();
  connect(watcher_, &QFileSystemWatcher::directoryChanged, this,
          &FileWatcher::onDirChanged);

  auto p = ConfigManager::instance()->value("FileWatcher", "Path").toString();
  if (!p.isEmpty()) {
    watcher_->addPath(p);
  }
}
FileWatcher::~FileWatcher() {
  watcher_->removePaths(watcher_->directories());
  watcher_->removePaths(watcher_->files());
  watcher_->deleteLater();
}

void FileWatcher::watchDir(const QString &path) {
  if (!QFileInfo(path).exists()) {
    return;
  }
  if (!watcher_->directories().empty()) {
    watcher_->removePaths(watcher_->directories());
  }
  if (!watcher_->files().empty()) {
    watcher_->removePaths(watcher_->files());
  }
  watcher_->addPath(path);
  ConfigManager::instance()->setValue("FileWatcher", "Path", path);
}

void FileWatcher::onDirChanged(const QString &path) {
  emit directoryChanged(path);
  QDir dir(path);
  auto list = dir.entryInfoList(
      QDir::AllDirs | QDir::Files | QDir::NoDotAndDotDot, QDir::Time);
  if (!list.empty()) {
    emit fileAdded(list.first().absoluteFilePath());
  }
}
