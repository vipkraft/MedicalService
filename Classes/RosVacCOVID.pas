unit RosVacCOVID;

interface

uses REST.Client, System.SysUtils, REST.Types, IPPeerCommon, System.JSON, IdURI, IPPeerClient, System.Classes,
  System.DateUtils, cxDateUtils, NativeXml, System.ZLib, SevenZip,
  //AbBase, AbBrowse, AbZBrows, AbZipper,
  REST.Authenticator.OAuth, System.StrUtils,
  //AbUnzper, AbUtils, AbArcTyp,
  REST.Authenticator.OAuth.WebForm.Win,Vcl.Forms,
  System.NetEncoding, Winapi.WinInet, IdHTTP, IdSSLOpenSSL, IdGlobal
  ,Vcl.Dialogs
  ,LogInterfaces
  ;

type
  Tsub_researches = class
    exam_result: string;
    exam_date: string;
  end;

  Tsub_drugs = class
    drug_name: string;
    dosage: string;
    duration: string;
    take_type: string;
    drug: string;
    standard_form: String;
    normalized_dosage: String;
    day_amount: string;
  end;

  Tsub_exams = class
    script_vaccination: string;
    exam_date: string;
    mo: string;
    department: string;
    medical_worker: string;
    medical_worker_snils: string;
    temperature: string;
    respiratory_rate: string;
    heart_rate: string;
    general_state: string;
    had_covid: string;
    contact_patient: string;
    admission: string;
    contraindication: string;
    exacerbation: string;
    decompensation: string;
    complication: string;
    contraindication_mkb: string;
    admission_start_date: string;
    admission_end_date: string;
    medical_commission_date: string;
    medical_commission_number: string;
    pregnancy: string;
    pregnancy_period: string;
    exam_type: string;
    result_pcr: string;
    igm: string;
    igg: string;
    female: boolean;
  end;

  Tsub_reactions = class
    reaction: string;
    reaction_type: string;
    reaction_text: string;
  end;

  Tsub_stages = class
    stage_number: string;
    gtin: string;
    serial_number: string;
    batch_series: string;
    has_reaction: string;
    reaction: string;
    reaction_type: string;
    sub_reactions: array of Tsub_reactions;
    sub_exams: array of Tsub_exams;
    sub_drugs: array of Tsub_drugs;
  end;

  TReg = class
    has_allergies: String;
    allergies: string;
    had_last_vaccine_reactions: string;
    last_vaccine_reactions: string;
    vaccination_information_flu: string;
    information_flu_id: string;
    information_flu_text: string;
    vaccination_information_air: string;
    vaccine: string;
    has_pathology_bronch: string;
    pathology_bronch: array of string;
    has_pathology_cardio: string;
    pathology_cardio: array of string;
    has_pathology_endo: string;
    pathology_endo: array of string;
    has_pathology_onko: string;
    pathology_onko: array of string;
    has_pathology_hiv: string;
    pathology_hiv: array of string;
    has_pathology_tuber: string;
    pathology_tuber: array of string;
    has_pathology_syphilis: string;
    pathology_syphilis: array of string;
    has_pathology_hepatitis: string;
    pathology_hepatitis: array of string;
    has_pathology_other: string;
    pathology_other: array of string;
    risk_group: string;
    sub_researches: array of Tsub_researches;
    sub_stages: array of Tsub_stages;
  end;

  Tsub_persdocs = class
    persdoc_type: string;
    pd_series: string;
    pd_number: string;
    issued_by: string;
    date_begin: string;
  end;

  Tsub_contacts = class
    contact_type: string;
    contact: string;
  end;

  Taddress = class
    region: string;
    area_guid: string;
    street_guid: string;
    house_guid: string;
    area_name: string;
    street_name: string;
    house: string;
    flat: string;
  end;

  Tsub_addr = class
    addr_type: String;
    address: Taddress;
  end;

   Tsub_insurance = class
    policy_type: string;
    policy_series: string;
    policy_number: string;
    ins_org: string;
  end;

  Tperson = class
    snils: string;
    lastname: string;
    firstname: string;
    patronymic: string;
    gender: string;
    birth_date: string;
    citizenship_country: string;
    citizenship: string;
    sub_persdocs: array of Tsub_persdocs;
    sub_contacts: array of Tsub_contacts;
    sub_addr: array of Tsub_addr;
    sub_insurance: array of Tsub_insurance;
  end;

  TPostRecordIn = class
    reg: TReg;
    person: Tperson;
  end;

  TPostRecordOut = class
    codeError: string;
    Content: string;
    reg_id: string;
    person_id: string;
  end;

  TPutRegOut = class
    codeError: string;
    Content: string;
  end;

  TPutRegStageExamOut = class
    codeError: string;
    Content: string;
  end;

  TPutRegIn = class
    has_allergies: string;
    allergies: string;
    had_last_vaccine_reactions: string;
    last_vaccine_reactions: string;
    vaccination_information_flu: string;
    information_flu_id: string;
    information_flu_text: string;
    vaccination_information_air: string;
    vaccine: string;
    has_pathology_bronch: string;
    pathology_bronch: array of string;
    has_pathology_cardio: String;
    pathology_cardio: array of string;
    has_pathology_endo: string;
    pathology_endo: array of string;
    has_pathology_onko: string;
    pathology_onko: array of string;
    has_pathology_hiv: string;
    pathology_hiv: array of string;
    has_pathology_tuber: string;
    pathology_tuber: array of string;
    has_pathology_syphilis: string;
    pathology_syphilis: array of string;
    has_pathology_hepatitis: string;
    pathology_hepatitis: array of string;
    has_pathology_other: string;
    pathology_other: array of string;
    risk_group: string;
    sub_researches: array of Tsub_researches;
    sub_stages: array of Tsub_stages;
  end;

  TPutRegStageExamIn = class
    exam_date: string;
    mo: string;
    department: string;
    medical_worker: string;
    medical_worker_snils: String;
    temperature: string;
    respiratory_rate: string;
    heart_rate: string;
    general_state: string;
    had_covid: string;
    contact_patient: string;
    admission: string;
    pregnancy: string;
    pregnancy_period: string;
  end;

  TPutPersonIn = class
    snils: string;
    lastname: string;
    firstname: string;
    patronymic: string;
    gender: string;
    birth_date: string;
    citizenship_country: string;
    citizenship: string;
    sub_persdocs: array of Tsub_persdocs;
    sub_contacts: array of Tsub_contacts;
    sub_addr: array of Tsub_addr;
    sub_insurance: array of Tsub_insurance;
  end;

  TPutPersonOut = class
    codeError: string;
    Content: string;
  end;

  Tsub_moves = class
    date_from: string;
    date_to: string;
    country: string;
    city: string;
  end;

  Tsub_acts = class
    act_id: string;
  end;

  Tsub_adds = class
    symp_id: string;
    description: string;
  end;


  Tsub_diffs = class
    disease_name: string;
    date_begin: string;
    date_end: string;
  end;

  Tsub_symp = class
    symp_date_begin: String;
    symp_date_end: string;
    symp_diff: string;
    add_treatment: string;
    different_action: string;
    sub_acts: array of Tsub_acts;
    sub_adds: array of Tsub_adds;
    sub_drugs: array of Tsub_drugs;
    sub_diffs: array of Tsub_diffs;
  end;

  TPostRegDairyIn = class
    diary_date: string;
    pregnancy: string;
    first_stage_contact: string;
    first_stage_contact_date: string;
    second_stage_contact: string;
    second_stage_contact_date: string;
    description: string;
    sub_exams: array of Tsub_exams;
    sub_moves: array of Tsub_moves;
    sub_symp: Tsub_symp;
  end;

  TPostRegDairyOut = class
    codeError: string;
    Content: string;
  end;

  TPutRegDairyIn = class
    diary_date: string;
    pregnancy: string;
    first_stage_contact: string;
    first_stage_contact_date: string;
    second_stage_contact: String;
    second_stage_contact_date: string;
    description: string;
    sub_exams: array of Tsub_exams;
    sub_moves: array of Tsub_moves;
    sub_symp: Tsub_symp;
  end;

  TPutRegDairyOut = class
    codeError: string;
    Content: string;
  end;

  TDeleteRegDairyOut = class
    codeError: string;
    Content: string;
  end;

  Tsub_symps = class
    symp_id: string;
    description: string;
  end;

  TPostRegComplicationIn = class
    exam_date: string;
    mo: String;
    department: string;
    medical_worker: string;
    medical_worker_snils: string;
    other_symp: string;
    sub_symps: array of Tsub_symps;
  end;

  TPostRegComplicationOut = class
    codeError: string;
    Content: string;
  end;

  TPutRegComplicationIn = class
    exam_date: string;
    mo: string;
    department: STring;
    medical_worker: string;
    medical_worker_snils: string;
    other_symp: string;
    sub_symps: array of Tsub_symps;
  end;

  TPutRegComplicationOut = class
    codeError: string;
    Content: string;
  end;

  TDeleteRegComplicationOut = class
    codeError: string;
    Content: string;
  end;

  Tsub_exam = class
    exam_date: string;
    mo: string;
    pregnancy_term: string;
    pregnancy_features: string;
  end;

  Tsub_child = class
    gender: string;
    weight: string;
    height: string;
    apgar_scale: string;
    has_anomalies: string;
    anomalies: array of string;
  end;

  TPostRegPregnancyIn = class
    estimated_date: string;
    pregnancy_order: string;
    childbirth_order: string;
    pregnancy_outcome: string;
    pregnancy_outcome_date: String;
    mo: string;
    childbirth_term: string;
    childbirth_features: string;
    children_amount: string;
    sub_exam: array of Tsub_exam;
    sub_child: array of Tsub_child;
  end;

  TPostRegPregnancyOut = class
    codeError: string;
    Content: string;
  end;

  TPutRegPregnancyIn = class
    estimated_date: string;
    pregnancy_order: string;
    childbirth_order: string;
    pregnancy_outcome: string;
    pregnancy_outcome_date: string;
    mo: string;
    childbirth_term: string;
    childbirth_features: string;
    children_amount: string;
    sub_exam: array of Tsub_exam;
    sub_child: array of Tsub_child;
  end;

  TPutRegPregnancyOut = class
    codeError: string;
    Content: string;
  end;

  TDeleteRegPregnancyOut = class
    codeError: string;
    Content: string;
  end;

  TRosVacCOVID = class
    private
      FLog: ILog;
      FUrlPath: string;
      Fsertopen: string;
      Fips: string;
      Fsertclose: string;
      FAuthorization: string;
      function CreateRESTClient(): TRESTClient;
      function CreateRESTResponse(): TRESTResponse;
      function CreateRESTRequest(Resource: string; RestRequestMethod: TRestRequestMethod;
      RESTClient: TRESTClient; RESTResponse: TRESTResponse): TRESTRequest;
      function AddParam(NameParam, ValueParam, SourceParams: String): String;
      function FormatDateTimeToService(DateIn: TDateTime): string;
      function FormatDateToService(DateIn: TDateTime): string;
      procedure SaveToFile(JSON: TJSONObject);
      procedure SaveToF(AuthStr: string; sFileName: string);
      procedure Log(AMessage: String);
    public
      ///<summary>Создание регистровой записи</summary>
      function PostRecord(send: TPostRecordIn): TPostRecordOut;
      ///<summary>Обновление регистровой записи</summary>
      function PutReg(reg_id: string; send: TPutRegIn): TPutRegOut;
      ///<summary>Обновление осмотра</summary>
      function PutRegStageExam(reg_id, stage_number, exam_date: string; send: TPutRegStageExamIn): TPutRegStageExamOut;
      ///<summary>Обновление осмотра</summary>
      function PutPerson(reg_id: string; send: TPutPersonIn): TPutPersonOut;
      ///<summary>Создание записи в дневнике самонаблюдения</summary>
      function PostRegDairy(reg_id: string; send: TPostRegDairyIn): TPostRegDairyOut;
      ///<summary>Обновление записи в дневнике самонаблюдения</summary>
      function PutRegDairy(reg_id, diary_date: string; send: TPutRegDairyIn): TPutRegDairyOut;
      ///<summary>Удаление записи в дневнике самонаблюдения</summary>
      function DeleteRegDairy(reg_id: string): TDeleteRegDairyOut;
      ///<summary>Создание записи сведений об осложнениях</summary>
      function PostRegComplication(reg_id: string; send: TPostRegComplicationIn): TPostRegComplicationOut;
      ///<summary>Обновление записи сведений об осложнениях</summary>
      function PutRegComplication(reg_id, complication_date: string; send: TPutRegComplicationIn): TPutRegComplicationOut;
      ///<summary>Удаление записи сведений об осложнениях</summary>
      function DeleteRegComplication(reg_id, complication_date: string): TDeleteRegComplicationOut;
      ///<summary>Создание записи сведений о беременности после иммунизации</summary>
      function PostRegPregnancy(reg_id: string; send: TPostRegPregnancyIn): TPostRegPregnancyOut;
      ///<summary>Обновление записи сведений о беременности после иммунизации</summary>
      function PutRegPregnancy(reg_id, pregnancy, searchBy: string; send: TPutRegPregnancyIn): TPutRegPregnancyOut;
      ///<summary>Удаление записи сведений о беременности после иммунизации</summary>
      function DeleteRegPregnancy(reg_id, pregnancy, searchBy: string): TDeleteRegPregnancyOut;
      constructor Create(ALog: ILog);
    published
      property UrlPath: string read FUrlPath write FUrlPath;
      property ips: string read Fips write Fips;
      property sertopen: string read Fsertopen write Fsertopen;
      property sertclose: string read Fsertclose write Fsertclose;
      property Authorization: string read FAuthorization write FAuthorization;
  end;

implementation
{ TRosVacCOVID }

uses
  Main;

function TRosVacCOVID.AddParam(NameParam, ValueParam, SourceParams: String): String;
begin
  if SourceParams='' then
    Result:='?'
  else
    Result:=SourceParams+'&';
  Result:=Result+NameParam+'='+ValueParam;
end;

constructor TRosVacCOVID.Create(ALog: ILog);
begin
  FLog := ALog;
end;

function TRosVacCOVID.CreateRESTClient: TRESTClient;
begin
  Result:=TRESTClient.Create(FUrlPath);
  Result.AcceptCharset := 'UTF-8';
  Result.AcceptEncoding := 'UTF-8';
  Result.ContentType := 'charset=utf-8';
  Result.FallbackCharsetEncoding := 'UTF-8';
  Result.AllowCookies := True;
  Result.AutoCreateParams := True;
  Result.HandleRedirects := True;
  Result.RaiseExceptionOn500 := True;
  Result.SynchronizedEvents := True;
  Result.BaseURL:=FUrlPath;
