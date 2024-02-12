unit RESTer;

interface

uses
  System.Classes, System.SysUtils, System.JSON, LogInterfaces, REST.Client, JWTGenerator;

type
  TFilesInRest = class
  public
    FileName: String;
    FileMes: TMemoryStream;
  end;

  TArrayFilesInRest = array of TFilesInRest;

  TRester = class
  private
    FLog: ILog;
    FJwtGenerator: TJWTGenerator;
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FsRESTClient: TRESTClient;
    procedure Log(AMessage: String);
    function getUINError(Error: String): String;
  public
    constructor Create(ALog: ILog);
    destructor Destroy(); override;
  public
    function Post(Resource: String; RequestObject: TJSONObject; ArrayFilesInRestout: TArrayFilesInRest; out ResponceObject: TJSONObject; out ContentOur: String): Boolean;
  end;

implementation

uses
  REST.Types, IPPeerCommon, Data.Bind.Components, Data.Bind.ObjectScope, System.StrUtils, ServiceConstants;

{ TRester }

constructor TRester.Create(ALog: ILog);
var
  Strings: TStringList;
  OpenedKey: String;
  ClosedKey: String;
begin
  FLog := ALog;

  Strings := TStringList.Create();
  try
    Strings.LoadFromFile(PathToKey1);
    OpenedKey := Strings.Text;
    Strings.LoadFromFile(PathToKey2);
    ClosedKey := Strings.Text;
    FJwtGenerator := TJWTGenerator.Create(OpenedKey, ClosedKey, IdentIS, PathCovidService);
  finally
    FreeAndNil(Strings);
  end;

  FsRESTClient := TRESTClient.Create(nil);
  FsRESTClient.UserAgent := 'MIS KSAMU';
  FsRESTClient.BaseURL := PathCovidService;

  FRESTResponse := TRESTResponse.Create(nil);

  FRESTRequest := TRESTRequest.Create(nil);
  FRESTRequest.Client := FsRESTClient;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.Accept := 'application/json';
  FRESTRequest.Timeout := 18000;

  FRESTResponse.ContentEncoding := 'UTF-8';
  FsRESTClient.AcceptCharset := 'UTF-8';
  FsRESTClient.AcceptEncoding := 'UTF-8';
  FsRESTClient.ContentType := 'charset=utf-8';
  FsRESTClient.FallbackCharsetEncoding := 'UTF-8';
  FsRESTClient.AllowCookies := True;
  FsRESTClient.AutoCreateParams := True;
  FsRESTClient.HandleRedirects := True;
  FsRESTClient.RaiseExceptionOn500 := True;
  FsRESTClient.SynchronizedEvents := True;
  FRESTRequest.AcceptCharset := 'UTF-8';
  FRESTRequest.AcceptEncoding := 'UTF-8';
end;

destructor TRester.Destroy();
begin
  FreeAndNil(FsRESTClient);
  FreeAndNil(FRESTResponse);
  FreeAndNil(FRESTRequest);
end;

function TRester.getUINError(Error: String): String;
var
  posTemp: Integer;
begin
  posTemp:=Pos('local_id = [',Error);
  Result:=Copy(Error,posTemp+12,36);
end;

function TRester.Post(Resource: String; RequestObject: TJSONObject; ArrayFilesInRestout: TArrayFilesInRest; out ResponceObject: TJSONObject; out ContentOur: String): Boolean;
var
  AMessage: String;
  i: Integer;
  JSON: TJSONObject;
  str: string;
begin
  Result := False;
  ResponceObject := nil;
  try
    FRESTRequest.ClearBody();
    FRESTRequest.Params.Clear();
    FRESTRequest.Params.AddHeader('Authorization', 'Bearer ' + FJwtGenerator.CreateToken());// TODO: Передать токен
    FRESTRequest.Params.Items[0].Options := [poDoNotEncode];
    FRESTRequest.Resource := Resource;
    FRESTRequest.Method := TRestRequestMethod.rmPost;

    if Length(ArrayFilesInRestout)>0 then
    begin
      FRESTRequest.AddParameter('record', RequestObject.ToJSON(), TRESTRequestParameterKind.pkREQUESTBODY);
//      FsRESTClient.Params.AddItem('Content-Type','application/json', TRESTRequestParameterKind.pkREQUESTBODY, [], TRESTContentType.ctAPPLICATION_JSON);
//      FRESTRequest.AddParameter('Content-Type', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
//      FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
      for I := 0 to Length(ArrayFilesInRestout)-1 do
      begin
        FRESTRequest.Params.AddItem(ArrayFilesInRestout[i].FileName, ArrayFilesInRestout[i].FileMes, TRESTRequestParameterKind.pkREQUESTBODY,
        [TRESTRequestParameterOption.poDoNotEncode],
        TRESTContentType.ctAPPLICATION_OCTET_STREAM);
      end;
    end
    else
    begin
      FRESTRequest.AddBody(RequestObject.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
    end;

    FRESTRequest.Execute();

    Result := (FRESTResponse.StatusCode = 200) or (FRESTResponse.StatusCode = 201);

    if (Result) then
      AMessage := FRESTResponse.JSONValue.ToJSON
    else
      AMessage := FRESTResponse.Content;

    ContentOur:=FRESTResponse.Content;
    AMessage := Format('[%d] %s', [FRESTResponse.StatusCode, AMessage]);

//   if Assigned(RequestObject) and not AMessage.IsEmpty() then
//     FLog.SaveFile(Self.ClassName, RequestObject.ToJSON, AMessage);

    if (Result) then
     begin
       ResponceObject := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
//      ResponceObject := TJSONObject.ParseJSONValue(BytesOf(FRESTResponse.Content), 0, True) as TJSONObject;
//      ResponceObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(FRESTResponse.Content), 0, True) as TJSONObject;
//      JSON:=TJSONObject.Create;
//      ResponceObject := JSON.ParseJSONValue(TEncoding.UTF8.GetBytes(FRESTResponse.Content),0, True) as TJSONObject;
//      str := ((FRESTResponse.JSONValue) as TJSONObject).GetValue('uin').Value;
      if ResponceObject.GetValue('uin') = nil then
        ResponceObject := FRESTResponse.JSONValue as TJSONObject;
     end;

    if (FRESTResponse.StatusCode = 400)
    and (Pos('уже была создана, используйте метод update для обновления данных',FRESTResponse.Content)<>0) then
    begin
      Result:=true;
      ResponceObject:= TJSONObject.ParseJSONValue(BytesOf('{'+
      '    "guid":"'+getUINError(FRESTResponse.Content)+'",'+
      '    "uin":"'+getUINError(FRESTResponse.Content)+'"'+
      '}'+
      ''), 0) as TJSONObject;
    end;
  except
    on E: Exception do
    begin
      Log(E.Message+' '+ FRESTResponse.Content);
      FLog.SaveFile(Self.ClassName, RequestObject.ToJSON, E.Message +' '+ FRESTResponse.Content);
    end;
  end;
end;

procedure TRester.Log(AMessage: String);
begin
  if Assigned(FLog) then
    FLog.AppendRecord(Self.ClassName, 0, 0, AMessage);
end;

end.
