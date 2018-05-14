#ifndef CONFIGMANAGER_H
#define CONFIGMANAGER_H

#include <QObject>
#include <QSettings>

class ConfigManager : public QObject {
  Q_OBJECT
 public:
  static ConfigManager *instance();
  Q_INVOKABLE const QString fileName() const;
  Q_INVOKABLE void remove(const QString &group, const QString &key);
  Q_INVOKABLE void setValue(const QString &group, const QString &key,
                            const QVariant &value);
  Q_INVOKABLE QVariant value(const QString &group, const QString &key);
  Q_INVOKABLE QVariant value(const QString &group, const QString &key,
                             const QVariant &default_value);

 private:
  explicit ConfigManager(QObject *parent = nullptr);

 private:
  static ConfigManager *config_manager_;
  QSettings *setting_;
};

#endif  // CONFIGMANAGER_H
