unit SendClass;

interface

uses
  System.JSON, LogInterfaces, BaseConnectClass, upAnyDataSet, RESTer, Data.DB;

type
  TSendClass = class(TBaseConnectClass)
  private
    FdsAllDocs: TupAnyDataSet;
    FdsPersonInfo: TupAnyDataSet;
    FdsDUL: TupAnyDataSet;
    FdsAddress: TupAnyDataSet;
    FdsInsurance: TupAnyDataSet;
    FdsRegInfo: TupAnyDataSet;
    FdsPatology: TupAnyDataSet;
    FdsExams: TupAnyDataSet;
    FdsDaily: TupAnyDataSet;
    FdsArrival: TupAnyDataSet;
    FdsEpidContact: TupAnyDataSet;
    FdsFinalClinicalDs: TupAnyDataSet;
    FdsPathologicalDs: TupAnyDataSet;
    FdsDeathCertificate: TupAnyDataSet;
    FdsDsPsmpreFile: TupAnyDataSet;
    FdsDsPsmfinFile: TupAnyDataSet;
    FdsDeathCertificateFile: TupAnyDataSet;

    FdsExtInfo: TupAnyDataSet;
    FdsSendedDoc: TupAnyDataSet;
    FdsUpdateAllDocs: TupAnyDataSet;

    FRester: TRester;

    ArrayFilesInRest: TArrayFilesInRest;
  private
    procedure WriteSendedDoc(Id, Status: String);
    procedure WriteDocExternalInfo(Id, Uin, AMessage: String);
    procedure WriteUnloadDoc(Id: String);

    function FormatDateToStr(ADate: TDate): String;
    function CheckSnils(SNILS: String): Boolean;
    function DeleteNotNumbers(S: String): String;
    function RemoveSpaces(S: String): String;

//    procedure SaveToFile(JSON: TJSONObject);
  private
    function GUIDPreapare(GUID: String): string;
    function CorrectCodeSMO(CodeSMO: String): String;
    function PrepareFile(): TJSONObject;
    procedure AddPerson(Root: TJSONObject);
    procedure AddDocuments(Root: TJSONObject);
    procedure AddAddresses(Root: TJSONObject; NodeName, PatientId, MOId: String);
    procedure AddAddressesEpic(Root: TJSONObject; NodeName, PatientId, MOId: String);
    procedure AddContacts(Root: TJSONObject);
    procedure AddInsurances(Root: TJSONObject);
    procedure AddRegMain(Root: TJSONObject);
    procedure AddPathology(Root: TJSONObject);
    procedure AddArrayIfNeed(Root: TJSONObject; NodeName, TypeZap: String);
    procedure AddExam(Root: TJSONObject);
    procedure AddDaily(Root: TJSONObject);
    procedure AddArrival(Root: TJSONObject);
    procedure AddEpidContact(Root: TJSONObject);
    procedure AddFinalClinicalDs(Root: TJSONObject);
    procedure AddPathologicalDs(Root: TJSONObject);
    procedure AddDeathCertificate(Root: TJSONObject);
    function PhoneNumPrepare(Phone: string): string;
  protected
    procedure CreateComponents(); override;
    procedure DestroyComponents(); override;
  public
    procedure Send();
  end;

implementation

uses
  System.Classes, System.SysUtils, System.DateUtils, System.RegularExpressions, FireDAC.Stan.Param,
  System.StrUtils, System.Math, System.Variants;

{ TSendClass }

procedure TSendClass.Send();
var
  AFile: TJSONObject;
  RestResponse: TJSONObject;
  Resource, ContentOur: String;
  LogTemp: TStringList;
begin
  FdsAllDocs.CloseOpen();
  FdsAllDocs.First();
  while not FdsAllDocs.Eof do
  begin
    try
      AFile := PrepareFile();
       //Запись файла
//  LogTemp := TStringList.Create;
//  LogTemp.Text := AFile.ToJSON;
//  gTemp.Text := RESTResponse.Content;
//  gTemp.Text := Bundle.ToString;
// gTemp.Text := RESTResponse.JSONValue.ToString;
//  LogTemp.SaveToFile('D:\CovidPost_'+FormatDateTime('hhnnsszzz', Now())+'.json');
//  FreeAndNil(LogTemp);

      try
        if FdsAllDocs.FBN('UIN').AsString.IsEmpty() then
          Resource := '/record/create'
        else
          Resource := '/record/update?uin=' + GUIDPreapare(FdsAllDocs.FBN('UIN').AsString);

        if FRester.Post(Resource, AFile, ArrayFilesInRest, RestResponse, ContentOur) then
        begin
          if Assigned(RestResponse) then
            WriteSendedDoc(FdsAllDocs.FBN('ID').AsString,'Документ успешно выгружен')
          else
            WriteSendedDoc(FdsAllDocs.FBN('ID').AsString,'Ошибка данных: '+ContentOur);

          WriteUnloadDoc(FdsAllDocs.FBN('ID').AsString);

          try
            if RestResponse.GetValue('uin') <> Nil then
                WriteDocExternalInfo(FdsAllDocs.FBN('ID').AsString, RestResponse.GetValue('uin').Value, '');
          finally
            FreeAndNil(RestResponse);
          end;
        end
        else
        begin
          WriteDocExternalInfo(FdsAllDocs.FBN('ID').AsString, '', 'Не удалось выгрузить документ');
          WriteSendedDoc(FdsAllDocs.FBN('ID').AsString,'Ошибка выгрузки: '+ContentOur);
          WriteUnloadDoc(FdsAllDocs.FBN('ID').AsString);
        end;
      finally
        FreeAndNil(AFile);
      end;
    except
      on E: Exception do
      begin
        Log(E.Message + ' ' +FdsAllDocs.FBN('ID').AsString);
//        WriteSendedDoc(FdsAllDocs.FBN('ID').AsString);
        WriteDocExternalInfo(FdsAllDocs.FBN('ID').AsString, '', E.Message);
        WriteSendedDoc(FdsAllDocs.FBN('ID').AsString,'Ошибка формирования: '+E.Message);
        WriteUnloadDoc(FdsAllDocs.FBN('ID').AsString);
      end;
    end;

    FdsAllDocs.Next();
  end;
end;


function TSendClass.PrepareFile(): TJSONObject;
var
  Root : TJSONObject;
  i: Integer;
begin
  try
    for i:=0 to Length(ArrayFilesInRest)-1 do
    begin
      ArrayFilesInRest[i].FileMes.Free;
      ArrayFilesInRest[i].Free;
    end;
    SetLength(ArrayFilesInRest,0);

    Result := TJSONObject.Create();
    Root := TJSONObject.Create();
    Result.AddPair('record', Root);

    AddPerson(Root); // required
    AddDocuments(Root);
    AddContacts(Root);
    AddAddresses(Root, 'person_addr', FdsAllDocs.FBN('PATIENT').AsString, FdsAllDocs.FBN('MO').AsString);
    AddInsurances(Root);

    AddRegMain(Root); // required
    AddPathology(Root); // required
    AddExam(Root);
    AddDaily(Root);
    AddArrival(Root);
    AddEpidContact(Root);
    AddFinalClinicalDs(Root);
    AddPathologicalDs(Root);
    AddDeathCertificate(Root);
  except
    if Assigned(Result) then
      FreeAndNil(Result);
    raise;
  end;
end;

// Персональные данные пациента
procedure TSendClass.AddPerson(Root: TJSONObject);
var
  Main: TJSONObject;
  snils: String;
  Builder: TStringBuilder;
begin
  // required: local_id, lastname, firstname, gender, birth_date, citizenship_country
  FdsPersonInfo.PBN('ID').AsString := FdsAllDocs.FBN('ID').AsString;
  FdsPersonInfo.CloseOpen();
   Builder := TStringBuilder.Create();
    try
      if (FdsPersonInfo.RecordCount = 0) then
        Builder.Append('Не заполнена персональная информация о пациенте' + sLineBreak);
      if (FdsPersonInfo.FBN('lastname').AsString.IsEmpty()) then
        Builder.Append('Не заполнена фамилия' + sLineBreak);
      if (FdsPersonInfo.FBN('firstname').AsString.IsEmpty()) then
        Builder.Append('Не заполнено имя' + sLineBreak);
      if (FdsPersonInfo.FBN('birth_date').isNull) then
        Builder.Append('Не заполнена дата рождения' + sLineBreak);
      if (FdsPersonInfo.FBN('citizenship_country').AsString = '') then
        Builder.Append('Не заполнено гражданство');

      if (Builder.Length > 0) then
      begin
