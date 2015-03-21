' Contributors: Pierluca Borso
Attribute VB_Name = "Module1"
Sub DuplicateMasterSlide()
    ActivePresentation.Slides(1).Copy
    ActivePresentation.Slides.Paste (ActivePresentation.Slides.Count + 1)
End Sub

Sub InsertAndSizePicture(oSl As Slide, i As Integer)

    Dim oPicture As Shape
    Dim FullPath As String

    ' Set this to the full path to picture.
    FullPath = "C:\Users\Pilu\Dropbox\PolyProg\HC2\2012\teampics\" & i & ".jpg"

    Dim l As Single, t As Single, w As Single, h As Single
    w = ActivePresentation.SlideMaster.Width / 2
    h = w * 2 / 3
    l = ActivePresentation.SlideMaster.Width / 2 - (w / 2)
    t = ActivePresentation.SlideMaster.Height / 4
    
    ' Insert the picture at an arbitrary size;
    ' PowerPoint requires you to supply *some* height and width for the picture
    Set oPicture = oSl.Shapes.AddPicture(FileName:=FullPath, _
       LinkToFile:=msoFalse, _
       SaveWithDocument:=msoTrue, _
       Left:=l, Top:=t, _
       Width:=w, Height:=h)

    ' Rescale the picture to its "natural" slze
    'With oPicture
    '   .ScaleHeight 1, msoTrue
    '   .ScaleWidth 1, msoTrue
    'End With

    Set oPicture = Nothing
    Set oSl = Nothing

End Sub


Sub GeneratePresentation()

    Dim osld As Slide, oshp As Shape
    
    Dim sourceXL As Excel.Application
    Dim sourceBook As Excel.Workbook
    Dim sourceSheet As Excel.Worksheet
    
    Dim teamCount As Integer
    
    Set sourceXL = Excel.Application
    Set sourceBook = sourceXL.Workbooks.Open("C:\Users\Pilu\Dropbox\PolyProg\HC2\2012\final_rank.xls")
    Set sourceSheet = sourceBook.Sheets(1)
    
    teamCount = 1
    
    Do While sourceSheet.Range("A" & teamCount).Value <> vbNullString
        
        Call DuplicateMasterSlide
        
        
        Set osld = ActivePresentation.Slides(teamCount + 1)
        
        osld.Shapes(1).TextFrame.TextRange.Text = sourceSheet.Range("B" & teamCount).Value
        osld.Shapes(2).TextFrame.TextRange.Text = sourceSheet.Range("C" & teamCount).Value
        osld.Shapes(3).TextFrame.TextRange.Text = sourceSheet.Range("D" & teamCount).Value
        osld.Shapes(4).TextFrame.TextRange.Text = "Points: " & sourceSheet.Range("E" & teamCount).Value
        osld.Shapes(5).TextFrame.TextRange.Text = "Penalties: " & sourceSheet.Range("F" & teamCount).Value
        osld.Shapes(6).TextFrame.TextRange.Text = "Time: " & sourceSheet.Range("G" & teamCount).Value
        osld.Shapes(7).TextFrame.TextRange.Text = sourceSheet.Range("H" & teamCount).Value
        
        Call InsertAndSizePicture(osld, sourceSheet.Range("A" & teamCount).Value)
        
        teamCount = teamCount + 1
    Loop

    'For Each osld In ActivePresentation.Slides
     '   sourceSheet.Range("A1").Select
     '   osld.Shapes(1).TextFrame.TextRange.Text = sourceSheet.Range("A1").Value
     '   sourceSheet.Range("A2").Select
     '   osld.Shapes(2).TextFrame.TextRange.Text = sourceSheet.Range("B1").Value
     '   osld.Shapes(3).TextFrame.TextRange.Text = "Not that many penaltiles"
    'Next osld
End Sub
