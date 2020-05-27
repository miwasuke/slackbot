Attribute VB_Name = "Module1"
Sub make_json()

ThisWorkbook.Activate
'変数定義
    Dim fileName, fileFolder, fileFile As String
    Dim isFirstRow As Boolean
    Dim i, u As Long

'最終行取得
    Dim maxRow, maxCol As Long
    If Len(ActiveSheet.Range("A2").Value) = 0 Then
        maxRow = 0
    ElseIf Len(ActiveSheet.Range("A3").Value) = 0 Then
        maxRow = 2
    Else
        maxRow = ActiveSheet.Range("A1").End(xlDown).Row
    End If
'最終列取得
    maxCol = Range("A1").End(xlToRight).Column


'JSONファイル定義
    fileName = "all_qanda.json"                 'JSONファイル名を指定
    fileFolder = ThisWorkbook.Path         '新しいファイルの保存先フォルダ名
    fileFile = fileFolder & "\" & fileName '新しいファイルをフルパスで定義

    '同名のJSONファイルが既にある場合は削除する
    If Dir(fileFile) <> "" Then
        Kill fileFile
    End If

'JSON作成
    'オブジェクトを用意する
    Dim txt As Object
    Set txt = CreateObject("ADODB.Stream")
    txt.Charset = "UTF-8"
    txt.Open

    'JSON開始タグ
    isFirstRow = True
    txt.WriteText "[" & vbCrLf, adWriteLine

    'リストをオブジェクトに書き込む
    For i = 2 To maxRow
        '1行目か確認して2行目以降の場合は行頭に","を挿入
        If isFirstRow = True Then
            isFirstRow = False
        Else
            txt.WriteText "," & vbCrLf, adWriteLine
        End If

        '行の開始タグを挿入
            txt.WriteText vbTab & "{" & vbCrLf, adWriteLine
            txt.WriteText vbTab & vbTab & """" & "id" & """" & ":" & i - 2 & "," & vbCrLf, adWriteLine
            For u = 1 To maxCol
                '最終列でない場合は","を挿入
                If u = maxCol Then
                    txt.WriteText vbTab & vbTab & """" & Cells(1, u).Value & """" & ":" & """" & Cells(i, u).Value & """" & vbCrLf, adWriteLine
                Else
                    txt.WriteText vbTab & vbTab & """" & Cells(1, u).Value & """" & ":" & """" & Cells(i, u).Value & """" & "," & vbCrLf, adWriteLine
                End If
            Next u

        '行の閉じタグを挿入
        txt.WriteText vbTab & "}", adWriteLine
    Next

    'JSON終了タグ
    txt.WriteText vbCrLf, adWriteLine
    txt.WriteText "]" & vbCrLf, adWriteLine

    'オブジェクトの内容をファイルに保存
    txt.SaveToFile fileFile

    'オブジェクトを閉じる
    txt.Close


    MsgBox ("ファイルを生成しました｡")


End Sub