//        Log('AddPerson','Не заполнена персональная информация о пациенте:' + sLineBreak + Builder.ToString());
        raise Exception.Create('Не заполнена персональная информация о пациенте:' + sLineBreak + Builder.ToString());
      end;
    finally
      FreeAndNil(Builder);
    end;

  Main := TJSONObject.Create();
  Main.AddPair(TJSONPair.Create('local_id', GUIDPreapare(FdsPersonInfo.FBN('local_id').AsString)));
  snils := DeleteNotNumbers(FdsPersonInfo.FBN('snils').AsString);
  if (CheckSnils(snils)) then
    Main.AddPair(TJSONPair.Create('snils', snils));
  Main.AddPair(TJSONPair.Create('lastname', RemoveSpaces(FdsPersonInfo.FBN('lastname').AsString)));
  Main.AddPair(TJSONPair.Create('firstname', RemoveSpaces(FdsPersonInfo.FBN('firstname').AsString)));
  if RemoveSpaces(FdsPersonInfo.FBN('patronymic').AsString)<>'' then
    Main.AddPair(TJSONPair.Create('patronymic', RemoveSpaces(FdsPersonInfo.FBN('patronymic').AsString)));
  Main.AddPair('gender', TJSONNumber.Create(FdsPersonInfo.FBN('gender').AsInteger));
  Main.AddPair('birth_date', FormatDateToStr(FdsPersonInfo.FBN('birth_date').AsDateTime));
  Main.AddPair('citizenship_country', TJSONNumber.Create(FdsPersonInfo.FBN('citizenship_country').AsInteger));
//  Main.AddPair('citizenship', TJSONNumber.Create(FdsPersonInfo.FBN('citizenship').AsInteger));
  Root.AddPair('person', Main);
end;

// Блок информации о документах пациента
procedure TSendClass.AddDocuments(Root: TJSONObject);
var
  DocumentsArray: TJSONArray;
  Document: TJSONObject;
begin
  FdsDUL.PBN('PATIENT').AsString := FdsAllDocs.FBN('PATIENT').AsString;
  FdsDUL.PBN('MO').AsString := FdsAllDocs.FBN('MO').AsString;
  FdsDUL.CloseOpen();
  if (FdsDUL.RecordCount = 0) then
    Exit;

  DocumentsArray := nil;
  FdsDUL.First();
  while (not FdsDUL.Eof) do
  begin
    // required: local_id, persdoc_type, pd_number, date_begin
    if FdsDUL.FBN('local_id').AsString.IsEmpty()
      or (FdsDUL.FBN('persdoc_type').AsInteger = 0)
      or FdsDUL.FBN('pd_number').AsString.IsEmpty()
      or (FdsDUL.FBN('date_begin').isNull) then
    begin
      FdsDUL.Next();
      Continue;
    end;

    if not Assigned(DocumentsArray) then
      DocumentsArray := TJSONArray.Create();

    Document := TJSONObject.Create();
    Document.AddPair(TJSONPair.Create('local_id', GUIDPreapare(FdsDUL.FBN('local_id').AsString)));
    Document.AddPair('persdoc_type', TJSONNumber.Create(FdsDUL.FBN('persdoc_type').AsInteger)); // TODO: Сопоставить справочник 1.2.643.5.1.13.13.99.2.48
    if RemoveSpaces(FdsDUL.FBN('pd_series').AsString) <> '' then
      Document.AddPair(TJSONPair.Create('pd_series', RemoveSpaces(FdsDUL.FBN('pd_series').AsString)));
    Document.AddPair(TJSONPair.Create('pd_number', RemoveSpaces(FdsDUL.FBN('pd_number').AsString)));
    Document.AddPair(TJSONPair.Create('date_begin', FormatDateToStr(FdsDUL.FBN('date_begin').AsDateTime)));
    if RemoveSpaces(FdsDUL.FBN('issued_by').AsString) = '' then
      Document.AddPair(TJSONPair.Create('issued_by', TJSONNull.Create))
    else
      Document.AddPair(TJSONPair.Create('issued_by', RemoveSpaces(FdsDUL.FBN('issued_by').AsString)));
    DocumentsArray.AddElement(Document);

    FdsDUL.Next();
  end;
  if Assigned(DocumentsArray) then
    Root.AddPair('person_persdocs', DocumentsArray);
end;

// Блок с контактными данными пациента
procedure TSendClass.AddContacts(Root: TJSONObject);
var
  ContactsArray: TJSONArray;
  Contact: TJSONObject;
  PhoneNumber: String;
begin
  PhoneNumber := PhoneNumPrepare(FdsPersonInfo.FBN('phone').AsString);
  if (not TRegEx.IsMatch(PhoneNumber, '^(\+\d{11})$')) then
    Exit;

  ContactsArray := TJSONArray.Create();
  // required: contact_type, contact
  Contact := TJSONObject.Create();
  Contact.AddPair('contact_type', 'mobile'); // mobile, phone
  Contact.AddPair('contact', PhoneNumber);
  ContactsArray.AddElement(Contact);
  Root.AddPair('person_contacts', ContactsArray);
end;

// Блок с адресами пациента
procedure TSendClass.AddAddresses(Root: TJSONObject; NodeName, PatientId, MOId: String);
var
  AddressesArray: TJSONArray;
  AddressNode: TJSONObject;
  Address: TJSONObject;
begin
 // required: addr_type, address, region
  FdsAddress.PBN('PATIENT').AsString := PatientId;
  FdsAddress.PBN('MO').AsString := MOId;
  FdsAddress.CloseOpen();
  if (FdsAddress.RecordCount = 0) then
    raise Exception.Create('Не найден Блок с адресами пациента !!!');

  AddressesArray := nil;
  FdsAddress.First();
  while (not FdsAddress.Eof) do
  begin
    // required: addr_type, address
    if FdsAddress.FBN('addr_type').AsString.IsEmpty()
      or FdsAddress.FBN('region').isnull then
    begin
      FdsAddress.Next();
      Continue;
    end;

    if not Assigned(AddressesArray) then
      AddressesArray := TJSONArray.Create();

    AddressNode := TJSONObject.Create();
    AddressNode.AddPair(TJSONPair.Create('addr_type', FdsAddress.FBN('addr_type').AsString)); // reg, live
    Address := TJSONObject.Create();
    Address.AddPair('region', TJSONNumber.Create(FdsAddress.FBN('region').AsInteger)); // required: 1.2.643.5.1.13.13.99.2.206
//    Address.AddPair(TJSONPair.Create('area_guid', '')); // ФИАС
//    Address.AddPair(TJSONPair.Create('street_guid', '')); // ФИАС
//    Address.AddPair(TJSONPair.Create('house_guid', '')); // ФИАС
   if not FdsAddress.FBN('area_name').AsString.IsEmpty() then
     Address.AddPair(TJSONPair.Create('area_name', FdsAddress.FBN('area_name').AsString)); // нас. пункт
   if not FdsAddress.FBN('street_name').AsString.IsEmpty() then
     Address.AddPair(TJSONPair.Create('street_name', FdsAddress.FBN('street_name').AsString));
   if not FdsAddress.FBN('house').AsString.IsEmpty() then
     Address.AddPair(TJSONPair.Create('house', FdsAddress.FBN('house').AsString));
   if not FdsAddress.FBN('flat').AsString.IsEmpty() then
    Address.AddPair(TJSONPair.Create('flat', FdsAddress.FBN('flat').AsString));
    AddressNode.AddPair(TJSONPair.Create('address', Address));
    AddressesArray.AddElement(AddressNode);

    FdsAddress.Next();
  end;

  if Assigned(AddressesArray) then
  begin
    if (AddressesArray.Count = 0) then
        raise Exception.Create('Ошибки заполнения Блока с адресами пациента !!!');
    Root.AddPair(NodeName, AddressesArray);
  end;