end;

function TRosVacCOVID.CreateRESTRequest(Resource: string; RestRequestMethod: TRestRequestMethod; RESTClient: TRESTClient;
  RESTResponse: TRESTResponse): TRESTRequest;
begin
  Result:=TRESTRequest.Create(nil);
  Result.Client:=RESTClient;
  Result.Response:=RESTResponse;
  Result.ClearBody;
  Result.Params.Clear;
  Result.Resource:=Resource;
  Result.Method:=RestRequestMethod;
  Result.Timeout:=600000;
  Result.Accept := 'application/json';
  Result.AcceptCharset := 'UTF-8';
  Result.AcceptEncoding := 'UTF-8';
  Result.Params.AddHeader('Authorization', 'Bearer '+FAuthorization);
  Result.Params.Items[0].Options:=[poDoNotEncode];
end;

function TRosVacCOVID.CreateRESTResponse: TRESTResponse;
begin
  Result:=TRESTResponse.Create(nil);
  Result.ContentEncoding := 'UTF-8';
end;

function TRosVacCOVID.DeleteRegComplication(reg_id, complication_date: string): TDeleteRegComplicationOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;
  Bundle, sub_symps: TJSONObject;
  sub_sympsArray: TJSONArray;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('record/'+reg_id+'/complication/'+complication_date,TRestRequestMethod.rmDELETE, RESTClient, RESTResponse);

  try
    RESTRequest.Execute;
  except
  end;

  Result:=TDeleteRegComplicationOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

function TRosVacCOVID.DeleteRegDairy(reg_id: string): TDeleteRegDairyOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;

  i,j: Integer;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('record/'+reg_id+'/dairy',TRestRequestMethod.rmPUT, RESTClient, RESTResponse);

  try
    RESTRequest.Execute;
  except
  end;

  Result:=TDeleteRegDairyOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

