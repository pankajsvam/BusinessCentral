table 50203 "Quick Quote Worksheet Line"
{
    // version TOP010,230

    // TOP010 KT ABCSI Stock Status Quick Quote Screen 12082014
    //   - Temp table for Stock Status Quick Quote
    // 
    // TOP230 KT ABCSI CRP 2 Fixes 06162015
    //   - Modified the DecimalPlaces property and AutoFormatType property for all the custom fields with Quantity, Price and Amounts


    fields
    {
        field(2; "Sell-To Customer No."; Code[10])
        {
        }
        field(6; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(7; "Location Code"; Code[10])
        {
            TableRelation = Location.Code WHERE("Use As In-Transit" = CONST(false));
        }
        field(9; "Line No."; Integer)
        {
        }
        field(10; "Current Qty (Base)"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(11; Description; Text[50])
        {
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(5404; "Qty per Unit of Measure"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50002; "Last Quoted Unit Price"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(50003; "Last Quoted UOM"; Code[10])
        {
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(50004; "Last Quoted Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50005; "Current Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50006; "Current UOM"; Code[10])
        {
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(50007; "Last Unit Price"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(50008; "Last Price UOM"; Code[10])
        {
        }
        field(50009; "Last Price Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50013; "Last Price Date"; Date)
        {
        }
        field(50020; "Promotion Code"; Code[10])
        {
        }
        field(50026; "Lost Opportunity"; Boolean)
        {
        }
        field(50027; "Reason Code"; Code[10])
        {
            Description = 'TableRelation: "Reason Code" WHERE (Order Type=CONST(Stock Status))';
            TableRelation = "Reason Code";

            trigger OnValidate();
            var
                ReasonCode: Record "Reason Code";
            begin
            end;
        }
        field(50028; "Reason Code Comment"; Text[60])
        {
        }
        field(50100; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';

            trigger OnLookup();
            begin
                LookupShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Line No.")
        {
        }
        key(Key2; "Location Code", "Line No.", "Item No.", "Sell-To Customer No.")
        {
        }
        key(Key3; "Line No.", "Item No.", "Sell-To Customer No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit DimensionManagement;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin

        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
    end;
}

