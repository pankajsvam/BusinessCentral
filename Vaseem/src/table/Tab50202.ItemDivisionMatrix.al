table 50202 "Item Division Matrix"
{
    // version TOP130

    // TOP130 KT ABCSI Item List Sort and Filter by Status 04102015
    //   - Created this Page as part of this SMT


    fields
    {
        field(1; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';

            trigger OnLookup();
            begin
                LookupShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(2; "Divisional Filter"; Text[100])
        {

            trigger OnValidate();
            begin
                DimVal.SETFILTER(Code, "Divisional Filter");
            end;
        }
    }

    keys
    {
        key(Key1; "Shortcut Dimension 5 Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit DimensionManagement;
        DimVal: Record "Dimension Value";

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin

        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
    end;
}

