#include "configmanager.h"

ConfigManager::ConfigManager(QObject *parent) : QObject(parent) {
  setting_ = new QSettings("FileMonitor", "FileMonitor", this);
}

const QString ConfigManager::fileName() const { return setting_->fileName(); }

void ConfigManager::setValue(const QString &group, const QString &key,
                             const QVariant &value) {
  setting_->beginGroup(group);
  setting_->setValue(key, value);
  setting_->endGroup();
}

QVariant ConfigManager::value(const QString &group, const QString &key) {
  return value(group, key, QVariant());
}

QVariant ConfigManager::value(const QString &group, const QString &key,
                              const QVariant &default_value) {
  setting_->beginGroup(group);
  auto v = setting_->value(key, default_value);
  setting_->endGroup();
  return v;
}
