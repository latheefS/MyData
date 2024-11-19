Dim FSO
Dim fCheckFiles, fWrapFiles
Dim WshShell, strCurDir

Set WshShell = CreateObject("WScript.Shell")
strCurDir    = WshShell.CurrentDirectory
'Sub main()

Set FSO = CreateObject("Scripting.FileSystemObject")

Set fCheckFiles = fso.CreateTextFile("CheckFiles.txt")
Set fWrapFiles = fso.CreateTextFile("WrapFiles.txt")

WrapFolder fso.GetFolder (strCurDir), strCurDir
'strPath = Wscript.ScriptFullName

fCheckFiles.Close
fWrapFiles.Close

'End Sub

Sub ReplaceText(FileName)

	Dim NewValue
	Dim OldValue
	Dim fName
	Dim Rewrite
	Dim fo

	Set f = fso.GetFile(FileName)
	Set ts = f.OpenAsTextStream(1,-2)
	Set fo = fso.CreateTextFile(FileName & "tmp")

    Rewrite = False
    
    if not ts.AtEndOfStream then
		OldValue = ts.ReadLine
	End If
	
    While not ts.AtEndOfStream
        
        NewValue = OldValue
        
        If InStr(OldValue, "@") > 0 Then
            If InStr(UCase(OldValue), ".SQL") > 0 Or InStr(UCase(OldValue), ".PKS") > 0 Or InStr(UCase(OldValue), ".PKB") > 0 Then
                NewValue = Replace(NewValue, ".sql", ".sqlplb")
                NewValue = Replace(NewValue, ".SQL", ".sqlplb")
                NewValue = Replace(NewValue, ".pks", ".pksplb")
                NewValue = Replace(NewValue, ".PKS", ".pksplb")
                NewValue = Replace(NewValue, ".pkb", ".pkbplb")
                NewValue = Replace(NewValue, ".PKB", ".pkbplb")
                Rewrite = True
            Else
                If InStr(LCase(OldValue), "mxdm_nvis_extract") = 0 Then
                    fCheckFiles.WriteLine FileName
'                    fCheckFiles.WriteLine OldValue
                End If
            End If
        End If
            
        fo.WriteLine NewValue
    
		OldValue = ts.ReadLine
    
    Wend
    
    ts.Close
    fo.Close
    
    If Rewrite Then
        fso.DeleteFile FileName
        fso.MoveFile FileName & "tmp", FileName
    Else
        fso.DeleteFile FileName & "tmp"
    End If
    
End Sub

Sub WrapFolder(Folder, FolderName)
    
	Dim FileName
	Dim file
	Dim cmd

	For Each file In Folder.Files
		If InStr(file.Name, "wrapper.xlsm") = 0 And file.Name <> "CheckFiles.txt" And file.Name <> "Wrapper.vbs" And file.Name <> "DoIt.bat" And file.Name <> "WrapFiles.txt" Then
			FileType = UCase(Mid(file.Name, InStrRev(file.Name, ".")))
			Select Case FileType
			Case ".SQL", ".PKS", ".PKB"
				ReplaceText (Folder & "\" & file.Name)
				cmd = "wrap iname=" & Chr(34) & Folder & "\" & file.Name & """ oname=""" & Folder & "\" & file.Name & "plb"""
				fWrapFiles.WriteLine cmd
				cmd = "del """ & Folder & "\" & file.Name & """"
				fWrapFiles.WriteLine cmd
			End Select
		End If
	Next

	For Each subfolder In Folder.SubFolders
		WrapFolder subfolder, FolderName
	Next
		
End Sub

