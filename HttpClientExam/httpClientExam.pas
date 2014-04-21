unit httpClientExam;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdIOHandler,
  IdIOHandlerStream, IdThreadComponent, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdCookieManager, IdZLibCompressorBase, IdCompressorZLib,IdURI,System.JSON,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Edit1: TEdit;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdCookieManager1: TIdCookieManager;
    httpID: TEdit;
    passwd: TEdit;
    Timer1: TTimer;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure IdHTTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure IdHTTP1Connected(Sender: TObject);
    procedure IdHTTP1Disconnected(Sender: TObject);
  private
    { Private declarations }
    procedure Log(log : string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
s:string;
i,j:Integer;
request : string;
Buff:TStringStream;
MS : TMemoryStream;
JPEGImage : TJPEGImage;
lURI :TIdURI;
LJSONObject , LInnerJson  : TJSONObject;
begin
s := 'A';
try
  request := Edit1.Text + '?'+'return_type=json'+ '&mb_id='+ httpID.Text+'&mb_password=' +passwd.Text ;
  Buff := TStringStream.Create;
IdHTTP1.Get(request,Buff);
except on E: Exception do
ShowMessage(E.ToString);
end;

  Memo1.Lines.Add(TIdURI.URLDecode(s));
  LJSONObject := TJSONObject.Create;
  LJSONObject.Parse(Buff.Bytes,0,Buff.Size);
  for i :=  0 to LJSONObject.Count-1 do
   begin
   Log(TIdURI.URLDecode( LJSONObject.Get(i).ToString));
   end;
//Memo1.Lines.Add(TIdURI.URLDecode(s));
//Memo1.Lines.Add(TIdURI.URLDecode(LJSONObject.ToString));
//
   MS := TMemoryStream.Create;
   JPEGImage  := TJPEGImage.Create;

   try
   IdHTTP1.Get('https://s3-ap-northeast-1.amazonaws.com/markmedia-menutab/mt_store_menu/s1362558242588/m1370952536933/img_0/634981905_l1IdjAbN_EBB984ED9484ECB0B9EC8AA4ED858CEC9DB4ED81AC.jpg',MS);
   except on E: Exception do
   ShowMessage(E.ToString);
   end;

    MS.Seek(0,soFromBeginning);
     JPEGImage.LoadFromStream(MS);//load the image in a Stream
     Image1.Picture.Assign(JPEGImage);//Load the image in a Timage component

//




end;

procedure TForm1.IdHTTP1Connected(Sender: TObject);
begin
Memo1.Lines.Add( '����');
end;

procedure TForm1.IdHTTP1Disconnected(Sender: TObject);
begin
Memo1.Lines.Add('����');
end;

procedure TForm1.IdHTTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
Memo1.Lines.Add(AStatusText);
end;

procedure TForm1.Log(log:string);
var
msg:string;
begin
msg := '[' + FormatDateTime('yyyy-mm-dd, HH:MM:SS', Now) + ']';
Memo1.Lines.Add(msg + log);
end;


end.