end;

// Блок информации о медицинском страховании пациента
procedure TSendClass.AddInsurances(Root: TJSONObject);
var
  InsuranceArray: TJSONArray;
  Insurance: TJSONObject;
begin
  FdsInsurance.PBN('ID').AsString := FdsAllDocs.FBN('ID').AsString;
  FdsInsurance.CloseOpen();
  // required: policy_type, policy_number, smo_cod
  if (FdsInsurance.RecordCount = 0)
    or (FdsInsurance.FBN('policy_number').AsString.IsEmpty())
    or (FdsInsurance.FBN('smo_cod').AsString.IsEmpty()) then
    Exit;

  InsuranceArray := TJSONArray.Create();
  Insurance := TJSONObject.Create();
  //1 Полис ОМС старого образца
  //2 Временное свидетельство
  //3 Полис ОМС единого образца
  if FdsInsurance.FBN('policy_type').IsNull then
    Insurance.AddPair('policy_type', TJSONNull.Create)
  else
    Insurance.AddPair('policy_type', TJSONNumber.Create(FdsInsurance.FBN('policy_type').AsInteger)); // 1.2.643.5.1.13.13.99.2.245
  if FdsInsurance.FBN('policy_series').IsNull then
    Insurance.AddPair('policy_series', TJSONNull.Create)
  else
    Insurance.AddPair(TJSONPair.Create('policy_series', FdsInsurance.FBN('policy_series').AsString));
  if Length(FdsInsurance.FBN('policy_number').AsString)>20 then
    Insurance.AddPair(TJSONPair.Create('policy_number', Copy(FdsInsurance.FBN('policy_number').AsString,1,20)))
  else
    Insurance.AddPair(TJSONPair.Create('policy_number', FdsInsurance.FBN('policy_number').AsString));
  Insurance.AddPair(TJSONPair.Create('smo_cod', CorrectCodeSMO(FdsInsurance.FBN('smo_cod').AsString)));
  InsuranceArray.AddElement(Insurance);
  Root.AddPair('person_insurance', InsuranceArray)
end;

// Блок основной регистрационной информции
procedure TSendClass.AddRegMain(Root: TJSONObject);
var
  RegInfo: TJSONObject;
  Builder: TStringBuilder;
begin
  FdsRegInfo.PBN('ID').AsString := FdsAllDocs.FBN('ID').AsString;
  FdsRegInfo.CloseOpen();

   Builder := TStringBuilder.Create();
    try
      // required: local_id, mo, include_date, ambulatory_treatment, diagnosis_main,
      //   disease_date, pregnancy, vaccination_information_flu, vaccination_information_air
      if (FdsRegInfo.RecordCount = 0) then
        Builder.Append('Не найден блок регистрационной информации' + sLineBreak);
      if FdsRegInfo.FBN('mo').AsString.IsEmpty() then
        Builder.Append('Не заполнен OID организации' + sLineBreak);
      if (FdsRegInfo.FBN('include_date').IsNull) then
        Builder.Append('Не заполнена дата включения в регистр' + sLineBreak);
      if FdsRegInfo.FBN('diagnosis_main').AsString.IsEmpty() then
        Builder.Append('Не заполнен основной диагноз' + sLineBreak);
      if (FdsRegInfo.FBN('approved_date').IsNull) then
        Builder.Append('Не заполнена дата постановки диагноза');
      if FdsRegInfo.FBN('is_vaccination_information_flu').IsNull then
        Builder.Append('Не заполнен Вакцинация против гриппа' + sLineBreak);
      if FdsRegInfo.FBN('is_vaccination_information_air').IsNull then
        Builder.Append('Не заполнена Вакцинация против пневмококковой инфекции' + sLineBreak);
      if FdsRegInfo.FBN('is_pregnancy').IsNull then
        Builder.Append('Не заполнен Беременность' + sLineBreak);

      if (Builder.Length > 0) then
        raise Exception.Create('Ошибки заполнения блока регистрационной информации:' + sLineBreak + Builder.ToString());
    finally
      FreeAndNil(Builder);
    end;

  RegInfo := TJSONObject.Create();
  RegInfo.AddPair(TJSONPair.Create('local_id', GUIDPreapare(FdsRegInfo.FBN('local_id').AsString)));
  RegInfo.AddPair(TJSONPair.Create('mo', FdsRegInfo.FBN('mo').AsString)); // 1.2.643.5.1.13.13.11.1461 (OID)
  RegInfo.AddPair('include_date', FormatDateToStr(FdsRegInfo.FBN('include_date').AsDateTime));
  if FdsRegInfo.FBN('stage_type').AsInteger = 1 then
    RegInfo.AddPair('ambulatory_treatment', TJSONBool.Create(True))
  else
    RegInfo.AddPair('ambulatory_treatment', TJSONBool.Create(False));
  RegInfo.AddPair(TJSONPair.Create('diagnosis_main', FdsRegInfo.FBN('diagnosis_main').AsString)); // 1.2.643.5.1.13.13.99.2.568 (МКБ)
  //Заполнять поля [Без осложнений] и [Код диагноза осложнения] для нозологии [Короновирус]
  //допустимо только при основном диагнозе U07.1 или U07.2"
  if (FdsRegInfo.FBN('diagnosis_main').AsString = 'U07.1') or (FdsRegInfo.FBN('diagnosis_main').AsString = 'U07.2') then
  begin
    RegInfo.AddPair('variant',TJSONNumber.Create('1'));
    RegInfo.AddPair('diagnosis_hasnt_complication', TJSONBool.Create(FdsRegInfo.FBN('is_diagnosis_hasnt_complication').AsBoolean));
    if (not FdsRegInfo.FBN('is_diagnosis_hasnt_complication').AsBoolean) and (not FdsRegInfo.FBN('diagnosis_complication').AsString.IsEmpty) then
      RegInfo.AddPair(TJSONPair.Create('diagnosis_complication', FdsRegInfo.FBN('diagnosis_complication').AsString)); // 1.2.643.5.1.13.13.99.2.568 (МКБ)
  end;
  RegInfo.AddPair('disease_date', FormatDateToStr(FdsRegInfo.FBN('approved_date').AsDateTime));
  If FdsRegInfo.FBN('symptom_date').IsNull = False then
    RegInfo.AddPair('symptom_date', FormatDateToStr(FdsRegInfo.FBN('symptom_date').AsDateTime));
  If FdsRegInfo.FBN('hospitalization_date').IsNull = False then
    RegInfo.AddPair('hospitalization_date', FormatDateToStr(FdsRegInfo.FBN('hospitalization_date').AsDateTime));
  if FdsRegInfo.FBN('gender').AsInteger=2 then
  begin
    RegInfo.AddPair('pregnancy', TJSONBool.Create(FdsRegInfo.FBN('is_pregnancy').AsBoolean));
    if FdsRegInfo.FBN('is_pregnancy').AsBoolean then
    begin
      RegInfo.AddPair('pregnancy_trimester', TJSONNumber.Create(FdsRegInfo.FBN('TRIMESTER').AsInteger));
    end;
  end else
  begin
    RegInfo.AddPair(TJSONPair.Create('pregnancy', TJSONNull.Create));
//  RegInfo.AddPair(TJSONPair.Create('pregnancy_trimester', TJSONNull.Create));
  end;
  RegInfo.AddPair('vaccination_information_flu', TJSONBool.Create(FdsRegInfo.FBN('is_vaccination_information_flu').AsBoolean));
  RegInfo.AddPair('vaccination_information_air', TJSONBool.Create(FdsRegInfo.FBN('is_vaccination_information_air').AsBoolean));

