; 使用须知：请在你个generalsettings.ini里面设置好
; 7z
; 7zg
; 的路径
; 这是配合candy的用法，独立用的话，请自行修改
Cando_智能解压:          ;IntUnZip ======= intelligent UnZip
	IntUnZip_Many_In_FirstLevel:=0
	IntUnZip_Folder_In_FirstLevel:=0
	aaaa:=
	bbbb:=
	Count:=1

	IntUnZip_FileLists=%a_temp%\wannianshuyao_IntUnZip_%a_now%.txt
	Splitpath ,CandySelected,,IntUnZip_FileDir,,IntUnZip_FileNameNoExt,IntUnZip_FileDrive
	DriveSpaceFree , IntUnZip_FreeSpace, %IntUnZip_FileDrive%
	FileGetSize, IntUnZip_FileSize, %CandySelected%, M
	If ( IntUnZip_FileSize > IntUnZip_FreeSpace )
	{
		MsgBox 磁盘空间不足,请检查后再解压。`n------------`n压缩包大小为%IntUnZip_FileSize%M`n剩余空间为%IntUnZip_FreeSpace%M
		Return
	}
	Runwait, %Comspec% /C %7Z% L "%CandySelected%" `>"%IntUnZip_FileLists%",,hide

	;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	Loop,read,%IntUnZip_FileLists%
	{
		If(regexmatch(a_loopreadline,"^\d{4}-\d{2}-\d{2}"))
		{
			If( Instr(a_loopreadline,"d")=21 Or Instr(a_loopreadline,"\"))  ;本行如果包含\或者有d标志，则判定为文件夹
			{
				IntUnZip_Folder_In_FirstLevel=1
			}
			aaaa:=RegExReplace(A_LoopReadLine,"^\d{4}-\d{2}-\d{2}.{43}(.*?)(\\.*|$)","$1")
			If(bbbb != aaaa  And  bbbb!="" )
			{
; 				MsgBox %aaaa%`n%bbbb%
				IntUnZip_Many_In_FirstLevel=1
				Break
			}
			bbbb:=aaaa
		}
	}
	Filedelete,%IntUnZip_FileLists%
	;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
; 	MsgBox IntUnZip_Many_In_FirstLevel=%IntUnZip_Many_In_FirstLevel%  IntUnZip_Folder_In_FirstLevel=%IntUnZip_Folder_In_FirstLevel%
	If(IntUnZip_Many_In_FirstLevel=0 && IntUnZip_Folder_In_FirstLevel=0 )   ;压缩文件内，首层有且仅有一个文件
	{
		Run, %7Zg% X "%CandySelected%" -O"%IntUnZip_FileDir%"    ;覆盖还是改名，交给7z
	}
	Else If(IntUnZip_Many_In_FirstLevel=0 && IntUnZip_Folder_In_FirstLevel=1 )   ;压缩文件内，首层有且仅有一个文件夹
	{
		IntUnzip_FilePath:=IntUnZip_FileDir "\" aaaa
		If not	FileExist(IntUNzip_FilePath)  ;不存在同名文件夹？则直接解压
		{
			Run, %7Zg% X "%CandySelected%" -O"%IntUnZip_FileDir%"
		}
		Else  ;存在同名文件夹？则加一个后缀。遗憾的是，这样的话，一定会生成”多余“文件夹。
		{
			IntUnzip_FilePath_test:=IntUnzip_FilePath
			While,fileexist(IntUnzip_FilePath)
			{
				IntUnzip_FilePath:=IntUnzip_FilePath_test "(" Count ")"
				Count+=1
			}
			Run %7Zg% X  "%CandySelected%" -O"%IntUnzip_FilePath%"
		}
	}
	Else  ;压缩文件内，首层有多个文件(夹)，此时不论怎么的，都得生成 “压缩文件名”为名的文件夹。
	{
		IntUnzip_FilePath :=IntUnZip_FileDir "\" IntUnZip_FileNameNoExt
		IntUnzip_FilePath_test:=IntUnzip_FilePath
		While,fileexist(IntUnzip_FilePath)
		{
			IntUnzip_FilePath:=IntUnzip_FilePath_test "(" Count ")"
			Count+=1
		}
		Run %7Zg% X  "%CandySelected%" -O"%IntUnzip_FilePath%"
	}
	Return
