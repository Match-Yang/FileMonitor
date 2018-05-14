#ifndef FILEWATCHER_H
#define FILEWATCHER_H

#include <QFileSystemWatcher>
#include <QObject>

class FileWatcher : public QObject {
  Q_OBJECT
 public:
  explicit FileWatcher(QObject *parent = nullptr);
  ~FileWatcher();
  Q_INVOKABLE void watchDir(const QString &path);

 signals:
  void directoryChanged(const QString &path);
  void fileAdded(const QString &path);

 private:
  void onDirChanged(const QString &path);

 private:
  QFileSystemWatcher *watcher_;
};

#endif  // FILEWATCHER_H
