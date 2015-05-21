#ifndef EVENT_H
#define EVENT_H


#include <QDateTime>
#include <QObject>
#include <QString>

class Event : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QDateTime startDate READ startDate WRITE setStartDate NOTIFY startDateChanged)
    Q_PROPERTY(QDateTime endDate READ endDate WRITE setEndDate NOTIFY endDateChanged)
    Q_PROPERTY(int id READ getId)

public:
    explicit Event(QObject *parent = 0);

    QString name() const;
    void setName(const QString &name);

    QDateTime startDate() const;
    void setStartDate(const QDateTime &startDate);

    QDateTime endDate() const;
    void setEndDate(const QDateTime &endDate);

    int getId() const;
    void setId(const int &id);

signals:
    void nameChanged(const QString &name);
    void startDateChanged(const QDateTime &startDate);
    void endDateChanged(const QDateTime &endDate);

private:
    int mId;
    QString mName;
    QDateTime mStartDate;
    QDateTime mEndDate;
};


#endif // EVENT_H
