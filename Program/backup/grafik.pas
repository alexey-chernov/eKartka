unit grafik;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, DBGrids,
  ExtCtrls, StdCtrls, DateTimePicker;

type

  { TformGrafik }

  TformGrafik = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    DataSource1: TDataSource;
    DateTimePicker1: TDateTimePicker;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    SQLQuery_Reception: TSQLQuery;
    SQLQuery_Receptiondatereception: TDateField;
    SQLQuery_Receptiondoctorfullname: TStringField;
    SQLQuery_Receptionidd: TLongintField;
    SQLQuery_Receptionidp: TLongintField;
    SQLQuery_Receptionid_reception: TLongintField;
    SQLQuery_Receptionpatientfullname: TStringField;
    SQLQuery_Receptionstatereception: TStringField;
    SQLQuery_Receptiontimereception: TTimeField;
    SQLScript: TSQLScript;
    SQLTransaction1: TSQLTransaction;
    SQLTransaction_Script: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  formGrafik: TformGrafik;

implementation

{$R *.lfm}

{ TformGrafik }

uses main, addeditreception;

procedure TformGrafik.FormCreate(Sender: TObject);
var
  select_date : string;
begin
  DateTimePicker1.Date := now;
  DateTimeToString(select_date, 'dd/mm/yy', Now);
  SQLQuery_Reception.SQL.Clear;
  SQLQuery_Reception.SQL.Add('SELECT * FROM sel_reception(''' + select_date + ''');');
  SQLQuery_Reception.Active := True;
end;

procedure TformGrafik.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SQLQuery_Reception.Active := False;
end;

procedure TformGrafik.Button2Click(Sender: TObject);
var
  frmAddEditReception: TfrmAddEditReception;
  time_str, _DateStr : string;
begin
     frmAddEditReception := TfrmAddEditReception.Create(Application);
     frmAddEditReception.Caption := 'Створення нового запису на прийом';
     frmAddEditReception.CheckBoxSetStatus.Visible := False;
     DateTimePicker1.Date := Now;
     if frmAddEditReception.ShowModal = mrOk then
     begin
        time_str := IntToStr(frmAddEditReception.SpinEditEx1.Value) + ':' +
                    IntToStr(frmAddEditReception.SpinEditEx2.Value);
        DateTimeToString(_DateStr, 'dd/mm/yy', frmAddEditReception.DateTimePicker1.Date);
        with SQLScript.Script do
        begin
            Clear;
            Add('INSERT INTO public."Reception"(');
            Add('date, "time", idd, idp, state_reception)');
	    Add('VALUES (');
            Add('''' + _DateStr + ''',');
            Add('''' + time_str + ''',');
            Add(_idd + ',');
            Add(IntToStr(idpt) + ',');
            Add('1);');
        end;
//        SQLScript.Script.SaveToFile('Script.sql');
        try
           try
              SQLTransaction_Script.StartTransaction;
              SQLScript.Execute;
              SQLTransaction_Script.Commit;
           finally
                  MessageDlg('Новий запис на прийом успішно добавлено!', mtInformation, [mbOK], 0);
           end;
        except
              SQLTransaction_Script.Rollback;
        end;
     end;
     frmAddEditReception.Free;
     SQLQuery_Reception.Refresh;
end;

procedure TformGrafik.Button3Click(Sender: TObject);
var
  frmAddEditReception: TfrmAddEditReception;
  time_str, _DateStr, _idrp : string;
begin
     frmAddEditReception := TfrmAddEditReception.Create(Application);
     frmAddEditReception.Caption := 'Редагування запису на прийом';
     frmAddEditReception.CheckBoxSetStatus.Visible := True;
     _idrp := SQLQuery_Reception.FieldByName('Id_Reception').AsString;
     idpt := SQLQuery_Reception.FieldByName('IdP').AsInteger;
     frmAddEditReception.DBLookupComboBox1.KeyValue := idpt;
     frmAddEditReception.DateTimePicker1.Date := DateTimePicker1.Date;
     DateTimeToString(time_str, 'HH:mm', SQLQuery_Reception.FieldByName('TimeReception').AsDateTime);
     frmAddEditReception.SpinEditEx1.Value := StrToInt(copy(time_str, 0, 2));
     frmAddEditReception.SpinEditEx2.Value := StrToInt(copy(time_str, 4, length(time_str)));

     if frmAddEditReception.ShowModal = mrOk then
     begin
        time_str := IntToStr(frmAddEditReception.SpinEditEx1.Value) + ':' +
                    IntToStr(frmAddEditReception.SpinEditEx2.Value);
        DateTimeToString(_DateStr, 'dd/mm/yy', frmAddEditReception.DateTimePicker1.Date);
        with SQLScript.Script do
        begin
            Clear;
            Add('UPDATE public."Reception"');
            if frmAddEditReception.CheckBoxSetStatus.Checked then
                Add('SET date=''' + _DateStr + ''', "time"=''' + time_str + ''', idp=' + IntToStr(idpt) + ', state_reception=1')
            else
                Add('SET date=''' + _DateStr + ''', "time"=''' + time_str + ''', idp=' + IntToStr(idpt));
	    Add('WHERE "Id"=' + _idrp + ';');
        end;
//        SQLScript.Script.SaveToFile('Script.sql');
        try
           try
              SQLTransaction_Script.StartTransaction;
              SQLScript.Execute;
              SQLTransaction_Script.Commit;
           finally
                  MessageDlg('Дані запису на прийом успішно змінено!', mtInformation, [mbOK], 0);
           end;
        except
              SQLTransaction_Script.Rollback;
        end;
     end;
     frmAddEditReception.Free;
     SQLQuery_Reception.Refresh;
end;

procedure TformGrafik.Button4Click(Sender: TObject);
var
  _idrp : string;
begin
     _idrp := SQLQuery_Reception.FieldByName('Id_Reception').AsString;
     if MessageDlg('Ви дійсно бажаєте скасувати прийом для пацієнта ' + #13 +
                   SQLQuery_Reception.FieldByName('patientfullname').AsString + ' ?',
                   mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     begin
        with SQLScript.Script do
        begin
            Clear;
            Add('UPDATE public."Reception"');
            Add('SET state_reception=3');
	    Add('WHERE "Id"=' + _idrp + ';');
        end;
//        SQLScript.Script.SaveToFile('Script.sql');
        try
           try
              SQLTransaction_Script.StartTransaction;
              SQLScript.Execute;
              SQLTransaction_Script.Commit;
           finally
                  MessageDlg('Дані запису на прийом скасовано!', mtInformation, [mbOK], 0);
           end;
        except
              SQLTransaction_Script.Rollback;
        end;
     end;
     frmAddEditReception.Free;
     SQLQuery_Reception.Refresh;
end;

procedure TformGrafik.Button5Click(Sender: TObject);
var
  _idrp : string;
begin
     _idrp := SQLQuery_Reception.FieldByName('Id_Reception').AsString;
     if MessageDlg('Ви бажаєте завершити прийом для пацієнта ' + #13 +
                   SQLQuery_Reception.FieldByName('patientfullname').AsString + ' ?',
                   mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     begin
        with SQLScript.Script do
        begin
            Clear;
            Add('UPDATE public."Reception"');
            Add('SET state_reception=2');
	    Add('WHERE "Id"=' + _idrp + ';');
        end;
//        SQLScript.Script.SaveToFile('Script.sql');
        try
           try
              SQLTransaction_Script.StartTransaction;
              SQLScript.Execute;
              SQLTransaction_Script.Commit;
           finally
                  MessageDlg('Запис на прийом завершено!', mtInformation, [mbOK], 0);
           end;
        except
              SQLTransaction_Script.Rollback;
        end;
     end;
     frmAddEditReception.Free;
     SQLQuery_Reception.Refresh;
end;

procedure TformGrafik.Button1Click(Sender: TObject);
var
  select_date : string;
begin
  SQLQuery_Reception.Active := False;
  DateTimeToString(select_date, 'dd/mm/yy', DateTimePicker1.Date);
  SQLQuery_Reception.SQL.Clear;
  SQLQuery_Reception.SQL.Add('SELECT * FROM sel_reception(''' + select_date + ''');');
  SQLQuery_Reception.Active := True;
end;

end.

