unit SendVac;


interface

uses
  BaseConnectClass,
  RosVacCOVID, JWTGenerator, System.JSON, System.Classes, System.SysUtils, System.IniFiles,
  upAnyDataSet,Vcl.Dialogs
  ;

type
 TSendVac = class(TBaseConnectClass)
 private
   FdsAllVacs: TupAnyDataSet;
   FdsEditVacs: TupAnyDataSet;
   FdsDocSend: TupAnyDataSet;
   FJwtGenerator: TJWTGenerator;
   FdsFirstEtap: TupAnyDataSet;
   procedure WriteDocSended(Id, SendCode, RegID, PersonID, AMessage: String);
 protected
    procedure CreateComponents(); override;
    procedure DestroyComponents(); override;
 public
 procedure sendone();
 procedure updateone();

end;
implementation

uses
 System.Variants,
 ServiceConstants;

{ TSendVac }

procedure TSendVac.CreateComponents;
begin
  inherited;
  FdsAllVacs := CreateDataSet(FSQLModule.FindScript('fdscrpt1', 'AllVacs'));
  FdsEditVacs := CreateDataSet(FSQLModule.FindScript('fdscrpt1', 'EditVacs'));
  FdsDocSend := CreateDataSet(FSQLModule.FindScript('fdscrpt1', 'SendDoc'), 'MIS_KSAMU.dbo.REG_EXTERNAL_REGISTR_VAC');
  FdsFirstEtap := CreateDataSet(FSQLModule.FindScript('fdscrpt1', 'GetFirstEtap'));
//   FRester := TRester.Create(FLog);
end;

procedure TSendVac.DestroyComponents;
begin
//  FreeAndNil(FRester);
  FreeAndNil(FdsAllVacs);
  FreeAndNil(FdsEditVacs);
  FreeAndNil(FdsDocSend);
  FreeAndNil(FdsFirstEtap);
  inherited;
end;

procedure TSendVac.sendone;
var
  vacunit: TRosVacCOVID;
  cToken: string;
  postOne: TPostRecordIn;
  postOut: TPostRecordOut;
  Strings: TStringList;
  OpenedKey: String;
  ClosedKey: String;
  Options: TIniFile;
//  tstr: string;
  n:Integer;
  Dopusk:integer;


begin
  Options := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini');
  PathCovidService:= Options.ReadString('OptionConnect', 'PathCovidService', 'https://ips.rosminzdrav.ru/8e05a39d5d5c9');
  SerNumberCovid:=Options.ReadString('OptionConnect', 'SerNumberCovid', '10');
  IdentIS:=Options.ReadString('OptionConnect', 'IdentIS', 'be7323a6-2635-416f-b6b3-97dd9a9dda4c');
  PathToKey1:=Options.ReadString('OptionConnect', 'PathToKey1', 'Keys/Key1.cer');
  PathToKey2:=Options.ReadString('OptionConnect', 'PathToKey2', 'Keys/Key2.cer');
  FreeAndNil(Options);

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

   vacunit := TRosVacCOVID.Create(Flog);
   vacunit.UrlPath := PathCovidService;
   vacunit.ips := IdentIS;
   vacunit.sertopen := PathToKey1;
   vacunit.sertclose := PathToKey2;
   try
   vacunit.Authorization := FJwtGenerator.CreateToken();
   finally
     FreeAndNil(FJwtGenerator);
   end;

   FdsAllVacs.CloseOpen();
   FdsAllVacs.First();
  while not FdsAllVacs.Eof do
  begin
     postOne := TPostRecordIn.Create();
//   tstr:= '';
//    for I := 0 to FdsAllVacs.FieldCount-1 do
//    begin
//     tstr := tstr + FdsAllVacs.Fields[I].FieldName +' | '+ FdsAllVacs.Fields[I].AsString + sLineBreak;

     postOne.reg := TReg.Create();