function TRosVacCOVID.DeleteRegPregnancy(reg_id, pregnancy, searchBy: string): TDeleteRegPregnancyOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;

  i,j: Integer;

  Bundle, sub_exam, sub_child: TJSONObject;
  sub_examArray, sub_childArray: TJSONArray;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('record/'+reg_id+'/pregnancy/'+pregnancy+'?searchBy='+searchBy,TRestRequestMethod.rmDELETE, RESTClient, RESTResponse);
  //
  RESTRequest.AddBody(Bundle.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
  try
    RESTRequest.Execute;
  except
  end;

  Result:=TDeleteRegPregnancyOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

function TRosVacCOVID.FormatDateTimeToService(DateIn: TDateTime): string;
begin
  Result:=FormatDateTime('yyyy-MM-dd HH:mm:ss', DateIn);
end;

function TRosVacCOVID.FormatDateToService(DateIn: TDateTime): string;
begin
  Result:=FormatDateTime('yyyy-MM-dd', DateIn);
end;

procedure TRosVacCOVID.Log(AMessage: String);
begin
 if Assigned(FLog) then
    FLog.AppendRecord(Self.ClassName, 0, 0, AMessage);
end;

function TRosVacCOVID.PostRecord(send: TPostRecordIn): TPostRecordOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;
  i, j: Integer;
  Bundle, reg, sub_researches, sub_stages, sub_exams, person, sub_persdocs, sub_contacts, sub_addr,
  address: TJSONObject;
  pathology_bronchArray, pathology_cardioArray, pathology_endoArray, pathology_onkoArray, pathology_hivArray,
  pathology_tuberArray, pathology_syphilisArray, pathology_hepatitisArray, pathology_otherArray,
  sub_researchesArray, sub_stagesArray, sub_examsArray, sub_persdocsArray, sub_contactsArray,
  sub_addrArray: TJSONArray;
  tmp:string;
  Dopusk: string;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('/record',TRestRequestMethod.rmPOST, RESTClient, RESTResponse);

  //Заполнение запроса
  Bundle:=TJSONObject.Create;
  if send.reg <> Nil then
  begin
    reg := TJSONObject.Create;
    if send.reg.has_allergies <> '' then
      reg.AddPair('has_allergies', TJSONBool.Create(StrToBool(send.reg.has_allergies)))
    else
      reg.AddPair('has_allergies', TJSONNull.Create);
    if send.reg.allergies <> '' then
      reg.AddPair('allergies', TJSONBool.Create(StrToBool(send.reg.allergies)))
    else
      reg.AddPair('allergies', TJSONNull.Create);
    if send.reg.had_last_vaccine_reactions <> '' then
      reg.AddPair('had_last_vaccine_reactions', TJSONNumber.Create(send.reg.had_last_vaccine_reactions))
    else
      reg.AddPair('had_last_vaccine_reactions', TJSONNull.Create);
    if send.reg.last_vaccine_reactions <> '' then
      reg.AddPair('last_vaccine_reactions', TJSONNumber.Create(send.reg.last_vaccine_reactions))
    else
      reg.AddPair('last_vaccine_reactions', TJSONNull.Create);
    if send.reg.vaccination_information_flu <> '' then
      reg.AddPair('vaccination_information_flu', send.reg.vaccination_information_flu)
    else
      reg.AddPair('vaccination_information_flu', TJSONNull.Create);
    if send.reg.information_flu_id <> '' then
      reg.AddPair('information_flu_id', send.reg.information_flu_id)
    else
      reg.AddPair('information_flu_id', TJSONNull.Create);
    if send.reg.information_flu_text <> '' then
      reg.AddPair('information_flu_text', send.reg.information_flu_text)
    else
      reg.AddPair('information_flu_text', TJSONNull.Create);
    if send.reg.vaccination_information_air <> '' then
      reg.AddPair('vaccination_information_air', send.reg.vaccination_information_air)
    else
      reg.AddPair('vaccination_information_air', TJSONNull.Create);
    if send.reg.vaccine <> '' then
      reg.AddPair('vaccine', TJSONNumber.Create(send.reg.vaccine))
    else
      reg.AddPair('vaccine', TJSONNull.Create);
    if send.reg.has_pathology_bronch <> '' then
      reg.AddPair('has_pathology_bronch', send.reg.has_pathology_bronch)
    else
      reg.AddPair('has_pathology_bronch', TJSONNull.Create);
    if Length(send.reg.pathology_bronch) > 0 then
    begin
      pathology_bronchArray := TJSONArray.Create;
      for I := 0 to Length(send.reg.pathology_bronch)-1 do
        pathology_bronchArray.Add(send.reg.pathology_bronch[i]);
      reg.AddPair('pathology_bronch', pathology_bronchArray);
    end else
    begin
      pathology_bronchArray := TJSONArray.Create;
      reg.AddPair('pathology_bronch', pathology_bronchArray);
    end;
    if send.reg.has_pathology_cardio <> '' then
      reg.AddPair('has_pathology_cardio', send.reg.has_pathology_cardio)
    else
      reg.AddPair('has_pathology_cardio', TJSONNull.Create);
    if Length(send.reg.pathology_cardio) > 0 then
    begin
      pathology_cardioArray := TJSONArray.Create;
      for I := 0 to Length(send.reg.pathology_cardio)-1 do
        pathology_cardioArray.Add(send.reg.pathology_cardio[i]);
      reg.AddPair('pathology_cardio', pathology_cardioArray);
    end else
    begin
      pathology_cardioArray := TJSONArray.Create;
      reg.AddPair('pathology_cardio', pathology_cardioArray);
    end;
    if send.reg.has_pathology_endo <> '' then
      reg.AddPair('has_pathology_endo', send.reg.has_pathology_endo)
    else
      reg.AddPair('has_pathology_endo', TJSONNull.Create);
    if Length(send.reg.pathology_endo) > 0 then
    begin
      pathology_endoArray := TJSONArray.Create;
      for I := 0 to Length(send.reg.pathology_endo)-1 do
        pathology_endoArray.Add(send.reg.pathology_endo[i]);
      reg.AddPair('pathology_endo', pathology_endoArray);
    end else
    begin
      pathology_endoArray := TJSONArray.Create;
      reg.AddPair('pathology_endo', pathology_endoArray);
    end;
    if send.reg.has_pathology_onko <> '' then
      reg.AddPair('has_pathology_onko', send.reg.has_pathology_onko)
    else
      reg.AddPair('has_pathology_onko', TJSONNull.Create);
    if Length(send.reg.pathology_onko) > 0 then
    begin
      pathology_onkoArray := TJSONArray.Create;
      for I := 0 to Length(send.reg.pathology_onko)-1 do
        pathology_onkoArray.Add(send.reg.pathology_onko[i]);
      reg.AddPair('pathology_onko', pathology_onkoArray);
    end else
    begin
      pathology_onkoArray := TJSONArray.Create;
      reg.AddPair('pathology_onko', pathology_onkoArray);
    end;
    if send.reg.has_pathology_hiv <> '' then
      reg.AddPair('has_pathology_hiv', send.reg.has_pathology_hiv)
    else
      reg.AddPair('has_pathology_hiv', TJSONNull.Create);
    if Length(send.reg.pathology_hiv) > 0 then
    begin
      pathology_hivArray := TJSONArray.Create;
      for I := 0 to Length(send.reg.pathology_hiv)-1 do
        pathology_hivArray.Add(send.reg.pathology_hiv[i]);
      reg.AddPair('pathology_hiv', pathology_hivArray);
    end else
    begin
      pathology_hivArray := TJSONArray.Create;
      reg.AddPair('pathology_hiv', pathology_hivArray);
    end;
    if send.reg.has_pathology_tuber <> '' then
      reg.AddPair('has_pathology_tuber', send.reg.has_pathology_tuber)
    else
      reg.AddPair('has_pathology_tuber', TJSONNull.Create);
    if Length(send.reg.pathology_tuber) > 0 then
    begin
      pathology_tuberArray := TJSONArray.Create;
      for I := 0 to Length(send.reg.pathology_tuber)-1 do
        pathology_tuberArray.Add(send.reg.pathology_tuber[i]);
      reg.AddPair('pathology_tuber', pathology_tuberArray);
    end else
    begin
      pathology_tuberArray := TJSONArray.Create;
      reg.AddPair('pathology_tuber', pathology_tuberArray);
    end;
    if send.reg.has_pathology_syphilis <> '' then
      reg.AddPair('has_pathology_syphilis', send.reg.has_pathology_syphilis)
    else
      reg.AddPair('has_pathology_syphilis', TJSONNull.Create);
    if Length(send.reg.pathology_syphilis) > 0 then
    begin
      pathology_syphilisArray := TJSONArray.Create;
      for I := 0 to Length(send.reg.pathology_syphilis)-1 do
        pathology_syphilisArray.Add(send.reg.pathology_syphilis[i]);
      reg.AddPair('pathology_syphilis', pathology_syphilisArray);
    end else
    begin
      pathology_syphilisArray := TJSONArray.Create;
      reg.AddPair('pathology_syphilis', pathology_syphilisArray);
    end;
    if send.reg.has_pathology_hepatitis <> '' then
      reg.AddPair('has_pathology_hepatitis', send.reg.has_pathology_hepatitis)
    else
      reg.AddPair('has_pathology_hepatitis', TJSONNull.Create);
    if Length(send.reg.pathology_hepatitis) > 0 then
    begin
      pathology_hepatitisArray := TJSONArray.Create;
      for I := 0 to Length(send.reg.pathology_hepatitis)-1 do
        pathology_hepatitisArray.Add(send.reg.pathology_hepatitis[i]);
      reg.AddPair('pathology_hepatitis', pathology_hepatitisArray);
    end else
    begin
      pathology_hepatitisArray := TJSONArray.Create;
      reg.AddPair('pathology_hepatitis', pathology_hepatitisArray);
    end;
    if send.reg.has_pathology_other <> '' then
      reg.AddPair('has_pathology_other', send.reg.has_pathology_other)
    else
      reg.AddPair('has_pathology_other', TJSONNull.Create);
    if Length(send.reg.pathology_other) > 0 then
    begin
      pathology_otherArray := TJSONArray.Create;
      for I := 0 to Length(send.reg.pathology_other)-1 do
        pathology_otherArray.Add(send.reg.pathology_other[i]);
      reg.AddPair('pathology_other', pathology_otherArray);
    end else
    begin
      pathology_otherArray := TJSONArray.Create;
      reg.AddPair('pathology_other', pathology_otherArray);
    end;
    if send.reg.risk_group <> '' then
      reg.AddPair('risk_group', send.reg.risk_group)
    else
      reg.AddPair('risk_group', TJSONNull.Create);
    if Length(send.reg.sub_researches) > 0 then
    begin
      sub_researchesArray := TJSONArray.Create;
      for I := 0 to Length(send.reg.sub_researches)-1 do
      begin
        sub_researches:= TJSONObject.Create;
        if send.reg.sub_researches[i].exam_result <> '' then
          sub_researches.AddPair('exam_result', TJSONBool.Create(StrToBool(send.reg.sub_researches[i].exam_result)))
        else
          sub_researches.AddPair('exam_result', TJSONNull.Create);
        if send.reg.sub_researches[i].exam_date <> '' then
          sub_researches.AddPair('exam_date', FormatDateToService(StrToDateTime(send.reg.sub_researches[i].exam_date, FormatSettings)))
        else
          sub_researches.AddPair('exam_result', TJSONNull.Create);
        sub_researchesArray.AddElement(sub_researches);
      end;
      reg.AddPair('sub_researches', sub_researchesArray);
    end else
    begin
      sub_researchesArray := TJSONArray.Create;
      reg.AddPair('sub_researches', sub_researchesArray);
    end;
    if Length(send.reg.sub_stages) > 0 then
    begin
      sub_stagesArray := TJSONArray.Create;
      for I := 0 to Length(send.reg.sub_stages)-1 do
      begin
        sub_stages:= TJSONObject.Create;
        if send.reg.sub_stages[i].stage_number <> '' then
          sub_stages.AddPair('stage_number', TJSONNumber.Create(send.reg.sub_stages[i].stage_number))
        else
          sub_stages.AddPair('stage_number', TJSONNull.Create);
        if send.reg.sub_stages[i].gtin <> '' then
          sub_stages.AddPair('gtin', send.reg.sub_stages[i].gtin)
        else
          sub_stages.AddPair('gtin', TJSONNull.Create);
        if send.reg.sub_stages[i].serial_number <> '' then
          sub_stages.AddPair('serial_number', send.reg.sub_stages[i].serial_number)
        else
          sub_stages.AddPair('serial_number', TJSONNull.Create);
        if send.reg.sub_stages[i].batch_series <> '' then
          sub_stages.AddPair('batch_series', send.reg.sub_stages[i].batch_series)
        else
          sub_stages.AddPair('batch_series', TJSONNull.Create);
        if send.reg.sub_stages[i].has_reaction <> '' then
          sub_stages.AddPair('has_reaction', TJSONBool.Create(StrToBool(send.reg.sub_stages[i].has_reaction)))
        else
          sub_stages.AddPair('has_reaction', TJSONNull.Create);
        if send.reg.sub_stages[i].reaction <> '' then
          sub_stages.AddPair('reaction', TJSONNumber.Create(send.reg.sub_stages[i].reaction))
        else
          sub_stages.AddPair('reaction', TJSONNull.Create);
        if send.reg.sub_stages[i].reaction_type <> '' then
          sub_stages.AddPair('reaction_type', TJSONNumber.Create(send.reg.sub_stages[i].reaction_type))
        else
          sub_stages.AddPair('reaction_type', TJSONNull.Create);
        if Length(send.reg.sub_stages[i].sub_exams) > 0 then
        begin
          sub_examsArray := TJSONArray.Create;
          for j := 0 to Length(send.reg.sub_stages[i].sub_exams)-1 do
          begin
            //обязательные атрибуты
             Dopusk := send.reg.sub_stages[i].sub_exams[j].admission;
             if Dopusk = '' then
               Continue;
             if send.reg.sub_stages[i].sub_exams[j].script_vaccination = '' then
               Continue;
             if send.reg.sub_stages[i].sub_exams[j].exam_date = '' then
               Continue;
            sub_exams := TJSONObject.Create;
            sub_exams.AddPair('admission', TJSONNumber.Create(Dopusk));
            sub_exams.AddPair('script_vaccination', TJSONNumber.Create(send.reg.sub_stages[i].sub_exams[j].script_vaccination));
            sub_exams.AddPair('exam_date', FormatDateToService(StrToDate(send.reg.sub_stages[i].sub_exams[j].exam_date, FormatSettings)));

            if send.reg.sub_stages[i].sub_exams[j].mo <> '' then
              sub_exams.AddPair('mo', send.reg.sub_stages[i].sub_exams[j].mo)
            else
              sub_exams.AddPair('mo', TJSONNull.Create);
            if send.reg.sub_stages[i].sub_exams[j].department <> '' then
              sub_exams.AddPair('department', send.reg.sub_stages[i].sub_exams[j].department)
            else
              sub_exams.AddPair('department', TJSONNull.Create);
            if send.reg.sub_stages[i].sub_exams[j].medical_worker <> '' then
              sub_exams.AddPair('medical_worker', send.reg.sub_stages[i].sub_exams[j].medical_worker)
            else
              sub_exams.AddPair('medical_worker', TJSONNull.Create);
            if send.reg.sub_stages[i].sub_exams[j].medical_worker_snils <> '' then
              sub_exams.AddPair('medical_worker_snils', send.reg.sub_stages[i].sub_exams[j].medical_worker_snils)
            else
              sub_exams.AddPair('medical_worker_snils', TJSONNull.Create);
            if send.reg.sub_stages[i].sub_exams[j].temperature <> '' then
              sub_exams.AddPair('temperature', TJSONNumber.Create(send.reg.sub_stages[i].sub_exams[j].temperature))
            else
              sub_exams.AddPair('temperature', TJSONNull.Create);
            if send.reg.sub_stages[i].sub_exams[j].respiratory_rate <> '' then
              sub_exams.AddPair('respiratory_rate', TJSONNumber.Create(send.reg.sub_stages[i].sub_exams[j].respiratory_rate))
            else
              sub_exams.AddPair('respiratory_rate', TJSONNull.Create);
            if send.reg.sub_stages[i].sub_exams[j].heart_rate <> '' then
              sub_exams.AddPair('heart_rate', TJSONNumber.Create(send.reg.sub_stages[i].sub_exams[j].heart_rate))
            else
              sub_exams.AddPair('heart_rate', TJSONNull.Create);
            if send.reg.sub_stages[i].sub_exams[j].general_state <> '' then
              sub_exams.AddPair('general_state', send.reg.sub_stages[i].sub_exams[j].general_state)
            else
              sub_exams.AddPair('general_state', TJSONNull.Create);
            if send.reg.sub_stages[i].sub_exams[j].had_covid <> '' then
              sub_exams.AddPair('had_covid', TJSONBool.Create(StrToBool(send.reg.sub_stages[i].sub_exams[j].had_covid)))
            else
              sub_exams.AddPair('had_covid', TJSONNull.Create);
            if send.reg.sub_stages[i].sub_exams[j].contact_patient <> '' then
              sub_exams.AddPair('contact_patient', TJSONBool.Create(StrToBool(send.reg.sub_stages[i].sub_exams[j].contact_patient)))
            else
              sub_exams.AddPair('contact_patient', TJSONNull.Create);
            if send.reg.sub_stages[i].sub_exams[j].pregnancy <> '' then
              sub_exams.AddPair('pregnancy', TJSONBool.Create(StrToBool(send.reg.sub_stages[i].sub_exams[j].pregnancy)))
            else
              if send.reg.sub_stages[i].sub_exams[j].female then
               sub_exams.AddPair('pregnancy', TJSONNull.Create);
            if send.reg.sub_stages[i].sub_exams[j].pregnancy_period <> '' then
              sub_exams.AddPair('pregnancy_period', TJSONBool.Create(StrToBool(send.reg.sub_stages[i].sub_exams[j].pregnancy_period)))
            else
              if send.reg.sub_stages[i].sub_exams[j].female then
               sub_exams.AddPair('pregnancy_period', TJSONNull.Create);
            sub_examsArray.AddElement(sub_exams);
            //данные при МЕДОТВОДЕ
            if (Dopusk.ToInteger > 1) then
            begin
                if (send.reg.sub_stages[i].sub_exams[j].contraindication = '') then
                  sub_exams.AddPair('contraindication', TJSONNull.Create)
                else
                  sub_exams.AddPair('contraindication', TJSONNumber.Create(send.reg.sub_stages[i].sub_exams[j].contraindication));
                if (send.reg.sub_stages[i].sub_exams[j].exacerbation = '') then
                  sub_exams.AddPair('exacerbation', TJSONNull.Create)
                else
                  sub_exams.AddPair('exacerbation', TJSONBool.Create(StrToBool(send.reg.sub_stages[i].sub_exams[j].exacerbation)));
                if (send.reg.sub_stages[i].sub_exams[j].decompensation = '') then
                  sub_exams.AddPair('decompensation', TJSONNull.Create)
                else
                  sub_exams.AddPair('decompensation', TJSONBool.Create(StrToBool(send.reg.sub_stages[i].sub_exams[j].decompensation)));
                if (send.reg.sub_stages[i].sub_exams[j].complication = '') then
                  sub_exams.AddPair('complication', TJSONNull.Create)
                else
                  sub_exams.AddPair('complication', TJSONBool.Create(StrToBool(send.reg.sub_stages[i].sub_exams[j].complication)));
                if (send.reg.sub_stages[i].sub_exams[j].contraindication_mkb <> '') AND (send.reg.sub_stages[i].sub_exams[j].contraindication_mkb.ToInteger in [16,17]) then
                  sub_exams.AddPair('contraindication_mkb', TJSONNumber.Create(send.reg.sub_stages[i].sub_exams[j].contraindication_mkb));
                if (send.reg.sub_stages[i].sub_exams[j].admission_start_date <> '') then
                  sub_exams.AddPair('admission_start_date', FormatDateToService(StrToDate(send.reg.sub_stages[i].sub_exams[j].admission_start_date, FormatSettings)));
                if (send.reg.sub_stages[i].sub_exams[j].admission_end_date <> '') then
                  sub_exams.AddPair('admission_end_date', FormatDateToService(StrToDate(send.reg.sub_stages[i].sub_exams[j].admission_end_date, FormatSettings)));
                if (send.reg.sub_stages[i].sub_exams[j].medical_commission_date <> '') then
                  sub_exams.AddPair('medical_commission_date', FormatDateToService(StrToDate(send.reg.sub_stages[i].sub_exams[j].medical_commission_date, FormatSettings)));
                if (send.reg.sub_stages[i].sub_exams[j].medical_commission_number <> '') then
                  sub_exams.AddPair('medical_commission_number', send.reg.sub_stages[i].sub_exams[j].medical_commission_number);
            end;
          end;
          sub_stages.AddPair('sub_exams', sub_examsArray);
        end else
        begin
          sub_examsArray := TJSONArray.Create;
          sub_stages.AddPair('sub_exams', sub_examsArray);
        end;
        sub_stagesArray.AddElement(sub_stages);
      end;
      reg.AddPair('sub_stages', sub_stagesArray);
    end else
    begin
      sub_stagesArray := TJSONArray.Create;
      reg.AddPair('sub_stages', sub_stagesArray);
    end;

    Bundle.AddPair('reg', reg);
  end;
  if send.person <> Nil then
  begin
    person := TJSONObject.Create;
    if send.person.snils <> '' then
      person.AddPair('snils',send.person.snils)
    else
      person.AddPair('snils',TJSONNull.Create);
    if send.person.lastname <> '' then
      person.AddPair('lastname',send.person.lastname)
    else
      person.AddPair('lastname',TJSONNull.Create);
    if send.person.firstname <> '' then
      person.AddPair('firstname',send.person.firstname)
    else
      person.AddPair('firstname',TJSONNull.Create);
    if send.person.patronymic <> '' then
      person.AddPair('patronymic',send.person.patronymic)
    else
      person.AddPair('patronymic',TJSONNull.Create);
    if send.person.gender <> '' then
      person.AddPair('gender',TJSONNumber.Create(send.person.gender))
    else
      person.AddPair('gender',TJSONNull.Create);
    if send.person.birth_date <> '' then
      person.AddPair('birth_date',FormatDateToService(StrToDate(send.person.birth_date, FormatSettings)))
    else
      person.AddPair('birth_date',TJSONNull.Create);
    if send.person.citizenship_country <> '' then
      person.AddPair('citizenship_country',TJSONNumber.Create(send.person.citizenship_country))
    else
      person.AddPair('citizenship_country',TJSONNull.Create);
    if send.person.citizenship <> '' then
      person.AddPair('citizenship',TJSONNumber.Create(send.person.citizenship))
    else
      person.AddPair('citizenship',TJSONNull.Create);
    if Length(send.person.sub_persdocs) > 0 then
    begin
      sub_persdocsArray := TJSONArray.Create;
      for I := 0 to Length(send.person.sub_persdocs)-1 do
      begin
        sub_persdocs := TJSONObject.Create;
        if send.person.sub_persdocs[i].persdoc_type <> '' then
          sub_persdocs.AddPair('persdoc_type', TJSONNumber.Create(send.person.sub_persdocs[i].persdoc_type))
        else
          sub_persdocs.AddPair('persdoc_type', TJSONNull.Create);
        if send.person.sub_persdocs[i].pd_series <> '' then
          sub_persdocs.AddPair('pd_series', send.person.sub_persdocs[i].pd_series)
        else
          sub_persdocs.AddPair('pd_series', TJSONNull.Create);
        if send.person.sub_persdocs[i].pd_number <> '' then
          sub_persdocs.AddPair('pd_number', send.person.sub_persdocs[i].pd_number)
        else
          sub_persdocs.AddPair('pd_number', TJSONNull.Create);
        if send.person.sub_persdocs[i].issued_by <> '' then
          sub_persdocs.AddPair('issued_by', send.person.sub_persdocs[i].issued_by)
        else
          sub_persdocs.AddPair('issued_by', TJSONNull.Create);
        if send.person.sub_persdocs[i].date_begin <> '' then
          sub_persdocs.AddPair('date_begin', FormatDateToService(StrToDate(send.person.sub_persdocs[i].date_begin, FormatSettings)))
        else
          sub_persdocs.AddPair('date_begin', TJSONNull.Create);
        sub_persdocsArray.AddElement(sub_persdocs);
      end;
      person.AddPair('sub_persdocs', sub_persdocsArray);
    end else
    begin
      sub_persdocsArray := TJSONArray.Create;
      person.AddPair('sub_persdocs', sub_persdocsArray);
    end;
    if Length(send.person.sub_contacts) > 0 then
    begin
      sub_contactsArray := TJSONArray.Create;
      for I := 0 to Length(send.person.sub_contacts)-1 do
      begin
        sub_contacts := TJSONObject.Create;
        if send.person.sub_contacts[i].contact_type <> '' then
          sub_contacts.AddPair('contact_type', send.person.sub_contacts[i].contact_type)
        else
          sub_contacts.AddPair('contact_type', TJSONNull.Create);
        if send.person.sub_contacts[i].contact <> '' then
          sub_contacts.AddPair('contact', send.person.sub_contacts[i].contact)
        else
          sub_contacts.AddPair('contact', TJSONNull.Create);
        sub_contactsArray.AddElement(sub_contacts);
      end;
      person.AddPair('sub_contacts', sub_contactsArray);
    end else
    begin
      sub_contactsArray := TJSONArray.Create;
      sub_contactsArray.AddElement(sub_contacts);
    end;
    if Length(send.person.sub_addr) > 0 then
    begin
      sub_addrArray := TJSONArray.Create;
      for I := 0 to Length(send.person.sub_addr)-1 do
      begin
        sub_addr := TJSONObject.Create;
        if send.person.sub_addr[i].addr_type <> '' then
          sub_contacts.AddPair('addr_type', send.person.sub_addr[i].addr_type);
        if send.person.sub_addr[i].address <> Nil then
        begin
          address := TJSONObject.Create;
          if send.person.sub_addr[i].address.region <> '' then
            address.AddPair('region', TJSONNumber.Create(send.person.sub_addr[i].address.region))
          else
            address.AddPair('region', TJSONNull.Create);
          if send.person.sub_addr[i].address.area_guid <> '' then
            address.AddPair('area_guid', send.person.sub_addr[i].address.area_guid)
          else
            address.AddPair('area_guid', TJSONNull.Create);
          if send.person.sub_addr[i].address.street_guid <> '' then
            address.AddPair('street_guid', send.person.sub_addr[i].address.street_guid)
          else
            address.AddPair('street_guid', TJSONNull.Create);
          if send.person.sub_addr[i].address.house_guid <> '' then
            address.AddPair('house_guid', send.person.sub_addr[i].address.house_guid)
          else
            address.AddPair('house_guid', TJSONNull.Create);
          if send.person.sub_addr[i].address.area_name <> '' then
            address.AddPair('area_name', send.person.sub_addr[i].address.area_name)
          else
            address.AddPair('area_name', TJSONNull.Create);
          if send.person.sub_addr[i].address.street_name <> '' then
            address.AddPair('street_name', send.person.sub_addr[i].address.street_name)
          else
            address.AddPair('street_name', TJSONNull.Create);
          if send.person.sub_addr[i].address.house <> '' then
            address.AddPair('house', send.person.sub_addr[i].address.house)
          else
            address.AddPair('house', TJSONNull.Create);
          if send.person.sub_addr[i].address.flat <> '' then
            address.AddPair('flat', send.person.sub_addr[i].address.flat)
          else
            address.AddPair('flat', TJSONNull.Create);
          sub_contacts.AddPair('address', address);
        end else
        begin
          address := TJSONObject.Create;
          sub_contacts.AddPair('address', address)
        end;
        sub_addrArray.AddElement(sub_addr);
      end;
      person.AddPair('sub_addr', sub_addrArray);
    end else
    begin
      sub_addrArray := TJSONArray.Create;
      person.AddPair('sub_addr', sub_addrArray);
    end;
    Bundle.AddPair('person', person);
  end;
  RESTRequest.AddBody(Bundle.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
  try
    RESTRequest.Execute;
  except
  end;

  Result:=TPostRecordOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;
  if RESTResponse.JSONValue<>Nil then
  begin
    if ((RESTResponse.JSONValue) as TJSONObject).GetValue('reg_id')<>Nil then
      Result.reg_id := ((RESTResponse.JSONValue) as TJSONObject).GetValue('reg_id').Value;
    if ((RESTResponse.JSONValue) as TJSONObject).GetValue('person_id')<>Nil then
      Result.person_id := ((RESTResponse.JSONValue) as TJSONObject).GetValue('person_id').Value;
  end;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

procedure TRosVacCOVID.SaveToFile(JSON: TJSONObject);
var
  Stream: TStringStream;
begin
  Stream := TStringStream.Create(JSON.ToJSON, TEncoding.UTF8);
  try
    Stream.SaveToFile('D:\Test.json');
  finally
    FreeAndNil(Stream);
  end;
end;

procedure TRosVacCOVID.SaveToF(AuthStr: string; sFileName: string);
var
  Stream: TStringStream;
begin
  Stream := TStringStream.Create(AuthStr, TEncoding.UTF8);
  try
    Stream.SaveToFile(sFileName);
  finally
    FreeAndNil(Stream);
  end;
end;


function TRosVacCOVID.PostRegComplication(reg_id: string; send: TPostRegComplicationIn): TPostRegComplicationOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;

  i,j: Integer;

  Bundle, sub_symps: TJSONObject;
  sub_sympsArray: TJSONArray;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('record/'+reg_id+'/complication',TRestRequestMethod.rmPOST, RESTClient, RESTResponse);

  //Заполнение запроса
  Bundle:=TJSONObject.Create;
  if send <> Nil then
  begin
    if send.exam_date <> '' then
      Bundle.AddPair('exam_date', FormatDateToService(StrToDate(send.exam_date, FormatSettings)))
    else
      Bundle.AddPair('exam_date', TJSONNull.Create);
    if send.mo <> '' then
      Bundle.AddPair('mo', send.mo)
    else
      Bundle.AddPair('mo', TJSONNull.Create);
    if send.department <> '' then
      Bundle.AddPair('department', send.department)
    else
      Bundle.AddPair('department', TJSONNull.Create);
    if send.medical_worker <> '' then
      Bundle.AddPair('medical_worker', send.medical_worker)
    else
      Bundle.AddPair('medical_worker', TJSONNull.Create);
    if send.medical_worker_snils <> '' then
      Bundle.AddPair('medical_worker_snils', send.medical_worker_snils)
    else
      Bundle.AddPair('medical_worker_snils', TJSONNull.Create);
    if send.other_symp <> '' then
      Bundle.AddPair('other_symp', send.other_symp)
    else
      Bundle.AddPair('other_symp', TJSONNull.Create);
    if Length(send.sub_symps) > 0 then
    begin
      sub_sympsArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_symps)-1 do
      begin
        sub_symps := TJSONObject.Create;
        if send.sub_symps[i].symp_id <> '' then
          sub_symps.AddPair('symp_id', TJSONNumber.Create(send.sub_symps[i].symp_id))
        else
          sub_symps.AddPair('symp_id', TJSONNull.Create);
        if send.sub_symps[i].description <> '' then
          sub_symps.AddPair('description', send.sub_symps[i].description)
        else
          sub_symps.AddPair('description', TJSONNull.Create);
        sub_sympsArray.AddElement(sub_symps);
      end;
      Bundle.AddPair('sub_symps', sub_sympsArray);
    end else
    begin
      sub_sympsArray := TJSONArray.Create;
      Bundle.AddPair('sub_symps', sub_sympsArray);
    end;
  end;
  //
  RESTRequest.AddBody(Bundle.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
  try
    RESTRequest.Execute;
  except
  end;

  Result:=TPostRegComplicationOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

function TRosVacCOVID.PostRegDairy(reg_id: string; send: TPostRegDairyIn): TPostRegDairyOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;

  i,j: Integer;

  Bundle, sub_exams, sub_moves, sub_symp, sub_acts, sub_adds, sub_drugs, sub_diffs: TJSONObject;
  sub_examsArray, sub_movesArray, sub_actsArray, sub_addsArray, sub_drugsArray, sub_diffsArray: TJSONArray;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('record/'+reg_id+'/dairy',TRestRequestMethod.rmPOST, RESTClient, RESTResponse);

  //Заполнение запроса
  Bundle:=TJSONObject.Create;
  if send <> Nil then
  begin
    if send.diary_date <> '' then
      Bundle.AddPair('diary_date', FormatDateToService(StrToDate(send.diary_date, FormatSettings)))
    else
      Bundle.AddPair('diary_date', TJSONNull.Create);
    if send.pregnancy <> '' then
      Bundle.AddPair('pregnancy', TJSONBool.Create(StrToBool(send.pregnancy)))
    else
       Bundle.AddPair('pregnancy', TJSONNull.Create);
    if send.first_stage_contact <> '' then
      Bundle.AddPair('first_stage_contact', TJSONBool.Create(StrToBool(send.first_stage_contact)))
    else
      Bundle.AddPair('first_stage_contact', TJSONNull.Create);
    if send.first_stage_contact_date <> '' then
      Bundle.AddPair('first_stage_contact_date', FormatDateToService(StrToDate(send.first_stage_contact_date, FormatSettings)))
    else
      Bundle.AddPair('first_stage_contact_date', TJSONNull.Create);
    if send.second_stage_contact <> '' then
      Bundle.AddPair('second_stage_contact', TJSONBool.Create(StrToBool(send.second_stage_contact)))
    else
      Bundle.AddPair('second_stage_contact', TJSONNull.Create);
    if send.second_stage_contact_date <> '' then
      Bundle.AddPair('second_stage_contact_date', FormatDateToService(StrToDate(send.second_stage_contact_date, FormatSettings)))
    else
      Bundle.AddPair('second_stage_contact_date', TJSONNull.Create);
    if send.description <> '' then
      Bundle.AddPair('description', send.description)
    else
      Bundle.AddPair('description', TJSONNull.Create);
    if Length(send.sub_exams) > 0 then
    begin
      sub_examsArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_exams)-1 do
      begin
        sub_exams := TJSONObject.Create;
        if send.sub_exams[i].script_vaccination <> '' then
          sub_exams.AddPair('script_vaccination', TJSONNumber.Create(send.sub_exams[i].script_vaccination))
        else
          sub_exams.AddPair('script_vaccination', TJSONNull.Create);
        if send.sub_exams[i].exam_date <> '' then
          sub_exams.AddPair('exam_date', FormatDateToService(StrToDate(send.sub_exams[i].exam_date, FormatSettings)))
        else
          sub_exams.AddPair('exam_date', TJSONNull.Create);
        if send.sub_exams[i].mo <> '' then
          sub_exams.AddPair('mo', send.sub_exams[i].mo)
        else
          sub_exams.AddPair('mo', TJSONNull.Create);
        if send.sub_exams[i].department <> '' then
          sub_exams.AddPair('department', send.sub_exams[i].department)
        else
          sub_exams.AddPair('department', TJSONNull.Create);
        if send.sub_exams[i].medical_worker <> '' then
          sub_exams.AddPair('medical_worker', send.sub_exams[i].medical_worker)
        else
          sub_exams.AddPair('medical_worker', TJSONNull.Create);
        if send.sub_exams[i].medical_worker_snils <> '' then
          sub_exams.AddPair('medical_worker_snils', send.sub_exams[i].medical_worker_snils)
        else
          sub_exams.AddPair('medical_worker_snils', TJSONNull.Create);
        if send.sub_exams[i].temperature <> '' then
          sub_exams.AddPair('temperature', TJSONNumber.Create(send.sub_exams[i].temperature))
        else
          sub_exams.AddPair('temperature', TJSONNull.Create);
        if send.sub_exams[i].respiratory_rate <> '' then
          sub_exams.AddPair('respiratory_rate', TJSONNumber.Create(send.sub_exams[i].respiratory_rate))
        else
          sub_exams.AddPair('respiratory_rate', TJSONNull.Create);
        if send.sub_exams[i].heart_rate <> '' then
          sub_exams.AddPair('heart_rate', TJSONNumber.Create(send.sub_exams[i].heart_rate))
        else
          sub_exams.AddPair('heart_rate', TJSONNull.Create);
        if send.sub_exams[i].general_state <> '' then
          sub_exams.AddPair('general_state', send.sub_exams[i].general_state)
        else
          sub_exams.AddPair('general_state', TJSONNull.Create);
        if send.sub_exams[i].had_covid <> '' then
          sub_exams.AddPair('had_covid', TJSONBool.Create(StrToBool(send.sub_exams[i].had_covid)))
        else
          sub_exams.AddPair('had_covid', TJSONNull.Create);
        if send.sub_exams[i].contact_patient <> '' then
          sub_exams.AddPair('contact_patient', send.sub_exams[i].contact_patient)
        else
          sub_exams.AddPair('contact_patient', TJSONNull.Create);
        if send.sub_exams[i].admission <> '' then
          sub_exams.AddPair('admission', TJSONNumber.Create(send.sub_exams[i].admission))
        else
          sub_exams.AddPair('admission', TJSONNull.Create);
        if send.sub_exams[i].pregnancy <> '' then
          sub_exams.AddPair('pregnancy', FormatDateToService(StrToDate(send.sub_exams[i].pregnancy, FormatSettings)))
        else
            sub_exams.AddPair('pregnancy', TJSONNull.Create);
        if send.sub_exams[i].pregnancy_period <> '' then
          sub_exams.AddPair('pregnancy_period', TJSONNumber.Create(send.sub_exams[i].pregnancy_period))
        else
           sub_exams.AddPair('pregnancy_period', TJSONNull.Create);
        sub_examsArray.AddElement(sub_exams);
      end;
      Bundle.AddPair('sub_exams', sub_examsArray);
    end else
    begin
      sub_examsArray := TJSONArray.Create;
      Bundle.AddPair('sub_exams', sub_examsArray);
    end;
    if Length(send.sub_moves) > 0 then
    begin
      sub_movesArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_moves)-1 do
      begin
        sub_moves := TJSONObject.Create;
        if send.sub_moves[i].date_from <> '' then
          sub_moves.AddPair('date_from', FormatDateToService(StrToDate(send.sub_moves[i].date_from, FormatSettings)))
        else
          sub_moves.AddPair('date_from', TJSONNull.Create);
        if send.sub_moves[i].date_to <> '' then
          sub_moves.AddPair('date_to', FormatDateToService(StrToDate(send.sub_moves[i].date_to, FormatSettings)))
        else
          sub_moves.AddPair('date_to', TJSONNull.Create);
        if send.sub_moves[i].country <> '' then
          sub_moves.AddPair('country', TJSONNumber.Create(send.sub_moves[i].country))
        else
          sub_moves.AddPair('country', TJSONNull.Create);
        if send.sub_moves[i].city <> '' then
          sub_moves.AddPair('city', TJSONNumber.Create(send.sub_moves[i].city))
        else
          sub_moves.AddPair('city', TJSONNull.Create);
        sub_movesArray.AddElement(sub_moves);
      end;
      Bundle.AddPair('sub_moves', sub_movesArray);
    end else
    begin
      sub_movesArray := TJSONArray.Create;
      Bundle.AddPair('sub_moves', sub_movesArray);
    end;
    if send.sub_symp <> Nil then
    begin
      sub_symp := TJSONObject.Create;
      if send.sub_symp.symp_date_begin <> '' then
        sub_symp.AddPair('symp_date_begin', send.sub_symp.symp_date_begin);
      if send.sub_symp.symp_date_end <> '' then
        sub_symp.AddPair('symp_date_end', send.sub_symp.symp_date_end);
      if send.sub_symp.symp_diff <> '' then
        sub_symp.AddPair('symp_diff', send.sub_symp.symp_diff);
      if send.sub_symp.add_treatment <> '' then
        sub_symp.AddPair('add_treatment', send.sub_symp.add_treatment);
      if send.sub_symp.different_action <> '' then
        sub_symp.AddPair('different_action', send.sub_symp.different_action);
      if Length(send.sub_symp.sub_acts) > 0 then
      begin
        sub_actsArray := TJSONArray.Create;
        for I := 0 to Length(send.sub_symp.sub_acts)-1 do
        begin
          sub_acts := TJSONObject.Create;
          if send.sub_symp.sub_acts[i].act_id <> '' then
            sub_acts.AddPair('act_id', send.sub_symp.sub_acts[i].act_id);
          sub_actsArray.AddElement(sub_acts);
        end;
        sub_symp.AddPair('sub_acts', sub_actsArray);
      end else
      begin
        sub_actsArray := TJSONArray.Create;
        sub_symp.AddPair('sub_acts', sub_actsArray);
      end;
      if Length(send.sub_symp.sub_adds) > 0 then
      begin
        sub_addsArray := TJSONArray.Create;
        for I := 0 to Length(send.sub_symp.sub_adds)-1 do
        begin
          sub_adds := TJSONObject.Create;
          if send.sub_symp.sub_adds[i].symp_id <> '' then
            sub_adds.AddPair('symp_id', send.sub_symp.sub_adds[i].symp_id)
          else
            sub_adds.AddPair('symp_id', TJSONNull.Create);
          if send.sub_symp.sub_adds[i].description <> '' then
            sub_adds.AddPair('description', send.sub_symp.sub_adds[i].description)
          else
            sub_adds.AddPair('description', TJSONNull.Create);
          sub_addsArray.AddElement(sub_adds);
        end;
        sub_symp.AddPair('sub_adds', sub_addsArray);
      end else
      begin
        sub_addsArray := TJSONArray.Create;
        sub_symp.AddPair('sub_adds', sub_addsArray);
      end;
      if Length(send.sub_symp.sub_drugs) > 0 then
      begin
        sub_drugsArray := TJSONArray.Create;
        for I := 0 to Length(send.sub_symp.sub_drugs)-1 do
        begin
          sub_drugs := TJSONObject.Create;
          if send.sub_symp.sub_drugs[i].drug_name <> '' then
            sub_drugs.AddPair('drug_name', send.sub_symp.sub_drugs[i].drug_name)
          else
            sub_drugs.AddPair('drug_name', TJSONNull.Create);
          if send.sub_symp.sub_drugs[i].dosage <> '' then
            sub_drugs.AddPair('dosage', send.sub_symp.sub_drugs[i].dosage)
          else
            sub_drugs.AddPair('dosage', TJSONNull.Create);
          if send.sub_symp.sub_drugs[i].duration <> '' then
            sub_drugs.AddPair('duration', send.sub_symp.sub_drugs[i].duration)
          else
            sub_drugs.AddPair('duration', TJSONNull.Create);
          sub_drugsArray.AddElement(sub_drugs);
        end;
        sub_symp.AddPair('sub_drugs', sub_drugsArray);
      end else
      begin
        sub_drugsArray := TJSONArray.Create;
        sub_symp.AddPair('sub_drugs', sub_drugsArray);
      end;
      if Length(send.sub_symp.sub_diffs) > 0 then
      begin
        sub_diffsArray := TJSONArray.Create;
        for I := 0 to Length(send.sub_symp.sub_diffs)-1 do
        begin
          sub_diffs := TJSONObject.Create;
          if send.sub_symp.sub_diffs[i].disease_name <> '' then
            sub_diffs.AddPair('disease_name', send.sub_symp.sub_diffs[i].disease_name)
          else
            sub_diffs.AddPair('disease_name', TJSONNull.Create);
          if send.sub_symp.sub_diffs[i].date_begin <> '' then
            sub_diffs.AddPair('date_begin', FormatDateToService(StrToDate(send.sub_symp.sub_diffs[i].date_begin, FormatSettings)))
          else
            sub_diffs.AddPair('date_begin', TJSONNull.Create);
          if send.sub_symp.sub_diffs[i].date_end <> '' then
            sub_diffs.AddPair('date_end', FormatDateToService(StrToDate(send.sub_symp.sub_diffs[i].date_end, FormatSettings)))
          else
            sub_diffs.AddPair('date_end', TJSONNull.Create);
          sub_diffsArray.AddElement(sub_diffs);
        end;
        sub_symp.AddPair('sub_diffs', sub_diffsArray);
      end else
      begin
        sub_diffsArray := TJSONArray.Create;
        sub_symp.AddPair('sub_diffs', sub_diffsArray);
      end;
      Bundle.AddPair('sub_symp', sub_symp);
    end;
  end;
  //
  RESTRequest.AddBody(Bundle.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
  try
    RESTRequest.Execute;
  except
  end;

  Result:=TPostRegDairyOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

function TRosVacCOVID.PostRegPregnancy(reg_id: string; send: TPostRegPregnancyIn): TPostRegPregnancyOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;

  i,j: Integer;

  Bundle, sub_exam, sub_child: TJSONObject;
  sub_examArray, sub_childArray, anomaliesArray: TJSONArray;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('record/'+reg_id+'/pregnancy',TRestRequestMethod.rmPOST, RESTClient, RESTResponse);

  //Заполнение запроса
  Bundle:=TJSONObject.Create;
  if send <> Nil then
  begin
    if send.estimated_date <> '' then
      Bundle.AddPair('estimated_date', FormatDateToService(StrToDate(send.estimated_date, FormatSettings)))
    else
      Bundle.AddPair('estimated_date', TJSONNull.Create);
    if send.pregnancy_order <> '' then
      Bundle.AddPair('pregnancy_order', TJSONNumber.Create(send.pregnancy_order))
    else
      Bundle.AddPair('pregnancy_order', TJSONNull.Create);
    if send.childbirth_order <> '' then
      Bundle.AddPair('childbirth_order', TJSONNumber.Create(send.childbirth_order))
    else
      Bundle.AddPair('childbirth_order', TJSONNull.Create);
    if send.pregnancy_outcome <> '' then
      Bundle.AddPair('pregnancy_outcome',TJSONNumber.Create(send.pregnancy_outcome))
    else
      Bundle.AddPair('pregnancy_outcome', TJSONNull.Create);
    if send.pregnancy_outcome_date <> '' then
      Bundle.AddPair('pregnancy_outcome_date', FormatDateToService(StrToDate(send.pregnancy_outcome_date, FormatSettings)))
    else
      Bundle.AddPair('pregnancy_outcome_date', TJSONNull.Create);
    if send.mo <> '' then
      Bundle.AddPair('mo',send.mo)
    else
      Bundle.AddPair('mo', TJSONNull.Create);
    if send.childbirth_term <> '' then
      Bundle.AddPair('childbirth_term', TJSONNumber.Create(send.childbirth_term))
    else
      Bundle.AddPair('childbirth_term', TJSONNull.Create);
    if send.childbirth_features <> '' then
      Bundle.AddPair('childbirth_features',send.childbirth_features)
    else
      Bundle.AddPair('childbirth_features', TJSONNull.Create);
    if send.children_amount <> '' then
      Bundle.AddPair('children_amount', TJSONNumber.Create(send.children_amount))
    else
      Bundle.AddPair('children_amount', TJSONNull.Create);
    if Length(send.sub_exam) > 0 then
    begin
      sub_examArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_exam)-1 do
      begin
        sub_exam := TJSONObject.Create;
        if send.sub_exam[i].exam_date <> '' then
          sub_exam.AddPair('exam_date', FormatDateToService(StrToDate(send.sub_exam[i].exam_date, FormatSettings)))
        else
          sub_exam.AddPair('exam_date', TJSONNull.Create);
        if send.sub_exam[i].mo <> '' then
          sub_exam.AddPair('mo', send.sub_exam[i].mo)
        else
          sub_exam.AddPair('mo', TJSONNull.Create);
        if send.sub_exam[i].pregnancy_term <> '' then
          sub_exam.AddPair('pregnancy_term', TJSONNumber.Create(send.sub_exam[i].pregnancy_term))
        else
          sub_exam.AddPair('pregnancy_term', TJSONNull.Create);
        if send.sub_exam[i].pregnancy_features <> '' then
          sub_exam.AddPair('pregnancy_features', send.sub_exam[i].pregnancy_features)
        else
          sub_exam.AddPair('pregnancy_features', TJSONNull.Create);
        sub_examArray.AddElement(sub_exam);
      end;
      Bundle.AddPair('sub_exam',sub_examArray);
    end else
    begin
      sub_examArray := TJSONArray.Create;
      Bundle.AddPair('sub_exam',sub_examArray);
    end;
    if Length(send.sub_child) > 0 then
    begin
      sub_childArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_child)-1 do
      begin
        sub_child := TJSONObject.Create;
        if send.sub_child[i].gender <> '' then
          sub_child.AddPair('gender', TJSONNumber.Create(send.sub_child[i].gender))
        else
          sub_child.AddPair('gender', TJSONNull.Create);
        if send.sub_child[i].weight <> '' then
          sub_child.AddPair('weight', TJSONNumber.Create(send.sub_child[i].weight))
        else
          sub_child.AddPair('weight', TJSONNull.Create);
        if send.sub_child[i].height <> '' then
          sub_child.AddPair('height', TJSONNumber.Create(send.sub_child[i].height))
        else
          sub_child.AddPair('height', TJSONNull.Create);
        if send.sub_child[i].apgar_scale <> '' then
          sub_child.AddPair('apgar_scale', TJSONNumber.Create(send.sub_child[i].apgar_scale))
        else
          sub_child.AddPair('apgar_scale', TJSONNull.Create);
        if send.sub_child[i].has_anomalies <> '' then
          sub_child.AddPair('has_anomalies', TJSONBool.Create(StrToBool(send.sub_child[i].has_anomalies)))
        else
          sub_child.AddPair('has_anomalies', TJSONNull.Create);
        if Length(send.sub_child[i].anomalies) > 0 then
        begin
          anomaliesArray := TJSONArray.Create;
          for j := 0 to Length(send.sub_child[i].anomalies)-1 do
            anomaliesArray.Add(send.sub_child[i].anomalies[j]);
          sub_child.AddPair('anomalies', anomaliesArray);
        end else
        begin
          anomaliesArray := TJSONArray.Create;
          sub_child.AddPair('anomalies', anomaliesArray);
        end;
        sub_childArray.AddElement(sub_child);
      end;
      Bundle.AddPair('sub_child',sub_childArray);
    end else
    begin
      sub_childArray := TJSONArray.Create;
      Bundle.AddPair('sub_child',sub_childArray);
    end;
  end;
  //
  RESTRequest.AddBody(Bundle.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
  try
    RESTRequest.Execute;
  except
  end;

  Result:=TPostRegPregnancyOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

function TRosVacCOVID.PutPerson(reg_id: string; send: TPutPersonIn): TPutPersonOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;

  i,j: Integer;

  Bundle, sub_persdocs, sub_contacts, sub_addr, address, sub_insurance: TJSONObject;
  sub_persdocsArray, sub_contactsArray, sub_addrArray, sub_insuranceArray: TJSONArray;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('person/'+reg_id,TRestRequestMethod.rmPUT, RESTClient, RESTResponse);

  //Заполнение запроса
  Bundle:=TJSONObject.Create;
  if send <> Nil then
  begin
    if send.snils <> '' then
      Bundle.AddPair('snils', send.snils)
    else
      Bundle.AddPair('snils', TJSONNull.Create);
    if send.lastname <> '' then
      Bundle.AddPair('lastname', send.lastname)
    else
      Bundle.AddPair('lastname', TJSONNull.Create);
    if send.firstname <> '' then
      Bundle.AddPair('firstname', send.firstname)
    else
      Bundle.AddPair('firstname', TJSONNull.Create);
    if send.patronymic <> '' then
      Bundle.AddPair('patronymic', send.patronymic)
    else
      Bundle.AddPair('patronymic', TJSONNull.Create);
    if send.gender <> '' then
      Bundle.AddPair('gender', TJSONNumber.Create(send.gender))
    else
      Bundle.AddPair('gender', TJSONNull.Create);
    if send.birth_date <> '' then
      Bundle.AddPair('birth_date', FormatDateToService(StrToDate(send.birth_date, FormatSettings)))
    else
      Bundle.AddPair('birth_date', TJSONNull.Create);
    if send.citizenship_country <> '' then
      Bundle.AddPair('citizenship_country', TJSONNumber.Create(send.citizenship_country))
    else
      Bundle.AddPair('citizenship_country', TJSONNull.Create);
    if send.citizenship <> '' then
      Bundle.AddPair('citizenship', TJSONNumber.Create(send.citizenship))
    else
      Bundle.AddPair('citizenship', TJSONNull.Create);
    if Length(send.sub_persdocs) > 0 then
    begin
      sub_persdocsArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_persdocs)-1 do
      begin
        sub_persdocs := TJSONObject.Create;
        if send.sub_persdocs[i].persdoc_type <> '' then
          sub_persdocs.AddPair('persdoc_type', TJSONNumber.Create(send.sub_persdocs[i].persdoc_type))
        else
          sub_persdocs.AddPair('persdoc_type', TJSONNull.Create);
        if send.sub_persdocs[i].pd_series <> '' then
          sub_persdocs.AddPair('pd_series', send.sub_persdocs[i].pd_series)
        else
          sub_persdocs.AddPair('pd_series', TJSONNull.Create);
        if send.sub_persdocs[i].pd_number <> '' then
          sub_persdocs.AddPair('pd_number', send.sub_persdocs[i].pd_number)
        else
          sub_persdocs.AddPair('pd_number', TJSONNull.Create);
        if send.sub_persdocs[i].issued_by <> '' then
          sub_persdocs.AddPair('issued_by', send.sub_persdocs[i].issued_by)
        else
          sub_persdocs.AddPair('issued_by', TJSONNull.Create);
        if send.sub_persdocs[i].date_begin <> '' then
          sub_persdocs.AddPair('date_begin', FormatDateToService(StrToDate(send.sub_persdocs[i].date_begin, FormatSettings)))
        else
          sub_persdocs.AddPair('date_begin', TJSONNull.Create);
        sub_persdocsArray.AddElement(sub_persdocs);
      end;
      Bundle.AddPair('sub_persdocs', sub_persdocsArray);
    end else
    begin
      sub_persdocsArray := TJSONArray.Create;
      Bundle.AddPair('sub_persdocs', sub_persdocsArray);
    end;
    if Length(send.sub_contacts) > 0 then
    begin
      sub_contactsArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_contacts)-1 do
      begin
        sub_contacts := TJSONObject.Create;
        if send.sub_contacts[i].contact_type <> '' then
          sub_contacts.AddPair('contact_type', send.sub_contacts[i].contact_type)
        else
          sub_contacts.AddPair('contact_type', TJSONNull.Create);
        if send.sub_contacts[i].contact <> '' then
          sub_contacts.AddPair('contact', send.sub_contacts[i].contact)
        else
          sub_contacts.AddPair('contact', TJSONNull.Create);
        sub_contactsArray.AddElement(sub_contacts);
      end;
      Bundle.AddPair('sub_contacts', sub_contactsArray);
    end else
    begin
      sub_contactsArray := TJSONArray.Create;
      Bundle.AddPair('sub_contacts', sub_contactsArray);
    end;
    if Length(send.sub_addr) > 0 then
    begin
      sub_addrArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_addr)-1 do
      begin
        sub_addr := TJSONObject.Create;
        if send.sub_addr[i].addr_type <> '' then
          sub_addr.AddPair('addr_type', send.sub_addr[i].addr_type)
        else
          sub_addr.AddPair('addr_type', TJSONNull.Create);
        if send.sub_addr[i].address <> Nil then
        begin
          address := TJSONObject.Create;
          if send.sub_addr[i].address.region <> '' then
            address.AddPair('region', send.sub_addr[i].address.region)
          else
            address.AddPair('region', TJSONNull.Create);
          if send.sub_addr[i].address.area_guid <> '' then
            address.AddPair('area_guid', send.sub_addr[i].address.area_guid)
          else
            address.AddPair('area_guid', TJSONNull.Create);
          if send.sub_addr[i].address.street_guid <> '' then
            address.AddPair('street_guid', send.sub_addr[i].address.street_guid)
          else
            address.AddPair('street_guid', TJSONNull.Create);
          if send.sub_addr[i].address.house_guid <> '' then
            address.AddPair('house_guid', send.sub_addr[i].address.house_guid)
          else
            address.AddPair('house_guid', TJSONNull.Create);
          if send.sub_addr[i].address.area_name <> '' then
            address.AddPair('area_name', send.sub_addr[i].address.area_name)
          else
            address.AddPair('area_name', TJSONNull.Create);
          if send.sub_addr[i].address.street_name <> '' then
            address.AddPair('street_name', send.sub_addr[i].address.street_name)
          else
            address.AddPair('street_name', TJSONNull.Create);
          if send.sub_addr[i].address.house <> '' then
            address.AddPair('house', send.sub_addr[i].address.house)
          else
            address.AddPair('house', TJSONNull.Create);
          if send.sub_addr[i].address.flat <> '' then
            address.AddPair('flat', send.sub_addr[i].address.flat)
          else
            address.AddPair('flat', TJSONNull.Create);
          sub_addr.AddPair('address', address);
        end;
        sub_addrArray.AddElement(sub_addr);
      end;
      Bundle.AddPair('sub_addr', sub_addrArray);
    end else
    begin
      sub_addrArray := TJSONArray.Create;
      Bundle.AddPair('sub_addr', sub_addrArray);
    end;
    if Length(send.sub_insurance) > 0 then
    begin
      sub_insuranceArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_insurance)-1 do
      begin
        sub_insurance := TJSONObject.Create;
        if send.sub_insurance[i].policy_type <> '' then
          sub_insurance.AddPair('policy_type', TJSONNumber.Create(send.sub_insurance[i].policy_type))
        else
          sub_insurance.AddPair('policy_type', TJSONNull.Create);
        if send.sub_insurance[i].policy_series <> '' then
          sub_insurance.AddPair('policy_series', send.sub_insurance[i].policy_series)
        else
          sub_insurance.AddPair('policy_series', TJSONNull.Create);
        if send.sub_insurance[i].policy_number <> '' then
          sub_insurance.AddPair('policy_number', send.sub_insurance[i].policy_number)
        else
          sub_insurance.AddPair('policy_number', TJSONNull.Create);
        if send.sub_insurance[i].ins_org <> '' then
          sub_insurance.AddPair('ins_org', send.sub_insurance[i].ins_org)
        else
          sub_insurance.AddPair('ins_org', TJSONNull.Create);
        sub_insuranceArray.AddElement(sub_insurance);
      end;
      Bundle.AddPair('sub_insurance', sub_insuranceArray);
    end else
    begin
      sub_insuranceArray := TJSONArray.Create;
      Bundle.AddPair('sub_insurance', sub_insuranceArray);
    end;
  end;
  //
  RESTRequest.AddBody(Bundle.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
  try
    RESTRequest.Execute;
  except
  end;

  Result:=TPutPersonOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

function TRosVacCOVID.PutReg(reg_id: string; send: TPutRegIn): TPutRegOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;

  i, j: Integer;
  Bundle, reg, sub_researches, sub_stages, sub_exams: TJSONObject;
  pathology_bronchArray, pathology_cardioArray, pathology_endoArray, pathology_onkoArray, pathology_hivArray,
  pathology_tuberArray, pathology_syphilisArray, pathology_hepatitisArray, pathology_otherArray,
  sub_researchesArray, sub_stagesArray, sub_examsArray: TJSONArray;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('reg/'+reg_id,TRestRequestMethod.rmPUT, RESTClient, RESTResponse);

  //Заполнение запроса
  Bundle:=TJSONObject.Create;
  if send <> Nil then
  begin
    if send.has_allergies <> '' then
      Bundle.AddPair('has_allergies', send.has_allergies)
    else
      Bundle.AddPair('has_allergies', TJSONNull.Create);
    if send.allergies <> '' then
      Bundle.AddPair('allergies', send.allergies)
    else
      Bundle.AddPair('allergies', TJSONNull.Create);
    if send.had_last_vaccine_reactions <> '' then
      Bundle.AddPair('had_last_vaccine_reactions', send.had_last_vaccine_reactions)
    else
      Bundle.AddPair('had_last_vaccine_reactions', TJSONNull.Create);
    if send.last_vaccine_reactions <> '' then
      Bundle.AddPair('last_vaccine_reactions', send.last_vaccine_reactions)
    else
      Bundle.AddPair('last_vaccine_reactions', TJSONNull.Create);
    if send.vaccination_information_flu <> '' then
      Bundle.AddPair('vaccination_information_flu', send.vaccination_information_flu)
    else
      Bundle.AddPair('vaccination_information_flu', TJSONNull.Create);
    if send.information_flu_id <> '' then
      Bundle.AddPair('information_flu_id', send.information_flu_id)
    else
      Bundle.AddPair('information_flu_id', TJSONNull.Create);
    if send.information_flu_text <> '' then
      Bundle.AddPair('information_flu_text', send.information_flu_text)
    else
      Bundle.AddPair('information_flu_text', TJSONNull.Create);
    if send.vaccination_information_air <> '' then
      Bundle.AddPair('vaccination_information_air', send.vaccination_information_air)
    else
      Bundle.AddPair('vaccination_information_air', TJSONNull.Create);
    if send.vaccine <> '' then
      Bundle.AddPair('vaccine', TJSONNumber.Create(send.vaccine))
    else
      Bundle.AddPair('vaccine', TJSONNull.Create);

    if send.has_pathology_bronch <> '' then
      Bundle.AddPair('has_pathology_bronch', send.has_pathology_bronch)
    else
      Bundle.AddPair('has_pathology_bronch', TJSONNull.Create);
    if Length(send.pathology_bronch) > 0 then
    begin
      pathology_bronchArray := TJSONArray.Create;
      for I := 0 to Length(send.pathology_bronch)-1 do
        pathology_bronchArray.Add(send.pathology_bronch[i]);
      Bundle.AddPair('pathology_bronch', pathology_bronchArray);
    end else
    begin
      pathology_bronchArray := TJSONArray.Create;
      Bundle.AddPair('pathology_bronch', pathology_bronchArray);
    end;
    if send.has_pathology_cardio <> '' then
      Bundle.AddPair('has_pathology_cardio', send.has_pathology_cardio)
    else
      Bundle.AddPair('has_pathology_cardio', TJSONNull.Create);
    if Length(send.pathology_cardio) > 0 then
    begin
      pathology_cardioArray := TJSONArray.Create;
      for I := 0 to Length(send.pathology_cardio)-1 do
        pathology_bronchArray.Add(send.pathology_cardio[i]);
      Bundle.AddPair('pathology_cardio', pathology_cardioArray);
    end else
    begin
      pathology_cardioArray := TJSONArray.Create;
      Bundle.AddPair('pathology_cardio', pathology_cardioArray);
    end;
    if send.has_pathology_endo <> '' then
      Bundle.AddPair('has_pathology_endo', send.has_pathology_endo)
    else
      Bundle.AddPair('has_pathology_endo', TJSONNull.Create);
    if Length(send.pathology_endo) > 0 then
    begin
      pathology_endoArray := TJSONArray.Create;
      for I := 0 to Length(send.pathology_endo)-1 do
        pathology_endoArray.Add(send.pathology_endo[i]);
      Bundle.AddPair('pathology_endo', pathology_endoArray);
    end else
    begin
      pathology_endoArray := TJSONArray.Create;
      Bundle.AddPair('pathology_endo', pathology_endoArray);
    end;
    if send.has_pathology_onko <> '' then
      Bundle.AddPair('has_pathology_onko', send.has_pathology_onko)
    else
      Bundle.AddPair('has_pathology_onko', TJSONNull.Create);
    if Length(send.pathology_onko) > 0 then
    begin
      pathology_onkoArray := TJSONArray.Create;
      for I := 0 to Length(send.pathology_onko)-1 do
        pathology_onkoArray.Add(send.pathology_onko[i]);
      Bundle.AddPair('pathology_onko', pathology_onkoArray);
    end else
    begin
      pathology_onkoArray := TJSONArray.Create;
      Bundle.AddPair('pathology_onko', pathology_onkoArray);
    end;
    if send.has_pathology_hiv <> '' then
      Bundle.AddPair('has_pathology_hiv', send.has_pathology_hiv)
    else
      Bundle.AddPair('has_pathology_hiv', TJSONNull.Create);
    if Length(send.pathology_hiv) > 0 then
    begin
      pathology_hivArray := TJSONArray.Create;
      for I := 0 to Length(send.pathology_hiv)-1 do
        pathology_hivArray.Add(send.pathology_hiv[i]);
      Bundle.AddPair('pathology_hiv', pathology_hivArray);
    end else
    begin
      pathology_hivArray := TJSONArray.Create;
      Bundle.AddPair('pathology_hiv', pathology_hivArray);
    end;
    if send.has_pathology_tuber <> '' then
      Bundle.AddPair('has_pathology_tuber', send.has_pathology_tuber)
    else
      Bundle.AddPair('has_pathology_tuber', TJSONNull.Create);
    if Length(send.pathology_tuber) > 0 then
    begin
      pathology_tuberArray := TJSONArray.Create;
      for I := 0 to Length(send.pathology_tuber)-1 do
        pathology_tuberArray.Add(send.pathology_tuber[i]);
      Bundle.AddPair('pathology_tuber', pathology_tuberArray);
    end else
    begin
      pathology_tuberArray := TJSONArray.Create;
      Bundle.AddPair('pathology_tuber', pathology_tuberArray);
    end;
    if send.has_pathology_syphilis <> '' then
      Bundle.AddPair('has_pathology_syphilis', send.has_pathology_syphilis)
    else
      Bundle.AddPair('has_pathology_syphilis', TJSONNull.Create);
    if Length(send.pathology_syphilis) > 0 then
    begin
      pathology_syphilisArray := TJSONArray.Create;
      for I := 0 to Length(send.pathology_syphilis)-1 do
        pathology_syphilisArray.Add(send.pathology_syphilis[i]);
      Bundle.AddPair('pathology_syphilis', pathology_syphilisArray);
    end else
    begin
      pathology_syphilisArray := TJSONArray.Create;
      Bundle.AddPair('pathology_syphilis', pathology_syphilisArray);
    end;
    if send.has_pathology_hepatitis <> '' then
      Bundle.AddPair('has_pathology_hepatitis', send.has_pathology_hepatitis)
    else
      Bundle.AddPair('has_pathology_hepatitis', TJSONNull.Create);
    if Length(send.pathology_hepatitis) > 0 then
    begin
      pathology_hepatitisArray := TJSONArray.Create;
      for I := 0 to Length(send.pathology_hepatitis)-1 do
        pathology_hepatitisArray.Add(send.pathology_hepatitis[i]);
      Bundle.AddPair('pathology_hepatitis', pathology_hepatitisArray);
    end else
    begin
      pathology_hepatitisArray := TJSONArray.Create;
      Bundle.AddPair('pathology_hepatitis', pathology_hepatitisArray);
    end;
    if send.has_pathology_other <> '' then
      Bundle.AddPair('has_pathology_other', send.has_pathology_other)
    else
      Bundle.AddPair('has_pathology_other', TJSONNull.Create);
    if Length(send.pathology_other) > 0 then
    begin
      pathology_otherArray := TJSONArray.Create;
      for I := 0 to Length(send.pathology_other)-1 do
        pathology_otherArray.Add(send.pathology_other[i]);
      Bundle.AddPair('pathology_other', pathology_otherArray);
    end else
    begin
      pathology_otherArray := TJSONArray.Create;
      Bundle.AddPair('pathology_other', pathology_otherArray);
    end;
    if send.risk_group <> '' then
      Bundle.AddPair('risk_group', send.risk_group)
    else
      Bundle.AddPair('risk_group', TJSONNull.Create);
    if Length(send.sub_researches) > 0 then
    begin
      sub_researchesArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_researches)-1 do
      begin
        sub_researches := TJSONObject.Create;
        if send.sub_researches[i].exam_result <> '' then
          sub_researches.AddPair('exam_result', send.sub_researches[i].exam_result)
        else
          sub_researches.AddPair('exam_result', TJSONNull.Create);
        if send.sub_researches[i].exam_date <> '' then
          sub_researches.AddPair('exam_date', FormatDateToService(StrToDate(send.sub_researches[i].exam_date, FormatSettings)))
        else
          sub_researches.AddPair('exam_date', TJSONNull.Create);
        sub_researchesArray.AddElement(sub_researches);
      end;
      Bundle.AddPair('sub_researchesArray', sub_researches);
    end else
    begin
      sub_researchesArray := TJSONArray.Create;
      Bundle.AddPair('sub_researches', sub_researchesArray);
    end;
    if Length(send.sub_stages) > 0 then
    begin
      sub_stagesArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_stages)-1 do
      begin
        sub_stages := TJSONObject.Create;
        if send.sub_stages[i].stage_number <> '' then
          sub_stages.AddPair('stage_number', TJSONNumber.Create(send.sub_stages[i].stage_number))
        else
          sub_stages.AddPair('stage_number', TJSONNull.Create);
        if send.sub_stages[i].gtin <> '' then
          sub_stages.AddPair('gtin', send.sub_stages[i].gtin)
        else
          sub_stages.AddPair('gtin', TJSONNull.Create);
        if send.sub_stages[i].serial_number <> '' then
          sub_stages.AddPair('serial_number', send.sub_stages[i].serial_number)
        else
          sub_stages.AddPair('serial_number', TJSONNull.Create);
        if send.sub_stages[i].batch_series <> '' then
          sub_stages.AddPair('batch_series', send.sub_stages[i].batch_series)
        else
          sub_stages.AddPair('batch_series', TJSONNull.Create);
        if send.sub_stages[i].has_reaction <> '' then
          sub_stages.AddPair('has_reaction', TJSONBool.Create(StrToBool(send.sub_stages[i].has_reaction)))
        else
          sub_stages.AddPair('has_reaction', TJSONNull.Create);
        if send.sub_stages[i].reaction <> '' then
          sub_stages.AddPair('reaction', TJSONNumber.Create(send.sub_stages[i].reaction))
        else
          sub_stages.AddPair('reaction', TJSONNull.Create);
        if send.sub_stages[i].reaction_type <> '' then
          sub_stages.AddPair('reaction_type', TJSONNumber.Create(send.sub_stages[i].reaction_type))
        else
          sub_stages.AddPair('reaction_type', TJSONNull.Create);
        if Length(send.sub_stages[i].sub_exams) > 0 then
        begin
          sub_examsArray := TJSONArray.Create;
          for j := 0 to Length(send.sub_stages[i].sub_exams)-1 do
          begin
            sub_exams := TJSONObject.Create;
            if send.sub_stages[i].sub_exams[j].script_vaccination <> '' then
              sub_exams.AddPair('script_vaccination', TJSONNumber.Create(send.sub_stages[i].sub_exams[j].script_vaccination))
            else
              sub_exams.AddPair('script_vaccination', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].exam_date <> '' then
              sub_exams.AddPair('exam_date', FormatDateToService(StrToDate(send.sub_stages[i].sub_exams[j].exam_date, FormatSettings)))
            else
              sub_exams.AddPair('exam_date', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].mo <> '' then
              sub_exams.AddPair('mo', send.sub_stages[i].sub_exams[j].mo)
            else
              sub_exams.AddPair('mo', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].department <> '' then
              sub_exams.AddPair('department', send.sub_stages[i].sub_exams[j].department)
            else
              sub_exams.AddPair('department', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].medical_worker <> '' then
              sub_exams.AddPair('medical_worker', send.sub_stages[i].sub_exams[j].medical_worker)
            else
              sub_exams.AddPair('medical_worker', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].medical_worker_snils <> '' then
              sub_exams.AddPair('medical_worker_snils', send.sub_stages[i].sub_exams[j].medical_worker_snils)
            else
              sub_exams.AddPair('medical_worker_snils', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].temperature <> '' then
              sub_exams.AddPair('temperature', TJSONNumber.Create(send.sub_stages[i].sub_exams[j].temperature))
            else
              sub_exams.AddPair('temperature', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].respiratory_rate <> '' then
              sub_exams.AddPair('respiratory_rate', TJSONNumber.Create(send.sub_stages[i].sub_exams[j].respiratory_rate))
            else
              sub_exams.AddPair('respiratory_rate', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].heart_rate <> '' then
              sub_exams.AddPair('heart_rate', send.sub_stages[i].sub_exams[j].heart_rate)
            else
              sub_exams.AddPair('heart_rate', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].general_state <> '' then
              sub_exams.AddPair('general_state', send.sub_stages[i].sub_exams[j].general_state)
            else
              sub_exams.AddPair('general_state', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].had_covid <> '' then
              sub_exams.AddPair('had_covid', TJSONBool.Create(StrToBool(send.sub_stages[i].sub_exams[j].had_covid)))
            else
              sub_exams.AddPair('had_covid', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].contact_patient <> '' then
              sub_exams.AddPair('contact_patient', send.sub_stages[i].sub_exams[j].contact_patient)
            else
              sub_exams.AddPair('contact_patient', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].admission <> '' then
              sub_exams.AddPair('admission', TJSONNumber.Create(send.sub_stages[i].sub_exams[j].admission))
            else
              sub_exams.AddPair('admission', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].pregnancy <> '' then
              sub_exams.AddPair('pregnancy', TJSONBool.Create(StrToBool(send.sub_stages[i].sub_exams[j].pregnancy)))
            else
              if send.sub_stages[i].sub_exams[j].female then
                sub_exams.AddPair('pregnancy', TJSONNull.Create);
            if send.sub_stages[i].sub_exams[j].pregnancy_period <> '' then
              sub_exams.AddPair('pregnancy_period', TJSONNumber.Create(send.sub_stages[i].sub_exams[j].pregnancy_period))
            else
             if send.sub_stages[i].sub_exams[j].female then
              sub_exams.AddPair('pregnancy_period', TJSONNull.Create);
            sub_examsArray.AddElement(sub_exams);
          end;
          sub_stages.AddPair('sub_exams', sub_examsArray);
        end else
        begin
          sub_examsArray := TJSONArray.Create;
          sub_stages.AddPair('sub_exams', sub_examsArray);
        end;
        sub_stagesArray.AddElement(sub_stages);
      end;
      Bundle.AddPair('sub_stages', sub_stagesArray);
    end else
    begin
      sub_stagesArray := TJSONArray.Create;
      Bundle.AddPair('sub_stages', sub_stagesArray);
    end;
  end;
  //
