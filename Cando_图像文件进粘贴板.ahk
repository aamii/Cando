;必须用到Winclip库
;请自行下载   ; http://www.autohotkey.com/community/viewtopic.php?f=13&t=79998
Cando_图像文件进粘贴板:
	ImageFile =%CandySel%
	if RegExMatch(ImageFile, "i)^(https?|ftp)://")
		return
	html =
	(
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
	<HTML><HEAD></HEAD>
	<BODY><!--StartFragment--><IMG src="%ImageFile%"><!--EndFragment--></BODY>
	</HTML>
	)
	WinClip.Clear()
	WinClip.SetHTML( html )
	WinClip.SetFiles( ImageFile )
	WinClip.SetBitmap( ImageFile )
	return