//
   try


   postOne.reg.vaccine := FdsAllVacs.FBN('VACCINE').AsString;
   n:=-1;
   //проверка на этап вакцинации
   if FdsAllVacs.FBN('NUMBER_ETAP').AsInteger = 2 then
   begin
       //ищем и заполняем данные из первого этапа
       Dopusk := FdsFirstEtap.FBN('ADMISSION').AsInteger;
       FdsFirstEtap.PBN('ID').AsString := FdsAllVacs.FBN('PERSON').AsString;
       FdsFirstEtap.CloseOpen();

       if FdsFirstEtap.RecordCount = 0 then
        raise Exception.Create('Не найдены данные по первому этапу вакцинации! ');
       inc(n);
       SetLength(postOne.reg.sub_stages,2);
       postOne.reg.sub_stages[n] := Tsub_stages.Create();
       postOne.reg.sub_stages[n].stage_number := FdsFirstEtap.FBN('NUMBER_ETAP').AsString;
       postOne.reg.sub_stages[n].gtin := FdsFirstEtap.FBN('GTIN').AsString;
       postOne.reg.sub_stages[n].serial_number := FdsFirstEtap.FBN('ISN').AsString;
       postOne.reg.sub_stages[n].batch_series := FdsFirstEtap.FBN('SERIA_VAC').AsString;
       //реакция на вакцину
       if Dopusk = 1 then
         postOne.reg.sub_stages[n].has_reaction := '0';
       SetLength(postOne.reg.sub_stages[n].sub_exams, 1);
       postOne.reg.sub_stages[n].sub_exams[0] := Tsub_exams.Create();
       postOne.reg.sub_stages[n].sub_exams[0].mo := FdsFirstEtap.FBN('MO_OID').AsString;
    //   postOne.reg.sub_stages[n].sub_exams[0].department := '';
       postOne.reg.sub_stages[n].sub_exams[0].exam_date := FdsFirstEtap.FBN('DATEPOST').AsString;
       postOne.reg.sub_stages[n].sub_exams[0].medical_worker := FdsFirstEtap.FBN('FIO_MEDPERSONAL').AsString;
       postOne.reg.sub_stages[n].sub_exams[0].medical_worker_snils := FdsFirstEtap.FBN('SNILS_MEDPERSONAL').AsString;
       postOne.reg.sub_stages[n].sub_exams[0].general_state := FdsFirstEtap.FBN('PATIENT_SOST').AsString;
       postOne.reg.sub_stages[n].sub_exams[0].temperature := FdsFirstEtap.FBN('TEMPPAT').AsString;
       if FdsFirstEtap.FBN('respiratory_rate').AsInteger > 0 then
         postOne.reg.sub_stages[n].sub_exams[0].respiratory_rate := FdsFirstEtap.FBN('respiratory_rate').AsString;
       if FdsFirstEtap.FBN('heart_rate').AsInteger > 0 then
         postOne.reg.sub_stages[n].sub_exams[0].heart_rate := FdsFirstEtap.FBN('heart_rate').AsString;
       postOne.reg.sub_stages[n].sub_exams[0].script_vaccination := Dopusk.ToString;
       postOne.reg.sub_stages[n].sub_exams[0].admission := Dopusk.ToString;
       if FdsFirstEtap.FBN('GENDER').AsInteger = 2 then
        postOne.reg.sub_stages[n].sub_exams[0].female := True;
   end
   else
      SetLength(postOne.reg.sub_stages,1);

   inc(n);
//   postOne.reg.risk_group := '4';
   postOne.reg.sub_stages[n] := Tsub_stages.Create();
   postOne.reg.sub_stages[n].stage_number := FdsAllVacs.FBN('NUMBER_ETAP').AsString;
   postOne.reg.sub_stages[n].gtin := FdsAllVacs.FBN('GTIN').AsString;
   postOne.reg.sub_stages[n].serial_number := FdsAllVacs.FBN('ISN').AsString;
   postOne.reg.sub_stages[n].batch_series := FdsAllVacs.FBN('SERIA_VAC').AsString;
   //реакция на вакцину
   Dopusk := FdsAllVacs.FBN('ADMISSION').AsInteger;
   if Dopusk = 1 then
     postOne.reg.sub_stages[n].has_reaction := '0';
   SetLength(postOne.reg.sub_stages[n].sub_exams, 1);
   postOne.reg.sub_stages[n].sub_exams[0] := Tsub_exams.Create();
   if FdsAllVacs.FBN('GENDER').AsInteger = 2 then
     postOne.reg.sub_stages[n].sub_exams[0].female := True;
   postOne.reg.sub_stages[n].sub_exams[0].mo := FdsAllVacs.FBN('MO_OID').AsString;
