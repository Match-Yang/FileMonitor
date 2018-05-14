#ifndef PDIPMANAGER_H
#define PDIPMANAGER_H

#include <QObject>
extern "C" {
#include "pdip.h"
}

class PdipManager : public QObject {
  Q_OBJECT
 public:
  explicit PdipManager(QObject *parent = nullptr);

  Q_INVOKABLE void sendMessage(const QString &msg);

 signals:
  void receivedMessage(const QString &msg);

 private:
  pdip_t pdip_;
  pdip_cfg_t cfg_;
};

#endif  // PDIPMANAGER_H