//  RegInfo.AddPair('approved_date', FormatDateToStr(FdsRegInfo.FBN('approved_date').AsDateTime));

  if FdsRegInfo.FBN('disease_outcome').AsString <> '' then  // 1.2.643.5.1.13.13.99.2.558
    RegInfo.AddPair('disease_outcome', TJSONNumber.Create(FdsRegInfo.FBN('disease_outcome').AsInteger))
  else
    RegInfo.AddPair(TJSONPair.Create('disease_outcome', TJSONNull.Create));
  if FdsRegInfo.FBN('disease_outcome_date').IsNull = False then
    RegInfo.AddPair('disease_outcome_date', FormatDateToStr(FdsRegInfo.FBN('disease_outcome_date').AsDateTime))
  else
    RegInfo.AddPair('disease_outcome_date', TJSONNull.Create);
  if FdsRegInfo.FBN('death_reason').AsString <> '' then
    RegInfo.AddPair(TJSONPair.Create('death_reason', FdsRegInfo.FBN('death_reason').AsString));
  Root.AddPair('reg', RegInfo);
end;


// Блок информации о сопутствующих заболеваниях
procedure TSendClass.AddPathologicalDs(Root: TJSONObject);
var
  Pathological_Ds : TJSONObject;
  preliminary_pathological_ds: TJSONObject;
  final_pathological_ds: TJSONObject;

  ArrayOfds_psmpre_complication: TJSONArray;
  ArrayOfds_psmpre_accompany: TJSONArray;
  ArrayOfds_psmfin_complication: TJSONArray;
  ArrayOfds_psmfin_accompany: TJSONArray;
  ArrayOfds_psmpre_file: TJSONArray;
  ArrayOfds_psmfin_file: TJSONArray;
begin
  FdsPathologicalDs.PBN('ID').AsString := FdsAllDocs.FBN('ID').AsString;
  FdsPathologicalDs.PBN('MO').AsString := FdsAllDocs.FBN('MO').AsString;
  FdsPathologicalDs.CloseOpen();
  if (FdsPathologicalDs.RecordCount = 0) or
  (FdsPathologicalDs.FBN('ds_psmpre_main').AsString.IsEmpty() and FdsPathologicalDs.FBN('ds_psmfin_main').AsString.IsEmpty()) then
    Exit;

  FdsDsPsmpreFile.PBN('OWNER').AsString := FdsAllDocs.FBN('ID_MO').AsString;
  FdsDsPsmpreFile.PBN('MO').AsString := FdsAllDocs.FBN('MO').AsString;
  FdsDsPsmpreFile.CloseOpen();

  Fdsdspsmfinfile.PBN('OWNER').AsString := FdsAllDocs.FBN('ID_MO').AsString;
  Fdsdspsmfinfile.PBN('MO').AsString := FdsAllDocs.FBN('MO').AsString;
  Fdsdspsmfinfile.CloseOpen();

  ArrayOfds_psmpre_complication := nil;
  ArrayOfds_psmpre_accompany := nil;
  ArrayOfds_psmfin_complication := nil;
  ArrayOfds_psmfin_accompany := nil;
  ArrayOfds_psmpre_file := nil;

  Pathological_Ds := TJSONObject.Create();
  Pathological_Ds.AddPair('psm_exam_refusing', TJSONBool.Create(FdsPathologicalDs.FBN('IS_psm_exam_refusing').AsBoolean));

  if (not FdsPathologicalDs.FBN('ds_psmpre_main').AsString.IsEmpty())
  and (FdsDsPsmpreFile.RecordCount>0)
  and (not FdsDsPsmpreFile.FBN('DOC_NAME').AsString.IsEmpty)then
  begin
    preliminary_pathological_ds := TJSONObject.Create();
    preliminary_pathological_ds.AddPair(TJSONPair.Create('ds_psmpre_main', FdsPathologicalDs.FBN('ds_psmpre_main').AsString));
    preliminary_pathological_ds.AddPair('ds_psmpre_hasnt_complication', TJSONBool.Create(FdsPathologicalDs.FBN('IS_ds_psmpre_hasnt_complication').AsBoolean));
    if not FdsPathologicalDs.FBN('ds_psmpre_complication').AsString.IsEmpty() then
    begin
      if not Assigned(ArrayOfds_psmpre_complication) then
        ArrayOfds_psmpre_complication := TJSONArray.Create();

      ArrayOfds_psmpre_complication.Add(FdsPathologicalDs.FBN('ds_psmpre_complication').AsString);

      preliminary_pathological_ds.AddPair('ds_psmpre_complication',ArrayOfds_psmpre_complication);
    end;
    preliminary_pathological_ds.AddPair('ds_psmpre_hasnt_accompany', TJSONBool.Create(FdsPathologicalDs.FBN('IS_ds_psmpre_hasnt_accompany').AsBoolean));
    if not FdsPathologicalDs.FBN('ds_psmpre_accompany').AsString.IsEmpty() then
    begin
      if not Assigned(ArrayOfds_psmpre_accompany) then
        ArrayOfds_psmpre_accompany := TJSONArray.Create();

      ArrayOfds_psmpre_accompany.Add(FdsPathologicalDs.FBN('ds_psmpre_accompany').AsString);

      preliminary_pathological_ds.AddPair('ds_psmpre_complication',ArrayOfds_psmpre_accompany);
    end;
    //Файлы
    if (FdsDsPsmpreFile.RecordCount>0) and (not FdsDsPsmpreFile.FBN('DOC_NAME').AsString.IsEmpty) then
    begin
      if not Assigned(ArrayOfds_psmpre_file) then
        ArrayOfds_psmpre_file := TJSONArray.Create();

      ArrayOfds_psmpre_file.Add(FdsDsPsmpreFile.FBN('DOC_NAME').AsString);

      SetLength(ArrayFilesInRest,Length(ArrayFilesInRest)+1);

      ArrayFilesInRest[Length(ArrayFilesInRest)-1]:=TFilesInRest.Create;
      ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileName:=FdsDsPsmpreFile.FBN('DOC_NAME').AsString;
      ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileMes:=TMemoryStream.Create;
      ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileMes.Seek(0, soFromBeginning);
      TBlobField(FdsDsPsmpreFile.FieldByName('DOC')).SaveToStream(ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileMes);

      preliminary_pathological_ds.AddPair('ds_psmpre_file',ArrayOfds_psmpre_file);
    end;
    //
    Pathological_Ds.AddPair('preliminary_pathological_ds',preliminary_pathological_ds);
  end;

  if (not FdsPathologicalDs.FBN('ds_psmfin_main').AsString.IsEmpty())
  and (Fdsdspsmfinfile.RecordCount>0)
  and (not Fdsdspsmfinfile.FBN('DOC_NAME').AsString.IsEmpty)then
  begin
    final_pathological_ds := TJSONObject.Create();
    final_pathological_ds.AddPair(TJSONPair.Create('ds_psmpre_main', FdsPathologicalDs.FBN('ds_psmpre_main').AsString));
    final_pathological_ds.AddPair('ds_psmfin_hasnt_complication', TJSONBool.Create(FdsPathologicalDs.FBN('IS_ds_psmfin_hasnt_complication').AsBoolean));
    if not FdsPathologicalDs.FBN('ds_psmfin_complication').AsString.IsEmpty() then
    begin
      if not Assigned(ArrayOfds_psmfin_complication) then
        ArrayOfds_psmfin_complication := TJSONArray.Create();

      ArrayOfds_psmfin_complication.Add(FdsPathologicalDs.FBN('ds_psmfin_complication').AsString);

      final_pathological_ds.AddPair('ds_psmfin_complication',ArrayOfds_psmfin_complication);
    end;
    final_pathological_ds.AddPair('ds_psmfin_hasnt_accompany', TJSONBool.Create(FdsPathologicalDs.FBN('IS_ds_psmfin_hasnt_accompany').AsBoolean));
    if not FdsPathologicalDs.FBN('ds_psmfin_accompany').AsString.IsEmpty() then
    begin
      if not Assigned(ArrayOfds_psmfin_accompany) then
        ArrayOfds_psmfin_accompany := TJSONArray.Create();

      ArrayOfds_psmfin_accompany.Add(FdsPathologicalDs.FBN('ds_psmfin_accompany').AsString);

      final_pathological_ds.AddPair('ds_psmfin_accompany',ArrayOfds_psmfin_accompany);
    end;

    //Файлы
    if (Fdsdspsmfinfile.RecordCount>0) and (not Fdsdspsmfinfile.FBN('DOC_NAME').AsString.IsEmpty) then
    begin
      if not Assigned(ArrayOfds_psmfin_file) then
        ArrayOfds_psmfin_file := TJSONArray.Create();

      ArrayOfds_psmfin_file.Add(Fdsdspsmfinfile.FBN('DOC_NAME').AsString);

      SetLength(ArrayFilesInRest,Length(ArrayFilesInRest)+1);

      ArrayFilesInRest[Length(ArrayFilesInRest)-1]:=TFilesInRest.Create;
      ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileName:=Fdsdspsmfinfile.FBN('DOC_NAME').AsString;
      ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileMes:=TMemoryStream.Create;
      ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileMes.Seek(0, soFromBeginning);
      TBlobField(Fdsdspsmfinfile.FieldByName('DOC')).SaveToStream(ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileMes);

      preliminary_pathological_ds.AddPair('ds_psmfin_file',ArrayOfds_psmfin_file);
    end;
    //

    Pathological_Ds.AddPair('final_pathological_ds',final_pathological_ds);
  end;

  Root.AddPair('pathological_ds', Pathological_Ds);
