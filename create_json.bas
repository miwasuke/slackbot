Attribute VB_Name = "Module1"
Sub make_json()

ThisWorkbook.Activate
'�ϐ���`
    Dim fileName, fileFolder, fileFile As String
    Dim isFirstRow As Boolean
    Dim i, u As Long

'�ŏI�s�擾
    Dim maxRow, maxCol As Long
    If Len(ActiveSheet.Range("A2").Value) = 0 Then
        maxRow = 0
    ElseIf Len(ActiveSheet.Range("A3").Value) = 0 Then
        maxRow = 2
    Else
        maxRow = ActiveSheet.Range("A1").End(xlDown).Row
    End If
'�ŏI��擾
    maxCol = Range("A1").End(xlToRight).Column


'JSON�t�@�C����`
    fileName = "all_qanda.json"                 'JSON�t�@�C�������w��
    fileFolder = ThisWorkbook.Path         '�V�����t�@�C���̕ۑ���t�H���_��
    fileFile = fileFolder & "\" & fileName '�V�����t�@�C�����t���p�X�Œ�`

    '������JSON�t�@�C�������ɂ���ꍇ�͍폜����
    If Dir(fileFile) <> "" Then
        Kill fileFile
    End If

'JSON�쐬
    '�I�u�W�F�N�g��p�ӂ���
    Dim txt As Object
    Set txt = CreateObject("ADODB.Stream")
    txt.Charset = "UTF-8"
    txt.Open

    'JSON�J�n�^�O
    isFirstRow = True
    txt.WriteText "[" & vbCrLf, adWriteLine

    '���X�g���I�u�W�F�N�g�ɏ�������
    For i = 2 To maxRow
        '1�s�ڂ��m�F����2�s�ڈȍ~�̏ꍇ�͍s����","��}��
        If isFirstRow = True Then
            isFirstRow = False
        Else
            txt.WriteText "," & vbCrLf, adWriteLine
        End If

        '�s�̊J�n�^�O��}��
            txt.WriteText vbTab & "{" & vbCrLf, adWriteLine
            txt.WriteText vbTab & vbTab & """" & "id" & """" & ":" & i - 2 & "," & vbCrLf, adWriteLine
            For u = 1 To maxCol
                '�ŏI��łȂ��ꍇ��","��}��
                If u = maxCol Then
                    txt.WriteText vbTab & vbTab & """" & Cells(1, u).Value & """" & ":" & """" & Cells(i, u).Value & """" & vbCrLf, adWriteLine
                Else
                    txt.WriteText vbTab & vbTab & """" & Cells(1, u).Value & """" & ":" & """" & Cells(i, u).Value & """" & "," & vbCrLf, adWriteLine
                End If
            Next u

        '�s�̕��^�O��}��
        txt.WriteText vbTab & "}", adWriteLine
    Next

    'JSON�I���^�O
    txt.WriteText vbCrLf, adWriteLine
    txt.WriteText "]" & vbCrLf, adWriteLine

    '�I�u�W�F�N�g�̓��e���t�@�C���ɕۑ�
    txt.SaveToFile fileFile

    '�I�u�W�F�N�g�����
    txt.Close


    MsgBox ("�t�@�C���𐶐����܂����")


End Sub
