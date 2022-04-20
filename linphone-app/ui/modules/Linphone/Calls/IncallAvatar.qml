import QtQuick 2.7

import Linphone 1.0
import LinphoneUtils 1.0

import UtilsCpp 1.0

import App.Styles 1.0

// =============================================================================

Avatar {
  property var call
  property var participantDeviceModel

  readonly property var _sipAddressObserver: call ? SipAddressesModel.getSipAddressObserver(call.fullPeerAddress, call.fullLocalAddress)
												: participantDeviceModel ? SipAddressesModel.getSipAddressObserver(participantDeviceModel.address, '')
													: null
  readonly property var _username: _sipAddressObserver ? UtilsCpp.getDisplayName(_sipAddressObserver.peerAddress) : ''

  backgroundColor: CallStyle.container.avatar.backgroundColor
  foregroundColor: call && call.status === CallModel.CallStatusPaused
    ? CallStyle.container.pause.color
    : 'transparent'

  image: {
		if (_sipAddressObserver) {
			var contact = _sipAddressObserver.contact
		    return contact && contact.vcard.avatar
		}else
			return null;
  }

  username: call && (call.status === CallModel.CallStatusPaused) || !_username? '' : _username

  Text {
    anchors.fill: parent
    color: CallStyle.container.pause.text.color

    // `|| 1` => `pointSize` must be greater than 0.
    font.pointSize: (width / CallStyle.container.pause.text.pointSizeFactor) || 1

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    text: '&#10073;&#10073;'
    textFormat: Text.RichText
    visible: call && (call.status === CallModel.CallStatusPaused) || false
  }
}