end;

procedure TSendClass.AddArrayIfNeed(Root: TJSONObject; NodeName, TypeZap: String);
  var
    JSONArray: TJSONArray;
  begin
    FdsPatology.Filter := 'TYPE_ZAB = ' + QuotedStr(TypeZap);
    FdsPatology.Filtered := True;

    Root.AddPair('has_' + NodeName, TJSONBool.Create(FdsPatology.FindFirst())); // required
    if (not FdsPatology.FindFirst()) then
      Exit;

    JSONArray := TJSONArray.Create();
    FdsPatology.First();
    while (not FdsPatology.Eof) do
    begin
      JSONArray.Add(FdsPatology.FBN('CODEST').AsString); // 1.2.643.5.1.13.13.11.1005 (код МКБ)
      FdsPatology.Next();
    end;
    Root.AddPair(TJSONPair.Create(NodeName, JSONArray));
  end;

// Блок информации о сопутствующих заболеваниях
procedure TSendClass.AddPathology(Root: TJSONObject);
var
  Pathology: TJSONObject;
begin
  FdsPatology.PBN('OWNER').AsString := FdsAllDocs.FBN('ID_MO').AsString;
  FdsPatology.PBN('MO').AsString := FdsAllDocs.FBN('MO').AsString;
  FdsPatology.CloseOpen();

  Pathology := TJSONObject.Create();
  AddArrayIfNeed(Pathology, 'pathology_bronch', '0');
  AddArrayIfNeed(Pathology, 'pathology_cardio', '1');
  AddArrayIfNeed(Pathology, 'pathology_endo', '2');
  AddArrayIfNeed(Pathology, 'pathology_onko', '3');
  AddArrayIfNeed(Pathology, 'pathology_hiv', '4');
  AddArrayIfNeed(Pathology, 'pathology_tuber', '5');
  AddArrayIfNeed(Pathology, 'pathology_other', '6');
  Root.AddPair('pathology', Pathology);
end;

// Блок информации о лабораторных исследованиях
procedure TSendClass.AddExam(Root: TJSONObject);
var
  ExamsArray: TJSONArray;
  Exam: TJSONObject;
begin
  FdsExams.PBN('OWNER').AsString := FdsAllDocs.FBN('ID_MO').AsString;
  FdsExams.PBN('MO').AsString := FdsAllDocs.FBN('MO').AsString;
  FdsExams.CloseOpen();
  if (FdsExams.RecordCount = 0) then
    Exit;

  ExamsArray := nil;
  FdsExams.First();
  while (not FdsExams.Eof) do
  begin
     // required: local_id, date, mo, diagnostic_material, result, type
    if FdsExams.FBN('exam_date').IsNull
      or FdsExams.FBN('exam_result').IsNull
      or FdsExams.FBN('exam_type').IsNull
      or FdsExams.FBN('mo').AsString.IsEmpty()
      or FdsExams.FBN('diagnostic_material').AsString.IsEmpty() then
    begin
      FdsExams.Next();
      Continue;
    end;

    if not Assigned(ExamsArray) then
      ExamsArray := TJSONArray.Create();

    Exam := TJSONObject.Create();
    Exam.AddPair(TJSONPair.Create('local_id', GUIDPreapare(FdsExams.FBN('local_id').AsString)));
    Exam.AddPair('type', IfThen(FdsExams.FBN('exam_type').AsInteger = 1, 'other', 'covid19')); // covid19, other
    Exam.AddPair('date', DateToISO8601(FdsExams.FBN('exam_date').AsDateTime, False)); // iso8601
    Exam.AddPair(TJSONPair.Create('mo', FdsExams.FBN('mo').AsString)); // 1.2.643.5.1.13.13.11.1461 (OID)
    Exam.AddPair('diagnostic_material', TJSONNumber.Create(FdsExams.FBN('diagnostic_material').AsInteger)); // 1.2.643.5.1.13.13.99.2.557 (id)
    Exam.AddPair('result', TJSONBool.Create(FdsExams.FBN('exam_result').AsBoolean));
    ExamsArray.AddElement(Exam);
    FdsExams.Next();
  end;

  if Assigned(ExamsArray) then
    Root.AddPair('exam', ExamsArray)
end;

procedure TSendClass.AddFinalClinicalDs(Root: TJSONObject);
var
  FinalClinicalDs: TJSONObject;
  Fds_clinfin_complication: TJSONObject;

  ArrayOfds_clinfin_complication: TJSONArray;
  ArrayOfds_clinfin_accompany: TJSONArray;
begin
  FdsFinalClinicalDs.PBN('ID').AsString := FdsAllDocs.FBN('ID').AsString;
  FdsFinalClinicalDs.PBN('MO').AsString := FdsAllDocs.FBN('MO').AsString;
  FdsFinalClinicalDs.CloseOpen();

  if (FdsFinalClinicalDs.RecordCount = 0)
    or FdsFinalClinicalDs.FBN('ds_clinfin_main').AsString.IsEmpty() then
    Exit;

  ArrayOfds_clinfin_complication := nil;
  ArrayOfds_clinfin_accompany := nil;

  // required: arrival_date, arrival_from, transport_id, transport_in
  FinalClinicalDs := TJSONObject.Create();
  FinalClinicalDs.AddPair(TJSONPair.Create('ds_clinfin_main', FdsFinalClinicalDs.FBN('ds_clinfin_main').AsString));
  FinalClinicalDs.AddPair('ds_clinfin_hasnt_complication', TJSONBool.Create(FdsFinalClinicalDs.FBN('IS_ds_clinfin_hasnt_complication').AsBoolean));
  if FdsFinalClinicalDs.FBN('ds_clinfin_complication').AsString<>'' then
  begin
    if not Assigned(ArrayOfds_clinfin_complication) then
      ArrayOfds_clinfin_complication := TJSONArray.Create();

    ArrayOfds_clinfin_complication.Add(FdsFinalClinicalDs.FBN('ds_clinfin_complication').AsString);

    FinalClinicalDs.AddPair('ds_clinfin_complication',ArrayOfds_clinfin_complication);
  end;
  FinalClinicalDs.AddPair('ds_clinfin_hasnt_accompany', TJSONBool.Create(FdsFinalClinicalDs.FBN('IS_ds_clinfin_hasnt_accompany').AsBoolean));
  if FdsFinalClinicalDs.FBN('ds_clinfin_accompany').AsString<>'' then
  begin
    if not Assigned(ArrayOfds_clinfin_accompany) then
      ArrayOfds_clinfin_accompany := TJSONArray.Create();

    ArrayOfds_clinfin_accompany.Add(FdsFinalClinicalDs.FBN('ds_clinfin_accompany').AsString);

    FinalClinicalDs.AddPair('ds_clinfin_accompany',ArrayOfds_clinfin_complication);
  end;
  if FdsFinalClinicalDs.FBN('ds_clinfin_exreason').AsString<>'' then
    FinalClinicalDs.AddPair(TJSONPair.Create('ds_clinfin_exreason', FdsFinalClinicalDs.FBN('ds_clinfin_exreason').AsString));

  Root.AddPair('final_clinical_ds', FinalClinicalDs);
end;

