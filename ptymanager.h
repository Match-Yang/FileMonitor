#ifndef PTYMANAGER_H
#define PTYMANAGER_H

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
#include <mutex>
#include <thread>

#include <QObject>

class PtyManager : public QObject {
  Q_OBJECT
 public:
  explicit PtyManager(QObject *parent = nullptr);
  ~PtyManager();
  Q_INVOKABLE void setMessage(const QString &msg);

 signals:
  void messageArrived(const QString &msg);

 private:
  int initPty();
  void runMasterProcess();
  void runSlaveProcess();

 private:
  int fd_master_;
  int fd_slave_;
  QString shell_path_;
  QStringList shell_args_;

  std::mutex mutex_;
  bool request_quit_;
};

#endif  // PTYMANAGER_H
