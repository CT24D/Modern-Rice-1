import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Qt5Compat.GraphicalEffects
import Quickshell.Services.Mpris
Scope {
	id: root
	property var modVis: false
	FontLoader {
		id: montserrat
		source: "fonts/static/Montserrat-Light.ttf"
				
	}
	FileView {
		id: colorsJson
		path: "/home/jmkwrld/.cache/wallust/colors.json"
		watchChanges: true
		onFileChanged: reload()
				
		onAdapterUpdated: writeCopyAdapter()
	
		JsonAdapter {
			id: config
			property var colors: ({})
		}
	
	}
	
		
	PwObjectTracker {
		objects: [Pipewire.defaultAudioSink]
	}
	property  int volume: Math.round(Pipewire.defaultAudioSink.audio.volume * 100)
	property int volume2: Math.round(Pipewire.defaultAudioSink.audio.volume * 100)-100
	property bool overVolume: volume > 100
	Variants{
		model: Quickshell.screens
		PanelWindow {
			required property var modelData
			screen: modelData
			id: bar
			anchors{
				top: true
				left: true
				bottom: true
			}
			
			Rectangle {

				id:rbar
				color: config.colors["color12"]
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				implicitWidth:parent.width - 25
			}
			color: "transparent"
			
			
			implicitWidth: Screen.width / 30 + 25   
			exclusiveZone: Screen.width/ 30 + 5
			Item{
				id: barRadi
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.left:parent.left
				implicitWidth: 50
				visible:false
				Rectangle{
					anchors.fill:parent
					bottomLeftRadius:25
					topLeftRadius:25
					color:"white"
					
				}
			}
	
			Rectangle{
					
				anchors.bottom:parent.bottom
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.leftMargin:rbar.width
				implicitWidth:50
				color:config.colors["color12"]
				layer.enabled: true
	        		layer.effect: OpacityMask {
	       		     	maskSource: barRadi // Use the mask item defined above
				invert: true // This is the key property for reverse clipping
				}
			}	
				
			Text {
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.topMargin: parent.height * .07
				font.family: montserrat.name
				text: (Hyprland.activeToplevel.title).length > 50? (Hyprland.activeToplevel.wayland.title).slice(0,50) + "..." : Hyprland.activeToplevel.wayland.title
				font.pixelSize: rbar.width / 3
				transform: Rotation {
					origin.x: 25
					origin.y: 25
					angle: 90
				}
	
	
	
			}	
			Rectangle {
				id:tray
				anchors.left: parent.left
				anchors.bottom: parent.bottom
				anchors.bottomMargin: parent.height /8
				anchors.leftMargin: rbar.width/2 -implicitWidth/2
				implicitHeight: parent.height/6
				implicitWidth: rbar.width/1.4
				radius:25

				color:config.colors["color0"]
				Button {
					anchors.left: parent.left
					anchors.bottom: parent.bottom
					anchors.bottomMargin: parent.height/2 - implicitHeight/2
					implicitWidth: parent.width
					implicitHeight: parent.height/4
					
					onClicked: {
						Quickshell.execDetached(["nwg-look"]);
					}
					background: Rectangle {
						color:"transparent"
					}
					Text {
						anchors.fill: parent
						anchors.leftMargin: parent.width/2-implicitWidth/2 
						color: config.colors["color11"]
						font.pixelSize: parent.width*.8
						text: "󰂯"
					}
				}
				Process {
					id: power
					command: ["powerprofilesctl", "get"]
					property var icon
					stdout: StdioCollector {
						onStreamFinished: {
							if (this.text == "performance\n")
							{
								power.icon = ""
							}
							if (this.text == "balanced\n")
							{
								power.icon = ""
							}
							if (this.text == "power-saver\n")
							{
								power.icon = ""
							}
						}
					}
				}
				Timer {
					interval: 2000
					repeat: true
					running: true
					onTriggered: {
						power.running = true
					}

				}
				Button {
					anchors.left: parent.left
					anchors.bottom: parent.bottom
					anchors.bottomMargin: parent.height - implicitHeight*1.3
					implicitWidth: parent.width
					implicitHeight: parent.height/4
					
					onClicked: {
						Quickshell.execDetached(["nwg-look"]);
					}
					background: Rectangle {
						color:"transparent"
					}
					Text {
						anchors.fill: parent
						anchors.leftMargin: parent.width/2-implicitWidth/2 
						color: config.colors["color11"]
						font.pixelSize: parent.width*.7
						text: power.icon
					}
				}
				Process {
					id: con
					command: ["nmcli", "networking", "connectivity"]
					property var icon
					stdout: StdioCollector {
						onStreamFinished:{
							if (this.text == "none\n" || this.text == "unknown\n"){
								con.icon = "󱞐"
							}
							if (this.text == "full\n") {
								con.icon = "󰤨"
							}
							if (this.text == "portal\n" || this.text == "limited\n") {
								con.icon = "󰤩"
							}
											}
					}
				}
				Timer {
					id: dateTimer
					interval: 1000
					repeat: true
					running: true
					onTriggered: {
						con.running = true
					}
				}
				Button {
					anchors.left: parent.left
					anchors.bottom: parent.bottom
					anchors.bottomMargin: parent.height/20
					implicitWidth: parent.width
					implicitHeight: parent.height/4
					
					onClicked: {
						
					}
					background: Rectangle {
						color:"transparent"
					}
					Text {
						anchors.fill: parent
						anchors.leftMargin: parent.width/2-implicitWidth/2 
						color: config.colors["color11"]
						font.pixelSize: parent.width*.6
						text: con.icon
					}
				}
				
			}
			Text {

				anchors.left: parent.left
				anchors.top: parent.top
				anchors.topMargin: parent.height * .01
				anchors.leftMargin: rbar.width/2 - implicitWidth/2
				text: Math.round(UPower.displayDevice.percentage*100)
				font.pixelSize: rbar.width/3
				font.family: montserrat.name
			}
			Rectangle {
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.topMargin: parent.height * .035
				anchors.leftMargin: rbar.width/2 - implicitWidth/2
				implicitWidth: rbar.width/1.8
				implicitHeight: rbar.width/6
				radius: 25
				color: UPower.onBattery? config.colors["color0"] : config.colors["color11"]
			}

			Text {
				anchors.bottom: parent.bottom
				anchors.left: parent.left
				anchors.leftMargin: rbar.width / 2 - implicitWidth/2
				anchors.bottomMargin: parent.height * .01
				font.pixelSize: rbar.width/2
				font.family: montserrat.name
				text: Hyprland.focusedWorkspace.id
			}
			SystemClock {
				id: clock
				precision: SystemClock.Secconds
			}	
			Text { 
				anchors.bottom: parent.bottom
				anchors.left: parent.left
				anchors.leftMargin: rbar.width/2 - implicitWidth/2
				font.pixelSize: rbar.width * .35
				font.family: montserrat.name
				horizontalAlignment: Text.AlignHCenter
				anchors.bottomMargin: parent.height * .06
				text: Qt.formatDateTime(clock.date, "h:mm\nA")
			}
		}
}
	Variants {
		model: Quickshell.screens
		PanelWindow{
			required property var modelData
			screen: modelData
			id:volumeControl
			aboveWindows:true
			anchors.right:true
			exclusiveZone:0
			implicitHeight:Screen.height / 2.5
			implicitWidth: Screen.width / 30
			color: "transparent"
			visible:false
			property int volume: root.volume
			onVolumeChanged: {
				volumeControl.visible = true
				hideTimer.start()
				hideTimer.restart()
					
			}
			Timer {
				id: hideTimer
				interval: 800
				repeat: false
				onTriggered: {
					volumeControl.visible = false
				}
			}
			Item{
				id: topRadi
				anchors.top: parent.top
				anchors.right: parent.right
				anchors.left:parent.left
				implicitHeight:50
				visible:false
				Rectangle{
					anchors.fill:parent
					bottomRightRadius:25
					color:"white"
					
				}
			}
			Item{
				id: bottomRadi
				anchors.bottom: parent.bottom
				anchors.right: parent.right
				anchors.left:parent.left
				implicitHeight:50
				visible:false
				Rectangle{
					anchors.fill:parent
					topRightRadius:25
					color:"white"
					
				}
	
			}
			Rectangle{
	
				implicitHeight:50
				anchors.bottom:parent.bottom
				anchors.right: parent.right
				anchors.left: parent.left
				color: config.colors["color12"]
				layer.enabled: true
	        		layer.effect: OpacityMask {
	       		     	maskSource: bottomRadi // Use the mask item defined above
				invert: true // This is the key property for reverse clipping
				}
				
			}
			Rectangle{
	
				implicitHeight:50
				anchors.top:parent.top
				anchors.right: parent.right
				anchors.left: parent.left
				color: config.colors["color12"]
				layer.enabled: true
	        		layer.effect: OpacityMask {
	       		     	maskSource: topRadi // Use the mask item defined above
	        		invert: true // This is the key property for reverse clipping
	        }
				
			}
			Rectangle{
				antialiasing: true
				anchors.fill: parent
				color: config.colors["color12"]
				topLeftRadius: 25
				bottomLeftRadius: 25
				anchors.topMargin:50
				anchors.bottomMargin:50
				
		
				Rectangle{
					antialiasing:true

					implicitWidth: parent.width/3
					color: config.colors["color0"]
					anchors.bottom: parent.bottom
					anchors.right: parent.right
					anchors.top: parent.top
					anchors.rightMargin: parent.width/2 - implicitWidth/2
					anchors.topMargin: parent.height/10
					anchors.bottomMargin: parent.height/6
					radius:25
					clip:true
					
					
				
					Rectangle{
						antialiasing: true	
						implicitWidth: parent.width/3
						color: config.colors["color11"]
						anchors.bottom: parent.bottom
						anchors.right: parent.right
						anchors.left: parent.left
						property int max:parent.height-25 
						property int vol: root.overVolume ? max : volume/100*max
						
						implicitHeight:vol+25
						radius:25
						

					}
					Rectangle{
						antialiasing: true	
						implicitWidth: parent.width/3
						color:config.colors["color10"]
						anchors.bottom: parent.bottom
						anchors.right: parent.right
						anchors.left: parent.left
						property int max:parent.height-25 
						property int vol:root.volume2/100*max
						visible: root.overVolume
						implicitHeight:vol+25
						radius:25
						
					}

				 
					
				}
			
				Text{
					anchors.bottom:parent.bottom
					anchors.right: parent.right
					anchors.rightMargin: parent.width/2 - implicitWidth/2
					anchors.bottomMargin: parent.height * .06
					font.pixelSize: parent.width/3.5
					font.family: montserrat.name
					text: root.volume
					color: root.overVolume ? "red" : "black"
				}	
	
			}
			
		}

	}
	Variants {
		model: Quickshell.screens
		PanelWindow{
			required property var modelData
			screen: modelData
			id: modules
			color: "transparent"
			visible:false
			anchors{
				top: true
			}
			implicitWidth: Screen.width/2
			implicitHeight: Screen.height/2.5
			exclusiveZone:0
			GlobalShortcut {
    				name: "performance"
				onPressed: modules.visible = !modules.visible

			}
			Rectangle {
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.right: parent.right
				anchors.rightMargin: 25
				implicitWidth: parent.width -50
				color: config.colors["color12"]
				bottomLeftRadius:25
				bottomRightRadius:25
				/*Button{
					anchors.top:parent.top
					anchors.left: parent.left
					anchors.leftMargin: parent.width/2 - implicitWidth/2
					implicitWidth: parent.width/3
					implicitHeight:parent.height/32
					background: Rectangle {
						anchors.fill: parent
						bottomRightRadius:25
						bottomLeftRadius:25
						color: config.colors["color0"]
					}
					onClicked: {
						modVis = false
					}	
				}*///depricated for space bar
				Rectangle{
					id: tabs
					anchors.right: parent.right
					anchors.left: parent.left
					anchors.top: parent.top
					anchors.topMargin: parent.height/10
					implicitHeight: parent.height/12
					color: config.colors["color12"]
					Button {
						id: mediaButton
						anchors.top: parent.top
						anchors.left: parent.left
						implicitHeight: parent.height
						implicitWidth: parent.width/3.5
						Text {
							anchors.fill: parent
							font.pixelSize: parent.height*.8
							font.family: montserrat.name
							text: "   Media"
							horizontalAlignment: Text.AlignHCenter
							verticalAlignment: Text.AlignVCenter
						}
						background: Rectangle {
							color: "transparent"
						}
						onClicked: {
							media.visible = true
							performance.visible = false
							power.visible = false
						}

					}
					Button {
						id: performanceButton
						anchors.top: parent.top
						anchors.left: parent.left
						anchors.leftMargin: parent.width/2 - implicitWidth/2
						implicitHeight: parent.height
						implicitWidth: parent.width/3.5
						Text {
							anchors.fill: parent
							font.pixelSize: parent.height*.8
							font.family: montserrat.name
							text: "   Performance"
							horizontalAlignment: Text.AlignHCenter
							verticalAlignment: Text.AlignVCenter
						}
						background: Rectangle {
							color: "transparent"
						}
						onClicked: {
							media.visible = false
							performance.visible = true
							power.visible = false
						}
					}
					Button {
						id: powerButton
						anchors.top: parent.top
						anchors.right: parent.right	
						implicitHeight: parent.height
						implicitWidth: parent.width/3.5
						Text {
							anchors.fill: parent
							font.pixelSize: parent.height*.8
							font.family: montserrat.name
							text: "  Power"
							horizontalAlignment: Text.AlignHCenter
							verticalAlignment: Text.AlignVCenter
						}
						background: Rectangle {
							color: "transparent"
						}
						onClicked: {
							media.visible = false
							performance.visible = false
							power.visible = true
						}	
					}
					

				}
				
				Rectangle{
					id: media
					anchors.right: parent.right
					anchors.top: parent.top
					implicitWidth:parent.width * .9
					implicitHeight:parent.height *.75
					anchors.rightMargin:parent.width/2 -implicitWidth/2
					anchors.topMargin: parent.height/5
					color: config.colors["color12"]
					visible: true
					Rectangle {
						id: albumCover
						anchors.top: parent.top
						anchors.left: parent.left
						implicitHeight: parent.height
						implicitWidth: parent.height
						radius: 25		

						color: config.colors["color0"]
						Image {
							anchors.centerIn: parent
							width: parent.width*.9
							height: parent.height*.9
							source: playerButton.player.trackArtUrl 


						}
					}
					Slider {
						id: progress
						from: 0 
						to: playerButton.player.length
						value: playerButton.player? playerButton.player.position : 0
						anchors.bottom: parent.bottom
						anchors.left: parent.left
						anchors.leftMargin: (parent.width - albumCover.width)/2 +albumCover.width -implicitWidth/2
						clip:true
						
						background: Rectangle {
							implicitWidth: media.height*1.2
							implicitHeight: media.height/20
							radius: 25
							color: config.colors["color0"]
							Rectangle {
								implicitWidth:progress.visualPosition*progress.width
								implicitHeight: parent.height
								color: config.colors["color11"]
								radius:25

							}
							
						}
						
						handle: Rectangle {
							x: progress.visualPosition * progress.width -width
							y: parent.height/2 - height/2
							
							width: media.height/20
							height: media.height/20
							radius:25
							color:config.colors["color11"]
						}
						
					}
					FrameAnimation {
 						 // only emit the signal when the position is actually changing.
  						running: playerButton.player.playbackState == MprisPlaybackState.Playing
 						 // emit the positionChanged signal every frame.
  						onTriggered: playerButton.player.positionChanged()
					}
					Timer {
 						// only emit the signal when the position is actually changing.
						running: playerButton.player.playbackState == MprisPlaybackState.Playing
						interval: 5000
						repeat:true
 						// emit the positionChanged signal every frame.
  						onTriggered: playerButton.player.lengthChanged()
					}
					Text {
							id:timee
							anchors.bottom: parent.bottom
							anchors.left: parent.left
							anchors.leftMargin: (parent.width - albumCover.width)/2 +albumCover.width -implicitWidth/2
							anchors.bottomMargin: media.height/20	
							text: playerButton.player.length <= 3600? playerButton.player.length >= 0? Math.floor(playerButton.player.position/60) +":"+ String(Math.floor(playerButton.player.position%60)).padStart(2,'0') +"/"+Math.floor(playerButton.player.length/60) +":"+ String(Math.floor(playerButton.player.length%60)).padStart(2,'0') : "--:--":Math.floor(playerButton.player.position/3600)+":"+ String(Math.floor(playerButton.player.position/60%60)).padStart(2, '0') +":"+ String(Math.floor(playerButton.player.position%60)).padStart(2,'0') +"/"+ Math.floor(playerButton.player.length/3600)+":"+Math.floor(playerButton.player.length/60%60) +":"+ String(Math.floor(playerButton.player.length%60)).padStart(2,'0')
						
							
					}
					Button {
						id: playButton
						anchors.top: parent.top
						anchors.left: parent.left
						anchors.topMargin: parent.height*.75-implicitWidth/2
						anchors.leftMargin: (parent.width - albumCover.width)/2 +albumCover.width -implicitWidth/2
						background: Rectangle {
							implicitWidth: media.height/5
							implicitHeight: media.height/5
							radius: implicitWidth/2
							color: config.colors["color0"]

						}
						Text {
							anchors.centerIn:parent
							font.pixelSize: parent.height*.7
							text: playerButton.player.isPlaying? "":""
							horizontalAlignment: Text.AlignHCenter
							color: config.colors["color11"]

						}
						onClicked: {
							playerButton.player.isPlaying = !playerButton.player.isPlaying
						}
					}
					Button {
						id: skipButton
						anchors.top: parent.top
						anchors.left: parent.left
						anchors.topMargin: parent.height*.75 - implicitWidth/2
						anchors.leftMargin: ((parent.width - albumCover.width)/2 +albumCover.width -implicitWidth/2)+implicitHeight+ parent.height/12
						background: Rectangle {
							implicitWidth: media.height/6
							implicitHeight: media.height/6
							radius: implicitWidth/2
							color: config.colors["color0"]

						}
						Text {
							anchors.centerIn:parent
							font.pixelSize: parent.height*.5
							text: ""
							horizontalAlignment: Text.AlignHLeft
							color: config.colors["color11"]

						}
						onClicked: {
							playerButton.player.next()
						}
					}
					Button {
						id: prevButton
						anchors.top: parent.top
						anchors.left: parent.left
						anchors.topMargin: parent.height*.75 - implicitWidth/2
						anchors.leftMargin: ((parent.width - albumCover.width)/2 +albumCover.width -implicitWidth/2)-implicitHeight- parent.height/12
						background: Rectangle {
							implicitWidth: media.height/6
							implicitHeight: media.height/6
							radius: implicitWidth/2
							color: config.colors["color0"]

						}
						Text {
							anchors.centerIn:parent
							font.pixelSize: parent.height*.5
							text: ""
							horizontalAlignment: Text.AlignHRight
							color: config.colors["color11"]

						}
						onClicked: {
							playerButton.player.previous()
						}
					}
					Text {
						id: trackTitle
						anchors.top: parent.top
						anchors.left: parent.left
						text: (playerButton.player.trackTitle).length > 27? (playerButton.player.trackTitle).slice(0,25) + "..." : playerButton.player.trackTitle
						anchors.leftMargin: (parent.width - albumCover.width)/2 +albumCover.width -implicitWidth/2
						anchors.topMargin: parent.height/2.7
						font.pixelSize: parent.height/10
						font.family: montserrat.name

					}
					Text {
						id: artist
						anchors.top: parent.top
						anchors.left: parent.left
						text: playerButton.player.trackArtist + " - " + playerButton.player.trackAlbum || ""
						anchors.leftMargin: (parent.width - albumCover.width)/2 +albumCover.width -implicitWidth/2
						anchors.topMargin: parent.height/2
						font.pixelSize: parent.height/20
						font.family: montserrat.name

					}
					Button {
						id: playerButton
						anchors.top: parent.top
						anchors.left: parent.left
						anchors.leftMargin: (parent.width - albumCover.width)/2 +albumCover.width -implicitWidth/2
						anchors.topMargin: parent.height/12
						property int index
						property var dName: player.dbusName.split('.')[3].toUpperCase().slice()[0] +  player.dbusName.split('.')[3].slice(1)
						property var player: Mpris.players.values[index]
						background: Rectangle {
							implicitWidth: media.height/1.8
							implicitHeight: media.height/12
							topRightRadius: 25
							topLeftRadius: 25
							bottomLeftRadius: 25
							bottomRightRadius: 25

							color:config.colors["color0"]
						}
						Text {
							id: playerText
							anchors.centerIn: parent
							text: playerButton.dName
							font.pixelSize: parent.height/2
							font.family: montserrat.name
							color: config.colors["color11"]
						}
						Menu {
							id: playerSelector
							implicitWidth: parent.width
							y: parent.y + parent.height/4
							visible: false
							background: Rectangle {
								color: config.colors["color0"]
								radius: parent.height/4							}
							Repeater {
								model:Mpris.players.values
								MenuItem {
									property var name: model.dbusName.split('.')[3].toUpperCase().slice()[0] +  model.dbusName.split('.')[3].slice(1)
									onTriggered: {
										playerText.text = name
										playerButton.index = index
									}
									Text{
										anchors.centerIn: parent
										font.pixelSize: playerButton.height/2
										font.family: montserrat.name
										color: config.colors["color11"]
										text: name
									}

								}
							}

						}
						onClicked: {
							playerSelector.visible = !playerSelector.visible
							playerButton.bottomRightRadius = 0
							playerButton.bottomLeftRadius = 0

						}

					}

					
				}	
				Rectangle{
					id: performance
					anchors.right: parent.right
					anchors.top: parent.top
					implicitWidth: parent.width * .9
					implicitHeight: parent.height *.75
					anchors.rightMargin: parent.width/2 -implicitWidth/2
					anchors.topMargin: parent.height/5
					visible: false
					color: config.colors["color12"]
					Process {
						id: cpuTemp
						command: ["cat", "/sys/class/thermal/thermal_zone0/temp"]
						property int temp
						running: true
						stdout: StdioCollector{
							onStreamFinished: {
								cpuTemp.temp = parseInt(this.text) /1000
							}
						}
					}
					Timer {
						interval:500
						running: true
						repeat: true
						onTriggered: {
							cpuTemp.running = true
						}
					}
					Rectangle {
						id: temp
						anchors.right: parent.right
						anchors.bottom: parent.bottom
						anchors.topMargin: parent.height/2-implicitHeight/3 
						implicitWidth: parent.height/1.5
						implicitHeight: parent.height/1.5
						radius: 25
						color: config.colors["color0"]
						Text {
							anchors.centerIn: parent
							text: cpuTemp.temp+"C"
							color: config.colors["color11"]
							font.pixelSize: parent.height/3
							font.family: montserrat.name
						}
						Text {
							anchors.bottom: parent.bottom
							anchors.left: parent.left
							anchors.bottomMargin: parent.height/5
							anchors.leftMargin: parent.width/2 - implicitWidth/2
							text: "Temp"
							font.pixelSize: parent.height/10
							font.family: montserrat.name
							color: config.colors["color11"]
						}

					}
					Process {
						id: ramUsed
						command: ["sh", "-c", "free --giga | awk 'FNR == 2 {print $3}'"]
						property int used
						running: true
						stdout: StdioCollector{
							onStreamFinished: {
								ramUsed.used = this.text
							}
						}
					}
					Timer {
						interval:500
						running: true
						repeat: true
						onTriggered: {
							ramUsed.running = true
						}
					}
					Process {
						id: ramTot
						command: ["sh", "-c", "free --giga | awk 'FNR == 2 {print $2}'"] 
						property int total
						running: true
						stdout: StdioCollector{
							onStreamFinished: {
								ramTot.total = this.text
							}
						}
					}
					Timer {
						interval:500
						running: true
						repeat: true
						onTriggered: {
							ramTot.running = true
						}
					}
					Rectangle {
						id: ram
						anchors.left: parent.left
						anchors.bottom:parent.bottom
						implicitWidth: parent.height/1.5
						implicitHeight: parent.height/1.5
						radius: 25
						Text {
							anchors.centerIn: parent
							text: ramUsed.used+"G /"+ramTot.total+"G"
							color: config.colors["color11"]
							font.pixelSize: parent.height/5
							font.family: montserrat.name
						}
						Text {
							anchors.bottom: parent.bottom
							anchors.left: parent.left
							anchors.bottomMargin: parent.height/5
							anchors.leftMargin: parent.width/2 - implicitWidth/2
							text: "Ram"
							font.pixelSize: parent.height/10
							font.family: montserrat.name
							color: config.colors["color11"]
						}
						color: config.colors["color0"]


					}
					Rectangle {
						id: cpu
						anchors.left: parent.left
						anchors.bottom: parent.bottom
						anchors.topMargin: parent.height/2-implicitHeight/2
						anchors.leftMargin: parent.width/2-implicitWidth/2
						implicitWidth: parent.height/1.5
						implicitHeight: parent.height/1.5
						radius:25
						color: config.colors["color0"]
						Text {
							anchors.centerIn: parent
							text: "15%"
							color: config.colors["color11"]
							font.pixelSize: parent.height/3
							font.family: montserrat.name
						}
						Text {
							anchors.bottom: parent.bottom
							anchors.left: parent.left
							anchors.bottomMargin: parent.height/5
							anchors.leftMargin: parent.width/2 - implicitWidth/2
							text: "CPU"
							font.pixelSize: parent.height/10
							font.family: montserrat.name
							color: config.colors["color11"]
						}
					
					}
					Process {
						id: perf
						command: ["powerprofilesctl", "get"]
						property var icon
						stdout: StdioCollector {
							onStreamFinished: {
								if (this.text == "performance\n")
								{
									perf.icon = "   Performance"
								}
								if (this.text == "balanced\n")
								{
									perf.icon = "    Balanced"
								}
								if (this.text == "power-saver\n")
								{
									perf.icon = "   Eco"
								}
							}
						}
					}
					Timer {
						interval: 2000
						repeat: true
						running: true
						onTriggered: {
							perf.running = true
						}
	
					}
					Rectangle {
						id: perfDisplay
						anchors.top: parent.top
						anchors.left: parent.left
						implicitHeight: parent.height/8
						implicitWidth: parent.height
						radius: 25
						color: config.colors["color0"]
						Text {
							text: perf.icon
							anchors.fill: parent
							verticalAlignment: Text.AlignVCenter
							anchors.leftMargin: parent.width/20
							font.family: montserrat.name
							font.pixelSize: parent.height*.65
							color: config.colors["color11"]
							
						}
					}
					Process {
						id: diskProc
						command: ["sh", "-c", "df -BG / | awk 'FNR == 2 {print $3 \" /\"$2}'"]
						property var icon
						stdout: StdioCollector {
							onStreamFinished: {
								diskProc.icon = this.text
							}							
						}
					}
					Timer {
						interval: 5000
						repeat: true
						running: true
						onTriggered: {
							diskProc.running = true
						}
	
					}
					Rectangle {
						id: disk
						anchors.top: parent.top
						anchors.left: parent.left
						anchors.topMargin: implicitHeight + parent.height/30
						implicitHeight: parent.height/8
						implicitWidth: parent.height
						radius: 25
						color: config.colors["color0"]
						Text {
							text: "   "+diskProc.icon
							anchors.fill: parent
							verticalAlignment: Text.AlignVCenter
							anchors.leftMargin: parent.width/20
							font.family: montserrat.name
							font.pixelSize: parent.height*.65
							color: config.colors["color11"]
							
						}
					}
					Rectangle {
						anchors.top: parent.top
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.leftMargin: parent.height + parent.height/10
						implicitHeight: parent.height/4 + parent.height/30
						radius: 25
						color: config.colors["color0"]
						Text {
							anchors.left: parent.left
							anchors.top:parent.top
							anchors.topMargin:parent.height/6
							horizontalAlignment: Text.AlignHLeft
							anchors.leftMargin: parent.width/20
							font.family: montserrat.name
							font.pixelSize: parent.height/3.3
							color: config.colors["color11"]
							text: "Full In: " + Math.ceil(UPower.displayDevice.timeToFull/60) +"Minutes"	
						}
						Text {
							anchors.left: parent.left
							anchors.top:parent.top
							anchors.topMargin:parent.height/2
							horizontalAlignment: Text.AlignHLeft
							anchors.leftMargin: parent.width/20
							font.family: montserrat.name
							font.pixelSize: parent.height/3.3
							color: config.colors["color11"]
							text: "Empty In: " + Math.ceil(UPower.displayDevice.timeToEmpty/60) +"Minutes"	
						}
						


					}
				}
				Rectangle{
					id: power
					anchors.right: parent.right
					anchors.top: parent.top
					implicitWidth: parent.width * .9
					implicitHeight: parent.height *.75
					anchors.rightMargin: parent.width/2 -implicitWidth/2
					anchors.topMargin: parent.height/5
					visible: false
					color: config.colors["color12"]
					Button {
						anchors.left: parent.left
						anchors.top: parent.top
						implicitHeight: parent.height/2.2
						implicitWidth: parent.height/2.2
						background: Rectangle {
							radius: 25
							color: config.colors["color0"]
							Text {
								anchors.fill: parent
								horizontalAlignment: Text.AlignHCenter
								verticalAlignment: Text.AlignVCenter
								font.family: monstserrat.name
								font.pixelSize: parent.width /2
								color: config.colors["color11"]
								text: " "
								
							}
						}
						onClicked: {
							Quickshell.execDetached(["hyprlock"])
							modVis = false
						}

					}
					Button {
						anchors.left: parent.left
						anchors.bottom: parent.bottom 
						implicitHeight: parent.height/2.2
						implicitWidth: parent.height/2.2
						background: Rectangle {
							radius: 25
							color: config.colors["color0"]
							Text {
								anchors.fill: parent
								horizontalAlignment: Text.AlignHCenter
								verticalAlignment: Text.AlignVCenter
								font.family: monstserrat.name
								font.pixelSize: parent.width /2
								color: config.colors["color11"]
								text: "󰤄 "
								
							}
						}
						onClicked: {
							Quickshell.execDetached(["systemctl", "suspend"])
							modVis = false
						}
						
					}
					Button {
						anchors.left: parent.left
						anchors.bottom: parent.bottom 
						anchors.leftMargin: parent.height/2.2 + parent.height/10
						implicitHeight: parent.height/2.2
						implicitWidth: parent.height/2.2
						background: Rectangle {
							radius: 25
							color: config.colors["color0"]
							Text {
								anchors.fill: parent
								horizontalAlignment: Text.AlignHCenter
								verticalAlignment: Text.AlignVCenter
								font.family: monstserrat.name
								font.pixelSize: parent.width /2
								color: config.colors["color11"]
								text: " "

								
							}
						}
						onClicked: {
							Quickshel.execDetached(["shutdown"]);
						}
						
					}
					Button {
						anchors.left: parent.left
						anchors.top: parent.top
						anchors.leftMargin: parent.height/2.2 + parent.height/10
						implicitHeight: parent.height/2.2
						implicitWidth: parent.height/2.2
						background: Rectangle {
							radius: 25
							color: config.colors["color0"]
							Text {
								anchors.fill: parent
								horizontalAlignment: Text.AlignHCenter
								verticalAlignment: Text.AlignVCenter
								font.family: monstserrat.name
								font.pixelSize: parent.width /2
								color: config.colors["color11"]
								text: " "
								
							}
						}
						onClicked: {
							Quickshell.execDetached(["reboot"]);

						}
						
					}
					Button {
						anchors.left: parent.left
						anchors.bottom: parent.bottom
						anchors.leftMargin: parent.height/2.2*2 + parent.height/10*2
						implicitHeight: parent.height/2.2
						implicitWidth: parent.height/2.2*3.2
						background: Rectangle {
							radius: 25
							color: config.colors["color0"]
							Text {
								anchors.fill: parent
								horizontalAlignment: Text.AlignHCenter
								verticalAlignment: Text.AlignVCenter
								font.family: montserrat.name
								font.pixelSize: parent.height /2
								color: config.colors["color11"]
								text: "Logout 󰍃"

								
							}
						}
						onClicked: {
							Quickshell.execDetached(["hyprctl","dispatch","exit"]);
						}
						
						
					}
					Process {
						id: os
						running:true
						command: ["uname", "-sr"]
						property var name
						stdout: StdioCollector {
							onStreamFinished: {
								os.name=this.text
							}
						}


					}
					Process {
						id: uptime
						running:true
						command: ["sh", ".config/quickshell/uptime.sh"]
						property var val
						stdout: StdioCollector {
							onStreamFinished: {
								uptime.val=this.text
							}
						}


					}
					Timer {
						interval: 30000
						running: true
						repeat: true
        					onTriggered:uptime.running=true 
					}
					Text {
						anchors.left: parent.left
						anchors.top: parent.top
						anchors.leftMargin: parent.height/2.1*2 + parent.height/10*2
						anchors.topMargin: parent.height/10
						font.pixelSize: parent.height/12
						font.family: montserrat.name
						text: "Uptime: "+uptime.val
						
					}
					Text {
						anchors.left: parent.left
						anchors.top: parent.top
						anchors.leftMargin: parent.height/2.1*2 + parent.height/10*2
						anchors.topMargin: implicitHeight+parent.height/18
						font.pixelSize: parent.height/12 
						font.family: montserrat.name
						text: "Kernel: "+os.name
						
					}
				}

				

				
			}
			Rectangle {
				anchors.top: parent.top
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				anchors.rightMargin: parent.width-25
				implicitWidth: 50	
				color: config.colors["color12"]
				layer.enabled: true
				layer.effect: OpacityMask {
					maskSource: rightRadi
					invert:true
				}
			}
			Item{
				id: leftRadi
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.left:parent.left
				implicitWidth: 50
				visible:false
				Rectangle{
					anchors.fill:parent
					topLeftRadius:25
					color:"white"
					
				}
	
			}
			Item{
				id: rightRadi
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.right:parent.right
				implicitWidth: 50
				visible:false
				Rectangle{
					anchors.fill:parent
					topRightRadius:25
					color:"white"
					
				}
	
			}
			Rectangle {
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.bottom: parent.bottom
				anchors.leftMargin: parent.width-25
				implicitWidth: 50	
				color: config.colors["color12"]
				layer.enabled: true
				layer.effect: OpacityMask {
					maskSource: leftRadi
					invert: true
				}
			}

		}
	}
	/*Variants {
		model: Quickshell.screens
		PanelWindow{
			required property var modelData
			screen: modelData
			id: hiddenModules
			color: "transparent"
			visible:true
			anchors{
				top: true
			}
			implicitWidth: Screen.width/6
			implicitHeight: Screen.height/80
			exclusiveZone:0
			Rectangle {
				anchors.fill: parent
				color: "transparent"
				Button {
					anchors.fill: parent
					background: Rectangle {
						anchors.fill: parent
						bottomRightRadius:25
						bottomLeftRadius:25
						color: config.colors["color1"]
					}
					onClicked: {
						modVis = true
					}
				}
			}
			
		}
	}*///depricated space bar
	Variants {
		model: Quickshell.screens
		PanelWindow{
			required property var modelData
			screen: modelData
			id: warnings
			visible:false
			color: "transparent"
			implicitWidth: Screen.width/4.5
			implicitHeight: Screen.height/5
			exclusiveZone: 0
			property var bat: Math.round(UPower.displayDevice.percentage*100)
			onBatChanged: {
				if(UPower.onBattery){
					if(bat == 20 || bat == 10 || bat == 5)
					{
						warnings.visible = true
					}
				}
			}
			Rectangle {
				anchors.fill: parent
				color: config.colors["color12"]
				radius: 25
				Text {
					font.family: montserrat.name
					font.pixelSize: parent.height/7
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: parent.height*.05
					horizontalAlignment: Text.AlignHCenter
					text: "Warning: Battery Low"
				}
				Text {
					
					font.family: montserrat.name
					font.pixelSize: parent.height/10
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: parent.height*.3
					horizontalAlignment: Text.AlignHCenter
					text: "Battery has reached "+bat+"% plug in or enter power save mode to ."
					width: parent.width*.7
					
					wrapMode: Text.WordWrap
				}
				
				Button {
					anchors.bottom: parent.bottom
					anchors.left: parent.left
					implicitWidth: parent.width*.4
					implicitHeight: parent.height*.17
					anchors.leftMargin:parent.width*.06
					anchors.bottomMargin: parent.height*.1
					background: Rectangle {
						radius:25
						color: config.colors["color0"]
						Text {
							font.family:montserrat.name
							font.pixelSize: parent.height*.6
							anchors.centerIn:parent
							color: config.colors["color11"]
							text: "Power saver"
						}
					}
					onClicked: {
						warnings.visible = false
						Quickshell.execDetached(["sh","-c","powerprofilesctl set power-saver"])
					}	

				}
				Button { 
					anchors.bottom: parent.bottom
					anchors.right: parent.right
					implicitWidth: parent.width*.4
					implicitHeight: parent.height*.17
					anchors.rightMargin:parent.width*.06
					anchors.bottomMargin: parent.height*.1
					background: Rectangle {
						radius:25
						color: config.colors["color0"]
						Text {
							font.family:montserrat.name
							font.pixelSize: parent.height*.6
							anchors.centerIn:parent
							color: config.colors["color11"]
							text: "Ok"

						}
					}
					onClicked: {
						warnings.visible = false
					}
				}
			}

		}
	}
	Variants {
		model: Quickshell.screens
		PanelWindow{
			id:assistant
			anchors {
				
				bottom: true
				right:true
			}
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand	
			color: "transparent"
			implicitHeight: 100+reply.height
			implicitWidth: 525
			visible:false
			GlobalShortcut {
    				name: "assistant"
				onPressed: assistant.visible = !assistant.visible

			}
			Rectangle {
				id:mainbox
				anchors.fill: parent
				anchors.rightMargin: 25
				anchors.bottomMargin: 25
				radius:25
				color: config.colors["color12"]
				Text {
					id: reply
					text: "Hello, What can i do for you today!"
					font.pixelSize: 20
					font.family: montserrat.name
					anchors.left: parent.left
					anchors.top: parent.top
					anchors.leftMargin: 30
					anchors.topMargin: 15
					wrapMode: Text.Wrap
					width: parent.width-50
				}
				Process {
					id:ai
					running:false
					command: ["ollama","run","llama3.2:1b "+input.text]
	        
        				stdout: StdioCollector {
        					onStreamFinished: {
							reply.text = this.text;
							Quickshell.execDetached=["killall","ollama"]
						
							
            					}
        				}

				}
				TextField {
					id: input
					implicitWidth: parent.width-40
					implicitHeight: 35
					anchors.bottom: parent.bottom
					anchors.bottomMargin: 15
					anchors.horizontalCenter: parent.horizontalCenter
					z:1
					font.family: montserrat.name
					font.pixelSize: 18
					font.bold: true
					leftPadding:15
					wrapMode: Text.Wrap
					color: config.colors["color11"]
					placeholderText: "Ask anything"
        				placeholderTextColor: config.colors["color11"]
					background: Rectangle {
						radius:25
						color: config.colors["color6"]
					}
					focus:true
					onAccepted: {
						Quickshell.execDetached=["ollama","serve"]	
						ai.running=true
						reply.text="..."
						text=""
						
					}
				}
				

			}
		}
	}
}