// Результат ежедневного наблюдения
procedure TSendClass.AddDaily(Root: TJSONObject);
var
  DailyArray: TJSONArray;
  Daily: TJSONObject;
begin
  FdsDaily.PBN('OWNER').AsString := FdsAllDocs.FBN('ID_MO').AsString;
  FdsDaily.PBN('MO').AsString := FdsAllDocs.FBN('MO').AsString;
  FdsDaily.CloseOpen();
  if (FdsDaily.RecordCount = 0) then
    Exit;

  DailyArray := nil;
  FdsDaily.First();
  while (not FdsDaily.Eof) do
  begin
    // TODO: validete params
    // required: local_id, date, disease_severity, ivl, ekmo, antivirus_threatment
    if (FdsDaily.FBN('daily_date').isNull)
      or (FdsDaily.FBN('disease_severity').AsString = '')
      or (StrToIntDef(FdsDaily.FBN('disease_severity').AsString,-1) = -1)  then
    begin
      FdsDaily.Next();
      Continue;
    end;

    if not Assigned(DailyArray) then
      DailyArray := TJSONArray.Create();

    Daily := TJSONObject.Create();
    Daily.AddPair(TJSONPair.Create('local_id', GUIDPreapare(FdsDaily.FBN('local_id').AsString)));
    Daily.AddPair(TJSONPair.Create('date', DateToISO8601(FdsDaily.FBN('daily_date').AsDateTime, False))); // iso8601
    Daily.AddPair('disease_severity', TJSONNumber.Create(FdsDaily.FBN('disease_severity').AsInteger)); // 1.2.643.5.1.13.13.11.1006 (ID)
    Daily.AddPair('saturation_level', TJSONNumber.Create(FdsDaily.FBN('saturation_level').AsInteger));
    Daily.AddPair('ivl', TJSONBool.Create(FdsDaily.FBN('is_ivl').AsBoolean));
    Daily.AddPair('ekmo', TJSONBool.Create(FdsDaily.FBN('is_ecmo').AsBoolean));
    Daily.AddPair('antivirus_threatment', TJSONBool.Create(FdsDaily.FBN('is_antivirus_threatment').AsBoolean));
    Daily.AddPair('orit', TJSONBool.Create(FdsDaily.FBN('is_orit').AsBoolean));
    DailyArray.AddElement(Daily);
    FdsDaily.Next();
  end;

  if Assigned(DailyArray) then
    Root.AddPair('daily', DailyArray)
end;

procedure TSendClass.AddDeathCertificate(Root: TJSONObject);
var
  death_certificate: TJSONObject;
  ArrayOfdeath_certificate: TJSONArray;
  ArrayOfother_important_conditions: TJSONArray;
  ArrayOfdeath_certificate_file: TJSONArray;
  ArOtherConditions: TJSONArray;
  str: string;
begin
  FdsDeathCertificate.PBN('ID').AsString := FdsAllDocs.FBN('ID').AsString;
  FdsDeathCertificate.PBN('MO').AsString := FdsAllDocs.FBN('MO').AsString;
  FdsDeathCertificate.CloseOpen();
  if (FdsDeathCertificate.RecordCount = 0)
    or (FdsDeathCertificate.FBN('certificate_series').AsString.IsEmpty())
    or (FdsDeathCertificate.FBN('certificate_number').AsString.IsEmpty())
    or (FdsDeathCertificate.FBN('certificate_date').AsString.IsEmpty())
    or (FdsDeathCertificate.FBN('deadly_disease').AsString.IsEmpty())
    or (FdsDeathCertificate.FBN('pathological_condition').AsString.IsEmpty())
    or (FdsDeathCertificate.FBN('original_cause').AsString.IsEmpty())
    or (FdsDeathCertificate.FBN('is_no_other_important_conditions').IsNull) then
    Exit;

  Fdsdeathcertificatefile.PBN('OWNER').AsString := FdsAllDocs.FBN('ID_MO').AsString;
  Fdsdeathcertificatefile.PBN('MO').AsString := FdsAllDocs.FBN('MO').AsString;
  Fdsdeathcertificatefile.CloseOpen();
  if (Fdsdeathcertificatefile.RecordCount=0)
    or (Fdsdeathcertificatefile.FBN('DOC_NAME').AsString.IsEmpty) then
    Exit;

  ArrayOfdeath_certificate:= Nil;
  ArrayOfother_important_conditions:= Nil;
  ArOtherConditions := nil;
  ArrayOfdeath_certificate_file := nil;

  death_certificate:= TJSONObject.Create;
  death_certificate.AddPair(TJSONPair.Create('certificate_series', FdsDeathCertificate.FBN('certificate_series').AsString));
  death_certificate.AddPair(TJSONPair.Create('certificate_number', FdsDeathCertificate.FBN('certificate_number').AsString));
  death_certificate.AddPair('certificate_date', FormatDateToStr(FdsDeathCertificate.FBN('certificate_date').AsDateTime));
  death_certificate.AddPair(TJSONPair.Create('deadly_disease', FdsDeathCertificate.FBN('deadly_disease').AsString));
  death_certificate.AddPair(TJSONPair.Create('pathological_condition', FdsDeathCertificate.FBN('pathological_condition').AsString));
  death_certificate.AddPair(TJSONPair.Create('original_cause', FdsDeathCertificate.FBN('original_cause').AsString));
  if not FdsDeathCertificate.FBN('external_cause').isnull then
    death_certificate.AddPair(TJSONPair.Create('external_cause', FdsDeathCertificate.FBN('external_cause').AsString));
  death_certificate.AddPair('no_other_important_conditions', TJSONBool.Create(FdsDeathCertificate.FBN('IS_no_other_important_conditions').AsBoolean));
  if (FdsDeathCertificate.FBN('is_no_other_important_conditions').AsBoolean = False) and
     (FdsDeathCertificate.FBN('other_important_conditions').AsString <> '') then
  begin
    ArOtherConditions := TJSONArray.Create();
    ArOtherConditions.Add(FdsDeathCertificate.FBN('other_important_conditions').AsString);
    death_certificate.AddPair('other_important_conditions', ArOtherConditions);
  end;
  //Файлы
  if (Fdsdeathcertificatefile.RecordCount>0) and (not Fdsdeathcertificatefile.FBN('DOC_NAME').AsString.IsEmpty) then
  begin
    if not Assigned(ArrayOfdeath_certificate_file) then
      ArrayOfdeath_certificate_file := TJSONArray.Create();

    ArrayOfdeath_certificate_file.Add(Fdsdeathcertificatefile.FBN('DOC_NAME').AsString);

    SetLength(ArrayFilesInRest,Length(ArrayFilesInRest)+1);

    ArrayFilesInRest[Length(ArrayFilesInRest)-1]:=TFilesInRest.Create;
    ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileName:=Fdsdeathcertificatefile.FBN('DOC_NAME').AsString;
    ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileMes:=TMemoryStream.Create;
    ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileMes.Seek(0, soFromBeginning);
    TBlobField(Fdsdeathcertificatefile.FieldByName('DOC')).SaveToStream(ArrayFilesInRest[Length(ArrayFilesInRest)-1].FileMes);

    death_certificate.AddPair('death_certificate_file',ArrayOfdeath_certificate_file);
  end;
  //
  if not Assigned(ArrayOfdeath_certificate) then
    ArrayOfdeath_certificate := TJSONArray.Create();
  ArrayOfdeath_certificate.AddElement(death_certificate);

  Root.AddPair('death_certificate', ArrayOfdeath_certificate);
end;

// Блок информации о прибытии пациентов из другой страны
procedure TSendClass.AddAddressesEpic(Root: TJSONObject; NodeName, PatientId,
  MOId: String);
var
  AddressNode: TJSONObject;
  Address: TJSONObject;
