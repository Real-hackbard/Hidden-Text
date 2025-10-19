unit Unit1;

interface

uses
  Windows, FORMS, StdCtrls, Buttons, Controls, Graphics, Classes,dialogs,
  ExtCtrls,Messages, SysUtils, ExtDlgs, Vcl.ComCtrls, UEncrypt, ShellApi,
  Vcl.Menus, IdCoderHeader;

type
  TForm1 = class(TForm)
    OpenPictureDialog1: TOpenPictureDialog;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    Memo1: TMemo;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Panel3: TPanel;
    Splitter1: TSplitter;
    SaveDialog1: TSaveDialog;
    GroupBox1: TGroupBox;
    Button1: TBitBtn;
    Button2: TBitBtn;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    Open1: TMenuItem;
    GroupBox3: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label3: TLabel;
    Clear1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Panel4: TMenuItem;
    Crypt1: TMenuItem;
    None1: TMenuItem;
    EncryptDecrypt1: TMenuItem;
    N2: TMenuItem;
    Memo2: TMemo;
    Edit2: TMenuItem;
    procedure CryptToImage(MyImage: TImage;MyMemo:Tmemo);
    procedure DecryptImage(MyImage: TImage;MyMemo:Tmemo);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure ScrollBox1Resize(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure None1Click(Sender: TObject);
    procedure EncryptDecrypt1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
  private
    { Declarations privates }
    originalScrollBoxWindowProc : TWndMethod;
    procedure ScrollBoxWindowProc (var Msg : TMessage) ;
    procedure ScrollBoxImageDrop (var Msg : TWMDROPFILES) ;
  public
    { Declarations public }
  end;

var
  Form1   : TForm1;

implementation

{$R *.DFM}
procedure TForm1.ScrollBoxWindowProc(var Msg: TMessage) ;
begin
  (*PanelWindowProc*)
    if Msg.Msg = WM_DROPFILES then
      ScrollBoxImageDrop(TWMDROPFILES(Msg))
    else
      originalScrollBoxWindowProc(Msg) ;
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  if Image1.Picture.Graphic = nil then begin
    MessageDlg('No Picture to Save!',mtInformation, [mbOK], 0);
    Exit;
  end;

  Button2.Click;
end;

procedure TForm1.ScrollBox1Resize(Sender: TObject);
begin
  Label2.Left := (ScrollBox1.Width div 2) - 50;
  Label2.Top := (ScrollBox1.Height div 2);
end;

procedure TForm1.ScrollBoxImageDrop(var Msg: TWMDROPFILES) ;
var
    numFiles : longInt;
    buffer : array[0..MAX_PATH] of char;

    FileHeader: TBitmapFileHeader;
    InfoHeader: TBitmapInfoHeader;
    Stream    : TFileStream;
    SeedKey : integer;
begin
    numFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0) ;
    if numFiles > 1 then
    begin
      ShowMessage('You can drop only one image file at a time!') ;
    end
    else
    begin
      DragQueryFile(Msg.Drop, 0, @buffer, sizeof(buffer)) ;
      try
        Image1.Picture.LoadFromFile(buffer) ;
      except
        on EInvalidGraphic do ShowMessage('Unsupported image file, or not an image!') ;
      end;
    end;

    Label2.Visible := false;

    try
      Stream := TFileStream.Create(buffer, fmOpenRead or fmShareDenyNone);
        Stream.Read(FileHeader, SizeOf(FileHeader));
        Stream.Read(InfoHeader, SizeOf(InfoHeader));
        StatusBar1.Panels[1].Text := ExtractFileName(buffer);
        StatusBar1.Panels[3].Text := Format('%d Kb', [FileHeader.bfSize div 1000]);
        StatusBar1.Panels[5].Text := Format('%d', [InfoHeader.biBitCount]);
        StatusBar1.Panels[7].Text := Format('%d', [InfoHeader.biWidth]) + 'x' +
                                     Format('%d', [InfoHeader.biHeight]);
        StatusBar1.Panels[9].Text := Format('%d', [InfoHeader.biPlanes]);
        StatusBar1.Panels[11].Text := Format('%d', [InfoHeader.biClrUsed]);
      finally
        Stream.Free;
      end;

    DecryptImage(Image1,Memo1);

    if RadioButton1.Checked = true then
    begin
      SeedKey := StrToInt(Edit1.Text);
      Memo1.Text := Decrypt(Memo1.Text,SeedKey);
    end;

