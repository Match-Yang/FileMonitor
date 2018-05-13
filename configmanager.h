#ifndef CONFIGMANAGER_H
#define CONFIGMANAGER_H

#include <QObject>
#include <QSettings>

class ConfigManager : public QObject {
  Q_OBJECT
 public:
  explicit ConfigManager(QObject *parent = nullptr);
  Q_INVOKABLE const QString fileName() const;
  Q_INVOKABLE void setValue(const QString &group, const QString &key,
                            const QVariant &value);
  Q_INVOKABLE QVariant value(const QString &group, const QString &key);
  Q_INVOKABLE QVariant value(const QString &group, const QString &key,
                             const QVariant &default_value);

 private:
  QSettings *setting_;
};

#endif  // CONFIGMANAGER_H
