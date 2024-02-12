object SQLDataModule: TSQLDataModule
  OldCreateOrder = False
  Height = 293
  Width = 380
  object COVIDScripts: TFDScript
    SQLScripts = <
      item
        Name = 'AllDocs'
        SQL.Strings = (
          '--AllDocs'
          'select TOP 50'
          '    a.ID'
          '    ,a.ID_MO'
          '    ,a.PATIENT'
          '    ,a.MO'
          '    ,rec.UIN'
          '    ,a.UUID as local_id'
          '    ,a.DATE_UPLOAD'
          '    ,a.DATE_LAST_EDIT'
          'from'
          '    MIS_KSAMU.dbo.DOC_COVID a'
          '    left join MIS_KSAMU.dbo.REG_COVID rc on rc.ID = a.ID'
          
            '    left join  MIS_KSAMU.dbo.REG_EXTERNAL_COVID rec ON a.id = re' +
            'c.owner AND rec.DATE_SEND ='
          
            '           (SELECT max(rex.DATE_SEND) FROM MIS_KSAMU.dbo.REG_EXT' +
            'ERNAL_COVID rex WHERE a.id = rex.OWNER AND rex.UIN IS NOT NULL)'
          'WHERE   '
          '   ('
          '    a.DATE_UPLOAD IS NULL '
          '    OR a.DATE_UPLOAD < a.DATE_LAST_EDIT'
          '   )    '
          '   AND    '
          '   a.PATIENT IS NOT NULL '
          ' --AND a.DATEDOC BETWEEN '#39'01-11-2021'#39' AND '#39'01-12-2023'#39' '
          ' --AND a.DATEDOC > '#39'01-06-2023'#39' '
          'order BY a.DATEDOC desc, a.DATE_UPLOAD asc')
      end
      item
        Name = 'SelectPersonalInfo'
        SQL.Strings = (
          '--SelectPersonalInfo'
          'select'
          '    rp.UUID as local_id'
          '    ,rp.SNILS as snils'
          '    ,rp.FAM as lastname'
          '    ,rp.IM as firstname'
          '    ,rp.OT as patronymic'
          '    ,case rp.SEX '
          '        when '#39#1052#1091#1078'.'#39' then '#39'1'#39
          '        when '#39#1046#1077#1085'.'#39' then '#39'2'#39
          '        else null'
          '    end as gender'
          '    ,rp.BIRTHDAY as birth_date'
          '    ,IsNull(rc.ID_NSI, 171) as citizenship_country'
          '   -- ,171 AS citizenship_country'
          '    ,IsNull(rp.TELSOT, rp.TELDOM) as phone'
          'from'
          '    MIS_KSAMU.dbo.DOC_COVID a'
          
            '    join MIS_KSAMU.dbo.REF_PATIENTS rp on rp.ID_MO = a.PATIENT a' +
            'nd rp.MO = a.MO'
          
            '    left join (select top 1 * from MIS_KSAMU.dbo.REG_PASSPORTS o' +
            'rder by DATEON desc) p on p.OWNER = rp.ID_MO and p.MO = rp.MO'
          
            '    left join MIS_KSAMU.dbo.REF_COUNTRY rc on rc.ID_MO = p.CITIZ' +
            'ENSHIP and rc.MO = p.MO'
          'where'
          '    a.ID = :ID')
      end
      item
        Name = 'SelectDULs'
        SQL.Strings = (
          '--SelectDULs'
          'select'
          '    rp.UUID as local_id'
          '    ,pt.ID_NSI as persdoc_type'
          '    ,rp.SERIAL_PASSPOR as pd_series'
          '    ,rp.NUMBER_PASSPOR as pd_number'
          '    ,rp.VIDAN_DATE as date_begin'
          '    ,NULL as issued_by'
          'from'
          '    MIS_KSAMU.dbo.REG_PASSPORTS rp'
          
            '    join MIS_KSAMU.dbo.REF_PASSPORTTYPE pt on pt.ID = rp.PASSPOR' +
            'TTYPE'
          'where'
          '    rp.OWNER = :PATIENT'
          '    and MO = :MO')
      end
      item
        Name = 'SelectAddresses'
        SQL.Strings = (
          '--SelectAddresses'
          'select DISTINCT'
          '    IsNull(IsNull(r0.CODE, r1.CODE), r2.CODE) as region'
          '    ,case ra.CODE'
          '        when 1 then '#39'reg'#39
          '        when 2 then '#39'live'#39
          '    end as addr_type'
          '    ,IsNull(a.NASPUNKT, a.CITY) as area_name'
          '    ,a.STREET as street_name'
          '    ,a.HOUSE as house'
          '    ,a.KVARTIRA as flat'
          'from'
          '    MIS_KSAMU.dbo.REG_ADDRESS a'
          
            '    join MIS_KSAMU.dbo.REF_ADDRESSTYPE ra ON ra.ID = a.ADDRESSTY' +
            'PE and ra.CODE in (1, 2)'
          
            '    left join MIS_KSAMU.dbo.REF_MEDICALPOLES mp on mp.OWNER = a.' +
            'OWNER and mp.MO = a.MO'
          
            '    left join MIS_KSAMU.dbo.REF_REGIONS r0 on r0.ID = mp.REGION_' +
            'SMO'
          '    left join MIS_KSAMU.dbo.REF_SMO smo on smo.ID = mp.SMO    '
          '    left join MIS_KSAMU.dbo.REF_REGIONS r1 on r1.ID = smo.REGION'
          '    left join MIS_KSAMU.dbo.REF_MO rm on rm.ID = a.MO'
          '    left join MIS_KSAMU.dbo.REF_REGIONS r2 on r2.ID = rm.REGION'
          'where'
          '    a.OWNER = :PATIENT'
          '    and a.MO = :MO')
      end
      item
        Name = 'SelectInsurance'
        SQL.Strings = (
          '--SelectInsurance'
          'SELECT '
          '     pt.CODE_TFOMS as policy_type    '
          '    ,rm.SERIAL_POLES as policy_series'
          '    ,rm.NUMBER_POLES as policy_number            '
          
            '    ,IIF(rs.CODE=9999, (SELECT top 1 s.CODE FROM MIS_KSAMU.dbo.R' +
            'EF_SMO s where s.REGION=COALESCE(rm.REGION_SMO, r.id) and s.DATE' +
            '_OFF is null AND s.CODE is not NULL), rs.CODE)  as smo_cod'
          'from'
          '    MIS_KSAMU.dbo.DOC_COVID a    '
          
            '    JOIN MIS_KSAMU.dbo.REG_ACTUAL_POLISES rap ON rap.ID_MO = a.P' +
            'ATIENT and rap.MO = a.MO '
          
            '    join MIS_KSAMU.dbo.REF_MEDICALPOLES rm on rm.ID_MO = rap.POL' +
            'IS and rm.MO = rap.MO'
          
            '    join MIS_KSAMU.dbo.REF_MEDICALPOLESTYPE pt on pt.ID = rm.TYP' +
            'EPOLES    '
          '    join MIS_KSAMU.dbo.REF_SMO rs on rs.ID = rm.SMO'
          
            '    LEFT JOIN MIS_KSAMU.dbo.REF_REGIONS_NEW r on r.CODE=cast(lef' +
            't(rm.NUMBER_POLES, 2) AS TINYINT)'
          'where'
          '    rs.CODE <> 9999'
          '    and a.ID = :ID')
      end
      item
        Name = 'SelectRegInfo'
        SQL.Strings = (
          '--SelectRegInfo'
          'SELECT'
          '    a.UUID as local_id'
          '    ,l.OID as mo'
          '    ,a.DATEDOC as include_date'
          '    ,rm.CODEST as diagnosis_main'
          
            '    ,iif(substring(rm.CODEST,1,1) = '#39'J'#39' OR a.IS_AMBUL_LECH IS NU' +
            'LL, 0, 1) as stage_type    '
          '    ,a.IS_NOT_OSLOJ as is_diagnosis_hasnt_complication'
          '    ,rmo.CODEST as diagnosis_complication'
          '    ,LEAST(a.DATE_MKB, a.DATE_ISHOD) as approved_date'
          '    ,a.DATE_KLIN as symptom_date        '
          #9'  ,vir.CODEST as variant   '
          #9'  ,a.IS_VAKCIN_PNEV as is_vaccination_information_air'
          '    ,flu.CODEST as information_flu_id'
          '    ,a.VAKCIN_GRIP_TEXT AS information_flu_text    '
          
            '    ,iif(flu.CODEST IS NULL, 0, 1) as is_vaccination_information' +
            '_flu'
          '    ,ctv.CODEST as disease_outcome    '
          
            '    ,LEAST(a.DATE_GOSP, a.DATEDOC, a.DATE_ISHOD) as hospitalizat' +
            'ion_date'
          
            '    ,iif(ctv.CODEST is NULL, null, GREATEST(a.DATE_GOSP, a.DATED' +
            'OC, a.DATE_ISHOD)) as disease_outcome_date'
          '    ,a.DEATH_REASON as death_reason'
          '    ,a.is_pregnancy'
          '    ,IIF(1=1, NULL, a.TRIMESTER) TRIMESTER '
          '    ,case rp.SEX '
          '        when '#39#1052#1091#1078'.'#39' then '#39'1'#39
          '        when '#39#1046#1077#1085'.'#39' then '#39'2'#39
          '        else NULL'
          '    end as gender'
          'from'
          '    MIS_KSAMU.dbo.DOC_COVID a'
          
            '    join MIS_KSAMU.dbo.REF_LPU as l on l.ID_MO = a.MEDORG_LECH a' +
            'nd l.MO = a.MO'
          '    join MIS_KSAMU.dbo.REF_MKB as rm on rm.ID = a.MKB_OSN'
          
            '    join MIS_KSAMU.dbo.REF_PATIENTS rp on rp.ID_MO = a.PATIENT a' +
            'nd rp.MO = a.MO'
          
            '    left join MIS_KSAMU.dbo.REF_MKB as rmo on rmo.ID = a.MKB_OSL' +
            'OJ'
          
            '    left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE ctv on ctv.ID' +
            '_MO = a.ISHOD_ZAB and ctv.MO = a.MO'
          
            '    left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE flu on flu.ID' +
            '_MO = a.GRIPP_VAC_NSI'
          
            '    left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE vir on vir.ID' +
            '_MO = a.var_virus'
          'WHERE  '
          '    a.ID = :ID')
      end
      item
        Name = 'SelectPathology'
        SQL.Strings = (
          'select'
          '    a.TYPE_ZAB'
          '    ,rm.CODEST'
          'from'
          '    MIS_KSAMU.dbo.DOCTAB_COVID_SOP_ZAB a'
          '    join MIS_KSAMU.dbo.REF_MKB rm on rm.ID = a.MKB'
          'where'
          '    a.OWNER = :OWNER'
          '    and a.MO = :MO')
      end
      item
        Name = 'SelectExams'
        SQL.Strings = (
          '--SelectExams'
          'SELECT '
          '    a.UUID as local_id'
          '    ,a.DATE_MATERIAL   '
          '    ,a.DATEISSLED as exam_date'
          '    ,l.OID as mo'
          '    ,NULL AS diagnostic_material_date    '
          '    ,NULL AS diagnostic_material_mo'
          '    ,ctv.CODEST as diagnostic_material'
          '    ,NULL as diagnostic_material_detail    '
          '    ,TYP.CODEST EXAM_TYPE'
          '    ,RES.CODEST EXAM_RESULT'
          '    ,MET.CODEST EXAM_METHOD'
          '    ,NULL AS exam_method_detail    '
          '    ,NULL AS pathogen'
          
            '    ,IIF(TYP.CODEST = '#39'1'#39', RES.CODEST,  NULL) AS test_system_ser' +
            'ial'
          '    ,NULL AS etiology'
          'from'
          '    MIS_KSAMU.dbo.DOCTAB_COVID_LAB_ISSLED a'
          
            '    left join MIS_KSAMU.dbo.REF_LPU l on l.ID_MO = a.MO_ISSLED a' +
            'nd l.MO = a.MO'
          
            '    left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE ctv on ctv.ID' +
            '_MO = a.DIAGNOS_MATERIAL and ctv.MO = a.MO'
          
            '    left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE TYP on A.TYPE' +
            '_RESEARCH_NSI = TYP.ID'
          
            '    left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE MET on A.EXAM' +
            '_METHOD = MET.ID'
          
            '    left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE RES on A.RESU' +
            'LT_RESEARCH_NSI = RES.ID'
          'where'
          '    a.OWNER = :OWNER'
          '    and a.MO = :MO')
      end
      item
        Name = 'SelectDailyInfo'
        SQL.Strings = (
          '--SelectDailyInfo'
          'SELECT distinct '
          '    a.UUID as local_id'
          '    ,a.DATEIZM as daily_date'
          '    ,ctv.CODEST as disease_severity'
          '    ,a.SATURATION_LEVEL as saturation_level'
          '    ,a.IS_IVL as is_ivl'
          '    ,a.IS_ECMO as is_ecmo'
          '    ,a.IS_ANTIVIRUS_THREATMENT as is_antivirus_threatment'
          '    ,a.IS_ORIT'
          'from'
          '    MIS_KSAMU.dbo.DOCTAB_COVID_DAILY a'
          
            '    join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE ctv on ctv.ID_MO =' +
            ' a.DISEASE_SEVERITY and ctv.MO = a.MO'
          'where'
          '    a.OWNER = :OWNER'
          '    and a.MO = :MO'
          'ORDER BY a.DATEIZM ')
      end
      item
        Name = 'SelectArrivalInfo'
        SQL.Strings = (
          'select'
          '    a.DATE_PRIB as arrival_date'
          '    ,c.ID_NSI as arrival_from'
          '    ,ctv2.CODEST as transport_id'
          '    ,a.SRED_PERED_DOP as transport_detail'
          '    ,a.MESTO_ENTER as transport_in'
          '    ,a.MARCHRUT_RF as movement'
          'from'
          '    MIS_KSAMU.dbo.DOC_COVID a'
          
            '    join MIS_KSAMU.dbo.REF_COUNTRY c on c.ID_MO = a.COUNTER_OFF ' +
            'and c.MO = a.MO'
          
            '    join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE ctv2 ON ctv2.ID_MO' +
            ' = a.SRED_PERED and ctv2.MO = a.MO'
          'WHERE'
          '    a.ID = :ID')
      end
      item
        Name = 'SelectEpidContacts'
        SQL.Strings = (
          'select distinct'
          '    p.ID_MO as PATIENT'
          '    ,p.MO'
          '    ,p.UUID as local_id'
          '    ,p.FAM as firstname'
          '    ,p.IM as lastname'
          '    ,p.OT as patronymic'
          '    ,p.BIRTHDAY as birth_date'
          '    ,case p.SEX'
          '        when '#39#1052#1091#1078'.'#39' then 1'
          '        when '#39#1046#1077#1085'.'#39' then 2'
          '        else null'
          '    end as gender'
          '    ,IsNull(rc.ID_NSI, 171) as citizenship_country   '
          '    ,IsNull(p.TELSOT, p.TELDOM) as mobile_phone'
          '    ,ra.PRED as live_address_manual'
          'from'
          '    MIS_KSAMU.dbo.DOCTAB_COVID_EPID_CONTACT a'
          
            '    join MIS_KSAMU.dbo.REF_PATIENTS p on p.ID_MO = a.PATIENT and' +
            ' p.MO = a.MO'
          
            '    left join (select top 1 * from MIS_KSAMU.dbo.REG_PASSPORTS o' +
            'rder by DATEON desc) pp on pp.OWNER = p.ID_MO and pp.MO = p.MO'
          
            '    left join MIS_KSAMU.dbo.REF_COUNTRY rc on rc.ID_MO = pp.CITI' +
            'ZENSHIP and rc.MO = pp.MO'
          
            '    left join MIS_KSAMU.dbo.REG_ADDRESS ra on ra.OWNER = p.ID_MO' +
            ' and ra.MO = p.MO'
          
            '    left join MIS_KSAMU.dbo.REF_ADDRESSTYPE t on t.ID = ra.ADDRE' +
            'SSTYPE'
          'where'
          '    a.OWNER = :OWNER'
          '    and a.MO = :MO'
          '    and t.CODE = 2')
      end
      item
        Name = 'SetDocumentSended'
        SQL.Strings = (
          'select'
          '    ID,'
          '    DATEADD,'
          '    STATUS'
          'from'
          '    MIS_KSAMU.dbo.REG_COVID a'
          'where'
          '    a.ID = :ID')
      end
      item
        Name = 'SetDocumentExternalInfo'
        SQL.Strings = (
          'select'
          '    a.ID'
          '    ,a.OWNER'
          '    ,a.DATE_SEND'
          '    ,a.UIN'
          '    ,a.MESSAGE'
          'from'
          '    MIS_KSAMU.dbo.REG_EXTERNAL_COVID a'
          'where'
          '    a.OWNER = :OWNER')
      end
      item
        Name = 'SelectFinalClinicalDs'
        SQL.Strings = (
          'select'
          '    rctv.CODEST ds_clinfin_main,'
          '    a.IS_NOT_OSLOJ_DEATH is_ds_clinfin_hasnt_complication,'
          '    rm.CODEST ds_clinfin_complication,'
          '    a.IS_NOT_SOPUT is_ds_clinfin_hasnt_accompany,'
          '    rm1.CODEST ds_clinfin_accompany,'
          '    rm2.CODEST ds_clinfin_exreason'
          'from'
          '    MIS_KSAMU.dbo.DOC_COVID a'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE rctv ON rctv' +
            '.ID_MO=a.ISHOD_ZAB AND rctv.MO=a.MO'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm ON rm.ID=a.MKB_OSLOJ_DEA' +
            'TH'
          '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm1 ON rm1.ID=a.MKB_SOPUT'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm2 ON rm2.ID=a.MKB_PRICIN_' +
            'DEATH'
          'WHERE'
          '    a.ID = :ID AND a.MO=:MO')
      end
      item
        Name = 'SelectPathologicalDs'
        SQL.Strings = (
          'select'
          '    a.IS_FAILURE_PATOLOGO IS_psm_exam_refusing,'
          '    rm.CODEST ds_psmpre_main,'
          '    a.IS_NOT_OSLOJ_PATOLOGO IS_ds_psmpre_hasnt_complication,'
          '    rm1.CODEST ds_psmpre_complication,  '
          '    a.IS_NOT_SOPUT_PATOLOGO IS_ds_psmpre_hasnt_accompany,'
          '    rm2.CODEST ds_psmpre_accompany,'
          '    rm3.CODEST ds_psmfin_main,'
          '    a.IS_NOT_OSLOJ_ZAKLUCH IS_ds_psmfin_hasnt_complication,'
          '    rm4.CODEST ds_psmfin_complication,'
          '    a.IS_NOT_SOPUT_ZAKLUCH IS_ds_psmfin_hasnt_accompany,'
          '    rm5.CODEST ds_psmfin_accompany    '
          'from'
          '    MIS_KSAMU.dbo.DOC_COVID a'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm ON rm.ID=a.MKB_OSN_PATOL' +
            'OGO'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm1 ON rm1.ID=a.MKB_OSLOJ_P' +
            'ATOLOGO'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm2 ON rm2.ID=a.MKB_SOPUT_P' +
            'ATOLOGO'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm3 ON rm3.ID=a.MKB_OSN_ZAK' +
            'LUCH'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm4 ON rm4.ID=a.MKB_OSLOJ_Z' +
            'AKLUCH'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm5 ON rm5.ID=a.MKB_SOPUT_Z' +
            'AKLUCH'
          '    '
          'WHERE'
          '    a.ID = :ID AND a.MO=:MO')
      end
      item
        Name = 'SelectDeathCertificate'
        SQL.Strings = (
          'select'
          '    a.SERIA_SERTIFICATE certificate_series,'
          '    a.NUMBER_SERTIFICATE certificate_number, '
          '    a.VIDAN_DATE_SERTIFICATE certificate_date,'
          '    rm.CODEST deadly_disease,'
          '    rm1.CODEST pathological_condition,'
          '    rm2.CODEST original_cause,'
          '    rm3.CODEST external_cause,'
          '    a.IS_OTHER_CONDITION IS_no_other_important_conditions,'
          '    rm4.CODEST other_important_conditions '
          'from'
          '    MIS_KSAMU.dbo.DOC_COVID a'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.ref_mkb rm ON rm.ID=a.MKB_BOL_SERTI' +
            'FICATE'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm1 ON rm1.ID=a.MKB_PATOL_S' +
            'ERTIFICATE'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm2 ON rm2.ID=a.MKB_FIRST_C' +
            'AUSE'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm3 ON rm3.ID=a.MKB_EXTERNA' +
            'L_CAUSE'
          
            '    LEFT JOIN  MIS_KSAMU.dbo.REF_MKB rm4 ON rm4.ID=a.MKB_OTHER_C' +
            'ONDITION'
          'WHERE'
          '    a.ID = :ID AND a.MO=:MO')
      end
      item
        Name = 'SelectDsPsmpreFile'
        SQL.Strings = (
          'SELECT a.DOC_NAME, a.TYPEDOC, a.DOC'
          'FROM FileStorage.dbo.REG_ATTACHED_COVID_FILE a'
          'WHERE a.MO=:MO and a.OWNER=:OWNER and a.typedoc = 0'
          '')
      end
      item
        Name = 'SelectDsPsmfinFile'
        SQL.Strings = (
          'SELECT a.DOC_NAME, a.TYPEDOC, a.DOC'
          'FROM FileStorage.dbo.REG_ATTACHED_COVID_FILE a'
          'WHERE a.MO=:MO and a.OWNER=:OWNER and a.typedoc = 2')
      end
      item
        Name = 'SelectDeathCertificateFile'
        SQL.Strings = (
          'SELECT a.DOC_NAME, a.TYPEDOC, a.DOC'
          'FROM FileStorage.dbo.REG_ATTACHED_COVID_FILE a'
          'WHERE a.MO=:MO and a.OWNER=:OWNER and a.typedoc = 1')
      end
      item
        Name = 'UpdateDateDoc'
        SQL.Strings = (
          'select '
          '    a.ID'
          '    ,a.DATE_UPLOAD'
          'from'
          '    MIS_KSAMU.dbo.DOC_COVID a'
          'where'
          '    a.ID=:ID')
      end>
    Params = <>
    Macros = <>
    Left = 40
    Top = 56
  end
  object fdscrpt1: TFDScript
    SQLScripts = <
      item
        Name = 'AllVacs'
        SQL.Strings = (
          'SELECT TOP 100'
          '      a.ID,'
          '     rerv.STATUS,'
          '      --CVAC.CODEST VACCINE_ID,'
          '       GTINSOP.ID_NSI VACCINE,'
          '       A.NUMBER_ETAP,'
          '       A.GTIN, A.ISN, A.SERIA_VAC,'
          '      --GTINSOP.NAME_PRODUCER, GTINSOP.NAME_VAC_NSI,        '
          
            '       iif(SCEN.CODEST > 1, iif(A.MED_OTVOD_TYPES = '#39#1042#1088#1077#1084#1077#1085#1085#1099#1081#39',' +
            ' '#39'2'#39', iif(A.MED_OTVOD_TYPES = '#39#1055#1086#1089#1090#1086#1103#1085#1085#1099#1081#39', '#39'3'#39', null)), iif(SCE' +
            'N.CODEST is not null, '#39'1'#39', null)) DOPUSK_VAC,'
          
            '       iif(SCEN.CODEST > 1, iif(A.MED_OTVOD_TYPES = '#39#1042#1088#1077#1084#1077#1085#1085#1099#1081#39',' +
            ' '#39'2'#39', iif(A.MED_OTVOD_TYPES = '#39#1055#1086#1089#1090#1086#1103#1085#1085#1099#1081#39', '#39'3'#39', null)), iif(SCE' +
            'N.CODEST is not null, '#39'1'#39', null)) ADMISSION,'
          '       A.DATEPOST,        '
          
            '       PAR.OID_NSI MO_OID, iif(DEP.OID_NSI_POD is null, BRA.OID_' +
            'NSI, DEP.OID_NSI_POD) DEPART_OID,'
          
            '       VRACH.TITLE FIO_MEDPERSONAL, PERS.SNILS SNILS_MEDPERSONAL' +
            ','
          '       CAST(A.TEMPPAT AS VARCHAR) TEMPPAT,    '
          '       A.CHDD respiratory_rate, a.CHSS heart_rate,'
          
            '       iif(A.PATSOST > 0, '#39#1085#1077#1091#1076#1086#1074#1083#1077#1090#1074#1086#1088#1080#1090#1077#1083#1100#1085#1086#1077#39', '#39#1091#1076#1086#1074#1083#1077#1090#1074#1086#1088#1080#1090#1077 +
            #1083#1100#1085#1086#1077#39') PATIENT_SOST,'
          '       --'#1076#1072#1085#1085#1099#1077' '#1086' '#1087#1072#1094#1080#1077#1085#1090#1077
          '       rp.ID AS PERSON,'
          '       rp.SNILS, rp.FAM, rp.IM, rp.OT,       '
          '       iif(UPPER(LEFT(rp.SEX,3)) = '#39#1046#1045#1053#39', 2, 1) GENDER,'
          '       rp.BIRTHDAY,'
          '       1 AS citizenship,'
          '       NULL AS citizenship_country,'
          '       rctv.CODEST AS contraindication,      '
          '       NULL AS exacerbation,'
          '       NULL AS decompensation,'
          '       NULL AS complication,'
          '       NULL AS contraindication_mkb,'
          '       A.MED_OTVOD_DATE_S MEDOTVOD_START,'
          '       dmo.DATE_END MEDOTVOD_END,'
          
            '       iif(DATEDIFF(day,A.MED_OTVOD_DATE_S, dmo.DATE_END) > 30, ' +
            'A.MED_OTVOD_DATE_S, null) medical_commission_date,'
          '       '#39#1042'-111'#39' AS medical_commission_number'
          ''
          'from MIS_KSAMU.dbo.DOC_REGISTR_VAC A'
          
            'left join MIS_KSAMU.dbo.REF_VACCINE VAC on A.VACCINE = VAC.ID_MO' +
            ' AND A.MO = VAC.MO'
          
            '--left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE CVAC on VAC.REG' +
            'ISTR_VAC = CVAC.ID_MO AND VAC.MO = CVAC.MO'
          
            'left join MIS_KSAMU.dbo.REF_MEDPERSONAL VRACH on A.MEDPERSONAL =' +
            ' VRACH.ID_MO AND A.MO = VRACH.MO'
          
            'left join MIS_KSAMU.dbo.REF_PERSONAL PERS on VRACH.PERSONAL = PE' +
            'RS.ID_MO AND VRACH.MO = PERS.MO'
          
            'left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE SCEN on A.REGISTR' +
            '_VAC_SCENARIO = SCEN.ID_MO AND A.MO = SCEN.MO'
          'left join MIS_KSAMU.dbo.PARAMS_LPU par ON PAR.MO = a.MO'
          
            'left join MIS_KSAMU.dbo.REF_DEPARTMENTS DEP on VRACH.DEPARTMENT ' +
            '= DEP.ID_MO AND VRACH.MO = DEP.MO'
          
            'left join MIS_KSAMU.dbo.REF_BRANCHES BRA on DEP.BRANCH = BRA.ID_' +
            'MO AND DEP.MO = BRA.MO'
          
            'left join MIS_KSAMU.dbo.REF_VAC_GTIN_SOPOST GTINSOP on VAC.GTIN_' +
            'SPR = GTINSOP.ID_MO AND VAC.MO = GTINSOP.MO'
          'LEFT JOIN MIS_KSAMU.dbo.REF_PATIENTS rp ON A.PATIENT=rp.ID_MO'
          
            'LEFT JOIN (SELECT tmp.* FROM MIS_KSAMU.dbo.REG_EXTERNAL_REGISTR_' +
            'VAC tmp INNER JOIN '
          
            '            (SELECT OWNER, max(DATE_SEND) mins FROM MIS_KSAMU.db' +
            'o.REG_EXTERNAL_REGISTR_VAC GROUP BY OWNER) regext'
          
            '              ON regext.OWNER = tmp.OWNER AND regext.mins = tmp.' +
            'DATE_SEND) '
          '              rerv ON A.ID = rerv.OWNER   '
          
            'LEFT JOIN MIS_KSAMU.dbo.DOC_MED_OTVOD dmo ON A.MED_OTVOD = dmo.I' +
            'D_MO AND a.MO = dmo.MO'
          
            'LEFT JOIN MIS_KSAMU.dbo.REF_MED_OTVOD rmo ON dmo.MED_OTVOD = rmo' +
            '.ID_MO AND dmo.MO = rmo.MO'
          
            'LEFT JOIN MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE rctv ON rmo.REGIS' +
            'TR_VAC = rctv.ID_MO AND rctv.MO = rmo.MO'
          'WHERE (rerv.status IS NULL OR rerv.STATUS > 200)'
          ' AND a.ID NOT IN ('#39'8'#1082'gg'#1060#1080':4v'#8212'J'#1060#1103'R'#1049'Y'#39', '#39'+Y'#1083#1041'^'#1050'8'#1066's'#1047#1058'`'#1075#164'>'#1056#39')'
          '--AND a.ID = '#39#1046#1048'mh'#177'H'#1077'?Z'#1074#1086'qM'#1092#1087'L'#39
          '--AND'
          ' --rp.ID = '#39'"a+9'#1087#1067#1072'A'#1101#1051'Wc'#1086#1071'bt'#39
          '--AND rp.ID ='#39'~'#1025#1071#1096#1046#1053't'#1081'f'#1084#1064#1049#1080#1053#1118'6'#39
          '--rerv.STATUS = 200'
          'ORDER BY A.DATEDOC ASC')
      end
      item
        Name = 'SendDoc'
        SQL.Strings = (
          'SELECT'
          '  a.ID'
          ' ,a.OWNER'
          ' ,a.DATE_SEND'
          ' ,a.REGID'
          ' ,a.MESSAGE'
          ' ,a.DATE_LAST_EDIT'
          ' ,a.STATUS'
          ' ,a.PERSONID'
          'FROM'
          '   MIS_KSAMU.dbo.REG_EXTERNAL_REGISTR_VAC a'
          'WHERE '
          '   a.OWNER = :ID')
      end
      item
        Name = 'EditVacs'
        SQL.Strings = (
          'SELECT TOP 100'
          'a.ID,'
          'rerv.STATUS,'
          'rerv.REGID,'
          '--CVAC.CODEST VACCINE_ID,'
          '        GTINSOP.ID_NSI VACCINE,'
          '        A.NUMBER_ETAP,'
          '         A.GTIN, A.ISN, A.SERIA_VAC,'
          '        --GTINSOP.NAME_PRODUCER, GTINSOP.NAME_VAC_NSI,        '
          
            '       iif(SCEN.CODEST > 1, iif(A.MED_OTVOD_TYPES = '#39#1042#1088#1077#1084#1077#1085#1085#1099#1081#39',' +
            ' '#39'2'#39', iif(A.MED_OTVOD_TYPES = '#39#1055#1086#1089#1090#1086#1103#1085#1085#1099#1081#39', '#39'3'#39', null)), iif(SCE' +
            'N.CODEST is not null, '#39'1'#39', null)) DOPUSK_VAC,'
          
            '       iif(SCEN.CODEST > 1, iif(A.MED_OTVOD_TYPES = '#39#1042#1088#1077#1084#1077#1085#1085#1099#1081#39',' +
            ' '#39'2'#39', iif(A.MED_OTVOD_TYPES = '#39#1055#1086#1089#1090#1086#1103#1085#1085#1099#1081#39', '#39'3'#39', null)), iif(SCE' +
            'N.CODEST is not null, '#39'1'#39', null)) ADMISSION,'
          '       A.DATEPOST,              '
          
            '       PAR.OID_NSI MO_OID, iif(DEP.OID_NSI_POD is null, BRA.OID_' +
            'NSI, DEP.OID_NSI_POD) DEPART_OID,'
          
            '       VRACH.TITLE FIO_MEDPERSONAL, PERS.SNILS SNILS_MEDPERSONAL' +
            ','
          '       CAST(A.TEMPPAT AS VARCHAR) TEMPPAT,    '
          '       A.CHDD respiratory_rate, a.CHSS heart_rate,'
          
            '       iif(A.PATSOST > 0, '#39#1085#1077#1091#1076#1086#1074#1083#1077#1090#1074#1086#1088#1080#1090#1077#1083#1100#1085#1086#1077#39', '#39#1091#1076#1086#1074#1083#1077#1090#1074#1086#1088#1080#1090#1077 +
            #1083#1100#1085#1086#1077#39') PATIENT_SOST,'
          '       --'#1076#1072#1085#1085#1099#1077' '#1086' '#1087#1072#1094#1080#1077#1085#1090#1077
          '       rp.SNILS, rp.FAM, rp.IM, rp.OT,       '
          '       iif(UPPER(LEFT(rp.SEX,3)) = '#39#1046#1045#1053#39', 2, 1) GENDER,'
          '       rp.BIRTHDAY,'
          '       1 AS citizenship,'
          '       NULL AS citizenship_country    '
          ''
          'from MIS_KSAMU.dbo.DOC_REGISTR_VAC A'
          
            'left join MIS_KSAMU.dbo.REF_VACCINE VAC on A.VACCINE = VAC.ID_MO' +
            ' AND A.MO = VAC.MO'
          
            '--left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE CVAC on VAC.REG' +
            'ISTR_VAC = CVAC.ID_MO AND VAC.MO = CVAC.MO'
          
            'left join MIS_KSAMU.dbo.REF_MEDPERSONAL VRACH on A.MEDPERSONAL =' +
            ' VRACH.ID_MO AND A.MO = VRACH.MO'
          
            'left join MIS_KSAMU.dbo.REF_PERSONAL PERS on VRACH.PERSONAL = PE' +
            'RS.ID_MO AND VRACH.MO = PERS.MO'
          
            'left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE SCEN on A.REGISTR' +
            '_VAC_SCENARIO = SCEN.ID_MO AND A.MO = SCEN.MO'
          'left join MIS_KSAMU.dbo.PARAMS_LPU par ON PAR.MO = a.MO'
          
            'left join MIS_KSAMU.dbo.REF_DEPARTMENTS DEP on VRACH.DEPARTMENT ' +
            '= DEP.ID_MO AND VRACH.MO = DEP.MO'
          
            'left join MIS_KSAMU.dbo.REF_BRANCHES BRA on DEP.BRANCH = BRA.ID_' +
            'MO AND DEP.MO = BRA.MO'
          
            'left join MIS_KSAMU.dbo.REF_VAC_GTIN_SOPOST GTINSOP on VAC.GTIN_' +
            'SPR = GTINSOP.ID_MO AND VAC.MO = GTINSOP.MO'
          'LEFT JOIN MIS_KSAMU.dbo.REF_PATIENTS rp ON A.PATIENT=rp.ID_MO'
          
            'LEFT JOIN (SELECT tmp.* FROM MIS_KSAMU.dbo.REG_EXTERNAL_REGISTR_' +
            'VAC tmp INNER JOIN '
          
            '            (SELECT OWNER, max(DATE_SEND) mins FROM MIS_KSAMU.db' +
            'o.REG_EXTERNAL_REGISTR_VAC GROUP BY OWNER) regext'
          
            '              ON regext.OWNER = tmp.OWNER AND regext.mins = tmp.' +
            'DATE_SEND) '
          '              rerv ON A.ID = rerv.OWNER'
          
            'WHERE rerv.status IS NOT NULL AND rerv.STATUS < 200             ' +
            ' '
          'AND rerv.REGID <> '#39#39
          'ORDER BY rerv.DATE_SEND')
      end
      item
        Name = 'GetFirstEtap'
        SQL.Strings = (
          'SELECT TOP 1'
          '      a.ID,'
          '      rerv.STATUS,'
          '      --CVAC.CODEST VACCINE_ID,'
          '       GTINSOP.ID_NSI VACCINE,'
          '       A.NUMBER_ETAP,'
          '       A.GTIN, A.ISN, A.SERIA_VAC,'
          '      --GTINSOP.NAME_PRODUCER, GTINSOP.NAME_VAC_NSI,        '
          
            '       iif(SCEN.CODEST > 1, iif(A.MED_OTVOD_TYPES = '#39#1042#1088#1077#1084#1077#1085#1085#1099#1081#39',' +
            ' '#39'2'#39', iif(A.MED_OTVOD_TYPES = '#39#1055#1086#1089#1090#1086#1103#1085#1085#1099#1081#39', '#39'3'#39', null)), iif(SCE' +
            'N.CODEST is not null, '#39'1'#39', null)) DOPUSK_VAC,'
          
            '       iif(SCEN.CODEST > 1, iif(A.MED_OTVOD_TYPES = '#39#1042#1088#1077#1084#1077#1085#1085#1099#1081#39',' +
            ' '#39'2'#39', iif(A.MED_OTVOD_TYPES = '#39#1055#1086#1089#1090#1086#1103#1085#1085#1099#1081#39', '#39'3'#39', null)), iif(SCE' +
            'N.CODEST is not null, '#39'1'#39', null)) ADMISSION,'
          '       A.DATEPOST,              '
          
            '       PAR.OID_NSI MO_OID, iif(DEP.OID_NSI_POD is null, BRA.OID_' +
            'NSI, DEP.OID_NSI_POD) DEPART_OID,'
          
            '       VRACH.TITLE FIO_MEDPERSONAL, PERS.SNILS SNILS_MEDPERSONAL' +
            ','
          '       CAST(A.TEMPPAT AS VARCHAR) TEMPPAT,    '
          '       A.CHDD respiratory_rate, a.CHSS heart_rate,'
          
            '       iif(A.PATSOST > 0, '#39#1085#1077#1091#1076#1086#1074#1083#1077#1090#1074#1086#1088#1080#1090#1077#1083#1100#1085#1086#1077#39', '#39#1091#1076#1086#1074#1083#1077#1090#1074#1086#1088#1080#1090#1077 +
            #1083#1100#1085#1086#1077#39') PATIENT_SOST,'
          '       iif(UPPER(LEFT(rp.SEX,3)) = '#39#1046#1045#1053#39', 2, 1) GENDER'
          ''
          'from MIS_KSAMU.dbo.DOC_REGISTR_VAC A'
          
            'left join MIS_KSAMU.dbo.REF_VACCINE VAC on A.VACCINE = VAC.ID_MO' +
            ' AND A.MO = VAC.MO'
          
            '--left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE CVAC on VAC.REG' +
            'ISTR_VAC = CVAC.ID_MO AND VAC.MO = CVAC.MO'
          
            'left join MIS_KSAMU.dbo.REF_MEDPERSONAL VRACH on A.MEDPERSONAL =' +
            ' VRACH.ID_MO AND A.MO = VRACH.MO'
          
            'left join MIS_KSAMU.dbo.REF_PERSONAL PERS on VRACH.PERSONAL = PE' +
            'RS.ID_MO AND VRACH.MO = PERS.MO'
          
            'left join MIS_KSAMU.dbo.REF_CUSTOM_TABLE_VALUE SCEN on A.REGISTR' +
            '_VAC_SCENARIO = SCEN.ID_MO AND A.MO = SCEN.MO'
          'left join MIS_KSAMU.dbo.PARAMS_LPU par ON PAR.MO = a.MO'
          
            'left join MIS_KSAMU.dbo.REF_DEPARTMENTS DEP on VRACH.DEPARTMENT ' +
            '= DEP.ID_MO AND VRACH.MO = DEP.MO'
          
            'left join MIS_KSAMU.dbo.REF_BRANCHES BRA on DEP.BRANCH = BRA.ID_' +
            'MO AND DEP.MO = BRA.MO'
          
            'left join MIS_KSAMU.dbo.REF_VAC_GTIN_SOPOST GTINSOP on VAC.GTIN_' +
            'SPR = GTINSOP.ID_MO AND VAC.MO = GTINSOP.MO'
          'LEFT JOIN MIS_KSAMU.dbo.REF_PATIENTS rp ON A.PATIENT=rp.ID_MO'
          
            'LEFT JOIN (SELECT tmp.* FROM MIS_KSAMU.dbo.REG_EXTERNAL_REGISTR_' +
            'VAC tmp INNER JOIN '
          
            '            (SELECT OWNER, max(DATE_SEND) mins FROM MIS_KSAMU.db' +
            'o.REG_EXTERNAL_REGISTR_VAC GROUP BY OWNER) regext'
          
            '              ON regext.OWNER = tmp.OWNER AND regext.mins = tmp.' +
            'DATE_SEND) '
          '              rerv ON A.ID = rerv.OWNER'
          ''
          'WHERE a.NUMBER_ETAP = 1 '
          ' AND rp.ID = :ID'
          ' AND rerv.STATUS = 200')
      end>
    Params = <>
    Macros = <>
    Left = 176
    Top = 128
  end
end
