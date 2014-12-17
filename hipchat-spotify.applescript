tell application "Spotify"
	set current_track to null
	set current_artist to null
	set current_album to null
	set userName to short user name of (system info)
	set auth_token to "YOUR_HIPCHAT_AUTH_TOKEN_FOR_THE_ROOM_GOES_HERE"
	set room_id to "YOUR_HIPCHAT_ROOM_ID_TO_NOTIFY_GOES_HERE"
	
	repeat until application "Spotify" is not running
		set track_name to name of current track
		set track_artist to artist of current track
		set track_album to album of current track
		
		if track_name is not current_track and track_artist is not current_artist and track_album is not current_track then
			set current_track to name of current track
			set current_artist to artist of current track
			set current_album to album of current track
			
			set message to userName & " is listening to " & current_artist & " - " & current_track
			set message_escaped to my replace("'", "`", message)
			
			do shell script "curl -sS -d 'auth_token=" & auth_token & "&from=Spotify&color=yellow&message=" & message_escaped & "' https://api.hipchat.com/v2/room/" & room_id & "/notification"
			
		end if
		
		delay 5
	end repeat
	tell me to quit
end tell

on replace(A, B, theText)
	set L to length of A
	set K to L - 1
	set P to offset of A in theText
	repeat until P = 0
		if P = 1 then
			set theText to B & text (L + 1) through -1 of theText
		else if P = (length of theText) - K then
			set theText to text 1 through -(L + 1) of theText & B
		else
			set theText to text 1 through (P - 1) of theText & B & text (P + L) through -1 of theText
		end if
		set P to offset of A in theText
	end repeat
	return theText
end replace
