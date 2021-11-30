codeunit 50200 "Codeunit5700EventSubscriber"
{

    trigger OnRun();
    begin
    end;

    var
        HasGotDivisionFilterUserSetup: Boolean;
        UserSetup: Record "User Setup";
        DivisionFilter: Text[250];
        HasGotMfrRepUserSetup: Boolean;
        MfrRepSalesFilter: Code[10];
        HasGotPriceBookUserSetup: Boolean;
        PriceBookFilter: Code[10];
        HasGotLocationFilterUserSetup: Boolean;
        LocationFilter: Code[20];
        HasGotICWHESetup: Boolean;
        ICLocationCode: Code[1024];

    procedure GetDivisionFilter(): Code[10];
    begin
        // <TPZ159>
        exit(GetDivisionFilter2(USERID));
        // </TPZ159>
    end;

    procedure GetMfrRepSalesFilter(): Code[20];
    begin
        // <TPZ159>
        exit(GetMfrRepSalesFilter2(USERID));
        // </TPZ159>
    end;

    procedure GetPriceBookFilter(): Code[10];
    begin
        // <TPZ159>
        exit(GetPriceBookFilter2(USERID));
        // </TPZ159>
    end;

    procedure GetLocationFilter(): Code[20];
    begin
        // <TPZ159>
        exit(GetLocationFilter2(USERID));
        // </TPZ159>
    end;

    procedure GetDivisionFilter2(UserCode: Code[50]): Code[10];
    begin
        // <TPZ159>
        if not HasGotDivisionFilterUserSetup then begin
            if UserSetup.GET(UserCode) and (UserCode <> '') then
                if UserSetup."Shortcut Dimension 5 Filter" <> '' then
                    DivisionFilter := UserSetup."Shortcut Dimension 5 Filter";
            HasGotDivisionFilterUserSetup := true;
        end;
        exit(DivisionFilter);
        // </TPZ159>
    end;

    procedure GetMfrRepSalesFilter2(UserCode: Code[50]): Code[20];
    begin
        // <TPZ159>
        if not HasGotMfrRepUserSetup then begin
            if UserSetup.GET(UserCode) and (UserCode <> '') then
                if UserSetup."Mfr. Rep. Filter" <> '' then
                    MfrRepSalesFilter := UserSetup."Mfr. Rep. Filter";
            HasGotMfrRepUserSetup := true;
        end;
        exit(MfrRepSalesFilter);
        // </TPZ159>
    end;

    procedure GetPriceBookFilter2(UserCode: Code[50]): Code[50];
    begin
        // <TPZ159>
        if not HasGotPriceBookUserSetup then begin
            if UserSetup.GET(UserCode) and (UserCode <> '') then
                if UserSetup."Price Book Filter" <> '' then
                    PriceBookFilter := UserSetup."Price Book Filter";
            HasGotPriceBookUserSetup := true;
        end;
        exit(PriceBookFilter);
        // </TPZ159>
    end;

    procedure GetLocationFilter2(UserCode: Code[50]): Code[50];
    begin
        // <TPZ159>
        if not HasGotLocationFilterUserSetup then begin
            if UserSetup.GET(UserCode) and (UserCode <> '') then
                if UserSetup."Location Filter" <> '' then
                    LocationFilter := UserSetup."Location Filter";
            HasGotLocationFilterUserSetup := true;
        end;
        exit(LocationFilter);
        // </TPZ159>
    end;

    procedure GetCommHdlgAdmin(UserCode: Code[50]): Boolean;
    begin
        // <TPZ858>
        if UserSetup.GET(UserCode) and (UserCode <> '') then
            if UserSetup."Comm. / Hdlg Admin." then
                exit(true);

        exit(false);
        // </TPZ858>
    end;

    procedure GetOSRCSRISRMfrRepAdmin(UserCode: Code[50]): Boolean;
    begin
        // <TPZ1015>
        if UserSetup.GET(UserCode) and (UserCode <> '') then
            if UserSetup."OSR/CSR/ISR/Mfr. Rep. Admin." then
                exit(true);

        exit(false);
        // </TPZ1015>
    end;

    procedure GetICLocationFilter(): Code[1024];
    begin
        //<TPZ1882>
        exit(GetICLocationFilter2(USERID));
        //</TPZ1882>
    end;

    procedure GetICLocationFilter2(Usercode: Code[100]): Code[1024];
    var
        WarehouseEmployee: Record "Warehouse Employee";
        I: Integer;
        BLANK: Code[10];
    begin
        //<TPZ1882>
        BLANK := '''' + '''';
        if not HasGotICWHESetup then begin
            WarehouseEmployee.RESET;
            WarehouseEmployee.SETRANGE("User ID", Usercode);
            if WarehouseEmployee.FINDSET and (Usercode <> '') then begin
                repeat
                    if WarehouseEmployee."Location Code" <> '' then begin
                        I := I + 1;
                        if I = 1 then
                            ICLocationCode := BLANK + '|' + WarehouseEmployee."Location Code"
                        else
                            ICLocationCode := ICLocationCode + '|' + WarehouseEmployee."Location Code";
                    end;
                until WarehouseEmployee.NEXT = 0;
                HasGotICWHESetup := true;
            end else
                ICLocationCode := BLANK;
        end;
        exit(ICLocationCode);
        //</TPZ1882>
    end;
}