end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked = true then begin
    Memo1.ReadOnly := false;
    Memo1.Enabled := true;
    Memo1.Color := clWhite;
    Edit2.Checked := true;
  end else begin
    Memo1.ReadOnly := true;
    Memo1.Enabled := false;
    Memo1.Color := $00E2E0E0;
    Edit2.Checked := false;
  end;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
var
  s, s2 : string;
begin
  if CheckBox2.Checked = true then begin
    Memo2.Text := Memo1.Text;
    s := Memo1.Text;
    s2 := DecodeHeader(s);
    Memo1.Text := s2;
  end else begin
    Memo1.Text := Memo2.Text;
  end;
end;

procedure TForm1.Clear1Click(Sender: TObject);
begin
  Image1.Picture.Graphic := nil;
  StatusBar1.Panels[1].Text := '';
  StatusBar1.Panels[3].Text := '0 Kb';
  StatusBar1.Panels[5].Text := '0';
  StatusBar1.Panels[7].Text := '0x0';
  StatusBar1.Panels[9].Text := '0';
  StatusBar1.Panels[11].Text := '0';
  Label2.Visible := true;
  Memo1.Clear;
end;

procedure TForm1.CryptToImage(MyImage: TImage ;MyMemo:TMemo);
var
  x, y    : integer;
  col     : integer;
  cpt     : integer;
  R, G, B : byte;
  C       : byte;
  txt     : string;
  maxbyte : integer;
  OKformat: boolean;
begin
  txt := MyMemo.Text + #0;

  maxbyte := (MyImage.Picture.Width - 1) * (MyImage.Picture.Height - 1);
  if length(txt) > maxbyte then
    begin
      showmessage('Text too long');
      exit;
    end;

  OKformat := MyImage.Picture.Bitmap.PixelFormat = pf24bit;
  if not OKformat then
    begin
      showmessage('Sorry, 24-bit/pixel images are required.');
      exit;
    end;

  cpt := 1;
  while cpt <= length(txt) do
    begin
      C := byte(txt[cpt]);
      x := (cpt - 1) mod MyImage.Picture.Width;
      y := (cpt - 1) div MyImage.Picture.Width;
      col := MyImage.canvas.Pixels[x, y];
      R := getRvalue(col);
      G := getGvalue(col);
      B := getBvalue(col);
      R := R and 248 or (C and 7);
      G := G and 248 or (C and 56) shr 3;
      B := B and 252 or (C and 192) shr 6;
      MyImage.Canvas.Pixels[x, y] := RGB(R, G, B);

      cpt := cpt + 1;
    end;

end;

procedure TForm1.DecryptImage(MyImage: TImage;MyMemo:Tmemo);
var
  i, j    : integer;
  X, Y    : integer;
  cpt     : integer;
  R, G, B : byte;
  C       : byte;
  txt     : string;
  Ligne   : pbytearray;
  bX      : integer;
  OKformat: boolean;