//  SaveToFile(Bundle);
//   Exit;
  RESTRequest.AddBody(Bundle.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
  try
    RESTRequest.Execute;
  except
  end;

  Result:=TPutRegOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

function TRosVacCOVID.PutRegComplication(reg_id, complication_date: string; send: TPutRegComplicationIn): TPutRegComplicationOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;

  i,j: Integer;

  Bundle, sub_symps: TJSONObject;
  sub_sympsArray: TJSONArray;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('record/'+reg_id+'/complication/'+complication_date,TRestRequestMethod.rmPUT, RESTClient, RESTResponse);

  //Заполнение запроса
  Bundle:=TJSONObject.Create;
  if send <> Nil then
  begin
    if send.exam_date <> '' then
      Bundle.AddPair('exam_date', FormatDateToService(StrToDate(send.exam_date, FormatSettings)))
    else
      Bundle.AddPair('exam_date', TJSONNull.Create);
    if send.mo <> '' then
      Bundle.AddPair('mo', send.mo)
    else
      Bundle.AddPair('mo', TJSONNull.Create);
    if send.department <> '' then
      Bundle.AddPair('department', send.department)
    else
      Bundle.AddPair('department', TJSONNull.Create);
    if send.medical_worker <> '' then
      Bundle.AddPair('medical_worker', send.medical_worker)
    else
      Bundle.AddPair('medical_worker', TJSONNull.Create);
    if send.medical_worker_snils <> '' then
      Bundle.AddPair('medical_worker_snils', send.medical_worker_snils)
    else
      Bundle.AddPair('medical_worker_snils', TJSONNull.Create);
    if send.other_symp <> '' then
      Bundle.AddPair('other_symp', send.other_symp)
    else
      Bundle.AddPair('other_symp', TJSONNull.Create);
    if Length(send.sub_symps) > 0 then
    begin
      sub_sympsArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_symps)-1 do
      begin
        sub_symps := TJSONObject.Create;
        if send.sub_symps[i].symp_id <> '' then
          sub_symps.AddPair('symp_id', TJSONNumber.Create(send.sub_symps[i].symp_id))
        else
          sub_symps.AddPair('symp_id', TJSONNull.Create);
        if send.sub_symps[i].description <> '' then
          sub_symps.AddPair('description', send.sub_symps[i].description)
        else
          sub_symps.AddPair('description', TJSONNull.Create);
        sub_sympsArray.AddElement(sub_symps);
      end;
      Bundle.AddPair('sub_symps', sub_sympsArray);
    end else
    begin
      sub_sympsArray := TJSONArray.Create;
      Bundle.AddPair('sub_symps', sub_sympsArray);
    end;
  end;
  //
  RESTRequest.AddBody(Bundle.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
  try
    RESTRequest.Execute;
  except
  end;

  Result:=TPutRegComplicationOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

function TRosVacCOVID.PutRegDairy(reg_id, diary_date: string; send: TPutRegDairyIn): TPutRegDairyOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;

  i,j: Integer;

  Bundle, sub_exams, sub_moves, sub_symp, sub_acts, sub_adds, sub_drugs, sub_diffs: TJSONObject;
  sub_examsArray, sub_movesArray, sub_actsArray, sub_addsArray, sub_drugsArray, sub_diffsArray: TJSONArray;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('record/'+reg_id+'/diary/'+diary_date,TRestRequestMethod.rmPUT, RESTClient, RESTResponse);

  //Заполнение запроса
  Bundle:=TJSONObject.Create;
  if send <> Nil then
  begin
    if send.diary_date <> '' then
      Bundle.AddPair('diary_date', FormatDateToService(StrToDate(send.diary_date, FormatSettings)))
    else
      Bundle.AddPair('diary_date', TJSONNull.Create);
    if send.pregnancy <> '' then
      Bundle.AddPair('pregnancy', TJSONBool.Create(StrToBool(send.pregnancy)))
    else
      Bundle.AddPair('pregnancy', TJSONNull.Create);
    if send.first_stage_contact <> '' then
      Bundle.AddPair('first_stage_contact', TJSONBool.Create(StrToBool(send.first_stage_contact)))
    else
      Bundle.AddPair('first_stage_contact', TJSONNull.Create);
    if send.first_stage_contact_date <> '' then
      Bundle.AddPair('first_stage_contact_date', FormatDateToService(StrToDate(send.first_stage_contact_date, FormatSettings)))
    else
      Bundle.AddPair('first_stage_contact_date', TJSONNull.Create);
    if send.second_stage_contact <> '' then
      Bundle.AddPair('second_stage_contact', TJSONBool.Create(StrToBool(send.second_stage_contact)))
    else
      Bundle.AddPair('second_stage_contact', TJSONNull.Create);
    if send.second_stage_contact_date <> '' then
      Bundle.AddPair('second_stage_contact_date', FormatDateToService(StrToDate(send.second_stage_contact_date, FormatSettings)))
    else
      Bundle.AddPair('second_stage_contact_date', TJSONNull.Create);
    if send.description <> '' then
      Bundle.AddPair('description', send.description)
    else
      Bundle.AddPair('description', TJSONNull.Create);
    if Length(send.sub_exams) > 0 then
    begin
      sub_examsArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_exams)-1 do
      begin
        sub_exams := TJSONObject.Create;
        if send.sub_exams[i].script_vaccination <> '' then
          sub_exams.AddPair('script_vaccination', TJSONNumber.Create(send.sub_exams[i].script_vaccination))
        else
          sub_exams.AddPair('script_vaccination', TJSONNull.Create);
        if send.sub_exams[i].exam_date <> '' then
          sub_exams.AddPair('exam_date', FormatDateToService(StrToDate(send.sub_exams[i].exam_date, FormatSettings)))
        else
          sub_exams.AddPair('exam_date', TJSONNull.Create);
        if send.sub_exams[i].mo <> '' then
          sub_exams.AddPair('mo', send.sub_exams[i].mo)
        else
          sub_exams.AddPair('mo', TJSONNull.Create);
        if send.sub_exams[i].department <> '' then
          sub_exams.AddPair('department', send.sub_exams[i].department)
        else
          sub_exams.AddPair('department', TJSONNull.Create);
        if send.sub_exams[i].medical_worker <> '' then
          sub_exams.AddPair('medical_worker', send.sub_exams[i].medical_worker)
        else
          sub_exams.AddPair('medical_worker', TJSONNull.Create);
        if send.sub_exams[i].medical_worker_snils <> '' then
          sub_exams.AddPair('medical_worker_snils', send.sub_exams[i].medical_worker_snils)
        else
          sub_exams.AddPair('medical_worker_snils', TJSONNull.Create);
        if send.sub_exams[i].temperature <> '' then
          sub_exams.AddPair('temperature', TJSONNumber.Create(send.sub_exams[i].temperature))
        else
          sub_exams.AddPair('temperature', TJSONNull.Create);
        if send.sub_exams[i].respiratory_rate <> '' then
          sub_exams.AddPair('respiratory_rate', TJSONNumber.Create(send.sub_exams[i].respiratory_rate))
        else
          sub_exams.AddPair('respiratory_rate', TJSONNull.Create);
        if send.sub_exams[i].heart_rate <> '' then
          sub_exams.AddPair('heart_rate', TJSONNumber.Create(send.sub_exams[i].heart_rate))
        else
          sub_exams.AddPair('heart_rate', TJSONNull.Create);
        if send.sub_exams[i].general_state <> '' then
          sub_exams.AddPair('general_state', send.sub_exams[i].general_state)
        else
          sub_exams.AddPair('general_state', TJSONNull.Create);
        if send.sub_exams[i].had_covid <> '' then
          sub_exams.AddPair('had_covid', TJSONBool.Create(StrToBool(send.sub_exams[i].had_covid)))
        else
          sub_exams.AddPair('had_covid', TJSONNull.Create);
        if send.sub_exams[i].contact_patient <> '' then
          sub_exams.AddPair('contact_patient', send.sub_exams[i].contact_patient)
        else
          sub_exams.AddPair('contact_patient', TJSONNull.Create);
        if send.sub_exams[i].admission <> '' then
          sub_exams.AddPair('admission', TJSONNumber.Create(send.sub_exams[i].admission))
        else
          sub_exams.AddPair('admission', TJSONNull.Create);
        if send.sub_exams[i].pregnancy <> '' then
          sub_exams.AddPair('pregnancy', TJSONBool.Create(StrToBool(send.sub_exams[i].pregnancy)))
        else
          sub_exams.AddPair('pregnancy', TJSONNull.Create);
        if send.sub_exams[i].pregnancy_period <> '' then
          sub_exams.AddPair('pregnancy_period', TJSONNumber.Create(send.sub_exams[i].pregnancy_period))
        else
          sub_exams.AddPair('pregnancy_period', TJSONNull.Create);
        sub_examsArray.AddElement(sub_exams);
      end;
      Bundle.AddPair('sub_exams', sub_examsArray);
    end else
    begin
      sub_examsArray := TJSONArray.Create;
      Bundle.AddPair('sub_exams', sub_examsArray);
    end;
    if Length(send.sub_moves) > 0 then
    begin
      sub_movesArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_moves)-1 do
      begin
        sub_moves := TJSONObject.Create;
        if send.sub_moves[i].date_from <> '' then
          sub_moves.AddPair('date_from', FormatDateToService(StrToDate(send.sub_moves[i].date_from, FormatSettings)))
        else
          sub_moves.AddPair('date_from', TJSONNull.Create);
        if send.sub_moves[i].date_to <> '' then
          sub_moves.AddPair('date_to', FormatDateToService(StrToDate(send.sub_moves[i].date_to, FormatSettings)))
        else
          sub_moves.AddPair('date_to', TJSONNull.Create);
        if send.sub_moves[i].country <> '' then
          sub_moves.AddPair('country', TJSONNumber.Create(send.sub_moves[i].country))
        else
          sub_moves.AddPair('country', TJSONNull.Create);
        if send.sub_moves[i].city <> '' then
          sub_moves.AddPair('city', send.sub_moves[i].city)
        else
          sub_moves.AddPair('city', TJSONNull.Create);
        sub_movesArray.AddElement(sub_moves);
      end;
      Bundle.AddPair('sub_moves', sub_movesArray);
    end else
    begin
      sub_movesArray := TJSONArray.Create;
      Bundle.AddPair('sub_moves', sub_movesArray);
    end;
    if send.sub_symp <> Nil then
    begin
      sub_symp := TJSONObject.Create;
      if send.sub_symp.symp_date_begin <> '' then
        sub_symp.AddPair('symp_date_begin', FormatDateToService(StrToDate(send.sub_symp.symp_date_begin, FormatSettings)))
      else
        sub_symp.AddPair('symp_date_begin', TJSONNull.Create);
      if send.sub_symp.symp_date_end <> '' then
        sub_symp.AddPair('symp_date_end', FormatDateToService(StrToDate(send.sub_symp.symp_date_end, FormatSettings)))
      else
        sub_symp.AddPair('symp_date_begin', TJSONNull.Create);
      if send.sub_symp.symp_diff <> '' then
        sub_symp.AddPair('symp_diff', send.sub_symp.symp_diff)
      else
        sub_symp.AddPair('symp_diff', TJSONNull.Create);
      if send.sub_symp.add_treatment <> '' then
        sub_symp.AddPair('add_treatment', send.sub_symp.add_treatment)
      else
        sub_symp.AddPair('add_treatment', TJSONNull.Create);
      if send.sub_symp.different_action <> '' then
        sub_symp.AddPair('different_action', send.sub_symp.different_action)
      else
        sub_symp.AddPair('different_action', TJSONNull.Create);
      if Length(send.sub_symp.sub_acts) > 0 then
      begin
        sub_actsArray := TJSONArray.Create;
        for I := 0 to Length(send.sub_symp.sub_acts)-1 do
        begin
          sub_acts := TJSONObject.Create;
          if send.sub_symp.sub_acts[i].act_id <> '' then
            sub_acts.AddPair('act_id',send.sub_symp.sub_acts[i].act_id);
          sub_actsArray.AddElement(sub_acts);
        end;
        sub_symp.AddPair('sub_acts', sub_actsArray);
      end else
      begin
        sub_actsArray := TJSONArray.Create;
        sub_symp.AddPair('sub_acts', sub_actsArray);
      end;
      if Length(send.sub_symp.sub_adds) > 0 then
      begin
        sub_addsArray := TJSONArray.Create;
        for I := 0 to Length(send.sub_symp.sub_adds)-1 do
        begin
          sub_adds := TJSONObject.Create;
          if send.sub_symp.sub_adds[i].symp_id <> '' then
            sub_adds.AddPair('symp_id', TJSONNumber.Create(send.sub_symp.sub_adds[i].symp_id))
          else
            sub_adds.AddPair('symp_id', TJSONNull.Create);
          if send.sub_symp.sub_adds[i].description <> '' then
            sub_adds.AddPair('symp_id', send.sub_symp.sub_adds[i].description)
          else
            sub_adds.AddPair('symp_id', TJSONNumber.Create);
          sub_addsArray.AddElement(sub_adds);
        end;
        sub_symp.AddPair('sub_adds', sub_addsArray);
      end else
      begin
        sub_addsArray := TJSONArray.Create;
        sub_symp.AddPair('sub_adds', sub_addsArray);
      end;
      if Length(send.sub_symp.sub_drugs) > 0 then
      begin
        sub_drugsArray := TJSONArray.Create;
        for I := 0 to Length(send.sub_symp.sub_drugs)-1 do
        begin
          sub_drugs := TJSONObject.Create;
          if send.sub_symp.sub_drugs[i].drug_name <> '' then
            sub_drugs.AddPair('drug_name', send.sub_symp.sub_drugs[i].drug_name)
          else
            sub_drugs.AddPair('drug_name', TJSONNull.Create);
          if send.sub_symp.sub_drugs[i].dosage <> '' then
            sub_drugs.AddPair('dosage', TJSONNumber.Create(send.sub_symp.sub_drugs[i].dosage))
          else
            sub_drugs.AddPair('dosage', TJSONNull.Create);
          if send.sub_symp.sub_drugs[i].duration <> '' then
            sub_drugs.AddPair('duration', TJSONNumber.Create(send.sub_symp.sub_drugs[i].duration))
          else
            sub_drugs.AddPair('duration', TJSONNull.Create);
          sub_drugsArray.AddElement(sub_drugs);
        end;
        sub_symp.AddPair('sub_drugs', sub_drugsArray);
      end else
      begin
        sub_drugsArray := TJSONArray.Create;
        sub_symp.AddPair('sub_drugs', sub_drugsArray);
      end;
      if Length(send.sub_symp.sub_diffs) > 0 then
      begin
        sub_diffsArray := TJSONArray.Create;
        for I := 0 to Length(send.sub_symp.sub_diffs)-1 do
        begin
          sub_diffs := TJSONObject.Create;
          if send.sub_symp.sub_diffs[i].disease_name <> '' then
            sub_diffs.AddPair('disease_name', send.sub_symp.sub_diffs[i].disease_name)
          else
            sub_diffs.AddPair('disease_name', TJSONNull.Create);
          if send.sub_symp.sub_diffs[i].date_begin <> '' then
            sub_diffs.AddPair('date_begin', send.sub_symp.sub_diffs[i].date_begin)
          else
            sub_diffs.AddPair('date_begin', TJSONNull.Create);
          if send.sub_symp.sub_diffs[i].date_end <> '' then
            sub_diffs.AddPair('date_end', send.sub_symp.sub_diffs[i].date_end)
          else
            sub_diffs.AddPair('date_end', TJSONNull.Create);
          sub_diffsArray.AddElement(sub_diffs);
        end;
        sub_symp.AddPair('sub_diffs', sub_diffsArray);
      end else
      begin
        sub_diffsArray := TJSONArray.Create;
        sub_symp.AddPair('sub_diffs', sub_diffsArray);
      end;
      Bundle.AddPair('sub_symp', sub_symp);
    end else
    begin
      sub_symp := TJSONObject.Create;
      Bundle.AddPair('sub_symp', sub_symp);
    end;
  end;
  //
  RESTRequest.AddBody(Bundle.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
  try
    RESTRequest.Execute;
  except
  end;

  Result:=TPutRegDairyOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

function TRosVacCOVID.PutRegPregnancy(reg_id, pregnancy, searchBy: string; send: TPutRegPregnancyIn): TPutRegPregnancyOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;

  i,j: Integer;

  Bundle, sub_exam, sub_child: TJSONObject;
  sub_examArray, sub_childArray, anomaliesArray: TJSONArray;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('record/'+reg_id+'/pregnancy/'+pregnancy+'?searchBy='+searchBy,TRestRequestMethod.rmPUT, RESTClient, RESTResponse);

  //Заполнение запроса
  Bundle:=TJSONObject.Create;
  if send <> Nil then
  begin
    if send.estimated_date <> '' then
      Bundle.AddPair('estimated_date', FormatDateToService(StrToDate(send.estimated_date, FormatSettings)))
    else
      Bundle.AddPair('estimated_date', TJSONNull.Create);
    if send.pregnancy_order <> '' then
      Bundle.AddPair('pregnancy_order', TJSONNumber.Create(send.pregnancy_order))
    else
      Bundle.AddPair('pregnancy_order', TJSONNull.Create);
    if send.childbirth_order <> '' then
      Bundle.AddPair('childbirth_order', TJSONNumber.Create(send.childbirth_order))
    else
      Bundle.AddPair('childbirth_order', TJSONNull.Create);
    if send.pregnancy_outcome <> '' then
      Bundle.AddPair('pregnancy_outcome', TJSONNumber.Create(send.pregnancy_outcome))
    else
      Bundle.AddPair('pregnancy_outcome', TJSONNull.Create);
    if send.pregnancy_outcome_date <> '' then
      Bundle.AddPair('pregnancy_outcome_date', FormatDateToService(StrToDate(send.pregnancy_outcome_date, FormatSettings)))
    else
      Bundle.AddPair('pregnancy_outcome_date', TJSONNull.Create);
    if send.mo <> '' then
      Bundle.AddPair('mo',send.mo)
    else
      Bundle.AddPair('mo', TJSONNull.Create);
    if send.childbirth_term <> '' then
      Bundle.AddPair('childbirth_term',send.childbirth_term)
    else
      Bundle.AddPair('childbirth_term', TJSONNull.Create);
    if send.childbirth_features <> '' then
      Bundle.AddPair('childbirth_features',send.childbirth_features)
    else
      Bundle.AddPair('childbirth_features', TJSONNull.Create);
    if send.children_amount <> '' then
      Bundle.AddPair('children_amount', TJSONNumber.Create(send.children_amount))
    else
      Bundle.AddPair('children_amount', TJSONNull.Create);
    if Length(send.sub_exam) > 0 then
    begin
      sub_examArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_exam)-1 do
      begin
        sub_exam := TJSONObject.Create;
        if send.sub_exam[i].exam_date <> '' then
          sub_exam.AddPair('exam_date', FormatDateToService(StrToDate(send.sub_exam[i].exam_date, FormatSettings)))
        else
          sub_exam.AddPair('exam_date', TJSONNull.Create);
        if send.sub_exam[i].mo <> '' then
          sub_exam.AddPair('mo', send.sub_exam[i].mo)
        else
          sub_exam.AddPair('mo', TJSONNull.Create);
        if send.sub_exam[i].pregnancy_term <> '' then
          sub_exam.AddPair('pregnancy_term', send.sub_exam[i].pregnancy_term)
        else
          sub_exam.AddPair('pregnancy_term', TJSONNull.Create);
        if send.sub_exam[i].pregnancy_features <> '' then
          sub_exam.AddPair('pregnancy_features', send.sub_exam[i].pregnancy_features)
        else
          sub_exam.AddPair('pregnancy_features', TJSONNull.Create);
        sub_examArray.AddElement(sub_exam);
      end;
      Bundle.AddPair('sub_exam',sub_examArray);
    end else
    begin
      sub_examArray := TJSONArray.Create;
      Bundle.AddPair('sub_exam',sub_examArray);
    end;
    if Length(send.sub_child) > 0 then
    begin
      sub_childArray := TJSONArray.Create;
      for I := 0 to Length(send.sub_child)-1 do
      begin
        sub_child := TJSONObject.Create;
        if send.sub_child[i].gender <> '' then
          sub_child.AddPair('gender', TJSONNumber.Create(send.sub_child[i].gender))
        else
          sub_child.AddPair('gender', TJSONNull.Create);
        if send.sub_child[i].weight <> '' then
          sub_child.AddPair('weight', send.sub_child[i].weight);
        if send.sub_child[i].height <> '' then
          sub_child.AddPair('height', send.sub_child[i].height);
        if send.sub_child[i].apgar_scale <> '' then
          sub_child.AddPair('apgar_scale', send.sub_child[i].apgar_scale);
        if send.sub_child[i].has_anomalies <> '' then
          sub_child.AddPair('has_anomalies', send.sub_child[i].has_anomalies);
        if Length(send.sub_child[i].anomalies) > 0 then
        begin
          anomaliesArray := TJSONArray.Create;
          for j := 0 to Length(send.sub_child[i].anomalies)-1 do
            anomaliesArray.Add(send.sub_child[i].anomalies[j]);
          sub_child.AddPair('anomalies', anomaliesArray);
        end;
        sub_childArray.AddElement(sub_child);
      end;
      Bundle.AddPair('sub_child',sub_childArray);
    end else
    begin
      sub_childArray := TJSONArray.Create;
      Bundle.AddPair('sub_child',sub_childArray);
    end;
  end;
  //
  RESTRequest.AddBody(Bundle.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
  try
    RESTRequest.Execute;
  except
  end;

  Result:=TPutRegPregnancyOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

function TRosVacCOVID.PutRegStageExam(reg_id, stage_number, exam_date: string; send: TPutRegStageExamIn): TPutRegStageExamOut;
var
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;

  Bundle: TJSONObject;
begin
  RESTClient:=CreateRESTClient;
  RESTResponse:=CreateRESTResponse;
  RESTRequest:=CreateRESTRequest('record/'+reg_id+'/stage/'+stage_number+'/exam/'+exam_date,TRestRequestMethod.rmPUT, RESTClient, RESTResponse);

  //Заполнение запроса
  Bundle:=TJSONObject.Create;
  if send <> Nil then
  begin
    if send.exam_date <> '' then
      Bundle.AddPair('exam_date', FormatDateToService(StrToDate(send.exam_date, FormatSettings)))
    else
      Bundle.AddPair('exam_date', TJSONNull.Create);
    if send.mo <> '' then
      Bundle.AddPair('mo', send.mo)
    else
      Bundle.AddPair('mo', TJSONNull.Create);
    if send.department <> '' then
      Bundle.AddPair('department', send.department)
    else
      Bundle.AddPair('department', TJSONNull.Create);
    if send.medical_worker <> '' then
      Bundle.AddPair('medical_worker', send.medical_worker)
    else
      Bundle.AddPair('medical_worker', TJSONNull.Create);
    if send.medical_worker_snils <> '' then
      Bundle.AddPair('medical_worker_snils', send.medical_worker_snils)
    else
      Bundle.AddPair('medical_worker_snils', TJSONNull.Create);
    if send.temperature <> '' then
      Bundle.AddPair('temperature', TJSONNumber.Create(send.temperature))
    else
      Bundle.AddPair('temperature', TJSONNull.Create);
    if send.respiratory_rate <> '' then
      Bundle.AddPair('respiratory_rate', TJSONNumber.Create(send.respiratory_rate))
    else
      Bundle.AddPair('respiratory_rate', TJSONNull.Create);
    if send.heart_rate <> '' then
      Bundle.AddPair('heart_rate', TJSONNumber.Create(send.heart_rate))
    else
      Bundle.AddPair('heart_rate', TJSONNull.Create);
    if send.general_state <> '' then
      Bundle.AddPair('general_state', send.general_state)
    else
      Bundle.AddPair('general_state', TJSONNull.Create);
    if send.had_covid <> '' then
      Bundle.AddPair('had_covid', TJSONBool.Create(StrToBool(send.had_covid)))
    else
      Bundle.AddPair('had_covid', TJSONNull.Create);
    if send.contact_patient <> '' then
      Bundle.AddPair('contact_patient', send.contact_patient)
    else
      Bundle.AddPair('contact_patient', TJSONNull.Create);
    if send.admission <> '' then
      Bundle.AddPair('admission', TJSONNumber.Create(send.admission))
    else
      Bundle.AddPair('admission', TJSONNull.Create);
    if send.pregnancy <> '' then
      Bundle.AddPair('pregnancy', TJSONBool.Create(StrToBool(send.pregnancy)))
    else
      Bundle.AddPair('pregnancy', TJSONNull.Create);
    if send.pregnancy_period <> '' then
      Bundle.AddPair('pregnancy_period', TJSONNumber.Create(send.pregnancy_period))
    else
      Bundle.AddPair('pregnancy_period', TJSONNull.Create)
  end;
  //
  RESTRequest.AddBody(Bundle.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
  try
    RESTRequest.Execute;
  except
  end;

  Result:=TPutRegStageExamOut.Create;
  Result.codeError := IntToStr(RESTResponse.StatusCode);
  Result.Content := RESTResponse.Content;

  FreeAndNil(RESTClient);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTRequest);
end;

end.