begin
  FdsAddress.PBN('PATIENT').AsString := PatientId;
  FdsAddress.PBN('MO').AsString := MOId;
  FdsAddress.CloseOpen();
  if (FdsAddress.RecordCount = 0) then
    Exit;

  FdsAddress.First();
  // required: addr_type, address
  if FdsAddress.FBN('area_name').AsString.IsEmpty()
    or FdsAddress.FBN('street_name').AsString.IsEmpty() then
  begin
    FdsAddress.Next();
  end;

  AddressNode := TJSONObject.Create();
  AddressNode.AddPair(TJSONPair.Create('addr_type', FdsAddress.FBN('addr_type').AsString)); // reg, live
  Address := TJSONObject.Create();
  Address.AddPair('region', TJSONNumber.Create(FdsAddress.FBN('region').AsInteger)); // required: 1.2.643.5.1.13.13.99.2.206
//    Address.AddPair(TJSONPair.Create('area_guid', '')); // ФИАС
//    Address.AddPair(TJSONPair.Create('street_guid', '')); // ФИАС
//    Address.AddPair(TJSONPair.Create('house_guid', '')); // ФИАС
  Address.AddPair(TJSONPair.Create('area_name', FdsAddress.FBN('area_name').AsString)); // нас. пункт
  Address.AddPair(TJSONPair.Create('street_name', FdsAddress.FBN('street_name').AsString));
  Address.AddPair(TJSONPair.Create('house', FdsAddress.FBN('house').AsString));
  Address.AddPair(TJSONPair.Create('flat', FdsAddress.FBN('flat').AsString));
  AddressNode.AddPair(TJSONPair.Create('address', Address));

  Root.AddPair(NodeName, Address);
end;

procedure TSendClass.AddArrival(Root: TJSONObject);
var
  Arrival: TJSONObject;
begin
  FdsArrival.PBN('ID').AsString := FdsAllDocs.FBN('ID').AsString;
  FdsArrival.CloseOpen();
  if (FdsArrival.RecordCount = 0)
    or (FdsArrival.FBN('arrival_date').isNull)
    or (FdsArrival.FBN('arrival_from').AsInteger = 0)
    or (FdsArrival.FBN('transport_id').AsInteger = 0)
    or FdsArrival.FBN('transport_in').AsString.IsEmpty() then
    Exit;

  // required: arrival_date, arrival_from, transport_id, transport_in
  Arrival := TJSONObject.Create();
  Arrival.AddPair('arrival_date', FormatDateToStr(FdsArrival.FBN('arrival_date').AsDateTime));
  Arrival.AddPair('arrival_from', TJSONNumber.Create(FdsArrival.FBN('arrival_from').AsInteger)); // 1.2.643.5.1.13.2.1.1.63 (id)
  Arrival.AddPair('transport_id', TJSONNumber.Create(FdsArrival.FBN('transport_id').AsInteger)); // 1.2.643.5.1.13.13.99.2.556 (id)
  Arrival.AddPair(TJSONPair.Create('transport_detail', FdsArrival.FBN('transport_detail').AsString));
  Arrival.AddPair(TJSONPair.Create('transport_in', FdsArrival.FBN('transport_in').AsString));
  Arrival.AddPair(TJSONPair.Create('movement', FdsArrival.FBN('movement').AsString));
  Root.AddPair('arrival', Arrival);
end;

// Блок информация о контактных лицах
procedure TSendClass.AddEpidContact(Root: TJSONObject);
var
  ArrayOfContacts: TJSONArray;
  EpidContact: TJSONObject;
//  AddressesArray: TJSONArray;
//  AddressNode: TJSONObject;
//  Address: TJSONObject;
  mobile: string;
begin
  FdsEpidContact.PBN('OWNER').AsString := FdsAllDocs.FBN('ID_MO').AsString;
  FdsEpidContact.PBN('MO').AsString := FdsAllDocs.FBN('MO').AsString;
  FdsEpidContact.CloseOpen();
  if (FdsEpidContact.RecordCount = 0) then
    Exit;

  ArrayOfContacts := nil;
  FdsEpidContact.First();
  while (not FdsEpidContact.Eof) do
  begin
    if FdsEpidContact.FBN('firstname').AsString.IsEmpty()
      or FdsEpidContact.FBN('lastname').AsString.IsEmpty()
      or (FdsEpidContact.FBN('gender').AsInteger = 0) then
    begin
      FdsEpidContact.Next();
      Continue;
    end;
    mobile := '';

    if not Assigned(ArrayOfContacts) then
      ArrayOfContacts := TJSONArray.Create();

    // required: local_id, firstname, lastname, gender
    EpidContact := TJSONObject.Create();
    EpidContact.AddPair(TJSONPair.Create('local_id', GUIDPreapare(FdsEpidContact.FBN('local_id').AsString)));
    EpidContact.AddPair(TJSONPair.Create('firstname', RemoveSpaces(FdsEpidContact.FBN('firstname').AsString)));
    EpidContact.AddPair(TJSONPair.Create('lastname', RemoveSpaces(FdsEpidContact.FBN('lastname').AsString)));
    EpidContact.AddPair(TJSONPair.Create('patronymic', RemoveSpaces(FdsEpidContact.FBN('patronymic').AsString)));
    If FdsEpidContact.FBN('birth_date').IsNull = False then
      EpidContact.AddPair('birth_date', FormatDateToStr(FdsEpidContact.FBN('birth_date').AsDateTime));
    EpidContact.AddPair('gender', TJSONNumber.Create(FdsEpidContact.FBN('gender').AsInteger)); // 1-мужской, 2-женский
    EpidContact.AddPair('citizenship_country', TJSONNumber.Create(FdsEpidContact.FBN('citizenship_country').AsInteger)); // 1.2.643.5.1.13.2.1.1.63 (id)
    mobile := PhoneNumPrepare(FdsEpidContact.FBN('mobile_phone').AsString);
    if (TRegEx.IsMatch(mobile, '^(\+\d{5,11})$')) then
      EpidContact.AddPair(TJSONPair.Create('mobile_phone', mobile));
    EpidContact.AddPair(TJSONPair.Create('live_address_manual', FdsEpidContact.FBN('live_address_manual').AsString));

    AddAddressesEpic(EpidContact, 'live_address', FdsEpidContact.FBN('PATIENT').AsString, FdsEpidContact.FBN('MO').AsString);

//    AddressesArray := TJSONArray.Create();
//    AddressNode := TJSONObject.Create();
//    AddressNode.AddPair(TJSONPair.Create('addr_type', 'reg')); // reg, live
//    Address := TJSONObject.Create();
//    Address.AddPair('region', TJSONNumber.Create(FdsEpidContact.FBN('region').AsInteger)); // required: 1.2.643.5.1.13.13.99.2.206
//    Address.AddPair(TJSONPair.Create('area_name', FdsEpidContact.FBN('area_name').AsString));
//    Address.AddPair(TJSONPair.Create('street_name', FdsEpidContact.FBN('street_name').AsString));
//    Address.AddPair(TJSONPair.Create('house', FdsEpidContact.FBN('house').AsString));
//    Address.AddPair(TJSONPair.Create('flat', FdsEpidContact.FBN('flat').AsString));
//    AddressNode.AddPair(TJSONPair.Create('address', Address));
//    AddressesArray.AddElement(AddressNode);
//    EpidContact.AddPair('live_address', AddressesArray);

    ArrayOfContacts.AddElement(EpidContact);

    FdsEpidContact.Next();
  end;

  if Assigned(ArrayOfContacts) then
    Root.AddPair('epid_contact', ArrayOfContacts);
end;

procedure TSendClass.WriteDocExternalInfo(Id, Uin, AMessage: String);
begin
  try
    FdsExtInfo.PBN('owner').AsString := Id;
    FdsExtInfo.CloseOpen();
    if (FdsExtInfo.RecordCount = 0) then
    begin
      FdsExtInfo.Append();
      FdsExtInfo.FBN('OWNER').AsString := Id;
      FdsExtInfo.FBN('ID').AsString := GenKey_UIN('MIS_KSAMU.dbo.REG_EXTERNAL_COVID');
    end
    else
      FdsExtInfo.Edit();
    FdsExtInfo.FBN('DATE_SEND').AsDateTime := Now();
    if not Uin.IsEmpty() and (FdsExtInfo.FBN('UIN').AsString <> Uin) then
      FdsExtInfo.FBN('UIN').AsString := Uin;
    if AMessage.IsEmpty() then
      FdsExtInfo.FBN('MESSAGE').Value := Null
    else
      FdsExtInfo.FBN('MESSAGE').AsString := AMessage;
    FdsExtInfo.Post();
    FdsExtInfo.UpdateTransaction.Commit();
    FdsExtInfo.Close();
  except
    on E: Exception do
    begin
      if FdsExtInfo.UpdateTransaction.Active then
        FdsExtInfo.UpdateTransaction.Rollback();
      Log('Ошибка обновления внешней информации: ' + E.Message);
    end;
  end;