begin
  MyMemo.Clear;
  txt := '';
  OKformat := MyImage.Picture.Bitmap.PixelFormat = pf24bit;
  if not OKformat then
    begin
      Beep;
      Image1.Picture.Graphic := nil;
      StatusBar1.Panels[1].Text := 'Invalid Bitmap';
      StatusBar1.Panels[3].Text := '0';
      StatusBar1.Panels[5].Text := '0';
      StatusBar1.Panels[7].Text := '0x0';
      StatusBar1.Panels[9].Text := '0';
      StatusBar1.Panels[11].Text := '0';
      showmessage('Sorry, 24-bit/pixel Images are required.');
      Label2.Visible := true;
      Label2.Left := (ScrollBox1.Width div 2) - 50;
      Label2.Top := (ScrollBox1.Height div 2);
      exit;
    end;

  cpt := 1;

    for Y := 0 to MyImage.Height - 1 do
      begin
        Ligne := MyImage.Picture.Bitmap.ScanLine[Y];
        for X := 0 to MyImage.Width - 1 do
          begin
            bX := X * 3;
            B := ligne[bx];
            G := ligne[bx + 1];
            R := ligne[bx + 2];
            C := ((B and 3) shl 6) or ((G and 7) shl 3) or (R and 7);
            cpt := cpt + 1;
            if C = 0 then
              begin
                MyMemo.Text := txt;
                exit;
              end;
            txt := txt + chr(C);
          end;
      end;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if NOT (Key in [#08, '0'..'9']) then
    Key := #0;
end;

procedure TForm1.Edit2Click(Sender: TObject);
begin
  CheckBox1.Checked := not CheckBox1.Checked;
end;

procedure TForm1.EncryptDecrypt1Click(Sender: TObject);
begin
  RadioButton1.Checked := true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;

  originalScrollBoxWindowProc := ScrollBox1.WindowProc;
  ScrollBox1.WindowProc := ScrollBoxWindowProc;
  DragAcceptFiles(ScrollBox1.Handle,true) ;

  Label2.Left := (ScrollBox1.Width div 2) - 50;
  Label2.Top := (ScrollBox1.Height div 2);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Label2.Left := (ScrollBox1.Width div 2) - 50;
  Label2.Top := (ScrollBox1.Height div 2);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  StatusBar1.SetFocus;
end;

procedure TForm1.None1Click(Sender: TObject);
begin
  RadioButton2.Checked := true;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  Button1.Click;
end;

procedure TForm1.Panel4Click(Sender: TObject);
begin
  Panel1.Visible  := Panel4.Checked;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  EncryptDecrypt1.Checked := true;
  StatusBar1.SetFocus;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  None1.Checked := true;
  StatusBar1.SetFocus;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  SeedKey : integer;
begin
  if RadioButton1.Checked = true then begin
    SeedKey := StrToInt(Edit1.Text);
    Memo1.Text := Encrypt(Memo1.Text,SeedKey);
  end;

  CryptToImage(Image1, Memo1);

  if SaveDialog1.Execute then begin
    Image1.Picture.SaveToFile(SaveDialog1.FileName + '.bmp');
  end;

  StatusBar1.SetFocus;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  FileHeader: TBitmapFileHeader;
  InfoHeader: TBitmapInfoHeader;
  Stream    : TFileStream;
  SeedKey : integer;
begin
  Memo1.Clear;
  if OpenPictureDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);

      try
        Stream := TFileStream.Create(OpenPictureDialog1.FileName, fmOpenRead or fmShareDenyNone);
          Stream.Read(FileHeader, SizeOf(FileHeader));
          Stream.Read(InfoHeader, SizeOf(InfoHeader));
          StatusBar1.Panels[1].Text := ExtractFileName(OpenPictureDialog1.FileName);
          StatusBar1.Panels[3].Text := Format('%d Kb', [FileHeader.bfSize div 1000]);
          StatusBar1.Panels[5].Text := Format('%d', [InfoHeader.biBitCount]);
          StatusBar1.Panels[7].Text := Format('%d', [InfoHeader.biWidth]) + 'x' +
                                       Format('%d', [InfoHeader.biHeight]);
          StatusBar1.Panels[9].Text := Format('%d', [InfoHeader.biPlanes]);
          StatusBar1.Panels[11].Text := Format('%d', [InfoHeader.biClrUsed]);
      finally
          Stream.Free;
          Label2.Visible := false;
      end;
        DecryptImage(Image1,Memo1);
  end;

  if RadioButton1.Checked = true then
  begin
    SeedKey := StrToInt(Edit1.Text);
  Memo1.Text := Decrypt(Memo1.Text,SeedKey);
  end;

  StatusBar1.SetFocus;
end;

end.

