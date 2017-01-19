import QtQuick 2.7
import QtQuick.Layouts 1.3

import Common 1.0
import Linphone 1.0
import Utils 1.0

import App.Styles 1.0

// =============================================================================

ColumnLayout {
  function _removeContact (contact) {
    Utils.openConfirmDialog(window, {
      descriptionText: qsTr('removeContactDescription'),
      exitHandler: function (status) {
        if (status) {
          ContactsListModel.removeContact(contact)
        }
      },
      title: qsTr('removeContactTitle')
    })
  }

  spacing: 0

  // ---------------------------------------------------------------------------
  // Search Bar & actions.
  // ---------------------------------------------------------------------------

  Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: ContactsStyle.bar.height

    color: ContactsStyle.bar.backgroundColor

    RowLayout {
      anchors {
        fill: parent
        leftMargin: ContactsStyle.bar.leftMargin
        rightMargin: ContactsStyle.bar.rightMargin
      }
      spacing: ContactsStyle.spacing

      TextField {
        Layout.fillWidth: true
        icon: 'filter'
        placeholderText: qsTr('searchContactPlaceholder')

        onTextChanged: contacts.setFilter(text)
      }

      ExclusiveButtons {
        texts: [
          qsTr('selectAllContacts'),
          qsTr('selectConnectedContacts')
        ]

        onClicked: contacts.useConnectedFilter = !!button
      }

      TextButtonB {
        text: qsTr('addContact')
        onClicked: window.setView('ContactEdit')
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Contacts list.
  // ---------------------------------------------------------------------------

  Rectangle {
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: ContactsStyle.backgroundColor

    ScrollableListView {
      anchors.fill: parent
      spacing: 0

      model: ContactsListProxyModel {
        id: contacts
      }

      delegate: Borders {
        bottomColor: ContactsStyle.contact.border.color
        bottomWidth: ContactsStyle.contact.border.width
        height: ContactsStyle.contact.height
        width: parent.width

        // ---------------------------------------------------------------------

        Rectangle {
          id: contact

          anchors.fill: parent
          color: ContactsStyle.contact.backgroundColor.normal

          // -------------------------------------------------------------------

          Component {
            id: container1

            RowLayout {
              spacing: ContactsStyle.contact.spacing

              PresenceLevel {
                Layout.preferredHeight: ContactsStyle.contact.presenceLevelSize
                Layout.preferredWidth: ContactsStyle.contact.presenceLevelSize
                level: $contact.presenceLevel
              }

              PresenceString {
                Layout.fillWidth: true
                status: $contact.presenceStatus
              }
            }
          }

          Component {
            id: container2

            Item {
              ActionBar {
                anchors {
                  left: parent.left
                  verticalCenter: parent.verticalCenter
                }
                iconSize: ContactsStyle.contact.actionButtonsSize

                ActionButton {
                  icon: 'video_call'
                  onClicked: CallsWindow.launchVideoCall($contact.vcard.sipAddresses[0]) // FIXME: Display menu if many addresses.
                }

                ActionButton {
                  icon: 'call'
                  onClicked: CallsWindow.launchAudioCall($contact.vcard.sipAddresses[0]) // FIXME: Display menu if many addresses.
                }

                ActionButton {
                  icon: 'chat'
                  onClicked: window.setView('Conversation', {
                    sipAddress: $contact.vcard.sipAddresses[0] // FIXME: Display menu if many addresses.
                  })
                }
              }

              ActionButton {
                anchors {
                  right: parent.right
                  verticalCenter: parent.verticalCenter
                }
                icon: 'delete'
                iconSize: ContactsStyle.contact.deleteButtonSize

                onClicked: _removeContact($contact)
              }
            }
          }

          // -------------------------------------------------------------------

          Rectangle {
            id: indicator

            anchors.left: parent.left
            color: 'transparent'
            height: parent.height
            width: ContactsStyle.contact.indicator.width
          }

          MouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true

            MouseArea {
              anchors.fill: parent
              cursorShape: containsMouse
                ? Qt.PointingHandCursor
                : Qt.ArrowCursor
              hoverEnabled: true

              onClicked: window.setView('ContactEdit', {
                sipAddress: $contact.vcard.sipAddresses[0] // FIXME: Display menu if many addresses.
              })
            }

            RowLayout {
              anchors {
                fill: parent
                leftMargin: ContactsStyle.contact.leftMargin
                rightMargin: ContactsStyle.contact.rightMargin
              }
              spacing: ContactsStyle.contact.spacing

              Avatar {
                Layout.preferredHeight: ContactsStyle.contact.avatarSize
                Layout.preferredWidth: ContactsStyle.contact.avatarSize
                image: $contact.vcard.avatar
                username: $contact.vcard.username
              }

              Text {
                Layout.fillHeight: true
                Layout.preferredWidth: ContactsStyle.contact.username.width

                color: ContactsStyle.contact.username.color
                elide: Text.ElideRight

                font {
                  bold: true
                  pointSize: ContactsStyle.contact.username.fontSize
                }

                text: $contact.vcard.username
                verticalAlignment: Text.AlignVCenter
              }

              // Container.
              Loader {
                id: loader

                Layout.fillWidth: true
                Layout.fillHeight: true
                sourceComponent: container1
              }
            }
          }

          // -------------------------------------------------------------------

          states: State {
            when: mouseArea.containsMouse

            PropertyChanges {
              color: ContactsStyle.contact.backgroundColor.hovered
              target: contact
            }

            PropertyChanges {
              color: ContactsStyle.contact.indicator.color
              target: indicator
            }

            PropertyChanges {
              sourceComponent: container2
              target: loader
            }
          }
        }
      }
    }
  }
}