//   postOne.reg.sub_stages[n].sub_exams[0].department := '';
   postOne.reg.sub_stages[n].sub_exams[0].exam_date := FdsAllVacs.FBN('DATEPOST').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].medical_worker := FdsAllVacs.FBN('FIO_MEDPERSONAL').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].medical_worker_snils := FdsAllVacs.FBN('SNILS_MEDPERSONAL').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].general_state := FdsAllVacs.FBN('PATIENT_SOST').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].temperature := FdsAllVacs.FBN('TEMPPAT').AsString;
   if FdsAllVacs.FBN('respiratory_rate').AsInteger > 0 then
     postOne.reg.sub_stages[n].sub_exams[0].respiratory_rate := FdsAllVacs.FBN('respiratory_rate').AsString;
   if FdsAllVacs.FBN('heart_rate').AsInteger > 0 then
     postOne.reg.sub_stages[n].sub_exams[0].heart_rate := FdsAllVacs.FBN('heart_rate').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].script_vaccination := Dopusk.ToString;
   postOne.reg.sub_stages[n].sub_exams[0].admission := Dopusk.ToString;
   postOne.reg.sub_stages[n].sub_exams[0].contraindication := FdsAllVacs.FBN('contraindication').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].exacerbation := FdsAllVacs.FBN('exacerbation').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].decompensation := FdsAllVacs.FBN('decompensation').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].complication := FdsAllVacs.FBN('complication').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].contraindication_mkb := FdsAllVacs.FBN('contraindication_mkb').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].exacerbation := FdsAllVacs.FBN('decompensation').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].admission_start_date := FdsAllVacs.FBN('MEDOTVOD_START').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].admission_end_date := FdsAllVacs.FBN('MEDOTVOD_END').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].medical_commission_date := FdsAllVacs.FBN('medical_commission_date').AsString;
   postOne.reg.sub_stages[n].sub_exams[0].medical_commission_number := FdsAllVacs.FBN('medical_commission_number').AsString;


   postOne.person := Tperson.Create();
   postOne.person.snils := FdsAllVacs.FBN('SNILS').AsString;
   postOne.person.lastname := FdsAllVacs.FBN('FAM').AsString;
   postOne.person.firstname := FdsAllVacs.FBN('IM').AsString;
   postOne.person.patronymic := FdsAllVacs.FBN('OT').AsString;
   postOne.person.gender := FdsAllVacs.FBN('GENDER').AsString;
   postOne.person.birth_date := FdsAllVacs.FBN('BIRTHDAY').AsString;
   postOne.person.citizenship_country := FdsAllVacs.FBN('citizenship_country').AsString;
   postOne.person.citizenship := FdsAllVacs.FBN('citizenship').AsString;

   postOut := TPostRecordOut.Create();
   postOut := vacunit.PostRecord(postOne);
   WriteDocSended(FdsAllVacs.FBN('ID').AsString, postOut.codeError, postOut.reg_id, postOut.person_id, postOut.Content);
//   MainForm.Memo1.Lines.Add( + sLineBreak + postOut.Content + sLineBreak + );
//   ShowMessage(postOut.codeError + sLineBreak + postOut.Content + sLineBreak + postOut.reg_id + sLineBreak + postOut.person_id);
//        if FdsAllVacs.FBN('UIN').AsString.IsEmpty() then
//            WriteSendedDoc(FdsAllVacs.FBN('ID').AsString,'Документ успешно выгружен')   //
   finally
     FreeAndNil(postOne);
     FreeAndNil(postOut);
   end;
//    end;
    FdsAllVacs.Next();
  end;

 FreeAndNil(vacunit);

end;


procedure TSendVac.updateone;
var
  vacunit: TRosVacCOVID;
  cToken: string;
  putOne: TPutRegIn;
  putOut: TPutRegOut;

  Strings: TStringList;
  OpenedKey: String;
  ClosedKey: String;
  Options: TIniFile;
//  tstr: string;
  I:Integer;

begin
  Options := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini');
  PathCovidService:= Options.ReadString('OptionConnect', 'PathCovidService', 'https://ips.rosminzdrav.ru/8e05a39d5d5c9');
  SerNumberCovid:=Options.ReadString('OptionConnect', 'SerNumberCovid', '10');
  IdentIS:=Options.ReadString('OptionConnect', 'IdentIS', 'be7323a6-2635-416f-b6b3-97dd9a9dda4c');
  PathToKey1:=Options.ReadString('OptionConnect', 'PathToKey1', 'Keys/Key1.cer');
  PathToKey2:=Options.ReadString('OptionConnect', 'PathToKey2', 'Keys/Key2.cer');
  FreeAndNil(Options);

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

   vacunit := TRosVacCOVID.Create(Flog);
   vacunit.UrlPath := PathCovidService;
   vacunit.ips := IdentIS;
   vacunit.sertopen := PathToKey1;
   vacunit.sertclose := PathToKey2;
   try
   vacunit.Authorization := FJwtGenerator.CreateToken();
   finally
     FreeAndNil(FJwtGenerator);
   end;

   FdsEditVacs.CloseOpen();
   FdsEditVacs.First();
  while not FdsEditVacs.Eof do
  begin
     putOne := TPutRegIn.Create();
   try
   putOne.vaccine := FdsEditVacs.FBN('VACCINE').AsString;