end;

procedure TSendClass.WriteSendedDoc(Id, Status: String);
begin
  try
    FdsSendedDoc.PBN('ID').AsString := Id;
    FdsSendedDoc.CloseOpen();
    if (FdsSendedDoc.RecordCount = 0) then
      FdsSendedDoc.Append()
    else
      FdsSendedDoc.Edit;

    FdsSendedDoc.FBN('ID').AsString := Id;
    FdsSendedDoc.FBN('DATEADD').AsDateTime := Now;
    FdsSendedDoc.FBN('STATUS').AsString := Status;

    FdsSendedDoc.Post();
    FdsSendedDoc.UpdateTransaction.Commit();
    FdsSendedDoc.Close();
  except
    on E: Exception do
    begin
      if FdsSendedDoc.UpdateTransaction.Active then
        FdsSendedDoc.UpdateTransaction.Rollback();
      Log('Ошибка Обновления статуса документа: ' + E.Message);
    end;
  end;
end;

procedure TSendClass.WriteUnloadDoc(Id: String);
begin
  try
    FdsUpdateAllDocs.PBN('ID').AsString:=Id;
    FdsUpdateAllDocs.CloseOpen();
    FdsUpdateAllDocs.Edit;
    FdsUpdateAllDocs.FBN('DATE_UPLOAD').AsDateTime:=Now;
    FdsUpdateAllDocs.Post;
    FdsUpdateAllDocs.UpdateTransaction.Commit();
    FdsUpdateAllDocs.close;
  except
    on E: Exception do
    begin
      if FdsUpdateAllDocs.UpdateTransaction.Active then
        FdsUpdateAllDocs.UpdateTransaction.Rollback();
      Log('Ошибка обновления внешней информации: ' + E.Message);
    end;
  end;
end;

function TSendClass.FormatDateToStr(ADate: TDate): String;
const
  DATE_PATTERN = 'yyyy-mm-dd';
begin
  Result := FormatDateTime(DATE_PATTERN, ADate);
end;

function TSendClass.GUIDPreapare(GUID: String): string;
var
  TempGUID: TGUID;
begin
  CreateGUID(TempGUID);
  Result:=StringReplace(StringReplace(GUID,'{','',[rfReplaceAll, rfIgnoreCase]),'}','',[rfReplaceAll, rfIgnoreCase]);
  //Result:=StringReplace(StringReplace(LowerCase(GUIDToString(TempGUID)),'{','',[rfReplaceAll, rfIgnoreCase]),'}','',[rfReplaceAll, rfIgnoreCase]);
end;

function TSendClass.PhoneNumPrepare(Phone: string): string;
var
 tel: string;
begin
  tel := RemoveSpaces(Phone);
  tel := DeleteNotNumbers(Phone);
  if (tel.Length > 6) and (tel[1] = '8') then
    tel[1] := '7';
  if (tel.Length = 10) and (tel[1] <> '7') then
    tel := '7' + tel;
  if tel.Length = 0 then
    tel := '98765';
  result := '+' + Copy(tel, 1, 11);
end;

function TSendClass.CheckSnils(SNILS: string): Boolean;
var
  I, CheckSum: Integer;
  S: string;
begin
  if not TRegEx.IsMatch(SNILS, '^\d{3}-{0,1}\d{3}-{0,1}\d{3} {0,1}\d{2}$') then
    Exit(False);
  S := DeleteNotNumbers(SNILS);
  S := LeftStr(S, 9);
  if S = '000000000' then
    Exit(False);
  if StrToInt(S) < 1001998 then
    Exit(True);
  CheckSum := 0;
  for I := 1 to 9 do
    Inc(CheckSum, (10 - I) * StrToInt(S[I]));
  CheckSum := (CheckSum mod 101) mod 100;
  Result := CheckSum = RightStr(SNILS, 2).ToInteger();
end;

function TSendClass.CorrectCodeSMO(CodeSMO: String): String;
var
  i: Integer;
begin
  Result:=CodeSMO;
  for I := Length(CodeSMO) to 4 do
  begin
    Result:='0'+Result;
  end;
end;

procedure TSendClass.CreateComponents();
begin
  inherited;
  //тестовое подключение
  try
   ConnectBase();
   DisconnectBase();
  except
    raise Exception.Create('Ошибка подключения к БД');
    exit;
  end;
  FdsAllDocs := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'AllDocs'));
  FdsPersonInfo := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectPersonalInfo'));
  FdsDUL := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectDULs'));
  FdsAddress := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectAddresses'));
  FdsInsurance := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectInsurance'));
  FdsRegInfo := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectRegInfo'));
  FdsPatology := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectPathology'));
  FdsExams := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectExams'));
  FdsDaily := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectDailyInfo'));
  FdsArrival := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectArrivalInfo'));
  FdsEpidContact := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectEpidContacts'));
  FdsFinalClinicalDs := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectFinalClinicalDs'));
  FdsPathologicalDs := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectPathologicalDs'));
  FdsDeathCertificate := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SelectDeathCertificate'));
  FdsDsPsmpreFile := CreateDataSetFiles(FSQLModule.FindScript('COVIDScripts', 'SelectDsPsmpreFile'));
  FdsDsPsmfinFile := CreateDataSetFiles(FSQLModule.FindScript('COVIDScripts', 'SelectDsPsmfinFile'));
  FdsDeathCertificateFile := CreateDataSetFiles(FSQLModule.FindScript('COVIDScripts', 'SelectDeathCertificateFile'));

  FdsExtInfo := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SetDocumentExternalInfo'), 'MIS_KSAMU.dbo.REG_EXTERNAL_COVID');
  FdsSendedDoc := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'SetDocumentSended'), 'MIS_KSAMU.dbo.REG_COVID');

  FdsUpdateAllDocs := CreateDataSet(FSQLModule.FindScript('COVIDScripts', 'UpdateDateDoc'), 'MIS_KSAMU.dbo.DOC_COVID');

  FRester := TRester.Create(FLog);
end;

procedure TSendClass.DestroyComponents();
begin
  FreeAndNil(FRester);

  FreeAndNil(FdsAllDocs);
  FreeAndNil(FdsPersonInfo);
  FreeAndNil(FdsDUL);
  FreeAndNil(FdsAddress);
  FreeAndNil(FdsInsurance);
  FreeAndNil(FdsRegInfo);
  FreeAndNil(FdsPatology);
  FreeAndNil(FdsExams);
  FreeAndNil(FdsDaily);
  FreeAndNil(FdsArrival);
  FreeAndNil(FdsEpidContact);
  FreeAndNil(FdsFinalClinicalDs);
  FreeAndNil(FdsPathologicalDs);
  FreeAndNil(FdsDeathCertificate);
  FreeAndNil(FdsDsPsmpreFile);
  FreeAndNil(FdsDsPsmfinFile);
  FreeAndNil(FdsDeathCertificateFile);

  FreeAndNil(FdsExtInfo);
  FreeAndNil(FdsSendedDoc);
  FreeAndNil(FdsUpdateAllDocs);

  inherited;
end;

function TSendClass.DeleteNotNumbers(S: String): String;
begin
  Result := TRegEx.Replace(S, '[^0-9]', '');
end;

function TSendClass.RemoveSpaces(S: String): String;
begin
  Result := TRegEx.Replace(S, '\s+', '');
end;

//procedure TSendClass.SaveToFile(JSON: TJSONObject);
//var
//  Stream: TStringStream;
//begin
//  Stream := TStringStream.Create(JSON.ToJSON, TEncoding.UTF8);
//  try
//    Stream.SaveToFile('D:\Test.json');
//  finally
//    FreeAndNil(Stream);
//  end;
//end;

end.
