import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import ru.miet.shuvakin.electronic_secretary 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 400
    minimumWidth: 550
    minimumHeight: 350
    color: "#f4f4f4"

    title: "Электронный секретарь"

    SystemPalette {
        id: systemPalette
    }

    SqlEventModel {
        id: eventModel
    }

    Row {
        id: row
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10


        Component {
            id: eventListHeader

            Row {
                id: eventDateRow
                width: parent.width
                height: eventDayLabel.height
                spacing: 10

                Label {
                    id: eventDayLabel
                    text: calendar.selectedDate.getDate()
                    font.pointSize: 35
                }

                Column {
                    height: eventDayLabel.height

                    Label {
                        readonly property var options: { weekday: "long" }
                        text: Qt.locale().standaloneDayName(calendar.selectedDate.getDay(), Locale.LongFormat)
                        font.pointSize: 18
                    }
                    Label {
                        text: Qt.locale().standaloneMonthName(calendar.selectedDate.getMonth())
                              + calendar.selectedDate.toLocaleDateString(Qt.locale(), " yyyy")
                        font.pointSize: 12
                    }
                }
            }
        }

        Rectangle {
            width: (parent.width * 0.4 - parent.spacing)
            height: parent.height
            border.color: Qt.darker(color, 1.2)

            Column {
                width: parent.width
                height: parent.height
                //anchors.fill: parent

            ListView {
                id: eventsListView
                width: parent.width
                height: parent.height - 30
                spacing: 4
                clip: true
                header: eventListHeader
                //anchors.fill: parent
                anchors.margins: 10
                model: eventModel.eventsForDate(calendar.selectedDate)
                highlight: Rectangle
                              {
                                   color: "#ADD2F5"
                                   radius: 5
                                   opacity: 0.7
                                   focus: true
                              }
                focus: true

                delegate: Component {
                    Item {
                        id: eventListItem
                        width: eventsListView.width
                        height: eventItemColumn.height
                        anchors.horizontalCenter: parent.horizontalCenter

                        property variant delegateData: modelData

                        Image {
                            anchors.top: parent.top
                            anchors.topMargin: 4
                            width: 12
                            height: width
                            source: "qrc:/images/average_event_indicator.png"
                        }

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: "#eee"
                        }

                        Column {
                            id: eventItemColumn
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.right: parent.right
                            height: timeLabel.height + nameLabel.height + 8

                            Label {
                                id: nameLabel
                                width: parent.width
                                wrapMode: Text.Wrap
                                text: modelData.name
                            }
                            Label {
                                id: timeLabel
                                width: parent.width
                                wrapMode: Text.Wrap
                                text: modelData.startDate.toLocaleTimeString(calendar.locale, Locale.ShortFormat) + " - "
                                      + modelData.endDate.toLocaleTimeString(calendar.locale, Locale.ShortFormat)
                                color: "#aaa"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: eventsListView.currentIndex = index
                            //onDoubleClicked:
                        }
                    }
                }
            }

            Row{

                //width: parent.width
                //height: 50

                Button{
                    id: addButton
                    width: parent.width / 3
                    text: "Добавить"
                }

                Button{
                    id: changeButton
                    text: "Изменить"
                    onClicked: console.log(eventsListView.currentItem.delegateData.id)
                }

                Button{
                    id: deleteButton
                    text: "Удалить"
                    onClicked: eventModel.deleteEventFromTable(eventsListView.currentItem.delegateData.id)
                }

            }
        }
        }


        Calendar {
            id: calendar
            width: (parent.width * 0.6 - parent.spacing)
            height: parent.height
            frameVisible: true
            weekNumbersVisible: true
            selectedDate: new Date(2015, 4, 7)
            focus: true

            style: CalendarStyle {
                dayDelegate: Item {
                    readonly property color sameMonthDateTextColor: "#444"
                    readonly property color selectedDateColor: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                    readonly property color selectedDateTextColor: "white"
                    readonly property color differentMonthDateTextColor: "#bbb"
                    readonly property color invalidDatecolor: "#dddddd"

                    Rectangle {
                        anchors.fill: parent
                        border.color: "transparent"
                        color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                        anchors.margins: styleData.selected ? -1 : 0
                    }

                    Image {
                        visible: eventModel.eventsForDate(styleData.date).length > 0
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: -1
                        width: 12
                        height: width
                        source: "qrc:/images/average_event_indicator.png"
                    }

                    Label {
                        id: dayDelegateText
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        color: {
                            var color = invalidDatecolor;
                            if (styleData.valid) {
                                // Date is within the valid range.
                                color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                if (styleData.selected) {
                                    color = selectedDateTextColor;
                                }
                            }
                            color;
                        }
                    }
                }
            }
        }
    }
}