//   putOne.risk_group := '4';
   SetLength(putOne.sub_stages,1);
   putOne.sub_stages[0] := Tsub_stages.Create();
   putOne.sub_stages[0].stage_number := FdsEditVacs.FBN('NUMBER_ETAP').AsString;
   putOne.sub_stages[0].gtin := FdsEditVacs.FBN('GTIN').AsString;
   putOne.sub_stages[0].serial_number := FdsEditVacs.FBN('ISN').AsString;
   putOne.sub_stages[0].batch_series := FdsEditVacs.FBN('SERIA_VAC').AsString;
   putOne.sub_stages[0].has_reaction := '0';
   SetLength(putOne.sub_stages[0].sub_exams, 1);
   putOne.sub_stages[0].sub_exams[0] := Tsub_exams.Create();
   putOne.sub_stages[0].sub_exams[0].mo := FdsEditVacs.FBN('MO_OID').AsString;
//   putOne.sub_stages[0].sub_exams[0].department := '';
   putOne.sub_stages[0].sub_exams[0].exam_date := FdsEditVacs.FBN('DATEPOST').AsString;
   putOne.sub_stages[0].sub_exams[0].medical_worker := FdsEditVacs.FBN('FIO_MEDPERSONAL').AsString;
   putOne.sub_stages[0].sub_exams[0].medical_worker_snils := FdsEditVacs.FBN('SNILS_MEDPERSONAL').AsString;
   putOne.sub_stages[0].sub_exams[0].general_state := FdsEditVacs.FBN('PATIENT_SOST').AsString;
   putOne.sub_stages[0].sub_exams[0].temperature := FdsEditVacs.FBN('TEMPPAT').AsString;
   putOne.sub_stages[0].sub_exams[0].script_vaccination := FdsEditVacs.FBN('ADMISSION').AsString;
   putOne.sub_stages[0].sub_exams[0].admission := FdsEditVacs.FBN('ADMISSION').AsString;
   if FdsEditVacs.FBN('GENDER').AsInteger = 2 then
     putOne.sub_stages[0].sub_exams[0].female := True;
   putOut := TPutRegOut.Create();
   putOut := vacunit.PutReg(FdsEditVacs.FBN('REGID').AsString, putOne);
   WriteDocSended(FdsEditVacs.FBN('ID').AsString, putOut.codeError, FdsEditVacs.FBN('REGID').AsString, '', putOut.Content);

   finally
     FreeAndNil(putOne);
     FreeAndNil(putOut);
   end;
//    end;
    FdsEditVacs.Next();
  end;

 FreeAndNil(vacunit);

end;



procedure TSendVac.WriteDocSended(Id, SendCode, RegID, PersonID,
  AMessage: String);
var
  strtofind: string;
begin
   try
    FdsDocSend.PBN('ID').AsString := Id;
    FdsDocSend.CloseOpen();
//    if (FdsDocSend.RecordCount = 0) then
//    begin
//      FdsDocSend.Append();
//      FdsDocSend.FBN('OWNER').AsString := Id;
//    end
//    else
//      FdsDocSend.Edit();

    //всегда добавлять запись
    FdsDocSend.Append();
    FdsDocSend.FBN('ID').AsString := GenKey_UIN('MIS_KSAMU.dbo.REG_EXTERNAL_REGISTR_VAC');
    FdsDocSend.FBN('OWNER').AsString := Id;

    FdsDocSend.FBN('DATE_SEND').AsDateTime := Now();

    strtofind := 'Запись регистра с такой вакциной (УНРЗ:';

    if (SendCode<>'200') and (Pos(strtofind, AMessage) > 0) then
    begin
      FdsDocSend.FBN('STATUS').AsInteger := 6;
      FdsDocSend.FBN('REGID').AsString := Copy(AMessage, Length(strtofind)+1, Pos(')', AMessage)-Length(strtofind)-1);
    end
    else
    begin
       FdsDocSend.FBN('STATUS').AsInteger := StrToInt(SendCode);
      if not RegID.IsEmpty() and (FdsDocSend.FBN('REGID').AsString <> RegID) then
        FdsDocSend.FBN('REGID').AsString := RegID;
    end;

    if not PersonID.IsEmpty() and (FdsDocSend.FBN('PERSONID').AsString <> PersonID) then
      FdsDocSend.FBN('PERSONID').AsString := PersonID;
    if AMessage.IsEmpty() then
      FdsDocSend.FBN('MESSAGE').Value := Null
    else
      FdsDocSend.FBN('MESSAGE').AsString := AMessage;
    FdsDocSend.Post();
    FdsDocSend.UpdateTransaction.Commit();
    FdsDocSend.Close();
  except
    on E: Exception do
    begin
      if FdsDocSend.UpdateTransaction.Active then
        FdsDocSend.UpdateTransaction.Rollback();
      Log('Ошибка обновления внешней информации: ' + E.Message);
    end;
  end;
end;

end.
