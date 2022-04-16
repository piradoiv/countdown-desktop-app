#tag Class
Protected Class AppSettings
	#tag Method, Flags = &h0
		Shared Function FromJSONString(jsonString As String) As AppSettings
		  Var result As New AppSettings
		  
		  Try
		    Var json As Dictionary = ParseJSON(jsonString)
		    result.Left = json.Lookup("left", 20)
		    result.Top = json.Lookup("top", 100)
		    result.Width = json.Lookup("width", 600)
		    result.Height = json.Lookup("height", 400)
		    result.FontName = json.Lookup("font_name", "Monaco")
		    result.TimerMinutes = json.Lookup("timer_minutes", 25)
		  Catch
		  End Try
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToJSON() As String
		  Var json As New Dictionary
		  json.Value("left") = Left
		  json.Value("top") = Top
		  json.Value("width") = Width
		  json.Value("height") = Height
		  json.Value("font_name") = FontName
		  json.Value("timer_minutes") = TimerMinutes
		  
		  Return GenerateJSON(json)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		FontName As String = "Monaco"
	#tag EndProperty

	#tag Property, Flags = &h0
		Height As Integer = 400
	#tag EndProperty

	#tag Property, Flags = &h0
		Left As Integer = 20
	#tag EndProperty

	#tag Property, Flags = &h0
		TimerMinutes As Integer = 25
	#tag EndProperty

	#tag Property, Flags = &h0
		Top As Integer = 100
	#tag EndProperty

	#tag Property, Flags = &h0
		Width As Integer = 600
	#tag EndProperty


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
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=false
			Group="Behavior"
			InitialValue="400"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=false
			Group="Behavior"
			InitialValue="600"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontName"
			Visible=false
			Group="Behavior"
			InitialValue="Monaco"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
