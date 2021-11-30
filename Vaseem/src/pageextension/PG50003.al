page 50205 "Division Code Selection"
{
    // version TOP010,020

    // TOP010 KT ABCSI Stock Status Quick Quote Screen 12082014
    //   - This page is for Division selection when opening Stock Status Quick Quote screen

    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field("Division Code"; CurrentDivisionCodeFilter)
            {
                TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DIVISION'));

                trigger OnValidate();
                begin
                    //TOP020 KT ABCSI Sales Orders by Division 02052015
                    if (CurrentDivisionCodeFilter <> '') then begin
                        GLSetup.GET;
                        if GLSetup."Shortcut Dimension 5 Code" <> '' then begin
                            if not DimVal.GET(GLSetup."Shortcut Dimension 5 Code", CurrentDivisionCodeFilter) then
                                ERROR(
                                  STRSUBSTNO(ab003,
                                    CurrentDivisionCodeFilter, GLSetup."Shortcut Dimension 5 Code"));
                        end else
                            ERROR(ab002, GLSetup.TABLECAPTION);
                    end;
                    //TOP020 KT ABCSI Sales Orders by Division 02052015
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        UserSetup.GET(USERID);
        if UserSetup."Shortcut Dimension 5 Code" <> '' then
            CurrentDivisionCodeFilter := UserSetup."Shortcut Dimension 5 Code";
    end;

    var
        CurrentDivisionCodeFilter: Code[20];
        DimMgt: Codeunit DimensionManagement;
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
        ab002: TextConst ENU = 'This Shortcut Dimension is not defined in the %1.', ESM = 'Este Shortcut de dimensión no está def. en el %1.', FRC = 'La dimension de ce raccourci n''est pas définie dans le %1.', ENC = 'This Shortcut Dimension is not defined in the %1.';
        ab003: TextConst ENU = '%1 is not an available %2 for that dimension.', ESM = '%1 no está disponible %2 para esa dimensión.', FRC = '%1 n''est pas un %2 disponible pour cette dimension.', ENC = '%1 is not an available %2 for that dimension.';

    procedure GetDivisionCodeValue(): Code[20];
    begin
        exit(CurrentDivisionCodeFilter);
    end;

    procedure GetErrorMsg();
    begin
        if CurrentDivisionCodeFilter = '' then
            ERROR('Please Select value for Division Code');
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin

        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        //TOP020 KT ABCSI Sales Orders by Division 02052015
        if (ShortcutDimCode <> '') then begin
            GLSetup.GET;
            if GLSetup."Shortcut Dimension 5 Code" <> '' then begin
                if not DimVal.GET(GLSetup."Shortcut Dimension 5 Code", ShortcutDimCode) then
                    ERROR(
                      STRSUBSTNO(ab003,
                        ShortcutDimCode, GLSetup."Shortcut Dimension 5 Code"));
            end else
                ERROR(ab002, GLSetup.TABLECAPTION);
        end;
        //TOP020 KT ABCSI Sales Orders by Division 02052015
    end;
}

