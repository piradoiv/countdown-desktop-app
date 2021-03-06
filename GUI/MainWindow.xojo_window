#tag DesktopWindow
Begin DesktopWindow MainWindow
   Backdrop        =   0
   BackgroundColor =   NormalBackgroundColor
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   True
   HasCloseButton  =   True
   HasFullScreenButton=   True
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   400
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   2045237247
   MenuBarVisible  =   False
   MinimumHeight   =   150
   MinimumWidth    =   230
   Resizeable      =   True
   Title           =   "Countdown"
   Type            =   0
   Visible         =   True
   Width           =   600
   Begin DesktopLabel CountdownLabel
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "Monaco"
      FontSize        =   120.0
      FontUnit        =   0
      Height          =   328
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "--:--"
      TextAlignment   =   2
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   560
   End
   Begin DesktopButton ResetButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Reset"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   360
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin Timer CountdownTimer
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   1000
      RunMode         =   2
      Scope           =   2
      TabPanelIndex   =   0
   End
   Begin DesktopButton SettingsButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Settings"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   500
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   360
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Closing()
		  App.Settings.TimerMinutes = Minutes
		  App.Settings.Left = Left
		  App.Settings.Top = Top
		  App.Settings.Width = Width
		  App.Settings.Height = Height
		  App.Settings.FontName = CountdownLabel.FontName
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  Minutes = App.Settings.TimerMinutes
		  Left = App.Settings.Left
		  Top = App.Settings.Top
		  Width = App.Settings.Width
		  Height = App.Settings.Height
		  CountdownLabel.FontName = App.Settings.FontName
		  
		  If App.FinishTime = Nil Then
		    ResetCountdown
		  End If
		  UpdateLabel
		  
		  If App.Settings.HideMainWindowOnStart Then
		    Self.Hide
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  UpdateFontSize
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  UpdateFontSize
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub ResetCountdown()
		  MainWindow.BackgroundColor = NormalBackgroundColor
		  App.FinishTime = DateTime.Now.AddInterval(0, 0, 0, 0, Minutes, 1)
		  CountdownTimer.RunMode = Timer.RunModes.Multiple
		  UpdateLabel
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateDockIcon(minutes As String)
		  If LastMinuteShown = minutes Then Return
		  LastMinuteShown = minutes
		  
		  Const radius = 1400
		  Const padding = 200
		  
		  Var g As Graphics = App.DockItem.Graphics
		  
		  g.ClearRectangle(0, 0, g.Width, g.Height)
		  g.DrawPicture(icon_background, 0, 0, g.Width, g.Height, 0, 0, icon_background.Width, icon_background.Height)
		  g.DrawingColor = Color.White
		  g.FontSize = 720
		  g.FontName = App.Settings.FontName
		  
		  Var textWidth As Integer = g.TextWidth(minutes)
		  g.DrawText(minutes, g.Width / 2 - textWidth / 2, g.Height / 2 + g.FontSize / 3)
		  
		  App.DockItem.UpdateNow
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateFontSize()
		  CountdownLabel.FontSize = If(Width >= 420, kBigFontSize, kSmallFontSize)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateLabel()
		  Var remainingTime As DateInterval = App.FinishTime - DateTime.Now
		  
		  If remainingTime.Minutes <= 0 And remainingTime.Seconds <= 0 Then
		    CountdownTimer.RunMode = Timer.RunModes.Off
		    MainWindow.BackgroundColor = FinishedBackgroundColor
		  End If
		  
		  Var minutes As String = remainingTime.Minutes.ToString("00")
		  Var seconds As String = remainingTime.Seconds.ToString("00")
		  
		  CountdownLabel.Text = minutes + ":" + seconds
		  UpdateDockIcon(minutes)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private LastMinuteShown As String = "-"
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Minutes As Integer = 25
	#tag EndProperty


	#tag Constant, Name = kBigFontSize, Type = Double, Dynamic = False, Default = \"120", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSmallFontSize, Type = Double, Dynamic = False, Default = \"60", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events ResetButton
	#tag Event
		Sub Pressed()
		  ResetCountdown
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CountdownTimer
	#tag Event
		Sub Action()
		  UpdateLabel
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SettingsButton
	#tag Event
		Sub Pressed()
		  Var d As New SettingsDialog
		  d.SelectedFont = CountdownLabel.FontName
		  d.TimerMinutes = Minutes
		  d.HideMainWindowOnStart = App.Settings.HideMainWindowOnStart
		  d.ShowModal(Self)
		  
		  CountdownLabel.FontName = d.SelectedFont
		  Var oldMinutesValue As Integer = Minutes
		  Minutes = d.TimerMinutes
		  App.Settings.HideMainWindowOnStart = d.HideMainWindowOnStart
		  
		  If oldMinutesValue <> Minutes Then
		    ResetCountdown
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Windows Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
